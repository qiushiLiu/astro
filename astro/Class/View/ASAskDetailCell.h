//
//  ASAskDetailCell.h
//  astro
//
//  Created by kjubo on 14-6-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASQaCustomerBase.h"

@interface ASAskDetailCell : UITableViewCell

- (void)setQaCustomerProtocol:(id<ASQaAnswerProtocol>)qa canDel:(BOOL)canDel;
+ (CGFloat)heightForModel:(id<ASQaAnswerProtocol>)qa;
@end
