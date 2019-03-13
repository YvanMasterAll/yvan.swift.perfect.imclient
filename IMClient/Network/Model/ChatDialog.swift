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
