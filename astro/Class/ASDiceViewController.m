//
//  ASDiceViewController.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceViewController.h"
#import "ASDiceView.h"

@interface ASDiceViewController ()<ASDiceViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITextField *tfQuestion;
@property (nonatomic, strong) ASDiceView *panView;
@property (nonatomic, strong) UIButton *btnStart;
@end

@implementation ASDiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"占星骰子";
    
    //左侧按钮
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 54, 28) title:@"历史"];
    [btn addTarget:self action:@selector(btnClick_history) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dice_bg"]];
    
    self.tfQuestion = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 230, 30)];
    self.tfQuestion.background = [UIImage imageNamed:@"dice_input"];
    self.tfQuestion.clearButtonMode = UITextFieldViewModeAlways;
    self.tfQuestion.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, self.tfQuestion.height)];
    self.tfQuestion.font = [UIFont systemFontOfSize:13];
    self.tfQuestion.textColor = UIColorFromRGB(0x00FFFF);
    self.tfQuestion.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您要占卜的事情~" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x00FFFF)}];
    self.tfQuestion.leftViewMode = UITextFieldViewModeAlways;
    self.tfQuestion.returnKeyType = UIReturnKeyDone;
    self.tfQuestion.delegate = self;
    [self.contentView addSubview:self.tfQuestion];
    
    self.btnStart = [ASControls newRedButton:CGRectMake(0, 15, 60, 30) title:@"开始"];
    self.btnStart.right = DF_WIDTH - 10;
    [self.btnStart addTarget:self action:@selector(btnClick_start) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnStart];
    
    self.panView = [[ASDiceView alloc] initWithFrame:CGRectMake(0, self.tfQuestion.bottom + 4, 320, 320)];
    self.panView.delegate = self;
    [self.contentView addSubview:self.panView];
    
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dice_logo"]];
    ivLogo.bottom = self.panView.bottom - 5;
    ivLogo.left = 5;
    [self.contentView addSubview:ivLogo];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_background)];
    [self.contentView addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.panView.centerX = self.contentView.width/2;
}

- (void)tap_background{
    [self.tfQuestion resignFirstResponder];
}

- (void)btnClick_start{
    [self.tfQuestion resignFirstResponder];
    [self.panView start];
}

- (void)btnClick_history{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.tfQuestion){
        [self btnClick_start];
    }
    return YES;
}

#pragma mark - ASDiceViewDelegate
- (void)didFinishedDiceView:(ASDiceView *)dv{
    [self showWaiting];
    [HttpUtil load:@"pp/GetDiceInfo"
            params:@{@"star" : @(self.panView.star),
                     @"house" : @(self.panView.gong),
                     @"constellation" : @(self.panView.constellation)}
        completion:^(BOOL succ, NSString *message, id json) {
            NSString *val = json;
            val = [val stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
            [self hideWaiting];
            [self alert:val];
        }];
}

@end
