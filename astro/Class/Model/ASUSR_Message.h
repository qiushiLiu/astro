//
//  ASUSR_Message.h
//  astro
//
//  Created by kjubo on 14/11/25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@protocol ASUSR_Message

@end

@interface ASUSR_Message : JSONModel
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSDate *TS;
@property (nonatomic) NSInteger IsRead;
@end
