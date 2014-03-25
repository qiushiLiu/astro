//
//  ZiWeiMod.h
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASObject.h"
#import "DateEntity.h"

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
#define __FontSize 10
#define __TextFont 9
#endif

@interface ZiWeiMod : ASObject
@property (nonatomic, strong) DateEntity *BirthTime;
@property (nonatomic, strong) DateEntity *TransitTime;
@property (nonatomic) NSInteger Gender;
@property (nonatomic) NSInteger ShuXing;
@property (nonatomic) NSInteger Age;
@property (nonatomic) NSInteger Ming;
@property (nonatomic) NSInteger Shen;
@property (nonatomic) NSInteger MingJu;
@property (nonatomic, strong) NSMutableArray *Gong;
@property (nonatomic, strong) NSMutableArray *Xing;
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
@property (nonatomic, strong) NSMutableArray *LiuYao;
@property (nonatomic, strong) NSMutableArray *YunYao;
@property (nonatomic) NSInteger ZiDou;

- (UIImage *)centerImage:(BOOL)lxTag;
@end
