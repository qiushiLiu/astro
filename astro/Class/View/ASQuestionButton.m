//
//  ASQuestionButton.m
//  astro
//
//  Created by kjubo on 14-8-1.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASQuestionButton.h"

@interface ASQuestionButton ()
@property (nonatomic, strong) UILabel *lbInfo;
@end

@implementation ASQuestionButton

- (id)initWithFrame:(CGRect)frame iconName:(NSString *)iconName preFix:(NSString *)preFix
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 5;
        
        UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        icon.origin = CGPointMake(10, 5);
        [self addSubview:icon];
        
        UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        arrow.highlightedImage = [UIImage imageNamed:@"arrow_right_hl"];
        arrow.right = self.width - 10;
        arrow.centerY = icon.centerY;
        [self addSubview:arrow];
        
        UILabel *lbPrefix = [ASControls newRedTextLabel:CGRectMake(0, 0, 100, 30)];
        lbPrefix.text = [preFix copy];
        [lbPrefix sizeToFit];
        lbPrefix.left = icon.right + 10;
        lbPrefix.centerY = icon.centerY;
        [self addSubview:lbPrefix];
        
        UIImageView *ivLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_dash"]];
        ivLine.left = lbPrefix.left - 5;
        ivLine.top = icon.bottom;
        [self addSubview:ivLine];
        
        self.lbInfo = [ASControls newGrayTextLabel:CGRectMake(icon.left, ivLine.bottom, 250, 28)];
        [self addSubview:self.lbInfo];
    }
    return self;
}

- (void)setInfoText:(NSString *)info{
    self.lbInfo.text = [info copy];
}

@end
