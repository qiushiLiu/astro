//
//  ZiWeiMod.h
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "DateEntity.h"
#import "ZiWeiStar.h"
#import "ZiWeiGong.h"

#ifndef _ZiWeiMod_H
#define _ZiWeiMod_H

#define ZWColorBlue UIColorFromRGB(0x26ae6)
#define ZWColorRed UIColorFromRGB(0xff1100)
#define ZWColorGreen UIColorFromRGB(0x038516)
#define ZWColorFu UIColorFromRGB(0xfe02d1)
#define ZWColorXiong UIColorFromRGB(0x6700e6)
#define ZWColorXiao UIColorFromRGB(0x9c552d)
#define ZWColorGray UIColorFromRGB(0x646464)

#define __LxCellSize CGSizeMake(80, 140)
#define __CellSize CGSizeMake(80, 110)
#define __LineCount 6
#define __FontSize CGSizeMake(12, 10)
#define __TextFont 10
#endif

@protocol ZiWeiMod
@end

@interface ZiWeiMod : JSONModel
@property (nonatomic, strong) DateEntity *BirthTime;
@property (nonatomic, strong) DateEntity *TransitTime;
@property (nonatomic) NSInteger Type;
@property (nonatomic) NSInteger Gender;
@property (nonatomic) NSInteger ShuXing;
@property (nonatomic) NSInteger Age;
@property (nonatomic) NSInteger Ming;
@property (nonatomic) NSInteger Shen;
@property (nonatomic) NSInteger MingJu;
@property (nonatomic, strong) NSArray<ZiWeiGong> *Gong;
@property (nonatomic, strong) NSArray<ZiWeiStar> *Xing;
@property (nonatomic) NSInteger MingZhu;
@property (nonatomic) NSInteger ShenZhu;
@property (nonatomic) NSInteger RunYue;
@property (nonatomic) NSInteger TmpMonth;
@property (nonatomic) NSInteger TmpLiuMonth;
@property (nonatomic) NSInteger XiaoXian;
@property (nonatomic) NSInteger YueMa;
@property (nonatomic) NSInteger MingShenZhu;
@property (nonatomic) NSInteger ShiShang;
@property (nonatomic) NSInteger HuanYun;
@property (nonatomic) NSInteger LiuNianGong;
@property (nonatomic) NSInteger DaYunGong;
@property (nonatomic) NSInteger LiuYueGong;
@property (nonatomic, strong) NSArray *LiuYao;
@property (nonatomic, strong) NSArray *YunYao;
@property (nonatomic) NSInteger ZiDou;
@property (nonatomic, strong) NSString<Optional> *AreaName;
@property (nonatomic, strong) NSString<Optional> *Longitude;
@property (nonatomic) BOOL RealTime;
@property (nonatomic) BOOL IsDayLight;
- (UIImageView *)paipan;
@end
