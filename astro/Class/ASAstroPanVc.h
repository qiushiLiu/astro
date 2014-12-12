//
//  ASBaiPanVc.h
//  astro
//
//  Created by kjubo on 14-3-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "Paipan.h"
#import "AstroMod.h"
@interface ASAstroPanVc : ASBaseViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) AstroMod *astro;      //盘数据
@end
