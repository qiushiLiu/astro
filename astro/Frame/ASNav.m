//
//  ASNav.m
//  astro
//
//  Created by kjubo on 14-1-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASNav.h"
#import "ASLoginVc.h"

@implementation ASNav

+ (ASNav *)shared{
    static ASNav *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASNav alloc] init];
    });
    return instance;
}

- (id)init{
    if(self = [super init]){
        _vcDic = [[NSMutableDictionary alloc] init];
        [self configPageKey];
    }
    return self;
}

- (void)configPageKey{
    [_vcDic setObject:[ASLoginVc class] forKey:vcLogin];
}

- (UINavigationController *)newNav:(NSString *)key{
    //获得页面
    ASBaseViewController *vc =[self newVcForKey:key];
    vc.pageKey = key;
    
    //配置页面到导航vc
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.navigationBarHidden = YES;
    
    return nc;
}

- (ASBaseViewController *)newVcForKey:(NSString *)key{
    Class cl = [_vcDic objectForKey:key];
    if(cl){
        ASBaseViewController *vc = [[cl alloc] init];
        return vc;
    }
    return nil;
}


@end
