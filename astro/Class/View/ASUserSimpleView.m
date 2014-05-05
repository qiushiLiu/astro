//
//  ASUserSimpleView.m
//  astro
//
//  Created by kjubo on 14-4-11.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASUserSimpleView.h"

@implementation ASUserSimpleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.face = [[ASUrlImageView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
        self.lbName = [[UILabel alloc] initWithFrame:CGRectMake(self.face.right + 5, self.face.top, 100, 12)];
        self.lbName.font = [UIFont systemFontOfSize:14];
        self.lbName.backgroundColor = [UIColor clearColor];
        self.lbName.textColor = ASColorDarkRed;
        self.lbName.textAlignment = NSTextAlignmentLeft;
        self.lbName.text = @"姓名";
        
        self.lbIntro = [[UILabel alloc] initWithFrame:CGRectMake(self.lbName.left, self.lbName.bottom + 5, self.lbName.width, 28)];
        self.lbIntro.font = [UIFont systemFontOfSize:14];
        self.lbIntro.backgroundColor = [UIColor clearColor];
        self.lbIntro.textColor = ASColorDarkRed;
        self.lbIntro.numberOfLines = 2;
        self.lbIntro.textAlignment = NSTextAlignmentLeft;
        self.lbIntro.text = @"介绍";
        
        [self addSubview:self.face];
        [self addSubview:self.lbName];
        [self addSubview:self.lbIntro];
    }
    return self;
}

@end
