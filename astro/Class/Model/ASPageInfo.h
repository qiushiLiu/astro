//
//  ASPageInfo.h
//  astro
//
//  Created by kjubo on 14-4-17.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@interface ASPageInfo : JSONModel
@property (nonatomic) NSInteger Total;
@property (nonatomic) BOOL HasNextPage;
@end
