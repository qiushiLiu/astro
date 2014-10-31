//
//  ASPostReplyVc.m
//  astro
//
//  Created by kjubo on 14-10-15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPostReplyVc.h"

@interface ASPostReplyVc ()
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UITextView *tvReply;
@end

@implementation ASPostReplyVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"发帖"];
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"确定"];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat left = 20, top = 20;
    UIView *titleView = [ASControls titleView:CGRectMake(left, top, self.contentView.width - 2 * left, 30) title:@"请输入您的回复"];
    [self.contentView addSubview:titleView];
    top = titleView.bottom + 10;
    
    self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, titleView.bottom + 10, titleView.width, 1)];
    self.lbTitle.backgroundColor = [UIColor clearColor];
    self.lbTitle.textColor = ASColorDarkRed;
    self.lbTitle.font = [UIFont systemFontOfSize:14];
    self.lbTitle.numberOfLines = 0;
    self.lbTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self.contentView addSubview:self.lbTitle];
    
    self.tvReply = [[UITextView alloc] initWithFrame:CGRectMake(self.lbTitle.left, self.lbTitle.bottom, self.lbTitle.width, 120)];
    self.tvReply.font = [UIFont systemFontOfSize:13];
    self.tvReply.backgroundColor = [UIColor whiteColor];
    self.tvReply.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tvReply.layer.borderWidth = 1;
    self.tvReply.layer.cornerRadius = 6;
    self.tvReply.delegate = self;
    [self.contentView addSubview:self.tvReply];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.lbTitle.text = [self.question Title];
    self.lbTitle.height = [self.lbTitle.text sizeWithFont:self.lbTitle.font constrainedToSize:CGSizeMake(self.lbTitle.width, CGFLOAT_MAX) lineBreakMode:self.lbTitle.lineBreakMode].height;
    self.tvReply.top = self.lbTitle.bottom + 10;
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)submit{
    NSString *reply = [self.tvReply.text trim];
    if([reply length] == 0){
        [self alert:@"请输入您的回复内容"];
        return;
    }
    [self showWaiting];
    [HttpUtil load:@"qa/AddAnswer" params:@{@"CustomerSysNo" : Int2String([ASGlobal shared].user.SysNo),
                                            @"QuestionSysNo" : Int2String(self.question.SysNo),
                                            @"Title" : @"",
                                            @"Context" : reply}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Reply_NeedUpdate object:self.question];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.tag = NSAlertViewOK;
                [alert show];
            }else{
                [self alert:message];
            }
        }];
}

#pragma mark - UITextViewDelegate

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == NSAlertViewOK){
        [self btnClick_navBack:nil];
    }
}
@end
