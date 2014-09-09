//
//  GpsData.m
//  app
//
//  Created by kjubo on 14-5-22.
//  Copyright (c) 2014年 吉运软件. All rights reserved.
//

#import "GpsData.h"

@interface GpsData ()
@property (nonatomic) dispatch_queue_t writeQueue; //< Add this
@property (nonatomic, strong) NSDate *mkGpsDate;
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
        const char *lable = [[[NSBundle mainBundle] bundleIdentifier] UTF8String];
        self.writeQueue = dispatch_queue_create(lable, DISPATCH_QUEUE_CONCURRENT);
        self.geocoder = [[CLGeocoder alloc] init];
    }
    return self;
}

//设置苹果经纬度
- (void)setMKGpsLocation:(CLLocation *)loc{
    dispatch_barrier_async(self.writeQueue, ^{
        _loc = [loc copy];
        self.mkGpsDate = [NSDate date];
        
        [self.geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            self.placemark = placemarks[0];
        }];
    });
}


- (BOOL)haveMKGpsTag{
    if(self.mkGpsDate
       && self.placemark){
        int m = [self.mkGpsDate compareWithDate:[NSDate date]]/1000;
        if (m <= 60) { //1分钟之内算是有效的gps
            return YES;
        }
    }
    return NO;
}

@end
