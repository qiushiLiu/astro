//
//  ASZiWeiPanFillInfoVc.h
//  astro
//
//  Created by kjubo on 14/12/5.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ZiWeiMod.h"
#import "ASFillPersonVc.h"

@interface ASZiWeiPanFillInfoVc : ASBaseViewController<ASFillPersonVcDelegate>
@property (nonatomic, weak) ZiWeiMod *model;
@end
