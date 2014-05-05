//
//  ASQaAstroList.h
//  astro
//
//  Created by kjubo on 14-4-17.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPageInfo.h"
#import "ASQaMinAstro.h"
@interface ASQaAstroList : ASPageInfo
@property (nonatomic, strong) NSArray<ASQaMinAstro> *List;
@end
