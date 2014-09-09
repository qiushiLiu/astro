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
@property (nonatomic, readonly) CLLocation *loc;
//地理位置
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, strong) CLGeocoder *geocoder;
+ (instancetype)shared;
- (void)setMKGpsLocation:(CLLocation *)loc;
@end
