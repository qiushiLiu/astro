//
//  ASAskerVc.m
//  astro
//
//  Created by kjubo on 14-2-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskerVc.h"
#import "ASCategory.h"
#import "ASAskerCell.h"
#import "ASCache.h"
#import "ASPostQuestionVc.h"
#import "ASNav.h"
#import "ASAppDelegate.h"

@interface ASAskerVc ()
@property (nonatomic, strong) NSString *topCateId;
@property (nonatomic, strong) NSMutableArray *catelist;
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) ASAskerHeaderView *header;
@end

@implementation ASAskerVc

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"煮酒论命"];
    //导航栏按钮
    self.navigationItem.leftBarButtonItem = nil;
    self.btnRight = [ASControls newDarkRedButton:CGRectMake(0, 0, 80, 28) title:@""];
    [self.btnRight addTarget:self action:@selector(btnClick_post) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.btnRight];
    
    //tableheader view
    self.header = [[ASAskerHeaderView alloc] initWithItems:@[@"小白鼠区", @"学习研究"]];
    self.header.delegate = self;
    
    //table
    self.tbList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.tableHeaderView = self.header;
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    
    self.header.selected = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbList.frame = self.contentView.bounds;
    [self loadRightButtonTitle];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController != self);
}

- (void)btnClick_post{
    if([ASGlobal isLogined]){
        ASPostQuestionVc *vc = [[ASPostQuestionVc alloc] init];
        vc.topCateId = [self.topCateId copy];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ASAppDelegate *appDelegate = (ASAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showNeedLoginAlertView];
    }
}

- (void)notification_UserLogined:(NSNotification *)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sender.name object:nil];
    if([ASGlobal isLogined]){
        [self btnClick_post];
    }
}

- (void)loadRightButtonTitle{
    if([self.topCateId intValue] == 1){
        [self.btnRight setTitle:@"我要求测" forState:UIControlStateNormal];
    }else if([self.topCateId intValue] == 2){
        [self.btnRight setTitle:@"我要发帖" forState:UIControlStateNormal];
    }
}

#pragma mark - ASAskerHeaderViewDelegate
- (void)askerHeaderSelected:(NSInteger)tag{
    if(tag == 0){
        self.topCateId = @"1";
    }else if(tag == 1){
        self.topCateId = @"2";
    }
    [self loadRightButtonTitle];
    
    NSDictionary *params = @{@"parent" : self.topCateId};
    [self showWaiting];
    [HttpUtil load:kUrlGetCates params:params completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            self.catelist = [ASCategory arrayOfModelsFromDictionaries:json];
            [[ASCache shared] storeValue:[self.catelist toJSONString] dir:NSStringFromClass([ASCategory class]) key:self.topCateId];
            [self hideWaiting];
            [self.tbList reloadData];
        }else{
            [self alert:message];
        }
    }];
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.catelist count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASAskerCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[ASAskerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
    }
    ASCategory *cate = [self.catelist objectAtIndex:indexPath.row];
    
    [cell.icon load:cate.Pic cacheDir:self.pageKey];
    [cell.lbTitle setText:[NSString stringWithFormat:@"%@（%@）", cate.Name, @(cate.QuestNum)]];
    cell.lbSummary.text = [cate.Intro copy];
    cell.lbSummary.height = [cate.Intro boundingRectWithSize:CGSizeMake(cell.lbSummary.width, 50) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : cell.lbSummary.font} context:nil].size.height;
    cell.lbSummary.top = cell.lbTitle.bottom + 3;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASCategory *cate = [self.catelist objectAtIndex:indexPath.row];
    [self navTo:vcAskList params:@{@"topCateId" : self.topCateId,
                                   @"cate"      : Int2String(cate.SysNo),
                                   @"title"     : cate.Name}];
}

@end
