//
//  ASQaMinAstro.h
//  astro
//
//  Created by kjubo on 14/10/23.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASQaProtocol.h"
#import "AstroMod.h"
@protocol ASQaMinAstro
@end

@interface ASQaMinAstro : JSONModel<ASQaProtocol>
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger Award;
@property (nonatomic) NSInteger CateSysNo;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic, strong) NSString *CustomerNickName;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic) NSInteger IsSecret;
@property (nonatomic, strong) NSDate *LastReplyTime;
@property (nonatomic) NSInteger LastReplyUser;
@property (nonatomic) NSInteger ReplyCount;
@property (nonatomic) NSInteger ReadCount;
@property (nonatomic, strong) NSDate *TS;
@property (nonatomic, strong) NSArray<AstroMod> *Chart;
@end
