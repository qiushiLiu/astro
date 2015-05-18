//
//  ASFridariaGroupView.m
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASFridariaGroupView.h"
#import "ASFridariaView.h"

@interface ASFridariaGroupView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ASFridariaGroupView

+ (instancetype)newGroupView{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DF_WIDTH, 495) style:UITableViewStylePlain];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        self.rowHeight = 55;
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"FridariaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        ASFridariaView *fv = [[ASFridariaView alloc] initWithSection:indexPath.row];
        fv.tag = 100;
        [cell.contentView addSubview:fv];
    }
    return cell;
}


@end
