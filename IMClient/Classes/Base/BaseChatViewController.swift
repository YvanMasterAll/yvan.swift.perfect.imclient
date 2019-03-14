//
//  BaseChatViewController.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/10.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import SnapKit
import Starscream
import ObjectMapper

class BaseChatViewController: BaseViewController {
    
    //MARK: - 声明成员
    open lazy var chatView: IMUIMessageCollectionView = { //聊天视图
        return IMUIMessageCollectionView()
    }()
    open lazy var inputBar: IMUIInputView = {             //输入视图
        return IMUIInputView()
    }()
    
    func getUser() -> User {
        //yTest
        var user = User()
        user.id = 4
        user.nickname = "yi002"
        user.avatar = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1534926548887&di=f107f4f8bd50fada6c5770ef27535277&imgtype=0&src=http%3A%2F%2Fpic.58pic.com%2F58pic%2F11%2F67%2F23%2F69i58PICP37.jpg"
        return user
    }
    
    func getTarget() -> User {
        return User()
    }
    
    func getDialogType() -> DialogType {
        return .single
    }
    
    func getDialogId() -> String? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetupUI()
        baseSetupSocket()
    }
    
    deinit {
        socket.disconnect()
        print("deinit: \(type(of: self))")
    }
    
    //MARK: - 私有成员
    fileprivate var socket      : WebSocket!                //通讯对象
    fileprivate var url         : String = baseURL_socket   //通讯地址
    fileprivate var connected   : Bool   = false            //通讯连接
    fileprivate var registered  : Bool   = false            //通讯注册
    fileprivate var pageIndex   : Int    = 1                //页面索引
    fileprivate var pageLoading : Bool   = false            //页面加载
    fileprivate var pageEnded   : Bool   = false            //页面结束
    fileprivate lazy var user   : User = {                  //用户对象
        return getUser()
    }()
    fileprivate lazy var target : User = {                  //目标对象
        return getTarget()
    }()
    fileprivate lazy var dialogtype : DialogType = {        //会话类型
        return getDialogType()
    }()
    fileprivate var dialogid    : String?                   //会话标识
}

//MARK: - 初始化
extension BaseChatViewController {
    
    fileprivate func baseSetupUI() {
        self.view.addSubview(chatView)
        self.view.addSubview(inputBar)
        chatView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.inputBar.snp.top)
        }
        inputBar.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        chatView.delegate = self
        inputBar.delegate = self
        //Refresh Header
        self.chatView.messageCollectionView.configRefreshHeader(with: BaseRefreshHeader(), container: self) { [weak self] () -> Void in
            self?.refreshHandler()
        }
        //Refresh When Loaded
        self.chatView.messageCollectionView.switchRefreshHeader(to: .refreshing)
    }
    
    fileprivate func baseSetupSocket() {
        dialogid = getDialogId()
        socket = WebSocket(url: URL(string: url)!)
        socket.delegate = self
        socket.connect()
    }
}

//MARK: - Refresh Handler
extension BaseChatViewController {
    
    fileprivate func refreshHandler() {
        guard !self.pageEnded else {
            self.chatView.messageCollectionView.switchRefreshHeader(to: .removed)
            return
        }
        guard !self.pageLoading, connected else { return }
        self.pageLoading = true
        self.sendMessage(pageindex: pageIndex)
    }
    
    fileprivate func endRefresh() {
        if pageLoading {
            pageEnded = true
            pageLoading = false
            chatView.messageCollectionView.switchRefreshHeader(to: .removed)
        }
    }
}

//MARK: - WebSocketDelegate
extension BaseChatViewController: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        self.connected = true
        //客户端注册
        var message = ChatMessage()
        message.sender = user.id!
        message.cmd = .register
        if let data = message.toJSONString() {
            socket.write(string: data)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.connected = false
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let data = Mapper<BaseResult>().map(JSONString: text),
        let cmd = data.cmd else { return }
        let valid = data.result.code.valid()
        if !valid {                     //异常处理
            switch data.result.code {
            case .dialogNotExists:      //消息列表获取异常, 会话不存在
                endRefresh()
            default:                    //其它异常, 暂不处理
                endRefresh()
            }
            return
        }
        switch cmd {                    //命令判断
        case .register:                 //通讯注册
            registered = true
        case .chat:                     //发送结果
            if let dataDict = data.dataDict,
                let message = ChatMessage(map: Map(mappingType: .fromJSON, JSON: dataDict)) {
                if user.id! == message.sender! {
                    dialogid = message.dialogid
                    self.appendMessage(user: user,
                                       message: message,
                                       issender: true,
                                       status: .success,
                                       update: true)
                }
            }
        case .receive:                  //消息接收
            if let dataDict = data.dataDict,
                let message = ChatMessage(map: Map(mappingType: .fromJSON, JSON: dataDict)) {
                switch dialogtype {
                case .single:
                    if user.id! == message.receiver {
                        dialogid = message.dialogid
                        var _message = message
                        _message._id = "\(Date.timeid())"
                        self.appendMessage(user: target,
                                           message: _message,
                                           issender: false,
                                           status: .success)
                    }
                }
            }
        case .list:                     //消息列表
            if let dataDicts = data.dataDicts, pageLoading {
                let messages: [ChatMessage] = [ChatMessage](JSONArray: dataDicts)
                if messages.count > 0 {
                    switch dialogtype {
                    case .single:
                        messages.forEach { [unowned self] data in
                            var message = data
                            message._id = "\(Date.timeid())"
                            if self.dialogid == nil {
                                self.dialogid = message.dialogid
                            }
                            if self.user.id! == message.sender! {
                                self.appendMessage(user: self.user, message: message, issender: true, status: .success)
                            }
                            if self.user.id! == message.receiver! {
                                self.appendMessage(user: self.target, message: message, issender: false, status: .success)
                            }
                        }
                        chatView.messageCollectionView.switchRefreshHeader(to: .normal(.success, 0.5))
                    }
                } else {
                    endRefresh()
                }
                pageIndex += 1
                pageLoading = false     //页面状态
            } else {
                endRefresh()
            }
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}

//MARK: - 消息业务
extension BaseChatViewController {
    
    func sendMessage(pageindex: Int) {
        var message = ChatMessage()
        message.cmd = .list
        message.sender = user.id
        message.receiver = target.id
        message.dialogtype = dialogtype
        message.dialogid = dialogid
        message.pageindex = pageIndex
        if connected, let data = message.toJSONString() {
            socket.write(string: data)
        }
    }
    
    func sendMessage(text: String) {
        switch dialogtype {
        case .single:
            var message = ChatMessage()
            message.cmd = .chat
            message.sender = user.id
            message.receiver = target.id
            message.dialogid = dialogid
            message.dialogtype = .single
            message._id = "\(Date.timeid())"
            message.type = .text
            message.body = text
            if connected, let data = message.toJSONString() {
                socket.write(string: data)
            }
            self.appendMessage(user: user, message: message, issender: true, status: .sending)
        }
    }
    
    func appendMessage(user: User,
                       message: ChatMessage,
                       issender: Bool,
                       status: IMUIMessageStatus,
                       update: Bool = false) {
        guard let id = user.id,
            let name = user.nickname,
            let avatar = user.avatar,
            let msgId = message._id,
            let body = message.body,
            let type = message.type else { return }
        let cuser = ChatUser(id: id, name: name, avatar: avatar)
        var cmessage: BaseChatModel!
        switch type {
        case .text:
            cmessage = BaseChatModel(msgId: msgId,
                                     text: body,
                                     fromUser: cuser,
                                     isOutGoing: issender,
                                     date: message.createtime ?? Date(),
                                     status: status)
        }
        if update {
            chatView.updateMessage(with: cmessage)
        } else {
            chatView.appendMessage(with: cmessage)
        }
    }
}

//MARK: - IMUIInputViewDelegate + IMUICustomInputViewDelegate
extension BaseChatViewController: IMUIInputViewDelegate, IMUIMessageMessageCollectionViewDelegate {
    
    //MARK: - 文本消息
    func sendTextMessage(_ messageText: String) {
        self.sendMessage(text: messageText)
    }
}
