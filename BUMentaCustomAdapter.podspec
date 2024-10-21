Pod::Spec.new do |s|
    s.name             = 'BUMentaCustomAdapter'
    s.version          = '6.00.16'
    s.summary          = 'BUMentaCustomAdapter.podspec.'
    s.description      = 'This is the BUMentaCustomAdapter.podspec. Please proceed to https://www.mentamob.com for more information.'
    s.homepage         = 'https://www.mentamob.com/'
    s.license          = "Custom"
    s.author           = { 'wzy' => 'wangzeyong@mentamob.com' }
    s.source           = { :git => "https://github.com/JiaDingYi/GroMoreDemo.git", :tag => "#{s.version}" }
  
    s.ios.deployment_target = '11.0'
    s.frameworks = 'UIKit', 'MapKit', 'MediaPlayer', 'CoreLocation', 'AdSupport', 'CoreMedia', 'AVFoundation', 'CoreTelephony', 'StoreKit', 'SystemConfiguration', 'MobileCoreServices', 'CoreMotion', 'Accelerate','AudioToolbox','JavaScriptCore','Security','CoreImage','AudioToolbox','ImageIO','QuartzCore','CoreGraphics','CoreText'
    s.libraries = 'c++', 'resolv', 'z', 'sqlite3', 'bz2', 'xml2', 'iconv', 'c++abi'
    s.weak_frameworks = 'WebKit', 'AdSupport'
    s.static_framework = true
  
    s.source_files = 'BUMentaCustomAdapter/**/*'

    s.dependency 'MentaVlionBaseSDK', '~> 6.00.16'
    s.dependency 'MentaUnifiedSDK',   '~> 6.00.16'
    s.dependency 'MentaVlionSDK',     '~> 6.00.16'
    s.dependency 'MentaVlionAdapter', '~> 6.00.16'
    s.dependency 'Ads-CN-Beta'
    s.dependency 'Ads-CN-Beta/CSJMediation'
  
  end