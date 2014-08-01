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
    NSAlertViewDefault = 0,     /* 默认 */
    NSAlertViewOK,              /* 成功，提示，确认 */
    NSAlertViewError,           /* 错误 */
    NSAlertViewConfirm,         /* 确认 */
};

//百度地图 key
#define BMAP_KEY @"pdzQZt6WGKTmABSGlqiMvN6d"

//通知
#define Notification_Question_NeedUpdate    @"Notification_Question_NeedUpdate"//刷新帖子列表通知
#define Notification_LoginUser              @"Notification_LoginUser"//刷新帖子列表通知

extern NSString * const kAppVersion;
extern NSString * const kAppChannel;
extern NSString * const kAppHost;
extern BOOL kAppDebug;

extern NSInteger const A_HOUR_SECONDS;
extern NSInteger const A_DAY_SECONDS;

extern NSString *const kSinaiPadSSOUrl;
extern NSString *const kSinaiPhoneSSOUrl;
extern NSString *const kInterceptURL;


#define NumberToCharacter @[@"一", @"二"]
#define PanTypeArray @[@"占星排盘", @"八字排盘", @"紫斗排盘"]
#define RelationArray @[@"个人运势", @"两人关系"]
#define TimeZoneArray @[@"东12区", @"东11区", @"东10区", @"东9区", @"东8区", @"东7区", @"东6区",@"东5区", @"东4区", @"东3区", @"东2区", @"东1区", @"零食区", @"西1区",@"西2区", @"西3区", @"西4区", @"西5区", @"西6区", @"西7区", @"西8区",@"西9区", @"西10区", @"西11区", @"西12区"]