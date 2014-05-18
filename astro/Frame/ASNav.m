//
//  ASNav.m
//  astro
//
//  Created by kjubo on 14-1-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASNav.h"
#import "ASTabMainVc.h"
#import "ASLoginVc.h"
#import "ASRegisterVc.h"
#import "ASForgetPswVc.h"
#import "ASAskerVc.h"
#import "ASAskListVc.h"
#import "ASAskDetailVc.h"

#import "ASShareBindVc.h"
#import "ASBaziPanVc.h"

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
    [_vcDic setObject:[ASTabMainVc class] forKey:vcMain];
    [_vcDic setObject:[ASLoginVc class] forKey:vcLogin];
    [_vcDic setObject:[ASRegisterVc class] forKey:vcRegister];
    [_vcDic setObject:[ASForgetPswVc class] forKey:vcForgetPsw];
    [_vcDic setObject:[ASAskerVc class] forKey:vcAsk];
    [_vcDic setObject:[ASAskListVc class] forKey:vcAskList];
    [_vcDic setObject:[ASAskDetailVc class] forKey:vcAskDeltail];
    
    [_vcDic setObject:[ASShareBindVc class] forKey:vcShareBind];
    [_vcDic setObject:[ASBaziPanVc class] forKey:vcBaziPan];
    
}

- (UINavigationController *)newNav:(NSString *)key{
    //获得页面
    ASBaseViewController *vc =[self newVcForKey:key];
    vc.pageKey = key;
    
    //配置页面到导航vc
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    
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
