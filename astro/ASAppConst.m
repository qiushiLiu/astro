//
//  ASAppConst.m
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASAppConst.h"

NSString *const kAppVersion = @"1.1";
NSString *const kAppChannel = @"0";
NSString *const kAppHost = @"http://api.ssqian.com/app";
BOOL kAppDebug = YES;

NSString *const kAppAgent = @"app-agent";
NSString *const kAppVerify = @"Restecname";
double const kDefaultTimeOut = 3.0f;
NSString *const kDefalutLoadingText = @"正在加载..";

NSInteger const A_HOUR_SECONDS = 3600;
NSInteger const A_DAY_SECONDS = A_HOUR_SECONDS * 24;

CGFloat const kProgressViewHeight = 10.0f;
NSString *const kLoadFaildImageName = @"";
NSInteger const kMemoryCachedMaxNum = 1000;
NSInteger const kImageCacheMaxNum = 500;


NSString *const kSinaiPadSSOUrl = @"sinaweibohdsso://login?redirect_uri=http%3A%2F%2Fwww.ssqian.com&callback_uri=sinaweibosso.3097902199%3A%2F%2F&client_id=3097902199";
NSString *const kSinaiPhoneSSOUrl = @"sinaweibosso://login?redirect_uri=http%3A%2F%2Fwww.ssqian.com&callback_uri=sinaweibosso.3097902199%3A%2F%2F&client_id=3097902199";
NSString *const kInterceptURL = @"www.ssqian.com/passport/thirdlogin.aspx";
