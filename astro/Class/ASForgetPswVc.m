//
//  ASForgetPswVc.m
//  astro
//
//  Created by kjubo on 14-1-24.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASForgetPswVc.h"

@interface ASForgetPswVc ()
@property (nonatomic, strong) UIView *vFirst;
@property (nonatomic, strong) UIView *vNext;
@property (nonatomic, strong) UITextField *tfPhone;
@end

@implementation ASForgetPswVc
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"找回密码"];
    
    self.model = [[ASReturnValue alloc] init];
    self.model.delegate = self;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dl_logo"]];
    icon.centerX = self.view.width * 0.5;
    icon.top = 20;
    [self.contentView addSubview:icon];
    
    self.vFirst = [[UIView alloc] initWithFrame:CGRectMake(0, icon.bottom, self.view.width, 1)];
    self.vFirst.hidden = NO;
    [self.contentView addSubview:self.vFirst];
    
    //--- First View
    self.tfPhone = [ASControls newTextField:CGRectMake(icon.left - 10, 20, icon.width + 20, 36)];
    self.tfPhone.placeholder = @"Email/手机号";
    self.tfPhone.returnKeyType = UIReturnKeyDone;
    self.tfPhone.delegate = self;
    [self.vFirst addSubview:self.tfPhone];
    
    UIButton *btn = [ASControls newRedButton:CGRectMake(self.tfPhone.left, self.tfPhone.bottom + 50, self.tfPhone.width, 36) title:@"确定"];
    [btn addTarget:self action:@selector(btnClick_next) forControlEvents:UIControlEventTouchUpInside];
    [self.vFirst addSubview:btn];
    self.vFirst.height = btn.bottom;
    
    //--- Next View
    self.vNext = [[UIView alloc] initWithFrame:CGRectMake(0, icon.bottom, self.view.width, 1)];
    self.vNext.hidden = YES;
    [self.contentView addSubview:self.vNext];
    
    UILabel *lbTitle = [[UILabel alloc] init];
    lbTitle.textAlignment = NSTextAlignmentLeft;
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont systemFontOfSize:14];
    lbTitle.textColor = [UIColor blackColor];
    lbTitle.text = @"新密码已发送";
    [lbTitle sizeToFit];
    lbTitle.origin = CGPointMake(icon.left, 20);
    [self.vNext addSubview:lbTitle];
    
    UILabel *lbDetail = [[UILabel alloc] init];
    lbDetail.textAlignment = NSTextAlignmentLeft;
    lbDetail.backgroundColor = [UIColor clearColor];
    lbDetail.font = [UIFont systemFontOfSize:12];
    lbDetail.textColor = [UIColor blackColor];
    lbDetail.numberOfLines = 2;
    lbDetail.text = @"新密码已发送到您的手机，\n请查收短信。";
    [lbDetail sizeToFit];
    lbDetail.origin = CGPointMake(lbTitle.left, lbTitle.bottom + 15);
    [self.vNext addSubview:lbDetail];
    
    btn = [ASControls newRedButton:CGRectMake(icon.left, lbDetail.bottom + 30, icon.width, 36) title:@"重新登录"];
    [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.vNext addSubview:btn];
    self.vNext.height = btn.bottom;
}

- (BOOL)viewControllerShouldNavBack{
    [self.tfPhone resignFirstResponder];
    return YES;
}

- (void)btnClick_next{
    if([self.tfPhone.text length] == 0){
        [self alert:@"请输入您的Email或手机号"];
        return;
    }
    [self.tfPhone resignFirstResponder];
    [self showWaiting];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                    self.tfPhone.text, @"username", nil];
    [self.model load:kUrlGetPasssWord params:params];
}

- (void)login{
    
}

#pragma mark - Model Load Delegate
- (void)modelBeginLoad:(ASObject *)sender{
    [self showWaiting];
}

- (void)modelLoadFinished:(ASObject *)sender{
    [super modelLoadFinished:sender];
    [UIView animateWithDuration:0.2 animations:^{
        self.vFirst.alpha = 0.1;
    } completion:^(BOOL finished) {
        self.vFirst.hidden = YES;
        self.vNext.hidden = NO;
    }];
}

- (void)modelLoadFaild:(ASObject *)sender message:(NSString *)msg{
    [super modelLoadFaild:sender message:msg];
    [self alert:msg];
}

@end
