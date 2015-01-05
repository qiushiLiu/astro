//
//  ASDiceHouseView.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceHouseView.h"
#import "FBGlowLabel.h"

@interface ASDiceHouseView ()
@property (nonatomic, strong) FBGlowLabel *lbIndex;
@end

@implementation ASDiceHouseView

+ (instancetype)houseView:(NSInteger)index{
    return [[self alloc] initWithIndex:index];
}

- (id)initWithIndex:(NSInteger)index{
    if(self = [super initWithFrame:CGRectMake(0, 0, 50, 60)]){
        _gongIndex = index;
        self.backgroundColor = [UIColor clearColor];
        self.lbIndex = [[FBGlowLabel alloc] initWithFrame:CGRectMake(0, self.height * 0.4, self.width, 20)];
        self.lbIndex.textAlignment = NSTextAlignmentCenter;
        self.lbIndex.clipsToBounds = YES;
        self.lbIndex.backgroundColor = [UIColor clearColor];
        self.lbIndex.text = Int2String(_gongIndex);
        self.selected = _gongIndex == 1;
        [self addSubview:self.lbIndex];
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if(_selected){
        self.lbIndex.textColor = [UIColor whiteColor];
        self.lbIndex.innerGlowColor = [UIColor whiteColor];
        self.lbIndex.innerGlowSize = 20;
        self.lbIndex.glowColor = [UIColor redColor];
        self.lbIndex.glowSize = 4;
    }else{
        self.lbIndex.textColor = [UIColor blueColor];
        self.lbIndex.innerGlowColor = [UIColor blueColor];
        self.lbIndex.innerGlowSize = 20;
        self.lbIndex.glowColor = [UIColor clearColor];
        self.lbIndex.glowSize = 0;
    }
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    UIColor *color = _selected ? [UIColor redColor] : [UIColor blueColor];
//    CGContextSetLineWidth(ctx, 1.0);
//    CGContextSetStrokeColorWithColor(ctx, color.CGColor);
//    CGPoint arrPoint[3];
//    arrPoint[0] = CGPointMake(0, 0);
//    arrPoint[1] = CGPointMake(self.width, 0);
//    arrPoint[2] = CGPointMake(self.width * 0.5, self.height);
//    CGContextAddLines(ctx, arrPoint, 3);//添加线
//    CGContextClosePath(ctx);//封起来
//    CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
}

@end
