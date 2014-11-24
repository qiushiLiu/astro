//
//  ASGlobal.m
//  astro
//
//  Created by kjubo on 14-2-25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASGlobal.h"
#import "ASCache.h"

@implementation ASGlobal

static NSString *kCacheDir = @"appglobal";//全局变量dir
static NSString *kCacheKeyForUserInfo = @"kCacheKeyForUserInfo";

+ (ASGlobal *)shared{
    static ASGlobal *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASGlobal alloc] init];
    });
    return instance;
}

+ (void)login:(ASCustomer *)user{
    if(user == nil)
        return;
    [[ASCache shared] storeValue:[user toJSONString] dir:kCacheDir key:kCacheKeyForUserInfo];
    [self shared].user = user;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_LoginUser object:nil];
}

+ (void)loginOut{
    [self shared].user = nil;
    [[ASCache shared] removeDir:kCacheDir key:kCacheKeyForUserInfo];
}

+ (BOOL)isLogined{
    if([self shared].user
       && [self shared].user.SysNo > 0){
        return YES;
    }
    return NO;
}

- (id)init{
    if(self = [super init]){
        [self loadCachedUser];
        [self loadCachedDeviceNumber];
    }
    return self;
}

- (NSInteger)fateType{
    if(self.user){
        return [self.user FateType];
    }else{
        return 1;
    }
}

//从缓存中读取并设置登录信息
- (void)loadCachedUser{
    ASCacheObject *cf = [[ASCache shared] readDicFiledsWithDir:kCacheDir key:kCacheKeyForUserInfo];
    if (cf) {
        //设置登录信息
        self.user = [[ASCustomer alloc] initWithString:cf.value error:NULL];
    }
}

- (void)loadCachedDeviceNumber{
    NSUserDefaults *defalut = [NSUserDefaults standardUserDefaults];
    NSString *uuid = [defalut objectForKey:@"deviceNumber"];
    if(!uuid){
        CFUUIDRef uuidRef = CFUUIDCreate(NULL);
        CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
        uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
        CFRelease(uuidStringRef);
        CFRelease(uuidRef);
        [defalut setObject:uuid forKey:@"deviceNumber"];
    }
    self.deviceNumber = uuid;
}



@end
