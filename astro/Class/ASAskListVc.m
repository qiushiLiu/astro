//
//  ASLearnVc.m
//  astro
//
//  Created by kjubo on 14-4-11.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskListVc.h"
#import "ASUserSimpleView.h"
#import "ASAskTableViewCell.h"
#import "ASNav.h"
#import "ASCustomerShow.h"
#import "ASQaMinAstro.h"
#import "ASQaMinBazi.h"
#import "ASQaMinZiWei.h"

@interface ASAskListVc ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *lbHeaderTitle;
@property (nonatomic, strong) UIScrollView *svPage;
@property (nonatomic, strong) ASBaseSingleTableView *tbList;

@property (nonatomic) NSInteger type;
@property (nonatomic, strong) NSString *topCateId;
@property (nonatomic, strong) NSString *cate;
@property (nonatomic, strong) NSString *title;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) BOOL hasMore;

@property (nonatomic, strong) NSMutableArray *userStars;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ASAskListVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //更新通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needsUpdate:) name:Notification_Question_NeedUpdate object:nil];
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"发帖"];
    [btn addTarget:self action:@selector(postNew) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.headerView = [self newHeaderView];
    self.headerView.hidden = YES;
    [self.contentView addSubview:self.headerView];
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.loadMoreDelegate = self;
    [self.contentView addSubview:self.tbList];
    
    self.pageNo = 0;
    self.hasMore = YES;
    self.list = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:self.title];
    self.tbList.height = self.contentView.height;
    
    if(self.pageNo == 0){
        [self showWaiting];
        [HttpUtil load:kUrlGetStarsList params:@{@"catesysno" : self.cate} completion:^(BOOL succ, NSString *message, id json) {
            self.headerView.hidden = !succ;
            if(succ){
                self.userStars = [ASCustomerShow arrayOfModelsFromDictionaries:json];
            }
            [self loadHeader];
            [self loadMore];
        }];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)needsUpdate:(NSNotification *)sender{
    self.pageNo = 0;
    [self loadMore];
}

- (void)postNew{
    if([ASGlobal isLogined]){
        [self navTo:vcPostQuestion
             params:@{@"topCateId" : self.topCateId,
                      @"cate" : self.cate}];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您需要登录后才能发帖！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
        alert.tag = NSAlertViewNeedLogin;
        [alert show];
    }
}

- (void)notification_UserLogined:(NSNotification *)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sender.name object:nil];
    if([ASGlobal isLogined]){
        [self postNew];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == NSAlertViewNeedLogin
       && alertView.cancelButtonIndex != buttonIndex){
        UINavigationController *nc = [[ASNav shared] newNav:vcLogin];
        [self presentViewController:nc animated:YES completion:^{
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification_UserLogined:) name:Notification_LoginUser object:nil];
        }];
    }
}

- (void)loadHeader{
    if(self.headerView.isHidden){
        self.tbList.frame = self.contentView.bounds;
        return;
    }else{
        self.tbList.top = self.headerView.bottom;
        self.tbList.height = self.contentView.height - self.headerView.height;
    }
    
    [self.svPage removeAllSubViews];
    NSInteger pageCount = [self.userStars count]/2;
    if([self.userStars count] % 2 > 0){
        pageCount++;
    }
    self.svPage.contentSize = CGSizeMake(self.svPage.width * pageCount, self.svPage.height);
    CGFloat uvWidth = 150;
    for(NSInteger i = 0; i < [self.userStars count]; i++){
        ASCustomerShow *user = [self.userStars objectAtIndex:i];
        ASUserSimpleView *uv = [[ASUserSimpleView alloc] initWithFrame:CGRectMake(i * uvWidth, 0, uvWidth, self.svPage.height)];
        [uv.face load:user.smallPhotoShow cacheDir:NSStringFromClass([ASCustomerShow class])];
        [uv.lbName setText:user.NickName];
        [uv.lbIntro setText:user.Intro];
        [self.svPage addSubview:uv];
    }
}

- (void)setNavToParams:(NSDictionary *)params{
    self.topCateId = [params objectForKey:@"topCateId"];
    self.cate = [params objectForKey:@"cate"];
    self.type = [[params objectForKey:@"type"] intValue];
    self.title = [params objectForKey:@"title"];
}

- (UIView *)newHeaderView{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 85)];
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

#pragma mark - ASBaseSingleTableViewDelegate Method
- (void)loadMore{
    self.pageNo++;
    [self showWaiting];
    NSString *requestURL = nil;
    if([ASGlobal shared].fateType == 1){
        requestURL = @"qa/GetQuestionListForAstro";
    }else if([ASGlobal shared].fateType == 2){
        requestURL = @"qa/GetQuestionListForZiWei";
    }else{
        requestURL = @"qa/GetQuestionListForBazi";
    }
    
    [HttpUtil load:requestURL params:@{@"cate" : self.cate,
                                       @"pagesize" : @"10",
                                       @"pageindex" : Int2String(self.pageNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self hideWaiting];
                NSArray *arr = nil;
                NSError *error;
                if([ASGlobal shared].fateType == 1){
                    arr = [ASQaMinAstro arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                }else if([ASGlobal shared].fateType == 2){
                    arr = [ASQaMinZiWei arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                }else{
                    arr = [ASQaMinBazi arrayOfModelsFromDictionaries:json[@"list"] error:&error];
                }
                NSAssert(error == nil, @"%@", error);
                [self.list addObjectsFromArray:arr];
                self.tbList.hasMore = [json[@"hasNextPage"] boolValue];
                [self.tbList reloadData];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

#pragma mark - UITableViewHeader
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASAskTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[ASAskTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.panView.userInteractionEnabled = NO;
    }
    id<ASQaProtocol> qa = [self.list objectAtIndex:indexPath.row];
    NSString *nickName = nil;
    if([qa respondsToSelector:@selector(CustomerNickName)]){
        nickName = [qa CustomerNickName];
    }
    [cell setModelValue:qa nickName:nickName];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ASQaProtocol> qa = [self.list objectAtIndex:indexPath.row];
    return [ASAskTableViewCell heightFor:qa width:280];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id<ASQaProtocol> qa = [self.list objectAtIndex:indexPath.row];
    [self navTo:vcAskDeltail params:@{@"title" : self.title,
                                      @"sysno" : Int2String([qa SysNo])}];
}
@end
