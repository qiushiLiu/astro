//
//  ASDiceViewController.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceViewController.h"
#import "ASDiceView.h"

@interface ASDiceViewController ()
@property (nonatomic, strong) ASDiceView *panView;
@property (nonatomic, strong) UIButton *btnStart;
@end

@implementation ASDiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnStart = [ASControls newRedButton:CGRectMake(60, 15, 200, 28) title:@"开始"];
    [self.btnStart addTarget:self action:@selector(btnClick_start) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnStart];
    
    self.panView = [[ASDiceView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width - 10, self.contentView.width - 10)];
    [self.contentView addSubview:self.panView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.panView.center = CGPointMake(self.contentView.width/2, self.contentView.height/2);
}

- (void)btnClick_start{
    [self.panView start];
}



@end
