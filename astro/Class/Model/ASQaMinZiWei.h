//
//  ASQaMinZiWei.h
//  astro
//
//  Created by kjubo on 14-5-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASQaBase.h"
#import "ZiWeiMod.h"
@protocol ASQaMinZiWei
@end


@interface ASQaMinZiWei : ASQaBase <ASQaProtocol>
@property (nonatomic, strong) NSArray<ZiWeiMod> *Chart;
@end
