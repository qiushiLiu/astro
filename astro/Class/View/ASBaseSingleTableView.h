//
//  ASBaseSingleTableView.h
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASBaseSingleTableViewDelegate <NSObject>

@required
- (void)loadMore;

@end

@interface ASBaseSingleTableView : UITableView
@property (nonatomic, assign) id<ASBaseSingleTableViewDelegate> loadMoreDelegate;
@property (nonatomic, setter = setHasMore:) BOOL hasMore;
@end
