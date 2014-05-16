//
//  ZiWeiMod.m
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "Paipan.h"
#import "NSDate+Addition.h"
#import "ZiWeiMod.h"
#import "BaziMod.h"

@implementation ZiWeiMod

- (UIImage *)centerImage:(BOOL)lxTag
{
    NSDictionary *bAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : [UIColor blackColor]};
    NSDictionary *blAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorBlue};
    NSDictionary *rAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorRed};
    NSDictionary *gAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:__TextFont], NSForegroundColorAttributeName : ZWColorGreen};
    
    CGSize size = CGSizeZero;
    if(lxTag){
        size = CGSizeMake(__LxCellSize.width * 2, __LxCellSize.height *2);
    }else{
        size = CGSizeMake(__CellSize.width * 2, __CellSize.height * 2);
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);

    CGFloat top = 15;
    UIImage *logo = [UIImage imageNamed:@"logo_pan"];
    CGFloat left = size.width/2 - logo.size.width/2;
    [logo drawInRect:CGRectMake(left, top, logo.size.width, logo.size.height)];
    top += logo.size.height + 10;
    
    //line1
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    if(false){ //姓名
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:blAttribute]];
    }
    NSString *tmp = [NSString stringWithFormat:@"%@%@  虚岁： %d", [__ShuXing objectAtIndex:self.ShuXing], [__Gender objectAtIndex:self.Gender], self.Age];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:tmp attributes:bAttribute]];
    [str drawAtPoint:CGPointMake(10, top)];
    top += __FontSize.height;
    
    //line2
    tmp = [NSString stringWithFormat:@"公历：%@", [self.BirthTime.Date toStrFormat:@"yyyy-M-d HH:mm"]];
    str = [[NSMutableAttributedString alloc] initWithString:tmp attributes:bAttribute];
    [str addAttributes:rAttribute range:NSMakeRange(3, [tmp length] - 3)];
    [str drawAtPoint:CGPointMake(10, top)];
    top += __FontSize.height;
    
    //line3
    str = [[NSMutableAttributedString alloc] initWithString:@"阴历：" attributes:bAttribute];
    tmp = [NSString stringWithFormat:@"%@%@", GetTianGan(self.BirthTime.NongliTG), GetDiZhi(self.BirthTime.NongliDZ)];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:tmp attributes:rAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"年" attributes:bAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:GetNongliMonth(self.BirthTime.NongliMonth) attributes:rAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"月" attributes:bAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetNongliDay(self.BirthTime.NongliDay), GetDiZhi(self.BirthTime.NongliHour)] attributes:rAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"时生" attributes:bAttribute]];
    [str drawAtPoint:CGPointMake(10, top)];
    top += __FontSize.height;
    
    if(lxTag){
        //退运到
        tmp = [NSString stringWithFormat:@"退运至：%@", [self.TransitTime.Date toStrFormat:@"yyyy-M-d HH:mm"]];
        str = [[NSMutableAttributedString alloc] initWithString:tmp attributes:bAttribute];
        [str addAttributes:rAttribute range:NSMakeRange(4, [tmp length] - 4)];
        [str drawAtPoint:CGPointMake(10, top)];
        top += __FontSize.height;
    }
    
    //line4
    tmp = [NSString stringWithFormat:@"子年斗君：%@  %@", GetDiZhi(self.ZiDou), [__ZiWeiMingJu objectForKey:@(self.MingJu)]];
    str = [[NSMutableAttributedString alloc] initWithString:tmp attributes:bAttribute];
    [str drawAtPoint:CGPointMake(10, top)];
    top += __FontSize.height;
    
    //line5
    tmp = [NSString stringWithFormat:@"命主：%@  身主：%@", GetZiWeiStar(self.MingZhu), GetZiWeiStar(self.ShenZhu)];
    str = [[NSMutableAttributedString alloc] initWithString:tmp attributes:bAttribute];
    [str drawAtPoint:CGPointMake(10, top)];
    top += __FontSize.height;
    
    BaziMod *m_bazi = [[BaziMod alloc] initWithDateEntity:self.BirthTime];
    
    //流限
    if(lxTag){
        str = [[NSMutableAttributedString alloc] initWithString:@"流年" attributes:bAttribute];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetTianGan(self.TransitTime.NongliTG), GetDiZhi(self.TransitTime.NongliDZ)] attributes:gAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"  流月" attributes:bAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@月 %@%@", GetNongliMonth(self.TransitTime.NongliMonth), GetTianGan(2*(self.TransitTime.NongliTG - 1) + self.TmpLiuMonth + 1), GetDiZhi(self.TmpLiuMonth + 1)] attributes:gAttribute]];
        [str drawAtPoint:CGPointMake(10, top)];
        
        top += __FontSize.height;
        str = [[NSMutableAttributedString alloc] initWithString:@"流日" attributes:bAttribute];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@%@", GetNongliDay(self.TransitTime.NongliDay), GetTianGan(m_bazi.DayTG), GetDiZhi(m_bazi.DayDZ)] attributes:gAttribute]];
        [str drawAtPoint:CGPointMake(10, top)];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"  小限在" attributes:bAttribute]];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:GetDiZhi(self.XiaoXian) attributes:gAttribute]];
        [str drawAtPoint:CGPointMake(10, top)];
        top += __FontSize.height;
    }
    
    //line6
    CGFloat tableft = 10;
    top += __FontSize.height;
    str = [[NSMutableAttributedString alloc] initWithString:GetShiChenByTg(m_bazi.YearTG, m_bazi.DayTG) attributes:gAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    tableft += 38;
    str = [[NSMutableAttributedString alloc] initWithString:GetShiChenByTg(m_bazi.MonthTG, m_bazi.DayTG) attributes:gAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    tableft += 38;
    str = [[NSMutableAttributedString alloc] initWithString:@"日主" attributes:gAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    tableft += 38;
    str = [[NSMutableAttributedString alloc] initWithString:GetShiChenByTg(m_bazi.DayTG, m_bazi.DayTG) attributes:gAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    
    //line7
    top += __FontSize.height;
    tableft = 10;
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetTianGan(m_bazi.YearTG), GetDiZhi(m_bazi.YearDZ)] attributes:rAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    tableft += 38;
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetTianGan(m_bazi.MonthTG), GetDiZhi(m_bazi.MonthDZ)] attributes:rAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    tableft += 38;
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetTianGan(m_bazi.DayTG), GetDiZhi(m_bazi.DayDZ)] attributes:rAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    tableft += 38;
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetTianGan(m_bazi.HourTG), GetDiZhi(m_bazi.HourDZ)] attributes:rAttribute];
    [str drawAtPoint:CGPointMake(tableft, top)];
    
    //line8 - 10
    tableft = 10;
    for(int j = 0; j < 3 ; j++){
        top += __FontSize.height;
        for(int i = 0; i < 4; i++){
            NSInteger cg = [m_bazi getCangGanByX:i andY:j];
            if(!(j != 0 && cg == 0)){
                str = [[NSMutableAttributedString alloc] init];
                [str appendAttributedString:[[NSAttributedString alloc] initWithString:GetTianGan(cg) attributes:bAttribute]];
                [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@   ", GetShiChenByTg(cg,m_bazi.DayTG)] attributes:blAttribute]];
                [str drawAtPoint:CGPointMake(tableft + i * 38, top)];
            }
        }
    }
    
    //旬空
    top += __FontSize.height;
    str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"旬空: " attributes:bAttribute]];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", GetTianGan(m_bazi.XunKong0), GetDiZhi(m_bazi.XunKong1)] attributes:rAttribute]];
    [str drawAtPoint:CGPointMake(10, top)];
    
    //边框
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1);
    CGContextSetStrokeColorWithColor(ctx, ASColorDarkGray.CGColor);
    CGContextMoveToPoint(ctx, size.width, 0);
    CGContextAddLineToPoint(ctx, size.width, size.height);
    CGContextAddLineToPoint(ctx, 0, size.height);
    CGContextStrokePath(ctx);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
