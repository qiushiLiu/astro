//
//  ASFridariaGroupView.h
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASFirdariaDecade.h"
#import "ASFridariaView.h"
@interface ASFridariaGroupView : UITableView
@property (nonatomic, weak) NSArray<ASFirdariaDecade> *data;
@property (nonatomic, assign) id<ASFridariaViewDelegate> firdariaDelegate;
+ (instancetype)newGroupView;
@end
