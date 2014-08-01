//
//  ASQuestionButton.h
//  astro
//
//  Created by kjubo on 14-8-1.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASQuestionButton : UIButton
- (id)initWithFrame:(CGRect)frame iconName:(NSString *)iconName preFix:(NSString *)preFix;
- (void)setInfoText:(NSString *)info;
@end
