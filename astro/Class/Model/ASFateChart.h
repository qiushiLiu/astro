//
//  ASFateChart.h
//  astro
//
//  Created by kjubo on 14-7-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
@interface ASFateChart : JSONModel
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSDate *FirstBirth;
@property (nonatomic, strong) NSString *FirstPoi;   // 经度|纬度
@property (nonatomic, strong) NSString *FirstPoiName;
@property (nonatomic) NSInteger FirstDayLight;
@property (nonatomic) NSInteger FirstTimeZone;
@property (nonatomic) NSInteger FirstGender;

@property (nonatomic, strong) NSDate *SecondBirth;
@property (nonatomic, strong) NSString *SecondPoi;
@property (nonatomic, strong) NSString *SecondPoiName;
@property (nonatomic) NSInteger SecondDayLight;
@property (nonatomic) NSInteger SecondTimeZone;
@property (nonatomic) NSInteger SecondGender;

@property (nonatomic) NSInteger ChartType;
@end
