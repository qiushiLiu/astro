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
    NSInteger code = [[re objectForKey:@"Code"] intValue];
    if (code == 200) {
        [self appendFromJsonObject:[re objectForKey:@"Value"]];
        if([self.delegate respondsToSelector:@selector(modelLoadFinished:)]){
            [self.delegate modelLoadFinished:self];
        }
    } else {
        if([self.delegate respondsToSelector:@selector(modelLoadFaild:message:)]){
            [self.delegate modelLoadFaild:self message:[re objectForKey:@"Message"]];
        }
    }
}

- (void)_requestFailed:(ASIHTTPRequest *)req{
    if (kAppDebug) {
        NSLog(@">%@",[req responseString]);
    }
    
    int code = [[req error] code];
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
