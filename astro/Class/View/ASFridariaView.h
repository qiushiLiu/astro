//
//  ASFridariaView.h
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASFirdariaDecade.h"

@protocol ASFridariaViewDelegate <NSObject>

@optional
- (void)fridariaView:(NSInteger)section selectedIndex:(NSInteger)index;

@end

@interface ASFridariaView : UIView
@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, weak) ASFirdariaDecade *data;
@property (nonatomic, assign) id<ASFridariaViewDelegate> delegate;

+ (instancetype)newFridariaView;
- (void)setSection:(NSInteger)section forData:(ASFirdariaDecade *)data;
@end
