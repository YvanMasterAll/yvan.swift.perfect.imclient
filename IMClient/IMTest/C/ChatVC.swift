//
//  ChatVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class ChatVC: BaseChatViewController {
    
    //MARK: - 声明区域
    open var dialogtype : DialogType!
    open var user       : User!
    open var target     : User!
    
    override func getTarget() -> User {
        return target
    }
    
    override func getDialogType() -> DialogType {
        return dialogtype
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //yTest
        dialogtype = DialogType.single
//        user = User()
//        user.id = 2
//        user.nickname = "yi001"
//        user.avatar = ""
        target = User()
        target?.id = 2
        target?.nickname = "yi001"
        target?.avatar = ""
        
        setupUI()
    }
}

extension ChatVC {
    
    //MARK: - 初始化
    fileprivate func setupUI() {
        
    }
}
