//
//  ASGlobal.h
//  astro
//
//  Created by kjubo on 14-2-25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASCustomer.h"
@interface ASGlobal : NSObject

@property (nonatomic, strong) ASCustomer *user;
@property (nonatomic, strong) NSString *deviceNumber;
@property (nonatomic, readonly) NSInteger fateType;
+ (ASGlobal *)shared;
+ (void)login:(ASCustomer *)user;
+ (BOOL)isLogined;
@end
