//
//  ASFillPersonVc.h
//  astro
//
//  Created by kjubo on 14-7-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPostQuestionVc.h"
#import "ASPickerView.h"

@interface ASFillPersonVc : ASBaseViewController<UITextFieldDelegate, ASPickerViewDelegate>
@property (nonatomic) NSInteger personTag;
@property (nonatomic, weak) ASPostQuestionVc *parentVc;
@end
