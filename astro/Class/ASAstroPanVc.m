//
//  ASBaiPanVc.m
//  astro
//
//  Created by kjubo on 14-3-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAstroPanVc.h"
#import "ASZiWeiGrid.h"
#import "ZiWeiStar.h"
#import "AstroStar.h"
#import "Paipan.h"
#import "ASAstroPanFillInfoVc.h"

@interface ASAstroPanVc ()
@property (nonatomic, strong) UIScrollView *scPanView;  //星盘view
@property (nonatomic, strong) UIScrollView *scInfoView; //信息view
@property (nonatomic, strong) UIPageControl *page;      //分页控件
@property (nonatomic, strong) UILabel *lbTuiyun;    //退运说明
@property (nonatomic, strong) UILabel *lbP1Info;    //第一当事人
@property (nonatomic, strong) UILabel *lbP2Info;    //第二当事人
@property (nonatomic, strong) UIImageView *pan;     //盘的图片

@property (nonatomic, strong) AstroMod *astro;      //盘数据

//@property (nonatomic, strong) UIImageView *panCenter;

//@property (nonatomic, strong) NSMutableArray *gongs;
//@property (nonatomic, strong) ASZiWeiGrid *lastSelected;
@end

@implementation ASAstroPanVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"占星排盘"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
    self.contentView.pagingEnabled = YES;
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.delegate = self;
    
    UIButton *btn = [ASControls newRedButton:CGRectMake(0, 0, 56, 28) title:@"设置"];
    [btn addTarget:self action:@selector(btnClick_fillInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.page = [[UIPageControl alloc] init];
    self.page.pageIndicatorTintColor = ASColorDarkGray;
    self.page.currentPageIndicatorTintColor = ASColorDarkRed;
    self.page.numberOfPages = 2;
    self.page.currentPage = 0;
    self.page.centerX = self.contentView.width/2;
    self.page.top = 10;
    self.page.enabled = NO;
    [self.view addSubview:self.page];
    
    self.scPanView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scPanView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.scPanView];
    
    self.scInfoView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.scInfoView.backgroundColor = [UIColor clearColor];
    self.scInfoView.left = self.scInfoView.width;
    [self.contentView addSubview:self.scInfoView];
    
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_dl_logo"]];
    ivLogo.frame = CGRectMake(5, 5, ivLogo.width/2, ivLogo.height/2);
    [self.scPanView addSubview:ivLogo];
    
    self.lbTuiyun = [self newTextLabel:CGRectMake(0, ivLogo.top, 120, 40)];
    self.lbTuiyun.numberOfLines = 3;
    self.lbTuiyun.right = self.contentView.width - 10;
    [self.contentView addSubview:self.lbTuiyun];
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectMake(0, ivLogo.bottom, 320, 320)];
    [self.scPanView addSubview:self.pan];
    
    self.lbP1Info = [self newTextLabel:CGRectMake(ivLogo.left, 0, 120, 40)];
    self.lbP1Info.numberOfLines = 3;
    self.lbP1Info.bottom = self.pan.bottom + 10;
    [self.scPanView addSubview:self.lbP1Info];
    
    self.lbP2Info = [self newTextLabel:CGRectMake(0, 0, 120, 40)];
    self.lbP2Info.numberOfLines = 3;
    self.lbP2Info.right = self.pan.right;
    self.lbP2Info.bottom = self.pan.bottom + 10;
    [self.scPanView addSubview:self.lbP2Info];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.contentView.contentSize = CGSizeMake(self.contentView.width * 2, self.contentView.height);
    self.scInfoView.height = self.contentView.height;
    self.scPanView.height = self.contentView.height;
    
    [self showWaiting];
    [HttpUtil post:@"input/TimeToAstro" params:nil body:[self.astro toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            self.astro = [[AstroMod alloc] initWithDictionary:json error:NULL];
            self.pan.image = [self.astro paipan];
        }else{
            [self alert:message];
        }
    }];
}

#pragma mark - UIScrollView Delegate Method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.frame.size.width;
    self.page.currentPage = page;
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
    ASAstroPanFillInfoVc *vc = [[ASAstroPanFillInfoVc alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

//- (void)modelLoadFinished:(ASObject *)sender{
//    [super modelLoadFinished:sender];
//    self.pan.image = [self.astro paipan];
//    self.pan.size = self.pan.image.size;

    //紫薇
//    self.panCenter.image = [self.ziwei centerImage:self.lxTag];
//    if(self.lxTag){
//        self.panCenter.origin = CGPointMake(__LxCellSize.width, __LxCellSize.height);
//    }else{
//        self.panCenter.origin = CGPointMake(__CellSize.width, __CellSize.height);
//    }
//    self.panCenter.size = self.panCenter.image.size;
//    [self.contentView bringSubviewToFront:self.panCenter];
//    
//    self.contentView.contentSize = CGSizeMake(self.contentView.width, 560);
//    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
//    
//    for(int i = 0; i < 12; i++){
//        ASZiWeiGrid *gd = [[ASZiWeiGrid alloc] initWithZiWei:self.ziwei index:i lx:self.lxTag];
//        gd.tag = i + 100;
//        [gd addTarget:self action:@selector(gongSelected:) forControlEvents:UIControlEventTouchUpInside];
//        [self.gongs addObject:gd];
//        [self.contentView addSubview:gd];
//    }
//
//    //星旺宫
//    for(int i = 0; i < [self.ziwei.Xing count]; i++){
//        if(i == 58 ||  i == 59 || i == 62 || i == 63 || i == 66 || i == 64 || i == 67){
//            continue;
//        }
//        ZiWeiStar *star = [self.ziwei.Xing objectAtIndex:i];
//        ASZiWeiGrid *gd = [self.gongs objectAtIndex:star.Gong];
//        [gd addStar:star withIndex:i];
//    }
//
//    if(self.lxTag){
//        //流耀
//        for(int i = 0; i < 7; i++){
//            int gong = [[self.ziwei.YunYao objectAtIndex:i] intValue];
//            ASZiWeiGrid *gd = [self.gongs objectAtIndex:gong];
//            [gd addYunYao:i];
//            
//            gong = [[self.ziwei.LiuYao objectAtIndex:i] intValue];
//            gd = [self.gongs objectAtIndex:gong];
//            [gd addLiuYao:i];
//        }
//    }
    
//    [self hideWaiting];
//}

//- (void)gongSelected:(ASZiWeiGrid *)sender{
//    if(self.lastSelected
//       && self.lastSelected !=  sender){
//        [self changeTag:self.lastSelected.tag on:NO];
//    }
//    self.lastSelected = sender;
//    [self changeTag:self.lastSelected.tag on:YES];
//}
//
//- (void)changeTag:(NSInteger)begin on:(BOOL)on{
//    NSInteger i = begin - 100;
//    ASZiWeiGrid *item = (ASZiWeiGrid *)[self.contentView viewWithTag:i + 100];
//    ASZiWeiGrid *item4 = (ASZiWeiGrid *)[self.contentView viewWithTag:(i + 4)%12 + 100];
//    ASZiWeiGrid *item6 = (ASZiWeiGrid *)[self.contentView viewWithTag:(i + 6)%12 + 100];
//    ASZiWeiGrid *item8 = (ASZiWeiGrid *)[self.contentView viewWithTag:(i + 8)%12 + 100];
//    item.selected = item4.selected = item6.selected = item8.selected = on;
//}

@end
