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

@interface ASUrlImageView : UIView{
    //图片view
    UIImageView *_imageView;
    //转子
    UIActivityIndicatorView *_activityView;
    //进度条
    UIProgressView *_progressView;
    //http请求
    ASIHTTPRequest *_req;
    
    //缓存目录和url
    NSString *_url;
    NSString *_dir;
}

- (void)load:(NSString *)url cacheDir:(NSString *)dir;
- (void)load:(NSString *)url cacheDir:(NSString *)dir failImageName:(NSString *)imageName;
@end
