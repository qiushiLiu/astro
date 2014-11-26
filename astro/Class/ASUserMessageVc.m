//
//  ASUserMessageVc.m
//  astro
//
//  Created by kjubo on 14/11/25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASUserMessageVc.h"
#import "ASUSR_Message.h"
#import "ASUSR_SMS.h"

@interface ASUserMessageVc ()
@property (nonatomic, strong) ASAskerHeaderView *header;
@property (nonatomic, strong) ASBaseSingleTableView *tbList;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ASUserMessageVc

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.header = [[ASAskerHeaderView alloc] initWithItems:@[@"系统", @"私信"]];
    self.header.delegate = self;
    
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.tableHeaderView = self.header;
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    
    self.header.selected = 0;
    self.tbList.hasMore = NO;
    self.list = [NSMutableArray array];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbList.height = self.contentView.height;
}

- (void)loadMore{
    self.pageNo++;
    
    [self showWaiting];
    NSString *url = self.header.selected == 0 ? @"customer/GetMessageByCustomer" : @"customer/GetSMSTopicByUser";
    [HttpUtil load:url
            params:@{@"customersysno" : @([ASGlobal shared].user.SysNo),
                     @"pageindex" : @(self.pageNo),
                     @"pageSize" : @(20)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                if(self.pageNo == 1){
                    [self.list removeAllObjects];
                }
                
                if(self.header.selected == 0){
                    [self.list addObjectsFromArray:[ASUSR_Message arrayOfModelsFromDictionaries:json[@"list"]]];
                }else{
                    [self.list addObjectsFromArray:[ASUSR_SMS arrayOfModelsFromDictionaries:json[@"list"]]];
                }
                self.tbList.hasMore = [json[@"hasNextPage"] boolValue];
                [self.tbList reloadData];
                [self hideWaiting];
            }else{
                [self alert:message];
            }
        }];
}

#pragma mark - ASAskerHeaderViewDelegate
- (void)askerHeaderSelected:(NSInteger)tag{
    self.title = [self.header.selectedTitle copy];
    self.pageNo = 0;
    [self loadMore];
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *context = nil;
    CGFloat maxWidth = 0;
    if(self.header.selected == 0){
        ASUSR_Message *msg = [self.list objectAtIndex:indexPath.row];
        context = msg.Title;
        maxWidth = 300;
    }else{
        ASUSR_SMS *msg = [self.list objectAtIndex:indexPath.row];
        context = msg.Context;
        maxWidth = 260;
    }
    CGFloat height = 36;
    height += [context sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    return MAX(50, height);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ASUrlImageView *ivFace = [[ASUrlImageView alloc] initWithFrame:CGRectMake(5, 5, 28, 28)];
        ivFace.tag = 98;
        [cell.contentView addSubview:ivFace];
        
        UILabel *lbName = [[UILabel alloc] init];
        lbName.tag = 99;
        lbName.backgroundColor = [UIColor clearColor];
        lbName.textColor = [UIColor lightGrayColor];
        lbName.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbName];
        
        UILabel *lbDate = [[UILabel alloc] init];
        lbDate.tag = 100;
        lbDate.backgroundColor = [UIColor clearColor];
        lbDate.textColor = [UIColor lightGrayColor];
        lbDate.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbDate];
        
        UILabel *lbContext = [[UILabel alloc] init];
        lbContext.tag = 101;
        lbContext.lineBreakMode = NSLineBreakByCharWrapping;
        lbContext.numberOfLines = 0;
        lbContext.backgroundColor = [UIColor clearColor];
        lbContext.textColor = [UIColor blackColor];
        lbContext.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:lbContext];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_new"]];
        icon.tag = 102;
        [cell.contentView addSubview:icon];
    }
    if(indexPath.row % 2 == 0){
        cell.contentView.backgroundColor = ASColorLightQing;
    }else{
        cell.contentView.backgroundColor = ASColorQing;
    }
    
    
    ASUrlImageView *ivFace = (ASUrlImageView *)[cell.contentView viewWithTag:98];
    UILabel *lbName = (UILabel *)[cell.contentView viewWithTag:99];
    UILabel *lbDate = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lbContext = (UILabel *)[cell.contentView viewWithTag:101];
    UIImageView *icon = (UIImageView *)[cell.contentView viewWithTag:102];
    
    if(self.header.selected == 0){
        ASUSR_Message *msg = [self.list objectAtIndex:indexPath.row];
        lbName.hidden = YES;
        ivFace.hidden = YES;
        
        lbDate.text = [msg.TS toStrFormat:@"yyyy/M/d"];
        [lbDate sizeToFit];
        lbDate.origin = CGPointMake(10, 5);
        
        icon.left = lbDate.right + 5;
        icon.centerY= lbDate.centerY;
        icon.hidden = msg.IsRead;
        
        lbContext.text = msg.Title;
        lbContext.size = [lbContext.text sizeWithFont:lbContext.font constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:lbContext.lineBreakMode];
        lbContext.origin = CGPointMake(lbDate.left, lbDate.bottom + 5);
    }else{
        ASUSR_SMS *msg = [self.list objectAtIndex:indexPath.row];
        lbName.hidden = NO;
        ivFace.hidden = NO;
        
        [ivFace load:msg.smallFromPhotoShow cacheDir:nil];
        lbName.text = msg.FromName;
        [lbName sizeToFit];
        lbName.origin = CGPointMake(ivFace.right + 10, ivFace.top);
        
        icon.left = lbName.right + 5;
        icon.centerY= lbName.centerY;
        icon.hidden = msg.IsRead;
        
        lbDate.text = [msg.TS toStrFormat:@"yyyy/M/d"];
        [lbDate sizeToFit];
        lbDate.right = 310;
        lbDate.top = lbName.top;
        
        lbContext.text = msg.Context;
        lbContext.size = [lbContext.text sizeWithFont:lbContext.font constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:lbContext.lineBreakMode];
        lbContext.origin = CGPointMake(lbName.left, lbName.bottom + 5);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end
