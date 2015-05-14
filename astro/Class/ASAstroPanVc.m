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
#import "ASPostQuestionVc.h"
#import "ASAppDelegate.h"

@interface ASAstroPanVc ()
@property (nonatomic, strong) UIScrollView *scPanView;  //星盘view
@property (nonatomic, strong) UITableView *tbGongInfo;  //宫位信息
@property (nonatomic, strong) UITableView *tbStarInfo;  //星位信息
@property (nonatomic, strong) UIPageControl *page;      //分页控件
@property (nonatomic, strong) UILabel *lbTuiyun;    //退运说明
@property (nonatomic, strong) UILabel *lbP1Info;    //第一当事人
@property (nonatomic, strong) UILabel *lbP2Info;    //第二当事人
@property (nonatomic, strong) UIImageView *pan;     //盘的图片
@property (nonatomic, strong) UILabel *lbMoreTitle;     //更多信息标题
@property (nonatomic, strong) UISegmentedControl *segmentTimeUnit;  //生时调整单位
@property (nonatomic, strong) UIButton *btnQuestion;
@property (nonatomic, strong) NSMutableArray *starsInfo;
@property (nonatomic, strong) NSMutableArray *gongInfo;
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
    
    UIImageView *ivTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"astro_line_top"]];
    ivTop.centerX = self.contentView.width/2;
    ivTop.top = top;
    [self.scPanView addSubview:ivTop];
    
    self.lbMoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    self.lbMoreTitle.center = ivTop.center;
    self.lbMoreTitle.backgroundColor = [UIColor clearColor];
    self.lbMoreTitle.font = [UIFont systemFontOfSize:10];
    self.lbMoreTitle.textAlignment = NSTextAlignmentCenter;
    self.lbMoreTitle.textColor = [UIColor blackColor];
    [self.scPanView addSubview:self.lbMoreTitle];
    
    self.segmentTimeUnit = [[UISegmentedControl alloc] initWithItems:@[@"", @"", @"", @""]];
    self.segmentTimeUnit.size = CGSizeMake(210, 25);
    [self.segmentTimeUnit setTintColor:ASColorDarkRed];
    self.segmentTimeUnit.top = ivTop.bottom + 5;
    self.segmentTimeUnit.centerX = self.contentView.width/2;
    self.segmentTimeUnit.selectedSegmentIndex = 1;
    [self.scPanView addSubview:self.segmentTimeUnit];
    
    UIButton *btnLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnLeft.tag = 1;
    btnLeft.centerY = self.segmentTimeUnit.centerY;
    btnLeft.right = self.segmentTimeUnit.left - 10;
    [btnLeft setBackgroundImage:[UIImage imageNamed:@"btn_around"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(btnClick_birthTimeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.scPanView addSubview:btnLeft];
    
    UIButton *btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    btnRight.tag = 2;
    btnRight.centerY = self.segmentTimeUnit.centerY;
    btnRight.left = self.segmentTimeUnit.right + 15;
    [btnRight setBackgroundImage:[UIImage imageNamed:@"btn_around"] forState:UIControlStateNormal];
    btnRight.transform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI);
    [btnRight addTarget:self action:@selector(btnClick_birthTimeChange:) forControlEvents:UIControlEventTouchUpInside];
    [self.scPanView addSubview:btnRight];
    
    UIImageView *ivBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"astro_line_bottom"]];
    ivBottom.centerX = self.contentView.width/2;
    ivBottom.top = self.segmentTimeUnit.bottom + 15;
    [self.scPanView addSubview:ivBottom];
    top = ivBottom.bottom + 10;
    
    self.btnQuestion = [ASControls newOrangeButton:CGRectMake(0, top, 200, 28) title:@"求解"];
    self.btnQuestion.centerX = self.contentView.width/2;
    [self.btnQuestion addTarget:self action:@selector(btnClick_question:) forControlEvents:UIControlEventTouchUpInside];
    [self.scPanView addSubview:self.btnQuestion];
    
    self.scPanView.contentSize = CGSizeMake(self.scPanView.width, self.btnQuestion.bottom + 20);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnQuestion.hidden = self.hideButton;
    self.contentView.contentSize = CGSizeMake(self.contentView.width * 3, self.contentView.height);
    self.scPanView.height = self.contentView.height;
    self.tbGongInfo.height = self.contentView.height - self.tbGongInfo.top - 10;
    self.tbStarInfo.height = self.tbGongInfo.height;
    
    [self loadData];
}

- (void)loadData{
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
            self.lbTuiyun.size = [tuiText boundingRectWithSize:CGSizeMake(160, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lbTuiyun.font} context:nil].size;
            self.lbTuiyun.top = self.page.top + 3;
            self.lbTuiyun.right = self.contentView.width- 5;
            self.lbP1Info.text = [self textForDayLight:self.astro.IsDayLight quan:[self.astro isZuhepan] ? 1 : 0 gender:self.astro.Gender birth:self.astro.birth lon:self.astro.position.longitude lat:self.astro.position.latitude];
            if(self.astro.type == 2){
                self.lbP2Info.text = [self textForDayLight:self.astro.IsDayLight1 quan:[self.astro isZuhepan] ? 2 : 0 gender:self.astro.Gender1 birth:self.astro.birth1 lon:self.astro.position1.longitude lat:self.astro.position1.latitude];
                self.lbP2Info.hidden = NO;
            }else{
                self.lbP2Info.hidden = YES;
            }
            
            if(self.astro.type == 1){
                self.lbMoreTitle.text = @"生时调整";
                [self.segmentTimeUnit setTitle:@"十天" forSegmentAtIndex:0];
                [self.segmentTimeUnit setTitle:@"一天" forSegmentAtIndex:1];
                [self.segmentTimeUnit setTitle:@"一小时" forSegmentAtIndex:2];
                [self.segmentTimeUnit setTitle:@"一分钟" forSegmentAtIndex:3];
            }else if(self.astro.type == 3){
                self.lbMoreTitle.text = @"退运调整";
                [self.segmentTimeUnit setTitle:@"一年" forSegmentAtIndex:0];
                [self.segmentTimeUnit setTitle:@"一个月" forSegmentAtIndex:1];
                [self.segmentTimeUnit setTitle:@"十天" forSegmentAtIndex:2];
                [self.segmentTimeUnit setTitle:@"一天" forSegmentAtIndex:3];
            }else if(self.astro.type == 4){
                self.lbMoreTitle.text = @"法达星限";
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
    
    if(tableView == self.tbGongInfo){
        lbGong.text = @"宫";
        lbAngle.text = @"所落星座&度数";
        lbStars.text = @"宫内行星";
    }else if(tableView == self.tbStarInfo){
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
            CGFloat height = [item.info boundingRectWithSize:CGSizeMake(90, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil].size.height;
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
                CGFloat height = [lbStars.text boundingRectWithSize:CGSizeMake(lbStars.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: lbStars.font} context:nil].size.height;
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

- (void)btnClick_question:(UIButton *)sender{
    if([ASGlobal isLogined]){
        ASPostQuestionVc *vc = [[ASPostQuestionVc alloc] init];
        vc.topCateId = @"1";
        [vc.question setAstroModel:self.astro];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ASAppDelegate *appDelegate = (ASAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showNeedLoginAlertView];
    }
}

- (void)btnClick_birthTimeChange:(UIButton *)sender{
    if(!self.astro){
        return;
    }
    NSInteger flag = (sender.tag == 1) ? -1 : 1;
    if(self.astro.type == 1){   //本命
        if(self.segmentTimeUnit.selectedSegmentIndex == 0){ //十天
            self.astro.birth = [self.astro.birth dateByAddingTimeInterval:flag * 10 * D_DAY];
        }else if(self.segmentTimeUnit.selectedSegmentIndex == 1){   //一天
            self.astro.birth = [self.astro.birth dateByAddingTimeInterval:flag * D_DAY];
        }else if(self.segmentTimeUnit.selectedSegmentIndex == 2){   //一小时
            self.astro.birth = [self.astro.birth dateByAddingTimeInterval:flag * D_HOUR];
        }else{  //一分钟
            self.astro.birth = [self.astro.birth dateByAddingTimeInterval:flag * D_MINUTE];
        }
    }else if(self.astro.type == 3){
        NSDate *date = self.astro.transitTime;
        if(self.segmentTimeUnit.selectedSegmentIndex == 0){ //一年
            self.astro.transitTime = [NSDate initWithYear:date.year + flag month:date.month day:date.day hour:date.hour minute:date.minute second:date.seconds];
        }else if(self.segmentTimeUnit.selectedSegmentIndex == 1){   //一个月
            self.astro.transitTime = [NSDate initWithYear:date.year month:date.month + flag day:date.day hour:date.hour minute:date.minute second:date.seconds];
        }else if(self.segmentTimeUnit.selectedSegmentIndex == 2){   //十天
            self.astro.transitTime = [self.astro.birth dateByAddingTimeInterval:flag * 10 * D_DAY];
        }else{  //一天
            self.astro.transitTime = [self.astro.birth dateByAddingTimeInterval:flag * D_DAY];
        }
    }
    [self loadData];
}
@end