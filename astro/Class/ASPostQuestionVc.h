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
#define PanTypeArray @[@"占星术", @"塔罗牌"]
#define TimeZoneArray @[@"东12区", @"东11区", @"东10区", @"东9区", @"东8区", @"东7区", @"东6区",@"东5区", @"东4区", @"东3区", @"东2区", @"东1区", @"零食区", @"西1区",@"西2区", @"西3区", @"西4区", @"西5区", @"西6区", @"西7区", @"西8区",@"西9区", @"西10区", @"西11区", @"西12区"]

@interface ASPostQuestionVc : ASBaseViewController<UITextFieldDelegate, ASPickerViewDelegate>
@property (nonatomic, strong) ASPostQuestion *question;

+ (UIView *)titleView:(CGRect)frame title:(NSString *)title;
- (void)reloadQuestion;
- (void)reloadPerson:(NSInteger)tag;
@end
