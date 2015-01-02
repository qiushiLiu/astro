//
//  ASLoginVc.m
//  astro
//
//  Created by kjubo on 14-1-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASLoginVc.h"
#import "ASCustomer.h"
@interface ASLoginVc ()
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UITextField *tfName;
@property (nonatomic, strong) UITextField *tfPsw;
@property (nonatomic, strong) UIButton *btnSumbit;
@property (nonatomic, strong) UIButton *btnRegister;
@property (nonatomic, strong) UIButton *btnForgot;

@end

@implementation ASLoginVc

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"登录"];
    
    //左侧按钮
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 54, 28) title:nil];
    [btn setImage:[UIImage imageNamed:@"icon_navback"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //添加手指点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.contentView addGestureRecognizer:tap];
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dl_logo"]];
    icon.centerX = self.view.width * 0.5;
    icon.top = 20;
    [self.contentView addSubview:icon];
    
    CGFloat left = icon.left - 20;
    self.tfName = [ASControls newTextField:CGRectMake(left, icon.bottom + 10, icon.width + 40, 36)];
    self.tfName.delegate = self;
    self.tfName.placeholder = @"Email/手机号";
    self.tfName.returnKeyType = UIReturnKeyNext;
    self.tfName.keyboardType = UIKeyboardTypeEmailAddress;
    [self.contentView addSubview:self.tfName];
    
    self.tfPsw = [ASControls newTextField:CGRectMake(left, self.tfName.bottom + 10, icon.width + 40, 36)];
    self.tfPsw.delegate = self;
    self.tfPsw.secureTextEntry = YES;
    self.tfPsw.placeholder = @"请输入密码";
    self.tfPsw.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:self.tfPsw];
    
    self.btnSumbit = [ASControls newRedButton:CGRectMake(self.tfPsw.left, self.tfPsw.bottom + 10, self.tfPsw.width, 40) title:@"登录"];
    [self.btnSumbit addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnSumbit];
    
    self.btnRegister = [ASControls newMMButton:CGRectMake(self.btnSumbit.left, self.btnSumbit.bottom + 10, self.btnSumbit.width/2 - 5, 40) title:@"注册"];
    [self.btnRegister addTarget:self action:@selector(toRegister) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnRegister];
    
    self.btnForgot = [ASControls newMMButton:CGRectMake(self.btnRegister.right + 10, self.btnRegister.top, self.btnRegister.width, 40) title:@"忘记密码"];
    [self.btnForgot addTarget:self action:@selector(goForgotPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnForgot];
    
    
    //其他登录分割线
    UILabel *lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.text = @"其他账号登录";
    [lb sizeToFit];
    lb.centerX = self.contentView.width * 0.5;
    lb.top = self.btnForgot.bottom + 15;
    [self.contentView addSubview:lb];
    
    CGFloat lineMargin = 4;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.btnSumbit.left, 0, lb.left - self.btnSumbit.left - lineMargin, 1)];
    line.centerY = lb.centerY;
    line.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:line];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(lb.right + lineMargin, 0, self.btnSumbit.right - lb.right - lineMargin*2, 1)];
    line.centerY = lb.centerY;
    line.backgroundColor = [UIColor blackColor];
    [self.contentView addSubview:line];
    
    //其他登录button
    CGFloat buttonLeft = self.btnSumbit.left;
    btn = [[UIButton alloc] initWithFrame:CGRectMake(buttonLeft, lb.bottom + 10, 40, 60)];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    [btn setImage:[UIImage imageNamed:@"icon_dl_qq"] forState:UIControlStateNormal];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(39, -btn.width, 0, 0);
    [btn setTitle:@"腾讯QQ" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(loginByQQ) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    //其他登录button
    buttonLeft = btn.right + 10;
    btn = [[UIButton alloc] initWithFrame:CGRectMake(buttonLeft, lb.bottom + 10, 40, 60)];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    [btn setImage:[UIImage imageNamed:@"icon_dl_xl"] forState:UIControlStateNormal];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(39, -btn.width, 0, 0);
    [btn setTitle:@"新浪微博" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(loginBySina) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)login{
    if([self.tfName.text length] == 0){
        [self alert:@"请输入登录Email/手机号"];
        return;
    }
    if([self.tfPsw.text length] == 0){
        [self alert:@"请输入登录密码"];
        return;
    }
    [self hideKeyboard];
    [self showWaiting];
    [HttpUtil load:kUrlLogin params:@{@"uname" : self.tfName.text,
                                      @"pwd" : self.tfPsw.text}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                ASCustomer *user = [[ASCustomer alloc] initWithDictionary:json error:NULL];
                [ASGlobal login:user];
                [self btnClick_navBack:nil];
            }else{
                [self alert:message];
            }
        }];
}

- (void)loginByQQ{
    [self hideKeyboard];
    [self navTo:vcShareBind params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"2", @"type", nil]];
}

- (void)loginBySina{
    [self hideKeyboard];
    [self navTo:vcShareBind params:[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    @"1", @"type", nil]];
}

- (void)toRegister{
    [self hideKeyboard];
    [self navTo:vcRegister];
}

- (void)goForgotPwd{
    [self hideKeyboard];
    [self navTo:vcForgetPsw];
}

#pragma mark - KeyBoardEvent Method
- (void)keyboardEvent:(NSNotification *)sender{
    CGSize cSize = self.contentView.contentSize;
    CGRect keyboardFrame;
    [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    if([sender.name isEqualToString:UIKeyboardWillHideNotification]){
        self.contentView.height = self.view.height;
    }else{
        self.contentView.height = self.view.height - keyboardFrame.size.height;
        [self.contentView setContentOffset:CGPointMake(0, self.tfName.top - 10) animated:YES];
    }
    self.contentView.contentSize = cSize;
}


- (void)hideKeyboard{
    [self.tfName resignFirstResponder];
    [self.tfPsw resignFirstResponder];
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.tfName){
        [self.tfPsw becomeFirstResponder];
    }else{
        [self login];
    }
    return YES;
}


@end
