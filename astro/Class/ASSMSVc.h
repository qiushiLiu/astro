//
//  ASSMSVc.h
//  astro
//
//  Created by kjubo on 14/12/4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASBaseSingleTableView.h"
@interface ASSMSVc : ASBaseViewController<ASBaseSingleTableViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (nonatomic) NSInteger sysNo;

@end
