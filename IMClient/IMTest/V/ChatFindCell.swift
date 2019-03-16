//
//  ChatFindCell.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/16.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class ChatFindCell: BaseTableViewCell {

    @IBOutlet weak var lable_name: UILabel!
    @IBOutlet weak var img_avatar: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI() 
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - 初始化
extension ChatFindCell {
    
    fileprivate func setupUI() {
        
    }
}
