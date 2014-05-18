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
#import "ASQaMinZiWei.h"
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
        
        self.pan1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.pan1];
        self.pan2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.pan2];
        
        self.lbAstroIntro = [[UILabel alloc] init];
        self.lbAstroIntro.backgroundColor = [UIColor clearColor];
        self.lbAstroIntro.font = [UIFont systemFontOfSize:12];
        self.lbAstroIntro.numberOfLines = 0;
        self.lbAstroIntro.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.lbAstroIntro];
        
        self.lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(self.lbTitle.left, 0, self.lbTitle.width, 0)];
        self.lbDetail.backgroundColor = [UIColor clearColor];
        self.lbDetail.font = [UIFont systemFontOfSize:12];
        self.lbDetail.numberOfLines = 0;
        self.lbDetail.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.lbDetail];
        
        self.separated = [[UIView alloc] initWithFrame:CGRectMake(self.lbTitle.left, 0, self.lbTitle.width, 1)];
        self.separated.backgroundColor = ASColorDarkGray;
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
    CGFloat height = 25;
    if([model isKindOfClass:[ASQaMinAstro class]]){
        ASQaMinAstro *obj = (ASQaMinAstro *)model;
        height += 165 *  [obj.Chart count];
    }else if([model isKindOfClass:[ASQaMinBazi class]]){
        ASQaMinBazi *obj = (ASQaMinBazi *)model;
        height += 42 *  [obj.Chart count];
    }else if([model isKindOfClass:[ASQaMinZiWei class]]){
        ASQaMinZiWei *obj = (ASQaMinZiWei *)model;
        if([obj.Chart count] > 0){
            height += __CellSize.height + 8;
        }
    }
    NSString *temp = [NSString stringWithFormat:@"%@\n%@", model.Title, model.Context];
    height += [temp sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
    height += 40;
    return height;
}

- (void)setModelValue:(ASQaBase *)model{
    self.lbTitle.text = [model.Title copy];
    self.lbTitle.height = [self.lbTitle.text sizeWithFont:self.lbTitle.font constrainedToSize:CGSizeMake(self.lbTitle.width, 50) lineBreakMode:NSLineBreakByCharWrapping].height;
//    self.lbTitle.top = 25;
    CGFloat top = self.lbTitle.bottom + 5;
    
    //关闭特殊星盘的现实控件
    self.pan1.transform = CGAffineTransformIdentity;
    self.pan2.hidden = YES;
    self.lbAstroIntro.hidden = YES;
    
    if([model isKindOfClass:[ASQaMinAstro class]]){
        ASQaMinAstro *obj = (ASQaMinAstro *)model;
        AstroMod *panModel;
        if(obj.Chart && [obj.Chart count] >= 1){
            panModel = [obj.Chart objectAtIndex:0];
            self.pan1.image = [panModel paipan];
            self.pan1.size = self.pan1.image.size;
            self.pan1.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.pan1.origin = CGPointMake(self.lbTitle.left, top);
            top = self.pan1.bottom + 5;
            self.pan1.hidden = NO;
            
            NSMutableString *intro = [NSMutableString stringWithFormat:@"外圈\t%@\n%@\n%@\n", [ASHelper sexText:panModel.Gender], [panModel.birth toStrFormat:@"yyyy-MM-dd HH:mm"], panModel.position.name];
            if(panModel.birth1){
                [intro appendFormat:@"外圈\t%@\n%@\n%@\n", [ASHelper sexText:panModel.Gender], [panModel.birth1 toStrFormat:@"yyyy-MM-dd HH:mm"], panModel.position1.name];
            }
            self.lbAstroIntro.text = intro;
            [self.lbAstroIntro sizeToFit];
            self.lbAstroIntro.origin = CGPointMake(self.pan1.right + 5, self.pan1.top);
            self.lbAstroIntro.hidden = NO;
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
    }else if([model isKindOfClass:[ASQaMinZiWei class]]){
        ASQaMinZiWei *obj = (ASQaMinZiWei *)model;
        ZiWeiMod *panModel;
        if(obj.Chart && [obj.Chart count] >= 1){
            panModel = [obj.Chart objectAtIndex:0];
            
            NSMutableDictionary *gongs = [NSMutableDictionary dictionary];
            NSArray *arr = @[@(panModel.Ming), @((panModel.Ming + 6)%12), @((panModel.Ming + 4)%12), @((panModel.Ming + 10)%12)];
            for(int i = 0; i < 4; i++){
                NSInteger index = [[arr objectAtIndex:i] intValue];
                ASZiWeiGrid *gd = [[ASZiWeiGrid alloc] initWithZiWei:panModel index:index lx:NO];
                if(i < 3){
                    gd.borderEdge = UIEdgeInsetsMake(1, 1, 1, 0);
                }else{
                    gd.borderEdge = UIEdgeInsetsMake(1, 1, 1, 1);
                }
                gd.origin = CGPointMake(i * gd.width, 0);
                gd.tag = i + 100;
                [gongs setObject:gd forKey:@(index)];
                [self.pan1 addSubview:gd];
            }

            //星旺宫
            for(int i = 0; i < [panModel.Xing count]; i++){
                if(i == 58 ||  i == 59 || i == 62 || i == 63 || i == 66 || i == 64 || i == 67){
                    continue;
                }
                ZiWeiStar *star = [panModel.Xing objectAtIndex:i];
                if(![[gongs allKeys] containsObject:@(star.Gong)]){
                    continue;
                }
                ASZiWeiGrid *gd = [gongs objectForKey:@(star.Gong)];
                [gd addStar:star withIndex:i];
            }
            self.pan1.size = CGSizeMake(__CellSize.width * 4, __CellSize.height);
            self.pan1.transform = CGAffineTransformMakeScale(0.85, 0.85);
            
            self.pan1.origin = CGPointMake(self.lbTitle.left, top);
            top = self.pan1.bottom + 5;
            self.pan1.hidden = NO;
        }else{
            self.pan1.hidden = YES;
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
    self.lbReply.text = [NSString stringWithFormat:@"%d灵签", model.ReplyCount];
    [self.lbReply sizeToFit];
    self.lbReply.left = self.ivReply.right + 2;
    self.lbReply.centerY = self.ivReply.centerY;
    
    self.ivOffer.origin = CGPointMake(self.lbReply.right + 5, top);
    self.lbOffer.text = [NSString stringWithFormat:@"%d灵签", model.Award];
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
