//
//  ASFillPersonVc.h
//  astro
//
//  Created by kjubo on 14-7-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPostQuestion.h"
#import "ASPickerView.h"
#import "ASPoiMapVc.h"
#import "ASPerson.h"

@protocol ASFillPersonVcDelegate <NSObject>
@optional
- (void)ASFillPerson:(ASPerson *)person trigger:(id)trigger;
@end

@interface ASFillPersonVc : ASBaseViewController<ASPickerViewDelegate, ASPoiMapVcDelegate>
@property (nonatomic, assign) id<ASFillPersonVcDelegate> delegate;
@property (nonatomic, assign) id trigger;
@property (nonatomic, strong) ASPerson *person;
- (id)initWithType:(NSInteger)type; //0:Astro  1:BaZi&ZiWei
+ (NSString *)stringForBirth:(NSDate *)birth gender:(NSInteger)gender daylight:(NSInteger)daylight poi:(NSString *)poi timeZone:(NSInteger)timeZone;
+ (NSString *)stringForBirth:(NSDate *)birth gender:(NSInteger)gender daylight:(NSInteger)daylight poi:(NSString *)poi;
@end

