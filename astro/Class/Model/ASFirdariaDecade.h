//
//  ASFirdariaDecade.h
//  astro
//
//  Created by kjubo on 15/5/18.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"
#import "ASFirdaria.h"

@protocol ASFirdariaDecade
@end

@interface ASFirdariaDecade : JSONModel
@property (nonatomic, strong) ASFirdaria *FirdariaLong;
@property (nonatomic, strong) NSArray<ASFirdaria> *FirdariaShort;
@end
