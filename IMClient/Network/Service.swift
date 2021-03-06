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
    static let instance = UserService()
    private init() { }
    
    /// 用户登陆
    ///
    /// - Parameters:
    ///   - username: 用户名
    ///   - password: 用户密码
    func signin(username: String, password: String) -> Observable<ResultType> {
        return BaseProvider.rx.request(.signin(username: username, password: password))
            .mapObject(BaseResult.self)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map { data in
                if data.result.code.valid() {
                    //Token Save
                    let user = User(map: Map(mappingType: .fromJSON, JSON: data.dataDict!))!
                    Environment.token = user.token!
                    //User Save
                    ServiceUtil.saveUser(user)
                    //登录通知
                    BaseStatus.onNext(.signin)
                }
                return data.result
            }
            .catchError { error in
                return .just(ResultSet.requestFailed)
        }
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
                    //User Save
                    ServiceUtil.saveUser(user)
                    //登录通知
                    BaseStatus.onNext(.signin)
                }
                return data.result
            }
            .catchError { error in
                return .just(ResultSet.requestFailed)
            }
    }
    
    /// 用户登出
    ///
    /// - Returns: 返回结果
    func signout() -> Observable<ResultType> {
        return BaseProvider.rx.request(.signout)
            .mapObject(BaseResult.self)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map { data in
                Environment.clearUser()
                //登出通知
                BaseStatus.onNext(.signout)
                return data.result
            }
            .catchError { error in
                return .just(ResultSet.requestFailed)
        }
    }
    
    /// 用户简介
    ///
    /// - Parameter id: 用户标识
    /// - Returns: 返回数据
    func user_profile(id: Int) -> Observable<(UserProfile?, ResultType)> {
        return BaseProvider.rx.request(.profile(id: id))
            .mapObject(BaseResult.self)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map { data in
                if data.result.code.valid() {
                    let profile = UserProfile(map: Map(mappingType: .fromJSON, JSON: data.dataDict!))!
                    return (profile, data.result)
                }
                return (nil, data.result)
            }
            .catchError { error in
                return .just((nil, ResultSet.requestFailed))
            }
    }
}

class FindService {
    
    //MARK: - 单例
    static let instance = FindService()
    private init() { }
    
    //MARK: - 发现用户
    func find_user(page: Int) -> Observable<([User], ResultType)> {
        return BaseProvider.rx.request(.find_user(page: page))
            .mapObject(BaseResult.self)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map{ data in
                if data.result.code.valid() {
                    let list = [User].init(JSONArray: data.dataDicts!)
                    return (list, data.result)
                }
                return ([], data.result)
            }
            .catchErrorJustReturn(([], ResultSet.requestFailed))
    }
}

class FileService {
    
    //MARK: - 单例
    static let instance = FileService()
    private init() { }
    
    //MARK: - 聊天图片
    func upload_chat_image(msgid: String, url: URL) -> Observable<(ChatMessage?, ResultType)> {
        return BaseProvider.rx.request(.upload_chat_image(msgid: msgid, url: url))
            .mapObject(BaseResult.self)
            .asObservable()
            .observeOn(MainScheduler.instance)
            .map{ data in
                if data.result.code.valid() {
                    let message = ChatMessage(map: Map(mappingType: .fromJSON, JSON: data.dataDict!))!
                    return (message, data.result)
                }
                return (nil, data.result)
            }
            .catchErrorJustReturn((nil, ResultSet.requestFailed))
    }
}
