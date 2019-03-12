//
//  STBtn.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import UIKit

public enum STBtnStyle {
    case primary
}
@IBDesignable
open class STBtn: UIButton {
    
    //MARK: - 按钮样式
    open var style: STBtnStyle = .primary { didSet { updateStyle() } }
    
    //MARK: - 按钮状态
    open override var isEnabled: Bool { didSet { updateStyle() } }
    
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
extension STBtn {
    
    fileprivate func setupUI() {
        //取消高亮效果
        self.adjustsImageWhenHighlighted = false
    }
    
    fileprivate func setupSUI() {
        
    }
}

//MARK: - 按钮样式
extension STBtn {
    
    fileprivate func updateStyle() {
        switch style {
        case .primary:
            if isEnabled {
                //TODO: Enabled Style
                alpha = 1
            } else {
                alpha = 0.6
            }
        }
    }
}
