//
//  DateEntity.h
//  astro
//
//  Created by kjubo on 14-3-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface DateEntity : JSONModel <NSCopying>
@property (nonatomic, strong) NSDate *Date;
@property (nonatomic, strong) NSArray *BeginMonthShow;
@property (nonatomic, strong) NSArray *BeginZodiacShow;
@property (nonatomic) NSInteger NongliTG;
@property (nonatomic) NSInteger NongliDZ;
@property (nonatomic) NSInteger NongliMonth;
@property (nonatomic) NSInteger NongliDay;
@property (nonatomic) NSInteger NongliHour;
@end
