//
//  BUMentaInterstitialAdapter.m
//  BUMentaCustomAdapter
//
//  Created by jdy on 2024/7/9.
//

#import "BUMentaInterstitialAdapter.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK.h>

@interface BUMentaInterstitialAdapter () <MentaUnifiedInterstitialAdDelegate>

@property (nonatomic, strong) MentaUnifiedInterstitialAd *interstitialAd;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSString *ecpm;

@end

@implementation BUMentaInterstitialAdapter

- (BUMMediatedAdStatus)mediatedAdStatus {
    return BUMMediatedAdStatusNormal;
}

- (void)loadInterstitialAdWithSlotID:(NSString *)slotID andSize:(CGSize)size parameter:(NSDictionary *)parameter {
    if (self.interstitialAd) {
        [self.interstitialAd destory];
        self.interstitialAd.delegate = nil;
        self.interstitialAd = nil;
    }
    MUInterstitialConfig *config = [[MUInterstitialConfig alloc] init];
    config.adSize = UIScreen.mainScreen.bounds.size;
    config.slotId = slotID;
    
    self.interstitialAd = [[MentaUnifiedInterstitialAd alloc] initWithConfig:config];
    self.interstitialAd.delegate = self;
    [self.interstitialAd loadAd];
}

- (BOOL)showAdFromRootViewController:(UIViewController *)viewController parameter:(NSDictionary *)parameter {
    self.viewController = viewController;
    [self.interstitialAd showAdFromViewController:self.viewController];
    
    return YES;
}

- (void)didReceiveBidResult:(BUMMediaBidResult *)result {
    // 在此处理Client Bidding的结果回调
    if (result.win) {
        [self.interstitialAd sendWinNotification];
    } else {
        if (result.winnerPrice) {
            [self.interstitialAd sendLossNotificationWithInfo:@{MU_M_L_WIN_PRICE : @(result.winnerPrice)}];
        }
    }
}

#pragma mark - MentaUnifiedInterstitialAdDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingInterstitialADPolicy:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 插屏广告源数据拉取成功
- (void)menta_interstitialAdDidLoad:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 插屏广告视频下载成功
- (void)menta_interstitialAdMaterialDidLoad:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
    if (!self.ecpm) {
        self.ecpm = @"";
    }
    [self.bridge interstitialAd:self didLoadWithExt:@{
        BUMMediaAdLoadingExtECPM : self.ecpm,
    }];
}

/// 插屏广告加载失败
- (void)menta_interstitialAd:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge interstitialAd:self didLoadFailWithError:error ext:@{}];
}

/// 插屏广告被点击了
- (void)menta_interstitialAdDidClick:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge interstitialAdDidClick:self];
    [self.bridge interstitialAdWillPresentFullScreenModal:self];
}

/// 插屏广告关闭了
- (void)menta_interstitialAdDidClose:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge interstitialAdDidClose:self];
}

/// 插屏将要展现
- (void)menta_interstitialAdWillVisible:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 插屏广告曝光
- (void)menta_interstitialAdDidExpose:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge interstitialAdDidVisible:self];
}

/// 插屏广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_interstitialAd:(MentaUnifiedInterstitialAd *_Nonnull)interstitialAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"%s", __FUNCTION__);
    self.ecpm = [NSString stringWithFormat:@"%@", info[@"BEST_SOURCE_PRICE"]];
}

@end
