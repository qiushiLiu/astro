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
#import "ASAstroPanFillInfoVc.h"

@interface ASAstroPanVc ()
@property (nonatomic, strong) UIScrollView *scPanView;  //星盘view
@property (nonatomic, strong) UITableView *tbGongInfo;  //宫位信息
@property (nonatomic, strong) UITableView *tbStarInfo;  //星位信息
@property (nonatomic, strong) UIPageControl *page;      //分页控件
@property (nonatomic, strong) UILabel *lbTuiyun;    //退运说明
@property (nonatomic, strong) UILabel *lbP1Info;    //第一当事人
@property (nonatomic, strong) UILabel *lbP2Info;    //第二当事人
@property (nonatomic, strong) UIImageView *pan;     //盘的图片

@property (nonatomic, strong) AstroMod *astro;      //盘数据
@property (nonatomic, strong) NSMutableArray *starsInfo;
@property (nonatomic, strong) NSMutableArray *gongInfo;
//@property (nonatomic, strong) UIImageView *panCenter;

//@property (nonatomic, strong) NSMutableArray *gongs;
//@property (nonatomic, strong) ASZiWeiGrid *lastSelected;
@end

@implementation ASAstroPanVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gongInfo = [NSMutableArray array];
    self.starsInfo = [NSMutableArray array];
    
    [self setTitle:@"占星排盘"];
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
    [HttpUtil post:@"input/TimeToAstro" params:nil body:[self.astro toJSONString] completion:^(BOOL succ, NSString *message, id json) {
        [self hideWaiting];
        if(succ){
            NSError *error;
            self.astro = [[AstroMod alloc] initWithDictionary:json error:&error];
            
            NSAssert(error == nil, @"%@", error);
            
            [self.gongInfo removeAllObjects];
            [self.starsInfo removeAllObjects];
            
            self.gongInfo[0] = [NSMutableArray array];
            self.starsInfo[0] = [NSMutableArray array];
            [self.astro fecthStarsInfo:self.starsInfo[0] gongInfo:self.gongInfo[0] tag:0];
            if([self.astro isZuhepan]){
                self.gongInfo[1] = [NSMutableArray array];
                self.starsInfo[1] = [NSMutableArray array];
                [self.astro fecthStarsInfo:self.starsInfo[1] gongInfo:self.gongInfo[1] tag:1];
            }
            
            self.pan.image = [self.astro paipan];
            NSMutableString *tuiText = [NSMutableString stringWithString:[self.astro panTypeName]];
            if(self.astro.type == 3){
                [tuiText appendString:@"\n推运至\n"];
                [tuiText appendString:[self.astro.transitTime toStrFormat:@"yyyy-MM-dd"]];
            }
            self.lbTuiyun.text = tuiText;
            self.lbTuiyun.size = [tuiText sizeWithFont:self.lbTuiyun.font constrainedToSize:CGSizeMake(160, CGFLOAT_MAX) lineBreakMode:self.lbTuiyun.lineBreakMode];
            self.lbTuiyun.top = self.page.top + 3;
            self.lbTuiyun.right = self.contentView.width- 5;
            self.lbP1Info.text = [self textForDayLight:self.astro.IsDayLight quan:[self.astro isZuhepan] ? 1 : 0 gender:self.astro.Gender birth:self.astro.birth lon:self.astro.position.longitude lat:self.astro.position.latitude];
            if(self.astro.type == 2){
                self.lbP2Info.text = [self textForDayLight:self.astro.IsDayLight1 quan:[self.astro isZuhepan] ? 2 : 0 gender:self.astro.Gender1 birth:self.astro.birth1 lon:self.astro.position1.longitude lat:self.astro.position1.latitude];
                self.lbP2Info.hidden = NO;
            }else{
                self.lbP2Info.hidden = YES;
            }
            [self.tbStarInfo reloadData];
            [self.tbGongInfo reloadData];
        }else{
            [self alert:message];
        }
    }];
}

- (NSString *)textForDayLight:(NSInteger)dayLight quan:(NSInteger)quan gender:(NSInteger)gender birth:(NSDate *)birth lon:(CGFloat)lon lat:(CGFloat)lat{
    NSMutableString *ret = [NSMutableString string];
    if(dayLight){
        [ret appendString:@"夏令时  "];
    }
    if(quan == 1){
        [ret appendString:@"外圈 "];
    }else if(quan == 2){
        [ret appendString:@"内圈 "];
    }
    if(gender == 1){
        [ret appendString:@"男"];
    }else{
        [ret appendString:@"女"];
    }
    [ret appendString:@"\n"];
    
    [ret appendString:[birth toStrFormat:@"yyyy-MM-dd HH:mm"]];
    [ret appendString:@"\n"];
    
    [ret appendFormat:@"%.2f%@ ", fabs(lon), lon > 0? @"E" : @"W"];
    [ret appendFormat:@"%.2f%@ ", fabs(lat), lat > 0? @"N" : @"S"];
    return ret;
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
    return [self.astro isZuhepan] ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.tbStarInfo){
        if([self.starsInfo count] > 0){
            return [self.starsInfo[0] count];
        }else{
            return 0;
        }
    }else{
        return 12;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tbGongInfo.width, 35)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(5, 5, view.width - 10, 30)];
    bg.backgroundColor = section == 0 ? ASColorOrange : ASColorBlue;
    bg.layer.cornerRadius = 6;
    [view addSubview:bg];
    
    UILabel *lbGong = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 20)];
    lbGong.backgroundColor = [UIColor clearColor];
    lbGong.textColor = [UIColor whiteColor];
    lbGong.font = [UIFont boldSystemFontOfSize:14];
    [bg addSubview:lbGong];
    
    UILabel *lbAngle = [[UILabel alloc] initWithFrame:CGRectMake(65, lbGong.top, 130, lbGong.height)];
    lbAngle.textAlignment = NSTextAlignmentCenter;
    lbAngle.backgroundColor = [UIColor clearColor];
    lbAngle.textColor = [UIColor whiteColor];
    lbAngle.font = [UIFont boldSystemFontOfSize:14];
    [bg addSubview:lbAngle];
    
    UILabel *lbStars = [[UILabel alloc] initWithFrame:CGRectMake(lbAngle.right + 5, lbGong.top, 90, lbGong.height)];
    lbStars.textAlignment = NSTextAlignmentCenter;
    lbStars.backgroundColor = [UIColor clearColor];
    lbStars.textColor = [UIColor whiteColor];
    lbStars.font = [UIFont boldSystemFontOfSize:14];
    [bg addSubview:lbStars];
    
    if(tableView == self.tbStarInfo){
        lbGong.text = @"宫";
        lbAngle.text = @"所落星座&度数";
        lbStars.text = @"宫内行星";
    }else if(tableView == self.tbGongInfo){
        lbGong.text = @"行星";
        lbAngle.text = @"所落星座&度数";
        lbStars.text = @"所落宫位";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.tbStarInfo){
        return 30;
    }else{
        if( indexPath.section < [self.gongInfo count]){
            NSArray *arr = self.gongInfo[indexPath.section];
            AstroShowInfo *item = arr[indexPath.row];
            CGFloat height = [item.info sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(90, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping].height;
            return MAX(30, height);
        }
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        
        UILabel *lbGong = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 30)];
        lbGong.tag = 100;
        lbGong.textAlignment = NSTextAlignmentLeft;
        lbGong.backgroundColor = [UIColor clearColor];
        lbGong.textColor = [UIColor blackColor];
        lbGong.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lbGong];
        
        UILabel *lbAngle = [[UILabel alloc] initWithFrame:CGRectMake(lbGong.right + 5, 0, 100, 30)];
        lbAngle.tag = 101;
        lbAngle.textAlignment = NSTextAlignmentLeft;
        lbAngle.backgroundColor = [UIColor clearColor];
        lbAngle.textColor = [UIColor blackColor];
        lbAngle.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:lbAngle];
        
        UILabel *lbStars = [[UILabel alloc] initWithFrame:CGRectMake(lbAngle.right + 5, 0, 110, 30)];
        lbStars.tag = 102;
        lbStars.backgroundColor = [UIColor clearColor];
        lbStars.textColor = [UIColor blackColor];
        lbStars.font = [UIFont systemFontOfSize:14];
        lbStars.numberOfLines = 0;
        lbStars.lineBreakMode = NSLineBreakByCharWrapping;
        [cell.contentView addSubview:lbStars];
    }
    if(self.astro){
        UILabel *lbGong = (UILabel *)[cell.contentView viewWithTag:100];
        UILabel *lbAngle = (UILabel *)[cell.contentView viewWithTag:101];
        UILabel *lbStars = (UILabel *)[cell.contentView viewWithTag:102];
        if(tableView == self.tbStarInfo){
            if( indexPath.section < [self.starsInfo count]){
                NSArray *arr = self.starsInfo[indexPath.section];
                AstroShowInfo *item = arr[indexPath.row];
                lbGong.text = item.name;
                lbAngle.text = item.angle;
                lbStars.text = item.info;
                lbStars.textAlignment = NSTextAlignmentCenter;
            }
        }else if(tableView == self.tbGongInfo){
            if( indexPath.section < [self.gongInfo count]){
                NSArray *arr = self.gongInfo[indexPath.section];
                AstroShowInfo *item = arr[indexPath.row];
                lbGong.text = item.name;
                lbAngle.text = item.angle;
                lbStars.text = item.info;
                lbStars.textAlignment = NSTextAlignmentLeft;
                CGFloat height = [lbStars.text sizeWithFont:lbStars.font constrainedToSize:CGSizeMake(lbStars.width, CGFLOAT_MAX) lineBreakMode:lbStars.lineBreakMode].height;
                lbStars.height = MAX(30, height);
            }
        }
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

- (void)btnClick_fillInfo{
    if(!self.astro){
        return;
    }
    ASAstroPanFillInfoVc *vc = [[ASAstroPanFillInfoVc alloc] init];
    vc.model = self.astro;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_share:(UIButton *)sender{
    
}

- (void)btnClick_favorite:(UIButton *)sender{
    
}

- (void)btnClick_question:(UIButton *)sender{
    
}
@end