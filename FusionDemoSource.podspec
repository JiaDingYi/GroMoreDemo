Pod::Spec.new do |s|
  s.name         = "FusionDemoSource"
  s.version      = "1.0.0.0"
  s.license  = 'MIT'
  s.summary      = "FusionDemoSource"
  s.description  = "FusionDemoSource"
  s.homepage     = "https://github.com/bytedance/Bytedance-UnionAD"
  s.authors      = { "xuzhijun" => "xuzhijun.644@bytedance.com"}
  s.platform     = :ios, "10.0"
  s.source       = { :git => "git@code.byted.org:TTIOS/tt_sdk_CSJ.git", :branch => 'v00000'}
  s.frameworks = "UIKit", "CoreFoundation"
  s.weak_frameworks = 'AppTrackingTransparency', 'CoreML', 'DeviceCheck'
#  s.libraries = 'z', 'bz2', 'resolv.9', 'c++', 'sqlite3', 'xml2', 'iconv'
  
  s.requires_arc = true

  s.pod_target_xcconfig = {
    'CODE_SIGNING_ALLOWED' => 'NO'
  }
  
  s.default_subspec = ['Demo']
  
  s.subspec 'Demo' do |ss|
    
    ss.dependency 'FusionDemoSource/CSJDemoSource'
    ss.dependency 'FusionDemoSource/MediationCustomAdapter'
    
  end
  
  
  
  s.subspec 'CSJDemoSource' do |ss|
    
    ss.public_header_files = "DomesticDemo/BUDemo/App/**/*.h"
    ss.source_files = "DomesticDemo/BUDemo/App/**/*.{h,m,a,c,mm,pch}"
    ss.prefix_header_file = 'DomesticDemo/BUDemo/PrefixHeader.pch'
    ss.exclude_files = "DomesticDemo/BUDemo/App/Example/controller/ugen/*.*"
    
    # 公共的第三方库
    ss.dependency 'AFNetworking'
    ss.dependency 'Masonry'
    ss.dependency 'MBProgressHUD'
    ss.dependency 'MJRefresh'
    ss.dependency 'SDWebImage'
    
    # Demo 资源
    ss.dependency 'FusionDemoSource/CSJDemoResource'
    
    # 穿山甲相关的SDK
    ss.dependency 'FusionDemoSource/CSJRelateSDK'
    
    
  end
  
  # Gromore 相关的代码
  s.subspec 'MediationCustomAdapter' do |ss|

    ss.public_header_files = "MediationCustomAdapter/**/*.h"
    ss.source_files = "MediationCustomAdapter/**/*.{h,m,a,c,mm,pch}"
    
    ss.dependency 'FusionDemoSource/CSJRelateSDK'
  end
  
  # Demo 需要的资源文件
  s.subspec 'CSJDemoResource' do |ss|
    ss.resource_bundles = {
      'CSJDemoResource' => [
        'DomesticDemo/BUDemo/Resource/CSJDemoResource/**/*.*'
      ]
    }
  end
  
  # 穿山甲相关的SDK
  s.subspec 'CSJRelateSDK' do |ss|
   configuration = 'CN-Beta'
   if configuration == 'Develop'
     ss.dependency 'BUAdSDK'
     ss.dependency 'BUAdTestMeasurement'
     ss.dependency 'CSJMediation'
   elsif configuration == 'Release'
     ss.vendored_frameworks = 'SDK/BUAdSDK.xcframework', 'SDK/CSJMediation.xcframework', 'BUAdTestMeasurement/BUAdTestMeasurement.xcframework'
     ss.resources = ['SDK/CSJAdSDK.bundle', 'BUAdTestMeasurement/BUAdTestMeasurement.bundle']
   elsif configuration == 'CN-Release'
     # 正式版本
     ss.dependency 'Ads-Fusion-CN-Beta'
     ss.dependency 'Ads-Fusion-CN-Beta/CSJMediation'
     ss.dependency 'BUAdTestMeasurement'
   elsif configuration == 'CN-Beta'
      # 灰度版本
      ss.dependency 'Ads-Fusion-CN-Beta'
      ss.dependency 'Ads-Fusion-CN-Beta/CSJMediation'
      # ss.dependency 'BUAdTestMeasurement'
   end
  end
  

end
