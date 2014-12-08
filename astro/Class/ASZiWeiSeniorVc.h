//
//  ASZiWeiSeniorVc.h
//  astro
//
//  Created by kjubo on 14/12/7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiWeiMod.h"

@interface ASZiWeiSeniorVc : ASBaseViewController
@property (nonatomic, weak) ZiWeiMod *model;
+ (NSString *)strForRy:(NSInteger)ry tm:(NSInteger)tm sz:(NSInteger)sz ss:(NSInteger)ss dy:(NSInteger)dy;
@end
