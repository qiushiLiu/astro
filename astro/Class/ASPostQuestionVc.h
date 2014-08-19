//
//  ASPostQuestionVc.h
//  astro
//
//  Created by kjubo on 14-6-26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPickerView.h"
#import "ASPostQuestion.h"
#import "ASFillPersonVc.h"

@interface ASPostQuestionVc : ASBaseViewController<UITextFieldDelegate, UIAlertViewDelegate, ASFillPersonVcDelegate, ASPickerViewDelegate>
@property (nonatomic, strong) ASPostQuestion *question;


- (void)reloadQuestion;
- (void)reloadPerson:(NSInteger)tag;
@end
