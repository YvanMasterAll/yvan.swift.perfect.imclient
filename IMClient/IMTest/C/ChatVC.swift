//
//  ChatVC.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/17.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class ChatVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindRx()
    }
}

//MARK: - 初始化
extension ChatVC {
    
    fileprivate func setupUI() {
        
    }
    
    fileprivate func bindRx() {
        
    }
}
