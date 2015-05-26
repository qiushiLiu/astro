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

typedef void (^TransitCallback)(NSDate* date, ASPosition* poi);

@interface ASAstroTransitVc : ASBaseViewController<ASPickerViewDelegate, ASPoiMapVcDelegate>
@property (nonatomic, copy) ASPosition *transitPosition;
@property (nonatomic, copy) NSDate *transitTime;

+ (instancetype)newTransitVc:(TransitCallback)callBack;
@end
