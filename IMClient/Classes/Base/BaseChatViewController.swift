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
    fileprivate var socket      : WebSocket!
    fileprivate var url         : String = baseURL_socket
    fileprivate var connected   : Bool   = false
    fileprivate var registered  : Bool   = false
    fileprivate lazy var user   : User = {
        return getUser()
    }()
    fileprivate lazy var target : User = {
        return getTarget()
    }()
    fileprivate lazy var dialogtype : DialogType = {
        return getDialogType()
    }()
    fileprivate var dialogid    : String?
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
    }
    
    fileprivate func baseSetupSocket() {
        socket = WebSocket(url: URL(string: url)!)
        socket.delegate = self
        socket.connect()
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
        if let data = Mapper<BaseResult>().map(JSONString: text),
            data.result.code.valid(),
            let dataDict = data.dataDict,
            let message = ChatMessage(map: Map(mappingType: .fromJSON, JSON: dataDict)) {
            if let cmd = message.cmd {
                switch cmd {            //命令判断
                case .register:
                    registered = true
                case .chat:             //发送消息
                    if user.id! == message.sender! {
                        dialogid = message.dialogid
                        self.appendMessage(user: user,
                                           message: message,
                                           issender: true,
                                           status: .success,
                                           update: true)
                    }
                }
            } else {                    //接收消息
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
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        
    }
}


//MARK: - IMUIInputViewDelegate + IMUICustomInputViewDelegate
extension BaseChatViewController: IMUIInputViewDelegate, IMUIMessageMessageCollectionViewDelegate {
    
    //MARK: - 文本消息
    func sendTextMessage(_ messageText: String) {
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
            message.body = messageText
            if connected, let data = message.toJSONString() {
                socket.write(string: data)
            }
            self.appendMessage(user: user, message: message, issender: true, status: .sending)
        }
    }
}

//MARK: - 消息业务
extension BaseChatViewController {
    
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
                                     status: status)
        }
        if update {
            chatView.updateMessage(with: cmessage)
        } else {
            chatView.appendMessage(with: cmessage)
        }
    }
}

