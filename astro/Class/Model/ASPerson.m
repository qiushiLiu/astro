//
//  ASPerson.m
//  astro
//
//  Created by kjubo on 14-8-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPerson.h"

@implementation ASPerson
- (id)init{
    if(self = [super init]){
        self.TimeZone = 4;  //东八区
        self.Gender = 1;    //男
        self.Birth = [[NSDate alloc] initWithYear:1990 month:1 day:1 hour:12 minute:0 second:0];
    }
    return self;
}

@end