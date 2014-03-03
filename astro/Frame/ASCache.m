//
//  ASCache.m
//  astro
//
//  Created by kjubo on 13-12-31.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASCache.h"

@implementation ASCacheObject
@end

@implementation ASCache

+ (ASCache *)shared{
    static ASCache *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ASCache alloc] init];
    });
    return instance;
}

- (id)init{
    if (self = [super init]){
        //paths： ios下Document路径，Document为ios中可读写的文件夹
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *dbDir = [paths objectAtIndex:0];
        NSString *dbPath = [dbDir stringByAppendingPathComponent:@"cache.db"];
        //创建数据库实例 db  这里说明下:如果路径中不存在"cache.db"的文件,sqlite会自动创建"cache.db"
        _db= [FMDatabase databaseWithPath:dbPath] ;
        if (_db.open) {
            //创建表
            [_db executeUpdate:@"create table if not exists cachetb (cid integer primary key autoincrement,cdir text,ckey text,cvalue text,cexpire DATETIME NOT NULL)"];
            //创建索引
            [_db executeUpdate:@"create index if not exists idx_cdir on cachetb(cdir)"];
            [_db executeUpdate:@"create index if not exists idx_ckey on cachetb(ckey)"];
            [_db executeUpdate:@"create index if not exists idx_cversion on cachetb(cexpire)"];
            
            //清理过期数据
            [_db executeQuery:@"delete from cachetb where cexpire <= DATE(?)", [NSDate date]];
        }
        
        _valuesCached = [[NSMutableDictionary alloc] init];
        _valuesKeyList = [[NSMutableArray alloc] init];
        
        _imagesCached = [[NSMutableDictionary alloc] init];
        _imagesKeyList = [[NSMutableArray alloc] init];
    }
    return self;
}

//清理缓存
- (void)cleanAllValueCache{
    if(_db.open){
        [_db executeUpdate:@"delete from cachetb"];
    }
}

- (void)storeValue:(NSString *)value dir:(NSString *)dir key:(NSString *)key{
    [self storeValue:value dir:dir key:key expire:[NSDate dateWithTimeIntervalSinceNow:A_DAY_SECONDS]];
}

- (void)storeValue:(NSString *)value dir:(NSString *)dir key:(NSString *)key expire:(NSDate *)expire{
	//数据容错
	NSString *newDir = [dir trim];
	NSString *newKey = [key trim];
    //有记录就先删除
    int i = [_db intForQuery:@"select count(*) from cachetb where cdir=? and ckey=?", newDir, newKey];
    if (i > 0) {
        [_db executeUpdate:@"delete from cachetb where cdir=? and ckey=?", newDir, newKey];
    }
    //存储数据
    [_db executeUpdate:@"insert into cachetb (cdir, ckey, cvalue, cexpire) VALUES (?,?,?,DATE(?))", newDir, newKey, value, expire];
    //从二级缓存中移除
    [self removeCacheFieldsFromValueDic:[self createSecondCachedKeyForDir:dir key:key]];
}

//为二级缓存生成缓存key
- (NSString *)createSecondCachedKeyForDir:(NSString *)dir key:(NSString *)key{
    return [NSString stringWithFormat:@"%@-*-%@",dir,key];
}

//移除
- (void)removeDir:(NSString *)dir key:(NSString *)key{
	NSString *newDir = [dir trim];
	NSString *newKey = [key trim];
    //从数据库删除
    [_db executeUpdate:@"delete from cachetb where cdir=? and ckey=?", newDir, newKey];
    //从二级缓存中移除
    [self removeCacheFieldsFromValueDic:[self createSecondCachedKeyForDir:newDir key:newKey]];
}

//从二级缓存中移出数据
- (void)removeCacheFieldsFromValueDic:(NSString *)key{
    if ([key length] > 0) {
    	id x = [_valuesCached valueForKey:key];
    	if (x) {
            [_valuesCached removeObjectForKey:key];
    	}
    }
}

//读取
- (ASCacheObject *)readDicFiledsWithDir:(NSString *)dir key:(NSString *)key{
    NSString *newDir = [dir trim];
    NSString *newKey = [key trim];
	//先从二级缓存中读取
    NSString *dicKey = [self createSecondCachedKeyForDir:newDir key:newKey];
    ASCacheObject *objCached = [_valuesCached valueForKey:dicKey];
    if (!objCached) {
        //如果二级缓存中没有 就从数据库中查
        FMResultSet *rs = [_db executeQuery:@"select * from cachetb where cdir=? and ckey=? and cexpire >= DATE(?)", newDir, newKey, [NSDate date]];
        if ([rs next]) {
            //组织返回数据
            ASCacheObject *c = [[ASCacheObject alloc] init];
            //目录
            c.dir = [rs stringForColumn:@"cdir"];
            //关键词
            c.key = [rs stringForColumn:@"ckey"];
            //值
            c.value = [rs stringForColumn:@"cvalue"];
            //过期时间戳
            c.expire = [rs dateForColumn:@"cupdatestamp"];
            //保存到二级缓存中
            [self saveCacheFieldsToValueDic:c dicKey:dicKey];
        }
        return objCached;
    }else if(objCached.expire < [NSDate date]){
        return objCached;
    }else{
        return nil;
    }
}

//把数据存储到二级缓存中
- (void)saveCacheFieldsToValueDic:(ASCacheObject *)c dicKey:(NSString *)dicKey{
    if (c && [dicKey length] > 0) {
    	//先检查dic中原来有没有 没有的话把key添加到key列表中
    	ASCacheObject *x = [_valuesCached valueForKey:dicKey];
        if (!x) {
            [_valuesKeyList addObject:dicKey];
        }
        //然后把CacheFields保存到dic中
        [_valuesCached setValue:c forKey:dicKey];
        //最后检查dic是否超出限制 超出的话删除一个最先进来的数据
        if ([_valuesCached count] > kMemoryCachedMaxNum) {
            NSString *key = [_valuesKeyList objectAtIndex:0];
            [_valuesCached removeObjectForKey:key];
            [_valuesKeyList removeObjectAtIndex:0];
        }
	}
}


//读取图片
- (UIImage *)readImageWithDir:(NSString *)dir url:(NSString *)url{
    //从文件系统中读取
    BOOL e = [self chkExistImageWithDir:dir url:url];
    if (e) {
        NSString *filePath = [self imagePathWithDir:dir url:url];
        if ([filePath length] > 0) {
            //no cacahed
            UIImage *img = [[UIImage alloc] initWithContentsOfFile:filePath];
            return img;
        }
    }
    return nil;
}


//把图片存储到二级缓存中
- (void)saveImgToImgDic:(UIImage *)img dicKey:(NSString *)key{
    if (img && [key length] > 0) {
    	//先检查dic中原来有没有 没有的话把key添加到key列表中
        UIImage *x = [_imagesCached valueForKey:key];
        if (!x) {
            [_imagesKeyList addObject:key];
        }
        //然后把img保存到dic中
        [_imagesCached setValue:img forKey:key];
        //最后检查dic是否超出限制 超出的话删除一个最先进来的数据
        if ([_imagesKeyList count] > kImageCacheMaxNum) {
            NSString *k = [_imagesKeyList objectAtIndex:0];
            [_imagesCached removeObjectForKey:k];
            [_imagesKeyList removeObjectAtIndex:0];
        }
    }
}

- (BOOL)storeImageData:(NSData *)data dir:(NSString *)dir url:(NSString *)url{
    NSString *filePath = [self imagePathWithDir:dir url:url];
    if ([filePath length] > 0 && data) {
        UIImage *img = [[UIImage alloc] initWithData:data];
        NSString *dicKey = [[NSString alloc] initWithFormat:@"%@-%@", dir, url];
        [self saveImgToImgDic:img dicKey:dicKey];
        //存储到文件系统中
        return [data writeToFile:filePath atomically:YES];
    }
    return NO;
}

//检查是否存在图片
- (BOOL)chkExistImageWithDir:(NSString *)dir url:(NSString *)url {
    //是否在文件系统中
    NSString *filePath = [self imagePathWithDir:dir url:url];
    if ([filePath length] > 0) {
        NSFileManager *f = [NSFileManager defaultManager];
        return [f fileExistsAtPath:filePath];
    }
    return NO;
}

//获得图片路径
-(NSString *)imagePathWithDir:(NSString *)dir url:(NSString *)url {
    //确保dir和url都不能为空
    NSString *newDir = [dir trim];
    if ([newDir length] == 0
        || [url length] == 0) {
        return nil;
    }
    //文件名
    NSString *fileName = [self fileNameByUrl:url];
    
    if ([fileName length] == 0) {
        return nil;
    }
    
    NSString *tempPath = [[NSString alloc] initWithFormat:@"%@/tmp",NSHomeDirectory()];
    NSString *dirPath = [[NSString alloc] initWithFormat:@"%@/%@", tempPath, dir];
    NSFileManager *f = [NSFileManager defaultManager];
    //判断tmp文件夹是否存在
    if (![f fileExistsAtPath:dirPath]) {
        //不存在目录就创建一个
        [f createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    //文件路径
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",dirPath,fileName];
    return filePath;
}

- (NSString *)fileNameByUrl:(NSString *)url {
    NSURL *t = [[NSURL alloc] initWithString:url];
    //path
    NSString *path = [t path];
    if (path) {
        path = [path lowercaseString];
        path = [path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }else{
        path = @"";
    }
    //query
    NSString *query = [t query];
    if (query){
        query = [query lowercaseString];
    }
    
    NSString *re = [NSString stringWithFormat:@"%@%@", path, query];
    return re;
}



@end
