//
//  ASPostQuestion.h
//  astro
//
//  Created by kjubo on 14-7-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@interface ASPostQuestion : JSONModel
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger CateSysNo;
@property (nonatomic) NSInteger CustomerSysNo;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic) NSInteger Award;
@property (nonatomic) NSInteger IsSecret;
@end
