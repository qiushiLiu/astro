//
//  ASUrlImageView.h
//  astro
//
//  Created by kjubo on 13-12-26.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

typedef NS_ENUM(NSInteger, NSUrlImageViewScaleType) {		/* UIAlertView 的类型 */
    NSUrlImageViewScaleDefalut,             /* 默认 */
    NSUrlImageViewScaleToFitWidth,          /* 满足控件宽度去调整 */
    NSUrlImageViewScaleToFitHeight,         /* 满足控件高度去调整 */
    NSUrlImageViewScaleToFitImageSize,      /* 调整为图片大小 */
};

extern CGFloat const kProgressViewHeight;
extern NSString *const kLoadFaildImageName;

@interface ASUrlImageView : UIView
@property (nonatomic) BOOL showProgress;    //defalut is NO
// YES 根据控件大小去调整内图大小
// NO 根据图片大小去调整控件大小
@property (nonatomic) NSUrlImageViewScaleType scaleType;  //defalut is YES
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *dir;
@property (nonatomic, strong) id userInfo;

- (void)load:(NSString *)url cacheDir:(NSString *)dir;
- (void)load:(NSString *)url cacheDir:(NSString *)dir failImageName:(NSString *)imageName;
- (void)loadLocalImageName:(NSString *)imageName;
@end
