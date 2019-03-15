//
//  UserRegisterVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserRegisterVC: BaseViewController {
    
    @IBOutlet weak var tf_phone: STTxf!
    @IBOutlet weak var tf_password: STTxf!
    @IBOutlet weak var btn_register: STBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindRx()
    }
    
    //MARK: - 私有成员
    fileprivate var disposeBag = DisposeBag()
    fileprivate lazy var vmodel: RegisterVM = {
        return RegisterVM(disposeBag: disposeBag)
    }()
}

//MARK: - 初始化
extension UserRegisterVC {
    
    fileprivate func setupUI() {
        //注册按钮
        btn_register.isEnabled = false
    }
    
    fileprivate func bindRx() {
        self.tf_phone.rx.text.orEmpty
            .bind(to: vmodel.inputs.phoneInput)
            .disposed(by: disposeBag)
        self.tf_password.rx.text.orEmpty
            .bind(to: vmodel.inputs.passwordInput)
            .disposed(by: disposeBag)
        vmodel.outputs.inputUsable!
            .bind(to: btn_register.rx.isEnabled)
            .disposed(by: disposeBag)
        self.btn_register.rx.tap
            .map{ [unowned self] ()
                -> (String, String) in
                return (self.tf_phone.text ?? "",
                        self.tf_password.text ?? "")
            }
            .share(replay: 1)
            .bind(to: vmodel.inputs.registerTap)
            .disposed(by: disposeBag)
        vmodel.outputs.registerResult
            .subscribe(onNext: { response in
                guard response.code.valid() else {
                    STHud.showError(text: response.msg)
                    return
                }
                STHud.showSuccess(text: response.msg)
            })
            .disposed(by: disposeBag)
    }
}
