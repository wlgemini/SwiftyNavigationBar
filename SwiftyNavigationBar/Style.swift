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


/// Style
public class Style {
    
    /// set navigationBar.backgroundView's backgroundEffect, default: .blur(.light)
    public var backgroundEffect: Style.Effect? {
        get { return self._backgroundEffect }
        set { self._backgroundEffect = newValue }
    }
    
    /// set navigationBar.backgroundView's backgroundAlpha, default: 1
    public var backgroundAlpha: CGFloat? {
        get { return self._backgroundAlpha }
        set {
            if let nv = newValue {
                if nv > 1 {
                    self._backgroundAlpha = 1
                } else if nv < 0 {
                    self._backgroundAlpha = 0
                } else {
                    self._backgroundAlpha = nv
                }
            } else {
                self._backgroundAlpha = nil
            }
        }
    }
    
    /// set navigationBar's tintColor, default: black
    public var tintColor: UIColor? {
        get { return self._tintColor }
        set { self._tintColor = newValue }
    }
    
    /// set navigationBar's isWhiteBarStyle, default: false
    public var isWhiteBarStyle: Bool? {
        get { return self._isWhiteBarStyle }
        set { self._isWhiteBarStyle = newValue }
    }
    
    /// set navigationBar's shadowImageAlpha, default: 0.5
    public var shadowImageAlpha: CGFloat? {
        get { return self._shadowImageAlpha }
        set {
            if let nv = newValue {
                if nv > 1 {
                    self._shadowImageAlpha = nv
                } else if nv < 0 {
                    self._shadowImageAlpha = 0
                } else {
                    self._shadowImageAlpha = nv
                }
            } else {
                self._shadowImageAlpha = nil
            }
        }
    }
    
    /// set navigationBar's alpha, default: 1
    public var alpha: CGFloat? {
        get { return self._alpha }
        set {
            if let nv = newValue {
                if nv > 1 {
                    self._alpha = 1
                } else if nv < 0 {
                    self._alpha = 0
                } else {
                    self._alpha = nv
                }
            } else {
                self._alpha = nil
            }
        }
    }
    
    /// update style instantly
    public func update(_ setting: (Style) -> Void) {
        guard let navBar = self._viewController?.navigationController?.proxy?.navigationBar else { return }
        
        let toStyle = Style()
        setting(toStyle)
        navBar.update(fromStyle: self, toStyle: toStyle)
    }
    
    // MARK: - Internal
    /// Style property's backstore
    var _backgroundEffect: Style.Effect?
    var _backgroundAlpha: CGFloat?
    var _tintColor: UIColor?
    var _isWhiteBarStyle: Bool?
    var _shadowImageAlpha: CGFloat?
    var _alpha: CGFloat?
    
    /// for normal init
    internal init(viewController: UIViewController) {
        // _viewController
        self._viewController = viewController
    }
    
    /// for config style init
    internal init() {}
    
    // MARK: - Private
    /// _viewController
    private weak var _viewController: UIViewController?
}


/// Style(Default)
extension Style {
    
    /// set navigationBar.backgroundView's backgroundEffect, default: .blur(.light)
    public static var backgroundEffect: Style.Effect = .blur(.light)
    
    /// set navigationBar.backgroundView's backgroundAlpha, default: 1
    public static var backgroundAlpha: CGFloat = 1
    
    /// set navigationBar's tintColor, default: black
    public static var tintColor: UIColor = .black
    
    /// set navigationBar's isWhiteBarStyle, default: false
    public static var isWhiteBarStyle: Bool = false
    
    /// set navigationBar's shadowImageAlpha, default: 0.5
    public static var shadowImageAlpha: CGFloat = 0.5
    
    /// set navigationBar's alpha, default: 1
    public static var alpha: CGFloat = 1
}


extension Style {
    
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
}
