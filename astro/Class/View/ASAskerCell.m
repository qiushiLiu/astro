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
        // Initialization code
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 10, 300, 60)];
        bg.backgroundColor = [UIColor whiteColor];
        bg.layer.borderWidth = 1;
        bg.layer.borderColor = UIColorFromRGB(0x584D46).CGColor;
        bg.layer.cornerRadius = 8;
        [self.contentView addSubview:bg];
        
        self.icon = [[ASUrlImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        [self.contentView addSubview:self.icon];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, self.icon.top, 200, 20)];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = UIColorFromRGB(0x863321);
        self.lbTitle.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.lbTitle];
        
        self.lbSummary = [[UILabel alloc] initWithFrame:CGRectMake(self.icon.right + 10, self.lbTitle.bottom + 5, 200, 40)];
        self.lbSummary.backgroundColor = [UIColor clearColor];
        self.lbSummary.textColor = [UIColor blackColor];
        self.lbSummary.font = [UIFont systemFontOfSize:14];
        self.lbSummary.numberOfLines = 2;
        [self.contentView addSubview:self.lbSummary];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
