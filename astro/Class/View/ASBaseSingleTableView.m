//
//  ASBaseSingleTableView.m
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseSingleTableView.h"
#import "ASLoadMoreView.h"
@interface ASBaseSingleTableView()
@property (nonatomic, strong) ASLoadMoreView *loadMoreView;

@end

@implementation ASBaseSingleTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.loadMoreView = [[ASLoadMoreView alloc] initWithScrollView:self];
    }
    return self;
}

- (void)dealloc{
    [self.loadMoreView free];
}

- (void)setHasMore:(BOOL)hasMore{
    if(!hasMore){
        [self.loadMoreView stopLoading];
    }
    self.loadMoreView.hidden = !hasMore;
}

- (void)reloadData{
    [self.loadMoreView stopLoading];
    [super reloadData];
}


@end
