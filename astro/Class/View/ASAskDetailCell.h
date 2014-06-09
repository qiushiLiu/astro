//
//  ASAskDetailCell.h
//  astro
//
//  Created by kjubo on 14-6-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASQaProtocol.h"
#import "ASQaAnswer.h"
@interface ASAskDetailCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

- (void)setQaProtocol:(id<ASQaBaseProtocol>)qa chart:(NSArray *)chart customer:(ASCustomerShow *)user canDel:(BOOL)canDel canComment:(BOOL)canComment;
+ (CGFloat)heightForQaProtocol:(id<ASQaBaseProtocol>)qa chart:(NSArray *)chart;
@end
