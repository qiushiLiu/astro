//
//  ZiWeiMod.m
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ZiWeiMod.h"
#import "ZiWeiStar.h"
#import "ZiWeiGong.h"
#import "Paipan.h"

@interface XingGong : NSObject
@property (nonatomic, strong) NSMutableArray *stars;
@end

#define __CellSize CGSizeMake(80, 142)
#define __LineCount 6
#define __FontSize 12


#define ZWColorBlue UIColorFromRGB(0x26ae6)
#define ZWColorRed UIColorFromRGB(0xff3301)
#define ZWColorGreen UIColorFromRGB(0x038516)
#define ZWColorFu UIColorFromRGB(0xfe02d1)
#define ZWColorXiong UIColorFromRGB(0x6700e6)
#define ZWColorXiao UIColorFromRGB(0x9c552d)
#define ZWColorGray UIColorFromRGB(0x646464)

static NSMutableArray *cellAuchor;


@implementation ZiWeiMod
+ (Class)classForJsonObjectByKey:(NSString *)key {
    if([key isEqualToString:@"BirthTime"]){
        return [DateEntity class];
    }else if([key isEqualToString:@"TransitTime"]){
        return [DateEntity class];
    }
    return nil;
}

+ (Class)classForJsonObjectsByKey:(NSString *)key {
    if([key isEqualToString:@"Xing"]){
        return [ZiWeiStar class];
    } else if([key isEqualToString:@"Gong"]){
        return [ZiWeiGong class];
    }
    return nil;
}

- (UIImage *)paipan
{
    if(cellAuchor == nil){
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            cellAuchor = [[NSMutableArray alloc] init];
            // 0 - 3
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width, __CellSize.height * 3)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width, __CellSize.height * 2)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width, __CellSize.height)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width, 0)]];
            
            // 4 - 6
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 2, 0)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, 0)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 4, 0)]];
            
            // 7 - 9
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 4, __CellSize.height)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 4, __CellSize.height * 2)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 4, __CellSize.height * 3)]];
            
            // 10 - 11
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 3, __CellSize.height * 3)]];
            [cellAuchor addObject:[NSValue valueWithCGPoint:CGPointMake(__CellSize.width * 2, __CellSize.height * 3)]];
        });
    }
    CGSize size = CGSizeMake(__CellSize.width * 4, __CellSize.height * 4);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [UIColorFromRGB(0xf7f4ee) setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, UIColorFromRGB(0x888888).CGColor);
    
    for(int i = 0; i <= 4; i++){
        CGFloat y = __CellSize.height * i;
        CGContextMoveToPoint(ctx, 0, y);
        if(i != 2){
            CGContextAddLineToPoint(ctx, size.width, y);
        }else{
            CGContextAddLineToPoint(ctx, __CellSize.width, y);
            CGContextMoveToPoint(ctx, __CellSize.width*3, y);
            CGContextAddLineToPoint(ctx, size.width, y);
        }
    }
    
    for(int i = 0; i <= 4; i++){
        CGFloat x = __CellSize.width * i;
        CGContextMoveToPoint(ctx, x, 0);
        if(i != 2){
            CGContextAddLineToPoint(ctx, x, size.height);
        }else{
            CGContextAddLineToPoint(ctx, x, __CellSize.height);
            CGContextMoveToPoint(ctx, x, __CellSize.height*3);
            CGContextAddLineToPoint(ctx, x, size.height);
        }
    }
    CGContextStrokePath(ctx);
    
    //星
    int gsCount[12] = {0};
    for(int i = 0; i < [self.Xing count]; i++){
        if(i == 58 ||  i == 59 || i == 62 || i == 63 || i == 66 || i == 64 || i == 67){
            continue;
        }
        ZiWeiStar *star = [self.Xing objectAtIndex:i];
        [self drawStar:star withIndex:i gongIndex:gsCount[star.Gong]];
        gsCount[star.Gong]++;
    }
    //十二宫神
    [self drawGong];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)drawGong{
    for(int i = 0; i < 12; i++){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        CGPoint auchor = [[cellAuchor objectAtIndex:i] CGPointValue];
        CGPoint p = CGPointMake(auchor.x - __CellSize.width + 2, auchor.y + __CellSize.height - 4);
        ZiWeiGong *g = [self.Gong objectAtIndex:i];
        NSDictionary *bAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor blackColor],NSParagraphStyleAttributeName : paragraphStyle};
        NSDictionary *rAttribute = @{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : ZWColorRed,NSParagraphStyleAttributeName : paragraphStyle};
        
        NSAttributedString *boShi = [[NSAttributedString alloc] initWithString:[__ZiWeiBoShi objectAtIndex:g.BoShi] attributes:bAttribute];
        NSAttributedString *taiSui = [[NSAttributedString alloc] initWithString:[__ZiWeiBoShi objectAtIndex:g.TaiSui] attributes:bAttribute];
        NSAttributedString *jianQian = [[NSAttributedString alloc] initWithString:[__ZiWeiJiangQian objectAtIndex:g.JiangQian] attributes:bAttribute];
        
        NSMutableString *gn = [[NSMutableString alloc] initWithString:[__ZiWeiGong objectAtIndex:g.GongName]];
        if(self.Shen == i){
            if(self.Ming == i){
                [gn stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@"命"];
            }
            [gn stringByReplacingCharactersInRange:NSMakeRange(1, 1) withString:@"★"];
            [gn stringByReplacingCharactersInRange:NSMakeRange(2, 1) withString:@"身"];
        }
        NSAttributedString *gongName = [[NSAttributedString alloc] initWithString:gn attributes:rAttribute];
        NSMutableAttributedString *tran = nil;
        if(g.TransitA > 0){
            tran = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%02d-%02d", g.TransitA, g.TransitB]];
            [tran addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : ZWColorGray,
                                  } range:NSMakeRange(0, tran.length)];
        }
        
        NSAttributedString *tgdz = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", [__TianGan objectAtIndex:g.TG], [__DiZhi objectAtIndex:g.DZ]] attributes:bAttribute];
        NSAttributedString *changsheng = [[NSAttributedString alloc] initWithString:[__ZiWeiChangSheng objectAtIndex:g.ChangSheng] attributes:bAttribute];
        
        [jianQian drawInRect:CGRectMake(p.x, p.y - __FontSize, __FontSize * 2, __FontSize)];
        [boShi drawInRect:CGRectMake(p.x, p.y - 2 * __FontSize, __FontSize * 2, __FontSize)];
        [taiSui drawInRect:CGRectMake(p.x , p.y - 3 * __FontSize, __FontSize * 2, __FontSize)];
        
        [gongName drawInRect:CGRectMake(p.x + 2 * __FontSize, p.y - __FontSize, __FontSize * 3, __FontSize)];
        [tran drawInRect:CGRectMake(p.x + 2 * __FontSize, p.y - 2 * __FontSize, __FontSize * 3, __FontSize)];
        
        [tgdz drawInRect:CGRectMake(p.x + 5.2 * __FontSize, p.y - 4*__FontSize, __FontSize, __FontSize * 2)];
        [changsheng drawInRect:CGRectMake(p.x + 5.2 * __FontSize, p.y - 2*__FontSize, __FontSize, __FontSize * 2)];
        
    }
}

- (void)drawStar:(ZiWeiStar *)star withIndex:(int)index gongIndex:(int)gongIndex{
    UIColor *cl = nil;
    if(index <= 13){    //主星颜色
        cl = ZWColorRed;
    } else if(index <= 21){
        cl = ZWColorFu;
    } else if(index <= 27){
        cl = ZWColorXiong;
    } else{
        cl = ZWColorXiao;
    }
    
    CGFloat lh = 46;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    CGPoint auchor = [[cellAuchor objectAtIndex:star.Gong] CGPointValue];
    CGPoint p = CGPointMake(auchor.x - __FontSize, auchor.y);
    if(gongIndex < __LineCount){
        p.x -= __FontSize * gongIndex;
        NSMutableAttributedString *miaoWang = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiMiaowang objectAtIndex:star.Wang]];
        [miaoWang addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                                 NSForegroundColorAttributeName : [UIColor blackColor],
                                 NSParagraphStyleAttributeName : paragraphStyle,
                                  } range:NSMakeRange(0, miaoWang.length)];
        if([miaoWang length] > 0){
            [miaoWang drawInRect:CGRectMake(p.x, p.y + 23, __FontSize, 13)];
        }
        
        NSMutableAttributedString *siHua = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiSihua objectAtIndex:star.Hua]];
        if(![[siHua mutableString] isEqualToString:@" "]){
            [siHua addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:10],
                                  NSForegroundColorAttributeName : [UIColor whiteColor],
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                   } range:NSMakeRange(0, siHua.length)];
            CGRect siHuaRect = CGRectMake(p.x, p.y + 35, __FontSize, 13);
            [[UIColor redColor] setFill];
            UIRectFill(siHuaRect);
            [siHua drawInRect:siHuaRect];
        }
    }else{
        p.y += lh;
        p.x = __FontSize * (gongIndex - __LineCount);
    }
    
    NSMutableAttributedString *name = [[NSMutableAttributedString alloc] initWithString:[__ZiWeiStar objectAtIndex:star.StarName]];
    [name addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10],
                          NSForegroundColorAttributeName : cl,
                          NSParagraphStyleAttributeName : paragraphStyle,
                          } range:NSMakeRange(0, name.length)];
    [name drawInRect:CGRectMake(p.x, p.y, __FontSize, lh)];
}
@end
