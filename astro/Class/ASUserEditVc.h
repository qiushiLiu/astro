//
//  ASUserEditVc.h
//  astro
//
//  Created by kjubo on 14/11/24.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASUserCenterVc.h"
#import "ASCustomerShow.h"

@interface ASUserEditVc : ASBaseViewController <UITextViewDelegate>
@property (nonatomic, weak) ASCustomerShow *um;
@end
