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
    
    case text
    
    public var value: String {
        switch self {
        case .text               : return "文本"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "文本", "text"       : self = .text
        default                  : return nil
        }
    }
}

public enum DialogType: BaseType {  //会话类型
    
    case single
    
    public var value: String {
        switch self {
        case .single              : return "单聊"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "单聊", "single"      : self = .single
        default                   : return nil
        }
    }
}

public enum SocketCmdType: BaseType {//命令类型, WebSocket
    
    case register, chat, receive, list, list_dialog
    
    public var value: String {
        switch self {
        case .register          : return "注册"
        case .chat              : return "聊天"
        case .receive           : return "接收"
        case .list               : return "列表"
        case .list_dialog       : return "会话"
        }
    }
    
    init?(_ value: String) {
        switch value {
        case "注册", "register"   : self = .register
        case "聊天", "chat"       : self = .chat
        case "列表", "list"       : self = .list
        case "接收", "receive"    : self = .receive
        case "会话", "list_dialog": self = .list_dialog
        default                   : return nil
        }
    }
}
