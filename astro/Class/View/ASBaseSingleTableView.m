//
//  ASBaseSingleTableView.m
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseSingleTableView.h"

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

- (void)reloadData{
    [self.loadMoreView stopLoading];
    [super reloadData];
}



@end
