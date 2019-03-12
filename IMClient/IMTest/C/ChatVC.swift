//
//  ChatVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class ChatVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: - 私有成员
    fileprivate lazy var chatView: IMUIMessageCollectionView = { //聊天视图
        return IMUIMessageCollectionView()
    }()
}

extension ChatVC {
    
    //MARK: - 初始化
    fileprivate func setupUI() {
        
    }
}
