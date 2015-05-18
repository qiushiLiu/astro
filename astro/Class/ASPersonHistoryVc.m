//
//  ASPersonHistoryVc.m
//  astro
//
//  Created by kjubo on 15/5/15.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASPersonHistoryVc.h"

@interface ASPersonHistoryVc ()<ASHistoryPersonDelegate>
@property (nonatomic, strong) ASHistoryPersonTableView *tbPersons;
@end

@implementation ASPersonHistoryVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"历史当事人";
    
    self.tbPersons = [ASHistoryPersonTableView shared];
    self.tbPersons.personDelegate = self;
    [self.contentView addSubview:self.tbPersons];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbPersons.size = self.contentView.size;
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ASHistoryPersonDelegate
- (void)historyPersonSelected:(ASPerson *)person{
    self.parent.person = person;
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parent reloadData];
    }];
}

@end
