//
//  ASWaitingView.m
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASWaitingView.h"

extern NSString * const kDefalutLoadingText;

@interface ASWaitingView()
//蒙皮图片
@property (nonatomic, retain) UIImageView *maskview;
//loading主界面
@property (nonatomic, retain) UIImageView *loadview;
//loading
@property (nonatomic, retain) UIActivityIndicatorView *activety;
//标题内容
@property (nonatomic, retain) UILabel *title;

//loading主界面最大宽度
@property CGFloat maxLoadingViewWidth;
@end

@implementation ASWaitingView

- (id)initWithBaseViewController:(ASBaseViewController *)vc
{
    self = [super initWithFrame:vc.view.frame];
    if (self) {
        // Initialization code
        self.hidden = YES;
        self.backgroundColor = [UIColor clearColor];
        self.viewController = vc;
        [self.viewController.view addSubview:self];
        
        self.maxLoadingViewWidth = self.width * 0.5;
        
        self.maskview = [[UIImageView alloc] initWithFrame:self.bounds];
        self.maskview.backgroundColor = [UIColor blackColor];
        self.maskview.alpha = 0.3;
        [self addSubview:self.maskview];
        
        self.loadview = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.loadview.backgroundColor = [UIColor blackColor];
        self.loadview.layer.cornerRadius = 8;
        [self addSubview:self.loadview];
        
        self.activety = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 10, 36, 36)];
        [self.loadview addSubview:self.activety];
        
        self.title = [[UILabel alloc] init];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.lineBreakMode = NSLineBreakByCharWrapping;
        self.title.textColor = [UIColor whiteColor];
        self.title.font = [UIFont systemFontOfSize:14];
        [self.loadview addSubview:self.title];
    }
    return self;
}

- (void)showWating:(NSString *)tips{
    if([tips length] == 0){
        tips = kDefalutLoadingText;
    }
    
    self.title.text = tips;
    self.title.size = [self.title.text sizeWithFont:self.title.font constrainedToSize:CGSizeMake(self.maxLoadingViewWidth, CGFLOAT_MAX) lineBreakMode:self.title.lineBreakMode];
    self.loadview.size = CGSizeMake(self.title.width + 20, self.title.height + 70);
    self.loadview.center = CGPointMake(self.width * 0.5, self.height * 0.4);
    
    self.activety.centerX = self.loadview.width * 0.5;
    [self.activety startAnimating];
    self.title.origin = CGPointMake(10, self.activety.bottom + 5);
    
    self.hidden = NO;
    [self.viewController.view bringSubviewToFront:self];
    self.loadview.transform = CGAffineTransformMakeScale(1.7f, 1.7f);
    [UIView animateWithDuration:0.2 animations:^{
        self.loadview.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideWaiting{
    [self.activety stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        self.loadview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}


@end
