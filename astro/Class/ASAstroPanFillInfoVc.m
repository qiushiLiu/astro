//
//  ASAstroPanFillInfoVc.m
//  astro
//
//  Created by kjubo on 14-7-30.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAstroPanFillInfoVc.h"
#import "ASQuestionButton.h"

@interface ASAstroPanFillInfoVc ()
@property (nonatomic, strong) UIButton *btnPanType;
@property (nonatomic, strong) ASQuestionButton *btnFirstPersonInfo; //第一当事人
@property (nonatomic, strong) ASQuestionButton *btnSecondPersonInfo;//第二当事人
@property (nonatomic, strong) ASQuestionButton *btnPermitInfo;      //容许度
@property (nonatomic, strong) ASQuestionButton *btnStarsInfo;       //星体信息
@property (nonatomic, strong) ASPickerView *picker;                 //选择
@end

@implementation ASAstroPanFillInfoVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat left = 20, top = 20;
    UILabel *lb = [ASControls newRedTextLabel:CGRectMake(0, 0, 100, 30)];
    lb.text = @"排盘类型";
    lb.origin = CGPointMake(left, top);
    [self.contentView addSubview:lb];
    
    self.btnPanType = [ASControls newRedButton:CGRectMake(left, top, 120, 30) title:@"本命性格"];
    [self.btnPanType addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPanType];
    top = self.btnPanType.bottom + 10;
    
    self.btnFirstPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, 0, 280, 60) iconName:[NSString stringWithFormat:@"icon_person_%d", 1] preFix:[NSString stringWithFormat:@"第%@当事人", NumberToCharacter[0]]];
    self.btnFirstPersonInfo.centerX = self.contentView.width/2;
    [self.btnFirstPersonInfo addTarget:self action:@selector(btnClick_fillPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnFirstPersonInfo];
    
    self.btnSecondPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, 0, 280, 60) iconName:[NSString stringWithFormat:@"icon_person_%d", 2] preFix:[NSString stringWithFormat:@"第%@当事人", NumberToCharacter[1]]];
    self.btnSecondPersonInfo.centerX = self.contentView.width/2;
    [self.btnSecondPersonInfo addTarget:self action:@selector(btnClick_fillPerson:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSecondPersonInfo.hidden = YES;
    [self.contentView addSubview:self.btnSecondPersonInfo];
    
    
    
    self.picker = [[ASPickerView alloc] initWithParentViewController:self];
    self.picker.delegate = self;
}

- (void)btnClick_navBack:(UIButton *)sender{
    
    
}

@end
