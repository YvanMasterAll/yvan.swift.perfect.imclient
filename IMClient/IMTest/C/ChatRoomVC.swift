//
//  ChatRoomVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class ChatRoomVC: BaseChatViewController {
    
    //MARK: - 声明区域
    open var dialogtype : DialogType!
    open var dialogid   : String?
    open var target     : User!
    
    override func getTarget() -> User {
        return target
    }
    
    override func getDialogType() -> DialogType {
        return dialogtype
    }
    
    override func getDialogId() -> String? {
        return dialogid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let title = target.nickname { navBarTitle = title }
        setupUI()
    }
}

extension ChatRoomVC {
    
    //MARK: - 初始化
    fileprivate func setupUI() {
        
    }
}
