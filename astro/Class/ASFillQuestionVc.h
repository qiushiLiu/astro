//
//  ASFillQuestionVc.h
//  astro
//
//  Created by kjubo on 14-6-27.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPostQuestionVc.h"

@interface ASFillQuestionVc : ASBaseViewController<UITextFieldDelegate, UITextViewDelegate>
@property (nonatomic, weak) NSString *qtitle;
@property (nonatomic, weak) NSString *qcontent;
@end
