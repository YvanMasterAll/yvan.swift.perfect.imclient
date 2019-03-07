//
//  Storyboard+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation

protocol StoryboardLoadable {}

extension StoryboardLoadable where Self: UIViewController {
    
    /// <#Description#>
    ///
    /// - Returns: <#return value description#>
    static func loadStoryboard() -> Self {
        return UIStoryboard(name: "\(self)", bundle: nil).instantiateViewController(withIdentifier: "\(self)") as! Self
    }
}
