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
import RxCocoa
import RxSwift
import Photos

class BaseChatViewController: BaseViewController {
    
    //MARK: - 声明成员
    open lazy var chatView: IMUIMessageCollectionView = { //聊天视图
        return IMUIMessageCollectionView()
    }()
    open lazy var inputBar: IMUIInputView = {             //输入视图
        return IMUIInputView()
    }()
    
    func getUser() -> User {
        return Environment.user ?? User()
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
        baseBindRx()
    }
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    //MARK: - 私有成员
    fileprivate var disposeBag  : DisposeBag = DisposeBag()
    fileprivate var socket      : WebSocket {               //通讯对象
        return BaseChatSession.shared.socket
    }
    fileprivate var pageIndex   : Int    = 1                //页面索引
    fileprivate var pageLoading : Bool   = false            //页面加载
    fileprivate var pageEnded   : Bool   = false            //页面结束
    fileprivate lazy var user   : User = {                  //用户对象
        return getUser()
    }()
    fileprivate lazy var target : User = {                  //目标对象
        return getTarget()
    }()
    fileprivate var dialogid    : String?                   //会话标识
    fileprivate lazy var dialogtype : DialogType = {        //会话类型
        return getDialogType()
    }()
    fileprivate var valid: Bool {                           //连接状态
        return BaseChatSession.shared.valid()
    }
    fileprivate var imageMessages: [String: ChatMessage] = [:] //图片消息
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
    }
    
    fileprivate func baseSetupSocket() {
        dialogid = getDialogId()
        if valid { self.websocketDidRegister() }
        BaseChatSession.shared.block_registered = { [unowned self] in
            self.websocketDidRegister()
        }
    }
    
    fileprivate func baseBindRx() {
        socket.rx.response.subscribe(onNext: { [unowned self] response in
            switch response {
            case .disconnected(let error):
                self.websocketDidDisconnect(error: error)
            case .message(let text):
                self.websocketDidReceiveMessage(text: text)
            default:
                break
            }
        })
        .disposed(by: disposeBag)
    }
}

//MARK: - Refresh Handler
extension BaseChatViewController {
    
    fileprivate func refreshHandler() {
        guard !self.pageEnded else {
            refreshNoMore()
            return
        }
        guard valid, !self.pageLoading else { return }
        self.pageLoading = true
        self.sendMessage(pageindex: pageIndex)
    }
    
    fileprivate func refreshEnded() {
        if pageLoading {
            pageEnded = true
            pageLoading = false
            refreshNoMore()
        }
    }
    
    fileprivate func refreshNoMore() {
        STHud.showText(text: "没有更多数据")
        self.chatView.messageCollectionView.switchRefreshHeader(to: .normal(.none, 0.5))
    }
}

//MARK: - WebSocket Event
extension BaseChatViewController {
    
    func websocketDidRegister() {
        refreshHandler()
    }
    
    func websocketDidDisconnect(error: Error?) {
        refreshEnded()
    }
    
    func websocketDidReceiveMessage(text: String) {
        guard let data = Mapper<BaseResult>().map(JSONString: text),
            let cmd = data.cmd else { return }
        let valid = data.result.code.valid()
        if !valid {                     //异常处理
            switch data.result.code {
            case .dialogNotExists:      //消息列表获取异常, 会话不存在
                refreshEnded()
            default:                    //其它异常, 暂不处理
                refreshEnded()
            }
            return
        }
        switch cmd {                    //命令判断
        case .chat:                     //发送结果
            if let dataDict = data.dataDict,
                let message = ChatMessage(map: Map(mappingType: .fromJSON, JSON: dataDict)) {
                if user.id! == message.sender! {
                    dialogid = message.dialogid
                    self.appendMessage(user: user,
                                       message: message,
                                       issender: true,
                                       status: .success,
                                       type_append: .update)
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
                                self.appendMessage(user: self.user, message: message, issender: true, status: .success, type_append: .insert)
                            }
                            if self.user.id! == message.receiver! {
                                self.appendMessage(user: self.target, message: message, issender: false, status: .success, type_append: .insert)
                            }
                        }
                        chatView.messageCollectionView.switchRefreshHeader(to: .normal(.success, 0.5))
                    }
                } else {
                    refreshEnded()
                }
                pageIndex += 1
                pageLoading = false     //页面状态
            } else {
                refreshEnded()
            }
        default:
            break
        }
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
        message.tokened()
        if valid, let data = message.toJSONString() {
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
            message.tokened()
            if valid, let data = message.toJSONString() {
                socket.write(string: data)
            }
            self.appendMessage(user: user, message: message, issender: true, status: .sending)
        }
    }
    
    func sendMessage(url: URL) {
        var message = ChatMessage()
        message.cmd = .chat
        message.sender = self.user.id
        message.receiver = self.target.id
        message.dialogid = self.dialogid
        message.dialogtype = .single
        message._id = "\(Date.timeid())"
        message.type = .image
        message.body = url.absoluteString
        message.tokened()
        self.imageMessages[message._id!] = message
        self.upload_image(msgid: message._id!, url: url)
        self.appendMessage(user: self.user, message: message, issender: true, status: .sending)
    }
    
    func appendMessage(user: User,
                       message: ChatMessage,
                       issender: Bool,
                       status: IMUIMessageStatus,
                       type_append: MessageAppendType = .append) {
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
        case .image:
            cmessage = BaseChatModel(msgId: msgId,
                                     imageUrl: type_append == .update ? message._body!:body,
                                     fromUser: cuser,
                                     isOutGoing: issender,
                                     date: message.createtime ?? Date(),
                                     status: status)
        }
        switch type_append {
        case .append:
            chatView.appendMessage(with: cmessage)
        case .update:
            chatView.updateMessage(with: cmessage)
        case .insert:
            chatView.insertMessage(with: cmessage)
        }
    }
}

//MARK: - 文件上传
extension BaseChatViewController {
    
    fileprivate func upload_image(msgid: String, url: URL) {
        FileService.instance.upload_chat_image(msgid: msgid, url: url).asObservable()
            .subscribe(onNext: { [unowned self] response in
                let data = response.0
                let result = response.1
                if result.code.valid(),
                    let _ = data,
                    var message = self.imageMessages[data!._id!] {
                    message._body = message.body
                    message.body = data!.body
                    if let data = message.toJSONString() {
                        self.socket.write(string: data)
                    }
                }
            })
            .disposed(by: self.disposeBag)
    }
}

//MARK: - IMUIInputViewDelegate + IMUICustomInputViewDelegate
extension BaseChatViewController: IMUIInputViewDelegate, IMUIMessageMessageCollectionViewDelegate {
    
    //MARK: - 文本消息
    func sendTextMessage(_ messageText: String) {
        self.sendMessage(text: messageText)
    }
    
    //MARK: - 图片消息
    func didSeletedGallery(AssetArr: [PHAsset]) {
        for asset in AssetArr {
            asset.getURL(handler: { [unowned self] _url in
                if let url = _url {
                    self.sendMessage(url: url)
                }
            })
        }
    }
    
    //MARK: - 隐藏弹出
    func messageCollectionView(_ willBeginDragging: UICollectionView) {
        DispatchQueue.main.async {
            self.inputBar.hideFeatureView()
        }
    }
}

//MARK: - 添加类型, 添加, 更新, 插入
enum MessageAppendType {
    
    case append, update, insert
}


