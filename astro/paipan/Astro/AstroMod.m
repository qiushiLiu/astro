//
//  AstroMod.m
//  astro
//
//  Created by kjubo on 14-3-19.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "AstroMod.h"
#import "AstroStar.h"
#import "Paipan.h"

CGFloat D2R(CGFloat degrees) {return degrees * M_PI / 180.0;};
CGFloat R2D(CGFloat radians) {return radians * 180.0/M_PI;};

@interface AstroMod ()
@end

@implementation AstroMod
+ (Class)classForJsonObjectByKey:(NSString *)key {
    return nil;
}

+ (Class)classForJsonObjectsByKey:(NSString *)key {
    if([key isEqualToString:@"Stars"]){
        return [AstroStar class];
    }
    return nil;
}

#define _Size   CGSizeMake(320, 320)
#define _Radius _Size.width/2 - 10
#define _Center CGPointMake(_Size.width/2, _Size.height/2)
#define _ConstellationDegree 30.0

- (UIImage *)paipan
{
    [self initDrawData];
    
    if([self.__gong count] != 12){
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(_Size, YES, 0);
    [[UIColor blackColor] setFill];
    UIRectFill(CGRectMake(0, 0, _Size.width, _Size.height));

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetShouldAntialias(ctx, true);
    
    CGFloat r0 = _Radius;   //星座外径
    CGFloat r1 = r0 - 20;   //星座内径
    CGFloat r2 = r1 - 5;    //星座外径
    CGFloat r3 = r2 - 20;   //星座内径
    CGFloat r4 = r3 - 20;   //星径
    
    //四个同心圆
    [self drawArc:ctx radius:r0];
    [self drawArc:ctx radius:r1];
    [self drawArc:ctx radius:r2];
    [self drawArc:ctx radius:r3];
    
    //居中
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    //12宫
    for(int i = 0; i < 12; i++){
        double degree = [[self.__gong objectAtIndex:i] doubleValue];
        double nextDegree = 0;
        if(i != 11){
            nextDegree = [[self.__gong objectAtIndex:i + 1] doubleValue];
        }else{
            nextDegree = 540.0;
        }
        //写宫名
        CGFloat cd = (degree + nextDegree)*0.5;
        CGFloat cr = (r3 + r2)*0.5;
        CGPoint ct = [[self class] pointByRadius:cr andDegree:cd];
        UIColor *color = nil;
        switch (i%4) {
            case 0:
                color = [UIColor redColor];
                break;
            case 1:
                color = [UIColor yellowColor];
                break;
            case 2:
                color = [UIColor greenColor];
                break;
            case 3:
                color = [UIColor blueColor];
                break;
            default:
                break;
        }
        NSAttributedString *gn = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", i + 1]
                                                                 attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:8],
                                                                              NSForegroundColorAttributeName : color,
                                                                              NSParagraphStyleAttributeName : paragraphStyle}];
        [gn drawInRect:CGRectMake(ct.x - 6, ct.y - 6, 14, 14)];
        
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        [self drawSeparated:ctx degree:degree from:r2 to:r3];
        //分宫
        if(i < 6){
            CGFloat lineWidth = 0.3;
            CGFloat r = r3;
            if(i == 0 || i == 3){ //连接1-7，4-10宫的起点 （1，1虚线）
                lineWidth = 1.0;
                r = _Size.width/2;
            }
            CGFloat dash[] = {1, 1};
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextSetLineDash(ctx, 0, dash, 2);
            [self drawSeparated:ctx degree:degree from:r to:-r lineWidth:lineWidth];
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
    
    //12星座
    for(int i = 0; i < 360; i++){
        if(i % 30 == 0){
            [self drawSeparated:ctx degree:(self.__constellationStart + i) from:r0 to:r2];
        }else if(i % 5 == 0){
            [self drawSeparated:ctx degree:(self.__constellationStart + i) from:r1 to:r2];
        }else{
            [self drawSeparated:ctx degree:(self.__constellationStart + i) from:r1 to:r2 lineWidth:0.3];
        }
        if(i % 30 == 15){
            int cons = i/30 + 1;
            UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"icon_cons_%d", cons]];
            CGSize iSize = CGSizeMake(16, 16);
            CGFloat cr = (r1 + r0)*0.5;
            CGPoint ct = [[self class] pointByRadius:cr andDegree:(self.__constellationStart + i)];
            [icon drawInRect:CGRectMake(ct.x - iSize.width/2, ct.y - iSize.height/2, iSize.width, iSize.height)];
        }
        
    }
    
    //星图
    NSMutableArray *st = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.Stars count]; i++) {
        if(i >= 10 && i != 20 /*&& i != 23 && i != 26*/ && i != 29)
            continue;
        AstroStar *star = [self.Stars objectAtIndex:i];
        CGFloat degree = self.__constellationStart + 30 * (star.Constellation - 1) + star.DegreeHD;
        degree = fmodf(degree, 360.0);
        CGPoint center = [[self class] pointByRadius:r4 andDegree:degree];
        [self drawArc:ctx center:center radius:1 color:UIColorFromRGB(0xee1100)];
        
        
        
        [st addObject:@(degree)];
    }
    //象限
    for(int i = 0; i < [st count]; i++){
        double start = [[st objectAtIndex:i] doubleValue];
        for(int j = i + 1; j < [st count]; j++){
            double end = [[st objectAtIndex:j] doubleValue];
            double delta = fabs(start - end);
            if(delta > 180.0){
                delta = 360.0 - delta;
            }
            
            UIColor *cl = nil;
            CGFloat dd = -1 ;
            if(2*fabs(delta - 0.0) <= 10.0){
                cl = [UIColor yellowColor];
                dd = fabs(delta - 0.0);
            }
            else if(2*fabs(delta - 180.0) <= 10.0){
                cl = [UIColor blueColor];
                dd = fabs(delta - 180.0);
            }
            else if(2*fabs(delta - 90.0) <= 10.0){
                cl = [UIColor redColor];
                dd = fabs(delta - 90.0);
            }
            else if(2*fabs(delta - 120.0) <= 10.0){
                cl = [UIColor greenColor];
                dd = fabs(delta - 120.0);
            }
            else if(2*fabs(delta - 60.0) <= 10.0){
                cl = [UIColor cyanColor];
                dd = fabs(delta - 60.0);
            }
            
            if(dd >= 0){
                if(dd > 0){
                    dd = dd * 0.5;
                    CGFloat dash[] = {dd, dd};
                    CGContextSetLineDash(ctx, 0, dash, 2);
                }
                CGContextSetStrokeColorWithColor(ctx, cl.CGColor);
                [self drawStarLine:ctx radius:r4 from:start to:end];
            }
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)drawArc:(CGContextRef)ctx center:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color{
    CGContextAddArc(ctx, center.x, center.y, radius, 0, M_PI*2, 0);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)drawArc:(CGContextRef)ctx  radius:(CGFloat)radius{
    CGContextAddArc(ctx, _Center.x, _Center.y, radius, 0, M_PI*2, 0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (void)drawStarLine:(CGContextRef)ctx radius:(CGFloat)radius from:(CGFloat)fd to:(CGFloat)td{
    CGPoint begin = [[self class] pointByRadius:radius andDegree:fd];
    CGPoint end = [[self class] pointByRadius:radius andDegree:td];
    CGContextSetLineWidth(ctx, 1.0);
    CGContextMoveToPoint(ctx, begin.x, begin.y);
    CGContextAddLineToPoint(ctx, end.x, end.y);
    CGContextStrokePath(ctx);
}

- (void)drawSeparated:(CGContextRef)ctx degree:(CGFloat)degree from:(CGFloat)from to:(CGFloat)to{
    [self drawSeparated:ctx degree:degree from:from to:to lineWidth:1.0];
}

- (void)drawSeparated:(CGContextRef)ctx degree:(CGFloat)degree from:(CGFloat)from to:(CGFloat)to lineWidth:(CGFloat)lineWidth{
    CGPoint begin, end;
    begin = [[self class] pointByRadius:from andDegree:degree];
    end = [[self class] pointByRadius:to andDegree:degree];
    CGContextSetLineWidth(ctx, lineWidth);
    CGContextMoveToPoint(ctx, begin.x, begin.y);
    CGContextAddLineToPoint(ctx, end.x, end.y);
    CGContextStrokePath(ctx);
}

- (void)initDrawData{
    if(!self.__gong){
        self.__gong = [[NSMutableArray alloc] init];
    }
    [self.__gong removeAllObjects];
    
    CGFloat last = 180.0;
    [self.__gong addObject:@(last)];
    for(int i = 20; i < 31; i++){
        AstroStar *star = [self.Stars objectAtIndex:i];
        AstroStar *starNext = [self.Stars objectAtIndex:i + 1];
        if([star isEqual:[NSNull null]] || [starNext isEqual:[NSNull null]]){
            continue;
        }
        if(i == 20){
            self.__constellationStart = last - (star.Constellation - 1)*_ConstellationDegree - star.DegreeHD;
        }
        
        NSInteger cc = 0;
        if(starNext.Constellation >= star.Constellation){
            cc = starNext.Constellation - star.Constellation;
        }else{
            cc = (12 - star.Constellation) + starNext.Constellation;
        }
        last = last + cc*30.0 + (starNext.DegreeHD - star.DegreeHD);
        [self.__gong addObject:@(last)];
    }
}

+ (CGPoint)pointByRadius:(CGFloat)radius andDegree:(CGFloat)degree {
    return CGPointMake(_Center.x + cos(D2R(degree))*radius, _Center.y - sin(D2R(degree))*radius);
}
@end
