//
//  NSString+Addition.m
//  Xms
//
//  Created by liuqiushi on 12-4-1.
//  Copyright (c) 2012年 订餐小秘书 . All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

- (NSString *)stringByDecodingURLFormat {
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)trim{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
