//
//  ASUserCenterVc.h
//  astro
//
//  Created by kjubo on 14-6-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

#define kScroePerfixArray @[@"我的", @"Ta的"]
#define kScoreTitleArray @[@"灵签", @"提问数", @"解答数"]
#define kUserTableRowTitle @[@"回帖", @"发帖", @"消息"]

@interface ASUserCenterVc : ASBaseViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSInteger uid;    //如果是他人用户中心 uid > 0
@end
