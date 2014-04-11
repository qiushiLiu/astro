/**
 * http工具类
 * @author qianjiefeng
 *
 */

#import "HttpUtil.h"
#import "Cipher.h"

@implementation HttpUtil

+ (void)load:(NSString *)url params:(NSDictionary *)params completion:(HttpUtilBlock)completeBlock{
    [self http:url method:emHttpGet params:params timeOut:0 completion:completeBlock];
}

+ (void)http:(NSString *)url
      method:(emHttpMethod)method
      params:(NSDictionary *)params
     timeOut:(int)sec
  completion:(HttpUtilBlock)completeBlock
{
    //开始请求
    NSString *completeUrl = [NSString stringWithFormat:@"%@/%@", kAppHost, url];
    
    //超时时间
    if (sec <= 0) {
        [JSONHTTPClient setTimeoutInSeconds:kDefaultTimeOut];
    }
    [JSONHTTPClient setTimeoutInSeconds:sec];
    
    //头部参数
    NSMutableDictionary* headers = [JSONHTTPClient requestHeaders];
    headers[kAppAgent] = [self appAgentStr];
    //token
    //    [req addRequestHeader:kHttpTokenForHeader value:Global.instance.userInfo.token];
    //设置data
    if (method == emHttpPost) {
        [JSONHTTPClient setRequestContentType:@"application/json; charset=utf-8"];
        [JSONHTTPClient JSONFromURLWithString:completeUrl method:@"POST" params:params orBodyString:nil headers:nil completion:^(id json, JSONModelError *err) {
            [self completionBlock:json error:err completion:completeBlock];
        }];
    }else{
        [JSONHTTPClient JSONFromURLWithString:completeUrl method:@"GET" params:params orBodyString:nil headers:nil completion:^(id json, JSONModelError *err) {
            [self completionBlock:json error:err completion:completeBlock];
        }];
    }
}

+ (void)completionBlock:(id)json error:(JSONModelError *)err completion:(HttpUtilBlock)completeBlock{
    BOOL succ = NO;
    NSString *message = nil;
    id jsonObject = nil;
    if(err != NULL || json == nil){
        message = @"系统错误";
    }else if([json[@"Code"] intValue] != 200){
        message = json[@"Message"];
    }else{
        succ = YES;
        message = json[@"Message"];
        jsonObject = json[@"Value"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (completeBlock) {
            completeBlock(succ, message, jsonObject);
        }
    });
}

+ (NSString *)appAgentStr{
    //buddleId/version([iosSystem][systemVerson];deviceType;deviceId;AppChannelId)
    NSString *re = [NSString stringWithFormat:@"%@/%@(%@,%@;apple/%@;%@;%@;)",
                    [[NSBundle mainBundle] bundleIdentifier],
                    kAppVersion,
                    [UIDevice currentDevice].systemName,
                    [UIDevice currentDevice].systemVersion,
                    [UIDevice currentDevice].model,
                    [ASGlobal shared].deviceNumber,
                    kAppChannel
                    ];
    return re;
}

+ (NSString *)restEcName{
    //将 设备号+时间戳 放入请求头
    NSMutableString *ecName = [NSMutableString string];
    [ecName appendString:[ASGlobal shared].deviceNumber];
    [ecName appendString:@","];
    NSTimeInterval time=[[NSDate date] timeIntervalSince1970];
    [ecName appendString:[NSString stringWithFormat:@"%.0f",time]];
    Cipher* cipher = [[Cipher alloc] initWithKey:@""];
    NSData* plainData = [ecName dataUsingEncoding: NSUTF8StringEncoding];
    NSData* encryptedData = [cipher encrypt:plainData];
    NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@" <>"];
    NSString *hexRepresentation = [[encryptedData description] stringByTrimmingCharactersInSet:charsToRemove] ;
    hexRepresentation = [hexRepresentation stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [hexRepresentation uppercaseString];
}

@end



