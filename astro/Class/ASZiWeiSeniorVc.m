//
//  ASZiWeiSeniorVc.m
//  astro
//
//  Created by kjubo on 14/12/7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASZiWeiSeniorVc.h"

@interface ASZiWeiSeniorVc ()
@property (nonatomic, strong) UISegmentedControl *sgRunYue;
@property (nonatomic, strong) UISegmentedControl *sgTianMa;
@property (nonatomic, strong) UISegmentedControl *sgShengZhu;
@property (nonatomic, strong) UISegmentedControl *sgShiShang;
@property (nonatomic, strong) UISegmentedControl *sgDaYun;
@end

#define _RunYue @[@"按当月算", @"按下月算", @"月中分隔"]
#define _TianMa @[@"年马", @"月马"]
#define _ShengZhu @[@"生年年支", @"命宫地支"]
#define _ShiShang @[@"阴阳不同", @"阴阳相同"]
#define _DaYun @[@"农历新年", @"农历生日"]
@implementation ASZiWeiSeniorVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.title = @"高级选项";
    CGRect frame = CGRectMake(0, 0, 180, 30);
    CGFloat left = 20, top = 20, margin = 15;
    
    UILabel *lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"闰月排法";
    [self.contentView addSubview:lb];
    
    self.sgRunYue = [[UISegmentedControl alloc] initWithItems:_RunYue];
    self.sgRunYue.frame = frame;
    self.sgRunYue.origin = CGPointMake(lb.right, lb.top);
    [self.contentView addSubview:self.sgRunYue];
    top = lb.bottom + margin;
    
    lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"天马排法";
    [self.contentView addSubview:lb];
    
    self.sgTianMa = [[UISegmentedControl alloc] initWithItems:_TianMa];
    self.sgTianMa.frame = frame;
    self.sgTianMa.origin = CGPointMake(lb.right, lb.top);
    [self.contentView addSubview:self.sgTianMa];
    top = lb.bottom + margin;
    
    lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"身主排法";
    [self.contentView addSubview:lb];
    
    self.sgShengZhu = [[UISegmentedControl alloc] initWithItems:_ShengZhu];
    self.sgShengZhu.frame = frame;
    self.sgShengZhu.origin = CGPointMake(lb.right, lb.top);
    [self.contentView addSubview:self.sgShengZhu];
    top = lb.bottom + margin;
    
    lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"天使天伤";
    [self.contentView addSubview:lb];
    
    self.sgShiShang = [[UISegmentedControl alloc] initWithItems:_TianMa];
    self.sgShiShang.frame = frame;
    self.sgShiShang.origin = CGPointMake(lb.right, lb.top);
    [self.contentView addSubview:self.sgShiShang];
    top = lb.bottom + margin;
    
    lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"大运界限";
    [self.contentView addSubview:lb];
    
    self.sgDaYun = [[UISegmentedControl alloc] initWithItems:_DaYun];
    self.sgDaYun.frame = frame;
    self.sgDaYun.origin = CGPointMake(lb.right, lb.top);
    [self.contentView addSubview:self.sgDaYun];
}

- (void)loadData{
    self.sgRunYue.selectedSegmentIndex =  self.model.RunYue - 1;
    self.sgTianMa.selectedSegmentIndex = self.model.YueMa;
    self.sgShengZhu.selectedSegmentIndex = self.model.MingShenZhu;
    self.sgShiShang.selectedSegmentIndex = self.model.ShiShang;
    self.sgDaYun.selectedSegmentIndex = self.model.HuanYun;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)btnClick_navBack:(UIButton *)sender{
    self.model.RunYue = self.sgRunYue.selectedSegmentIndex + 1;
    self.model.YueMa = self.sgTianMa.selectedSegmentIndex;
    self.model.MingShenZhu = self.sgShengZhu.selectedSegmentIndex;
    self.model.ShiShang = self.sgShiShang.selectedSegmentIndex;
    self.model.HuanYun = self.sgDaYun.selectedSegmentIndex;
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (NSString *)strForRy:(NSInteger)ry tm:(NSInteger)tm sz:(NSInteger)sz ss:(NSInteger)ss dy:(NSInteger)dy{
    return [NSString stringWithFormat:@"%@ %@ %@ %@ %@", _RunYue[ry - 1], _TianMa[tm], _ShengZhu[sz], _ShiShang[ss], _DaYun[dy]];
}
@end
