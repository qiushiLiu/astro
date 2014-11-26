//
//  ASBaZiPanVc.m
//  astro
//
//  Created by kjubo on 14/11/26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaZiPanVc.h"
#import "BaziMod.h"
#import "Paipan.h"

@interface ASBaZiPanVc ()
@property (nonatomic, strong) UIScrollView *scPanView;  //星盘view
@property (nonatomic, strong) UITableView *tbGongInfo;  //宫位信息
@property (nonatomic, strong) UITableView *tbStarInfo;  //星位信息
@property (nonatomic, strong) UIPageControl *page;      //分页控件
@property (nonatomic, strong) UILabel *lbTuiyun;    //退运说明
@property (nonatomic, strong) UILabel *lbP1Info;    //第一当事人
@property (nonatomic, strong) UILabel *lbP2Info;    //第二当事人
@property (nonatomic, strong) UIImageView *pan;     //盘的图片

@property (nonatomic, strong) BaziMod *model;      //盘数据
@end

@implementation ASBaZiPanVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"八字排盘"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
    self.contentView.pagingEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.delegate = self;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"排盘"];
//    [btn addTarget:self action:@selector(btnClick_fillInfo) forControlEvents:UIControlEventTouchUpInside];
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
    
    self.tbStarInfo = [[UITableView alloc] initWithFrame:CGRectMake(self.contentView.width  + 5, self.page.bottom + 5, self.contentView.width - 10, 0) style:UITableViewStyleGrouped];
    self.tbStarInfo.delegate = self;
    self.tbStarInfo.dataSource = self;
    self.tbStarInfo.separatorColor = [UIColor clearColor];
    self.tbStarInfo.bounces = NO;
    [self.contentView addSubview:self.tbStarInfo];
    
    self.tbGongInfo = [[UITableView alloc] initWithFrame:CGRectMake(self.contentView.width * 2 + 5, self.page.bottom + 5, self.contentView.width - 10, 0) style:UITableViewStyleGrouped];
    self.tbGongInfo.delegate = self;
    self.tbGongInfo.dataSource = self;
    self.tbGongInfo.separatorColor = [UIColor clearColor];
    self.tbGongInfo.bounces = NO;
    [self.contentView addSubview:self.tbGongInfo];
    
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
    [HttpUtil post:@"input/TimeToBazi" params:nil body:[self.model toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            NSError *error;
            self.model = [[BaziMod alloc] initWithDictionary:json error:&error];
            NSAssert(error == nil, @"%@", error);
            self.pan.image = [self.model paipan];
            [self.tbStarInfo reloadData];
            [self.tbGongInfo reloadData];
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

#pragma mark - UITableView Delegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        
    }
    return cell;
}

#pragma mark --
- (UILabel *)newTextLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.textColor = [UIColor blackColor];
    lb.font = [UIFont systemFontOfSize:13];
    return lb;
}

- (void)btnClick_share:(UIButton *)sender{
    
}

- (void)btnClick_favorite:(UIButton *)sender{
    
}

- (void)btnClick_question:(UIButton *)sender{
    
}
@end
