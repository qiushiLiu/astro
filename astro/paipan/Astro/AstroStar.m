//
//  AstroStar.m
//  astro
//
//  Created by kjubo on 14-3-19.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "AstroStar.h"

@implementation AstroStar
- (CGFloat)DegreeHD{
    return self.Degree + self.Cent/60.0;
}
@end
