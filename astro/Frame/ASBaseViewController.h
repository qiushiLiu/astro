//
//  ASBaseViewController.h
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASTopView.h"

typedef enum {
    NavStyleDefault = 0,
    NavStyleBottomToTop,
    NavStyleTopToBottom,
    NavStyleLeftToRight,
    NavStyleFadeIn,
    NavStyleFadeOut,
    NavStyleNoEffect,
} NavStyle;

@interface ASBaseViewController : UIViewController<ASTopViewDelegate>

@property (nonatomic, strong) ASTopView *topView;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSString *pageKey;


- (void)changeRightButtonTitle:(NSString *)title;
- (void)changeTitle:(NSString *)title;

- (void)alert:(NSString *)msg;
@end
