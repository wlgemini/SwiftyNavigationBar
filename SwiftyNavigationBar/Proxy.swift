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
internal class Proxy: NSObject {
    
    /// navigationController delegate
    weak var navigationControllerDelegate: UINavigationControllerDelegate?
    
    /// navigationBar
    var navigationBar: NavigationBar { return self._navigationController.navigationBar as! NavigationBar }
    
    /// init
    init(_ navigationController: UINavigationController, preferenceStyle: Style) {
        // navigationController
        self._navigationController = navigationController
        
        // super init
        super.init()
        
        // config navigationBar
        self.navigationBar.preferenceStyle = preferenceStyle
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
    }
    
    // MARK: - Private
    /// navigationController
    private unowned(safe) let _navigationController: UINavigationController
}


/// Proxy (UINavigationControllerDelegate)
extension Proxy: UINavigationControllerDelegate {
    
    // MARK: - Forwarding message call to UINavigationController.delegate if self (Proxy) don't respond
    override func responds(to aSelector: Selector!) -> Bool {
        if #selector(Proxy.navigationController(_:willShow:animated:)) == aSelector {
            return true
        } else {
            return self.navigationControllerDelegate?.responds(to: aSelector) ?? false
        }
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return self.navigationControllerDelegate
    }
    
    // MARK: - UINavigationControllerDelegate
    @objc func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let preferenceStyle = self.navigationBar.preferenceStyle {
            let navBar = self.navigationBar
            let transitionCoordinator = self._navigationController.transitionCoordinator
            
            if let coordinator = transitionCoordinator { // transition with animation
                coordinator.animate(alongsideTransition: { (ctx) in
                    guard let fromVC = ctx.viewController(forKey: .from), let toVC = ctx.viewController(forKey: .to) else { return }
                    
                    // set fake bar style without animation, if there are not same style for transition.
                    if NavigationBar.isSameStyle(lhs: fromVC.snb.style, rhs: toVC.snb.style, preferenceStyle: preferenceStyle) == false {
                        // add fromFakeBar to fromVC
                        navBar.addFromFakeBar(to: fromVC)
                        
                        // add toFakeBar to toVC
                        navBar.addToFakeBar(to: toVC)
                        
                        // hidden backgroundFakeBar
                        navBar.isBackgroundFakeBarHidden = true
                    }
                    
                    // set navigationBar style with animation
                    navBar.setStyle(toVC.snb.style)
                    
                }) { (ctx) in
                    guard let fromVC = ctx.viewController(forKey: .from) else { return }
                    
                    // remove fromFakeBar and toFakeBar from superview
                    navBar.removeToAndFromFakeBar()
                    
                    // rollback navigationBar and backgroundFakeBar style if transition is cancelled
                    if ctx.isCancelled {
                        navBar.setStyle(fromVC.snb.style)
                    }
                    
                    // show backgroundFakeBar
                    navBar.isBackgroundFakeBarHidden = false
                }
            } else { // transition without animation
                // set navigationBar and backgroundFakeBar style
                let toVC = viewController
                navBar.setStyle(toVC.snb.style)
            }
        }
        
        /// call navigationController delegate
        self.navigationControllerDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
    }
}
