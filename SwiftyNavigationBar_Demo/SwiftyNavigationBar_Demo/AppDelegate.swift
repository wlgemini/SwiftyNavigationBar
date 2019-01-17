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
        
        Style.isWhiteBarStyle = false
        
        let vc0 = TableViewController()
        let nav0 = UINavigationController(rootViewController: vc0) { (style) in
            style.backgroundEffect = .blur(.light)
        }
        nav0.tabBarItem = UITabBarItem(title: "VC0", image: nil, selectedImage: nil)
        
        let vc1 = TableViewController()
        let nav1 = UINavigationController(rootViewController: vc1) { (style) in
            style.backgroundEffect = .blur(.dark)
        }
        nav1.tabBarItem = UITabBarItem(title: "VC1", image: nil, selectedImage: nil)
        
        let vc2 = TableViewController()
        let nav2 = UINavigationController(rootViewController: vc2) { (style) in
            style.backgroundEffect = .color(.gray)
        }
        nav2.tabBarItem = UITabBarItem(title: "VC2", image: nil, selectedImage: nil)
        
        let vc3 = TableViewController()
        let nav3 = UINavigationController(rootViewController: vc3) { (style) in
            style.backgroundEffect = .color(.black)
        }
        nav3.tabBarItem = UITabBarItem(title: "VC3", image: nil, selectedImage: nil)
        
        let tabBar = UITabBarController()
        tabBar.viewControllers = [nav0, nav1, nav2, nav3]
        
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        return true
    }
    
}

