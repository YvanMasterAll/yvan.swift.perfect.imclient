//
//  User.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import ObjectMapper

public struct User: BaseModel {
    
    var id          : Int?
    var nickname    : String?
    var realname    : String?
    var age         : Int?
    var avatar      : String?
    var signature   : String?
    var phone       : String?
    var email       : String?
    var address     : String?
    var college     : String?
    var gender      : Gender?
    var createtime  : Date?
    var updatetime  : Date?
    var status      : Status?
    var token       : String?
    
    public init(){}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        id          <- map["id"]
        nickname    <- map["nickname"]
        realname    <- map["realname"]
        age         <- map["age"]
        avatar      <- map["avatar"]
        signature   <- map["signature"]
        phone       <- map["phone"]
        email       <- map["email"]
        address     <- map["address"]
        college     <- map["college"]
        gender      <- (map["gender"], transfromOfType())
        createtime  <- (map["createtime"], transfromOfDate())
        updatetime  <- (map["updatetime"], transfromOfDate())
        status      <- (map["status"], transfromOfType())
        token       <- map["token"]
    }
}
