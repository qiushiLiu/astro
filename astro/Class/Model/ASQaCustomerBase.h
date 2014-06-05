//
//  ASQaCustomerBase.h
//  astro
//
//  Created by kjubo on 14-6-3.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASUsr_Customer.h"

@protocol ASQaAnswerProtocol <NSObject>

@required
@property (nonatomic) NSInteger Award;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASUsr_Customer *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSDate<NSDate> *TS;
@property (nonatomic, strong) NSString *Title;

@property (nonatomic, strong) NSArray *Chart;
@end

@protocol ASQaCustomerBaseProtocol <ASQaAnswerProtocol>

@required
@property (nonatomic) NSInteger CateSysNo;
@property (nonatomic) BOOL IsEnd;
@property (nonatomic) BOOL IsSecret;
@property (nonatomic, strong) NSDate<NSDate> *LastReplyTime;
@property (nonatomic) NSInteger LastReplyUser;
@property (nonatomic) NSInteger ReadCount;
@property (nonatomic) NSInteger ReplyCount;

@end


@interface ASQaCustomerBase : JSONModel <ASQaCustomerBaseProtocol>
@property (nonatomic) NSInteger Award;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASUsr_Customer *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSDate<NSDate> *TS;
@property (nonatomic, strong) NSString *Title;

@property (nonatomic) NSInteger CateSysNo;
@property (nonatomic) BOOL IsEnd;
@property (nonatomic) BOOL IsSecret;
@property (nonatomic, strong) NSDate<NSDate> *LastReplyTime;
@property (nonatomic) NSInteger LastReplyUser;
@property (nonatomic) NSInteger ReadCount;
@property (nonatomic) NSInteger ReplyCount;

@property (nonatomic, strong) NSArray *Chart;
@end
