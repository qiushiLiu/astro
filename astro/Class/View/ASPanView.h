//
//  ASPanView.h
//  astro
//
//  Created by kjubo on 14-6-3.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ASPanView : UIView

- (void)setChart:(NSArray *)chartList context:(NSString *)context;
+ (CGFloat)heightForChart:(NSArray *)chart context:(NSString *)context width:(CGFloat)width;
@end
