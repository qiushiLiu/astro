//
//  ASWaitingView.h
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASBaseViewController;
@class ASWaitingView;
@protocol ASWaitingViewDelegate <NSObject>

@required
- (void)asWaitingViewDidShow:(ASWaitingView *)wv;
- (void)asWaitingViewDidHide:(ASWaitingView *)wv;

@end

@interface ASWaitingView : UIView
@property (nonatomic, assign) ASBaseViewController *viewController;
@property (nonatomic, assign) id<ASWaitingViewDelegate> delegate;

- (id)initWithBaseViewController:(ASBaseViewController *)vc;
- (void)showWating:(NSString *)title;
- (void)hideWaiting;
@end
