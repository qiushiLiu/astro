//
//  ASUrlImageView.m
//  astro
//
//  Created by kjubo on 13-12-26.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASUrlImageView.h"
#import "ASCache.h"
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
    if([dir length] == 0){
        dir = NSStringFromClass([self class]);
    }
    [self load:url cacheDir:dir failImageName:kLoadFaildImageName];
}

- (void)load:(NSString *)url cacheDir:(NSString *)dir failImageName:(NSString *)imageName{
    if(_req){
        [_req clearDelegatesAndCancel];
    }
    _dir = [dir trim];
    _url = [url trim];
    BOOL isCached =[[ASCache shared] chkExistImageWithDir:_dir url:_url];
    
    //如果 dir url为空 或者 已经存在文件
    if (isCached) {
        [self loadImage];
    }else{
        [self downLoad];
    }
}

- (void)downLoad{
    _req = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:_url]];
    _req.delegate = self;
    [_req setTimeOutSeconds:15];//超时为15秒
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
    
    if(self.progressView){
        self.progressView.hidden = NO;
        self.progressView.bottom = self.height;
        [_req setDownloadProgressDelegate:self.progressView];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *data = [request responseData];
    [[ASCache shared] storeImageData:data dir:_dir url:_url];
    [self hideLoadAnimating];
    [self loadImage];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    [self hideLoadAnimating];
}

- (void)hideLoadAnimating{
    if(self.activityView){
        [self.activityView stopAnimating];
        self.activityView.hidden = YES;
    }
    if(self.progressView){
        self.progressView.hidden = YES;
    }
}

- (void)loadImage{
    UIImage *img = [[ASCache shared] readImageWithDir:_dir url:_url];
    CGSize imageSize = img.size;
    CGSize targetSize = self.size;
    CGSize scaledSize = CGSizeZero;
    CGFloat scaleFactor = 0.0f;
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        
        if (widthFactor < heightFactor){
            scaleFactor = widthFactor; // scale to fit height
        } else {
            scaleFactor = heightFactor; // scale to fit width
        }
        scaledSize.width  = imageSize.width * scaleFactor;
        scaledSize.height = imageSize.height * scaleFactor;
    }
    
    self.imageView.size = scaledSize;
    self.imageView.image = img;
}


@end
