//
//  ASAskDetailVc.m
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailVc.h"
#import "ASAskDetailHeaderView.h"

#import "ASQaMinBazi.h"
#import "ASQaMinAstro.h"
#import "ASQaMinZiWei.h"

@interface ASAskDetailVc ()
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, strong) id<ASQaProtocol> question;
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
    self.headerView.width = self.contentView.height;
    
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    //    self.tbList.tableHeaderView = [self newHeaderView];
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
}

- (void)setNavToParams:(NSDictionary *)params{
    self.title = [params objectForKey:@"title"];
    self.question = [params objectForKey:@"question"];
}

- (void)loadMore{
    self.pageNo++;
    [self showWaiting];
    [HttpUtil load:@"qa/GetQuestionListForAstro" params:@{@"cate" : Int2String([self.question SysNo]) ,
                                                          @"pagesize" : @"10",
                                                          @"pageindex" : [NSString stringWithFormat:@"%d", self.pageNo]}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self hideWaiting];
                [self.list addObjectsFromArray:[ASQaMinAstro arrayOfModelsFromDictionaries:json[@"list"]]];
                self.tbList.hasMore = [json[@"hasNextPage"] boolValue];
                [self.tbList reloadData];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

#pragma mark - UITableViewDelegate & DataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return self.headerView.height;
}



- (void)shareTo{
    
}

@end
