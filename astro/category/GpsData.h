//
//  GpsData.h
//  app
//
//  Created by kjubo on 14-5-22.
//  Copyright (c) 2014年 吉运软件. All rights reserved.
//


@interface GpsData : NSObject
//苹果经纬度
@property (nonatomic, readonly) BOOL haveMKGpsTag;
@property (nonatomic, readonly) double mkLon;
@property (nonatomic, readonly) double mkLat;
//地理位置
@property (nonatomic, readonly) NSString *cityName;
@property (nonatomic, readonly) NSString *regionName;
@property (nonatomic, readonly) NSString *street;

+ (instancetype)shared;
- (void)setMKGpsLocation:(CLLocationCoordinate2D)loc;
@end
