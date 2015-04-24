//
//  ASAskDetailVc.m
//  astro
//
//  Created by kjubo on 14-5-16.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAskDetailVc.h"
#import "ASAskDetailHeaderView.h"
#import "ASQaFullBazi.h"
#import "ASQaFullZiWei.h"
#import "ASQaFullAstro.h"
#import "ASQaAnswer.h"
#import "ASPostReplyVc.h"
#import "ASNav.h"
#import "ASUserCenterVc.h"
#import "ASAstroPanVc.h"
#import "ASZiWeiPanVc.h"
#import "ASBaZiPanVc.h"
#import "ASAppDelegate.h"

@interface ASAskDetailVc ()
@property (nonatomic) NSInteger sysNo;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic) BOOL hasMore;
@property (nonatomic, strong) id<ASQaProtocol> question;
@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, strong) ASBaseSingleTableView *tbList;
@property (nonatomic, strong) ASAskDetailHeaderView *headerView;
@property (nonatomic, weak) ASQaAnswer *selectedAnswer;
@end

@implementation ASAskDetailVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"回复"];
    [btn addTarget:self action:@selector(reply) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.headerView = [[ASAskDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 0)];
    
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor whiteColor];
    self.tbList.separatorColor = [UIColor clearColor];
    if ([self.tbList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tbList setSeparatorInset:UIEdgeInsetsZero];
    }
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.loadMoreDelegate = self;
    [self.contentView addSubview:self.tbList];
    
    self.pageNo = 0;
    self.hasMore = YES;
    self.list = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadQaData) name:Notification_Reply_NeedUpdate object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tbList.height = self.contentView.height;
    if(!self.question){
        [self loadQaData];
    }
}

- (void)setNavToParams:(NSDictionary *)params{
    self.title = [params objectForKey:@"title"];
    self.sysNo = [[params objectForKey:@"sysno"] intValue];
}

- (void)loadQaData{
    [self showWaiting];
    
    NSString *requestURL = nil;
    if([ASGlobal shared].fateType == 1){
        requestURL = @"qa/GetQuestionForAstro";
    }else if([ASGlobal shared].fateType == 2){
        requestURL = @"qa/GetQuestionForZiWei";
    }else{
        requestURL = @"qa/GetQuestionForBaZi";
    }
    
    [HttpUtil load:requestURL params:@{@"sysno" : Int2String(self.sysNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                NSError *error;
                if([ASGlobal shared].fateType == 1){
                    self.question = [[ASQaFullAstro alloc] initWithDictionary:json error:&error];
                }else if([ASGlobal shared].fateType == 2){
                    self.question = [[ASQaFullZiWei alloc] initWithDictionary:json error:&error];
                }else{
                    self.question = [[ASQaFullBazi alloc] initWithDictionary:json error:&error];
                }
                NSAssert(error == nil, @"%@", error);
                [self.headerView setQuestion:self.question];
                self.tbList.tableHeaderView = self.headerView;
                self.pageNo = 0;
                [self loadMore];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}

- (void)loadMore{
    self.pageNo++;
    [self showWaiting];
    [HttpUtil load:@"qa/GetAnswerByQuest" params:@{@"sysno" : Int2String(self.sysNo),
                                                   @"pagesize" : @"10",
                                                   @"pageindex" : Int2String(self.pageNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            if(succ){
                [self.list addObjectsFromArray:[ASQaAnswer arrayOfModelsFromDictionaries:json[@"list"]]];
                self.tbList.hasMore = [json[@"hasNextPage"] boolValue];
                [self.tbList reloadData];
                [self hideWaiting];
            }else{
                [self hideWaiting];
                [self alert:message];
            }
        }];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == NSAlertViewConfirm){
        if(alertView.cancelButtonIndex != buttonIndex){
            [self showWaiting];
            [HttpUtil load:@"qa/RemoveAnswer"
                    params:@{@"AnswerSysNo" : Int2String(self.selectedAnswer.SysNo)}
                completion:^(BOOL succ, NSString *message, id json) {
                    [self hideWaiting];
                    if(succ){
                        [self.list removeObject:self.selectedAnswer];
                        [self.tbList reloadData];
                    }else{
                        [self alert:message];
                    }
            }];
        }
    }
}

- (void)notification_UserLogined:(NSNotification *)sender{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:sender.name object:nil];
    if([ASGlobal isLogined]){
        [self reply];
    }
}

#pragma mark - UITableViewDelegate & DataSouce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if(self.question){
        count++;
    }
    return [self.list count] + count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 1)];
        vline.tag = 100;
        vline.backgroundColor = [UIColor lightGrayColor];
        [cell.contentView addSubview:vline];
        
        ASAskDetailCellView *cv = [[ASAskDetailCellView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 1)];
        cv.delegate = self;
        cv.tag = 200;
        [cell.contentView addSubview:cv];
    }
    UIView *vline = [cell.contentView viewWithTag:100];
    ASAskDetailCellView *cv = (ASAskDetailCellView *)[cell.contentView viewWithTag:200];
    BOOL canDel = NO;
    if(indexPath.row == 0){
        if([self.question Customer].SysNo == [[[ASGlobal shared] user] SysNo]){
            canDel = YES;
        }
        [cv setQaProtocol:self.question canDel:canDel canComment:NO floor:1];
    }else{
        ASQaAnswer *answer = [self.list objectAtIndex:indexPath.row - 1];
        if(answer.CustomerSysNo == [[[ASGlobal shared] user] SysNo]){
            canDel = YES;
        }
        [cv setQaProtocol:answer canDel:canDel canComment:YES floor:indexPath.row + 1];
    }
    vline.bottom = cv.bottom + 1;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 0){
        return [ASAskDetailCellView heightForQaProtocol:self.question canDelOrComment:NO] + 40;
    }else{
        ASQaAnswer *answer = [self.list objectAtIndex:indexPath.row - 1];
        return [ASAskDetailCellView heightForQaProtocol:answer canDelOrComment:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row > 0){
        ASQaAnswer *answer = [self.list objectAtIndex:indexPath.row - 1];
        [self navToCommentVc:answer becomeEdit:NO];
    }
}

#pragma mark - ASAskDetailCellViewDelegate
- (void)detailCellClickFace:(NSInteger)uid{
    ASUserCenterVc *vc = [[ASUserCenterVc alloc] init];
    vc.uid = uid;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)detailCellClickComment:(ASQaAnswer *)answer{
    [self navToCommentVc:answer becomeEdit:YES];
}

- (void)detailCellClickDelete:(ASQaAnswer *)answer{
    self.selectedAnswer = answer;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"是否要删除您的回复" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = NSAlertViewConfirm;
    [alert show];
}

- (void)detailCellClickPan:(id)pan{
    if([pan isKindOfClass:[AstroMod class]]){
        ASAstroPanVc *vc = [[ASAstroPanVc alloc] init];
        vc.astro = [[AstroMod alloc] initWithString:[pan toJSONString] error:nil];
        vc.hideButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([pan isKindOfClass:[BaziMod class]]){
        ASBaZiPanVc *vc = [[ASBaZiPanVc alloc] init];
        vc.model = [[BaziMod alloc] initWithString:[pan toJSONString] error:nil];
        vc.hideButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if([pan isKindOfClass:[ZiWeiMod class]]){
        ASZiWeiPanVc *vc = [[ASZiWeiPanVc alloc] init];
        vc.model = [[ZiWeiMod alloc] initWithString:[pan toJSONString] error:nil];
        vc.hideButton = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -
- (void)navToCommentVc:(ASQaAnswer *)answer becomeEdit:(BOOL)become{
    NSString *jsonStr = [answer toJSONString];
    ASQaAnswer *newAs = [[ASQaAnswer alloc] initWithString:jsonStr error:nil];
    [newAs.TopComments removeAllObjects];
    newAs.HasMoreComment = NO;
    [self navTo:vcComment params:@{@"answer" : newAs,
                                   @"title" : self.title,
                                   @"becomeEdit" : become ? @"1" : @"0",
                                   }];
}

- (void)reply{
    if([ASGlobal isLogined]){
        ASPostReplyVc *vc = [[ASPostReplyVc alloc] init];
        vc.question = self.question;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else{
        ASAppDelegate *appDelegate = (ASAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showNeedLoginAlertView];
    }
}

@end
