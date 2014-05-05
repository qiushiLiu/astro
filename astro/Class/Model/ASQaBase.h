//
//  ASQaBase.h
//  astro
//
//  Created by kjubo on 14-4-17.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASQaBase : JSONModel
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger CateSysNo;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic) NSInteger Award;
@property (nonatomic) NSInteger IsSecret;
@property (nonatomic, strong) NSDate<NSDate> *LastReplyTime;
@property (nonatomic) NSInteger LastReplyUser;
@property (nonatomic) NSInteger ReplyCount;
@property (nonatomic) NSInteger ReadCount;
//发帖时间
@property (nonatomic, strong) NSDate<NSDate> *TS;
@property (nonatomic, strong) NSString *CustomerNickName;
//盘
@end
