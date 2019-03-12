//
//  ChatMessage.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/12.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import ObjectMapper

public struct ChatMessage: BaseModel {
    
    var id          : String?
    var dialogid    : String?
    var sender      : Int?
    var receiver    : Int?
    var message     : String?
    var type        : MessageType?
    var createtime  : Date?
    var updatetime  : Date?
    var status      : Status?
    
    public init(){}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        id          <- map["id"]
        dialogid    <- map["dialogid"]
        sender      <- map["sender"]
        receiver    <- map["receiver"]
        message     <- map["message"]
        type        <- (map["type"], transfromOfType())
        createtime  <- (map["createtime"], transfromOfDate())
        updatetime  <- (map["updatetime"], transfromOfDate())
        status      <- (map["status"], transfromOfType())
    }
}
