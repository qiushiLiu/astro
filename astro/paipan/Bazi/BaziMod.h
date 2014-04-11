//
//  BaziMod.h
//  astro
//
//  Created by kjubo on 14-3-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "DateEntity.h"
#import "BaziDayun.h"
#import "DateEntity.h"

@interface BaziMod : JSONModel
@property (nonatomic, strong) NSString *Name;
@property (nonatomic) NSInteger YearTG;
@property (nonatomic) NSInteger YearDZ;
@property (nonatomic) NSInteger MonthTG;
@property (nonatomic) NSInteger MonthDZ;
@property (nonatomic) NSInteger DayTG;
@property (nonatomic) NSInteger DayDZ;
@property (nonatomic) NSInteger HourTG;
@property (nonatomic) NSInteger HourDZ;
@property (nonatomic, strong)DateEntity *BirthTime;
@property (nonatomic) NSInteger XunKong0;
@property (nonatomic) NSInteger XunKong1;
@property (nonatomic) NSInteger YinYang;
@property (nonatomic) NSInteger Gender;
@property (nonatomic, strong) NSArray<BaziDayun> *Dayun;
@property (nonatomic) NSDate *JiaoYun;
@property (nonatomic) long QiYunShow;
@property (nonatomic, strong) NSMutableArray *CangGanShow;
@property (nonatomic, strong) NSMutableArray<Ignore> *NaYin;
@property (nonatomic, strong) NSMutableArray<Ignore> *WangShuai;
@property (nonatomic, strong) NSArray<NSDate> *JieQi;
@property (nonatomic, strong) NSMutableArray *JieQiName;
@property (nonatomic) BOOL RealTime;
@property (nonatomic) NSInteger AreaSysNo;
@property (nonatomic, strong) NSString *AreaName;
@property (nonatomic, strong) NSString *Longitude;
@property (nonatomic) long RealTimeSpanShow;

- (id)initWithDateEntity:(DateEntity *)entity;
- (NSInteger)getCangGanByX:(NSInteger)x andY:(NSInteger)y;
- (UIImage *)paipan;
@end
