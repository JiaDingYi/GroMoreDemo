//
//  BUMentaConfigAdapter.m
//  AFNetworking
//
//  Created by jdy on 2024/7/9.
//

#import "BUMentaConfigAdapter.h"
#import <MentaUnifiedSDK/MUAPI.h>

@implementation BUMentaConfigAdapter

// 该自定义adapter是基于哪个版本实现的，填写编写时的最新值即可，GroMore会根据该值进行兼容处理
- (BUMCustomAdapterVersion *)basedOnCustomAdapterVersion {
    return BUMCustomAdapterVersion1_1;
}

// adn初始化方法
// @param initConfig 初始化配置，包括appid、appkey基本信息和部分用户传递配置
- (void)initializeAdapterWithConfiguration:(BUMSdkInitConfig *_Nullable)initConfig {
    // 初始化network
    [MUAPI enableLog:YES];
    [MUAPI canUseIDFA:YES];
    
    [MUAPI startWithAppID:initConfig.appID appKey:initConfig.appKey finishBlock:^(BOOL success, NSError * _Nullable error) {}];
}

// adapter的版本号
- (NSString *_Nonnull)adapterVersion {
    return [MUAPI sdkVersion];
}

// adn的版本号
- (NSString *_Nonnull)networkSdkVersion {
    return [MUAPI sdkVersion];
}

// 隐私权限更新，用户更新隐私配置时触发，初始化方法调用前一定会触发一次
- (void)didRequestAdPrivacyConfigUpdate:(NSDictionary *)config {
}

/// 收到配置更新请求时触发，如主题更新，初始化时设定配置不会触发，具体修改项需自行校验
- (void)didReceiveConfigUpdateRequest:(BUMUserConfig *)config {
}

- (nonnull NSMutableDictionary *)adnInitInfo { 
    return [NSMutableDictionary dictionary];
}


@end
