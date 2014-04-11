//
//  ASCategory.h
//  astro
//
//  Created by kjubo on 14-4-9.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

@interface ASCategory : JSONModel
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSString *Intro;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) NSString *Pic;
@property (nonatomic) NSInteger QuestNum;
@property (nonatomic) NSInteger Replys;
@property (nonatomic) NSInteger SolvedNum;
@end
