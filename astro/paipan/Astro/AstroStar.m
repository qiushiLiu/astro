//
//  AstroStar.m
//  astro
//
//  Created by kjubo on 14-3-19.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "AstroStar.h"

@implementation AstroStar
@end

@implementation AstroStarHD
- (id)initWithAstro:(AstroStar *)star{
    if(self = [super init]){
        self.base = star;
        self.DegreeHD = self.base.Degree + self.base.Cent/60.0;
    }
    return self;
}
@end
