//
//  STTxf.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

@IBDesignable
class STTxf: UITextField {
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        guard loaded else { loaded = true; setupSUI(); return }
    }
}

//MARK: - 初始化
extension STTxf {
    
    fileprivate func setupSUI() {
        
    }
}
