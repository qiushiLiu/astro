//
//  ASUserTopicVc.m
//  astro
//
//  Created by kjubo on 14/11/26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASUserTopicVc.h"
#import "ASQaAnswer.h"
#import "ASQaMinAstro.h"
#import "ASUserCenterVc.h"

@interface ASUserTopicVc ()
@property (nonatomic, strong) ASAskerHeaderView *header;
@property (nonatomic, strong) ASBaseSingleTableView *tbList;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ASUserTopicVc

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.header = [[ASAskerHeaderView alloc] initWithItems:@[@"小白鼠区", @"学习研究"]];
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
    
    NSString *perFix = [self isCurrentUser] ? kScroePerfixArray[0] : kScroePerfixArray[1];
    NSString *sub = kUserTableRowTitle[self.type];
    self.title = [NSString stringWithFormat:@"%@%@", perFix, sub];
}

- (void)loadMore{
    self.pageNo++;
    NSString *url = self.type == 0 ? @"qa/GetQuestionListByUserAnswer" : @"qa/GetQuestionListByUserAsk";
    [self showWaiting];
    [HttpUtil load:url
            params:@{@"customersysno" : @(self.uid),
                     @"cate" : @(self.header.selected + 1),
                     @"pageindex" : @(self.pageNo),
                     @"pageSize" : @(20)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                if(self.pageNo == 1){
                    [self.list removeAllObjects];
                }
                if(self.type == 0){
                    [self.list addObjectsFromArray:[ASQaAnswer arrayOfModelsFromDictionaries:json[@"list"]]];
                }else{
                    [self.list addObjectsFromArray:[ASQaMinAstro arrayOfModelsFromDictionaries:json[@"list"]]];
                }
                self.tbList.hasMore = [json[@"hasNextPage"] boolValue];
                [self.tbList reloadData];
                [self hideWaiting];
            }else{
                [self alert:message];
            }
        }];
}

- (BOOL)isCurrentUser{
    if(self.uid == 0){
        self.uid = [ASGlobal shared].user.SysNo;
    }
    return self.uid == [ASGlobal shared].user.SysNo;
}

#pragma mark - ASAskerHeaderViewDelegate
- (void)askerHeaderSelected:(NSInteger)tag{
    self.pageNo = 0;
    [self loadMore];
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 220, 18)];
        lbTitle.tag = 99;
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.lineBreakMode = NSLineBreakByTruncatingTail;
        lbTitle.textColor = [UIColor lightGrayColor];
        lbTitle.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbTitle];
        
        UILabel *lbDate = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 18)];
        lbDate.textAlignment = NSTextAlignmentRight;
        lbDate.tag = 100;
        lbDate.backgroundColor = [UIColor clearColor];
        lbDate.textColor = [UIColor lightGrayColor];
        lbDate.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbDate];
        
        UILabel *lbContext = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 300, 18)];
        lbContext.tag = 101;
        lbContext.lineBreakMode = NSLineBreakByTruncatingTail;
        lbContext.backgroundColor = [UIColor clearColor];
        lbContext.textColor = [UIColor orangeColor];
        lbContext.font = [UIFont systemFontOfSize:12];
        [cell.contentView addSubview:lbContext];
    }
    if(indexPath.row % 2 == 0){
        cell.contentView.backgroundColor = ASColorLightQing;
    }else{
        cell.contentView.backgroundColor = ASColorQing;
    }
    UILabel *lbTitle = (UILabel *)[cell.contentView viewWithTag:99];
    UILabel *lbDate = (UILabel *)[cell.contentView viewWithTag:100];
    UILabel *lbContext = (UILabel *)[cell.contentView viewWithTag:101];

    id<ASQaProtocol> item = self.list[indexPath.row];
    lbTitle.text = item.Title;
    lbDate.text = [item.TS toStrFormat:@"yyyy/M/d"];
    lbContext.text = item.Context;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ASQaProtocol> item = [self.list objectAtIndex:indexPath.row];
    [self navTo:vcAskDeltail params:@{@"title" : item.Title,
                                      @"sysno" : @(item.SysNo)}];
}

@end
