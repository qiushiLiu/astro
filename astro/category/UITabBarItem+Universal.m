//
//  UITabBarItem+Universal.m
//  astro
//
//  Created by kjubo on 14-3-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "UITabBarItem+Universal.h"

@implementation UITabBarItem (Universal)
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    UITabBarItem *tabBarItem = nil;
    tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    return tabBarItem;
}
@end
