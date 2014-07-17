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