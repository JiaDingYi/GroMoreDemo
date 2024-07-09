//
//  BUDUGenFeed4628ViewController.m
//  BUDemo
//
//  Created by ByteDance on 2022/8/25.
//  Copyright © 2022 bytedance. All rights reserved.
//

#import "BUDUGenFeed4628ViewController.h"
#import "Ugen.h"

@interface BUDUGenFeed4628ViewController ()<UgenTemplateDataSource, UgenEventDelegate>

@property (nonatomic, strong) UgenEngine *ugenoEngine;

@end

@implementation BUDUGenFeed4628ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    if (![UgenEngine checkValidVersion:[self p_mockTemplate]]) {
        return;
    }
    
    _ugenoEngine = [[UgenEngine alloc] initWithContext:self bizId:@"Street2"];
    _ugenoEngine.eventDelegate = self;
    UgenTemplateItem *item = [[UgenTemplateItem alloc] init];
    item.templateInfo = [self p_mockTemplate];
    item.dataSource = self;
    [_ugenoEngine createViewWithTemplateItem:item
                                    bizData:[self p_mockData]
                                 measureSize:self.view.bounds.size
                                      result:^(NSError * _Nullable error, UgenWidget * _Nullable resultWidget) {
        if (!error && resultWidget.ugenView) {
            [self.view addSubview:resultWidget.ugenView];
        }
    }];
    
}

#pragma mark - UgenEventDelegate
- (void)onUgenEvent:(UgenEvent *)event success:(void (^)(void))success failed:(void (^)(void))failed {
    NSLog(@"lwytest-- 事件类型：%ld", event.type);
    if (event.type == UgenEventType_OnShake) {
        
    } else if (event.type == UgenEventType_OnSlide) {
        
    }
}

#pragma mark - UGenoTemplateDataSource
- (NSString *)subTemplateIdWithDataInfo:(NSDictionary *)dataInfo {
    NSString *subTemplateId = @"";
    if ([dataInfo[@"image_mode"] integerValue] == 15 || [dataInfo[@"image_mode"] integerValue] == 16) {
        // 采用模版id: lu_v
        subTemplateId = @"lu_v";
    } else if ([dataInfo[@"image_mode"] integerValue] == 3 || [dataInfo[@"image_mode"] integerValue] == 5) {
        // 采用模版id: lu_h
        subTemplateId = @"lu_h";
    }
    return subTemplateId;
}


#pragma mark - mock


- (NSDictionary *)p_mockTemplate {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ugen_dsl_4628" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return result;
};

// 优惠券
- (NSDictionary *)p_mockData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"feed_image_mode3" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return result;
}

@end
