//
//  ASPostQuestion.m
//  astro
//
//  Created by kjubo on 14-7-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPostQuestion.h"

@implementation ASPostQuestion

- (id)init{
    if(self = [super init]){
        ASFateChart *ct = [[ASFateChart alloc] init];
        ct.FirstBirth = (NSDate<NSDate> *)[[NSDate alloc] initWithYear:1990 month:1 day:1 hour:12 minute:0 second:0];
        ct.FirstDayLight = 0;  //东八区
        ct.FirstGender = 1;    //男
        ct.FirstPoi = @"";
        ct.FirstPoiName = @"";
        
        ct.SecondBirth = (NSDate<NSDate> *)[[NSDate alloc] initWithYear:1990 month:1 day:1 hour:12 minute:0 second:0];
        ct.SecondDayLight = 0;  //东八区
        ct.SecondGender = 1;    //男
        ct.SecondPoi = @"";
        ct.SecondPoiName = @"";
        
        self.Chart = (NSArray<ASFateChart> *)@[ct];
    }
    return self;
}
@end
