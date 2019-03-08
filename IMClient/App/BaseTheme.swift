//
//  BaseTheme.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import Foundation

protocol BaseThemeColor {
    
    var primary500  : UIColor { get }
    var neutral900  : UIColor { get }
    var neutral800  : UIColor { get }
    var neutral700  : UIColor { get }
    var neutral600  : UIColor { get }
    var neutral500  : UIColor { get }
    var neutral400  : UIColor { get }
    var neutral300  : UIColor { get }
    var neutral200  : UIColor { get }
    var neutral100  : UIColor { get }      //阴影
    var neutral50   : UIColor { get }      //背景
}
public struct BaseTheme {
    
    enum ThemeStyle {
        case light
    }
    
    private struct ColorLight: BaseThemeColor {
        var primary500      = UIColor(rgb: 0x3272FB)
        var neutral50       = UIColor(rgb: 0xF0F0F0)
        var neutral100      = UIColor(rgb: 0xD4D4D4)
        var neutral200      = UIColor(rgb: 0xB9B9B9)
        var neutral300      = UIColor(rgb: 0x9D9D9D)
        var neutral400      = UIColor(rgb: 0x828282)
        var neutral500      = UIColor(rgb: 0x666666)
        var neutral600      = UIColor(rgb: 0x595959)
        var neutral700      = UIColor(rgb: 0x4D4D4D)
        var neutral800      = UIColor(rgb: 0x404040)
        var neutral900      = UIColor(rgb: 0x333333)
    }
    
    static var style: ThemeStyle = ThemeStyle.light
    
    static var color: BaseThemeColor {
        get {
            switch self.style {
            case .light:
                return ColorLight()
            }
        }
    }
}

public struct BaseFont {
    
    static let font16_m = UIFont.systemFont(ofSize: 16, weight: .medium)
}
