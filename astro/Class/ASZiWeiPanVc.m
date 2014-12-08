//
//  ASZiWeiPanVc.m
//  astro
//
//  Created by kjubo on 14/12/2.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASZiWeiPanVc.h"
#import "ASZiWeiGrid.h"
#import "ASZiWeiPanFillInfoVc.h"

@interface ASZiWeiPanVc ()
@property (nonatomic, strong) UIImageView *pan;     //盘的图片
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UIButton *btnFav;
@property (nonatomic, strong) UIButton *btnQueston;
@end


@implementation ASZiWeiPanVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"紫薇排盘"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"排盘"];
    [btn addTarget:self action:@selector(btnClick_fillInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.btnShare = [ASControls newOrangeButton:CGRectMake(15, 0, 90, 28) title:@"分享"];
    [self.btnShare addTarget:self action:@selector(btnClick_share:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnShare];

    self.btnFav = [ASControls newOrangeButton:CGRectMake(0, 0, 90, 28) title:@"收藏"];
    self.btnFav.centerX = self.contentView.width/2;
    [self.btnFav addTarget:self action:@selector(btnClick_favorite:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnFav];

    self.btnQueston = [ASControls newOrangeButton:CGRectMake(0, 0, 90, 28) title:@"求解"];
    self.btnQueston.right = 305;
    [self.btnQueston addTarget:self action:@selector(btnClick_question:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnQueston];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self showWaiting];
    [HttpUtil post:@"input/TimeToZiWei" params:nil body:[self.model toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            NSError *error;
            self.model = [[ZiWeiMod alloc] initWithDictionary:json error:&error];
            NSAssert(!error, @"%@", error);
            if(self.pan){
                [self.pan removeFromSuperview];
            }
            self.pan = [self.model paipan];
            [self.contentView addSubview:self.pan];
            self.btnFav.top = self.btnQueston.top = self.btnShare.top = self.pan.bottom + 10;
            self.contentView.contentSize = CGSizeMake(self.contentView.width, self.btnShare.bottom + 10);
        }else{
            [self alert:message];
        }
    }];
}

- (void)btnClick_fillInfo{
    if(!self.model){
        return;
    }
    ASZiWeiPanFillInfoVc *vc = [[ASZiWeiPanFillInfoVc alloc] init];
    vc.model = self.model;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_share:(UIButton *)sender{
    
}

- (void)btnClick_favorite:(UIButton *)sender{
    
}

- (void)btnClick_question:(UIButton *)sender{
    
}
@end
