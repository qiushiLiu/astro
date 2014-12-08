//
//  ASZiWeiPanFillInfoVc.m
//  astro
//
//  Created by kjubo on 14/12/5.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASZiWeiPanFillInfoVc.h"
#import "ASQuestionButton.h"
#import "ASAstroTransitVc.h"
#import "ASZiWeiSeniorVc.h"

@interface ASZiWeiPanFillInfoVc ()
@property (nonatomic, strong) UISegmentedControl *sgPanType;
@property (nonatomic, strong) ASQuestionButton *btnPersonInfo;      //第一当事人
@property (nonatomic, strong) ASQuestionButton *btnTransit;         //退运
@property (nonatomic, strong) ASQuestionButton *btnSenior;          //高级
@end

@implementation ASZiWeiPanFillInfoVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat left = 20, top = 20;
    UILabel *lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"排盘类型";
    [self.contentView addSubview:lb];
    
    self.sgPanType = [[UISegmentedControl alloc] initWithItems:@[@"天盘", @"流限盘"]];
    self.sgPanType.frame = CGRectMake(lb.right, 0, 200, 26);
    self.sgPanType.centerY = lb.centerY;
    [self.contentView addSubview:self.sgPanType];
    top = lb.bottom + 10;
    
    self.btnPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_0" preFix:@"当事人信息"];
    self.btnPersonInfo.centerX = self.contentView.width/2;
    [self.btnPersonInfo addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPersonInfo];
    top = self.btnPersonInfo.bottom + 10;
    
    self.btnTransit = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_4" preFix:@"推运到"];
    self.btnTransit.centerX = self.contentView.width/2;
    [self.btnTransit addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnTransit];
    top = self.btnTransit.bottom + 10;
    
    self.btnSenior = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_2" preFix:@"高级选项"];
    self.btnSenior.centerX = self.contentView.width/2;
    [self.btnSenior addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnSenior];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadPanType];
    [self loadPersonInfo];
    [self loadTransit];
}

- (void)loadPanType{
    self.sgPanType.selectedSegmentIndex = self.model.Type == 0 ? 0 : 1;
    [self.btnSenior setInfoText:[ASZiWeiSeniorVc strForRy:self.model.RunYue tm:self.model.YueMa sz:self.model.MingShenZhu ss:self.model.ShiShang dy:self.model.HuanYun]];
}

- (void)loadPersonInfo{
    [self.btnPersonInfo setInfoText:[ASFillPersonVc stringForBirth:self.model.BirthTime.Date gender:self.model.Gender daylight:self.model.IsDayLight poi:self.model.AreaName]];
}

- (void)loadTransit{
    NSString *transitStr = [NSString stringWithFormat:@"%@，%@", [self.model.TransitTime.Date toStrFormat:@"yyyy-MM-dd"], self.model.AreaName];
    [self.btnTransit setInfoText:transitStr];
}

- (void)btnClick_navBack:(UIButton *)sender{
    self.model.Type = self.sgPanType.selectedSegmentIndex;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnClick_fill:(UIButton *)sender{
    if(sender == self.btnPersonInfo){
        ASFillPersonVc *vc = [[ASFillPersonVc alloc] initWithType:1];
        vc.delegate = self;
        vc.trigger = sender;
        vc.person.RealTime = self.model.RealTime;
        vc.person.Birth = self.model.BirthTime.Date;
        vc.person.Gender = self.model.Gender;
        vc.person.DayLight = self.model.IsDayLight;
        vc.person.longitude = [self.model.Longitude floatValue];
        vc.person.poiName = self.model.AreaName;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if(sender == self.btnTransit){
        ASAstroTransitVc *vc = [[ASAstroTransitVc alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if(sender == self.btnSenior){
        ASZiWeiSeniorVc *vc = [[ASZiWeiSeniorVc alloc] init];
        vc.model = self.model;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

#pragma mark - ASFillPersonVc Delegate Method
- (void)ASFillPerson:(ASPerson *)person trigger:(id)trigger{
    self.model.RealTime = person.RealTime;
    self.model.Gender = person.Gender;
    self.model.BirthTime.Date = (NSDate<NSDate> *)person.Birth;
    self.model.AreaName = person.poiName;
    self.model.Longitude = [NSString stringWithFormat:@"%.2f", person.longitude];
    [self loadPersonInfo];
}
@end
