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

@property (nonatomic, strong) UIImageView *ivShangBg;
@property (nonatomic, strong) UILabel *lbShang1;
@property (nonatomic, strong) UILabel *lbShang2;

@property (nonatomic, strong) UILabel *lbReadCount;
@property (nonatomic, strong) UILabel *lbReplyCount;
@property (nonatomic, strong) UILabel *lbDate;

- (void)setQuestion:(id<ASQaFullProtocol>)obj;
@end
