//
//  AstroMod.h
//  astro
//
//  Created by kjubo on 14-3-19.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "AstroStar.h"
#import "ASPosition.h"
@protocol AstroMod
@end

//行星
#define AstroPlanetPermit @[@"太阳", @"月亮", @"水星", @"金星", @"火星", @"木星", @"土星", @"天王星", @"海王星", @"冥王星"]
//小行星
#define AstroAsteroidPermit @[@"凯龙星", @"谷神星", @"智神星", @"婚神星", @"灶神星", @"北交点", @"莉莉丝", @"福点", @"宿命点", @"东升点"]
//容许度
#define AstroAnglePermit @[@"0°", @"180°", @"120°", @"90°", @"60°"]
#define AstroAnglePermitText @[@"合相", @"冲相", @"三合", @"刑相", @"六合"]

@interface AstroMod : JSONModel{
    CGFloat constellationStart;
}
@property (nonatomic, strong) NSArray<AstroStar> *Stars;
@property (nonatomic) NSInteger Gender;
@property (nonatomic) NSInteger Gender1;
@property (nonatomic, strong) NSDate<NSDate> *birth;
@property (nonatomic, strong) NSDate<NSDate> *birth1;
@property (nonatomic, strong) ASPosition<ASPosition> *position;
@property (nonatomic, strong) ASPosition<ASPosition> *position1;
@property (nonatomic) NSInteger zone;
@property (nonatomic) NSInteger zone1;
@property (nonatomic) BOOL IsDaylight;
@property (nonatomic) BOOL IsDaylight1;

+ (NSInteger)getStarsPermit;
+ (void)setStarsPermit:(NSInteger)permit;
+ (NSString *)getStarsPermitTextInfo;

+ (NSArray *)getAnglePermit;
+ (void)setAnglePermit:(NSArray *)permit;
+ (NSString *)getAnglePermitTextInfo;

- (UIImage *)paipan;
+ (CGPoint)pointByRadius:(CGFloat)radius andDegree:(CGFloat)degree;
@end
