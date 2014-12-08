//
//  ASBaseViewController.h
//  astro
//
//  Created by kjubo on 13-12-16.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASWaitingView.h"
@interface ASBaseViewController : UIViewController

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) NSString *pageKey;

- (void)setNavToParams:(NSDictionary *)params;
- (void)setNavBackParams:(NSDictionary *)params;
- (ASBaseViewController *)navTo:(NSString *)key;
- (ASBaseViewController *)navTo:(NSString *)key params:(NSDictionary *)params;
- (ASBaseViewController *)navBack;
- (ASBaseViewController *)navBackTo:(NSString *)key params:(NSDictionary *)params;

- (BOOL)viewControllerShouldNavBack;
- (void)alert:(NSString *)msg;
- (void)showWaiting;
- (void)showWaitingTitle:(NSString *)title;
- (void)hideWaiting;
- (void)didShowWaiting;
- (void)didHideWaiting;

- (void)navToUserCenter:(NSInteger)uid;
@end
