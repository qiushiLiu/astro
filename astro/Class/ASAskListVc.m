//
//  ASLearnVc.m
//  astro
//
//  Created by kjubo on 14-4-11.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskListVc.h"
#import "ASBaseSingleTableView.h"
#import "ASUserSimpleView.h"
#import "ASAskTableViewCell.h"

#import "ASUsr_Customer.h"
#import "ASQaMinBazi.h"

@interface ASAskListVc ()
@property (nonatomic, strong) UILabel *lbHeaderTitle;
@property (nonatomic, strong) UIScrollView *svPage;
@property (nonatomic, strong) ASBaseSingleTableView *tbList;

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSString *cate;
@property (nonatomic) int pageNo;

@property (nonatomic, strong) NSMutableArray *userStars;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ASAskListVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"发帖"];
    [btn addTarget:self action:@selector(postNew) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
//    self.tbList.tableHeaderView = [self newHeaderView];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    
    self.pageNo = 1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tbList.height = self.contentView.height;
    [self showWaiting];
    [HttpUtil load:kUrlGetStarsList params:@{@"catesysno" : self.cate} completion:^(BOOL succ, NSString *message, id json) {
        if(succ){
            self.userStars = [ASUsr_Customer arrayOfModelsFromDictionaries:json];
            [self loadHeader];
            [self loadMore];
        }else{
            [self hideWaiting];
            [self alert:message];
        }
    }];
}

- (void)postNew{
    
}

- (void)loadMore{
    [self showWaiting];
    [HttpUtil load:@"qa/GetQuestionListForBaZi" params:@{@"cate" : self.cate,
                                             @"pagesize" : @"15",
                                             @"pageindex" : Int2String(self.pageNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self hideWaiting];
                self.list= [ASQaMinBazi arrayOfModelsFromDictionaries:json[@"list"]];
                [self.tbList reloadData];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

- (void)loadHeader{
    [self.svPage removeAllSubViews];
    NSInteger pageCount = [self.userStars count]/2;
    if([self.userStars count] % 2 > 0){
        pageCount++;
    }
    self.svPage.contentSize = CGSizeMake(self.svPage.width * pageCount, self.svPage.height);
    CGFloat uvWidth = 150;
    for(NSInteger i = 0; i < [self.userStars count]; i++){
        ASUsr_Customer *user = [self.userStars objectAtIndex:i];
        ASUserSimpleView *uv = [[ASUserSimpleView alloc] initWithFrame:CGRectMake(i * uvWidth, 0, uvWidth, self.svPage.height)];
        [uv.face load:user.smallPhotoShow cacheDir:NSStringFromClass([ASUsr_Customer class])];
        [uv.lbName setText:user.NickName];
        [uv.lbIntro setText:user.Intro];
        [self.svPage addSubview:uv];
    }
}

- (void)setNavToParams:(NSDictionary *)params{
    self.cate = @"5";//[params objectForKey:@"cate"];
    self.type = [[params objectForKey:@"type"] intValue];
}

- (UIView *)newHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)];
    view.backgroundColor = [UIColor whiteColor];
    
    self.lbHeaderTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 12)];
    self.lbHeaderTitle.font = [UIFont systemFontOfSize:14];
    self.lbHeaderTitle.backgroundColor = [UIColor clearColor];
    self.lbHeaderTitle.textAlignment = NSTextAlignmentLeft;
    self.lbHeaderTitle.text = @"版主";
    [view addSubview:self.lbHeaderTitle];
    
    self.svPage = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.lbHeaderTitle.bottom + 3, view.width, 50)];
    self.svPage.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    self.svPage.backgroundColor = [UIColor clearColor];
    self.svPage.showsHorizontalScrollIndicator = NO;
    self.svPage.showsVerticalScrollIndicator = NO;
    self.svPage.pagingEnabled = YES;
    [view addSubview:self.svPage];
    return view;
}

#pragma mark - UITableViewHeader
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[ASAskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
    }
    ASQaBase *qa = [self.list objectAtIndex:indexPath.row];
    [cell setModelValue:qa];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASQaBase *qa = [self.list objectAtIndex:indexPath.row];
    return [ASAskTableViewCell heightFor:qa];
}
@end
