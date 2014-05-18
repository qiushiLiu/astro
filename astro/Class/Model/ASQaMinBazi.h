//
//  ASQaMinBazi.h
//  astro
//
//  Created by kjubo on 14-5-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASQaBase.h"
#import "BaziMod.h"
@protocol ASQaMinBazi
@end

@interface ASQaMinBazi : ASQaBase <ASQaProtocol>
@property (nonatomic, strong) NSArray<BaziMod> *Chart;
@end
