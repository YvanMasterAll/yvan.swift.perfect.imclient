//
//  UserVM.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import RxCocoa
import RxSwift
import RxDataSources

struct RegisterVMInput {
    var phoneInput      : PublishSubject<String>
    var passwordInput   : PublishSubject<String>
    var registerTap     : PublishSubject<(String, String)>
}
struct RegisterVMOutput {
    var inputUsable     : Observable<Bool>?
    var registerResult  : PublishSubject<ResultType>
}
class RegisterVM {
    
    //MARK: - 私有成员
    fileprivate struct Model {
        var disposeBag: DisposeBag
    }
    fileprivate var model: Model!
    fileprivate var service = UserService.instance
    
    //MARK: - Inputs
    var inputs: RegisterVMInput = {
        return RegisterVMInput(phoneInput: PublishSubject<String>(),
                               passwordInput: PublishSubject<String>(),
                               registerTap: PublishSubject<(String, String)>())
    }()
    
    //MARK: - Outputs
    var outputs: RegisterVMOutput = {
        return RegisterVMOutput(inputUsable: nil,
                                registerResult: PublishSubject<ResultType>())
    }()
    
    init(disposeBag: DisposeBag) {
        self.model = Model(disposeBag: disposeBag)
        //Rx
        self.outputs.inputUsable = Observable<Bool>
            .combineLatest(inputs.phoneInput, inputs.passwordInput) { phone, password -> Bool in
                return BaseValidator.password.validate(password)
                    && BaseValidator.phone.validate(phone)
        }
        self.inputs.registerTap.asObserver()
            .subscribe(onNext: { phone, password in
                self.register(username: phone, password: password)
            })
            .disposed(by: model.disposeBag)
    }
}

extension RegisterVM {
    
    //MARK: - 数据请求
    fileprivate func register(username: String, password: String) {
        //显示菊花
        STHud.showLoading()
        self.service.register(username: username, password: password)
            .subscribe(onNext: { response in
                //隐藏菊花
                STHud.hide()
                self.outputs.registerResult.onNext(response)
            })
            .disposed(by: self.model.disposeBag)
    }
}

struct SigninVMInput {
    var phoneInput      : PublishSubject<String>
    var passwordInput   : PublishSubject<String>
    var signinTap       : PublishSubject<(String, String)>
}
struct SigninVMOutput {
    var inputUsable     : Observable<Bool>?
    var signinResult   : PublishSubject<ResultType>
}
class SigninVM {
    
    //MARK: - 私有成员
    fileprivate struct Model {
        var disposeBag: DisposeBag
    }
    fileprivate var model: Model!
    fileprivate var service = UserService.instance
    
    //MARK: - Inputs
    var inputs: SigninVMInput = {
        return SigninVMInput(phoneInput: PublishSubject<String>(),
                             passwordInput: PublishSubject<String>(),
                             signinTap: PublishSubject<(String, String)>())
    }()
    
    //MARK: - Outputs
    var outputs: SigninVMOutput = {
        return SigninVMOutput(inputUsable: nil,
                              signinResult: PublishSubject<ResultType>())
    }()
    
    init(disposeBag: DisposeBag) {
        self.model = Model(disposeBag: disposeBag)
        //Rx
        self.outputs.inputUsable = Observable<Bool>
            .combineLatest(inputs.phoneInput, inputs.passwordInput) { phone, password -> Bool in
                return BaseValidator.password.validate(password)
                //return BaseValidator.password.validate(password)
                //  && BaseValidator.phone.validate(phone)
        }
        self.inputs.signinTap.asObserver()
            .subscribe(onNext: { phone, password in
                self.signin(username: phone, password: password)
            })
            .disposed(by: model.disposeBag)
    }
}

extension SigninVM {
    
    //MARK: - 数据请求
    fileprivate func signin(username: String, password: String) {
        //显示菊花
        STHud.showLoading()
        self.service.signin(username: username, password: password)
            .subscribe(onNext: { response in
                //隐藏菊花
                STHud.hide()
                self.outputs.signinResult.onNext(response)
            })
            .disposed(by: self.model.disposeBag)
    }
}



