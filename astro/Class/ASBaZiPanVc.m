//
//  ASBaZiPanVc.m
//  astro
//
//  Created by kjubo on 14/11/26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaZiPanVc.h"
#import "ASBaZiPanFillInfoVc.h"

@interface ASBaZiPanVc ()
@property (nonatomic, strong) UIImageView *pan;     //盘的图片
@property (nonatomic, strong) UIButton *btnShare;
@property (nonatomic, strong) UIButton *btnFav;
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
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, __BaiZiPanSize.width, __BaiZiPanSize.height)];
    [self.contentView addSubview:self.pan];
    
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
    [HttpUtil post:@"input/TimeToBazi" params:nil body:[self.model toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            NSError *error;
            self.model = [[BaziMod alloc] initWithDictionary:json error:&error];
            NSAssert(!error, @"%@", error);
            self.pan.image = [self.model paipan];
            self.pan.size = self.pan.image.size;
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
    ASBaZiPanFillInfoVc *vc = [[ASBaZiPanFillInfoVc alloc] init];
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
