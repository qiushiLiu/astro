//
//  AstroMod.h
//  astro
//
//  Created by kjubo on 14-3-19.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASObject.h"

@interface AstroMod : ASObject
@property (nonatomic, strong) NSMutableArray *Stars;


@property (nonatomic, strong) NSMutableArray *__gong;
@property (nonatomic) CGFloat __constellationStart;

- (UIImage *)paipan;
+ (CGPoint)pointByRadius:(CGFloat)radius andDegree:(CGFloat)degree;
@end
