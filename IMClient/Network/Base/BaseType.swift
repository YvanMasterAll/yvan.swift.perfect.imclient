//
//  BaseType.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation

//MARK: - 枚举类型
protocol BaseType {
    
    var value: String { get }
    init?(_ value: String)
}
public enum Gender: BaseType {      //性别
    
    case male, female
    
    public var value: String {
        switch self {
        case .male              : return "男"
        case .female            : return "女"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "男"                : self = .male
        case "女"                : self = .female
        default                  : return nil
        }
    }
}
public enum Status: BaseType {      //状态
    
    case normal, delete, unread
    
    public var value: String {
        switch self {
        case .normal            : return "正常"
        case .delete            : return "删除"
        case .unread            : return "未读"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "正常"              : self = .normal
        case "删除"              : self = .delete
        case "未读"              : self = .unread
        default                  : return nil
        }
    }
}
public enum Whether: BaseType {     //是否
    
    case y, n
    
    public var value: String {
        switch self {
        case .y                 : return "是"
        case .n                 : return "否"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "是"                : self = .y
        case "否"                : self = .n
        default                  : return nil
        }
    }
}
public enum MessageType: BaseType { //消息类型
    
    case normal
    
    public var value: String {
        switch self {
        case .normal            : return "普通消息"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "普通消息", "normal"  : self = .normal
        default                  : return nil
        }
    }
}
public enum DialogType: BaseType {  //会话类型
    
    case normal
    
    public var value: String {
        switch self {
        case .normal             : return "普通会话"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "普通会话", "normal"  : self = .normal
        default                   : return nil
        }
    }
}
public enum SocketCmdType {         //命令类型, WebSocket
    
    case register, chat
    
    public var value: String {
        switch self {
        case .register       : return "注册"
        case .chat           : return "聊天"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "注册", "register"   : self = .register
        case "聊天", "chat"       : self = .chat
        default                   : return nil
        }
    }
}
