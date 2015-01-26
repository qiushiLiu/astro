//
//  ASBaZiPanVc.m
//  astro
//
//  Created by kjubo on 14/11/26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaZiPanVc.h"
#import "ASBaZiPanFillInfoVc.h"
#import "ASPostQuestionVc.h"
#import "ASAppDelegate.h"

@interface ASBaZiPanVc ()
@property (nonatomic) NSInteger panType;
@property (nonatomic, strong) UIImageView *pan;     //盘的图片
@property (nonatomic, strong) UIButton *btnQueston;
@end

@implementation ASBaZiPanVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"八字排盘"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"排盘"];
    [btn addTarget:self action:@selector(btnClick_fillInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 0, 0)];
    [self.contentView addSubview:self.pan];
    
    self.btnQueston = [ASControls newOrangeButton:CGRectMake(0, 0, 200, 28) title:@"求解"];
    self.btnQueston.centerX = self.contentView.width/2;
    [self.btnQueston addTarget:self action:@selector(btnClick_question:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnQueston];
    
    self.panType = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnQueston.hidden = self.hideButton;
    [self showWaiting];
    if(self.model){
        self.panType = [self.model.panType intValue];
    }
    [HttpUtil post:@"input/TimeToBazi" params:nil body:[self.model toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            NSError *error;
            self.model = [[BaziMod alloc] initWithDictionary:json error:&error];
            NSAssert(!error, @"%@", error);
            if(self.panType == 0){
                self.pan.image = [self.model paipan:YES];
            }else{
                self.pan.image = [self.model paipan:NO];
            }
            self.pan.size = self.pan.image.size;
            self.btnQueston.top  = self.pan.bottom + 10;
            self.contentView.contentSize = CGSizeMake(self.contentView.width, self.btnQueston.bottom + 10);
        }else{
            [self alert:message];
        }
    }];
}

- (void)btnClick_fillInfo{
    if(!self.model){
        return;
    }
    self.model.panType = @(self.panType);
    ASBaZiPanFillInfoVc *vc = [[ASBaZiPanFillInfoVc alloc] init];
    vc.model = self.model;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_question:(UIButton *)sender{
    if([ASGlobal isLogined]){
        ASPostQuestionVc *vc = [[ASPostQuestionVc alloc] init];
        vc.topCateId = @"1";
        [vc.question setBaziModel:self.model];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ASAppDelegate *appDelegate = (ASAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showNeedLoginAlertView];
    }
}
@end
