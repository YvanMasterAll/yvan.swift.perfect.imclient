//
//  TableView+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

//MARK: - 注册表列
extension UITableView {
    
    func register(nib: String, identifier: String) {
        self.register(UINib.init(nibName: nib, bundle: nil), forCellReuseIdentifier: identifier)
    }
}
