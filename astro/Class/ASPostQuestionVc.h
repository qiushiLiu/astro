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

#define NumberToCharacter @[@"一", @"二"]

@interface ASPostQuestionVc : ASBaseViewController<UITextFieldDelegate, ASPickerViewDelegate>
@property (nonatomic, strong) ASPostQuestion *question;

+ (UIView *)titleView:(CGRect)frame title:(NSString *)title;
- (void)reloadQuestion;
@end
