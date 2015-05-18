//
//  ASFirdaria.h
//  astro
//
//  Created by kjubo on 15/5/18.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@protocol ASFirdaria
@end

@interface ASFirdaria : JSONModel
@property (nonatomic, strong) NSDate *Begin;
@property (nonatomic, strong) NSDate *End;
@property (nonatomic) NSInteger Star;
@end
