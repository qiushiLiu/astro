//
//  ASAskDetailHeaderView.h
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASQaProtocol.h"

@interface ASAskDetailHeaderView : UIView
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIImageView *ivDing;
@property (nonatomic, strong) UIImageView *ivJing;
@property (nonatomic, strong) UIView *vline;
- (void)setQuestion:(id<ASQaProtocol>)obj;
@end
