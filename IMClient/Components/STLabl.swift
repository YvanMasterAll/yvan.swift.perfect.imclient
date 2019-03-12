//
//  STLabl.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

@IBDesignable
class STLabl: UILabel {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard loaded else { loaded = true; setupSUI(); return }
    }
}

//MARK: - 初始化
extension STLabl {
    
    fileprivate func setupUI() {
        
    }
    
    fileprivate func setupSUI() {
        
    }
}


