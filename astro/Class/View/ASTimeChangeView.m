//
//  ASTimeChangeView.m
//  astro
//
//  Created by kjubo on 15/5/14.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASTimeChangeView.h"

@interface ASTimeChangeView ()
@property (nonatomic, strong) UISegmentedControl *segmentTimeUnit;  //生时调整单位
@end

@implementation ASTimeChangeView

+ (instancetype)newTimeChangeView{
    return [[self alloc] initWithFrame:CGRectMake(0, 0, DF_WIDTH, 35)];
}

- (id)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.segmentTimeUnit = [[UISegmentedControl alloc] init];
        self.segmentTimeUnit.size = CGSizeMake(210, 25);
        [self.segmentTimeUnit setTintColor:ASColorDarkRed];
        self.segmentTimeUnit.center = CGPointMake(self.width/2, self.height/2);
        [self addSubview:self.segmentTimeUnit];
        
        UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        btnLeft.tag = 1;
        btnLeft.centerY = self.segmentTimeUnit.centerY;
        btnLeft.right = self.segmentTimeUnit.left - 10;
        [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_around"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(btnClick_birthTimeChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnLeft];
        
        UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        btnRight.tag = 2;
        btnRight.centerY = self.segmentTimeUnit.centerY;
        btnRight.left = self.segmentTimeUnit.right + 15;
        [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_around"] forState:UIControlStateNormal];
        btnRight.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
        [btnRight addTarget:self action:@selector(btnClick_birthTimeChange:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnRight];
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    if([items count] == 0) return;
    [self.segmentTimeUnit removeAllSegments];
    [items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self.segmentTimeUnit insertSegmentWithTitle:obj atIndex:idx animated:NO];
    }];
    self.segmentTimeUnit.selectedSegmentIndex = 0;
}

- (NSInteger)selectedIndex{
    return self.segmentTimeUnit.selectedSegmentIndex;
}

- (void)setSelectedIndex:(int)selectedIndex{
    self.segmentTimeUnit.selectedSegmentIndex = selectedIndex;
}

- (void)btnClick_birthTimeChange:(UIButton *)sender{
    NSInteger direction = sender.tag == 1 ? -1 : 1;
    if([self.delegate respondsToSelector:@selector(timeChangView:withDirection:andSelectedIndex:)]){
        [self.delegate timeChangView:self withDirection:direction andSelectedIndex:self.segmentTimeUnit.selectedSegmentIndex];
    }
}

@end
