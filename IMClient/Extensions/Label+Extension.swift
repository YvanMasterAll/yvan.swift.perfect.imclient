//
//  Label+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/12.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit

//MARK: - Bounding Size
extension UILabel {
    
    var height_nature: CGFloat {
        get {
            return self.text!
                .boundingRect(with: CGSize(width: self.frame.width, height:CGFloat(MAXFLOAT)),
                              options: .usesLineFragmentOrigin,
                              attributes: [NSAttributedString.Key.font : self.font],
                              context: nil).height
        }
    }
    
    var width_max: CGFloat {
        get {
            return self.text!
                .boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0),
                              options: .usesLineFragmentOrigin,
                              attributes: [NSAttributedString.Key.font : self.font],
                              context: nil).width
        }
    }
    
    /// 获取文本对应行数的高度
    /// - parameter by: 行数
    /// - returns: 文本高度
    func height_lines(by: Int) -> CGFloat {
        var s = ""
        for i in 0..<by {
            s += "\(i)"
        }
        return (s as NSString)
            .boundingRect(with: CGSize(width: 1, height:CGFloat(MAXFLOAT)),
                          options: .usesLineFragmentOrigin,
                          attributes: [NSAttributedString.Key.font : self.font],
                          context: nil).height
    }
}
