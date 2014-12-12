//
//  ASPanView.m
//  astro
//
//  Created by kjubo on 14-6-3.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPanView.h"
#import "AstroMod.h"
#import "BaziMod.h"
#import "ZiWeiMod.h"
#import "ASZiWeiGrid.h"

@interface ASPanView()
@property (nonatomic, strong) UILabel *lbAstroIntro;    //占星盘的简介
@property (nonatomic, strong) UILabel *lbDetail;        //问题说明
@end

@implementation ASPanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.pan1 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.pan1.userInteractionEnabled = YES;
        [self addSubview:self.pan1];
        self.pan2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.pan2.userInteractionEnabled = YES;
        [self addSubview:self.pan2];
        
        self.lbAstroIntro = [[UILabel alloc] init];
        self.lbAstroIntro.backgroundColor = [UIColor clearColor];
        self.lbAstroIntro.font = [UIFont systemFontOfSize:12];
        self.lbAstroIntro.numberOfLines = 0;
        self.lbAstroIntro.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.lbAstroIntro];
        
        self.lbDetail = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        self.lbDetail.backgroundColor = [UIColor clearColor];
        self.lbDetail.font = [UIFont systemFontOfSize:12];
        self.lbDetail.numberOfLines = 0;
        self.lbDetail.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.lbDetail];
    }
    return self;
}

- (void)setChart:(NSArray *)chartList context:(NSString *)context{
    //关闭特殊星盘的现实控件
    self.pan1.transform = CGAffineTransformIdentity;
    self.pan1.hidden = YES;
    self.pan2.hidden = YES;
    self.lbAstroIntro.hidden = YES;
    
    CGFloat top = 0;
    
    if([context length] > 0){
        self.lbDetail.hidden = NO;
        self.lbDetail.text = [context copy];
        self.lbDetail.height = [self.lbDetail.text boundingRectWithSize:CGSizeMake(self.lbDetail.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lbDetail.font} context:nil].size.height;
        self.lbDetail.origin = CGPointMake(0, top);
        top = self.lbDetail.bottom + 5;
    }else{
        self.lbDetail.hidden = YES;
    }
    
    id chart1 = [chartList firstObject];
    if([chart1 isKindOfClass:[AstroMod class]]){
        AstroMod *panModel = (AstroMod *)chart1;
        self.pan1.image = [panModel paipan];
        self.pan1.size = self.pan1.image.size;
        self.pan1.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.pan1.origin = CGPointMake(0, top);
        self.pan1.hidden = NO;
        top = self.pan1.bottom + 5;
        
        NSMutableString *intro = [NSMutableString stringWithFormat:@"外圈\t%@\n%@\n%@\n", [ASHelper sexText:panModel.Gender], [panModel.birth toStrFormat:@"yyyy-MM-dd HH:mm"], panModel.position.name];
        if(panModel.birth1){
            [intro appendFormat:@"外圈\t%@\n%@\n%@\n", [ASHelper sexText:panModel.Gender], [panModel.birth1 toStrFormat:@"yyyy-MM-dd HH:mm"], panModel.position1.name];
        }
        
        self.lbAstroIntro.text = intro;
        [self.lbAstroIntro sizeToFit];
        self.lbAstroIntro.origin = CGPointMake(self.pan1.right + 5, self.pan1.top);
        self.lbAstroIntro.hidden = NO;
        
    }else if([chart1 isKindOfClass:[BaziMod class]]){
        BaziMod *panModel = (BaziMod *)chart1;
        self.pan1.image = [panModel paipanSimple];
        self.pan1.size = self.pan1.image.size;
        self.pan1.origin = CGPointMake(0, top);
        self.pan1.hidden = NO;
        top = self.pan1.bottom + 5;
        
        if([chartList count] > 1){
            panModel = [chartList objectAtIndex:1];
            self.pan2.image = [panModel paipanSimple];
            self.pan2.size = self.pan2.image.size;
            self.pan2.origin = CGPointMake(0, top);
            top = self.pan2.bottom + 5;
            self.pan2.hidden = NO;
        }else{
            self.pan2.hidden = YES;
        }
    }else if([chart1 isKindOfClass:[ZiWeiMod class]]){
        ZiWeiMod *panModel = (ZiWeiMod *)chart1;
        [self.pan1 removeAllSubViews];
        UIImageView *iv = [panModel paipanSimple];
        [self.pan1 addSubview:iv];
        self.pan1.size = iv.size;
        self.pan1.transform = CGAffineTransformMakeScale(0.85, 0.85);
        self.pan1.origin = CGPointMake(0, top);
        top = self.pan1.bottom + 5;
        self.pan1.hidden = NO;
    }
    
    self.height = top;
}


+ (CGFloat)heightForChart:(NSArray *)chart context:(NSString *)context width:(CGFloat)width{
    CGFloat height = 0;
    if([chart count] > 0){
        id chart1 = [chart firstObject];
        if([chart1 isKindOfClass:[AstroMod class]]){
            height += 165 *  [chart count];
        }else if([chart1 isKindOfClass:[BaziMod class]]){
            height += 42 *  [chart count];
        }else if([chart1 isKindOfClass:[ZiWeiMod class]]){
            height += __CellSize.height * 0.9 + 3;
        }
    }
    
    if([context length] > 0){
        height += [context boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
    }
    
    return height;
}

@end
