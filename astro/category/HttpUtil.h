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
                  method:(emHttpMethod)method
                  params:(NSMutableDictionary *)params
                 timeOut:(NSInteger)sec
                delegate:(id)delegate
       didFinishSelector:(SEL)didFinishSelector
         didFailSelector:(SEL)didFailSelector;


+(NSString *)completeQueryString:(NSString *)url params:(NSMutableDictionary *)params;

+(NSString *)appAgentStr;


@end



