//
//  ASQaAstro.h
//  astro
//
//  Created by kjubo on 14-4-17.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASQaBase.h"
#import "AstroMod.h"
@protocol ASQaMinAstro
@end

@interface ASQaMinAstro : ASQaBase
@property (nonatomic, strong) NSArray<AstroMod> *Chart;
@end
