//
//  ChatFindVM.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources

struct ChatFindVMInput {
    var refreshTap          : PublishSubject<Bool>
}
struct ChatFindVMOutput {
    var sections            : Driver<[ChatFindSectionModel]>?
    var refreshResult       : PublishSubject<RefreshStatus>
}
class ChatFindVM {
    
    //MARK: - 私有成员
    fileprivate struct Model {
        var page: Int
        var disposeBag: DisposeBag
        var models: BehaviorRelay<[User]>
    }
    fileprivate var model: Model!
    fileprivate var service = FindService.instance
    
    //MARK: - Inputs
    var inputs: ChatFindVMInput = {
        return ChatFindVMInput(refreshTap: PublishSubject<Bool>())
    }()
    
    //MARK: - Outputs
    var outputs: ChatFindVMOutput = {
        return ChatFindVMOutput(sections: nil, refreshResult: PublishSubject<RefreshStatus>())
    }()
    
    init(disposeBag: DisposeBag) {
        self.model = Model(page: 0, disposeBag: disposeBag, models: BehaviorRelay<[User]>(value: []))
        //Rx
        self.outputs.sections = self.model.models.asObservable()
            .map{ models in
                return [ChatFindSectionModel(items: models)]
            }
            .asDriver(onErrorJustReturn: [])
        self.inputs.refreshTap.asObserver()
            .subscribe(onNext: { reload in
                self.find_user(reload: reload)
            })
            .disposed(by: model.disposeBag)
    }
}

//MARK: - 数据业务
extension ChatFindVM {
    
    //MARK: - 发现用户
    fileprivate func find_user(reload: Bool) {
        if reload {
            self.model.page = 1
            self.outputs.refreshResult.onNext(.end_foot)
            //拉取数据
            self.service.find_user(page: self.model.page)
                .subscribe(onNext: { response in
                    let data = response.0
                    let result = response.1
                    switch result.code {
                    case .success:
                        if data.count > 0 {
                            self.model.models.accept(data)
                            //结束刷新
                            self.outputs.refreshResult.onNext(.end)
                        } else {
                            //没有数据
                            self.outputs.refreshResult.onNext(.nodata)
                        }
                        break
                    default:
                        //请求错误
                        self.outputs.refreshResult.onNext(.nonet)
                        break
                    }
                })
                .disposed(by: self.model.disposeBag)
        } else {
            self.model.page += 1
            //拉取数据
            self.service.find_user(page: model.page)
                .subscribe(onNext: { response in
                    let data = response.0
                    let result = response.1
                    switch result.code {
                    case .success:
                        if data.count > 0 {
                            //结束刷新
                            self.outputs.refreshResult.onNext(.end_foot)
                            self.model.models.accept(self.model.models.value + data)
                        } else {
                            //没有更多数据
                            self.outputs.refreshResult.onNext(.nodata_foot)
                        }
                        break
                    default:
                        //请求失败
                        self.outputs.refreshResult.onNext(.nonet)
                        break
                    }
                })
                .disposed(by: self.model.disposeBag)
        }
    }
}

public struct ChatFindSectionModel {
    public var items: [item]
}

extension ChatFindSectionModel: SectionModelType {
    public typealias item = User
    
    public init(original: ChatFindSectionModel, items: [ChatFindSectionModel.item]) {
        self = original
        self.items = items
    }
}

