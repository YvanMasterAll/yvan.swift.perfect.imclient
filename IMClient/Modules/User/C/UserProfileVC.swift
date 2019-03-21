//
//  UserProfileVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/19.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class UserProfileVC: BaseViewController {

    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var label_gender: UILabel!
    @IBOutlet weak var label_sign: UILabel!
    
    //MARK: - 声明区域
    open var userid: Int?
    open var userpf: UserProfile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarTitle = "简介"
        setupUI()
        bindRx()
    }
    
    //MARK: - 私有成员
    fileprivate lazy var vmodel: ProfileVM = {
        return ProfileVM(disposeBag: self.disposeBag)
    }()
    fileprivate var disposeBag = DisposeBag()
}

//MARK: - 初始化
extension UserProfileVC {
    
    fileprivate func setupUI() {
        if let _ = userpf { setupContent() } else { reloadData() }
    }
    
    fileprivate func setupContent() {
        if let profile = self.userpf {
            img_avatar.kf.setImage(with: URL(string: profile.avatar!))
            label_name.text = profile.nickname
            label_gender.text = profile.gender?.value
            label_sign.text = profile.signature
        }
    }
    
    fileprivate func bindRx() {
        vmodel.outputs.profileResult.asObserver()
            .subscribe(onNext: { [unowned self] response in
                let data = response.0
                let result = response.1
                if result.code.valid() {
                    self.userpf = data!
                    self.setupContent()
                } else {
                    self.show_place()
                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK - Reload Data
extension UserProfileVC {
    
    fileprivate func reloadData() {
        if let id = userid {
            vmodel.inputs.profileTap.onNext(id)
        }
    }
}
