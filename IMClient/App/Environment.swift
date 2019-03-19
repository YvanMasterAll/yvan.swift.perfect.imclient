//
//  Environment.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import ObjectMapper

struct Environment {

    //MARK: - 环境初始化
    static func initialize() {
        if let dict = BaseUtil.fileToDict(filePath: baseConfig) {
            if let url = dict["baseURL"] as? String {
                baseURL_i = url
            }
            if let url = dict["baseURL_socket"] as? String {
                baseURL_socket = url
            }
        }
    }
    
    //MARK: - 认证模块
    static var token: String? {
        get {
            return self.userDefaults.value(forKey: UserDefaultsKeys.token.rawValue) as! String?
        }
        set {
            self.userDefaults.setValue(newValue, forKey: UserDefaultsKeys.token.rawValue)
        }
    }
    static var tokened: Bool {
        guard let _ = token else {
            return false
        }
        return true
    }
    
    //MARK: - 用户信息
    static var user: User? {
        get {
            if let data = self.userDefaults.value(forKey: UserDefaultsKeys.user.rawValue) as? [String: Any] {
                return User.init(map: Map(mappingType: .fromJSON, JSON: data))
            }
            return nil
        }
        set {
            if let data = newValue?.toJSON() {
                self.userDefaults.setValue(data, forKey: UserDefaultsKeys.user.rawValue)
            }
        }
    }
    
    //MARK: - 环境清理
    static func clearUser() {
        self.userDefaults.removeObject(forKey: UserDefaultsKeys.token.rawValue)
        self.userDefaults.removeObject(forKey: UserDefaultsKeys.user.rawValue)
    }
    
    private enum UserDefaultsKeys: String {
        case token      =   "user_auth_token"
        case user       =   "user"
    }
    
    //MARK: - 私有成员
    private static let userDefaults: UserDefaults = UserDefaults.standard
}
