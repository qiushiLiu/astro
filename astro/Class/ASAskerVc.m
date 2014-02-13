//
//  ASAskerVc.m
//  astro
//
//  Created by kjubo on 14-2-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskerVc.h"
#import "ASAskerCell.h"
@interface ASAskerVc ()
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tbList;
@end

@implementation ASAskerVc

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:nil];
    
    //左侧按钮
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 80, 28) title:@"我的话题"];
    [btn addTarget:self action:@selector(btnClick_mytopic:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //搜索框
    
    //tab 标签
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"小白鼠区", @"学习研究", @"付费咨询", nil]];
    segment.frame = CGRectMake(10, 10, 300, 28);
    [self.contentView addSubview:segment];
    
    //添加键盘监听事件
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillHideNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
}

- (void)btnClick_mytopic:(UIButton *)sender{
    
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
    [cell.icon load:@"" cacheDir:self.pageKey];
    [cell.lbTitle setText:@""];
    [cell.lbSummary setText:@""];
    return cell;
}

@end
