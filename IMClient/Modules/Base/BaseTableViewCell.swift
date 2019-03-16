//
//  BaseTableViewCell.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.baseSetupUI()
    }
}

//MARK: - 初始化
extension BaseTableViewCell {
    
    fileprivate func baseSetupUI() {
        self.backgroundColor = BaseTheme.color.neutral50
        self.selectionStyle = .none //取消高亮
    }
}
