//
//  ASQaComment.h
//  astro
//
//  Created by kjubo on 14-6-10.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASCustomer.h"
@protocol ASQaComment
@end

@interface ASQaComment : JSONModel
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASCustomer *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSDate *TS;
@end
