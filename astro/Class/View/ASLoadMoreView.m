//
//  ASLoadMoreView.m
//  astro
//
//  Created by kjubo on 14-2-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASLoadMoreView.h"

@interface ASLoadMoreView()
//是否需要刷新
@property (nonatomic) BOOL needRefreshTag;
//动画图片控件
@property (nonatomic, strong) UIImageView *arrow;
//提示标签
@property (nonatomic, strong) UILabel *hint;
//指示器
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@end

@implementation ASLoadMoreView

- (id)initWithScrollView:(ASBaseSingleTableView *)tableView
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        self.tableView = tableView;
        [self.tableView addSubview:self];
        //箭头
        self.arrow = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, 17, 27)];
        self.arrow.centerY = self.height/2;
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
        self.hidden = YES;
        _isLoadingTag = NO;
        
        if(self.tableView){
            [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [self.tableView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
            [self.tableView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
    return self;
}

- (void)free{
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
    [self.tableView removeObserver:self forKeyPath:@"contentSize"];
    [self.tableView removeObserver:self forKeyPath:@"pan.state"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if(object == self.tableView){
        if([keyPath isEqualToString:@"contentOffset"]){
            if (self.isLoadingTag || self.hidden) {
                return;
            }
            float y1 = self.tableView.contentOffset.y + self.tableView.height;
            float y2 = self.tableView.contentSize.height;
            if (self.tableView.isDragging && y1 > y2) {
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
               self.tableView.panGestureRecognizer.state == UIGestureRecognizerStateEnded){
                //刷新布局
                [self willLoading];
            }
        }else if([keyPath isEqualToString:@"contentSize"]){
            self.top = self.tableView.contentSize.height;
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
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, self.height, 0);
        [UIView commitAnimations];
        
        //加载更多
        if([self.tableView.loadMoreDelegate respondsToSelector:@selector(loadMore)]){
            [self.tableView.loadMoreDelegate loadMore];
            [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y + self.height) animated:YES];
        }
        [self stopLoading];
    }
}

- (void)stopLoading{
    self.arrow.hidden = NO;
    self.indicator.hidden = YES;
    _isLoadingTag = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
}

@end
