//
//  ASHistoryPersonTableView.h
//  astro
//
//  Created by kjubo on 15/4/29.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPerson.h"

@class ASHistoryPersonTableView;
@protocol ASHistoryPersonDelegate <NSObject>

@optional
- (void)historyPersonSelected:(ASPerson *)person;

@end

@interface ASHistoryPersonTableView : UITableView
+ (ASHistoryPersonTableView *)shared;
- (void)addPerson:(ASPerson *)person;
@end
