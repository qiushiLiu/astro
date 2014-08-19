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

+ (UIButton *)newOrangeButton:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [self newButton:frame title:title];
    [btn setBackgroundImage:[[UIImage imageNamed:@"btn_orange"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
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

+ (UIButton *)newDropDownButton:(CGRect)frame title:(NSString *)title{
    UIButton *btn = [ASControls newOrangeButton:frame title:title];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_arrow_down"]];
    iv.right = btn.width - 10;
    iv.centerY = btn.height/2;
    [btn addSubview:iv];
    return btn;
}

+ (UILabel *)newRedTextLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = ASColorDarkRed;
    return lb;
}

+ (UILabel *)newGrayTextLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:13];
    lb.textColor = [UIColor darkGrayColor];
    lb.numberOfLines = 1;
    lb.lineBreakMode = NSLineBreakByTruncatingTail;
    return lb;
}

+ (UITextField *)newTextField:(CGRect)frame{
    UITextField *tf = [[UITextField alloc] initWithFrame:frame];
    tf.backgroundColor = [UIColor clearColor];
    tf.background = [[UIImage imageNamed:@"input_white_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    tf.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tf.textColor = [UIColor blackColor];
    tf.font = [UIFont systemFontOfSize:14];
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, tf.height)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.clearButtonMode = UITextFieldViewModeAlways;
    tf.autocapitalizationType = UITextAutocapitalizationTypeNone;
    return tf;
}


+ (UITextView *)newTextView:(CGRect)frame{
    UITextView *tv = [[UITextView alloc] initWithFrame:frame];
    tv.backgroundColor = [UIColor clearColor];
    tv.textColor = [UIColor blackColor];
    tv.font = [UIFont systemFontOfSize:14];
    tv.autocapitalizationType = UITextAutocapitalizationTypeNone;
    UIImageView *bg = [[UIImageView alloc] initWithFrame:tv.bounds];
    bg.image = [[UIImage imageNamed:@"input_white_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [tv addSubview:bg];
    [tv sendSubviewToBack:bg];
    return tv;
}


+ (UIView *)titleView:(CGRect)frame title:(NSString *)title{
    UIView *titleView = [[UIView alloc] initWithFrame:frame];
    titleView.backgroundColor = UIColorFromRGB(0xc0a037);
    titleView.layer.cornerRadius = titleView.height/2;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleView.width - 15, titleView.height)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = [UIColor whiteColor];
    lb.text = [title copy];
    [titleView addSubview:lb];
    return titleView;
}


@end
