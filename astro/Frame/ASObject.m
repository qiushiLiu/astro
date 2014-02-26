//
//  ASObject.m
//  astro
//
//  Created by kjubo on 13-12-21.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASObject.h"
#import "HttpUtil.h"

@implementation ASObject

- (void)dealloc{
    if(_request){
        [_request cancel];
    }
}

- (NSDictionary *)properties_aps {
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding] ;
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

- (NSString *)toJsonString{
    return [[self properties_aps] JSONString];
}

#pragma mark - HttpRequest

- (void)load:(NSString *)url params:(NSMutableDictionary *)params{
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", kAppHost, url];
    if(_request){
        [_request cancel];
    }
    
    if([self.delegate respondsToSelector:@selector(modelBeginLoad:)]){
        [self.delegate modelBeginLoad:self];
    }
    _request = [HttpUtil http:requestUrl method:emHttpGet params:params timeOut:kDefaultTimeOut delegate:self didFinishSelector:@selector(_requestFinished:) didFailSelector:@selector(_requestFailed:)];
}

- (void)_requestFinished:(ASIHTTPRequest *)req{
    if (kAppDebug) {
        NSLog(@">%@",[req responseString]);
    }
    NSDictionary *re = [[req responseString] objectFromJSONString];
    
    if([re objectForKey:@"Code"]){
        NSInteger code = [[re objectForKey:@"Code"] intValue];
        if (code == 200) {
            if([NSStringFromClass([self class]) isEqualToString:@"ASReturnValue"]){
                [self appendFromJsonObject:re];
            }else{
                [self appendFromJsonObject:[re objectForKey:@"Value"]];
            }
            if([self.delegate respondsToSelector:@selector(modelLoadFinished:)]){
                [self.delegate modelLoadFinished:self];
            }
        } else {
            if([self.delegate respondsToSelector:@selector(modelLoadFaild:message:)]){
                [self.delegate modelLoadFaild:self message:[re objectForKey:@"Message"]];
            }
        }
    }else{
        if([self.delegate respondsToSelector:@selector(modelLoadFaild:message:)]){
            [self.delegate modelLoadFaild:self message:@"请求服务器失败"];
        }
    }
}

- (void)_requestFailed:(ASIHTTPRequest *)req{
    if (kAppDebug) {
        NSLog(@">%@",[req responseString]);
    }
    
    NSInteger code = [[req error] code];
    if([self.delegate respondsToSelector:@selector(modelLoadFaild:message:)]){
        if (code == 1) {
            [self.delegate modelLoadFaild:self message:@"似乎已断开与互联网的连接"];
        }else if (code == 2){
            [self.delegate modelLoadFaild:self message:@"抱歉,网络查询超时"];
        }else{
            [self.delegate modelLoadFaild:self message:@"网络查询出错"];
        }
    }
}

@end
