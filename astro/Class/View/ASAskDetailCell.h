//
//  ASAskDetailCell.h
//  astro
//
//  Created by kjubo on 14-6-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASQaProtocol.h"

@interface ASAskDetailCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>

- (void)setQaCustomerProtocol:(id<ASQaFullProtocol>)qa canDel:(BOOL)canDel canComment:(BOOL)canComment;
+ (CGFloat)heightForModel:(id<ASQaFullProtocol>)qa;
@end
