//
//  ASZiWeiPanVc.h
//  astro
//
//  Created by kjubo on 14/12/2.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "Paipan.h"
#import "ZiWeiMod.h"
@interface ASZiWeiPanVc : ASBaseViewController<UIScrollViewDelegate>
@property (nonatomic, strong) ZiWeiMod *model;
@end
