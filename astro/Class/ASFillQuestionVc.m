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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_ContentView:)];
    [self.contentView addGestureRecognizer:tapGesture];
    
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
    [self.contentView addSubview:self.ctrlContext];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.parentVc){
        self.ctrlTitle.text = [self.parentVc.question.Title copy];
        self.ctrlContext.text = [self.parentVc.question.Context copy];
    }
}

- (UILabel *)newRedTextLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 36, 30)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = ASColorDarkRed;
    return lb;
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self hideInput];
    if(self.parentVc){
        self.parentVc.question.Title = [self.ctrlTitle.text trim];
        self.parentVc.question.Context = [self.ctrlContext.text trim];
        [self.parentVc reloadQuestion];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tap_ContentView:(UITapGestureRecognizer *)sender{
    [self hideInput];
}

- (void)hideInput{
    [self.ctrlTitle resignFirstResponder];
    [self.ctrlContext resignFirstResponder];
}

#pragma mark - UITextField Delegate Method
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.ctrlTitle){
        [self.ctrlContext becomeFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newString = [[textField.text stringByReplacingCharactersInRange:range withString:string] trim];
    if([newString length] > 40){
        return NO;
    }
    return YES;
}

@end
