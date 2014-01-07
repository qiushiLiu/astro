//
//  ASNav.h
//  astro
//
//  Created by kjubo on 14-1-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASBaseViewController.h"

@interface ASNav : NSObject{
    //字典
    NSMutableDictionary *_vcDic;
}

+ (ASNav *)shared;
- (UINavigationController *)newNav:(NSString *)key;
- (ASBaseViewController *)newVcForKey:(NSString *)key;
@end
