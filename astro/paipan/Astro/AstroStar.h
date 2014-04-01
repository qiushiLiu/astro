//
//  AstroStar.h
//  astro
//
//  Created by kjubo on 14-3-19.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASObject.h"

@interface AstroStar : ASObject
@property (nonatomic) NSInteger StarName;
@property (nonatomic) NSInteger Gong;
@property (nonatomic) NSInteger Degree;
@property (nonatomic) double Cent;
@property (nonatomic) NSInteger Constellation;
@property (nonatomic) double Progress;

@property (nonatomic, readonly) CGFloat DegreeHD;
@property (nonatomic) CGFloat PanDegree;
@end
