//
//  ASLoadMoreView.h
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASLoadMoreView : UIView
//是否正在更新
@property (nonatomic, readonly) BOOL isLoadingTag;
//所归属的tableview
@property (nonatomic, assign) UIScrollView *scrollView;

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (void)stopLoading;
@end
