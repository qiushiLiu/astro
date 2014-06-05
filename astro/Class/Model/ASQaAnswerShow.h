//
//  ASQaAnswerShow.h
//  astro
//
//  Created by kjubo on 14-5-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASQaCommentShow.h"
#import "ASQaCustomerBase.h"

@interface ASQaAnswerShow : JSONModel <ASQaAnswerProtocol>
//ASQaCustomerBaseProtocol
@property (nonatomic) NSInteger Award;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) ASUsr_Customer *Customer;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSDate<NSDate> *TS;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSArray<Ignore> *Chart;

//Others
@property (nonatomic) BOOL HasMoreComment;
@property (nonatomic) NSInteger Hate;
@property (nonatomic) NSInteger Love;
@property (nonatomic) NSInteger QuestionSysNo;
@property (nonatomic, strong) NSArray<ASQaCommentShow, Optional> *TopComments;
@end
