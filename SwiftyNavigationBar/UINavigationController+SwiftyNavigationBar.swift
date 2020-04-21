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


/// UINavigationController(Init)
public extension UINavigationController {
    
    /// init with preference style
    convenience init(preference: ((Style) -> Void)?) {
        self.init(viewControllers: [], toolbarClass: nil, preference: preference)
    }
    
    /// init with rootViewController and preference style
    convenience init(rootViewController: UIViewController, preference: ((Style) -> Void)?) {
        self.init(viewControllers: [rootViewController], toolbarClass: nil, preference: preference)
    }
    
    /// init with viewControllers and preference style
    convenience init(viewControllers: [UIViewController], preference: ((Style) -> Void)?) {
        self.init(viewControllers: viewControllers, toolbarClass: nil, preference: preference)
    }
    
    /// init with viewControllers, toolbarClass and preference style
    convenience init(viewControllers: [UIViewController], toolbarClass: AnyClass?, preference: ((Style) -> Void)?) {       
        // init
        self.init(navigationBarClass: NavigationBar.self, toolbarClass: toolbarClass)
        
        // config
        self.viewControllers = viewControllers
        let preferenceStyle = Style()
        preference?(preferenceStyle)
        let proxy = Proxy(self, preferenceStyle: preferenceStyle)
        self.proxy = proxy

        // set delegate
        self.delegate = proxy
    }
    
    /// proxy
    internal var proxy: Proxy? {
        get { return objc_getAssociatedObject(self, &UINavigationController._proxyKey) as? Proxy }
        set { objc_setAssociatedObject(self, &UINavigationController._proxyKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    // MARK: - Private
    /// proxy key
    private static var _proxyKey: Void?
}
