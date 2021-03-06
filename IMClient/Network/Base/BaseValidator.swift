//
//  BaseValidator.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import SwiftValidators

protocol BaseValidatorProtocol {
    
    func validate(_ input: String) -> Bool
}

enum BaseValidator {
    
    case password
    case phone
}

extension BaseValidator {
    
    //MARK: - 工厂
    func instance() -> BaseValidatorProtocol {
        switch self {
        case .password:
            return ValidatorPassword.instance
        case .phone:
            return ValidatorPhoneNumber.instance
        }
    }
    
    //MARK: - 验证
    func validate(_ input: String) -> Bool {
        switch self {
        case .password:
            return ValidatorPassword.instance.validate(input)
        case .phone:
            return ValidatorPhoneNumber.instance.validate(input)
        }
    }
}

struct ValidatorPassword: BaseValidatorProtocol {
    
    //MARK: - 单例
    static let instance = ValidatorPassword()
    private init() { }
    
    //MARK: - 验证
    func validate(_ input: String) -> Bool {
        return v_ascii.apply(input) && v_length_min.apply(input) && v_length_min.apply(input)
    }
    
    //MARK: - 私有成员
    fileprivate let v_ascii         = Validator.isASCII()
    fileprivate let v_length_min    = Validator.minLength(6)
    fileprivate let v_length_max    = Validator.maxLength(16)
}

struct ValidatorPhoneNumber: BaseValidatorProtocol {
    
    //MARK: - 单例
    static let instance = ValidatorPhoneNumber()
    private init() { }
    
    //MARK: - 验证
    func validate(_ input: String) -> Bool {
        return v_phone.apply(input)
    }
    
    //MARK: - 私有成员
    fileprivate let v_phone         = Validator.isPhone(.zh_CN)
}

