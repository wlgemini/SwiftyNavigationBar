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
        Style.shadowImageAlpha = 0.25
        
        // settingNav
        let settingNav = UINavigationController(rootViewController: SettingViewController(), preference: { (style) in
            style.backgroundEffect = .blur(.light)
        })
        settingNav.tabBarItem = UITabBarItem(title: "Setting", image: nil, selectedImage: nil)
        settingNav.snb.navigationControllerDelegate = self
        
        // tabBar
        let tabBar = UITabBarController()
        tabBar.viewControllers = [settingNav]
        
        
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        return true
    }
}

extension AppDelegate: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
    }
    
    
    /*
    func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
        print(#function)
    }
    
    func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
        print(#function)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print(#function)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print(#function)
    }
     */
}

