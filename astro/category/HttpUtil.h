/**
 * http工具类
 * @author qianjiefeng
 *
 */

#import "JSONModel+networking.h"
typedef enum {
    emHttpGet,
    emHttpPost,
} emHttpMethod;

extern NSString * const kAppVerify;
extern NSString * const kAppAgent;
extern double const kDefaultTimeOut;

typedef void (^HttpUtilBlock)(BOOL succ, NSString *message, id json);

@interface HttpUtil : NSObject

+(NSString *)appAgentStr;
+ (void)load:(NSString *)url params:(NSDictionary *)params completion:(HttpUtilBlock)completeBlock;
+ (void)http:(NSString *)url
      method:(emHttpMethod)method
      params:(NSDictionary *)params
     timeOut:(int)sec
  completion:(HttpUtilBlock)completeBlock;

@end



