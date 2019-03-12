//
//  Loadable+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import Foundation

protocol StoryboardLoadable {}

extension StoryboardLoadable where Self: UIViewController {
    
    /// 通过SB实例化VC
    ///
    /// - Returns: VC
    static func storyboard(from: String) -> Self {
        return UIStoryboard(name: from, bundle: nil)
            .instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}

protocol NibLoadable {}

extension NibLoadable {
    
    /// 通过Xib实例化视图
    ///
    /// - Returns: 视图
    static func nibview() -> Self {
        return Bundle.main.loadNibNamed("\(self)", owner: nil, options: nil)?.last as! Self
    }
}
