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
#import "ASCache.h"

@implementation AstroShowInfo
@end

CGFloat D2R(CGFloat degrees) {return degrees * M_PI / 180.0;};
CGFloat R2D(CGFloat radians) {return radians * 180.0/M_PI;};

@interface AstroMod ()
@end

@implementation AstroMod

static NSString *startPermitKey = @"starsPermit";
static NSString *anglePermitKey = @"anglePermit";
static CGFloat kSpace = 8.0;

+ (NSInteger)getStarsPermit{
    ASCacheObject *obj = [[ASCache shared] readDicFiledsWithDir:NSStringFromClass([self class]) key:startPermitKey];
    if(obj){
        return [obj.value intValue];
    }else{
        return 0xf023ff; //默认:10个星体+婚神
    }
}

+ (NSIndexPath *)getStarsPermitCount{
    NSInteger planetCount = 0, asteroidCount = 0;
    NSInteger permit = [self getStarsPermit];
    for(int i = 0; i < 20; i++){
        BOOL selected = (permit & 1<<i) > 0;
        if(selected){
            if(i < 10){
                planetCount++;
            }else{
                asteroidCount++;
            }
        }
    }
    return [NSIndexPath indexPathForRow:planetCount inSection:asteroidCount];
}

+ (NSString *)getStarsPermitTextInfo{
    NSIndexPath *path = [self getStarsPermitCount];
    return [NSString stringWithFormat:@"主星:%@颗   小行星:%@颗", @(path.section), @(path.row)];
}

+ (void)setStarsPermit:(NSInteger)permit{
    [[ASCache shared] storeValue:Int2String(permit) dir:NSStringFromClass([self class]) key:startPermitKey];
}

+ (NSArray *)getAnglePermit{
    ASCacheObject *obj = [[ASCache shared] readDicFiledsWithDir:NSStringFromClass([self class]) key:anglePermitKey];
    NSString *value = nil;
    if(obj){
        value = obj.value;
    }else{
        value = @"10,10,10,10,10"; //默认:20个星体全部显示
    }
    NSMutableArray *ret = [NSMutableArray array];
    NSArray *arr = [value componentsSeparatedByString:@","];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [ret addObject:@([obj intValue])];
    }];
    return ret;
}

+ (void)setAnglePermit:(NSArray *)permit{
    [[ASCache shared] storeValue:[permit componentsJoinedByString:@","] dir:NSStringFromClass([self class]) key:anglePermitKey];
}

+ (NSString *)getAnglePermitTextInfo{
    NSArray *arr = [self getAnglePermit];
    NSMutableString *str = [NSMutableString string];
    [arr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj intValue] >= 0){
            [str appendFormat:@"%@_%d  ", AstroAnglePermit[idx], [obj intValue]];
        }
    }];
    return str;
}

- (NSString *)panTypeName{
    NSString *str = @"";
    switch (self.type) {
        case 1:
            str = AstroTypeArray[self.type - 1];
            break;
        case 2:
            str = AstroZuheArray[self.compose - 1];
            break;
        case 3:
            str = AstroTuiyunArray[self.transit - 1];
            break;
        default:
            break;
    }
    return str;
}

- (BOOL)isZuhepan{
    if(self.type == 2 && self.compose == 1){
        return YES;
    }else if(self.type == 3 && self.transit == 1){
        return YES;
    }
    return NO;
}

- (void)fecthStarsInfo:(NSMutableArray *)stars gongInfo:(NSMutableArray *)gongs tag:(NSInteger)tag{
    [stars removeAllObjects];
    [gongs removeAllObjects];
    
    NSArray *source = tag == 0 ? self.Stars : self.Stars1;
    for (int i = 20; i < 32; i++) {
        AstroStar *st = source[i];
        AstroShowInfo *item = [[AstroShowInfo alloc] init];
        item.name = [NSString stringWithFormat:@"%@宫", __DaXie[i - 19]];
        item.angle = [NSString stringWithFormat:@"%@%ld°%.0f′", __Constellation[st.Constellation], st.Degree, st.Cent];
        item.info = @"";
        [gongs addObject:item];
    }
    
    NSInteger permit = [[self class] getStarsPermit];
    for (int i = 0; i < 20; i++) {
        if(i > 20 && i != 23 && i != 26 && i != 29 && i <= 31){
            continue;
        }else if(i <= 20 && (permit & 1<<i) == 0){    //不被显示
            continue;
        }
        AstroStar *st = source[i];
        AstroShowInfo *item = [[AstroShowInfo alloc] init];
        item.name = __AstroStar[st.StarName];
        item.angle = [NSString stringWithFormat:@"%@%ld°%.0f′", __Constellation[st.Constellation], st.Degree, st.Cent];
        item.info = [NSString stringWithFormat:@"%@宫", __DaXie[st.Gong]];
        [stars addObject:item];
        
        //添加宫内星说明
        AstroShowInfo *gongInfo = gongs[st.Gong - 1];
        if([gongInfo.info length] == 0){
            gongInfo.info = item.name;
        }else{
            gongInfo.info = [NSString stringWithFormat:@"%@，%@", gongInfo.info, item.name];
        }
    }
}

#define _Size   CGSizeMake(320, 320)
#define _Radius _Size.width/2
#define _Center CGPointMake(_Size.width/2, _Size.height/2)
#define _ConstellationDegree 30.0

- (UIImage *)paipan
{
    NSMutableArray *arrGong = [self gongs];
    
    if([arrGong count] != 12){
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(_Size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(ctx, true);
    CGContextSetShouldAntialias(ctx, true);
    
    CGFloat r0 = _Radius;   //星座外径
    CGFloat r1 = r0 - 25;   //星座内径
    CGFloat r2 = r1 - 5;    //星座外径
    CGFloat r3 = r2 - 15;   //星座内径
    CGFloat r4 = r3 - 26;   //star星径
    CGFloat r5 = r4 - 26;   //star1星径
    
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
            if(i == 0 || i == 3){ //连接1-7，4-10宫的起点 （1，1虚线）
                lineWidth = 1.0;
            }
            CGFloat dash[] = {1, 1};
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextSetLineDash(ctx, 0, dash, 2);
            [self drawSeparated:ctx degree:degree from:r3 to:-r3 lineWidth:lineWidth];
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
    
    NSMutableArray *st0 = nil, *st1 = nil;
    if([self isZuhepan]){
        st0 = [self drawAstroStars:ctx stars:self.Stars radius:r4 relatedRadius:r5];
        st1 = st0;
    }else{
        st0 = [self drawAstroStars:ctx stars:self.Stars radius:r4 relatedRadius:r4];
        st1 = st0;
    }
    
    if([self.Stars1 count] > 0){
        st1 = [self drawAstroStars:ctx stars:self.Stars1 radius:r5 relatedRadius:r5];
    }
    if([self isZuhepan]){
        [self drawRelated:ctx stars:st0 with:st1 radius:r5];
    }else{
        [self drawRelated:ctx stars:st0 with:st1 radius:r4];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (NSMutableArray *)drawAstroStars:(CGContextRef)ctx stars:(NSArray *)astroStars radius:(CGFloat)r relatedRadius:(CGFloat)rr{
    NSInteger permit = [[self class] getStarsPermit];
    //画星的中心点
    NSMutableArray *st = [[NSMutableArray alloc] init];
    for (int i = 0; i < [astroStars count]; i++) {
        if(i > 20 && i != 23 && i != 26 && i != 29 && i <= 31){
            continue;
        }else if(i <= 20 && (permit & 1<<i) == 0){    //不被显示
            continue;
        }
        
        AstroStarHD *star = [[AstroStarHD alloc] initWithAstro:[astroStars objectAtIndex:i]];
        CGFloat degree = constellationStart + 30 * (star.base.Constellation - 1) + star.DegreeHD;
        degree = fmodf(degree, 360.0);
        NSAssert(degree >= 0, @"PanDegree 必须大于 0");
        star.PanDegree = degree;
        star.FixDegree = degree;
        [st addObject:star];
        
        if(r != rr){
            CGFloat dash[] = {1, 1};
            CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
            CGContextSetLineDash(ctx, 0, dash, 2);
            [self drawSeparated:ctx degree:star.PanDegree from:rr to:r lineWidth:0.5];
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
    
    //先排序
    [st sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AstroStarHD *s1 = (AstroStarHD *)obj1;
        AstroStarHD *s2 = (AstroStarHD *)obj2;
        return s1.PanDegree >= s2.PanDegree;
    }];
    
    //找到间隔最大的区域分散
    int maxSpaceIndex = 0;
    float maxSpace = 0.0;
    for(int i = 0; i < st.count; i++){
        int next = (i + 1)%st.count;
        AstroStarHD *star0 = st[i];
        AstroStarHD *star1 = st[next];
        float space = 0;
        if(i < next){
            space = star1.PanDegree - star0.PanDegree;
        }else{
            space = 360.0 - star0.PanDegree + star1.PanDegree;
        }
        if(space > maxSpace){
            maxSpaceIndex = next;
            maxSpace = space;
        }
    }
    
    //重新组合数组，将最大间隙下一个放在
    NSArray *arr0 = [st subarrayWithRange:NSMakeRange(maxSpaceIndex, st.count - maxSpaceIndex)];
    NSArray *arr1 = [st subarrayWithRange:NSMakeRange(0, maxSpaceIndex)];
    [arr1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AstroStarHD *star = (AstroStarHD *)obj;
        star.PanDegree += 360.0;
        star.FixDegree += 360.0;
    }];
    st = [NSMutableArray arrayWithArray:arr0];
    [st addObjectsFromArray:arr1];
    
    //调整位置
    [self fixDegree:st index:0];
    //画图
    [self drawGroupStar:ctx group:st radius:r];
    
    return st;
}

- (void)drawRelated:(CGContextRef)ctx stars:(NSArray *)st radius:(CGFloat)r{
    [self drawRelated:ctx stars:st with:st radius:r];
}

- (void)drawRelated:(CGContextRef)ctx stars:(NSArray *)st0 with:(NSArray *)st1 radius:(CGFloat)r{
    NSArray *anglePermit = [[self class] getAnglePermit];
    for(int i = 0; i < [st0 count]; i++){
        AstroStarHD *star = st0[i];
        if(star.base.StarName > 10)
            continue;
        
        for(int j = 0; j < [st1 count]; j++){
            AstroStarHD *relStar = st1[j]; //关联星
            if(star.base.StarName > 10)
                continue;
            
            if(st0 == st1 && i == j)
                continue;
            
            double delta = fabs(star.PanDegree - relStar.PanDegree);
            if(delta > 180.0){
                delta = 360.0 - delta;
            }
            
            UIColor *cl = nil;
            CGFloat dd = -1 ;
            
            for(int i = 0; i < anglePermit.count; i++){
                CGFloat permit = [anglePermit[i] floatValue];
                if(permit < 0){ //关闭的
                    continue;
                }
                
                if(2*fabs(delta - [AstroAnglePermit[i] floatValue]) <= permit){
                    switch (i) {
                        case 0:
                            cl = [UIColor yellowColor];
                            break;
                        case 1:
                            cl = [UIColor blueColor];
                            break;
                        case 2:
                            cl = [UIColor greenColor];
                            break;
                        case 3:
                            cl = [UIColor redColor];
                            break;
                        case 4:
                            cl = [UIColor cyanColor];
                            break;
                        default:
                            break;
                    }
                    dd = fabs(delta - [AstroAnglePermit[i] floatValue]);
                }
                
                if(dd >= 0){
                    if(dd > 0){
                        CGFloat dash[] = {1, dd};
                        CGContextSetLineDash(ctx, 0, dash, 2);
                    }else{
                        CGContextSetLineDash(ctx, 0, NULL, 0);
                    }
                    CGContextSetStrokeColorWithColor(ctx, cl.CGColor);
                    [self drawStarLine:ctx radius:r from:star.PanDegree to:relStar.PanDegree];
                }
            }
        }
    }
}

- (void)fixDegree:(NSMutableArray *)st index:(NSInteger)index{
    if(index >= st.count - 1){
        return;
    }
    
    AstroStarHD *star = st[index];
    NSInteger groupIndex = index;
    //向后看
    for(NSInteger i = index + 1; i < st.count; i++){
        AstroStarHD *sr = st[i];
        if(sr.FixDegree - star.FixDegree >= kSpace * (i - index)){
            break;
        }else{
            groupIndex = i;
        }
    }
    
    //调整 index - groupIndex 的间距
    if(groupIndex != index){
        AstroStarHD *star1 = st[groupIndex];
        CGFloat centerDegree = (star1.FixDegree + star.FixDegree) * 0.5;
        CGFloat center = (index + groupIndex) * 0.5;
        for(NSInteger i = index; i <= groupIndex; i++){
            AstroStarHD *sr = st[i];
            sr.FixDegree = centerDegree + (i - center) * kSpace;
        }
        [self fixDegree:st index:0];
    }else{
        [self fixDegree:st index:index + 1];
    }
}

- (void)drawGroupStar:(CGContextRef)ctx group:(NSArray *)group radius:(CGFloat)r{
    CGSize sSize = CGSizeMake(14, 14);
    for(NSInteger i = 0; i <  [group count]; i++){
        AstroStarHD *star = [group objectAtIndex:i];
        CGPoint center = [[self class] pointByRadius:r andDegree:star.PanDegree];
        [self drawArc:ctx center:center radius:1 color:UIColorFromRGB(0xee1100)];
        CGPoint centerFix = [[self class] pointByRadius:r + 14 andDegree:star.FixDegree];
        UIImage *icon = [UIImage imageNamed:[NSString stringWithFormat:@"icon_star_%@", @(star.base.StarName)]];
        [icon drawInRect:CGRectMake(centerFix.x - sSize.width/2, centerFix.y - sSize.height/2, sSize.width, sSize.height)];
        
        //指向线
        CGPoint lineEnd = [[self class] pointByRadius:r + 8 andDegree:star.FixDegree];
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

- (NSMutableArray *)gongs{
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
