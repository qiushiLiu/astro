//
//  ASAskDetailCellView.h
//  astro
//
//  Created by kjubo on 14-10-15.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASQaProtocol.h"
#import "ASQaAnswer.h"
@interface ASAskDetailCellView : UIView <UITableViewDelegate, UITableViewDataSource>
- (void)setQaProtocol:(id<ASQaProtocol>)qa canDel:(BOOL)canDel canComment:(BOOL)canComment floor:(NSInteger)floor;
+ (CGFloat)heightForQaProtocol:(id<ASQaProtocol>)qa;
@end
