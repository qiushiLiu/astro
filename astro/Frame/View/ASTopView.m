//
//  ASTopView.m
//  astro
//
//  Created by kjubo on 14-1-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASTopView.h"

@implementation ASTopView

- (id)initWithVc:(UIViewController *)vc
{
    self = [super initWithFrame:CGRectMake(0, 0, vc.view.width, 44)];
    if (self) {
        // Initialization code
        //页面
        self.vc = vc;
        
        //控件--------------------
        //背景
        self.backgroundColor = UIColorFromRGB(0x6c6459);
        
        //返回按钮
        self.btnBack = [self newButton:CGRectMake(8, 0, 50, 30)];
        self.btnBack.centerY = self.height*0.5;
        [self.btnBack addTarget:self action:@selector(btnClicked_back:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_back"]];
        icon.center = CGPointMake(self.btnBack.width * 0.5, self.btnBack.height * 0.5);
        [self.btnBack addSubview:icon];
        [self addSubview:self.btnBack];
        
        //标题
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, self.height)];
        self.lbTitle.centerX = self.width * 0.5;
        self.lbTitle.font = [UIFont boldSystemFontOfSize:19];
        self.lbTitle.textColor = [UIColor whiteColor];
        [self.lbTitle setShadowOffset:CGSizeMake(0, -1)];
        self.lbTitle.shadowColor = [UIColor darkGrayColor];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lbTitle];

        //右侧按钮
        self.btnRight = [self newButton:CGRectMake(0, 0, 60, 30)];
        self.btnRight.right = self.width - 8;
        self.btnRight.centerY = self.btnBack.centerY;
        [self.btnRight addTarget:self action:@selector(btnClicked_right:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnRight];
        
        //阴影
        
    }
    return self;
}

- (UIButton *)newButton:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_darkred"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_darkred_hl"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return btn;
}

- (void)btnClicked_back:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(topViewBackBtnClicked)]){
        [self.delegate topViewBackBtnClicked];
    }
}

- (void)btnClicked_right:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(topViewRightBtnClicked)]){
        [self.delegate topViewRightBtnClicked];
    }
}


@end
