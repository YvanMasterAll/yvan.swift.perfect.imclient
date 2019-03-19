//
//  AppDelegate.swift
//  IMClient
//
//  Created by Yiqiang Zeng on 2019/3/7.
//  Copyright © 2019 Yiqiang Zeng. All rights reserved.
//

import UIKit
import WatchdogInspector

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    //MARK: - 声明区域
    var window          : UIWindow?
    var rotationLock    : Bool = true //横竖屏锁定

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //MARK: - 创建窗口
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        //MARK: - 环境初始化
        Environment.initialize()
        //MARK: - FPS
        #if DEBUG
        TWWatchdogInspector.setEnableMainthreadStallingException(false)
        TWWatchdogInspector.setUseLogs(false)
        TWWatchdogInspector.start()
        #endif
        //MARK: - Test
        setupTest()
        
        return true
    }
    
    //MARK: - Test
    func setupTest() {
        var vc: BaseViewController!
        //yTest
        Environment.clearUser()
        if Environment.tokened {
             vc = ChatDialogVC.storyboard(from: "Chat")
        } else {
            vc = UserSigninVC.storyboard(from: "User")
        }
        let nc = BaseNavigationController(rootViewController: vc)
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }
    
    //MARK: - 应用扩展
    func application(_ application: UIApplication,
                     shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        //MARK: - 键盘扩展
        if extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard {
            if let navs = window?.rootViewController?.children[0].children { //所有导航
                for nav in navs {                                            //导航遍历
                    for vc in nav.children {                                 //VC遍历
                        if vc is BaseViewController {                        //VC判断
                            return (vc as! BaseViewController).thirdKeyboard
                        }
                    }
                }
            }
        }
        return true
    }
    
    //MARK: - 横竖屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if self.rotationLock {
            return UIInterfaceOrientationMask.portrait
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}

