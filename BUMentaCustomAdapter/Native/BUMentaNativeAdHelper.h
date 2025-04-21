//
//  BUMentaNativeAdHelper.h
//  BUMentaCustomAdapter
//
//  Created by jdy on 2024/7/10.
//

#import <Foundation/Foundation.h>
#import <BUAdSDK/BUAdSDK.h>
#import <MentaUnifiedSDK/MentaUnifiedSDK-umbrella.h>

NS_ASSUME_NONNULL_BEGIN

@interface BUMentaNativeAdHelper : NSObject  <BUMMediatedNativeAdData, BUMMediatedNativeAdViewCreator>

- (instancetype)initWithAdData:(MentaNativeObject *)data;

- (instancetype)initWithAdData:(MentaNativeObject *)data image:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
