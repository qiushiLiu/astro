//
//  ASPerson.h
//  astro
//
//  Created by kjubo on 14-8-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASPerson : NSObject
@property (nonatomic, strong) NSDate *Birth;
@property (nonatomic) NSInteger Gender;
@property (nonatomic) NSInteger DayLight;
@property (nonatomic) NSInteger TimeZone;
@property (nonatomic) float longitude;
@property (nonatomic) float latitude;
@property (nonatomic) NSString *poiName;
@end