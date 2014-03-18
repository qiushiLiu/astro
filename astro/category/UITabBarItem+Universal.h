//
//  UITabBarItem+Universal.h
//  astro
//
//  Created by kjubo on 14-3-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (Universal)
+ (instancetype)itemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage;
@end
