//
//  ASUSR_SMS.h
//  astro
//
//  Created by kjubo on 14/11/25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "JSONModel.h"

@interface ASUSR_SMS : JSONModel
@property (nonatomic) NSInteger SysNo;
@property (nonatomic, strong) NSString *FromName;
@property (nonatomic) NSInteger FromSysNo;
@property (nonatomic ,strong) NSString *smallFromPhotoShow;
@property (nonatomic, strong) NSString *ToName;
@property (nonatomic) NSInteger ToSysNo;
@property (nonatomic ,strong) NSString *smallToPhotoShow;
@property (nonatomic, strong) NSString *Context;
@property (nonatomic, strong) NSString *Title;
@property (nonatomic, strong) NSDate *TS;
@property (nonatomic) NSInteger IsRead;
@end
