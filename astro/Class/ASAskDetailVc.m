//
//  ASAskDetailVc.m
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailVc.h"
#import "ASAskDetailHeaderView.h"
#import "ASAskDetailCell.h"

#import "ASQaFullBazi.h"
//#import "ASQaFullAstro.h"
//#import "ASQaFullZiWei.h"
#import "ASQaAnswer.h"

@interface ASAskDetailVc ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger sysNo;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, strong) id<ASQaProtocol, ASCustomerShowProtocol> question;
@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, strong) ASBaseSingleTableView *tbList;
@property (nonatomic, strong) ASAskDetailHeaderView *headerView;
@end

@implementation ASAskDetailVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"分享"];
    [btn addTarget:self action:@selector(shareTo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.headerView = [[ASAskDetailHeaderView alloc] init];
    
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.loadMoreDelegate = self;
    [self.contentView addSubview:self.tbList];
    
    self.pageNo = 0;
    self.hasMore = YES;
    self.list = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbList.height = self.contentView.height;
    [self loadQaData];
}

- (void)setNavToParams:(NSDictionary *)params{
    self.title = [params objectForKey:@"title"];
    self.sysNo = [[params objectForKey:@"sysno"] intValue];
}

- (void)loadQaData{
    [self showWaiting];
    [HttpUtil load:@"qa/GetQuestionForBaZi" params:@{@"sysno" : Int2String(self.sysNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                ASQaFullBazi *model = [[ASQaFullBazi alloc] initWithDictionary:json error:NULL];
                self.question = model;
                [self.headerView setQuestion:self.question];
                self.tbList.tableHeaderView = self.headerView;
                [self loadMore];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

- (void)loadMore{
    self.pageNo++;
    [self showWaiting];
    [HttpUtil load:@"qa/GetAnswerByQuest" params:@{@"sysno" : Int2String(self.sysNo),
                                                   @"pagesize" : @"10",
                                                   @"pageindex" : Int2String(self.pageNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
//                [self.list addObjectsFromArray:[ASQaAnswerShow arrayOfModelsFromDictionaries:json[@"list"]]];
                self.tbList.hasMore = [json[@"hasNextPage"] boolValue];
                [self.tbList reloadData];
                [self hideWaiting];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

#pragma mark - UITableViewDelegate & DataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASAskDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[ASAskDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
    }
    if(indexPath.row == 0){
        [cell setQaProtocol:self.question chart:[self.question Chart] customer:[self.question Customer] canDel:YES canComment:YES];
    }else{
        ASQaAnswer *answer = [self.list objectAtIndex:indexPath.row - 1];
        [cell setQaProtocol:answer chart:nil customer:answer.Customer canDel:YES canComment:YES];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return [ASAskDetailCell heightForQaProtocol:self.question chart:[self.question Chart]];
    }else{
        ASQaAnswer *answer = [self.list objectAtIndex:indexPath.row - 1];
        return [ASAskDetailCell heightForQaProtocol:answer chart:nil];
    }
}

- (void)shareTo{
    
}

@end
