//
//  Button+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/8.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

//MARK: - 扩大按钮的交互区域
extension UIButton {

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = self.bounds
        let width = max(44 - bounds.size.width, 0)
        let height = max(44 - bounds.size.height, 0)
        bounds = bounds.insetBy(dx: -0.5 * width, dy: -0.5 * height)
        return bounds.contains(point)
    }
}
