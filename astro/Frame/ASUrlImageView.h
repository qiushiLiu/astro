//
//  ASUrlImageView.h
//  astro
//
//  Created by kjubo on 13-12-26.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

extern CGFloat const kProgressViewHeight;
extern NSString *const kLoadFaildImageName;

@interface ASUrlImageView : UIView
@property (nonatomic) BOOL showProgress;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *dir;
- (void)loadLocalImage:(NSString *)imageName;
- (void)load:(NSString *)url cacheDir:(NSString *)dir;
- (void)load:(NSString *)url cacheDir:(NSString *)dir failImageName:(NSString *)imageName;
@end
