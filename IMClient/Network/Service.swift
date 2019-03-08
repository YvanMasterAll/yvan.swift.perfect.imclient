//
//  Service.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import ObjectMapper
import SwiftValidators

class UserService {
    
    //MARK: - 单例
    static let shared = UserService()
    private init() { }
    
    
    /// 用户登陆
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 用户密码
    func signin(username: String, password: String) {
        
    }
    
    
    /// 用户注册
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 用户密码
    func register(username: String, password: String) -> Observable<ResultType> {
        return BaseProvider.rx.request(.register(username: username, password: password))
            .mapObject(BaseResult.self)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map { data in
                if data.result.code.valid() {
                    //Token Save
                    let user = User(map: Map(mappingType: .fromJSON, JSON: data.dataDict!))!
                    Environment.token = user.token!
//                    let token = result.token!
//                    Environment.token = token
//                    if let user = User.init(map: Map.init(mappingType: .fromJSON, JSON: result.data!)) {
//                        ServiceUtil.saveUserInfo(user)
//                    }
//                    //登录通知
//                    AppStatus.onNext(AppState.login)
                }
                return data.result
            }
            .catchError { error in
                return .just(ResultType(code: .failure))
            }
    }
}
