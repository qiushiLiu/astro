//
//  BaziDayun.h
//  astro
//
//  Created by kjubo on 14-3-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaziDayun
@end

@interface BaziDayun : JSONModel
@property (nonatomic) NSInteger YearTG;
@property (nonatomic) NSInteger YearDZ;
@property (nonatomic) NSInteger ShiShen;
@property (nonatomic) NSInteger Begin;
@property (nonatomic) NSInteger End;
@property (nonatomic) NSInteger WangShuai;
@property (nonatomic) NSInteger NaYin;
@end
