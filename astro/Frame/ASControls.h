//
//  ASControls.h
//  astro
//
//  Created by kjubo on 14-1-10.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASControls : NSObject

+ (UIButton *)newOrangeButton:(CGRect)frame title:(NSString *)title;
+ (UIButton *)newRedButton:(CGRect)frame title:(NSString *)title;
+ (UIButton *)newDarkRedButton:(CGRect)frame title:(NSString *)title;
+ (UIButton *)newMMButton:(CGRect)frame title:(NSString *)title;
+ (UIButton *)newDropDownButton:(CGRect)frame title:(NSString *)title;

+ (UILabel *)newRedTextLabel:(CGRect)frame;
+ (UILabel *)newGrayTextLabel:(CGRect)frame;

+ (UITextField *)newTextField:(CGRect)frame;
+ (UITextView *)newTextView:(CGRect)frame;
@end
