//
//  NSDate+Addition.m
//  astro
//
//  Created by kjubo on 14-3-5.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "NSDate+Addition.h"

#define CURRENT_CALENDAR [NSCalendar currentCalendar]
#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
static NSRegularExpression *regDate;

@implementation NSDate (Addition)

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regDate = [NSRegularExpression regularExpressionWithPattern:@"Date\\((\\d+)\\+\\d+\\)"
                                                        options:NSRegularExpressionCaseInsensitive
                                                          error:NULL];
    });
}

- (id)initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    return [calendar dateFromComponents:components];
}

+ (NSArray *)dateArrayFromNet:(NSArray *)values{
    NSMutableArray* list = [NSMutableArray arrayWithCapacity:[values count]];
    [values enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [list addObject:[self dateFromNet:obj]];
    }];
    return list;
}

+ (id)dateFromNet:(NSString *)str{
    if(str == nil){
        return nil;
    }
    NSArray *matches = [regDate matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    if([matches count] == 1){
        NSTextCheckingResult *rs = [matches objectAtIndex:0];
        NSTimeInterval time = [[str substringWithRange:[rs rangeAtIndex:1]] longLongValue] / 1000;
        return [NSDate dateWithTimeIntervalSince1970:time];
    }else{
        return nil;
    }
}

- (NSTimeInterval)compareWithDate:(NSDate *)date{
    return [self timeIntervalSince1970] - [date timeIntervalSince1970];
}

//获得日期字符串
- (NSString *)toStrFormat:(NSString *)format{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"GMT+8"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:format];
    NSString *destDateString = [dateFormatter stringFromDate:self];
    return destDateString;
}


#pragma mark Decomposing Dates

- (NSInteger) nearestHour
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	NSDateComponents *components = [CURRENT_CALENDAR components:NSHourCalendarUnit fromDate:newDate];
	return components.hour;
}

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.week;
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}

- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

@end
