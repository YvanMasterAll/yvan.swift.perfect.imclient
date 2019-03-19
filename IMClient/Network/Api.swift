//
//  Api.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Moya

//MARK: - API
public var BaseProvider: MoyaProvider = MoyaProvider<BaseApi>(
    endpointClosure: baseEndpointClosure,       //端点闭包
    requestClosure: baseRequestClosure          //请求闭包
    //stubClosure: MoyaProvider.delayedStub(2)  //immediatelyStub, 测试闭包
)

public enum BaseApi {
    //MARK: - 用户模块
    case register(username: String, password: String)
    case signin(username: String, password: String)
    case signout
    case profile(id: Int)
    //MARK: - 发现模块
    case find_user(page: Int)
    //MARK: - 文件模块
    case upload_chat_image(msgid: String, url: URL)
}

extension BaseApi: TargetType {
    
    //MARK: - 基础地址
    public var baseURL: URL {
        return URL(string: "\(baseURL_i)/api/v1")!
    }
    
    //MARK: - 资源路径
    public var path: String {
        switch self {
        //MARK: - 用户模块
        case .register:         return "/user/register"
        case .signin:           return "/user/signin"
        case .signout:          return "/user/signout"
        case .profile:          return "/user/profile"
        //MARK: - 发现模块
        case .find_user:        return "/find/user/list"
        //MARK: - 文件模块
        case .upload_chat_image:return "/file/chat/image"
        }
    }
    
    //MARK: - 请求方法
    public var method: Method {
        switch self {
        //MARK: - 用户模块
        case .register,
             .signin,
             .signout,
             .profile,
             .find_user,
             .upload_chat_image:
            return .post
        default:
            return .get
        }
    }
    
    //MARK: - 请求数据
    public var task: Task {
        switch self {
        //MARK: - 用户模块
        case .register(let username,
                    let password):
            let params = [
                "username": username,
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .signin(let username,
                     let password):
            let params = [
                "username": username,
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        case .profile(let id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case .find_user(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.default)
        case .upload_chat_image(let msgid, let url):
            return .uploadCompositeMultipart([MultipartFormData(provider: .file(url), name: "")], urlParameters: ["_id": msgid])
        default:
            return .requestPlain
        }
    }
    
    //MARK: - 测试数据
    public var sampleData: Data {
        switch self {
        //MARK: - 用户模块
        case .register:
            return BaseApiTestData.register.data(using: String.Encoding.utf8)!
        default:
            return "".data(using: String.Encoding.utf8)!
        }
    }
    
    //MARK: - 请求头
    public var headers: [String : String]? {
        return nil
    }
}

let baseRequestClosure = { (endpoint: Endpoint,
    done: MoyaProvider.RequestResultClosure) in
    var request: URLRequest
    do {
        try request = endpoint.urlRequest()
        request.timeoutInterval = 10            //请求超时
        request.httpShouldHandleCookies = true  //Cookies支持
        if let token = Environment.token {      //携带身份
            let cookies = "TurnstileSession=\(token);AppVersion=\(AppVersion)"
            request.setValue(cookies, forHTTPHeaderField: "Cookie")
        } else {
            request.setValue("AppVersion=\(AppVersion)", forHTTPHeaderField: "Cookie")
        }
        done(.success(request))
    } catch {
        done(.failure(MoyaError.requestMapping(endpoint.url)))
    }
}

let baseEndpointClosure = { (target: BaseApi) -> Endpoint in
    let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
    return defaultEndpoint
}

//MARK: - Extension

//MARK: - 测试数据
fileprivate struct BaseApiTestData {
    
    //MARK: - 用户模块
    static var register: String = """
{
    "code": 200,
    "msg": "注册成功",
    "dataDict": {
        "signature": "",
        "createtime": "2019-03-07 10:10:46",
        "avatar": "",
        "college": "",
        "realname": "",
        "status": "正常",
        "email": "",
        "age": 0,
        "address": "",
        "gender": "男",
        "token": "UccaGp_bJBHPb2UeoPz9gw",
        "phone": "",
        "nickname": "",
        "uniqueID": "",
        "id": 0,
        "updatetime": "2019-03-07 10:10:46"
    }
}
"""
}
