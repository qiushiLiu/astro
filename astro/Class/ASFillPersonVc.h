//
//  ASFillPersonVc.h
//  astro
//
//  Created by kjubo on 14-7-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPostQuestion.h"
#import "ASPostQuestionVc.h"
#import "ASPickerView.h"
#import "ASPoiMapVc.h"

@interface ASFillPersonVc : ASBaseViewController<ASPickerViewDelegate, ASPoiMapVcDelegate>
@property (nonatomic) NSInteger personTag;
@property (nonatomic, strong) ASPostQuestionVc *parentVc;
@end
