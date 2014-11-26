//
//  ASUserMessageVc.h
//  astro
//
//  Created by kjubo on 14/11/25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASAskerHeaderView.h"
#import "ASBaseSingleTableView.h"
@interface ASUserMessageVc : ASBaseViewController<ASAskerHeaderViewDelegate, ASBaseSingleTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@end
