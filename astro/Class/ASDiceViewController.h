//
//  ASDiceViewController.h
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

@interface ASDiceResult : NSObject
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *info;
@property (nonatomic, strong) NSString *result;
@end

@interface ASDiceViewController : ASBaseViewController

@end
