/**
 * http工具类
 * @author qianjiefeng
 *
 */

#import "ASIFormDataRequest.h"

typedef enum {
    emHttpGet,
    emHttpPost,
} emHttpMethod;

extern NSString * const kAppVerify;
extern NSString * const kAppAgent;
extern double const kDefaultTimeOut;

@interface HttpUtil : NSObject

+ (ASIHTTPRequest *)http:(NSString *)url
                  method:(emHttpMethod)typeTag
                 params:(NSMutableDictionary *)params
                   data:(NSData *)data
                timeOut:(NSInteger)sec
      didFinishSelector:(SEL)didFinishSelector
        didFailSelector:(SEL)didFailSelector
               delegate:(id)delegate
                    tag:(int)tag;


+(NSString *)completeQueryString:(NSString *)url params:(NSMutableDictionary *)params;

+(NSString *)appAgentStr;


@end



