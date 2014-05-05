//
//  ASLoadMoreView.h
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASBaseSingleTableView.h"

@interface ASLoadMoreView : UIView
//是否正在更新
@property (nonatomic, readonly) BOOL isLoadingTag;
//是否需要刷新
@property (nonatomic) BOOL needRefreshTag;
//所归属的tableview
@property (nonatomic, assign)ASBaseSingleTableView *tableView;

- (id)initWithScrollView:(ASBaseSingleTableView *)tableView;
- (void)stopLoading;
@end
