//
//  ASRegisterVc.h
//  astro
//
//  Created by kjubo on 14-2-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

@interface ASRegisterVc : ASBaseViewController<UIAlertViewDelegate, UITextFieldDelegate>
@property (nonatomic) NSInteger currentStep;
@end
