//
//  ASAppConst.h
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

// NSParagraphStyle
typedef NS_ENUM(NSInteger, NSAlertViewTag) {		/* UIAlertView 的类型 */
    NSAlertViewDefault = 123,     /* 默认 */
    NSAlertViewOK,              /* 成功，提示，确认 */
    NSAlertViewError,           /* 错误 */
    NSAlertViewConfirm,         /* 确认 */
    NSAlertViewNeedLogin,
};

#define DF_WIDTH    [[UIScreen mainScreen] bounds].size.width

//百度地图 key
#define BMAP_KEY @"pdzQZt6WGKTmABSGlqiMvN6d"

//通知
#define Notification_Question_NeedUpdate    @"Notification_Question_NeedUpdate"
#define Notification_Reply_NeedUpdate       @"Notification_Reply_NeedUpdate"
//#define Notification_LoginUser              @"Notification_LoginUser"
#define Notification_MainVc                 @"Notification_MainVc"  //返回首页


extern NSString * const kAppVersion;
extern NSString * const kAppChannel;
extern NSString * const kAppHost;
extern BOOL kAppDebug;

extern NSInteger const A_HOUR_SECONDS;
extern NSInteger const A_DAY_SECONDS;

extern NSString *const kSinaiPadSSOUrl;
extern NSString *const kSinaiPhoneSSOUrl;
extern NSString *const kInterceptURL;

#define FateTypeArray @[@"占星", @"紫薇斗数", @"八字"]
#define PanTypeArray @[@"占星排盘", @"紫斗排盘", @"八字排盘", @"占星色子"]
#define AstroTypeArray @[@"本命盘", @"合盘", @"推运盘"]
#define AstroZuheArray @[@"比较盘(comparison)", @"组合中点盘(composite)", @"时空中点盘(midpoint)", @"合并盘(synastry)"]
#define AstroTuiyunArray @[@"行运VS本命(Transit)", @"月亮次限法(365.25636)", @"月亮三限法(29.530588)", @"月亮三限法(27.321582)", @"太阳反照法(Solar Return)", @"月亮反照法(Lunar Return)", @"太阳弧法(Solar Arc)", @"法达星限(Firdaria)"]
#define RelationArray @[@"个人运势", @"两人关系"]
#define TimeZoneArray @[@"东12区", @"东11区", @"东10区", @"东9区", @"东8区", @"东7区", @"东6区",@"东5区", @"东4区", @"东3区", @"东2区", @"东1区", @"零时区", @"西1区",@"西2区", @"西3区", @"西4区", @"西5区", @"西6区", @"西7区", @"西8区",@"西9区", @"西10区", @"西11区", @"西12区"]

