//
//  ASAskerCell.h
//  astro
//
//  Created by kjubo on 14-2-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASAskerCell : UITableViewCell
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ASUrlImageView *icon;
@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbSummary;
@property (nonatomic, strong) UIImageView *arrow;
@end
