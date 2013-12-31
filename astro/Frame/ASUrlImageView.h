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

@interface ASUrlImageView : UIView{
    //图片view
    UIImageView *_imageView;
    //转子
    UIActivityIndicatorView *_activityView;
    //进度条
    UIProgressView *_progressView;
    //http请求
    ASIHTTPRequest *_req;
}
- (void)load:(NSString *)url cacheDir:(NSString *)dir;
@end
