//
//  BUMentaSplashAdapter.m
//  BUMentaCustomAdapter
//
//  Created by jdy on 2024/7/9.
//

#import "BUMentaSplashAdapter.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

@interface BUMentaSplashAdapter () <MentaUnifiedSplashAdDelegate>

@property (nonatomic, strong) MentaUnifiedSplashAd *splashAd;
@property (nonatomic, strong) UIView *customBottomView;
@property (nonatomic, strong) NSString *ecpm;

@end


@implementation BUMentaSplashAdapter

- (BUMMediatedAdStatus)mediatedAdStatus {
    return BUMMediatedAdStatusNormal;
}

- (void)loadSplashAdWithSlotID:(nonnull NSString *)slotID andParameter:(nonnull NSDictionary *)parameter {
    if (self.splashAd) {
        self.splashAd.delegate = nil;
        self.splashAd = nil;
    }
    CGSize size = [parameter[BUMAdLoadingParamSPExpectSize] CGSizeValue];
    self.customBottomView = parameter[BUMAdLoadingParamSPCustomBottomView];
    
    MUSplashConfig *config = [MUSplashConfig new];
    config.slotId = slotID;
//    config.tolerateTime = 5;
    config.adSize = size;
    config.bottomView = self.customBottomView;
    
    self.splashAd = [[MentaUnifiedSplashAd alloc] initWithConfig:config];
    self.splashAd.delegate = self;
    [self.splashAd loadAd];
}

- (void)showSplashAdInWindow:(nonnull UIWindow *)window parameter:(nonnull NSDictionary *)parameter {
    NSLog(@"%s", __FUNCTION__);
    [self.splashAd showInWindow:window];
}

- (void)dismissSplashAd {
//    [self.splashView removeFromSuperview];
//    [self.customBottomView removeFromSuperview];
}

- (void)didReceiveBidResult:(BUMMediaBidResult *)result {
    // 在此处理Client Bidding的结果回调
    if (result.win) {
        [self.splashAd sendWinNotification];
    } else {
        if (result.winnerPrice) {
            [self.splashAd sendLossNotificationWithInfo:@{MU_M_L_WIN_PRICE : @(result.winnerPrice)}];
        }
    }
}

#pragma mark - MentaUnifiedSplashAdDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingADPolicy:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 开屏广告数据拉取成功
- (void)menta_splashAdDidLoad:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    NSLog(@"%s", __FUNCTION__);
    if (!self.ecpm) {
        self.ecpm = @"";
    }
    [self.bridge splashAd:self didLoadWithExt:@{
        BUMMediaAdLoadingExtECPM : self.ecpm,
    }];
}

/// 开屏加载失败
- (void)menta_splashAd:(MentaUnifiedSplashAd *_Nonnull)splashAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    NSLog(@"%s- %@", __FUNCTION__, error);
    [self.bridge splashAd:self didLoadFailWithError:error ext:@{}];
}

/// 开屏广告被点击了
- (void)menta_splashAdDidClick:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge splashAdDidClick:self];
}

/// 开屏广告关闭了
- (void)menta_splashAdDidClose:(MentaUnifiedSplashAd *_Nonnull)splashAd closeMode:(MentaSplashAdCloseMode)mode {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge splashAdDidClose:self];
}

/// 开屏广告曝光
- (void)menta_splashAdDidExpose:(MentaUnifiedSplashAd *_Nonnull)splashAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge splashAdWillVisible:self];
}

/// 开屏广告曝光失败
- (void)menta_splashAd:(MentaUnifiedSplashAd *)splashAd didFailToExposeWithError:(NSError *)error {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge splashAdDidShowFailed:self error:error];
}

/// 开屏广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_splashAd:(MentaUnifiedSplashAd *_Nonnull)splashAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"%s", __FUNCTION__);
    self.ecpm = [NSString stringWithFormat:@"%@", info[@"BEST_SOURCE_PRICE"]];
}

@end
