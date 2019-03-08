//
//  BaseNavigationController.swift
//  ShuTu
//
//  Created by yiqiang on 2018/4/2.
//  Copyright © 2018年 yiqiang. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        baseSetupUI()
    }
}

//MARK: - 初始化
extension BaseNavigationController {
    
    fileprivate func baseSetupUI() {
        //侧滑返回
        self.interactivePopGestureRecognizer?.delegate = self
        //导航栏初始化
        self.baseSetupNavbar()
    }
    
    fileprivate func baseSetupNavbar() {
        //导航栏按钮字体颜色
        UINavigationBar.appearance().tintColor = BaseTheme.color.primary500
        //导航栏背景色
        UINavigationBar.appearance().barTintColor = BaseColor.white()
        //导航栏标题字体
        var titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .medium),
            NSAttributedString.Key.foregroundColor: BaseTheme.color.neutral900
        ]
        navigationBar.tintColor = BaseTheme.color.primary500
        navigationBar.titleTextAttributes = titleTextAttributes
        //导航栏阴影图片
        navigationBar.shadowImage = BaseFactory.generateImageWithColor(color: BaseTheme.color.neutral50)
        //导航栏按钮字体
        titleTextAttributes = [NSAttributedString.Key.font: BaseFont.font16_m]
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .normal)
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .highlighted)
        UIBarButtonItem.appearance().setTitleTextAttributes(titleTextAttributes, for: .disabled)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.children.count > 1 {    //控制器数量大于一才能侧滑
            if let vc = self.children.last as? BaseViewController {
                return vc.backGestured  //是否侧滑判断
            }
            return true
        }
        return false
    }
}

extension BaseNavigationController {
    
    //MARK: - 屏幕侧滑手势
    func screenEdgePanGestureRecognizer() -> UIScreenEdgePanGestureRecognizer? {
        var edgePan: UIScreenEdgePanGestureRecognizer?
        if let recognizers = view.gestureRecognizers, recognizers.count > 0 {
            for recognizer in recognizers {
                if recognizer is UIScreenEdgePanGestureRecognizer {
                    edgePan = recognizer as? UIScreenEdgePanGestureRecognizer
                    break
                }
            }
        }
        return edgePan
    }
}

