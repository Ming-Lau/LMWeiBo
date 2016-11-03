//
//  AppDelegate.swift
//  LMWeiBo
//
//  Created by 刘明 on 16/4/21.
//  Copyright © 2016年 LM. All rights reserved.
//

import UIKit
//切换控制器通知
let LMSwitchRootViewControllerKey = "LMSwitchRootViewControllerKey"
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //注册通知
        NotificationCenter.default.addObserver(self, selector:#selector(AppDelegate.switchViewController(_:)) , name: NSNotification.Name(rawValue: LMSwitchRootViewControllerKey), object: nil);
        //设置tabbar 和  navgationbar的颜色  在这里设置之后 全局有效
        UINavigationBar.appearance().tintColor = UIColor.orange
        UITabBar.appearance().tintColor = UIColor.orange
        //1.创建窗口
        window = UIWindow(frame :UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        //2.设置跟控制器
        window?.rootViewController = defaultController()
        //3.显示窗口
        window?.makeKeyAndVisible()
        return true
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
    
    func switchViewController(_ notify : Notification) {
        if notify.object as! Bool {
            window?.rootViewController = MainViewController()
        }
        else{
            window?.rootViewController = WelcomeViewController()
        }
    }
    
    //默认控制器
    fileprivate func defaultController()-> UIViewController{
        if UserAccount.userLogin() {
            return isNewUpdate() ? NewFeatureCollectionViewController() : WelcomeViewController()
        }
        return MainViewController()
    }
    
    fileprivate func isNewUpdate()->Bool{
        //1.获取当前软件版本号
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        //2.获取以前的版本号.从本地文件中读取.以前存储的
        let sandboxVersion = UserDefaults.standard.object(forKey: "CFBundleShortVersionString") as? String ?? ""
        //3.比较当前的版本号和以前的版本号
        if currentVersion.compare(sandboxVersion) == ComparisonResult.orderedDescending {
            //        3.1 如果当前的>以前的有新版本
            //        3.1.1存储当前的版本
            UserDefaults.standard.set(currentVersion, forKey: "CFBundleShortVersionString")
            return true
        }
        //3.2如果当前版本> = 没有新版本
        return false
    }

}

