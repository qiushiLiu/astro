//
//  ASUserEditVc.m
//  astro
//
//  Created by kjubo on 14/11/24.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASUserEditVc.h"
#import "ZJSwitch.h"
#import "ASPickerView.h"

@interface ASUserEditVc ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *btnFace;
@property (nonatomic, strong) ASUrlImageView *ivFace;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) ZJSwitch *swGender;
@property (nonatomic, strong) UITextView *tvIntro;
@property (nonatomic, strong) UISegmentedControl *sgFateType;
@end

@implementation ASUserEditVc

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.title = @"修改个人信息";
    
    CGFloat margin = 10;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_save) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.contentView addGestureRecognizer:tap];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width - 20, 1)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.bgView];
    
    self.btnFace = [[UIButton alloc] initWithFrame:CGRectMake(0, self.bgView.top + 10, 40, 40)];
    self.btnFace.backgroundColor = [UIColor clearColor];
    self.btnFace.right = self.bgView.right - 10;
    [self.btnFace addTarget:self action:@selector(btnClick_changeFace) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnFace];
    
    self.ivFace = [[ASUrlImageView alloc] initWithFrame:self.btnFace.bounds];
    [self.btnFace addSubview:self.ivFace];
    
    UILabel *lb = [self newPreFix:@"头像"];
    lb.left = self.bgView.left + 10;
    lb.centerY = self.btnFace.centerY;
    [self.contentView addSubview:lb];
    
    CGFloat lineWidth = self.btnFace.right - lb.left;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(lb.left, self.btnFace.bottom + margin, lineWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    self.lbName = [[UILabel alloc] initWithFrame:CGRectMake(0, line.bottom + margin, 220, 26)];
    self.lbName.right = self.btnFace.right;
    self.lbName.backgroundColor = [UIColor clearColor];
    self.lbName.font = [UIFont systemFontOfSize:14];
    self.lbName.textAlignment = NSTextAlignmentRight;
    self.lbName.textColor = ASColorBlue;
    [self.contentView addSubview:self.lbName];
    
    lb = [self newPreFix:@"名号"];
    lb.left = self.bgView.left + 10;
    lb.centerY = self.lbName.centerY;
    [self.contentView addSubview:lb];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(lb.left, self.lbName.bottom + margin, lineWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    self.swGender = [[ZJSwitch alloc] initWithFrame:CGRectMake(0, line.bottom + margin, 70, 26)];
    self.swGender.right = self.btnFace.right;
    self.swGender.textFont = [UIFont systemFontOfSize:13];
    self.swGender.onText = @"男";
    self.swGender.offText = @"女";
    [self.swGender setTintColor:ASColorBlue];
    [self.swGender setOnTintColor:ASColorDarkRed];
    [self.contentView addSubview:self.swGender];
    
    lb = [self newPreFix:@"性别"];
    lb.left = self.bgView.left + 10;
    lb.centerY = self.swGender.centerY;
    [self.contentView addSubview:lb];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(lb.left, self.swGender.bottom + margin, lineWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    self.tvIntro = [[UITextView alloc] initWithFrame:CGRectMake(0, line.bottom + margin, 220, 60)];
    self.tvIntro.right = self.btnFace.right;
    self.tvIntro.font = [UIFont systemFontOfSize:13];
    self.tvIntro.textColor = ASColorBlue;
    self.tvIntro.backgroundColor = [UIColor clearColor];
    self.tvIntro.returnKeyType = UIReturnKeyDone;
    self.tvIntro.delegate = self;
    [self.contentView addSubview:self.tvIntro];
    
    lb = [self newPreFix:@"介绍"];
    lb.left = self.bgView.left + 10;
    lb.centerY = self.tvIntro.centerY;
    [self.contentView addSubview:lb];
    
    line = [[UIView alloc] initWithFrame:CGRectMake(lb.left, self.tvIntro.bottom + margin, lineWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:line];
    
    self.sgFateType = [[UISegmentedControl alloc] initWithItems:FateTypeArray];
    [self.sgFateType setTintColor:ASColorDarkRed];
    self.sgFateType.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    self.sgFateType.top = line.bottom + margin;
    self.sgFateType.right = self.btnFace.right;
    [self.contentView addSubview:self.sgFateType];
    
    lb = [self newPreFix:@"命盘显示类型"];
    lb.left = self.bgView.left + 10;
    lb.centerY = self.sgFateType.centerY;
    [self.contentView addSubview:lb];
    
    self.bgView.height = self.sgFateType.bottom + 10;
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.contentView.contentSize = CGSizeMake(self.contentView.width, self.contentView.height);
    [self loadUserInfo];
}

- (void)loadUserInfo{
    [self.ivFace load:self.um.smallPhotoShow cacheDir:nil];
    [self.lbName setText:self.um.NickName];
    [self.tvIntro setText:self.um.Intro];
    self.swGender.on = self.um.Gender == 1;
    [self.sgFateType setSelectedSegmentIndex:self.um.FateType - 1];
}

- (UILabel *)newPreFix:(NSString *)title{
    UILabel *lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:13];
    lb.text = title;
    [lb sizeToFit];
    return lb;
}

- (void)hideKeyBoard{
    [self.tvIntro resignFirstResponder];
}

- (void)btnClick_save{
    [self hideKeyBoard];
    self.um.Gender = self.swGender.on ? 1 : 0;
    self.um.FateType = self.sgFateType.selectedSegmentIndex + 1;
    self.um.Intro = [self.tvIntro.text trim];
    [self showWaiting];
    [HttpUtil load:@"customer/UpdateUserInfo"
            params:@{@"uid" : Int2String(self.um.SysNo),
                     @"gender" : Int2String(self.um.Gender),
                     @"fatetype" : Int2String(self.um.FateType),
                     @"intro" : self.um.Intro}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                [ASGlobal shared].user.Gender = self.um.Gender;
                [ASGlobal shared].user.FateType = self.um.FateType;
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self alert:message];
            }
        }];
}

- (void)btnClick_changeFace{
    
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
    }
    self.contentView.contentSize = cSize;
}

@end
