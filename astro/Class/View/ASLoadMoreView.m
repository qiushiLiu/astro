//
//  ASLoadMoreView.m
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASLoadMoreView.h"

@interface ASLoadMoreView()
//动画图片控件
@property (nonatomic, strong) UIImageView *arrow;
//提示标签
@property (nonatomic, strong) UILabel *hint;
//指示器
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
//是否需要刷新
@property (nonatomic) BOOL needRefreshTag;
@end

@implementation ASLoadMoreView

- (id)initWithScrollView:(UIScrollView *)scrollView
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 50)];
    if (self) {
        self.scrollView = scrollView;
        [self.scrollView addSubview:self];
        //箭头
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(50, 5, 20, 40)];
        self.arrow.image = [UIImage imageNamed:@"loadmore_arrow.png"];
        [self addSubview:self.arrow];
        //加载指示器
        self.indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(50, 0, 24, 24)];
        self.indicator.hidden = YES;
        self.indicator.centerY = self.height/2;
        [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        [self.indicator stopAnimating];
        [self addSubview:self.indicator];
        //提示
        self.hint = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 18)];
        self.hint.centerY = self.height/2;
        self.hint.backgroundColor = [UIColor clearColor];
        self.hint.textColor = [UIColor darkGrayColor];
        self.hint.textAlignment = NSTextAlignmentCenter;
        self.hint.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.hint];
        
        self.needRefreshTag = NO;
        _isLoadingTag = NO;
        
        if(self.scrollView){
            [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [self.scrollView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if(object == self.scrollView){
        if([keyPath isEqualToString:@"contentOffset"]){
            if (self.isLoadingTag || self.hidden) {
                return;
            }
            float y1 = self.scrollView.contentOffset.y + self.scrollView.height;
            float y2 = self.scrollView.contentSize.height;
            if (self.scrollView.isDragging && y1 > y2) {
                self.needRefreshTag = y1 > (y2 + self.height);
                [UIView animateWithDuration:0.2 animations:^{
                    if (self.needRefreshTag) {
                        //是否需要刷新
                        self.hint.text = @"松开载入更多";
                        self.arrow.transform = CGAffineTransformMakeRotation(-M_PI);
                    } else {
                        //是否需要刷新
                        self.hint.text = @"上拉加载更多";
                        self.arrow.transform = CGAffineTransformIdentity;
                    }
                }];
            }
        }
        else if([keyPath isEqualToString:@"pan.state"]){
            if(self.needRefreshTag &&
               self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded){
                //刷新布局
                [self willLoading];
                //加载更多
            }
        }else if([keyPath isEqualToString:@"contentSize"]){
            self.top = self.scrollView.contentSize.height;
        }
    }
}

- (void)willLoading{
    if(self.needRefreshTag){
        //是否需要刷新
        self.needRefreshTag = NO;
        //是否正在读取
        _isLoadingTag = YES;
        self.hint.text = @"加载中..";
        //隐藏图标
        self.arrow.hidden = YES;
        //启动转子
        [self.indicator startAnimating];
        
        //设置scrollview的偏移
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, self.height, 0);
        [UIView commitAnimations];
    }
}

- (void)stopLoading{
    self.arrow.hidden = NO;
    self.indicator.hidden = YES;
}

@end
