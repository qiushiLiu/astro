//
//  ASReturnValue.h
//  astro
//
//  Created by kjubo on 14-1-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASObject.h"

@interface ASReturnValue : ASObject
@property (nonatomic) NSInteger Code;
@property (nonatomic, strong) NSString *Message;
@property (nonatomic, strong) id Value;
@end
