/**
 * http工具类
 * @author qianjiefeng
 *
 */

#import "HttpUtil.h"
#import "Cipher.h"

@implementation HttpUtil

+ (HttpUtil *)shared{
    static HttpUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[HttpUtil alloc] init];
    });
    return instance;
}

+ (ASIHTTPRequest *)http:(NSString *)url
                  method:(emHttpMethod)method
                  params:(NSMutableDictionary *)params
                 timeOut:(NSInteger)sec
                delegate:(id)delegate
       didFinishSelector:(SEL)didFinishSelector
         didFailSelector:(SEL)didFailSelector
{
    //开始请求
    NSString *completeUrl = [self completeQueryString:url params:params];
    if (kAppDebug) {
        NSLog(@">>%@", completeUrl);
    }
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:completeUrl]];
    //超时时间
    if (sec <= 0) {
        sec = kDefaultTimeOut;
    }
    [req setTimeOutSeconds:sec];
    //启用压缩
    [req allowCompressedResponse];
    [req shouldCompressRequestBody];
    //加密头
    [req addRequestHeader:kAppVerify value:[self restEcName]];
    //头部参数
    [req addRequestHeader:kAppAgent value:[self appAgentStr]];
    //token
//    [req addRequestHeader:kHttpTokenForHeader value:Global.instance.userInfo.token];
    //设置data
    if (method == emHttpPost) {
        if ([params count] > 0) {
            NSString *postData = [params JSONString];
            [req addRequestHeader: @"Content-Type" value:@"application/json; charset=utf-8"];
            [req appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    //ASIHTTPRequest ASIHTTPRequest 有bug 这个不能开启
    [req setShouldAttemptPersistentConnection:NO];
    //设置代理
    [req setDelegate:delegate];
    //设置选择器
    if (didFinishSelector) {
        req.didFinishSelector = didFinishSelector;
    }
    if (didFailSelector) {
        req.didFailSelector = didFailSelector;
    }
    //开始异步调用
    [req startAsynchronous];
    return req;
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


//完善请求字符串
+ (NSString *)completeQueryString:(NSString *)url params:(NSMutableDictionary *)params {
    NSMutableString *result = [NSMutableString string];
    //循环拼接参数
    if ([params count] > 0) {
        ASIFormDataRequest *formDataRequest = [ASIFormDataRequest requestWithURL:nil];
        [params enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSString *value = [formDataRequest encodeURL:obj];
            [result appendFormat:@"%@=%@&", key, value];
        }];
        [result deleteCharactersInRange:NSMakeRange([result length] - 1, 1)];
    }
    //拼接url
    NSString *re = [url trim];
    NSRange range = [re rangeOfString:@"?"];
    if (range.location != NSNotFound) {
        re = [re stringByAppendingFormat:@"&%@",result];
    } else {
        re = [re stringByAppendingFormat:@"?%@",result];
    }
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



