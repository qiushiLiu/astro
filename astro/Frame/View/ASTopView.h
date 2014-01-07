//
//  ASTopView.h
//  astro
//
//  Created by kjubo on 14-1-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASTopViewDelegate <NSObject>
- (void)topViewBackBtnClicked;
- (void)topViewRightBtnClicked;
@end

@interface ASTopView : UIView
@property (nonatomic, assign) id<ASTopViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, strong) UIButton *btnBack;
@property (nonatomic, strong) UIButton *btnRight;
@property (nonatomic, strong) UILabel *lbTitle;


- (id)initWithVc:(UIViewController *)vc;
@end
