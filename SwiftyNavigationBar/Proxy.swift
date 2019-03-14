//
//  SwiftyNavigationBar
//
//  Copyright (c) 2019-Present wlgemini <wangluguang@live.com>.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.


import UIKit


/// Proxy
internal class Proxy: NSObject, UINavigationControllerDelegate {
    
    /// navigationBar
    var navigationBar: NavigationBar { return self._navigationController.navigationBar as! NavigationBar }
    
    /// init
    init(_ navigationController: UINavigationController, preferenceStyle: Style) {
        // navigationController
        self._navigationController = navigationController
        
        // super init
        super.init()
        
        // config
        self.navigationBar.preferenceStyle = preferenceStyle
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self._navigationController.delegate = self
    }
    
    /// UINavigationControllerDelegate
    @objc func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let transitionCoordinator = self._navigationController.transitionCoordinator
        let navBar = self.navigationBar
        guard let preferenceStyle = navBar.preferenceStyle else { return }
        
        if let coordinator = transitionCoordinator { // transition with animation
            coordinator.animate(alongsideTransition: { (ctx) in
                guard let fromVC = ctx.viewController(forKey: .from), let toVC = ctx.viewController(forKey: .to) else { return }
                
                // set fake bar style without animation, if there are not same style for transition.
                if NavigationBar.isSameStyle(lhs: fromVC.snb, rhs: toVC.snb, preferenceStyle: preferenceStyle) == false {
                    // add fromFakeBar to fromVC
                    navBar.addFromFakeBar(to: fromVC)
                    
                    // add toFakeBar to toVC
                    navBar.addToFakeBar(to: toVC)
                    
                    // hidden backgroundFakeBar
                    navBar.isBackgroundFakeBarHidden = true
                }
                
                // set navigationBar style with animation
                navBar.setStyle(toVC.snb)
                
            }) { (ctx) in
                guard let fromVC = ctx.viewController(forKey: .from) else { return }
                
                // remove fromFakeBar and toFakeBar from superview
                navBar.removeToAndFromFakeBar()
                
                // rollback navigationBar and backgroundFakeBar style if transition is cancelled
                if ctx.isCancelled {
                    navBar.setStyle(fromVC.snb)
                }
                
                // show backgroundFakeBar
                navBar.isBackgroundFakeBarHidden = false
            }
        } else { // transition without animation
            // set navigationBar and backgroundFakeBar style
            let toVC = viewController
            navBar.setStyle(toVC.snb)
        }
    }
    
    // MARK: - Private
    /// navigationController
    private unowned(safe) let _navigationController: UINavigationController
}
