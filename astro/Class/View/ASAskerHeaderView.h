//
//  ASAskerHeaderView.h
//  astro
//
//  Created by kjubo on 14-2-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASAskerHeaderViewDelegate <NSObject>

@optional
- (void)askerHeaderSelected:(NSInteger)tag;

@end

@interface ASAskerHeaderView : UIView

@property (nonatomic) NSInteger selected;
@property (nonatomic, readonly) NSString *selectedTitle;
@property (nonatomic, assign) id<ASAskerHeaderViewDelegate> delegate;

- (id)initWithItems:(NSArray *)items;
@end
