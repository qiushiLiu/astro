//
//  ASAskDetailHeaderView.m
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailHeaderView.h"

@implementation ASAskDetailHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat left = 5;
        CGFloat top = 5;
        
        self.ivDing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_ding"]];
        [self addSubview:self.ivDing];
        
        self.ivJing = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_jing"]];
        [self addSubview:self.ivJing];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top, self.width - 2*left, 1)];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = ASColorDarkRed;
        self.lbTitle.font = [UIFont systemFontOfSize:16];
        self.lbTitle.numberOfLines = 2;
        [self addSubview:self.lbTitle];
        
        self.ivShangBg = [[UIImageView alloc] initWithFrame:CGRectMake(left, 0, 220, 30)];
        self.ivShangBg.image = [[UIImage imageNamed:@""] stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        [self addSubview:self.ivShangBg];
        
        self.lbShang1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 80, 26)];
        self.lbShang1.backgroundColor = [UIColor whiteColor];
        self.lbShang1.font = [UIFont systemFontOfSize:14];
        self.lbShang1.textColor = [UIColor blackColor];
        self.lbShang1.centerY = self.ivShangBg.height/2;
        [self.ivShangBg addSubview:self.lbShang1];
        
        self.lbShang2 = [[UILabel alloc] initWithFrame:CGRectMake(self.lbShang1.right + 5, 0, 80, 26)];
        self.lbShang2.backgroundColor = [UIColor whiteColor];
        self.lbShang2.font = [UIFont systemFontOfSize:14];
        self.lbShang2.textColor = [UIColor blackColor];
        self.lbShang2.centerY = self.ivShangBg.height/2;
        [self.ivShangBg addSubview:self.lbShang2];
        
        self.lbReadCount = [[UILabel alloc] init];
        self.lbReadCount.backgroundColor = [UIColor clearColor];
        self.lbReadCount.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lbReadCount];
        
        self.lbReplyCount = [[UILabel alloc] init];
        self.lbReplyCount.backgroundColor = [UIColor clearColor];
        self.lbReplyCount.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lbReplyCount];
        
        self.lbDate = [[UILabel alloc] init];
        self.lbDate.backgroundColor = [UIColor clearColor];
        self.lbDate.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lbDate];
    }
    return self;
}

- (void)setQaBase:(id<ASQaProtocol>)obj{
    self.lbTitle.text = [obj Title];
    self.lbTitle.height = [self.lbTitle.text sizeWithFont:self.lbTitle.font constrainedToSize:CGSizeMake(self.lbTitle.width, 40) lineBreakMode:NSLineBreakByCharWrapping].height;
    
    self.ivShangBg.top = self.lbTitle.bottom + 5;
    self.lbShang1.text = [NSString stringWithFormat:@"%d灵签", [obj Award]];
    self.lbShang2.text = @"已结束";
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"浏览量: %d", [obj ReadCount]]];
    [str setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(3, str.length - 3)];
    self.lbReadCount.attributedText = str;
    [self.lbReadCount sizeToFit];
    self.lbReadCount.left = self.lbTitle.left;
    self.lbReadCount.top = self.ivShangBg.bottom + 10;
    
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复数: %d", [obj ReplyCount]]];
    [str setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(3, str.length - 3)];
    self.lbReplyCount.attributedText = str;
    [self.lbReplyCount sizeToFit];
    self.lbReplyCount.left = self.lbReadCount.right + 8;
    self.lbReplyCount.top = self.lbReadCount.top;
    
    self.lbDate.text = [[obj TS] toStrFormat:@"yyyy-MM-dd"];
    [self.lbDate sizeToFit];
    self.lbDate.right = self.lbTitle.right;
    self.lbDate.top = self.lbReadCount.top;
    
    self.height = self.lbDate.bottom + 10;
}

@end
