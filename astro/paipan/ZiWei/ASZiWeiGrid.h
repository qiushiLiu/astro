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

@interface ASZiWeiGrid : UIButton
@property (nonatomic, strong)ZiWeiGong *gong;
@property (nonatomic, strong)NSString *gongName;

- (id)initWithGong:(ZiWeiGong *)gong index:(NSInteger)gongIndex;
- (void)addStar:(ZiWeiStar *)star withIndex:(NSInteger)index;
@end
