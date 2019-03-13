//
//  ServiceUtil.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation

struct ServiceUtil {
    
    //MARK: - 保存用户信息
    static func saveUser(_ user: User) {
        Environment.user = user
    }
    
    //TODO: - 保存用户详情
}
