//
//  ASUserCenterVc.h
//  astro
//
//  Created by kjubo on 14-6-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

@interface ASUserCenterVc : ASBaseViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSInteger uid;    //如果是他人用户中心 uid > 0
@end
