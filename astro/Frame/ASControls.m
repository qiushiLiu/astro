//
//  ASControls.m
//  astro
//
//  Created by kjubo on 14-1-10.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASControls.h"

@implementation ASControls

+ (UIButton *)newButton:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if([title length] > 0){
        [btn setTitle:title forState:UIControlStateNormal];
        
    }

    return btn;
}

+ (UIButton *)newRedButton:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [self newButton:frame title:title];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_red"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)newDarkRedButton:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [self newButton:frame title:title];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_darkred"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    return btn;
}

+ (UIButton *)newMMButton:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [self newButton:frame title:title];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_mm"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    return btn;
}

+ (UITextField *)newTextField:(CGRect)frame{
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.backgroundColor = [UIColor whiteColor];
    tf.borderStyle = UITextBorderStyleBezel;
    tf.layer.borderColor = [UIColor darkGrayColor].CGColor;
    tf.layer.borderWidth = 1;
    
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont systemFontOfSize:14];
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, tf.height)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return tf;
}

@end
