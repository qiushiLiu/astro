//
//  ASQaFullAstro.h
//  astro
//
//  Created by kjubo on 14/10/31.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASQaProtocol.h"
#import "AstroMod.h"

@interface ASQaFullAstro : JSONModel <ASQaProtocol>
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger Award;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASCustomerShow *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic, strong) NSDate<NSDate> *TS;
@property (nonatomic) NSInteger CateSysNo;
@property (nonatomic) BOOL IsEnd;
@property (nonatomic) BOOL IsSecret;
@property (nonatomic, strong) NSDate<NSDate> *LastReplyTime;
@property (nonatomic) NSInteger LastReplyUser;
@property (nonatomic) NSInteger ReadCount;
@property (nonatomic) NSInteger ReplyCount;

@property (nonatomic, strong) NSArray<AstroMod> *Chart;
@end
