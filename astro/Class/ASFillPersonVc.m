//
//  ASFillPersonVc.m
//  astro
//
//  Created by kjubo on 14-7-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASFillPersonVc.h"
#import "ZJSwitch.h"
@interface ASFillPersonVc ()
@property (nonatomic, strong) UITextField *tfName;
@property (nonatomic, strong) UIButton *btnDate;
@property (nonatomic, strong) UIButton *btnTime;
@property (nonatomic, strong) ZJSwitch *swDaylight; //夏令时

@property (nonatomic, strong) UIButton *btnTimeZone;//时区
@property (nonatomic, strong) ZJSwitch *swGender;   //性别
@end

@implementation ASFillPersonVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"当事人信息";
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"确定"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    CGFloat top = 20;
    CGFloat left = 20;

    UIView *titleView = [ASPostQuestionVc titleView:CGRectMake(left, top, 280, 30) title:[NSString stringWithFormat:@"请输入第%@当事人信息", NumberToCharacter[self.personTag]]];
    [self.contentView addSubview:titleView];
    top = titleView.bottom + 10;
    
    UILabel *lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"名       字";
    [self.contentView addSubview:lb];
    
    self.tfName = [ASControls newTextField:CGRectMake(lb.right + 10, top, 100, 30)];
    self.tfName.delegate = self;
    self.tfName.placeholder = @"输入名字";
    [self.contentView addSubview:self.tfName];
    top = self.tfName.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"阳历生日";
    [self.contentView addSubview:lb];
    
    self.btnDate = [self newPickerButton:CGRectMake(lb.right + 10, top, 100, 30)];
    [self.btnDate setTitle:@"请选择日期" forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnDate];
    
    self.btnTime = [self newPickerButton:CGRectMake(self.btnDate.right + 10, top, 100, 30)];
    [self.btnTime setTitle:@"请选择时间" forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnTime];
    top = self.btnTime.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"夏 令 时";
    [self.contentView addSubview:lb];
    
    self.swDaylight = [[ZJSwitch alloc] initWithFrame:CGRectMake(lb.right + 10, top, 80, 30)];
    self.swDaylight.textFont = [UIFont systemFontOfSize:16];
    self.swDaylight.onText = @"是";
    self.swDaylight.offText = @"否";
    [self.swDaylight setTintColor:ASColorBlue];
    [self.swDaylight setOnTintColor:ASColorDarkRed];
    [self.contentView addSubview:self.swDaylight];
    top = self.swDaylight.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"所属时区";
    [self.contentView addSubview:lb];
    
    self.btnTimeZone = [self newPickerButton:CGRectMake(lb.right + 10, top, 100, 30)];
    [self.btnTimeZone setTitle:@"东8区" forState:UIControlStateNormal];
    [self.contentView addSubview:self.btnTimeZone];
    top = self.btnTimeZone.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"性       别";
    [self.contentView addSubview:lb];
    
    self.swGender = [[ZJSwitch alloc] initWithFrame:CGRectMake(lb.right + 10, top, 80, 30)];
    self.swGender.textFont = [UIFont systemFontOfSize:16];
    self.swGender.onText = @"女";
    self.swGender.offText = @"男";
    [self.swGender setTintColor:ASColorBlue];
    [self.swGender setOnTintColor:ASColorDarkRed];
    [self.contentView addSubview:self.swGender];
    top = self.swGender.bottom + 10;
}

- (UILabel *)newPerfixTextLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = [UIColor blackColor];
    return lb;
}

- (UIButton *)newPickerButton:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    UIImageView *ivArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_arrow_down"]];
    ivArrow.right = btn.width - 8;
    ivArrow.centerY = btn.height/2;
    [btn addSubview:ivArrow];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [btn setBackgroundImage:[[UIImage imageNamed:@"input_white_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    return btn;
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end