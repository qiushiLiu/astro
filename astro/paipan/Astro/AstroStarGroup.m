//
//  AstroStarGroup.m
//  astro
//
//  Created by kjubo on 14-6-10.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "AstroStarGroup.h"

@implementation AstroStarGroup

static CGFloat kSpaceDegree = 9.0;

- (id)init{
    self = [super init];
    if(self){
        self.stars = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addNewStar:(AstroStarHD *)star{
    [self.stars addObject:star];
    [self fixRange];
}

- (void)joinStars:(NSArray *)stars{
    [self.stars addObjectsFromArray:stars];
    [self fixRange];
}

- (BOOL)relationTo:(AstroStarHD *)star{
    return [self point:star.PanDegree between:self.degreeStart and:self.degreeEnd];
}

- (BOOL)nearTo:(AstroStarGroup *)gp{
    return [self point:gp.degreeStart between:self.degreeStart and:self.degreeEnd]
    || [self point:gp.degreeEnd between:self.degreeStart and:self.degreeEnd]
    || [self point:self.degreeStart between:gp.degreeStart and:gp.degreeEnd]
    || [self point:self.degreeEnd between:gp.degreeStart and:gp.degreeEnd];
}

- (BOOL)point:(CGFloat)point between:(CGFloat)x and:(CGFloat)y{
    if(x > y){
        return (point >= x && point <= 360.0) || point <= y;
    }else{
        return point <= y && point >= x;
    }
}

- (void)fixRange{
    // 排序
    [self.stars sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        AstroStarHD *s1 = (AstroStarHD *)obj1;
        AstroStarHD *s2 = (AstroStarHD *)obj2;
        return s1.PanDegree >= s2.PanDegree;
    }];
    
    
    if([self.stars count] > 1){
        NSInteger subIndex = -1;
        for(int i = 0; i < [self.stars count] - 1; i++){
            AstroStarHD *s1 = [self.stars objectAtIndex:i];
            AstroStarHD *s2 = [self.stars objectAtIndex:i + 1];
            if(s2.PanDegree - s1.PanDegree > kSpaceDegree * 2){
                subIndex = i + 1;
                break;
            }
        }
        
        if(subIndex > 0){
            NSArray *arr1 = [self.stars subarrayWithRange:NSMakeRange(0, subIndex)];
            NSArray *arr2 = [self.stars subarrayWithRange:NSMakeRange(subIndex, [self.stars count] - subIndex)];
            self.stars = [NSMutableArray arrayWithArray:arr2];
            [self.stars addObjectsFromArray:arr1];
        }

        CGFloat centerDegree = 0.0f;
        AstroStarHD *first = [self.stars firstObject];
        AstroStarHD *last = [self.stars lastObject];
        if(first.PanDegree > last.PanDegree){
            centerDegree = first.PanDegree + (last.PanDegree - 360.0 + first.PanDegree) * 0.5;
        }else{
            centerDegree = (last.PanDegree + first.PanDegree) * 0.5;
        }
        
        //调整位置
        CGFloat center = [self.stars count] * 0.5;
        if([self.stars count] % 2 == 0){ //双数  4 -> 2 - >1.5
            center -= 0.5;
        }
        
        for(int i = 0; i  < [self.stars count]; i++){
            AstroStarHD *star = [self.stars objectAtIndex:i];
            star.FixDegree = centerDegree + (i - center) * kSpaceDegree;
            if(i == 0){
                self.degreeStart = star.FixDegree;
                if(self.degreeStart <= 0){
                    self.degreeStart = 360.0 + self.degreeStart;
                }
            }
            if(i == [self.stars count] - 1){
                self.degreeEnd = star.FixDegree;
                if(self.degreeEnd >= 360.0){
                    self.degreeEnd -= 360.0;
                }
            }
        }
    }else if([self.stars count] == 1){
        AstroStarHD *star = [self.stars firstObject];
        self.degreeStart = star.FixDegree - kSpaceDegree * 0.5;
        if(self.degreeStart <= 0){
            self.degreeStart = 360.0 + self.degreeStart;
        }
        self.degreeEnd = star.FixDegree + kSpaceDegree * 0.5;
        if(self.degreeEnd >= 360.0){
            self.degreeEnd -= 360.0;
        }
    }
    NSAssert(self.degreeEnd >= 0, @"degreeEnd 不能小于0");
    
}

@end
