//
//  ASCache.h
//  astro
//
//  Created by kjubo on 13-12-31.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface ASCacheObject : NSObject
@property (nonatomic, strong) NSString *dir;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, strong) NSDate *expire;
@end

extern NSInteger const kMemoryCachedMaxNum;
extern NSInteger const kImageCacheMaxNum;

@interface ASCache : NSObject{
    //数据库连接
    FMDatabase *_db;
    //二级缓存
    NSMutableDictionary *_valuesCached;
    //二级缓存顺序列表
    NSMutableArray *_valuesKeyList;
    //图片二级缓存
    NSMutableDictionary *_imagesCached;
    NSMutableArray *_imagesKeyList;
}

+ (ASCache *)shared;

- (void)cleanAllValueCache;
- (void)storeValue:(NSString *)value dir:(NSString *)dir key:(NSString *)key;
- (void)storeValue:(NSString *)value dir:(NSString *)dir key:(NSString *)key expire:(NSDate *)expire;

- (BOOL)chkExistImageWithDir:(NSString *)dir url:(NSString *)url;
- (UIImage *)readImageWithDir:(NSString *)dir url:(NSString *)url;
- (BOOL)storeImageData:(NSData *)data dir:(NSString *)dir url:(NSString *)url;
- (ASCacheObject *)readDicFiledsWithDir:(NSString *)dir key:(NSString *)key;
@end
