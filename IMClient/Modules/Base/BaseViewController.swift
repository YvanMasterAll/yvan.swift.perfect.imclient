//
//  BaseViewController.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import Foundation

class BaseViewController: UIViewController, StoryboardLoadable, StatePageProtocol {
    
    //MARK: - 声明区域
    open var backGestured       : Bool = true       //测滑返回
    open var thirdKeyboard      : Bool = true       //三方键盘
    
    //MARK: - 导航栏状态
    open var showNavbar         : Bool = true       //显示导航栏
    open var navBarTitle        : String = ""       //导航栏标题
    open var navBarLeftTitle    : String?           //导航栏左侧按钮
    open var navBarRightTitle   : String?           //导航栏左侧按钮
    open var navBarRightIcon    : String?           //导航栏右侧图标
    
    //MARK: - 导航栏事件
    func navBarLeftClicked() { }
    func navBarRightClicked() { }
    @objc fileprivate func _navBarLeftClicked() { self.navBarLeftClicked() }
    @objc fileprivate func _navBarRightClicked() { self.navBarRightClicked() }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.baseSetupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //初始化导航栏
        self.baseSetupNavbar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.showNavbar {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
    }
    
    deinit {
        print("deinit: \(type(of: self))")
    }
    
    //MARK: - 私有成员
    fileprivate var basePlace: STPlace!             //占位视图
    fileprivate var needReload: Bool = true         //重载判断
    internal var requested: Bool = false            //请求数据, 成功
}

//MARK: - 委托方法
extension BaseViewController {
    
    //MARK: - 重载数据
    @objc func reload() { }
}

//MARK: - 初始化
extension BaseViewController {
    
    fileprivate func baseSetupUI() {
        //背景色
        self.view.backgroundColor = BaseTheme.color.neutral50
        //Place
        basePlace = STPlace(target: self.view)
        basePlace.delegate = self
    }
    
    fileprivate func baseSetupNavbar() {
        if self.showNavbar {
            //导航栏标题
            self.navigationItem.title = self.navBarTitle
            //初始化导航栏返回选项
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "",
                                                                         style: .plain,
                                                                         target: self,
                                                                         action: nil)
            //导航栏右侧标题
            if let title = navBarRightTitle {
                let rightBarButton = UIBarButtonItem.init(title: title, style: .plain, target: self, action: #selector(self._navBarRightClicked))
                self.navigationItem.rightBarButtonItem = rightBarButton
            }
            //导航栏左侧标题
            if let title = navBarLeftTitle {
                let leftBarButton = UIBarButtonItem.init(title: title,
                                                         style: .plain,
                                                         target: self,
                                                         action: #selector(self._navBarLeftClicked))
                self.navigationItem.leftBarButtonItem = leftBarButton
            }
            //导航栏右侧标题
            if let icon = navBarRightIcon {
                let rightBarButton = UIBarButtonItem.init(title: "",
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(self._navBarRightClicked))
                rightBarButton.setBackgroundImage(UIImage.init(named: icon)?
                    .withSize(size: CGSize(width: 32, height: 32))
                    , for: .normal, barMetrics: UIBarMetrics.default)
                self.navigationItem.rightBarButtonItem = rightBarButton
            }
            //导航栏显示
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        } else { //导航栏隐藏
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationItem.backBarButtonItem = UIBarButtonItem.init(title: "", style: .plain, target: self, action: nil)
        }
    }
}

//MARK: - 占位视图
extension BaseViewController {
    
    func show_loading() {
        basePlace.show(style: .loading(type: .ballScaleMultiple, options: nil))
    }
    
    func show_place() {
        needReload = false
        basePlace.show(style: .empty(type: .nodata, options: nil))
    }
    
    func hide_place() {
        basePlace.hide()
    }
}

//MARK: - STPlaceDelegate
extension BaseViewController: PlaceDelegate {
    
    func placeViewClicked() {
        if needReload {
            self.hide_place()
            self.reload()
        }
    }
}
