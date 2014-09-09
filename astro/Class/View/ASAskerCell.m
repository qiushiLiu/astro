//
//  ASAskerCell.m
//  astro
//
//  Created by kjubo on 14-2-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskerCell.h"

@implementation ASAskerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        // Initialization code
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 5, 300, 70)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.borderWidth = 1;
        self.bgView.layer.borderColor = [UIColor grayColor].CGColor;
        self.bgView.layer.cornerRadius = 8;
        [self.contentView addSubview:self.bgView];
        
        self.icon = [[ASUrlImageView alloc] initWithFrame:CGRectMake(15, 15, 50, 50)];
        [self.contentView addSubview:self.icon];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, self.icon.top, 180, 16)];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = ASColorDarkRed;
        self.lbTitle.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.lbTitle];
        
        self.lbSummary = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, self.lbTitle.bottom + 2, 205, 32)];
        self.lbSummary.backgroundColor = [UIColor clearColor];
        self.lbSummary.textColor = [UIColor blackColor];
        self.lbSummary.font = [UIFont systemFontOfSize:12];
        self.lbSummary.numberOfLines = 2;
        [self.contentView addSubview:self.lbSummary];
        
        self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
        self.arrow.highlightedImage = [UIImage imageNamed:@"arrow_right_hl"];
        self.arrow.right = self.lbTitle.right + 40;
        self.arrow.centerY = self.icon.centerY;
        [self.contentView addSubview:self.arrow];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    self.arrow.highlighted = highlighted;
    if(highlighted){
        self.bgView.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.bgView.backgroundColor= [UIColor whiteColor];
    }
    [super setHighlighted:highlighted animated:animated];
}

@end
