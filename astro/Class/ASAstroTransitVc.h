//
//  ASAstroTransitVc.h
//  astro
//
//  Created by kjubo on 14-9-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPickerView.h"
#import "AstroMod.h"
#import "ASPoiMapVc.h"
@interface ASAstroTransitVc : ASBaseViewController<ASPickerViewDelegate, ASPoiMapVcDelegate>
@property (nonatomic, weak) AstroMod *astro;
@end
