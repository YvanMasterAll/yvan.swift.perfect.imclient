//
//  ViewController+Extension.swift
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
