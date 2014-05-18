//
//  ASQaCommentShow.h
//  astro
//
//  Created by kjubo on 14-5-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASUsr_Customer.h"
@protocol ASQaCommentShow
@end

@interface ASQaCommentShow : JSONModel
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASUsr_Customer *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSDate<NSDate> *TS;
@end
