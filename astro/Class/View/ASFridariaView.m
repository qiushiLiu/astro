//
//  ASFridariaView.m
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASFridariaView.h"

#define FridariaColorsRed       @[UIColorFromRGB(0xff3c00), UIColorFromRGB(0xf9ceaf), UIColorFromRGB(0xf3f2ed)]
#define FridariaColorsBlue      @[UIColorFromRGB(0x0086cf), UIColorFromRGB(0xb8e0e1), UIColorFromRGB(0xf3f2ed)]
#define FridariaColorsYellow    @[UIColorFromRGB(0xf4a12d), UIColorFromRGB(0xfff9b3), UIColorFromRGB(0xf3f2ed)]
#define FridariaColorsGreen     @[UIColorFromRGB(0x97c730), UIColorFromRGB(0xe2f1b7), UIColorFromRGB(0xf3f2ed)]
#define FridariaColorsCyan      @[UIColorFromRGB(0x006479), UIColorFromRGB(0xb5d9cd), UIColorFromRGB(0xf3f2ed)]
#define FridariaBrown           UIColorFromRGB(0xd7d3c7)
#define FridariaRed             UIColorFromRGB(0xf9ceaf)

#define Array_Fridaria_Colors @[FridariaColorsRed,\
                    FridariaColorsBlue,\
                    FridariaColorsYellow,\
                    FridariaColorsGreen,\
                    FridariaColorsRed,\
                    FridariaColorsRed,\
                    FridariaColorsYellow,\
                    FridariaColorsCyan,\
                    FridariaColorsCyan]

@interface ASFridariaView()
@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UILabel *lbTitle;
@end

@implementation ASFridariaView

- (instancetype)initWithSection:(NSInteger)section{
    if(self = [super initWithFrame:CGRectMake(0, 0, DF_WIDTH, 48)]){
        _section = section;
        NSAssert(section < [Array_Fridaria_Colors count] && section >= 0, @"Fridaria Section out of limit");
        
        NSArray *colors = Array_Fridaria_Colors[_section];
        
        UIView *leftTopView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, 10, self.height/2)];
        leftTopView.backgroundColor = colors[0];
        [self addSubview:leftTopView];
        
        UIView *rightTopView = [[UIView alloc] initWithFrame:CGRectMake(leftTopView.right, leftTopView.top, DF_WIDTH - 5 - leftTopView.right, leftTopView.height)];
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = rightTopView.bounds;
        gradient.startPoint = CGPointMake(0, 0);
        gradient.endPoint = CGPointMake(1, 0);
        gradient.colors = @[(id)[colors[1] CGColor], (id)[colors[2] CGColor]];
        [rightTopView.layer insertSublayer:gradient atIndex:0];
        [self addSubview:rightTopView];
        
        self.lbTitle = [[UILabel alloc] initWithFrame:rightTopView.frame];
        self.lbTitle.left = rightTopView.left + 10;
        self.lbTitle.backgroundColor = [UIColor clearColor];
        self.lbTitle.font = [UIFont systemFontOfSize:10];
        self.lbTitle.textColor = FridariaBrown;
        [self addSubview:self.lbTitle];
        
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(leftTopView.left, leftTopView.bottom, DF_WIDTH - 10, self.height/2)];
        bottomView.backgroundColor = ASColorDarkGray;
        [self addSubview:bottomView];
        
        CGFloat left = bottomView.left + 1.5;
        CGFloat top = bottomView.top + 1;
        for(int i = 1; i <= 7; i++){
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left, top, 43, 22)];
            btn.tag = i;
            btn.titleLabel.font = [UIFont systemFontOfSize:12];
            btn.backgroundColor = FridariaBrown;
            [btn setTitle:@"金" forState:UIControlStateNormal];
            [btn setTitleColor:ASColorDarkGray forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick_cell:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            left = btn.right + 1;
        }
    }
    return self;
}

- (void)btnClick_cell:(UIButton *)sender{
    
}

@end
