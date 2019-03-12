//
//  BaseChatViewController.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/10.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import SnapKit

class BaseChatViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetupUI()
    }
    
    //MARK: - 私有成员
    fileprivate lazy var chatView: IMUIMessageCollectionView = { //聊天视图
        return IMUIMessageCollectionView()
    }()
    fileprivate lazy var inputBar: IMUIInputView = {             //输入视图
        return IMUIInputView()
    }()
}

//MARK: - 初始化
extension BaseChatViewController {
    
    fileprivate func baseSetupUI() {
        self.view.addSubview(chatView)
        self.view.addSubview(inputBar)
        chatView.snp.makeConstraints { make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.inputBar)
        }
        inputBar.snp.makeConstraints { make in
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        chatView.delegate = self
        inputBar.delegate = self
    }
}

//MARK: - 消息业务
extension BaseChatViewController {
    
    func appendMessage(user: User, message: ChatMessage, issender: Bool) {
        
    }
}

//MARK: - Delegate
extension BaseChatViewController: IMUIMessageMessageCollectionViewDelegate, IMUIInputViewDelegate {
    
}

