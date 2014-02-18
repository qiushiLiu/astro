//
//  ASAskerVc.m
//  astro
//
//  Created by kjubo on 14-2-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskerVc.h"
#import "ASAskerCell.h"
#import "ASBaseSingleTableView.h"

@interface ASAskerVc ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) ASAskerHeaderView *header;
@property (nonatomic, strong) UISearchDisplayController *shResult;
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
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    barView.backgroundColor = [UIColor clearColor];
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 6, 210, 32)];
    self.searchBar.placeholder = @"搜索内容";
    self.searchBar.backgroundImage = [[UIImage imageNamed:@"input_white_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [self.searchBar setBarTintColor:[UIColor clearColor]];
    self.searchBar.backgroundColor = [UIColor clearColor];
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.delegate = self;
    [barView addSubview:self.searchBar];
    self.navigationItem.titleView = barView;
    
    //tableheader view
    self.header = [[ASAskerHeaderView alloc] init];
    self.header.delegate = self;
    
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.tableHeaderView = self.header;
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    
    //search Table
    self.shResult = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    [self.shResult.searchResultsTableView setSeparatorColor:[UIColor clearColor]];
    self.shResult.delegate = self;
	self.shResult.searchResultsDataSource = self;
	self.shResult.searchResultsDelegate = self;
    
    //添加键盘监听事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbList.frame = self.contentView.bounds;
}

- (void)btnClick_myTopic:(UIButton *)sender{
    
}

#pragma mark - 
- (void)askerHeaderSelected:(NSInteger)tag{
    
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASAskerCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[ASAskerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
    }
    [cell.icon load:@"http://www.ssqian.com/WebResources/IMAGES/icon_zhanxing.jpg" cacheDir:self.pageKey];
    [cell.lbTitle setText:@"现代占星（200）"];
    [cell.lbSummary setText:@"占星术是一门古老的学术，因为结合了科学，概念上已经有了新的技术.."];
    return cell;
}

#pragma mark - UISearchBar  keyboardBar
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return range.location < 70;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView{
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}

@end
