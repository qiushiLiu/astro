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

@protocol ASAskDetailCellViewDelegate <NSObject>
- (void)detailCellClickComment:(ASQaAnswer *)answer;
- (void)detailCellClickDelete:(ASQaAnswer *)answer;
- (void)detailCellClickFace:(NSInteger)uid;
@end

@interface ASAskDetailCellView : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<ASAskDetailCellViewDelegate> delegate;

- (void)setQaProtocol:(id<ASQaProtocol>)qa canDel:(BOOL)canDel canComment:(BOOL)canComment floor:(NSInteger)floor;
+ (CGFloat)heightForQaProtocol:(id<ASQaProtocol>)qa canDelOrComment:(BOOL)can;
@end
