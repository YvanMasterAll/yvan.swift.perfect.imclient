//
//  Reactive+Extension.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/9.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

extension Reactive where Base: UIButton {
    
    public var isEnabledBgColor: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.backgroundColor = value ? UIColor.blue:UIColor.white
        }
    }
    
    public var isEnabledBorderColor: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.layer.borderColor = value ? UIColor.blue.cgColor:UIColor.white.cgColor
            control.layer.masksToBounds = true
        }
    }
}
