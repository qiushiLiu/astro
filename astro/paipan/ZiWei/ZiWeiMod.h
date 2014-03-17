//
//  ZiWeiMod.h
//  astro
//
//  Created by kjubo on 14-3-13.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASObject.h"
#import "DateEntity.h"
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

- (UIImage *)paipan;
@end
