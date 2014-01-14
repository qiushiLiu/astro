//
//  ASBaseViewController.h
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NavStyleDefault = 0,
    NavStyleBottomToTop,
    NavStyleTopToBottom,
    NavStyleLeftToRight,
    NavStyleFadeIn,
    NavStyleFadeOut,
    NavStyleNoEffect,
} NavStyle;

@interface ASBaseViewController : UIViewController

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSString *pageKey;

- (void)alert:(NSString *)msg;
@end
