//
//  ASPersonHistoryVc.h
//  astro
//
//  Created by kjubo on 15/5/15.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASPerson.h"
#import "ASFillPersonVc.h"
#import "ASHistoryPersonTableView.h"

@interface ASPersonHistoryVc : ASBaseViewController
@property (nonatomic, weak) ASFillPersonVc *parent;
@end
