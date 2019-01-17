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


/// Style
public class Style {
    
    /// Effect
    public enum Effect: Equatable {
        
        /// blur effect
        case blur(UIBlurEffect.Style)
        
        /// color
        case color(UIColor)
    }
    
    
    /// set navigationBar.backgroundView's backgroundEffect, default: .blur(.light)
    public var backgroundEffect: Style.Effect?

    /// set navigationBar.backgroundView's backgroundAlpha, default: 1
    public var backgroundAlpha: CGFloat?
    
    /// set navigationBar's tintColor, default: black
    public var tintColor: UIColor?
    
    /// set navigationBar's isWhiteBarStyle, default: false
    public var isWhiteBarStyle: Bool?

    /// set navigationBar's shadowImageAlpha, default: 1
    public var shadowImageAlpha: CGFloat?
    
    /// set navigationBar's isHidden, default: false
    public var isHidden: Bool?
    
    /// update style instantly
    public func update(_ setting: (Style) -> Void) {
        guard let navBar = self._viewController?.navigationController?._manager?.navigationBar else { return }
        let toStyle = Style()
        setting(toStyle)
        navBar.updateNavigationBarAndBackgroundFakeBarStyle(style: self, toStyle: toStyle)
    }
    
    // MARK: - Private
    /// _viewController
    private weak var _viewController: UIViewController?
    
    /// for normal init
    fileprivate init(viewController: UIViewController) {
        // _viewController
        self._viewController = viewController
    }
    
    /// for config style init
    fileprivate init() {}
}


/// Style+Default
extension Style {
    
    /// set navigationBar.backgroundView's backgroundEffect, default: .blur(.light)
    public static var backgroundEffect: Style.Effect = .blur(.light)
    
    /// set navigationBar.backgroundView's backgroundAlpha, default: 1
    public static var backgroundAlpha: CGFloat = 1
    
    /// set navigationBar's tintColor, default: black
    public static var tintColor: UIColor = .black
    
    /// set navigationBar's isWhiteBarStyle, default: false
    public static var isWhiteBarStyle: Bool = false
    
    /// set navigationBar's shadowImageAlpha, default: 1
    public static var shadowImageAlpha: CGFloat = 1
    
    /// set navigationBar's isHidden, default: false
    public static var isHidden: Bool = false
}


/// UIViewController+snb
extension UIViewController {
    
    /// snb
    public var snb: Style {
        get {
            if let style = objc_getAssociatedObject(self, &UIViewController._snbKey) as? Style {
                return style
            } else {
                let style = Style(viewController: self)
                objc_setAssociatedObject(self, &UIViewController._snbKey, style, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return style
            }
        }
    }
    
    /// _snbKey
    private static var _snbKey: Void?
}


/// UINavigationController+init
public extension UINavigationController {
    
    /// init with preference style
    convenience init(preference: ((Style) -> Void)?) {
        self.init(viewControllers: [], preference: preference)
    }
    
    /// init with rootViewController and preference style
    convenience init(rootViewController: UIViewController, preference: ((Style) -> Void)?) {
        self.init(viewControllers: [rootViewController], preference: preference)
    }
    
    /// init with viewControllers and preference style
    convenience init(viewControllers: [UIViewController], preference: ((Style) -> Void)?) {
        self.init(navigationBarClass: _NavigationBar.self, toolbarClass: nil)
        self.viewControllers = viewControllers
        let preferenceStyle = Style()
        preference?(preferenceStyle)
        self._manager = _Manager(self, preferenceStyle: preferenceStyle)
    }
    
    /// _manager
    fileprivate var _manager: _Manager? {
        get { return objc_getAssociatedObject(self, &UINavigationController._managerKey) as? _Manager }
        set { objc_setAssociatedObject(self, &UINavigationController._managerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// _managerKey
    private static var _managerKey: Void?
}


/// _FakeBar
fileprivate class _FakeBar: UIVisualEffectView {
    
    /// preference style
    var preferenceStyle: Style!
    
    /// set style
    func setStyle(_ style: Style) {
        // backgroundEffect
        let backgroundEffect = style.backgroundEffect ?? self.preferenceStyle.backgroundEffect ?? Style.backgroundEffect
        switch backgroundEffect {
        case .blur(let b):
            self.effect = UIBlurEffect(style: b)
            self.backgroundColor = nil
        case .color(let c):
            self.effect = nil
            self.backgroundColor = c
        }
        
        // backgroundAlpha
        self.alpha = style.backgroundAlpha ?? self.preferenceStyle.backgroundAlpha ?? Style.backgroundAlpha
    }
    
    /// update to style
    func updateStyle(_ style: Style, toStyle: Style) {
        // backgroundEffect
        if let toBackgroundEffect = toStyle.backgroundEffect {
            let backgroundEffect = style.backgroundEffect ?? self.preferenceStyle.backgroundEffect ?? Style.backgroundEffect
            if backgroundEffect != toBackgroundEffect {
                style.backgroundEffect = toBackgroundEffect
                switch toBackgroundEffect {
                case .blur(let b):
                    self.effect = UIBlurEffect(style: b)
                    self.backgroundColor = nil
                case .color(let c):
                    self.effect = nil
                    self.backgroundColor = c
                }
            }
        }
        
        // backgroundAlpha
        if let toBackgroundAlpha = toStyle.backgroundAlpha {
            let backgroundAlpha = style.backgroundAlpha ?? self.preferenceStyle.backgroundAlpha ?? Style.backgroundAlpha
            if backgroundAlpha != toBackgroundAlpha {
                style.backgroundAlpha = toBackgroundAlpha
                self.alpha = toBackgroundAlpha
            }
        }
    }
    
    /// is same style for fakeBar
    static func isSameStyle(lhs: Style, rhs: Style, preferenceStyle: Style) -> Bool {
        // backgroundEffect
        let backgroundEffectL = lhs.backgroundEffect ?? preferenceStyle.backgroundEffect ?? Style.backgroundEffect
        let backgroundEffectR = rhs.backgroundEffect ?? preferenceStyle.backgroundEffect ?? Style.backgroundEffect
        
        // backgroundAlpha
        let backgroundAlphaL = lhs.backgroundAlpha ?? preferenceStyle.backgroundAlpha ?? Style.backgroundAlpha
        let backgroundAlphaR = rhs.backgroundAlpha ?? preferenceStyle.backgroundAlpha ?? Style.backgroundAlpha
        
        // check is same Style
        if backgroundEffectL == backgroundEffectR && backgroundAlphaL == backgroundAlphaR {
            return true
        } else {
            return false
        }
    }
}


/// _ShadowImageView
fileprivate class _ShadowImageView: UIImageView {
    
    /// init
    convenience init() {
        self.init(frame: .zero)
        self.backgroundColor = UIColor(white: 0.5, alpha: 1)
    }
}


/// _NavigationBar
fileprivate class _NavigationBar: UINavigationBar {
    
    // MARK: - fileprivate
    /// backgroundFakeBar
    let backgroundFakeBar = _FakeBar()
    
    /// shadowImageView
    let shadowImageView = _ShadowImageView()
    
    /// preference style
    var preferenceStyle: Style! {
        didSet {
            self.backgroundFakeBar.preferenceStyle = self.preferenceStyle
            self.fromFakeBar.preferenceStyle = self.preferenceStyle
            self.toFakeBar.preferenceStyle = self.preferenceStyle
        }
    }
    
    /// set style
    func setStyle(_ style: Style) {
        self.style = style
        
        // tintColor
        self.tintColor = style.tintColor ?? self.preferenceStyle.tintColor ?? Style.tintColor
        
        // isWhiteBarStyle
        let isWhiteBarStyle = style.isWhiteBarStyle ?? self.preferenceStyle.isWhiteBarStyle ?? Style.isWhiteBarStyle
        if isWhiteBarStyle {
            self.barStyle = .black
        } else {
            self.barStyle = .default
        }
        
        // shadowImageAlpha
        self.shadowImageView.alpha = style.shadowImageAlpha ?? self.preferenceStyle.shadowImageAlpha ?? Style.shadowImageAlpha
        
        // isHidden
        let isHidden = style.isHidden ?? self.preferenceStyle.isHidden ?? Style.isHidden
        if isHidden {
            self.alpha = _NavigationBar.allowedMinAlpha
        } else {
            self.alpha = 1
        }
    }
    
    /// update to style
    func updateToStyle(_ toStyle: Style) {
        guard let style = self.style else { return }
        
        // tintColor
        if let toTintColor = toStyle.tintColor {
            let tintColor = style.tintColor ?? self.preferenceStyle.tintColor ?? Style.tintColor
            if tintColor != toTintColor {
                style.tintColor = toTintColor
                self.tintColor = toTintColor
            }
        }
        
        // isWhiteBarStyle
        if let toIsWhiteBarStyle = toStyle.isWhiteBarStyle {
            let isWhiteBarStyle = style.isWhiteBarStyle ?? self.preferenceStyle.isWhiteBarStyle ?? Style.isWhiteBarStyle
            if isWhiteBarStyle != toIsWhiteBarStyle {
                style.isWhiteBarStyle = toIsWhiteBarStyle
                if toIsWhiteBarStyle {
                    self.barStyle = .black
                } else {
                    self.barStyle = .default
                }
            }
        }
        
        // shadowImageAlpha
        if let toShadowImageAlpha = toStyle.shadowImageAlpha {
            let shadowImageAlpha = style.shadowImageAlpha ?? self.preferenceStyle.shadowImageAlpha ?? Style.shadowImageAlpha
            if shadowImageAlpha != toShadowImageAlpha {
                style.shadowImageAlpha = toShadowImageAlpha
                self.shadowImageView.alpha = toShadowImageAlpha
            }
        }
        
        // isHidden
        if let toIsHidden = toStyle.isHidden {
            let isHidden = style.isHidden ?? self.preferenceStyle.isHidden ?? Style.isHidden
            if isHidden != toIsHidden {
                style.isHidden = toIsHidden
                if toIsHidden {
                    self.alpha = _NavigationBar.allowedMinAlpha
                } else {
                    self.alpha = 1
                }
            }
        }
    }
    
    /// update navigationBar and backgroundFakeBar style
    func updateNavigationBarAndBackgroundFakeBarStyle(style: Style, toStyle: Style) {
        // there must be the same reference, else something wrong happened.
        guard self.style === style else { return }
        
        // update navigationBar and backgroundFakeBar style
        self.backgroundFakeBar.updateStyle(style, toStyle: toStyle)
        self.updateToStyle(toStyle)
    }
    
    /// add fromfakeBar to fromVC
    func addFromFakeBar(to fromVC: UIViewController) {
        self.addFakeBar(fakeBar: self.fromFakeBar, to: fromVC)
    }
    
    /// add tofakeBar to toVC
    func addToFakeBar(to toVC: UIViewController) {
        self.addFakeBar(fakeBar: self.toFakeBar, to: toVC)
    }
    
    /// remove fromFakeBar and toFakeBar from superview
    func removeToAndFromFakeBar() {
        self.fromFakeBar.removeFromSuperview()
        self.toFakeBar.removeFromSuperview()
    }
    
    /// is same style for transition
    static func isSameStyle(lhs: Style, rhs: Style, preferenceStyle: Style) -> Bool {
        // isHidden
        let isHiddenL = lhs.isHidden ?? preferenceStyle.isHidden ?? Style.isHidden
        let isHiddenR = rhs.isHidden ?? preferenceStyle.isHidden ?? Style.isHidden
        
        // check is same Style
        if isHiddenL == isHiddenR && _FakeBar.isSameStyle(lhs: lhs, rhs: rhs, preferenceStyle: preferenceStyle) {
            return true
        } else {
            return false
        }
    }
    
    /// layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.frame.width
        let h = self.frame.height
        let x = self.frame.origin.x
        let y = self.frame.origin.y
        
        // backgroundFakeBar
        self.backgroundFakeBar.frame = CGRect(x: 0, y: -y, width: w, height: h + y)
        self.insertSubview(self.backgroundFakeBar, at: 0)
        
        // shadowImageView
        self.shadowImageView.frame = CGRect(x: x, y: h, width: w, height: 0.5)
        self.insertSubview(self.shadowImageView, at: 1)
    }
    
    // MARK: - private
    /// style
    private var style: Style?
    
    /// fromFakeBar
    private let fromFakeBar = _FakeBar()
    
    /// toFakeBar
    private let toFakeBar = _FakeBar()
    
    /// allowed min alpha
    private static let allowedMinAlpha: CGFloat = 0.001
    
    /// add fakeBar to ViewController
    private func addFakeBar(fakeBar: _FakeBar, to vc: UIViewController) {
        guard let preferenceStyle = self.preferenceStyle else { return }
        
        fakeBar.setStyle(vc.snb)
        fakeBar.isHidden = vc.snb.isHidden ?? preferenceStyle.isHidden ?? Style.isHidden
        fakeBar.frame = CGRect(origin: vc.view.bounds.origin, size: self.backgroundFakeBar.bounds.size)
        vc.view.addSubview(fakeBar)
    }
}


/// _Manager
fileprivate class _Manager: NSObject, UINavigationControllerDelegate {
    
    /// navigationController
    private unowned(safe) let navigationController: UINavigationController
    
    /// navigationBar
    var navigationBar: _NavigationBar { return self.navigationController.navigationBar as! _NavigationBar }
    
    /// init
    init(_ navigationController: UINavigationController, preferenceStyle: Style) {
        // navigationController
        self.navigationController = navigationController

        // super init
        super.init()
        
        // config
        self.navigationBar.preferenceStyle = preferenceStyle
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationController.delegate = self
    }
    
    /// UINavigationControllerDelegate
    @objc func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let transitionCoordinator = self.navigationController.transitionCoordinator
        let navBar = self.navigationBar
        
        if let coordinator = transitionCoordinator { // transition with animation
            coordinator.animate(alongsideTransition: { (ctx) in
                guard let fromVC = ctx.viewController(forKey: .from), let toVC = ctx.viewController(forKey: .to) else { return }
                
                // set fake bar style without animation, if there are not same style for transition.
                if _NavigationBar.isSameStyle(lhs: fromVC.snb, rhs: toVC.snb, preferenceStyle: navBar.preferenceStyle) == false {
                    UIView.performWithoutAnimation {
                        // add fromFakeBar to fromVC
                        navBar.addFromFakeBar(to: fromVC)
                        
                        // add toFakeBar to toVC
                        navBar.addToFakeBar(to: toVC)
                        
                        // set backgroundFakeBar
                        navBar.backgroundFakeBar.setStyle(toVC.snb)
                        navBar.backgroundFakeBar.isHidden = true
                    }
                }
                
                // set navigationBar style with animation
                navBar.setStyle(toVC.snb)
                
            }) { (ctx) in
                guard let fromVC = ctx.viewController(forKey: .from) else { return }
                
                // remove fromFakeBar and toFakeBar from superview
                navBar.removeToAndFromFakeBar()
                
                // rollback navigationBar and backgroundFakeBar style if transition is cancelled
                if ctx.isCancelled {
                    navBar.backgroundFakeBar.setStyle(fromVC.snb)
                    navBar.setStyle(fromVC.snb)
                }
                
                // show backgroundFakeBar
                navBar.backgroundFakeBar.isHidden = false
            }
        } else { // transition without animation
            // set navigationBar and backgroundFakeBar style
            let toVC = viewController
            navBar.backgroundFakeBar.setStyle(toVC.snb)
            navBar.setStyle(toVC.snb)
        }
    }
}
