//
//  ASAskTableViewCell.m
//  astro
//
//  Created by kjubo on 14-5-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskTableViewCell.h"
//#import "ASQaMinAstro.h"
#import "ASQaMinBazi.h"
//#import "ASQaMinZiWei.h"
#import "ASZiweiGrid.h"
@implementation ASAskTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        // Initialization code
        self.bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 310, 1)];
        self.bg.backgroundColor = [UIColor whiteColor];
        self.bg.layer.borderWidth = 1;
        self.bg.layer.borderColor = [UIColor grayColor].CGColor;
        self.bg.layer.cornerRadius = 8;
        [self.contentView addSubview:self.bg];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 280, 0)];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = ASColorDarkRed;
        self.lbTitle.numberOfLines = 2;
        self.lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
        self.lbTitle.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.lbTitle];
        
        self.panView = [[ASPanView alloc] initWithFrame:CGRectMake(self.lbTitle.left, 0, self.lbTitle.width, 0)];
        [self.contentView addSubview:self.panView];
        
        self.separated = [[UIView alloc] initWithFrame:CGRectMake(self.lbTitle.left, 0, self.lbTitle.width, 1)];
        self.separated.backgroundColor = [UIColor blackColor];
        self.separated.alpha = 0.2;
        [self.contentView addSubview:self.separated];
        
        //-- bottomView SubView
        self.ivReply = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_huifu"]];
        [self.contentView addSubview:self.ivReply];
        
        self.lbReply = [self newBlueLable];
        [self.contentView addSubview:self.lbReply];
        
        self.ivOffer = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_shang"]];
        [self.contentView addSubview:self.ivOffer];
        
        self.lbOffer = [self newBlueLable];
        [self.contentView addSubview:self.lbOffer];
        
        self.lbFrom = [self newBlueLable];
        [self.contentView addSubview:self.lbFrom];
    }
    return self;
}

- (UILabel *)newBlueLable{
    UILabel *lb = [[UILabel alloc] init];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = ASColorBlue;
    return lb;
}

+ (CGFloat)heightFor:(id<ASQaProtocol>)model width:(CGFloat)width{
    CGFloat height = 60;
    height += [model.Title sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    height += [ASPanView heightForChart:[model Chart] context:model.Context width:width];
    return height;
}

- (void)setModelValue:(id<ASQaProtocol>)model nickName:(NSString *)nickName{
    self.lbTitle.text = [model.Title copy];
    self.lbTitle.height = [self.lbTitle.text sizeWithFont:self.lbTitle.font constrainedToSize:CGSizeMake(self.lbTitle.width, 50) lineBreakMode:NSLineBreakByCharWrapping].height;
    CGFloat top = self.lbTitle.bottom + 5;
    
    [self.panView setChart:[model Chart] context:[model Context]];
    self.panView.top = top;
    top = self.panView.bottom;
    
    self.separated.top = top;
    top += 5;
    
    self.ivReply.origin = CGPointMake(self.lbTitle.left, top);
    self.lbReply.text = [NSString stringWithFormat:@"%@回复", @(model.ReplyCount)];
    [self.lbReply sizeToFit];
    self.lbReply.left = self.ivReply.right + 2;
    self.lbReply.centerY = self.ivReply.centerY;
    
    self.ivOffer.origin = CGPointMake(self.lbReply.right + 5, top);
    self.lbOffer.text = [NSString stringWithFormat:@"%@灵签", @(model.Award)];
    [self.lbOffer sizeToFit];
    self.lbOffer.left = self.ivOffer.right + 2;
    self.lbOffer.centerY = self.ivOffer.centerY;
    
    self.lbFrom.text = [NSString stringWithFormat:@"%@ %@", nickName, [model.TS toStrFormat:@"HH:mm"]];
    [self.lbFrom sizeToFit];
    self.lbFrom.right = self.lbTitle.right;
    self.lbFrom.centerY = self.lbReply.centerY;
    
    self.bg.height = self.lbFrom.bottom + 5;
}

@end
