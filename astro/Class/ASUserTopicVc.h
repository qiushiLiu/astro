//
//  ASUserTopicVc.h
//  astro
//
//  Created by kjubo on 14/11/26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASAskerHeaderView.h"
#import "ASBaseSingleTableView.h"
@interface ASUserTopicVc : ASBaseViewController<ASAskerHeaderViewDelegate, ASBaseSingleTableViewDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSInteger type;   //0回帖 1发帖
@property (nonatomic) NSInteger uid;
@end
