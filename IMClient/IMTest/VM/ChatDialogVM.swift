//
//  ChatDialogVM.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/18.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Starscream
import RxCocoa
import RxSwift
import RxDataSources
import ObjectMapper

struct ChatDialogVMInput {
    var refreshTap          : PublishSubject<Bool>
    var signoutTap          : PublishSubject<Void>
}
struct ChatDialogVMOutput {
    var sections            : Driver<[ChatDialogSectionModel]>?
    var refreshResult       : PublishSubject<RefreshStatus>
    var signoutResult       : PublishSubject<ResultType>
    var registered          : PublishSubject<Void>
}
class ChatDialogVM {
    
    //MARK: - 私有成员
    fileprivate struct Model {
        var page: Int
        var disposeBag: DisposeBag
        var models: BehaviorRelay<[ChatDialog_Message]>
    }
    fileprivate var model: Model!
    fileprivate var userService = UserService.instance
    fileprivate var reload: Bool = true
    fileprivate var user: User = {
        return Environment.user ?? User()
    }()
    fileprivate var socket: WebSocket {
        return BaseChatSession.shared.socket
    }
    fileprivate var valid: Bool {
        return BaseChatSession.shared.valid()
    }
    
    //MARK: - Inputs
    var inputs: ChatDialogVMInput = {
        return ChatDialogVMInput(refreshTap: PublishSubject<Bool>(),
                                 signoutTap: PublishSubject<Void>())
    }()
    
    //MARK: - Outputs
    var outputs: ChatDialogVMOutput = {
        return ChatDialogVMOutput(sections: nil,
                                  refreshResult: PublishSubject<RefreshStatus>(),
                                  signoutResult: PublishSubject<ResultType>(),
                                  registered: PublishSubject<Void>())
    }()
    
    init(disposeBag: DisposeBag) {
        self.model = Model(page: 0, disposeBag: disposeBag, models: BehaviorRelay<[ChatDialog_Message]>(value: []))
        //Rx
        self.outputs.sections = self.model.models.asObservable()
            .map{ models in
                return [ChatDialogSectionModel(items: models)]
            }
            .asDriver(onErrorJustReturn: [])
        if valid { self.websocketDidRegister() }
        BaseChatSession.shared.block_registered = { [unowned self] in
            self.websocketDidRegister()
        }
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
        .disposed(by: model.disposeBag)
        self.inputs.refreshTap.asObserver()
            .subscribe(onNext: { [unowned self] reload in
                self.reload = reload
                self.sendMessage()
            })
            .disposed(by: model.disposeBag)
        self.inputs.signoutTap.asObserver()
            .subscribe(onNext: {
                self.signout()
            })
            .disposed(by: model.disposeBag)
    }
}

//MARK: - 数据业务
extension ChatDialogVM {
    
    fileprivate func sendMessage() {
        guard valid else { return }
        if reload { model.page = 1 } else { model.page += 1 }
        var message = ChatMessage()
        message.cmd = .list_dialog
        message.sender = user.id
        message.pageindex = model.page
        message.tokened()
        if valid, let data = message.toJSONString() {
            socket.write(string: data)
        }
    }
    
    fileprivate func signout() {
        Environment.clearUser()
        self.userService.signout().asObservable()
            .subscribe(onNext: { result in
                self.outputs.signoutResult.onNext(result)
            })
            .disposed(by: model.disposeBag)
    }
}

//MARK: - WebSocket + Event
extension ChatDialogVM {
    
    fileprivate func refreshEnded() {
        outputs.refreshResult.onNext(.end)
        outputs.refreshResult.onNext(.end_foot)
    }
    
    fileprivate func websocketDidRegister() {
        outputs.registered.onNext(())
        sendMessage()
    }
    
    fileprivate func websocketDidDisconnect(error: Error?) {
        refreshEnded()
    }
    
    fileprivate func websocketDidReceiveMessage(text: String) {
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
        case .list_dialog:              //会话列表
            if let dataDicts = data.dataDicts {
                let messages: [ChatDialog_Message] = [ChatDialog_Message](JSONArray: dataDicts)
                if reload {
                    if messages.count > 0 {
                        self.model.models.accept(messages)
                        //结束刷新
                        outputs.refreshResult.onNext(.end)
                    } else {
                        outputs.refreshResult.onNext(.nodata)
                    }
                } else {
                    if messages.count > 0 {
                        //结束刷新
                        outputs.refreshResult.onNext(.end_foot)
                        model.models.accept(self.model.models.value + messages)
                    } else {
                        //没有更多数据
                        self.outputs.refreshResult.onNext(.nodata_foot)
                    }
                }
            } else {
                refreshEnded()
            }
        default:
            break
        }
    }
}

public struct ChatDialogSectionModel {
    public var items: [ChatDialog_Message]
}

extension ChatDialogSectionModel: SectionModelType {
    public typealias item = ChatDialog_Message
    
    public init(original: ChatDialogSectionModel, items: [ChatDialogSectionModel.item]) {
        self = original
        self.items = items
    }
}
