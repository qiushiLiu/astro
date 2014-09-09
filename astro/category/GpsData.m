//
//  GpsData.m
//  app
//
//  Created by kjubo on 14-5-22.
//  Copyright (c) 2014年 吉运软件. All rights reserved.
//

#import "GpsData.h"

@interface GpsAddress : JSONModel
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *street_number;
@end

@implementation GpsAddress

@end

@interface GpsData ()
@property (nonatomic) dispatch_queue_t writeQueue; ///< Add this
@property (nonatomic, strong) NSDate *mkGpsDate;
@property (nonatomic, strong) GpsAddress *gpsAddress;
@end

@implementation GpsData

+ (instancetype)shared{
    static GpsData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[GpsData alloc] init];
    });
    return instance;
}

- (id)init{
    if(self = [super init]){
        self.writeQueue = dispatch_queue_create("com.iDestiny.astro", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

//设置苹果经纬度
- (void)setMKGpsLocation:(CLLocationCoordinate2D)loc{
    dispatch_barrier_async(self.writeQueue, ^{ // 2
        _mkLon = loc.longitude;
        _mkLat = loc.latitude;
        self.mkGpsDate = [NSDate date];
        
        [HttpUtil load:@"app/loactionall" params:@{@"log" : [NSString stringWithFormat:@"%f", _mkLon],
                                                @"lat" : [NSString stringWithFormat:@"%f", _mkLat]}
            completion:^(BOOL succ, NSString *message, id json) {
                if(succ){
                    self.gpsAddress = [[GpsAddress alloc] initWithDictionary:json error:NULL];
                }else{
                    self.gpsAddress = nil;
                }
            }];
    });
}


- (BOOL)haveMKGpsTag{
    if(self.mkGpsDate){
        int m = [self.mkGpsDate compareWithDate:[NSDate date]]/1000;
        if (m <= 60) { //1分钟之内算是有效的gps
            return YES;
        }
    }
    return NO;
}

- (NSString *)cityName{
    if(self.haveMKGpsTag
       && self.gpsAddress){
        return [self.gpsAddress.city copy];
    }
    return nil;
}

- (NSString *)regionName{
    if(self.haveMKGpsTag
       && self.gpsAddress){
        return [self.gpsAddress.district copy];
    }
    return nil;
}

- (NSString *)street{
    if(self.haveMKGpsTag
       && self.gpsAddress){
        NSMutableString *str = [NSMutableString stringWithString:self.gpsAddress.street];
        if(self.gpsAddress.street_number){
            [str appendString:self.gpsAddress.street_number];
        }
        return str;
    }
    return nil;
}


@end
