//
//  ASDiceHouseView.h
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASDiceHouseView : UIView
@property (nonatomic, readonly) NSInteger gongIndex;
@property (nonatomic) BOOL selected;

+ (instancetype)houseView:(NSInteger)index;
@end
