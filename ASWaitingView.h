//
//  ASWaitingView.h
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASBaseViewController;
@interface ASWaitingView : UIView

@property (nonatomic, assign) ASBaseViewController *viewController;

- (id)initWithBaseViewController:(ASBaseViewController *)vc;
- (void)showWating:(NSString *)tips;
- (void)hideWaiting;
@end
