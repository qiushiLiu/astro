//
//  ASQaCustomerBazi.h
//  astro
//
//  Created by kjubo on 14-6-3.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASQaCustomerBase.h"
#import "BaziMod.h"
@interface ASQaCustomerBazi : ASQaCustomerBase<ASQaCustomerBaseProtocol>
@property (nonatomic, strong) NSArray<BaziMod> *Chart;
@end
