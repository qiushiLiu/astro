//
//  ASFridariaGroupView.m
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASFridariaGroupView.h"


@interface ASFridariaGroupView ()<UITableViewDataSource, UITableViewDelegate>

@end

@implementation ASFridariaGroupView

+ (instancetype)newGroupView{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DF_WIDTH, 1) style:UITableViewStylePlain];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if(self = [super initWithFrame:frame style:style]){
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.separatorColor = [UIColor clearColor];
        self.scrollEnabled = NO;
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row >=0 && indexPath.row < [_data count]){
        ASFirdariaDecade *item = _data[indexPath.row];
        if([item.FirdariaShort count] != 7){
            return 33;
        }
    }
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identy = @"FridariaCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identy];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identy];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        ASFridariaView *fv = [ASFridariaView newFridariaView];
        fv.delegate = self.firdariaDelegate;
        fv.tag = 100;
        [cell.contentView addSubview:fv];
    }
    ASFridariaView *fv = (ASFridariaView *)[cell.contentView viewWithTag:100];
    [fv setSection:indexPath.row forData:_data[indexPath.row]];
    return cell;
}

- (void)setData:(NSArray<ASFirdariaDecade> *)data{
    if([data count] != 9) return;
    _data = data;
    [self reloadData];
    self.size = self.contentSize;
}


@end
