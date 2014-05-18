//
//  ASPosition.h
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
@protocol ASPosition
@end

@interface ASPosition : JSONModel
@property (nonatomic, strong) NSString *name;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@end
