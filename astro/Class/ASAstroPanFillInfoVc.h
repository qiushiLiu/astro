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
#import "AstroMod.h"

@interface ASAstroPanFillInfoVc : ASBaseViewController<ASPickerViewDelegate, ASFillPersonVcDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) AstroMod *model;
@end
