//
//  ASFillQuestionVc.m
//  astro
//
//  Created by kjubo on 14-6-27.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASFillQuestionVc.h"

@interface ASFillQuestionVc ()
@property (nonatomic, strong) UITextField *ctrlTitle;
@property (nonatomic, strong) UITextView *ctrlContext;
@end

@implementation ASFillQuestionVc


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"问题内容";
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"确定"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat top = 20;
    CGFloat left = 20;
    
    UIView *titleView = [ASPostQuestionVc titleView:CGRectMake(left, top, 280, 30) title:@"请输入问题内容"];
    [self.contentView addSubview:titleView];
    top = titleView.bottom + 10;
    
    UILabel *lb = [self newRedTextLabel];
    lb.origin = CGPointMake(left, top);
    lb.text = @"标题";
    [self.contentView addSubview:lb];
    
    self.ctrlTitle = [ASControls newTextField:CGRectMake(lb.right + 10, top, 220, 30)];
    self.ctrlTitle.placeholder = @"最多输入30字";
    self.ctrlTitle.delegate = self;
    self.ctrlTitle.returnKeyType = UIReturnKeyNext;
    [self.contentView addSubview:self.ctrlTitle];
    top = self.ctrlTitle.bottom + 5;
    
    lb = [self newRedTextLabel];
    lb.textColor = [UIColor redColor];
    lb.font = [UIFont systemFontOfSize:12];
    lb.text = @"夺人眼球的标题，能吸引更多命理师";
    [lb sizeToFit];
    lb.origin = CGPointMake(self.ctrlTitle.left, top);
    [self.contentView addSubview:lb];
    top = lb.bottom + 10;
    
    lb = [self newRedTextLabel];
    lb.origin = CGPointMake(left, top);
    lb.text = @"内容";
    [self.contentView addSubview:lb];
    
    self.ctrlContext = [ASControls newTextView:CGRectMake(lb.right + 10, top, 220, 120)];
    self.ctrlContext.delegate = self;
    self.ctrlContext.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.ctrlContext];
}

- (UILabel *)newRedTextLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = ASColorDarkRed;
    return lb;
}

- (void)btnClick_navBack:(UIButton *)sender{
    self.qtitle = [self.ctrlTitle.text trim];
    self.qcontent = [self.ctrlContext.text trim];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
