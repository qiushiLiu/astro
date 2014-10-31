//
//  ASAskDetailVc.h
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASBaseSingleTableView.h"
#import "ASAskDetailCellView.h"
@interface ASAskDetailVc : ASBaseViewController<UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate, ASBaseSingleTableViewDelegate, ASAskDetailCellViewDelegate>

@end
