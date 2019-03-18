//
//  ChatDialog.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/12.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ChatDialog: BaseModel {
    
    var id              : String?
    var lastmessageid   : String?
    var type            : DialogType?
    var createtime      : Date?
    var updatetime      : Date?
    var status          : Status?
    
    public init(){}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        id              <- map["id"]
        lastmessageid   <- map["lastmessageid"]
        type            <- (map["type"], transfromOfType())
        createtime      <- (map["createtime"], transfromOfDate())
        updatetime      <- (map["updatetime"], transfromOfDate())
        status          <- (map["status"], transfromOfType())
    }
}

public struct ChatDialog_Message: BaseModel {
    
    var id              : String?
    var messageid       : String?
    var sender          : Int?
    var receiver        : Int?
    var body            : String?
    var avatar          : String?
    var name            : String?
    var type            : DialogType?
    var messagetype     : MessageType?
    var createtime      : Date?
    var updatetime      : Date?
    var status          : Status?
    
    public init(){}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        id              <- map["id"]
        messageid       <- map["messageid"]
        sender          <- map["sender"]
        receiver        <- map["receiver"]
        body            <- map["body"]
        avatar          <- map["avatar"]
        name            <- map["name"]
        type            <- (map["type"], transfromOfType())
        messagetype     <- (map["messagetype"], transfromOfType())
        createtime      <- (map["createtime"], transfromOfDate())
        updatetime      <- (map["updatetime"], transfromOfDate())
        status          <- (map["status"], transfromOfType())
    }
    
    public func target() -> User {
        var user = User()
        user.avatar = avatar
        user.nickname = name
        user.id = Environment.user?.id == sender ? receiver:sender
        return user
    }
}
