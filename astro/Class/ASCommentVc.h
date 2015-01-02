//
//  ASCommentVc.h
//  astro
//
//  Created by kjubo on 14/10/31.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASBaseSingleTableView.h"
#import "ASAskDetailCellView.h"
@interface ASCommentVc : ASBaseViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, ASBaseSingleTableViewDelegate, ASAskDetailCellViewDelegate>
@end
