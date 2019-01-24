//
//  AppDelegate.swift
//

import UIKit
import SwiftyNavigationBar

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        // 设置全局样式
        Style.isWhiteBarStyle = false
        Style.shadowImageAlpha = 1
        
        // settingNav
        let settingNav = UINavigationController(rootViewController: SettingViewController(), preference: { (style) in
            style.backgroundEffect = .blur(.light)
        })
        settingNav.tabBarItem = UITabBarItem(title: "Setting", image: nil, selectedImage: nil)
        
        // mineNav
        let mineNav = UINavigationController(rootViewController: MineViewController(), preference: nil)
        mineNav.tabBarItem = UITabBarItem(title: "Mine", image: nil, selectedImage: nil)
        
        // tabBar
        let tabBar = UITabBarController()
        tabBar.viewControllers = [settingNav, mineNav]
        
        
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        return true
    }
}

