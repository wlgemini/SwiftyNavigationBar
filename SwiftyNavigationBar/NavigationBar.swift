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


/// NavigationBar
internal class NavigationBar: UINavigationBar {
    
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
        self._shadowImageView.frame = CGRect(x: x, y: h, width: w, height: 1.0 / UIScreen.main.scale)
        self.insertSubview(self._shadowImageView, at: 1)
    }
    
    // MARK: - Internal
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
        self._tintColor = style._tintColor ?? preferenceStyle._tintColor ?? Style.tintColor
        
        // isWhiteBarStyle
        let isWhiteBarStyle = style._isWhiteBarStyle ?? preferenceStyle._isWhiteBarStyle ?? Style.isWhiteBarStyle
        if isWhiteBarStyle {
            self._barStyle = .black
        } else {
            self._barStyle = .default
        }
        
        // shadowImageAlpha
        self._shadowImageView.alpha = style._shadowImageAlpha ?? preferenceStyle._shadowImageAlpha ?? Style.shadowImageAlpha
        
        // alpha
        self._alpha = style._alpha ?? preferenceStyle._alpha ?? Style.alpha
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
        if let toTintColor = toStyle._tintColor {
            let tintColor = style._tintColor ?? preferenceStyle._tintColor ?? Style.tintColor
            if tintColor != toTintColor {
                style._tintColor = toTintColor
                self._tintColor = toTintColor
            }
        }
        
        // isWhiteBarStyle
        if let toIsWhiteBarStyle = toStyle._isWhiteBarStyle {
            let isWhiteBarStyle = style._isWhiteBarStyle ?? preferenceStyle._isWhiteBarStyle ?? Style.isWhiteBarStyle
            if isWhiteBarStyle != toIsWhiteBarStyle {
                style._isWhiteBarStyle = toIsWhiteBarStyle
                if toIsWhiteBarStyle {
                    self._barStyle = .black
                } else {
                    self._barStyle = .default
                }
            }
        }
        
        // shadowImageAlpha
        if let toShadowImageAlpha = toStyle._shadowImageAlpha {
            let shadowImageAlpha = style._shadowImageAlpha ?? preferenceStyle._shadowImageAlpha ?? Style.shadowImageAlpha
            if shadowImageAlpha != toShadowImageAlpha {
                style._shadowImageAlpha = toShadowImageAlpha
                self._shadowImageView.alpha = toShadowImageAlpha
            }
        }
        
        // alpha
        if let toAlpha = toStyle._alpha {
            let alpha = style._alpha ?? preferenceStyle._alpha ?? Style.alpha
            if alpha != toAlpha {
                style._alpha = toAlpha
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
        let alphaL = lhs._alpha ?? preferenceStyle._alpha ?? Style.alpha
        let alphaR = rhs._alpha ?? preferenceStyle._alpha ?? Style.alpha
        
        // check is same Style
        if alphaL == alphaR && _FakeBar.isSameStyle(lhs: lhs, rhs: rhs, preferenceStyle: preferenceStyle) {
            return true
        } else {
            return false
        }
    }
    
    // MARK: - Private
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
    
    /// add fakeBar to viewController
    private func addFakeBar(fakeBar: _FakeBar, to vc: UIViewController) {
        guard let preferenceStyle = self.preferenceStyle else { return }
        
        // set fakeBar style & frame without animation
        UIView.performWithoutAnimation {
            // set style
            fakeBar.setStyle(vc.snb, preferenceStyle: preferenceStyle)
            
            // set alpha according to alpha & backgroundAlpha
            let alpha = vc.snb._alpha ?? preferenceStyle._alpha ?? Style.alpha
            let backgroundAlpha = vc.snb._backgroundAlpha ?? preferenceStyle._backgroundAlpha ?? Style.backgroundAlpha
            fakeBar.alpha = alpha * backgroundAlpha
            
            // set frame
            fakeBar.frame = CGRect(origin: vc.view.bounds.origin, size: self._backgroundFakeBar.bounds.size)
            
            // add subview
            vc.view.addSubview(fakeBar)
        }
    }
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
        let backgroundEffect = style._backgroundEffect ?? preferenceStyle._backgroundEffect ?? Style.backgroundEffect
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
        self.alpha = style._backgroundAlpha ?? preferenceStyle._backgroundAlpha ?? Style.backgroundAlpha
    }
    
    /// update to style
    func updateStyle(_ style: Style, toStyle: Style, preferenceStyle: Style) {
        // backgroundEffect
        if let toBackgroundEffect = toStyle._backgroundEffect {
            let backgroundEffect = style._backgroundEffect ?? preferenceStyle._backgroundEffect ?? Style.backgroundEffect
            if backgroundEffect != toBackgroundEffect {
                style._backgroundEffect = toBackgroundEffect
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
        if let toBackgroundAlpha = toStyle._backgroundAlpha {
            let backgroundAlpha = style._backgroundAlpha ?? preferenceStyle._backgroundAlpha ?? Style.backgroundAlpha
            if backgroundAlpha != toBackgroundAlpha {
                style._backgroundAlpha = toBackgroundAlpha
                self.alpha = toBackgroundAlpha
            }
        }
    }
    
    /// is same style for fakeBar
    static func isSameStyle(lhs: Style, rhs: Style, preferenceStyle: Style) -> Bool {
        // backgroundEffect
        let backgroundEffectL = lhs._backgroundEffect ?? preferenceStyle._backgroundEffect ?? Style.backgroundEffect
        let backgroundEffectR = rhs._backgroundEffect ?? preferenceStyle._backgroundEffect ?? Style.backgroundEffect
        
        // backgroundAlpha
        let backgroundAlphaL = lhs._backgroundAlpha ?? preferenceStyle._backgroundAlpha ?? Style.backgroundAlpha
        let backgroundAlphaR = rhs._backgroundAlpha ?? preferenceStyle._backgroundAlpha ?? Style.backgroundAlpha
        
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
        self.backgroundColor = .black
    }
}
