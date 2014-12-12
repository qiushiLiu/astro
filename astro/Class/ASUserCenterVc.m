//
//  ASUserCenterVc.m
//  astro
//
//  Created by kjubo on 14-6-18.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASUserCenterVc.h"
#import "ASCustomerShow.h"
#import "ASUserEditVc.h"
#import "ASAskerCell.h"
#import "ASUserMessageVc.h"
#import "ASUserTopicVc.h"

@interface ASUserCenterVc ()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) ASUrlImageView *ivFace;
@property (nonatomic, strong) UILabel *lbNameInfo;
@property (nonatomic, strong) UILabel *lbUserIntro;
@property (nonatomic, strong) UILabel *lbUserPan;
@property (nonatomic, strong) UIButton *btnEdit;
@property (nonatomic, strong) UIView *bgScoreView;
@property (nonatomic, strong) NSMutableArray *arrScoreLabel;
@property (nonatomic, strong) UITableView *tbList;

@property (nonatomic, strong) ASCustomerShow *um;
@end

@implementation ASUserCenterVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.contentView.width - 20, 1)];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.borderWidth = 0.5;
    self.bgView.layer.cornerRadius = 5.0;
    [self.contentView addSubview:self.bgView];
    
    self.ivFace = [[ASUrlImageView alloc] initWithFrame:CGRectMake(10, self.bgView.top + 10, 40, 40)];
    [self.bgView addSubview:self.ivFace];
    
    self.lbNameInfo = [[UILabel alloc] init];
    self.lbNameInfo.backgroundColor = [UIColor clearColor];
    self.lbNameInfo.font = [UIFont systemFontOfSize:13];
    self.lbNameInfo.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.lbNameInfo];
    
    self.lbUserIntro = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 240, 10)];
    self.lbUserIntro.backgroundColor = [UIColor clearColor];
    self.lbUserIntro.font = [UIFont systemFontOfSize:13];
    self.lbUserIntro.textColor = [UIColor blackColor];
    self.lbUserIntro.numberOfLines = 0;
    self.lbUserIntro.lineBreakMode = NSLineBreakByCharWrapping;
    [self.bgView addSubview:self.lbUserIntro];
    
    self.lbUserPan = [[UILabel alloc] init];
    self.lbUserPan.backgroundColor = [UIColor clearColor];
    self.lbUserPan.font = [UIFont systemFontOfSize:13];
    self.lbUserPan.textColor = [UIColor blackColor];
    [self.bgView addSubview:self.lbUserPan];
    
    self.btnEdit = [ASControls newOrangeButton:CGRectMake(0, 0, 60, 26) title:@"修改"];
    [self.btnEdit addTarget:self action:@selector(btnClick_edit) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:self.btnEdit];
    
    self.bgScoreView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, self.bgView.width - 20, 60)];
    self.bgScoreView.backgroundColor = ASColorQing;
    self.bgScoreView.layer.cornerRadius = 5.0;
    [self.bgView addSubview:self.bgScoreView];
    
    self.arrScoreLabel = [NSMutableArray array];
    CGFloat margin = 2;
    CGSize labelSize = CGSizeMake((self.bgScoreView.width - 4*margin)/3, self.bgScoreView.height/2 - 2);
    for(int i = 0; i < 3 ;i++){
        UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(margin + i * (labelSize.width + margin), 0, labelSize.width, labelSize.height)];
        lbTitle.font = [UIFont systemFontOfSize:12];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textColor = [UIColor blackColor];
        lbTitle.textAlignment = NSTextAlignmentCenter;
        lbTitle.text = kScoreTitleArray[i];
        [self.bgScoreView addSubview:lbTitle];
        
        UILabel *lbScore = [[UILabel alloc] initWithFrame:lbTitle.frame];
        lbScore.top = lbTitle.bottom;
        lbScore.font = [UIFont systemFontOfSize:12];
        lbScore.backgroundColor = [UIColor whiteColor];
        lbScore.textColor = [UIColor redColor];
        lbScore.textAlignment = NSTextAlignmentCenter;
        lbScore.text = kScoreTitleArray[i];
        [self.bgScoreView addSubview:lbScore];
        [self.arrScoreLabel addObject:lbScore];
    }
    
    self.tbList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 80 * [kUserTableRowTitle count])];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.separatorStyle = UITableViewCellSeparatorStyleNone;
    if([self.tbList respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tbList setSeparatorInset:UIEdgeInsetsZero];
    }
    [self.contentView addSubview:self.tbList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([self.navigationController.viewControllers count] == 1){
        self.navigationItem.leftBarButtonItem = nil;
    }
    if([self isCurrentUser]){
        [self setTitle:@"个人首页"];
        UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"注销"];
        [btn addTarget:self action:@selector(btnClick_loginOut) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    }else{
        [self setTitle:@"Ta的首页"];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    [self showWaiting];
    [HttpUtil load:@"customer/GetUserInfo"
            params:@{@"uid" : @(self.uid)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                NSError *error;
                self.um = [[ASCustomerShow alloc] initWithDictionary:json error:&error];
                if(self.um){
                    [self loadUserInfo];
                }
            }else{
                [self alert:message];
            }
        }];
}

- (BOOL)isCurrentUser{
    if(self.uid == 0){
        self.uid = [ASGlobal shared].user.SysNo;
    }
    return self.uid == [ASGlobal shared].user.SysNo;
}

- (void)loadUserInfo{
    [self.ivFace load:self.um.smallPhotoShow cacheDir:nil];
    NSMutableString *str = [NSMutableString stringWithString:self.um.NickName];
    [str appendFormat:@"    %@ 等级 ", (self.um.Gender == 1 ? @"男" : @"女")];
    NSMutableAttributedString *attName = [[NSMutableAttributedString alloc] initWithString:str];
    [attName appendAttributedString:[[NSAttributedString alloc] initWithString:self.um.GradeShow
                                                                    attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    self.lbNameInfo.attributedText = attName;
    [self.lbNameInfo sizeToFit];
    self.lbNameInfo.origin = CGPointMake(self.ivFace.right + 10, self.ivFace.top);
    
    self.lbUserIntro.text = self.um.Intro;
    self.lbUserIntro.height = [self.um.Intro boundingRectWithSize:CGSizeMake(self.lbUserIntro.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.lbUserIntro.font} context:nil].size.height;
    self.lbUserIntro.origin = CGPointMake(self.lbNameInfo.left, self.lbNameInfo.bottom + 2);
    
    NSMutableAttributedString *attPan = [[NSMutableAttributedString alloc] initWithString:@"我目前最感兴趣的是: "];
    [attPan appendAttributedString:[[NSAttributedString alloc] initWithString:FateTypeArray[self.um.FateType - 1]
                                                                    attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}]];
    self.lbUserPan.attributedText = attPan;
    [self.lbUserPan sizeToFit];
    self.lbUserPan.origin = CGPointMake(self.ivFace.left, MAX(self.ivFace.bottom , self.lbUserIntro.bottom) + 15);
    
    CGFloat top = self.ivFace.bottom;
    if([self isCurrentUser]){
        self.btnEdit.hidden = NO;
        self.btnEdit.right = self.bgScoreView.right;
        self.btnEdit.centerY = self.lbUserPan.centerY;
        top = self.btnEdit.bottom;
    }else{
        self.btnEdit.hidden = YES;
    }
    
    self.bgScoreView.top = top + 15;
    self.bgView.height = self.bgScoreView.bottom + 25;
    ((UILabel *)self.arrScoreLabel[0]).text = Int2String(self.um.Point);
    ((UILabel *)self.arrScoreLabel[1]).text = Int2String(self.um.TotalQuest);
    ((UILabel *)self.arrScoreLabel[2]).text = Int2String(self.um.TotalAnswer);
    
    self.tbList.top = self.bgView.bottom + 10;
    self.contentView.contentSize = CGSizeMake(self.contentView.width, self.tbList.bottom + 10);
}


- (void)btnClick_edit{
    ASUserEditVc *vc = [[ASUserEditVc alloc] init];
    vc.um = self.um;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnClick_loginOut{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确定要注销当前登录用户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = NSAlertViewConfirm;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == NSAlertViewConfirm
       && alertView.cancelButtonIndex != buttonIndex){
        [ASGlobal loginOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_MainVc object:nil];
    }
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [kUserTableRowTitle count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASAskerCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[ASAskerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
    }
    
    [cell.icon loadLocalImage:@""];
    NSString *whos = [self isCurrentUser] ? @"我的" : @"Ta的";
    NSInteger count = 0;
    if(indexPath.row == 0){   //回帖
        count = self.um.TotalQuest + self.um.TotalTalk;
    }else if(indexPath.row == 1){   //发帖
        count = self.um.TotalAnswer + self.um.TotalTalkReply;
    }else if(indexPath.row == 2){   //消息
        count = self.um.NewMessage;
    }
    [cell.lbTitle setText:[NSString stringWithFormat:@"%@%@（%@）", whos, kUserTableRowTitle[indexPath.row], @(count)]];
    [cell.lbSummary setText:@""];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row <= 1){
        ASUserTopicVc *vc = [[ASUserTopicVc alloc] init];
        vc.type = indexPath.row;
        vc.uid = self.uid;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(indexPath.row == 2){
        ASUserMessageVc *vc = [[ASUserMessageVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark -

- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController != self);
}

@end
