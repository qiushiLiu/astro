//
//  ASWaitingView.h
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASBaseViewController;


typedef void (^WaitingCompleteBlock) (void);

@interface ASWaitingView : UIView

@property (nonatomic, assign) ASBaseViewController *viewController;

- (id)initWithBaseViewController:(ASBaseViewController *)vc;
- (void)showWating:(NSString *)tips;
- (void)showWating:(NSString *)tips withComplete:(WaitingCompleteBlock)block;
- (void)hideWaiting;
- (void)hideWaitingWithComplete:(WaitingCompleteBlock)block;
@end
