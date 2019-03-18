//
//  BaseChatSession.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/17.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import Starscream
import RxCocoa
import RxSwift
import ObjectMapper

class BaseChatSession {
    
    //MARK: - 声明区域
    public let socket: WebSocket
        = WebSocket(url: URL(string: baseURL_socket)!)      //网络通讯
    private(set) var connected: Bool = false                //连接状态
    private(set) var registered: Bool = false               //注册状态
    open var block_registered: (() -> Void)?                //注册成功
    func valid() -> Bool { return connected && registered } //状态判断
    
    //MARK: - 单例模式
    static let shared = BaseChatSession()
    private init() {
        socket.connect()
        baseBindRx()
    }
    
    //MARK: - 私有成员
    fileprivate let disposeBag = DisposeBag()
}

//MARK: - 初始化
extension BaseChatSession {
    
    fileprivate func baseBindRx() {
        socket.rx.response.subscribe(onNext: { [unowned self] response in
            switch response {
            case .connected:
                self.websocketDidConnect()
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

//MARK: - WebSocket Event
extension BaseChatSession {
    
    fileprivate func websocketDidConnect() {
        self.connected = true
        //客户端注册
        var message = ChatMessage()
        message.sender = Environment.user?.id
        message.cmd = .register
        message.tokened()
        if let data = message.toJSONString() {
            socket.write(string: data)
        }
    }
    
    fileprivate func websocketDidDisconnect(error: Error?) {
        self.connected = false
    }
    
    fileprivate func websocketDidReceiveMessage(text: String) {
        guard let data = Mapper<BaseResult>().map(JSONString: text),
            let cmd = data.cmd else { return }
        if data.result.code.valid() {
            switch cmd {
            case .register:
                registered = true
                self.block_registered?()
            default:
                break
            }
        }
    }
}

