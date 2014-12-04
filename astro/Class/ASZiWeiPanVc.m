//
//  ASZiWeiPanVc.m
//  astro
//
//  Created by kjubo on 14/12/2.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASZiWeiPanVc.h"
#import "ASZiWeiGrid.h"

@interface ASZiWeiPanVc ()
@property (nonatomic, strong) UIScrollView *scPanView;  //星盘view
@property (nonatomic, strong) UITableView *tbGongInfo;  //宫位信息
@property (nonatomic, strong) UITableView *tbStarInfo;  //星位信息
@property (nonatomic, strong) UIPageControl *page;      //分页控件
@property (nonatomic, strong) UILabel *lbTuiyun;    //退运说明
@property (nonatomic, strong) UILabel *lbP1Info;    //第一当事人
@property (nonatomic, strong) UILabel *lbP2Info;    //第二当事人
@property (nonatomic, strong) UIImageView *pan;     //盘的图片
@property (nonatomic, strong) UIImageView *panCenter;
@property (nonatomic, strong) NSMutableArray *gongs;
@property (nonatomic, strong) ASZiWeiGrid *lastSelected;
@end


@implementation ASZiWeiPanVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"紫薇排盘"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
    self.contentView.pagingEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.delegate = self;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"排盘"];
    [btn addTarget:self action:@selector(btnClick_fillInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.page = [[UIPageControl alloc] init];
    self.page.pageIndicatorTintColor = ASColorDarkGray;
    self.page.currentPageIndicatorTintColor = ASColorDarkRed;
    self.page.numberOfPages = 3;
    self.page.currentPage = 0;
    self.page.centerX = self.contentView.width/2;
    self.page.top = 10;
    self.page.enabled = NO;
    [self.view addSubview:self.page];
    
    self.scPanView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scPanView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.scPanView];
    
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dl_logo"]];
    ivLogo.frame = CGRectMake(5, 5, ivLogo.width/2, ivLogo.height/2);
    [self.scPanView addSubview:ivLogo];
    
    self.lbTuiyun = [self newTextLabel:CGRectZero];
    self.lbTuiyun.font = [UIFont systemFontOfSize:12];
    self.lbTuiyun.textAlignment = NSTextAlignmentRight;
    self.lbTuiyun.numberOfLines = 3;
    self.lbTuiyun.lineBreakMode = NSLineBreakByCharWrapping;
    self.lbTuiyun.right = self.contentView.width - 5;
    [self.contentView addSubview:self.lbTuiyun];
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectMake(0, ivLogo.bottom - 10, 320, 320)];
    [self.scPanView addSubview:self.pan];
    
    self.lbP1Info = [self newTextLabel:CGRectMake(ivLogo.left, 0, 120, 50)];
    self.lbP1Info.textAlignment = NSTextAlignmentLeft;
    self.lbP1Info.numberOfLines = 3;
    self.lbP1Info.bottom = self.pan.bottom + 26;
    [self.scPanView addSubview:self.lbP1Info];
    
    self.lbP2Info = [self newTextLabel:CGRectMake(0, 0, 120, 50)];
    self.lbP2Info.numberOfLines = 3;
    self.lbP2Info.textAlignment = NSTextAlignmentRight;
    self.lbP2Info.right = self.pan.right - 10;
    self.lbP2Info.bottom = self.pan.bottom + 26;
    [self.scPanView addSubview:self.lbP2Info];
    
    CGFloat top = self.lbP1Info.bottom + 10;
    btn = [ASControls newOrangeButton:CGRectMake(0, top, 90, 28) title:@"分享"];
    btn.left = self.lbP1Info.left + 5;
    [btn addTarget:self action:@selector(btnClick_share:) forControlEvents:UIControlEventTouchUpInside];
    [self.scPanView addSubview:btn];
    
    btn = [ASControls newOrangeButton:CGRectMake(0, top, 90, 28) title:@"收藏"];
    btn.centerX = self.scPanView.width/2;
    [btn addTarget:self action:@selector(btnClick_favorite:) forControlEvents:UIControlEventTouchUpInside];
    [self.scPanView addSubview:btn];
    
    btn = [ASControls newOrangeButton:CGRectMake(0, top, 90, 28) title:@"求解"];
    btn.right = self.lbP2Info.right - 5;
    [btn addTarget:self action:@selector(btnClick_question:) forControlEvents:UIControlEventTouchUpInside];
    [self.scPanView addSubview:btn];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width * 3, self.contentView.height);
    self.scPanView.height = self.contentView.height;
    self.tbGongInfo.height = self.contentView.height - self.tbGongInfo.top - 10;
    self.tbStarInfo.height = self.tbGongInfo.height;
    
    [self showWaiting];
    [HttpUtil post:@"input/TimeToZiWei" params:nil body:[self.model toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            NSError *error;
            self.model = [[ZiWeiMod alloc] initWithDictionary:json error:&error];
            NSAssert(error == nil, @"%@", error);
            self.pan = [self.model paipan:NO];
        }else{
            [self alert:message];
        }
    }];
}

#pragma mark - UIScrollView Delegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == self.contentView){
        int page = scrollView.contentOffset.x/scrollView.frame.size.width;
        self.page.currentPage = page;
    }
}

#pragma mark --
- (UILabel *)newTextLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:13];
    return lb;
}

- (void)btnClick_fillInfo{
}

- (void)btnClick_share:(UIButton *)sender{
    
}

- (void)btnClick_favorite:(UIButton *)sender{
    
}

- (void)btnClick_question:(UIButton *)sender{
    
}
@end
