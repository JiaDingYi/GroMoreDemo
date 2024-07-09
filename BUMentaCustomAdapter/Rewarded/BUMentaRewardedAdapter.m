//
//  BUMentaRewardedAdapter.m
//  BUMentaCustomAdapter
//
//  Created by jdy on 2024/7/9.
//

#import "BUMentaRewardedAdapter.h"
#import <MentaUnifiedSDK/MentaUnifiedSDK.h>

@interface BUMentaRewardedAdapter () <MentaUnifiedRewardVideoDelegate>
@property (nonatomic, strong) MentaUnifiedRewardVideoAd *rewardedVideo;
@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, strong) NSString *ecpm;

@end

@implementation BUMentaRewardedAdapter

- (BUMMediatedAdStatus)mediatedAdStatus {
    return BUMMediatedAdStatusNormal;
}

- (void)loadRewardedVideoAdWithSlotID:(nonnull NSString *)slotID andParameter:(nonnull NSDictionary *)parameter {
    
    if (self.rewardedVideo) {
        [self.rewardedVideo destory];
        self.rewardedVideo.delegate = nil;
        self.rewardedVideo = nil;
    }
    
    MURewardVideoConfig *config = [[MURewardVideoConfig alloc] init];
    config.adSize = UIScreen.mainScreen.bounds.size;
    config.slotId = slotID;
    config.videoGravity = MentaRewardVideoAdViewGravity_ResizeAspect;

    self.rewardedVideo = [[MentaUnifiedRewardVideoAd alloc] initWithConfig:config];
    self.rewardedVideo.delegate = self;
    [self.rewardedVideo loadAd];
}

- (BOOL)showAdFromRootViewController:(UIViewController * _Nonnull)viewController parameter:(nonnull NSDictionary *)parameter {
    self.viewController = viewController;
    
    if (self.rewardedVideo.isAdValid) {
        [self.rewardedVideo showAdFromRootViewController:self.viewController];
        return YES;
    } else {
        return NO;
    }
}

- (void)didReceiveBidResult:(BUMMediaBidResult *)result {
    // 在此处理Client Bidding的结果回调
    if (result.win) {
        
    } else {
        if (result.winnerPrice) {
            [self.rewardedVideo sendLossNotificationWithInfo:@{MU_M_L_WIN_PRICE : @(result.winnerPrice)}];
        }
    }
}

#pragma mark - MentaUnifiedRewardVideoDelegate

/// 广告策略服务加载成功
- (void)menta_didFinishLoadingRewardVideoADPolicy:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 激励视频广告源数据拉取成功
- (void)menta_rewardVideoAdDidLoad:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 激励视频广告视频下载成功
- (void)menta_rewardVideoAdMaterialDidLoad:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
    if (!self.ecpm) {
        self.ecpm = @"";
    }
    [self.bridge rewardedVideoAd:self didLoadWithExt:@{
        BUMMediaAdLoadingExtECPM : self.ecpm,
    }];
    [self.bridge rewardedVideoAdVideoDidLoad:self];
}

/// 激励视频加载失败
- (void)menta_rewardVideoAd:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd didFailWithError:(NSError * _Nullable)error description:(NSDictionary *_Nonnull)description {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge rewardedVideoAd:self didLoadFailWithError:error ext:@{}];
}

/// 激励视频广告被点击了
- (void)menta_rewardVideoAdDidClick:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge rewardedVideoAdDidClick:self];
    [self.bridge rewardedVideoAdWillPresentFullScreenModel:self];
}

/// 激励视频广告关闭了
- (void)menta_rewardVideoAdDidClose:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd closeMode:(MentaRewardVideoAdCloseMode)mode {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge rewardedVideoAdDidClose:self];
}

/// 激励视频将要展现
- (void)menta_rewardVideoAdWillVisible:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
}

/// 激励视频广告曝光
- (void)menta_rewardVideoAdDidExpose:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge rewardedVideoAdDidVisible:self];
}

/// 激励视频广告播放达到激励条件回调
- (void)menta_rewardVideoAdDidRewardEffective:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge rewardedVideoAd:self didServerRewardSuccessWithInfo:^(BUMAdapterRewardAdInfo * _Nonnull info) {
        info.rewardName = @"[可选]";
        info.rewardAmount = 1;
        info.tradeId = @"[可选]";
        info.verify = YES;
    }];
}

/// 激励视频广告播放完成回调
- (void)menta_rewardVideoAdDidPlayFinish:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd {
    NSLog(@"%s", __FUNCTION__);
    [self.bridge rewardedVideoAd:self didPlayFinishWithError:nil];
}

/// 激励视频广告 展现的广告信息 曝光之前会触发该回调
- (void)menta_rewardVideoAd:(MentaUnifiedRewardVideoAd *_Nonnull)rewardVideoAd bestTargetSourcePlatformInfo:(NSDictionary *_Nonnull)info {
    NSLog(@"%s", __FUNCTION__);
    self.ecpm = [NSString stringWithFormat:@"%@", info[@"BEST_SOURCE_PRICE"]];
}

@end
