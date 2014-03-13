//
//  ZiWeiMod.m
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//
#import "ZiWeiMod.h"
#import "ZiWeiStar.h"
#import "DateEntity.h"
#import "ZiWeiGong.h"

@interface ZiWeiZi : NSObject
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDictionary *attributed;
@end

@implementation ZiWeiZi

@end

@interface ZiWeiMod ()
@property (nonatomic, strong) NSMutableArray *zilist;
@end

@implementation ZiWeiMod
+ (Class)classForJsonObjectByKey:(NSString *)key {
    if([key isEqualToString:@"BirthTime"]){
        return [DateEntity class];
    }else if([key isEqualToString:@"TransitTime"]){
        return [DateEntity class];
    }
    return nil;
}

+ (Class)classForJsonObjectsByKey:(NSString *)key {
    if([key isEqualToString:@"Xing"]){
        return [ZiWeiStar class];
    } else if([key isEqualToString:@"Gong"]){
        return [ZiWeiGong class];
    }
    return nil;
}

- (UIImage *)paipan
{
    CGSize size = CGSizeMake(320, 485);
    UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    [UIColorFromRGB(0xf7f4ee) setFill];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    
    self.zilist = [[NSMutableArray alloc] initWithCapacity:12*9*10];
    for(int i = 0; i < [self.Xing count]; i++){
        if(i == 58 ||  i == 59 || i == 62 || i == 63 || i == 66 || i == 64 || i == 67){
            continue;
        }
        
        for(int j = 9; j >= 0; j--){
            ZiWeiStar *xi = [self.Xing objectAtIndex:i];
            ZiWeiZi *zi = [self ziAtx:xi.Gong y:0 z:j];
            if(!zi) {
                
            }
        }
        
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (ZiWeiZi *)ziAtx:(int)x y:(int)y z:(int)z{
    return [self.zilist objectAtIndex:x*12 + y*9 + z];
}

- (void)setZi:(NSString *)zi attributed:(NSDictionary *)attributed atx:(int)x y:(int)y z:(int)z{
    ZiWeiZi *newZi = [[ZiWeiZi alloc] init];
    newZi.content = [zi copy];
    newZi.attributed = attributed;
    [self.zilist setObject:newZi atIndexedSubscript:x*12 + y*9 + z];
}
@end
