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
#import "AstroStarGroup.h"

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
    NSMutableArray *arrGong = [self newGongs];
    
    if([arrGong count] != 12){
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(_Size, NO, 0);
//    [[UIColor clearColor] setFill];
//    UIRectFill(CGRectMake(0, 0, _Size.width, _Size.height));

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetShouldAntialias(ctx, true);
    
    CGFloat r0 = _Radius;   //星座外径
    CGFloat r1 = r0 - 25;   //星座内径
    CGFloat r2 = r1 - 5;    //星座外径
    CGFloat r3 = r2 - 15;   //星座内径
    CGFloat r4 = r3 - 26;   //星径
    
    //四个同心圆
    [self drawArc:ctx radius:r0 fillColor:[UIColor blackColor]];
    [self drawArc:ctx radius:r1];
    [self drawArc:ctx radius:r2];
    [self drawArc:ctx radius:r3];
    
    //居中
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    //分宫
    for(int i = 0; i < 12; i++){
        double degree = [[arrGong objectAtIndex:i] doubleValue];
        double nextDegree = 0;
        if(i != 11){
            nextDegree = [[arrGong objectAtIndex:i + 1] doubleValue];
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
            [self drawSeparated:ctx degree:(constellationStart + i) from:r0 to:r2];
        }else if(i % 5 == 0){
            [self drawSeparated:ctx degree:(constellationStart + i) from:r1 to:r2];
        }else{
            [self drawSeparated:ctx degree:(constellationStart + i) from:r1 to:r2 lineWidth:0.3];
        }
        if(i % 30 == 15){
            int cons = i/30 + 1;
            UIImage *constellation = [UIImage imageNamed:[NSString stringWithFormat:@"icon_cons_%d", cons]];
            UIImage *ruler = [UIImage imageNamed:[NSString stringWithFormat:@"icon_gong_%d", cons]];
            CGSize cSize = CGSizeMake(18, 18);
            CGSize rSize = CGSizeMake(cSize.width/2, cSize.height/2);
            CGFloat cr = (r1 + r0)*0.5;
            CGPoint ct = [[self class] pointByRadius:cr andDegree:(constellationStart + i + 2)];
            CGPoint rt = [[self class] pointByRadius:cr andDegree:(constellationStart + i - 4)];
            [constellation drawInRect:CGRectMake(ct.x - cSize.width/2, ct.y - cSize.height/2, cSize.width, cSize.height)];
            [ruler drawInRect:CGRectMake(rt.x - rSize.width/2, rt.y - rSize.height/2, rSize.width, rSize.height)];
        }
        
    }
    
    //画星的中心点
    NSMutableArray *st = [[NSMutableArray alloc] init];
    for (int i = 0; i < [self.Stars count]; i++) {
        if(i > 20 /*&& i != 23 && i != 26*/ && i != 29 && i <= 31)
            continue;
        AstroStarHD *star = [[AstroStarHD alloc] initWithAstro:[self.Stars objectAtIndex:i]];
        CGFloat degree = constellationStart + 30 * (star.base.Constellation - 1) + star.DegreeHD;
        degree = fmodf(degree, 360.0);
        NSAssert(degree > 0, @"PanDegree 必须大于 0");
        star.PanDegree = degree;
        star.FixDegree = degree;
        [st addObject:star];
    }
    
    //先排序
    [st sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AstroStarHD *s1 = (AstroStarHD *)obj1;
        AstroStarHD *s2 = (AstroStarHD *)obj2;
        return s1.PanDegree >= s2.PanDegree;
    }];
    
    
//    NSMutableArray *group = [[NSMutableArray alloc] init];
//    NSInteger bb = 0, ee = [st count] - 1;
//    CGFloat lastDegree = -1;
//    while (bb <= ee) {
//        AstroStar *star = [st objectAtIndex:bb];
//        if(bb == 0){
//            lastDegree = [star.PanDegree doubleValue];
//            while(bb <= ee){
//                AstroStar *lstar = [st objectAtIndex:ee];
//                BOOL tag = NO;
//                if(lastDegree < [lstar.PanDegree doubleValue]){
//                    if(360.0 - [lstar.PanDegree doubleValue] + lastDegree <= 8.0){
//                        tag = YES;
//                    }
//                }else{
//                    if(fabs(lastDegree - [star.PanDegree doubleValue]) <= 8.0){
//                        tag = YES;
//                    }
//                }
//                if(tag){
//                    [group insertObject:lstar atIndex:0];
//                    lastDegree = [lstar.PanDegree doubleValue];
//                    ee--;
//                }else{
//                    break;
//                }
//            }
//            lastDegree = -1;
//        }
//        if(lastDegree >= 0 && fabs(lastDegree - [star.PanDegree doubleValue]) > 8.0){
//            [self drawGroupStar:ctx group:group radius:r4];
//            [group removeAllObjects];
//        }
//        [group addObject:star];
//        lastDegree = [star.PanDegree doubleValue];
//        bb++;
//    }
//    if([group count] > 0){
//        [self drawGroupStar:ctx group:group radius:r4];
//    }

    
    NSMutableArray *groups = [[NSMutableArray alloc] init];
    for(AstroStarHD *star in st){
        [self starGroups:groups addNewStar:star];
    }
    
    for(AstroStarGroup *gp in groups){
//        if([gp.stars count] == 2){
            [self drawGroupStar:ctx group:gp.stars radius:r4];
//        }
    }
    
    for(int i = 0; i < [st count]; i++){
        AstroStarHD *star = [st objectAtIndex:i];
        if(star.base.StarName > 10)
            continue;
        for(int j = i + 1; j < [st count]; j++){
            AstroStarHD *relStar = [st objectAtIndex:j]; //关联星
            double delta = fabs(star.PanDegree - relStar.PanDegree);
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
                    CGFloat dash[] = {1, dd};
                    CGContextSetLineDash(ctx, 0, dash, 2);
                }else{
                    CGContextSetLineDash(ctx, 0, NULL, 0);
                }
                CGContextSetStrokeColorWithColor(ctx, cl.CGColor);
                [self drawStarLine:ctx radius:r4 from:star.PanDegree to:relStar.PanDegree];
            }
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (void)starGroups:(NSMutableArray *)groups addNewStar:(AstroStarHD *)star{
    AstroStarGroup *gp = [[AstroStarGroup alloc] init];
    [gp addNewStar:star];
    [groups addObject:gp];
    
    BOOL joinTag = YES;
    while(joinTag){
        NSInteger lastCount = [groups count];
        for(int i = 0; i < lastCount; i++){
            AstroStarGroup *gp0 = [groups objectAtIndex:i];
            for (int j = i + 1; j < lastCount; j++) {
                AstroStarGroup *gp1 = [groups objectAtIndex:j];
                if([gp0 nearTo:gp1]){
                    [gp0 joinStars:gp1.stars];
                    [groups removeObject:gp1];
                    break;
                }
            }
            if(lastCount != [groups count]){
                break;
            }
        }
        if(lastCount == [groups count]){
            joinTag = NO;
        }
    }
    
}

- (void)drawGroupStar:(CGContextRef)ctx group:(NSArray *)group radius:(CGFloat)r{
//    CGFloat cc = 0;
//    NSInteger mid = [group count]/2;
//    BOOL hasCenter = [group count]%2 != 0;
//    if([group count]%2 == 0){
//        AstroStar *a1 = (AstroStar *)[group objectAtIndex:mid - 1];
//        AstroStar *a2 = (AstroStar *)[group objectAtIndex:mid];
//        cc = ([a1.PanDegree doubleValue] + [a2.PanDegree doubleValue])*0.5;
//    }else{
//        cc = [((AstroStar *)[group objectAtIndex:mid]).PanDegree doubleValue];
//    }
    
    CGSize sSize = CGSizeMake(14, 14);
    for(NSInteger i = 0; i <  [group count]; i++){
//        CGFloat degreeFixed = 0;
//        NSInteger delta = abs((int)(i - mid));
//        if(i < mid){
//            degreeFixed = cc - delta * 4.25;
//        }else{
//            if(hasCenter){
//                degreeFixed = cc + delta * 4.25;
//            }else{
//                degreeFixed = cc + (delta + 1) * 4.25;
//            }
//        }
        AstroStarHD *star = [group objectAtIndex:i];
        CGPoint center = [[self class] pointByRadius:r andDegree:star.PanDegree];
        [self drawArc:ctx center:center radius:1 color:UIColorFromRGB(0xee1100)];
        CGPoint centerFix = [[self class] pointByRadius:r + 20 andDegree:star.FixDegree];
        UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"icon_star_%d", star.base.StarName]];
        [icon drawInRect:CGRectMake(centerFix.x - sSize.width/2, centerFix.y - sSize.height/2, sSize.width, sSize.height)];
        
        //指向线
        CGPoint lineEnd = [[self class] pointByRadius:r + 12 andDegree:star.FixDegree];
        CGContextSetLineDash(ctx, 0, NULL, 0);
        CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
        CGContextSetLineWidth(ctx, 0.8);
        CGContextMoveToPoint(ctx, center.x, center.y);
        CGContextAddLineToPoint(ctx, lineEnd.x, lineEnd.y);
        CGContextStrokePath(ctx);
    }
}

- (void)drawArc:(CGContextRef)ctx center:(CGPoint)center radius:(CGFloat)radius color:(UIColor *)color{
    CGContextAddArc(ctx, center.x, center.y, radius, 0, M_PI*2, 0);
    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    CGContextDrawPath(ctx, kCGPathFillStroke);
}

- (void)drawArc:(CGContextRef)ctx radius:(CGFloat)radius{
    [self drawArc:ctx radius:radius fillColor:nil];
}

- (void)drawArc:(CGContextRef)ctx radius:(CGFloat)radius fillColor:(UIColor *)color{
    CGContextAddArc(ctx, _Center.x, _Center.y, radius, 0, M_PI*2, 0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextDrawPath(ctx, kCGPathStroke);
    if(color){
        CGContextAddArc(ctx, _Center.x, _Center.y, radius, 0, M_PI*2, 0);
        CGContextSetFillColorWithColor(ctx, color.CGColor);
        CGContextDrawPath(ctx, kCGPathFillStroke);
    }
    
}

- (void)drawStarLine:(CGContextRef)ctx radius:(CGFloat)radius from:(CGFloat)fd to:(CGFloat)td{
    CGPoint begin = [[self class] pointByRadius:radius andDegree:fd];
    CGPoint end = [[self class] pointByRadius:radius andDegree:td];
    CGContextSetLineWidth(ctx, 0.6);
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

- (NSMutableArray *)newGongs{
    NSMutableArray *arrGong = [[NSMutableArray alloc] init];
    CGFloat last = 180.0;
    [arrGong addObject:@(last)];
    for(int i = 20; i < 31; i++){
        AstroStarHD *star = [[AstroStarHD alloc] initWithAstro:[self.Stars objectAtIndex:i]];
        AstroStarHD *starNext = [[AstroStarHD alloc] initWithAstro:[self.Stars objectAtIndex:i + 1]];
        if([star isEqual:[NSNull null]] || [starNext isEqual:[NSNull null]]){
            continue;
        }
        
        if(i == 20){
            constellationStart = last - (star.base.Constellation - 1)*_ConstellationDegree - star.DegreeHD;
            if(constellationStart <= 0){
                constellationStart = 360.0 - fabs(constellationStart);
            }
        }
        
        NSInteger cc = 0;
        if(starNext.base.Constellation >= star.base.Constellation){
            cc = starNext.base.Constellation - star.base.Constellation;
        }else{
            cc = (12 - star.base.Constellation) + starNext.base.Constellation;
        }
        last = last + cc*30.0 + (starNext.DegreeHD - star.DegreeHD);
        [arrGong addObject:@(last)];
    }
    return arrGong;
}

+ (CGPoint)pointByRadius:(CGFloat)radius andDegree:(CGFloat)degree {
    return CGPointMake(_Center.x + cos(D2R(degree))*radius, _Center.y - sin(D2R(degree))*radius);
}
@end
