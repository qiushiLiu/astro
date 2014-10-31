//
//  ASAskerHeaderView.m
//  astro
//
//  Created by kjubo on 14-2-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskerHeaderView.h"
@interface ASAskerHeaderView()
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UIImageView *cursor;
@end

@implementation ASAskerHeaderView

#define ButtonTitles [NSArray arrayWithObjects:@"小白鼠区", @"学习研究", /* @"付费咨询",*/ nil]

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 40)];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.buttons = [[NSMutableArray alloc] init];
        _selected = -1;
        
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 30)];
        bg.image = [[UIImage imageNamed:@"ask_dh_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        [self addSubview:bg];
        
        self.cursor = [[UIImageView alloc] initWithFrame:CGRectMake(bg.left, bg.top, 150, bg.height + 2)];
        [self addSubview:self.cursor];
        
        for(int i = 0; i < 2 ; i++){
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(bg.left + i * self.cursor.width, bg.top, self.cursor.width, bg.height - 2)];
            btn.tag = i;
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
            [btn setTitleColor:ASColorDarkGray forState:UIControlStateNormal];
            [btn setTitleColor:ASColorDarkRed forState:UIControlStateHighlighted];
            [btn setTitle:[ButtonTitles objectAtIndex:i] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [self.buttons addObject:btn];
        }        
    }
    return self;
}

- (void)setSelected:(NSInteger)selected{
    if(selected < 0 || selected >= 3){
        return;
    }
    
    if(_selected == selected){
        return;
    }
    if(_selected >= 0 && _selected <3){
        UIButton *btnLast = [self.buttons objectAtIndex:_selected];
        [btnLast setTitleColor:ASColorDarkGray forState:UIControlStateNormal];
    }
    [self.cursor setImage:[[UIImage imageNamed:[NSString stringWithFormat:@"ask_dh_selected_%@", @(selected)]] stretchableImageWithLeftCapWidth:10 topCapHeight:10]];
    
    UIButton *btnSelected = [self.buttons objectAtIndex:selected];
    [btnSelected setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.cursor.left = 10 + selected * self.cursor.width;
    } completion:^(BOOL finished) {
        _selected = selected;
        
        if([self.delegate respondsToSelector:@selector(askerHeaderSelected:)]){
            [self.delegate askerHeaderSelected:_selected];
        }
        
    }];
    
}

- (void)btnClick:(UIButton *)sender{
    self.selected = sender.tag;
}

@end
