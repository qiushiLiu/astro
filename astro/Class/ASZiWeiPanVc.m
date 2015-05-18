//
//  ASZiWeiPanVc.m
//  astro
//
//  Created by kjubo on 14/12/2.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASZiWeiPanVc.h"
#import "ASZiWeiGrid.h"
#import "ASZiWeiPanFillInfoVc.h"
#import "ASPostQuestionVc.h"
#import "ASAppDelegate.h"
#import "ASTimeChangeView.h"
@interface ASZiWeiPanVc () <ASTimeChangeViewDelegate>
@property (nonatomic, strong) UIImageView *pan;     //盘的图片
@property (nonatomic, strong) UIButton *btnQueston;
@property (nonatomic, strong) UIView *moreView;         //更多信息
@property (nonatomic, strong) UILabel *lbMoreTitle;     //更多信息标题
@property (nonatomic, strong) ASTimeChangeView *timeChangeView;  //生时调整单位
@property (nonatomic, strong) UIImageView *ivBottom;
@end


@implementation ASZiWeiPanVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"紫薇排盘"];
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_paipan"]];
    self.contentView.showsHorizontalScrollIndicator = NO;
    self.contentView.showsVerticalScrollIndicator = NO;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"排盘"];
    [btn addTarget:self action:@selector(btnClick_fillInfo) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.moreView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DF_WIDTH, 1)];
    self.moreView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.moreView];
    
    UIImageView *ivTop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"astro_line_top"]];
    ivTop.centerX = self.contentView.width/2;
    [self.moreView addSubview:ivTop];
    
    self.lbMoreTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    self.lbMoreTitle.center = ivTop.center;
    self.lbMoreTitle.backgroundColor = [UIColor clearColor];
    self.lbMoreTitle.font = [UIFont systemFontOfSize:10];
    self.lbMoreTitle.textAlignment = NSTextAlignmentCenter;
    self.lbMoreTitle.textColor = [UIColor blackColor];
    [self.moreView addSubview:self.lbMoreTitle];
    
    self.timeChangeView = [ASTimeChangeView newTimeChangeView];
    self.timeChangeView.delegate = self;
    self.timeChangeView.top = self.lbMoreTitle.bottom + 5;
    [self.moreView addSubview:self.timeChangeView];
    
    self.ivBottom = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"astro_line_bottom"]];
    self.ivBottom.centerX = self.contentView.width/2;
    self.ivBottom.top = self.timeChangeView.bottom + 15;
    [self.moreView addSubview:self.ivBottom];
    self.moreView.height = self.ivBottom.bottom;
    
    self.lbMoreTitle.text = @"生时调整";
    [self.timeChangeView setItems:@[@"十天", @"一天", @"一小时", @"一分钟"]];
    
    self.btnQueston = [ASControls newOrangeButton:CGRectMake(0, 0, 200, 28) title:@"求解"];
    self.btnQueston.centerX = self.contentView.width/2;
    [self.btnQueston addTarget:self action:@selector(btnClick_question:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnQueston];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnQueston.hidden = self.hideButton;
    [self loadData];
}

- (void)loadData{
    [self showWaiting];
    [HttpUtil post:@"input/TimeToZiWei"
            params:nil
              body:[self.model toJSONString]
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                NSError *error;
                self.model = [[ZiWeiMod alloc] initWithDictionary:json error:&error];
                NSAssert(!error, @"%@", error);
                if(self.pan){
                    [self.pan removeFromSuperview];
                }
                self.pan = [self.model paipan];
                [self.contentView addSubview:self.pan];
                self.moreView.top = self.pan.bottom + 10;
                self.btnQueston.top  = self.moreView.bottom + 10;
                self.contentView.contentSize = CGSizeMake(self.contentView.width, self.btnQueston.bottom + 10);
            }else{
                [self alert:message];
            }
        }];
}

- (void)btnClick_fillInfo{
    if(!self.model){
        return;
    }
    ASZiWeiPanFillInfoVc *vc = [[ASZiWeiPanFillInfoVc alloc] init];
    vc.model = self.model;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_question:(UIButton *)sender{
    if([ASGlobal isLogined]){
        ASPostQuestionVc *vc = [[ASPostQuestionVc alloc] init];
        vc.topCateId = @"1";
        [vc.question setZiWeiModel:self.model];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        ASAppDelegate *appDelegate = (ASAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showNeedLoginAlertView];
    }
}

#pragma mark - TimeChangeView Delegate
- (void)timeChangView:(ASTimeChangeView *)tcView withDirection:(NSInteger)direction andSelectedIndex:(NSInteger)selectedIndex{
    NSInteger flag = direction;
    if(selectedIndex == 0){ //十天
        self.model.BirthTime.Date = [self.model.BirthTime.Date dateByAddingTimeInterval:flag * 10 * D_DAY];
    }else if(selectedIndex == 1){   //一天
        self.model.BirthTime.Date = [self.model.BirthTime.Date dateByAddingTimeInterval:flag * D_DAY];
    }else if(selectedIndex == 2){   //一小时
        self.model.BirthTime.Date = [self.model.BirthTime.Date dateByAddingTimeInterval:flag * D_HOUR];
    }else{  //一分钟
        self.model.BirthTime.Date = [self.model.BirthTime.Date dateByAddingTimeInterval:flag * D_MINUTE];
    }
    [self loadData];
}



@end
