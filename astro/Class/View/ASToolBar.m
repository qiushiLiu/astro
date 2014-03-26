//
//  ASToolBar.m
//  astro
//
//  Created by kjubo on 14-2-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASToolBar.h"

@implementation ASToolBar
static CGFloat kBarItemWidth = 64;
- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor brownColor];
        for (int i = emModuleApp; i <= emModuleSet; i++) {
            CGFloat left = (i - 1) * kBarItemWidth;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(left, 0, kBarItemWidth, self.height)];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_mod_%d", i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_mod_%d_hl", i]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
    }
    return self;
}

- (void)btnClick:(UIButton *)sender{
    if(self.selected == sender.tag){
        return;
    }
    self.selected = (int)sender.tag;
    if([self.delegate respondsToSelector:@selector(toolBarDidChange:)]){
        [self.delegate toolBarDidChange:(emModule)sender.tag];
    }
}

@end
