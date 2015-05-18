//
//  ASFridariaView.h
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASFridariaView : UIView
@property (nonatomic, readonly) NSInteger section;

- (instancetype)initWithSection:(NSInteger)section;
@end
