//
//  ASCustomerShow.h
//  astro
//
//  Created by kjubo on 14-6-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASCustomer.h"
#import "ASUSR_MedalMod.h"

@interface ASCustomerShow : JSONModel <ASCustomerProtocol>
@property (nonatomic) NSInteger BestAnswer;
@property (nonatomic, strong) NSString *BigPhotoShow;
@property (nonatomic, strong) NSString *BirthShow;
@property (nonatomic) NSInteger Credit;
@property (nonatomic) NSInteger Exp;
@property (nonatomic) NSInteger FateType;
@property (nonatomic) NSInteger Gender;
@property (nonatomic, strong) NSString *GradeShow;
@property (nonatomic) NSInteger GradeSysNo;
@property (nonatomic) NSInteger HasNewInfo;
@property (nonatomic) NSInteger HomeTown;
@property (nonatomic, strong) NSString *Intro;
@property (nonatomic) NSInteger IsShowBirth;
@property (nonatomic) NSInteger IsStar;
@property (nonatomic, strong) NSString *NickName;
@property (nonatomic) NSInteger Point;
@property (nonatomic) NSInteger Status;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger TotalAnswer;
@property (nonatomic) NSInteger TotalQuest;
@property (nonatomic) NSInteger TotalReply;
@property (nonatomic) NSInteger TotalTalk;
@property (nonatomic) NSInteger TotalTalkReply;
@property (nonatomic, strong) NSString *smallPhotoShow;
@property (nonatomic) NSInteger NewMessage; //消息
@property (nonatomic, strong) NSArray<ASUSR_MedalMod, Optional> *Medals; //勋章
@end
