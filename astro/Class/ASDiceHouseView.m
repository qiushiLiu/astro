//
//  ASDiceHouseView.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceHouseView.h"
#import "GlowLabel.h"
@interface ASDiceHouseView ()
@property (nonatomic, strong) UIImageView *ivDelta;
@property (nonatomic, strong) GlowLabel *lbIndex;
@end

@implementation ASDiceHouseView

+ (instancetype)houseView:(NSInteger)index{
    return [[self alloc] initWithIndex:index];
}

- (id)initWithIndex:(NSInteger)index{
    
    if(self = [super initWithFrame:CGRectMake(0, 0, 56, 50)]){
        self.ivDelta = [[UIImageView alloc] initWithFrame:self.bounds];
        self.ivDelta.image = [UIImage imageNamed:@"delta_nl"];
        [self addSubview:self.ivDelta];
        
        _gongIndex = index;
        self.backgroundColor = [UIColor clearColor];
        self.lbIndex = [[GlowLabel alloc] initWithFrame:CGRectMake(0, self.height * 0.35, self.width, 20)];
        [self.lbIndex setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
        self.lbIndex.usesHighQualityGlow = YES;
        self.lbIndex.padding = CGSizeMake(4, 4);
        self.lbIndex.threshold = 0.0;
        self.lbIndex.backgroundColor = [UIColor clearColor];
        self.lbIndex.text = Int2String(_gongIndex);
        [self addSubview:self.lbIndex];
        self.selected = _gongIndex == 1;
    }
    return self;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    if(_selected){
        self.lbIndex.textColor = [UIColor whiteColor];
        self.lbIndex.glowColor = UIColorFromRGB(0xF03495);
        self.lbIndex.firstBlurRadius = 0.4;
        self.lbIndex.secondBlurRadius = 0.2;
        self.ivDelta.image = [UIImage imageNamed:@"delta"];
    }else{
        self.lbIndex.textColor = [UIColor whiteColor];
        self.lbIndex.glowColor = UIColorFromRGB(0x034EA0);
        self.lbIndex.firstBlurRadius = 0.2;
        self.lbIndex.secondBlurRadius = 0.2;
        self.ivDelta.image = [UIImage imageNamed:@"delta_nl"];
    }
}

@end
