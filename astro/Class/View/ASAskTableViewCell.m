//
//  ASAskTableViewCell.m
//  astro
//
//  Created by kjubo on 14-5-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskTableViewCell.h"
#import "ASQaMinAstro.h"
#import "ASQaMinBazi.h"

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
        self.bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 300, 1)];
        self.bg.backgroundColor = [UIColor whiteColor];
        self.bg.layer.borderWidth = 1;
        self.bg.layer.borderColor = [UIColor grayColor].CGColor;
        self.bg.layer.cornerRadius = 8;
        [self.contentView addSubview:self.bg];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 280, 0)];
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.textColor = ASColorDarkRed;
        self.lbTitle.numberOfLines = 2;
        self.lbTitle.lineBreakMode = NSLineBreakByCharWrapping;
        self.lbTitle.font = [UIFont boldSystemFontOfSize:14];
        [self.contentView addSubview:self.lbTitle];
        
        self.pan1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.pan1];
        self.pan2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.pan2];
        
        self.lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(self.lbTitle.left, 0, self.lbTitle.width, 0)];
        self.lbDetail.backgroundColor = [UIColor clearColor];
        self.lbDetail.font = [UIFont systemFontOfSize:12];
        self.lbDetail.numberOfLines = 0;
        self.lbDetail.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.lbDetail];
        
        self.separated = [[UIView alloc] initWithFrame:CGRectMake(self.lbTitle.left, 0, self.lbTitle.width, 1)];
        self.separated.backgroundColor = [UIColor blackColor];
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

+ (CGFloat)heightFor:(ASQaBase *)model{
    CGFloat height = 20;
    if([model isKindOfClass:[ASQaMinAstro class]]){
        height += 160;
    }else if([model isKindOfClass:[ASQaMinBazi class]]){
        ASQaMinBazi *obj = (ASQaMinBazi *)model;
        height += 45 *  [obj.Chart count];
    }
    NSString *temp = [NSString stringWithFormat:@"%@\n%@", model.Title, model.Context];
    height += [temp sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    height += 40;
    return height;
}

- (void)setModelValue:(ASQaBase *)model{
    self.lbTitle.text = [model.Title copy];
    self.lbTitle.height = [self.lbTitle.text sizeWithFont:self.lbTitle.font constrainedToSize:CGSizeMake(self.lbTitle.width, 50) lineBreakMode:NSLineBreakByCharWrapping].height;
    self.lbTitle.top = 10;
    CGFloat top = self.lbTitle.bottom + 5;
    
    if([model isKindOfClass:[ASQaMinAstro class]]){
        ASQaMinAstro *obj = (ASQaMinAstro *)model;
        AstroMod *panModel;
        if(obj.Chart && [obj.Chart count] >= 1){
            panModel = [obj.Chart objectAtIndex:0];
            self.pan1.image = [panModel paipan];
            self.pan1.size = self.pan1.image.size;
            self.pan1.origin = CGPointMake(self.lbTitle.left, top);
            top = self.pan1.bottom + 5;
            self.pan1.hidden = NO;
        }else{
            self.pan1.hidden = YES;
        }
    }else if([model isKindOfClass:[ASQaMinBazi class]]){
        ASQaMinBazi *obj = (ASQaMinBazi *)model;
        BaziMod *panModel;
        if(obj.Chart && [obj.Chart count] >= 1){
            panModel = [obj.Chart objectAtIndex:0];
            self.pan1.image = [panModel paipanSimple];
            self.pan1.size = self.pan1.image.size;
            self.pan1.origin = CGPointMake(self.lbTitle.left, top);
            top = self.pan1.bottom + 5;
            self.pan1.hidden = NO;
        }else{
            self.pan1.hidden = YES;
        }
        
        if(obj.Chart && [obj.Chart count] >= 2){
            panModel = [obj.Chart objectAtIndex:1];
            self.pan2.image = [panModel paipanSimple];
            self.pan2.size = self.pan2.image.size;
            self.pan2.origin = CGPointMake(self.lbTitle.left, top);
            top = self.pan2.bottom + 5;
            self.pan2.hidden = NO;
        }else{
            self.pan2.hidden = YES;
        }
    }
    
    if([model.Context length] > 0){
        self.lbDetail.text = [model.Context copy];
        self.lbDetail.height = [self.lbDetail.text sizeWithFont:self.lbDetail.font constrainedToSize:CGSizeMake(self.lbDetail.width, CGFLOAT_MAX) lineBreakMode:self.lbDetail.lineBreakMode].height;
        self.lbDetail.origin = CGPointMake(self.lbTitle.left, top);
        top = self.lbDetail.bottom + 5;
    }
    
    self.separated.top = top;
    top += 5;
    
    self.ivReply.origin = CGPointMake(self.lbTitle.left, top);
    self.lbReply.text = [NSString stringWithFormat:@"%ld灵签", model.ReplyCount];
    [self.lbReply sizeToFit];
    self.lbReply.left = self.ivReply.right + 2;
    self.lbReply.centerY = self.ivReply.centerY;
    
    self.ivOffer.origin = CGPointMake(self.lbReply.right + 5, top);
    self.lbOffer.text = [NSString stringWithFormat:@"%ld灵签", model.Award];
    [self.lbOffer sizeToFit];
    self.lbOffer.left = self.ivOffer.right + 2;
    self.lbOffer.centerY = self.ivOffer.centerY;
    
    self.lbFrom.text = [NSString stringWithFormat:@"%@ %@", model.CustomerNickName, [model.TS toStrFormat:@"HH:mm"]];
    [self.lbFrom sizeToFit];
    self.lbFrom.right = self.lbTitle.right;
    self.lbFrom.centerY = self.lbReply.centerY;
    
    self.bg.height = self.lbFrom.bottom + 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
