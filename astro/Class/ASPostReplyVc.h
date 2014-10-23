//
//  ASPostReplyVc.h
//  astro
//
//  Created by kjubo on 14-10-15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "ASQaProtocol.h"
@interface ASPostReplyVc : ASBaseViewController<UITextViewDelegate>
@property (nonatomic, assign) id<ASQaProtocol> question;
@end
