//
//  ASQaAnswer.h
//  astro
//
//  Created by kjubo on 14-6-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASQaProtocol.h"
#import "ASQaComment.h"

@interface ASQaAnswer : JSONModel <ASQaProtocol>
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger Award;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASCustomerShow *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic, strong) NSDate *TS;
//Others
@property (nonatomic) BOOL HasMoreComment;
@property (nonatomic) NSInteger Hate;
@property (nonatomic) NSInteger Love;
@property (nonatomic) NSInteger QuestionSysNo;
@property (nonatomic, strong) NSMutableArray<ASQaComment, Optional> *TopComments;
@property (nonatomic) NSInteger ToalComment;
@end
