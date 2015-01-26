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

@protocol ASAstroTransitVcDelegate <NSObject>
- (void)transiteTo:(NSDate *)date postion:(ASPosition *)transitPosition;
@end

@interface ASAstroTransitVc : ASBaseViewController<ASPickerViewDelegate, ASPoiMapVcDelegate>
@property (nonatomic, weak) ASPosition *transitPosition;
@property (nonatomic, weak) NSDate *transitTime;
@property (nonatomic, assign) id<ASAstroTransitVcDelegate> delegate;
@end
