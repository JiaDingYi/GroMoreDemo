//
//  BUMentaBannerAdapter.m
//  AFNetworking
//
//  Created by jdy on 2024/7/9.
//

#import "BUMentaBannerAdapter.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK.h>

@interface BUMentaBannerAdapter () <MentaUnifiedBannerAdDelegate>

// common
@property (nonatomic, assign) NSInteger adSubType;// 混用代码位时，代码位类型
@property (nonatomic, assign) NSTimeInterval lastLoadTimeInterval;

@property (nonatomic, strong) MentaUnifiedBannerAd *bannerAd;
@property (nonatomic, assign) UIView *bannerAdView;;
@property (nonatomic, strong) NSString *ecpm;

@end

@implementation BUMentaBannerAdapter

- (BUMMediatedAdStatus)mediatedAdStatus {
    BUMMediatedAdStatus status = BUMMediatedAdStatusNormal;
    return status;
}

- (void)loadBannerAdWithSlotID:(nonnull NSString *)slotID andSize:(CGSize)adSize parameter:(nullable NSDictionary *)parameter {
    
    if (self.bannerAd) {
        [self.bannerAd destory];
        self.bannerAd.delegate = nil;
        self.bannerAd = nil;
    }
    
    if (CGSizeEqualToSize(adSize, CGSizeZero)) adSize = CGSizeMake(300, 200);
    MUBannerConfig *config = [[MUBannerConfig alloc] init];
    config.adSize = adSize; // adSize 设置多少 最后的banner显示区域就是多少 同时containerView的size 要与adsize保持一致
    config.slotId = slotID;
    config.materialFillMode = MentaBannerAdMaterialFillMode_ScaleAspectFill;

    self.bannerAd = [[MentaUnifiedBannerAd alloc] initWithConfig:config];
    self.bannerAd.delegate = self;
    [self.bannerAd loadAd];
}

- (void)didReceiveBidResult:(BUMMediaBidResult *)result {
    // 在此处理Client Bidding的结果回调
    if (result.win) {
        [self.bannerAd sendWinNotification];
    } else {
        if (result.winnerPrice) {
            [self.bannerAd sendLossNotificationWithInfo:@{MU_M_L_WIN_PRICE : @(result.winnerPrice)}];
        }
    }
}

#pragma mark - MentaUnifiedBannerAdDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingBannerADPolicy:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 横幅(banner)广告源数据拉取成功
- (void)menta_bannerAdDidLoad:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 横幅(banner)广告物料下载成功
- (void)menta_bannerAdMaterialDidLoad:(MentaUnifiedBannerAd *_Nonnull)bannerAd {
    NSLog(@"%s", __FUNCTION__);
    self.bannerAdView = [self.bannerAd fetchBannerView];
    if (!self.ecpm) {
        self.ecpm = @"";
    }
    [self.bridge bannerAd:self didLoad:self.bannerAdView ext:@{
        BUMMediaAdLoadingExtECPM : self.ecpm,
    }];
}

/// 横幅(banner)广告加载失败
- (void)menta_bannerAd:(MentaUnifiedBannerAd *_Nonnull)bannerAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge bannerAd:self didLoadFailWithError:error ext:@{}];
}

/// 横幅(banner)广告被点击了
- (void)menta_bannerAdDidClick:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge bannerAdDidClick:self bannerView:adView];
    [self.bridge bannerAdWillPresentFullScreenModal:self bannerView:adView];
}

/// 横幅(banner)广告关闭了
- (void)menta_bannerAdDidClose:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge bannerAd:self bannerView:adView didClosedWithDislikeWithReason:@[]];
}

/// 横幅(banner)将要展现
- (void)menta_bannerAdWillVisible:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    NSLog(@"%s", __FUNCTION__);
}

/// 横幅(banner)广告曝光
- (void)menta_bannerAdDidExpose:(MentaUnifiedBannerAd *_Nonnull)bannerAd adView:(UIView *_Nullable)adView {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge bannerAdDidBecomeVisible:self bannerView:adView];
}

/// 横幅(banner)广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_bannerAd:(MentaUnifiedBannerAd *_Nonnull)bannerAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"%s", __FUNCTION__);
    self.ecpm = [NSString stringWithFormat:@"%@", info[@"BEST_SOURCE_PRICE"]];
}

@end
