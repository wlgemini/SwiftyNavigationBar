Pod::Spec.new do |s|
    s.name             = 'SwiftyNavigationBar'
    s.version          = '5.0.0'
    s.summary          = 'An easy way to customizing NavigationBar.'
    s.homepage         = 'https://github.com/wlgemini/SwiftyNavigationBar'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'wlgemini' => 'wangluguang@live.com' }
    s.source           = { :git => 'https://github.com/wlgemini/SwiftyNavigationBar.git', :tag => s.version.to_s }
    s.ios.deployment_target = '8.0'
    s.source_files     = 'SwiftyNavigationBar/*.swift'
    s.swift_version    = '5.0'
    s.frameworks       = 'UIKit'
end
