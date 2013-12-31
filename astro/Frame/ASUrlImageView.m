//
//  ASUrlImageView.m
//  astro
//
//  Created by kjubo on 13-12-26.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASUrlImageView.h"

@interface ASUrlImageView()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIProgressView *progressView;
@end

@implementation ASUrlImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)load:(NSString *)url cacheDir:(NSString *)dir{
    if(_req){
        [_req cancel];
    }
    _req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    [_req setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    //ASIHTTPRequest ASIHTTPRequest 有bug 这个不能开启
    [_req setShouldAttemptPersistentConnection:NO];
    //设置代理
    _req.delegate = self;
    
    if(self.progressView){
        self.progressView.hidden = NO;
        self.progressView.bottom = self.height;
        [_req setDownloadProgressDelegate:self.progressView];
    }
    
    //开始异步调用
    [_req startAsynchronous];
}

- (UIImageView *)imageView{
    if(!_imageView){
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor grayColor];
        [self addSubview:_imageView];
    }
    return _imageView;
}

- (UIActivityIndicatorView *)activityView{
    if(!_activityView){
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [self addSubview:_activityView];
    }
    return _activityView;
}

- (UIProgressView *)progressView{
    if(!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.width, kProgressViewHeight)];
        _progressView.progressViewStyle = UIProgressViewStyleDefault;
        [self addSubview:_progressView];
    }
    return _progressView;
}


- (void)requestStarted:(ASIHTTPRequest *)request{
    if(self.activityView){
        [self.activityView startAnimating];
        self.activityView.hidden = NO;
        self.activityView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
        [self bringSubviewToFront:self.activityView];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    self.imageView.image = [UIImage imageWithData:request.responseData];
//    CGSize newSize = self.size;
//    [UIView animateWithDuration:0.1 animations:^{
//        self.imageView.size = newSize;
//    } completion:^(BOOL finished) {
//        self.imageView.center = CGPointMake(self.width/2.0f, self.height/2.0f);
//    }];
    if(self.progressView){
        self.progressView.hidden = NO;
    }
    if(self.activityView){
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    if(self.activityView){
        self.activityView.hidden = YES;
    }
}
@end
