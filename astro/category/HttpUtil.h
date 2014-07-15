/**
 * http工具类
 * @author Kjubo
 *
 */

#import "JSONModel+networking.h"
typedef enum {
    emHttpGet,
    emHttpPost,
} emHttpMethod;

extern NSString * const kAppVerify;
extern NSString * const kAppAgent;
extern NSString * const kAppToken;
extern double const kDefaultTimeOut;

typedef void (^HttpUtilBlock)(BOOL succ, NSString *message, id json);

@interface HttpUtil : NSObject
+ (NSString *)appAgentStr;
+ (NSString*)urlEncode:(id<NSObject>)value;
+ (void)load:(NSString *)url params:(NSDictionary *)params completion:(HttpUtilBlock)completeBlock;
+ (void)post:(NSString *)url params:(NSDictionary *)params body:(NSString *)body completion:(HttpUtilBlock)completeBlock;
+ (void)post:(NSString *)url params:(NSDictionary *)params bodyData:(NSData *)body completion:(HttpUtilBlock)completeBlock;
@end



