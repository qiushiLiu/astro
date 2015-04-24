//
//  ASDiceView.h
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ASDiceView;
@protocol ASDiceViewDelegate <NSObject>
- (void)didFinishedDiceView:(ASDiceView *)dv;
@end

@interface ASDiceView : UIView
@property (nonatomic) NSInteger star;
@property (nonatomic, readonly) BOOL animateing;
@property (nonatomic, readonly) NSInteger constellation;
@property (nonatomic) NSInteger gong;
@property (nonatomic, assign) id<ASDiceViewDelegate> delegate;
- (void)start;
@end
