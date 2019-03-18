//
//  ChatDialogCell.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/17.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

class ChatDialogCell: BaseTableViewCell {
    
    @IBOutlet weak var img_avatar: UIImageView!
    @IBOutlet weak var label_name: UILabel!
    @IBOutlet weak var label_message: UILabel!
    @IBOutlet weak var label_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//MARK: - 初始化
extension ChatDialogCell {
    
    fileprivate func setupUI() {
        
    }
}
