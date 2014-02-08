//
//  ASToolBar.m
//  astro
//
//  Created by kjubo on 14-2-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASToolBar.h"

@implementation ASToolBar

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        // Initialization code
        self.backgroundColor = UIColorFromRGB(0xCECABB);
        for (int i = emModuleApp; i <= emModuleSet; i++) {
            CGFloat left = (i - 1)*64;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, left, self.height)];
            btn.tag = i;
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_mod_%d", i]] forState:UIControlStateNormal];
            [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_mod_%d_hl", i]] forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    return self;
}

- (void)btnClick:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(toolBarDidClick:)]){
        [self.delegate toolBarDidClick:sender.tag];
    }
}

@end
