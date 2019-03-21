//
//  UserSigninVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserSigninVC: BaseViewController {
    
    @IBOutlet weak var tf_phone: STTxf!
    @IBOutlet weak var tf_password: STTxf!
    @IBOutlet weak var btn_signin: STBtn!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarTitle = "登陆"
        setupUI()
        bindRx()
    }
    
    //MARK: - 私有成员
    fileprivate var disposeBag = DisposeBag()
    fileprivate lazy var vmodel: SigninVM = {
        return SigninVM(disposeBag: disposeBag)
    }()
}

//MARK: - 初始化
extension UserSigninVC {
    
    fileprivate func setupUI() {
        //注册按钮
        btn_signin.isEnabled = false
    }
    
    fileprivate func bindRx() {
        self.tf_phone.rx.text.orEmpty
            .bind(to: vmodel.inputs.phoneInput)
            .disposed(by: disposeBag)
        self.tf_password.rx.text.orEmpty
            .bind(to: vmodel.inputs.passwordInput)
            .disposed(by: disposeBag)
        vmodel.outputs.inputUsable!
            .bind(to: btn_signin.rx.isEnabled)
            .disposed(by: disposeBag)
        self.btn_signin.rx.tap
            .map{ [unowned self] ()
                -> (String, String) in
                return (self.tf_phone.text ?? "",
                        self.tf_password.text ?? "")
            }
            .share(replay: 1)
            .bind(to: vmodel.inputs.signinTap)
            .disposed(by: disposeBag)
        vmodel.outputs.signinResult
            .subscribe(onNext: { [unowned self] response in
                guard response.code.valid() else {
                    STHud.showError(text: response.msg)
                    return
                }
                STHud.showSuccess(text: response.msg)
                let vc = ChatDialogVC.storyboard(from: "Chat")
                self.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: disposeBag)
    }
}
