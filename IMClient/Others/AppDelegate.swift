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
    var window: UIWindow?

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
        let vc = ChatVC.storyboard(from: "Chat")
        let nc = BaseNavigationController(rootViewController: vc)
        self.window?.rootViewController = nc
        self.window?.makeKeyAndVisible()
    }

    func applicationWillResignActive(_ application: UIApplication) { }

    func applicationDidEnterBackground(_ application: UIApplication) { }

    func applicationWillEnterForeground(_ application: UIApplication) { }

    func applicationDidBecomeActive(_ application: UIApplication) { }

    func applicationWillTerminate(_ application: UIApplication) { }
}

