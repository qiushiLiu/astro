//
//  ASAstroPanFillInfoVc.h
//  astro
//
//  Created by kjubo on 14-7-30.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPickerView.h"
#import "ASFillPersonVc.h"
#import "ASAstroStarsFillVc.h"
#import "ASPermitInfoVc.h"
#import "ASAstroTransitVc.h"
#import "AstroMod.h"

@interface ASAstroPanFillInfoVc : ASBaseViewController<ASPickerViewDelegate, ASFillPersonVcDelegate, ASAstroTransitVcDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, weak) AstroMod *model;
@end
