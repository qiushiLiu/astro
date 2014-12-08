//
//  DateEntity.m
//  astro
//
//  Created by kjubo on 14-3-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "DateEntity.h"

@implementation DateEntity
- (id)copyWithZone:(NSZone *)zone{
    DateEntity *entity = [[[self class] allocWithZone:zone] init];
    [entity setDate:[self.Date copy]];
    [entity setBeginMonthShow:[self.BeginMonthShow copy]];
    [entity setBeginZodiacShow:[self.BeginZodiacShow copy]];
    entity.NongliDay = self.NongliDay;
    entity.NongliDZ = self.NongliDZ;
    entity.NongliHour = self.NongliHour;
    entity.NongliMonth = self.NongliMonth;
    entity.NongliTG = self.NongliTG;
    return entity;
}

@end
