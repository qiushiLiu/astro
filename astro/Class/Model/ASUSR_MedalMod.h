//
//  ASUSR_MedalMod.h
//  astro
//
//  Created by kjubo on 15/1/2.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@protocol ASUSR_MedalMod
@end

@interface ASUSR_MedalMod : JSONModel
@property (nonatomic, strong) NSString *MedalName;
@property (nonatomic, strong) NSString *Pic;
@property (nonatomic) NSInteger SysNo;
@property (nonatomic) NSInteger Type;
@end
