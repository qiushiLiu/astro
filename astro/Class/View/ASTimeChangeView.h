//
//  ASTimeChangeView.h
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASTimeChangeView;
@protocol ASTimeChangeViewDelegate <NSObject>

@optional
- (void)timeChangView:(ASTimeChangeView *)tcView withDirection:(NSInteger)direction andSelectedIndex:(NSInteger)selectedIndex;

@end

@interface ASTimeChangeView : UIView
@property (nonatomic, assign) id<ASTimeChangeViewDelegate> delegate;
@property (nonatomic) NSInteger selectedIndex;

- (void)setItems:(NSArray *)items;
+ (instancetype)newTimeChangeView;

@end
