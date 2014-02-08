//
//  ASBaseViewController.h
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWaitingView.h"
#import "ASObjectDelegate.h"
typedef enum {
    NavStyleDefault = 0,
    NavStyleBottomToTop,
    NavStyleTopToBottom,
    NavStyleLeftToRight,
    NavStyleFadeIn,
    NavStyleFadeOut,
    NavStyleNoEffect,
} NavStyle;

@interface ASBaseViewController : UIViewController<ASWaitingViewDelegate, ASObjectDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSString *pageKey;

- (void)navTo:(NSString *)key;
- (void)navBack;
- (BOOL)viewControllerShouldNavBack;

- (void)alert:(NSString *)msg;

- (void)showWaiting;
- (void)showWaitingTitle:(NSString *)title;
- (void)hideWaiting;
- (void)didShowWaiting;
- (void)didHideWaiting;
@end
