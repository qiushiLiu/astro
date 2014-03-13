//
//  BaziMod.h
//  astro
//
//  Created by kjubo on 14-3-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASObject.h"
#import "DateEntity.h"

@interface BaziMod : ASObject
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
@property (nonatomic, strong) NSMutableArray *Dayun;
@property (nonatomic) NSDate *JiaoYun;
@property (nonatomic) long QiYunShow;
@property (nonatomic, strong) NSMutableArray *CangGanShow;
@property (nonatomic, strong) NSMutableArray *NaYin;
@property (nonatomic, strong) NSMutableArray *WangShuai;
@property (nonatomic, strong) NSMutableArray *JieQi;
@property (nonatomic, strong) NSMutableArray *JieQiName;
@property (nonatomic) BOOL RealTime;
@property (nonatomic) NSInteger AreaSysNo;
@property (nonatomic, strong) NSString *AreaName;
@property (nonatomic, strong) NSString *Longitude;
@property (nonatomic) long RealTimeSpanShow;

- (UIImage *)paipan;
@end
