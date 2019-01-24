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
        
        /// image
        case image(UIImage, UIView.ContentMode)
        
        /// color
        case color(UIColor)
        
        /// ==
        public static func == (lhs: Effect, rhs: Effect) -> Bool {
            if case .blur(let styleL) = lhs, case .blur(let styleR) = rhs {
                return styleL == styleR
            }
            else if case .image(let imageL, let modeL) = lhs, case .image(let imageR, let modeR) = rhs {
                return imageL.pngData() == imageR.pngData() && modeL == modeR
            }
            else if case .color(let colorL) = lhs, case .color(let colorR) = rhs {
                return colorL == colorR
            }
            else {
                return false
            }
        }
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
    
    /// set navigationBar's alpha, default: 1
    public var alpha: CGFloat?
    
    /// update style instantly
    public func update(_ setting: (Style) -> Void) {
        guard let navBar = self._viewController?.navigationController?._manager?.navigationBar else { return }
        
        let toStyle = Style()
        setting(toStyle)
        navBar.update(fromStyle: self, toStyle: toStyle)
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
    
    /// set navigationBar's alpha, default: 1
    public static var alpha: CGFloat = 1
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
fileprivate class _FakeBar: UIView {
    
    // MARK: - For override system logic
    /// init
    convenience init() {
        self.init(frame: .zero)
        
        // _blurView
        self._blurView = UIVisualEffectView()
        self.addSubview(self._blurView)
        
        // _imageView
        self._imageView = UIImageView()
        self._imageView.clipsToBounds = true
        self.addSubview(self._imageView)
        
        // _colorView
        self._colorView = UIView()
        self.addSubview(self._colorView)
    }
    
    /// layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self._blurView.frame = self.bounds
        self._imageView.frame = self.bounds
        self._colorView.frame = self.bounds
    }
    
    // MARK: - Fileprivate
    /// set style
    func setStyle(_ style: Style, preferenceStyle: Style) {
        // backgroundEffect
        let backgroundEffect = style.backgroundEffect ?? preferenceStyle.backgroundEffect ?? Style.backgroundEffect
        self._blurView.isHidden = true
        self._imageView.isHidden = true
        self._colorView.isHidden = true
        switch backgroundEffect {
        case .blur(let b):
            self._blurView.effect = UIBlurEffect(style: b)
            self._blurView.isHidden = false
            
        case .image(let i, let c):
            self._imageView.image = i
            self._imageView.contentMode = c
            self._imageView.isHidden = false
            
        case .color(let c):
            self._colorView.backgroundColor = c
            self._colorView.isHidden = false
        }
        
        // backgroundAlpha
        self.alpha = style.backgroundAlpha ?? preferenceStyle.backgroundAlpha ?? Style.backgroundAlpha
    }
    
    /// update to style
    func updateStyle(_ style: Style, toStyle: Style, preferenceStyle: Style) {
        // backgroundEffect
        if let toBackgroundEffect = toStyle.backgroundEffect {
            let backgroundEffect = style.backgroundEffect ?? preferenceStyle.backgroundEffect ?? Style.backgroundEffect
            if backgroundEffect != toBackgroundEffect {
                style.backgroundEffect = toBackgroundEffect
                self._blurView.isHidden = true
                self._imageView.isHidden = true
                self._colorView.isHidden = true
                switch toBackgroundEffect {
                case .blur(let b):
                    self._blurView.effect = UIBlurEffect(style: b)
                    self._blurView.isHidden = false
                    
                case .image(let i, let c):
                    self._imageView.image = i
                    self._imageView.contentMode = c
                    self._imageView.isHidden = false
                    
                case .color(let c):
                    self._colorView.backgroundColor = c
                    self._colorView.isHidden = false
                }
            }
        }
        
        // backgroundAlpha
        if let toBackgroundAlpha = toStyle.backgroundAlpha {
            let backgroundAlpha = style.backgroundAlpha ?? preferenceStyle.backgroundAlpha ?? Style.backgroundAlpha
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
    
    // MARK: - Private
    private var _blurView: UIVisualEffectView!
    private var _imageView: UIImageView!
    private var _colorView: UIView!
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
    
    // MARK: - For override system logic
    /// tintColor
    override var tintColor: UIColor! {
        get { return super.tintColor }
        set { super.tintColor = self._tintColor }
    }
    
    /// barStyle
    override var barStyle: UIBarStyle {
        get { return super.barStyle }
        set { super.barStyle = self._barStyle }
    }
    
    /// alpha
    override var alpha: CGFloat {
        get { return super.alpha }
        set { super.alpha = self._alpha }
    }
    
    /// layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let w = self.frame.width
        let h = self.frame.height
        let x = self.frame.origin.x
        let y = self.frame.origin.y
        
        // backgroundFakeBar
        self._backgroundFakeBar.frame = CGRect(x: 0, y: -y, width: w, height: h + y)
        self.insertSubview(self._backgroundFakeBar, at: 0)
        
        // shadowImageView
        self._shadowImageView.frame = CGRect(x: x, y: h, width: w, height: 0.25)
        self.insertSubview(self._shadowImageView, at: 1)
    }
    
    // MARK: - fileprivate
    /// preference style
    var preferenceStyle: Style?
    
    /// isBackgroundFakeBarHidden
    var isBackgroundFakeBarHidden: Bool {
        get { return self._backgroundFakeBar.isHidden }
        set { self._backgroundFakeBar.isHidden = newValue }
    }
    
    /// set style
    func setStyle(_ style: Style) {
        // preferenceStyle
        guard let preferenceStyle = self.preferenceStyle else { return }
        // style
        self._style = style
        
        // backgroundFakeBar (without animation)
        UIView.performWithoutAnimation {
            self._backgroundFakeBar.setStyle(style, preferenceStyle: preferenceStyle)
        }
        
        // tintColor
        self._tintColor = style.tintColor ?? preferenceStyle.tintColor ?? Style.tintColor
        
        // isWhiteBarStyle
        let isWhiteBarStyle = style.isWhiteBarStyle ?? preferenceStyle.isWhiteBarStyle ?? Style.isWhiteBarStyle
        if isWhiteBarStyle {
            self._barStyle = .black
        } else {
            self._barStyle = .default
        }
        
        // shadowImageAlpha
        self._shadowImageView.alpha = style.shadowImageAlpha ?? preferenceStyle.shadowImageAlpha ?? Style.shadowImageAlpha
        
        // alpha
        self._alpha = style.alpha ?? preferenceStyle.alpha ?? Style.alpha
    }
    
    /// update to style
    func update(fromStyle: Style, toStyle: Style) {
        // style
        guard let style = self._style else { return }
        // preferenceStyle
        guard let preferenceStyle = self.preferenceStyle else { return }
        // there must be the same reference, else something wrong happened.
        guard style === fromStyle else { return }
        
        // backgroundFakeBar
        self._backgroundFakeBar.updateStyle(style, toStyle: toStyle, preferenceStyle: preferenceStyle)
        
        // tintColor
        if let toTintColor = toStyle.tintColor {
            let tintColor = style.tintColor ?? preferenceStyle.tintColor ?? Style.tintColor
            if tintColor != toTintColor {
                style.tintColor = toTintColor
                self._tintColor = toTintColor
            }
        }
        
        // isWhiteBarStyle
        if let toIsWhiteBarStyle = toStyle.isWhiteBarStyle {
            let isWhiteBarStyle = style.isWhiteBarStyle ?? preferenceStyle.isWhiteBarStyle ?? Style.isWhiteBarStyle
            if isWhiteBarStyle != toIsWhiteBarStyle {
                style.isWhiteBarStyle = toIsWhiteBarStyle
                if toIsWhiteBarStyle {
                    self._barStyle = .black
                } else {
                    self._barStyle = .default
                }
            }
        }
        
        // shadowImageAlpha
        if let toShadowImageAlpha = toStyle.shadowImageAlpha {
            let shadowImageAlpha = style.shadowImageAlpha ?? preferenceStyle.shadowImageAlpha ?? Style.shadowImageAlpha
            if shadowImageAlpha != toShadowImageAlpha {
                style.shadowImageAlpha = toShadowImageAlpha
                self._shadowImageView.alpha = toShadowImageAlpha
            }
        }
        
        // alpha
        if let toAlpha = toStyle.alpha {
            let alpha = style.alpha ?? preferenceStyle.alpha ?? Style.alpha
            if alpha != toAlpha {
                style.alpha = toAlpha
                self._alpha = toAlpha
            }
        }
    }
    
    /// add fromfakeBar to fromVC
    func addFromFakeBar(to fromVC: UIViewController) {
        self.addFakeBar(fakeBar: self._fromFakeBar, to: fromVC)
    }
    
    /// add tofakeBar to toVC
    func addToFakeBar(to toVC: UIViewController) {
        self.addFakeBar(fakeBar: self._toFakeBar, to: toVC)
    }
    
    /// remove fromFakeBar and toFakeBar from superview
    func removeToAndFromFakeBar() {
        self._fromFakeBar.removeFromSuperview()
        self._toFakeBar.removeFromSuperview()
    }
    
    /// is same style for transition
    static func isSameStyle(lhs: Style, rhs: Style, preferenceStyle: Style) -> Bool {
        // alpha
        let alphaL = lhs.alpha ?? preferenceStyle.alpha ?? Style.alpha
        let alphaR = rhs.alpha ?? preferenceStyle.alpha ?? Style.alpha
        
        // check is same Style
        if alphaL == alphaR && _FakeBar.isSameStyle(lhs: lhs, rhs: rhs, preferenceStyle: preferenceStyle) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - private
    /// for override tintColor logic
    private var _tintColor: UIColor = Style.tintColor {
        didSet { self.tintColor = self._tintColor }
    }
    
    /// for override barStyle logic
    private var _barStyle: UIBarStyle = Style.isWhiteBarStyle ? .black : .default {
        didSet { self.barStyle = self._barStyle }
    }
    
    /// for override alpha logic
    private var _alpha: CGFloat = Style.alpha {
        didSet { self.alpha = self._alpha }
    }
    
    /// style
    private var _style: Style?
    
    /// backgroundFakeBar
    private let _backgroundFakeBar = _FakeBar()
    
    /// shadowImageView
    private let _shadowImageView = _ShadowImageView()
    
    /// fromFakeBar
    private let _fromFakeBar = _FakeBar()
    
    /// toFakeBar
    private let _toFakeBar = _FakeBar()
    
    /// add fakeBar to ViewController
    private func addFakeBar(fakeBar: _FakeBar, to vc: UIViewController) {
        guard let preferenceStyle = self.preferenceStyle else { return }
        
        UIView.performWithoutAnimation {
            fakeBar.setStyle(vc.snb, preferenceStyle: preferenceStyle)
            fakeBar.alpha = vc.snb.alpha ?? preferenceStyle.alpha ?? Style.alpha
            fakeBar.frame = CGRect(origin: vc.view.bounds.origin, size: self._backgroundFakeBar.bounds.size)
            vc.view.addSubview(fakeBar)
        }
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
        guard let preferenceStyle = navBar.preferenceStyle else { return }
        
        if let coordinator = transitionCoordinator { // transition with animation
            coordinator.animate(alongsideTransition: { (ctx) in
                guard let fromVC = ctx.viewController(forKey: .from), let toVC = ctx.viewController(forKey: .to) else { return }
                
                // set fake bar style without animation, if there are not same style for transition.
                if _NavigationBar.isSameStyle(lhs: fromVC.snb, rhs: toVC.snb, preferenceStyle: preferenceStyle) == false {
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
}
