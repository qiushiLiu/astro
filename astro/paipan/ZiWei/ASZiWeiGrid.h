//
//  ASZiWeiGrid.h
//  astro
//
//  Created by kjubo on 14-3-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZiWeiStar.h"
#import "ZiWeiGong.h"
#import "ZiWeiMod.h"

@interface ASZiWeiGrid : UIButton
@property (nonatomic, weak)ZiWeiMod *ziwei;
@property (nonatomic, weak)ZiWeiGong *gong;
@property (nonatomic) BOOL lx;
- (id)initWithZiWei:(ZiWeiMod *)mod index:(NSInteger)gongIndex lx:(BOOL)lx;

- (void)addStar:(ZiWeiStar *)star withIndex:(NSInteger)index;
- (void)addYunYao:(int)tag;
- (void)addLiuYao:(int)tag;
@end
