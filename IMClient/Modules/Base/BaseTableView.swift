//
//  BaseTableView.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class BaseTableView: UITableView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = BaseTheme.color.neutral50
        self.separatorStyle = .none                 //消除分割线
        self.showsVerticalScrollIndicator = false   //消除指示器
        self.showsHorizontalScrollIndicator = false
        self.tableFooterView = UIView()             //消除底部视图
    }
}
