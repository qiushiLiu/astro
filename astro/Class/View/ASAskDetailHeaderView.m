//
//  ASAskDetailHeaderView.m
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailHeaderView.h"

@implementation ASAskDetailHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat left = 5;
        CGFloat top = 5;
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(left, top, self.width - 2*left, 1)];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = ASColorDarkRed;
        self.lbTitle.font = [UIFont systemFontOfSize:16];
        self.lbTitle.numberOfLines = 2;
        [self addSubview:self.lbTitle];
        
        self.vline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 1)];
        self.vline.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:self.vline];
    }
    return self;
}

- (void)setQuestion:(id<ASQaProtocol>)obj{
    self.lbTitle.text = [obj Title];
    self.lbTitle.height = [self.lbTitle.text boundingRectWithSize:CGSizeMake(self.lbTitle.width, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lbTitle.font} context:nil].size.height;
    
    self.height = self.lbTitle.bottom + 10;
    self.vline.bottom = self.height;
}

@end
