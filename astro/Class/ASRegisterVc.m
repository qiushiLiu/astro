//
//  ASRegisterVc.m
//  astro
//
//  Created by kjubo on 14-2-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASRegisterVc.h"
#import "ASCustomer.h"
@interface ASRegisterVc ()
@property (nonatomic, strong)UIImageView *ivProgress;
@property (nonatomic, strong)UIImageView *ivCursor;

@property (nonatomic, strong)UILabel *lbCurrent;
@property (nonatomic, strong)NSMutableArray *lbSteps;

@property (nonatomic, strong)UIView *vCurrent;
@property (nonatomic, strong)NSMutableArray *vSteps;

@property (nonatomic, strong)UITextField *tfPhone;

@property (nonatomic, strong)UITextField *tfCode;
@property (nonatomic, strong)UILabel *lbCountdown;
@property (nonatomic, strong)NSTimer *timerCountdown;
@property (nonatomic, strong)UIButton *btnFetchCode;

@property (nonatomic, strong)UITextField *tfPwd;
@property (nonatomic, strong)UITextField *tfNickName;
@property (nonatomic, strong)UITextField *tfInvitationCode;
@property (nonatomic, strong)NSString *phoneNumber;
//@property (nonatomic, strong)
@end

@implementation ASRegisterVc

static CGFloat kStepWidth = 103;
static CGFloat kInputWith = 220;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setTitle:@"注册"];
    
    self.vSteps = [[NSMutableArray alloc] init];
    self.lbSteps = [[NSMutableArray alloc] init];
    //添加手指点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.contentView addGestureRecognizer:tap];
    
    //头部进度条
    self.ivProgress = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kStepWidth*3, 43)];
    self.ivProgress.image = [[UIImage imageNamed:@"step_white"] stretchableImageWithLeftCapWidth:50 topCapHeight:0];
    self.ivProgress.centerX = self.contentView.width * 0.5;
    self.ivProgress.top = 30;
    [self.contentView addSubview:self.ivProgress];
    
    self.ivCursor = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"step_green"]];
    [self.ivProgress addSubview:self.ivCursor];
    [self.ivProgress sendSubviewToBack:self.ivCursor];
    
    UILabel *lb = [self newStepLabel:@"第一步"];
    [self.ivProgress addSubview:lb];
    [self.lbSteps addObject:lb];
    
    lb = [self newStepLabel:@"第二步"];
    lb.left = kStepWidth;
    [self.ivProgress addSubview:lb];
    [self.lbSteps addObject:lb];
    
    lb = [self newStepLabel:@"第三步"];
    lb.left = kStepWidth * 2;
    [self.ivProgress addSubview:lb];
    [self.lbSteps addObject:lb];
    
    CGFloat stepViewHeightMin = 500;
    
    //第一步
    UIView *vNewStep = [[UIView alloc] initWithFrame:CGRectMake(0, self.ivProgress.bottom, self.contentView.width, stepViewHeightMin)];
    vNewStep.hidden = YES;
    [self.contentView addSubview:vNewStep];
    [self.vSteps addObject:vNewStep];
    self.tfPhone = [ASControls newTextField:CGRectMake(0, 40, kInputWith, 40)];
    self.tfPhone.centerX = vNewStep.width * 0.5;
    self.tfPhone.placeholder = @"请输入您的手机号";
    self.tfPhone.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPhone.returnKeyType = UIReturnKeyDone;
    self.tfPhone.delegate = self;
    [vNewStep addSubview:self.tfPhone];
    
    UIButton *btn = [ASControls newMMButton:CGRectMake(self.tfPhone.left, self.tfPhone.bottom + 40, self.tfPhone.width, 40) title:@"下一步"];
    [btn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    [vNewStep addSubview:btn];
    
    //第二步
    vNewStep = [[UIView alloc] initWithFrame:CGRectMake(0, self.ivProgress.bottom, self.contentView.width, stepViewHeightMin)];
    vNewStep.hidden = YES;
    [self.contentView addSubview:vNewStep];
    [self.vSteps addObject:vNewStep];
    self.tfCode = [ASControls newTextField:self.tfPhone.frame];
    self.tfCode.placeholder = @"请输入验证码";
    self.tfCode.keyboardType = UIKeyboardTypeNumberPad;
    self.tfCode.returnKeyType = UIReturnKeyDone;
    self.tfCode.delegate = self;
    [vNewStep addSubview:self.tfCode];
    
    self.btnFetchCode = [ASControls newRedButton:CGRectMake(self.tfCode.left, self.tfCode.bottom + 40, self.tfCode.width, 40) title:@"再次获取验证码"];
    [self.btnFetchCode addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    [vNewStep addSubview:self.btnFetchCode];
    
    self.lbCountdown = [self newInfoLabel];
    self.lbCountdown.top = self.btnFetchCode.bottom;
    self.lbCountdown.backgroundColor = [UIColor clearColor];
    self.lbCountdown.textColor = [UIColor blackColor];
    self.lbCountdown.font = [UIFont systemFontOfSize:14];
    [vNewStep addSubview:self.lbCountdown];
    
    btn = [ASControls newMMButton:CGRectMake(self.lbCountdown.left, self.lbCountdown.bottom + 30, self.lbCountdown.width, 40) title:@"下一步"];
    [btn addTarget:self action:@selector(checkCode) forControlEvents:UIControlEventTouchUpInside];
    [vNewStep addSubview:btn];
    
    //第三步
    vNewStep = [[UIView alloc] initWithFrame:CGRectMake(0, self.ivProgress.bottom, self.contentView.width, stepViewHeightMin)];
    vNewStep.hidden = YES;
    [self.contentView addSubview:vNewStep];
    [self.vSteps addObject:vNewStep];
    
    CGFloat top = 20;
    self.tfPwd = [ASControls newTextField:CGRectMake(50, top, 220, 40)];
    self.tfPwd.SecureTextEntry = YES;
    self.tfPwd.placeholder = @"请输入密码";
    self.tfPwd.returnKeyType = UIReturnKeyNext;
    self.tfPwd.delegate = self;
    [vNewStep addSubview:self.tfPwd];
    
    lb = [self newInfoLabel];
    lb.top = self.tfPwd.bottom;
    lb.text = @"8-12位数字加字母";
    top = lb.bottom + 20;
    [vNewStep addSubview:lb];
    
    self.tfNickName = [ASControls newTextField:CGRectMake(50, top, 220, 40)];
    self.tfNickName.placeholder = @"请给自己取个响亮的名号";
    self.tfNickName.returnKeyType = UIReturnKeyNext;
    self.tfNickName.delegate = self;
    [vNewStep addSubview:self.tfNickName];
    
    lb = [self newInfoLabel];
    lb.top = self.tfNickName.bottom;
    lb.text = @"注册后不可修改";
    top = lb.bottom + 20;
    [vNewStep addSubview:lb];
    
    self.tfInvitationCode = [ASControls newTextField:CGRectMake(50, top, 220, 40)];
    self.tfInvitationCode.placeholder = @"好友推荐的请输入推荐码";
    self.tfInvitationCode.returnKeyType = UIReturnKeyDone;
    self.tfInvitationCode.delegate = self;
    [vNewStep addSubview:self.tfInvitationCode];
    
    lb = [self newInfoLabel];
    lb.top = self.tfInvitationCode.bottom;
    lb.text = @"无好友推荐可不填写";
    top = lb.bottom + 20;
    [vNewStep addSubview:lb];
    
    btn = [ASControls newRedButton:CGRectMake(50, top, 220, 40) title:@"完成"];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [vNewStep addSubview:btn];
    vNewStep.height = btn.bottom;
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //切换到第一页
    [self setCurrentStep:0];
}

- (BOOL)viewControllerShouldNavBack{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未完成注册流程，确定要返回吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 100;
    [alert show];
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 100){
        if(buttonIndex != alertView.cancelButtonIndex){
            [self navBack];
        }
    }else if(alertView.tag == 200){
        [self navBack];
    }
}

#pragma mark -
- (void)setCurrentStep:(NSInteger)step{
    UIView *nextView = [self.vSteps objectAtIndex:step];
    UILabel *nextLb = [self.lbSteps objectAtIndex:step];
    if(nextView == self.vCurrent){
        return;
    }
    
    [self hideKeyboard];
    [UIView animateWithDuration:0.2 animations:^{
        [self.vCurrent setAlpha:0.1];
        self.ivCursor.left = kStepWidth * step;
        [nextLb setTextColor:[UIColor whiteColor]];
        [self.lbCurrent setTextColor:[UIColor blackColor]];
    } completion:^(BOOL finished) {
        [self.vCurrent setHidden:YES];
        [nextView setHidden:NO];
        self.vCurrent = nextView;
        self.lbCurrent = nextLb;
    }];
    
    if(step == 1){
        [self beginCountDown];
    }
    
    _currentStep = step;
}

- (void)goNext{
    if([self.tfPhone.text length] != 11){
        [self alert:@"请输入有效的手机号码"];
        return;
    }
    [self hideKeyboard];
    self.phoneNumber = [self.tfPhone.text copy];
    [self showWaiting];
    [self getCode];
}

- (void)checkCode{
    if([self.tfCode.text length] == 0){
        [self alert:@"请输入有效的验证码"];
        return;
    }
    [self hideKeyboard];
    [self showWaiting];
    [HttpUtil load:kUrlGetPhoneCode params:@{@"phone" : self.phoneNumber,
                                             @"code" : self.tfCode.text}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if([json boolValue]){
                [self setCurrentStep:2];
            }else{
                [self alert:message];
            }
        }];
}

- (void)beginCountDown{
    self.btnFetchCode.enabled = NO;
    if(self.timerCountdown){
        [self.timerCountdown invalidate];
    }
    self.timerCountdown = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(getCodeCountDown:) userInfo:@60 repeats:NO];
}

- (void)getCodeCountDown:(NSTimer *)sender{
    int sec = [sender.userInfo intValue];
    [sender invalidate];
    self.lbCountdown.text = [NSString stringWithFormat:@"%d秒后可再次获取", sec];
    if(sec == 0){
        self.btnFetchCode.enabled = YES;
        [self.timerCountdown invalidate];
    }else{
        self.timerCountdown =[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(getCodeCountDown:) userInfo:[NSNumber numberWithInt:sec - 1] repeats:NO];
    }
    
}

#pragma mark - HttpRequest
- (void)getCode{
    [self showWaiting];
    [self beginCountDown];
    [HttpUtil load:kUrlGetPhoneCode params:@{@"phone": self.phoneNumber} completion:^(BOOL succ, NSString *message, id json) {
        if(succ){
            [self hideWaiting];
            if([json boolValue]){
                [self setCurrentStep:1];
            }else{
                [self alert:message];
            }
        }else{
            [self hideWaiting];
            [self alert:message];
        }
    }];
}

- (void)submit{
    if([self.tfNickName.text length] == 0){
        [self alert:@"请输入昵称"];
        return;
    }
    if (![self isPasswordVerfy:self.tfPwd.text]
        || [self.tfPwd.text length] < 8
        || [self.tfPwd.text length] > 12) {
        //implement
        [self alert:@"密码格式不正确，请使用8-12位数字加字母"];
        return;
    }
    [self hideKeyboard];
    [self showWaiting];
    [HttpUtil load:kUrlRegister params:@{@"phone" : self.phoneNumber,
                                         @"pwd" : self.tfPwd.text,
                                         @"nickname" : self.tfNickName.text,
                                         @"fatetype" : @"1"}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self hideWaiting];
                ASCustomer *user = [[ASCustomer alloc] initWithDictionary:json error:NULL];
                [ASGlobal login:user];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = 200;
                [alert show];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

- (BOOL)isPasswordVerfy:(NSString *)passsword{
    NSRegularExpression *regNumber = [NSRegularExpression regularExpressionWithPattern:@"\\d" options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRegularExpression *regChar = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z]" options:NSRegularExpressionCaseInsensitive error:NULL];
    if([regNumber matchesInString:passsword options:NSMatchingReportProgress range:NSMakeRange(0, [passsword length])]
       && [regChar matchesInString:passsword options:NSMatchingReportProgress range:NSMakeRange(0, [passsword length])]){
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark - KeyBoardEvent Method
- (void)keyboardEvent:(NSNotification *)sender{
    CGSize cSize = self.contentView.size;
    CGRect keyboardFrame;
    [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    if([sender.name isEqualToString:UIKeyboardWillHideNotification]){
        self.contentView.height = self.view.height;
    }else{
        self.contentView.height = self.view.height - keyboardFrame.size.height;
    }
    self.contentView.contentSize = cSize;
}


- (void)hideKeyboard{
    [self.tfCode resignFirstResponder];
    [self.tfInvitationCode resignFirstResponder];
    [self.tfNickName resignFirstResponder];
    [self.tfPhone resignFirstResponder];
    [self.tfPwd resignFirstResponder];
}

#pragma mark - UITextFieldDelegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.tfPhone){
        [self goNext];
    }else{
    }
    return YES;
}

#pragma mark - Controller
- (UILabel *)newStepLabel:(NSString *)step{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 103, 43)];
    lb.contentMode = UIViewContentModeCenter;
    lb.textAlignment = NSTextAlignmentCenter;
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.text = step;
    return lb;
}

- (UILabel *)newInfoLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 220, 28)];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:14];
    return lb;
}



@end
