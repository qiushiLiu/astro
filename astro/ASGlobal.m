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

+ (void)login:(ASUsr_Customer *)user{
    [[ASCache shared] storeValue:[user toJsonString] dir:kCacheDir key:kCacheKeyForUserInfo];
    [self shared].user = [user copy];
}

- (id)init{
    if(self = [super init]){
        [self loadCachedUser];
        [self loadCachedDeviceNumber];
    }
    return self;
}

//从缓存中读取并设置登录信息
- (void)loadCachedUser{
    ASCacheObject *cf = [[ASCache shared] readDicFiledsWithDir:kCacheDir key:kCacheKeyForUserInfo];
    if (cf) {
        //设置登录信息
        self.user = [[ASUsr_Customer alloc] initFromJsonString:cf.value];
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
