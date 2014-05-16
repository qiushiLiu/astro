//
//  ASHelper.m
//  astro
//
//  Created by kjubo on 14-5-15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASHelper.h"

@implementation ASHelper


+ (NSString *)sexText:(NSInteger)sex{
    if(sex == 0){
        return @"女";
    }else if(sex == 1){
        return @"男";
    }else{
        return @"保密";
    }
}


@end
