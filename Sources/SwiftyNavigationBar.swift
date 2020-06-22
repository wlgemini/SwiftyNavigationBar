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
public class SwiftyNavigationBar {
    
    /// current view controller's navigation bar style
    public let style: Style = Style()
    
    /// use this as UINavigationController.delegate
    public weak var navigationControllerDelegate: UINavigationControllerDelegate? {
        get {
            return self._navigationController?.proxy?.navigationControllerDelegate ?? self._navigationController?.delegate
        }
        set {
            if let proxy = self._navigationController?.proxy {
                // bugfix: reset navigationController.delegate
                self._navigationController?.delegate = nil
                proxy.navigationControllerDelegate = newValue
                self._navigationController?.delegate = proxy
            } else {
                self._navigationController?.delegate = newValue
            }
        }
    }
    
    /// update style instantly
    public func updateStyle(_ setting: (Style) -> Void) {
        guard let navBar = self._navigationController?.proxy?.navigationBar else { return }
        
        let toStyle = Style()
        setting(toStyle)
        navBar.update(fromStyle: self.style, toStyle: toStyle)
    }
    
    /// init
    internal init(viewController: UIViewController) {
        self._viewController = viewController
    }
    
    // MARK: - Private
    /// _viewController
    private unowned(safe) var _viewController: UIViewController
    /// _navigationController
    private var _navigationController: UINavigationController? {
        if let nav = self._viewController as? UINavigationController {
            return nav
        } else {
            return self._viewController.navigationController
        }
    }
}
