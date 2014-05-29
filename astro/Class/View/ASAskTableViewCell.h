//
//  ASAskTableViewCell.h
//  astro
//
//  Created by kjubo on 14-5-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASQaBase.h"

@interface ASAskTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *bg;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UIImageView *pan1;
@property (nonatomic, strong) UIImageView *pan2;
@property (nonatomic, strong) UILabel *lbAstroIntro;    //占星盘的简介
@property (nonatomic, strong) UILabel *lbDetail;        //问题说明

@property (nonatomic, strong) UIView *separated;        //分割线
@property (nonatomic, strong) UIImageView *ivReply;     //回复图标;
@property (nonatomic, strong) UILabel *lbReply;         //回复数量
@property (nonatomic, strong) UIImageView *ivOffer;     //悬赏图标
@property (nonatomic, strong) UILabel *lbOffer;         //悬赏
@property (nonatomic, strong) UILabel *lbFrom;          //发帖人和时间

+ (CGFloat)heightFor:(ASQaBase *)model;
- (void)setModelValue:(ASQaBase *)model;
@end