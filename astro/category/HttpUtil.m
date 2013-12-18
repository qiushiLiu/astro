/**
 * http工具类
 * @author qianjiefeng
 *
 */

#import "HttpUtil.h"


@implementation HttpUtil
+ (ASIHTTPRequest *)http:(NSString *)url
                  method:(emHttpMethod)method
                  params:(NSMutableDictionary *)params
                    data:(NSData *)data
                 timeOut:(NSInteger)sec
       didFinishSelector:(SEL)didFinishSelector
         didFailSelector:(SEL)didFailSelector
                delegate:(id)delegate
                     tag:(int)tag{
    //开始请求
    NSString *completeUrl = [self completeQueryString:url params:params];
    if (kAppDebug) {
        NSLog(@">>%@", completeUrl);
    }
    
    NSAssert([params count] > 0 && data, @"http请求中params和data不能同时有效");
    
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:completeUrl]];
    req.tag = tag;
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
        } else if (data) {
            [req appendPostData:data];
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
//    NSString *haveGpsTag = kEmptyStr;
//    if (Global.instance.haveGpsTag) {
//        haveGpsTag = @"1";
//    } else {
//        haveGpsTag = @"0";
//    }
//    NSString *needCorrectGpsTag = kEmptyStr;
//    if ([@"iPhone 3GS" isEqualToString:Global.instance.deviceType]) {
//        needCorrectGpsTag = @"1";
//    } else {
//        if (Global.instance.haveMkGpsTag) {
//            needCorrectGpsTag = @"0";
//        } else {
//            needCorrectGpsTag = @"1";
//        }
//    }
//    NSString *lon = [JsonTransUtil doubleToJson:Global.instance.lon];
//    NSString *lat = [JsonTransUtil doubleToJson:Global.instance.lat];
    
    //buddleId/version(ios[version];deviceType;deviceId;kAppChannelId)
    NSString *re = [NSString stringWithFormat:@"%@/%@(ios%.2f;apple/%@;%@;%@;)",
                    [[NSBundle mainBundle] bundleIdentifier],
                    kAppVersion,
                    7.0,
                    @"deviceType",
                    @"deviceNumberStr",
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
//    NSMutableString *token = [NSMutableString string];
//    [token appendString:Global.instance.deviceNumberStr];
//    [token appendString:@","];
//    [token appendString:[DateUtil dateNumberFrom1970WithNow]];
//    Cipher* cipher = [[Cipher alloc] initWithKey:@""];
//    NSData* plainData = [token dataUsingEncoding: NSUTF8StringEncoding];
//    NSData* encryptedData = [cipher encrypt:plainData ];
//    NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@" <>"];
//    NSString *hexRepresentation = [[encryptedData description] stringByTrimmingCharactersInSet:charsToRemove] ;
//    hexRepresentation = [hexRepresentation stringByReplacingOccurrencesOfString:@" " withString:@""];
//    [cipher release];
//    return [hexRepresentation uppercaseString];
    return @"";
}

@end



