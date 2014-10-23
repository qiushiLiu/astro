//
//  ASQaProtocol.h
//  astro
//
//  Created by kjubo on 14-6-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASCustomerShow.h"

@protocol ASQaProtocol <NSObject>
@required
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger Award;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) NSDate *TS;

@optional
@property (nonatomic) NSInteger ReplyCount;
@property (nonatomic) NSInteger ReadCount;
@property (nonatomic, strong) NSArray *Chart;
@property (nonatomic) BOOL IsEnd;

@optional
@property (nonatomic, strong) NSString *CustomerNickName;

@optional
@property (nonatomic, strong) ASCustomerShow *Customer;
@end



