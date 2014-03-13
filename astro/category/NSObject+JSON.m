//
//  NSObject+JSON.m
//  Astro
//
//  Created by ARD User on 13-12-18.
//  Copyright (c) 2013年 ARDUser. All rights reserved.
//

#import "NSObject+JSON.h"
#import "JSONKit.h"
#import <objc/runtime.h>

@implementation NSObject (JSON)

+ (NSRegularExpression *)regDate{
    static NSRegularExpression *reg = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reg = [NSRegularExpression regularExpressionWithPattern:@"Date\\((\\d+)\\+\\d+\\)"
                                                        options:NSRegularExpressionCaseInsensitive
                                                          error:NULL];
    });
    return reg;
}


- (id)initFromJsonString:(NSString *)str{
    id entry = [str objectFromJSONString];
    return [self initFromJsonObject:entry];
}

- (id)initFromJsonObject:(id)entry {
    if([entry isKindOfClass:[NSDictionary class]]){
        if ((self = [self init])) {
            [self appendFromJsonObject:entry];
        }
        return self;
    }else if([entry isKindOfClass:[NSString class]]){
        NSArray *matches = [[self class].regDate matchesInString:entry
                                                         options:0
                                                           range:NSMakeRange(0, [entry length])];
        if([matches count] == 1){
            NSTextCheckingResult *rs = [matches objectAtIndex:0];
            NSTimeInterval time = [[entry substringWithRange:[rs rangeAtIndex:1]] longLongValue] / 1000;
            self = [NSDate dateWithTimeIntervalSince1970:time];
        }else{
            self = entry;
        }
    }else{
        self = entry;
    }
	return self;
}

- (void)appendFromJsonObject:(NSDictionary *)entry{
    if(entry){
        for(id key in [entry allKeys]){
            id obj = [entry objectForKey:key];
            if(!obj)
                continue;
            
            BOOL hasVar = [self hasCorrspondingVariableForkey:key];
            if (hasVar) {
                if ([obj isKindOfClass:[NSArray class]]) {
                    Class class = [[self class] classForJsonObjectsByKey:key];
                    if (class) {
                        NSArray *subResults = [[self class] createObjectsWithClass:class fromJsonArray:obj];
                        [self setValue:subResults forKey:key];
                    } else {
                        [self setValue:obj forKey:key];
                    }
                }else {
                    Class class = [[self class] classForJsonObjectByKey:key];
                    
                    if (class) {
                        id dsObject = [NSObject createObjectWithClass:class fromJsonObject:obj];
                        [self setValue:dsObject forKey:key];
                    } else {
                        [self setValue:obj forKey:key];
                    }
                }
            }
        }
    }
}

- (BOOL)hasCorrspondingVariableForkey:(NSString*)key{
    const char *ckey = [[NSString stringWithFormat:@"_%@", key] cStringUsingEncoding:NSUTF8StringEncoding];
    return class_getInstanceVariable(object_getClass(self), ckey) != NULL;
}

+ (Class)classForJsonObjectsByKey:(NSString *)key {
    return nil;
}

+ (Class)classForJsonObjectByKey:(NSString *)key {
    return nil;
}

+ (id)createObjectWithClass:(Class)class fromJsonObject:(id)object {
	if (!object) {
		return nil;
	}
	id obj = [[class alloc] initFromJsonObject:object];
	return obj;
}

+ (id)createObjectsWithClass:(Class)class fromJsonArray:(id)array {
	if (array == nil
        ||![array isKindOfClass:[NSArray class]]) {
		return nil;
	}
    
    NSMutableArray *results = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [results addObject:[[class alloc] initFromJsonObject:obj]];
    }];
    
    return results;
}

@end
