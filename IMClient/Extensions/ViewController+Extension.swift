//
//  ViewController+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/15.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

//MARK: - 子控制器
extension UIViewController {
    
    public func addChildVC(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    public func _addChildVC(_ child: UIViewController) {
        child.beginAppearanceTransition(true, animated: false)
        view.addSubview(child.view)
        child.endAppearanceTransition()
        child.didMove(toParent: self)
        addChild(child)
    }
    
    public func removeChildVC(_ child: UIViewController) {
        child.removeChildVC()
    }
    
    public func removeChildVC() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}

