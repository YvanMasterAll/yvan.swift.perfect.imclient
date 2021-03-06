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
    var _id         : String?           //消息标识, 本地使用
    var cmd         : SocketCmdType?
    var dialogid    : String?
    var sender      : Int?
    var receiver    : Int?
    var _body       : String?           //临时消息, 本地使用
    var body        : String?
    var type        : MessageType?
    var dialogtype  : DialogType?
    var createtime  : Date?
    var updatetime  : Date?
    var status      : Status?
    var pageindex   : Int?              //页面索引, 本地使用
    var token       : String?           //身份认证, 本地使用
    
    public init(){}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        id          <- map["id"]
        _id         <- map["_id"]
        cmd         <- (map["cmd"], transfromOfType())
        dialogid    <- map["dialogid"]
        sender      <- map["sender"]
        receiver    <- map["receiver"]
        _body       <- map["_body"]
        body        <- map["body"]
        type        <- (map["type"], transfromOfType())
        dialogtype  <- (map["dialogtype"], transfromOfType())
        createtime  <- (map["createtime"], transfromOfDate())
        updatetime  <- (map["updatetime"], transfromOfDate())
        status      <- (map["status"], transfromOfType())
        pageindex   <- map["pageindex"]
        token       <- map["token"]
    }
    
    public mutating func tokened() {
        self.token = Environment.token
    }
}
