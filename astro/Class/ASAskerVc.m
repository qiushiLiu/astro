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

@interface ASAskerVc ()
@property (nonatomic, strong) NSMutableArray *catelist;
@property (nonatomic, strong) UITextField *tfSearch;
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) ASAskerHeaderView *header;
@end

@implementation ASAskerVc

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:nil];
    
    //左侧按钮
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 80, 28) title:@"我的话题"];
    [btn addTarget:self action:@selector(btnClick_myTopic:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //搜索框
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 210, 44)];
    barView.backgroundColor = [UIColor clearColor];
    self.tfSearch = [ASControls newTextField:CGRectMake(0, 8, 210, 28)];
    self.tfSearch.placeholder = @"搜索内容";
    self.tfSearch.font = [UIFont systemFontOfSize:14];
    self.tfSearch.backgroundColor = [UIColor clearColor];
    self.tfSearch.returnKeyType = UIReturnKeySearch;
    self.tfSearch.delegate = self;
    [barView addSubview:self.tfSearch];
    self.navigationItem.titleView = barView;
    
    //tableheader view
    self.header = [[ASAskerHeaderView alloc] init];
    self.header.delegate = self;
    
    //table
    self.tbList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.tableHeaderView = self.header;
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.header.selected = 0;
    self.tbList.frame = self.contentView.bounds;
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
}

- (void)btnClick_myTopic:(UIButton *)sender{
}

#pragma mark - ASAskerHeaderViewDelegate
- (void)askerHeaderSelected:(NSInteger)tag{
    int cateId = 0;
    if(tag == 0){
        cateId = 1;
    }else if(tag == 1){
        cateId = 2;
    }
    else{
        cateId = 17;
    }
    NSDictionary *params = @{@"parent" : Int2String(cateId)};
    [self showWaiting];
    [HttpUtil http:kUrlGetCates method:emHttpGet params:params timeOut:30 completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            [self hideWaiting];
            self.catelist = [ASCategory arrayOfModelsFromDictionaries:json];
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
    [cell.lbTitle setText:[NSString stringWithFormat:@"%@（%d）", cate.Name, cate.QuestNum]];
    [cell.lbSummary setText:[NSString stringWithFormat:@"%@", cate.Intro]];
    [cell.lbSummary alignTop];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASCategory *cate = [self.catelist objectAtIndex:indexPath.row];
    [self navTo:vcAskList params:@{@"cate"  : @(cate.SysNo),
                                   @"title" : cate.Name}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tfSearch resignFirstResponder];
}

#pragma mark - UISearchBar
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return range.location < 70;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.tfSearch resignFirstResponder];
    return YES;
}

@end
