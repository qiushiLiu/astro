//
//  ASUserSimpleView.h
//  astro
//
//  Created by kjubo on 14-4-11.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASUrlImageView.h"
@interface ASUserSimpleView : UIView
@property (nonatomic, strong) ASUrlImageView *face;
@property (nonatomic, strong) UILabel *lbName;
@property (nonatomic, strong) UILabel *lbIntro;
@end
