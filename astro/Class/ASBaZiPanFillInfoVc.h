//
//  ASBaZiPanFillInfoVc.h
//  astro
//
//  Created by kjubo on 14/12/7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "BaziMod.h"
#import "ASFillPersonVc.h"
@interface ASBaZiPanFillInfoVc : ASBaseViewController<ASFillPersonVcDelegate>
@property (nonatomic) NSInteger Type;
@property (nonatomic, weak) BaziMod *model;
@end
