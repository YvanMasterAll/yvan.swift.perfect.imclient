//
//  BaseResult.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import ObjectMapper

public struct BaseResult: BaseModel {
    
    var code        : Int!
    var result      : ResultType!
    var cmd         : SocketCmdType?
    var msg         : String?
    var dataArray   : [String]?
    var dataDict    : [String: Any]?
    var dataDicts   : [[String: Any]]?
    
    public init(){}
    
    public init?(map: Map) {
        mapping(map: map)
    }
    
    public mutating func mapping(map: Map) {
        code        <- map["code"]
        msg         <- map["msg"]
        dataArray   <- map["dataArray"]
        dataDict    <- map["dataDict"]
        dataDicts   <- map["dataDicts"]
        cmd         <- (map["cmd"], transfromOfType())
        result      = ResultType(code: ResultCode(code) == nil ? ResultCode.unknown:ResultCode(code)!,
                                 msg: msg)
    }
}

struct ResultType {
    
    var code    : ResultCode
    var msg     : String
    
    init(code: ResultCode, msg: String = "") {
        self.code = code
        self.msg = msg == "" ? code.msg():msg
    }
    init(code: ResultCode, msg: String?) {
        self.code = code
        self.msg = msg == nil ? code.msg():msg!
    }
}

enum ResultCode: Int {
    
    //MARK: - 200
    case success            = 200
    
    //MARK: - 400
    case requestIllegal     = 401
    case failure            = 499
    case userExists         = 411
    case userNotExists      = 412
    case signinFailure      = 413
    case dialogNotExists    = 421
    
    //MARK: - 500
    case serverError        = 500
    
    //MARK: - 900
    case unknown            = 900
    
    public var value: Int {
        return self.rawValue
    }
    
    init?(_ value: Int) {
        switch value {
        //MARK: - 200
        case 200                : self = .success
        //MARK: - 400
        case 401                : self = .requestIllegal
        case 499                : self = .failure
        case 411                : self = .userExists
        case 412                : self = .userNotExists
        case 413                : self = .signinFailure
        case 421                : self = .dialogNotExists
        //MARK: - 500
        case 500                : self = .serverError
        //MARK: - 900
        case 900                : self = .unknown
        default                 : return nil
        }
    }
    
    func msg() -> String {
        switch self {
        //MARK: - 200
        case .success:          return "请求成功"
        //MARK: - 400
        case .requestIllegal:   return "非法请求"
        case .failure:          return "请求失败"
        case .userExists:       return "用户已存在"
        case .userNotExists:    return "用户不存在"
        case .signinFailure:    return "登陆失败"
        case .dialogNotExists:  return "会话不存在"
        //MARK: - 500
        case .serverError:      return "服务器异常"
        //MARK: - 900
        case .unknown:          return "未知错误"
        }
    }
}

extension ResultCode {
    
    func valid() -> Bool {
        switch self {
        case .success:
            return true
        default:
            return false
        }
    }
}

