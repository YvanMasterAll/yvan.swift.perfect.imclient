//
//  App.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

//MARK: - 版本信息
let AppVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String

//MARK: - 配置文件
let baseConfig = "app.json"

//MARK: - 请求地址
var baseURL_i = "http://localhost:8181"

//MARK: - 应用状态
public enum BaseStatusType {
    case none           //未知状态
    case signout        //登出状态
    case signin         //登录状态
    case userinfo       //更新用户信息
    case userinfo_part  //局部更新用户信息, 如关注数, 不请求网络
}
let BaseStatus = PublishSubject<BaseStatusType>()
