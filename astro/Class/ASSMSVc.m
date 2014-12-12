//
//  ASSMSVc.m
//  astro
//
//  Created by kjubo on 14/12/4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASSMSVc.h"
#import "ASUSR_SMS.h"
@interface ASSMSVc ()
@property (nonatomic, strong) ASBaseSingleTableView *tbList;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) UITextField *tfComment;
@property (nonatomic, strong) UIButton *btnSumbit;
@property (nonatomic, strong) NSMutableArray *list;
@end

@implementation ASSMSVc

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"我的消息";
    //table
    self.tbList = [[ASBaseSingleTableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor clearColor];
    self.tbList.separatorColor = [UIColor clearColor];
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    self.tbList.hasMore = NO;
    
    self.viewBottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 44)];
    self.viewBottom.backgroundColor = [UIColor lightGrayColor];
    self.viewBottom.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewBottom.layer.borderWidth = 0.3;
    [self.contentView addSubview:self.viewBottom];
    
    self.tfComment = [ASControls newTextField:CGRectMake(10, 0, 230, 32)];
    self.tfComment.centerY = self.viewBottom.height/2;
    self.tfComment.placeholder = @"说点什么呢 :) ";
    self.tfComment.returnKeyType = UIReturnKeyDone;
    self.tfComment.delegate = self;
    [self.viewBottom addSubview:self.tfComment];
    
    self.btnSumbit = [ASControls newOrangeButton:CGRectMake(0, 0, 60, 30) title:@"发送"];
    self.btnSumbit.right = self.viewBottom.width - 10;
    self.btnSumbit.centerY = self.viewBottom.height/2;
    [self.btnSumbit addTarget:self action:@selector(btnClick_submit) forControlEvents:UIControlEventTouchUpInside];
    [self.viewBottom addSubview:self.btnSumbit];
    
    //添加键盘监听事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardEvent:) name:UIKeyboardWillHideNotification object:nil];
    
    self.list = [NSMutableArray array];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.viewBottom.bottom = self.contentView.height;
    self.tbList.height = self.viewBottom.top;
    [self loadMore];
}

- (void)loadMore{
    [self showWaiting];
    [HttpUtil load:@"customer/GetSMSTalk"
            params:@{@"sysno" : @(self.sysNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                [self.list addObjectsFromArray:[ASUSR_SMS arrayOfModelsFromDictionaries:json]];
                [self.tbList reloadData];
            }else{
                [self alert:message];
            }
        }];

}

- (void)btnClick_submit{
    
}

#pragma mark - UITableView Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ASUSR_SMS *item = [self.list objectAtIndex:indexPath.row];
    return 40 + [item.Context boundingRectWithSize:CGSizeMake(260, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12]} context:nil].size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ASUrlImageView *ivFace = [[ASUrlImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        ivFace.tag = 99;
        [cell.contentView addSubview:ivFace];
        
        UILabel *lbContext = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 1)];
        lbContext.tag = 101;
        lbContext.lineBreakMode = NSLineBreakByCharWrapping;
        lbContext.backgroundColor = [UIColor clearColor];
        lbContext.textColor = [UIColor blackColor];
        lbContext.font = [UIFont systemFontOfSize:12];
        
        UIImageView *ivContentBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, lbContext.width + 12, 1)];
        ivContentBg.tag = 100;
        [cell.contentView addSubview:ivContentBg];
        [cell.contentView addSubview:lbContext];
    }
    ASUrlImageView *ivFace = (ASUrlImageView *)[cell.contentView viewWithTag:99];
    UIImageView *ivContentBg = (UIImageView *)[cell.contentView viewWithTag:100];
    UILabel *lbContext = (UILabel *)[cell.contentView viewWithTag:101];
    
    ASUSR_SMS *item = [self.list objectAtIndex:indexPath.row];
    [ivFace load:item.smallFromPhotoShow cacheDir:nil];
    lbContext.text = [item.Context copy];
    lbContext.height = [lbContext.text boundingRectWithSize:CGSizeMake(lbContext.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : lbContext.font} context:nil].size.height;
    ivContentBg.height = lbContext.height + 20;
    if(item.FromSysNo == [ASGlobal shared].user.SysNo){//发出去的
        ivFace.origin = CGPointMake(10, 10);
        ivContentBg.origin = CGPointMake(ivFace.right + 6, ivFace.top);
        ivContentBg.image = [UIImage imageNamed:@"sms_bg_send"];
    }else{
        ivFace.right = 310;
        ivFace.top = 10;
        ivContentBg.right = ivFace.left - 6;
        ivContentBg.top = ivFace.top;
        ivContentBg.image = [UIImage imageNamed:@"sms_bg_receive"];
    }
    lbContext.origin = CGPointMake(ivContentBg.left + 12, ivContentBg.top + 6);
    
    return cell;
}

#pragma mark - KeyBoardEvent Method
- (void)keyboardEvent:(NSNotification *)sender{
    CGSize cSize = self.contentView.contentSize;
    CGRect keyboardFrame;
    [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    if([sender.name isEqualToString:UIKeyboardWillHideNotification]){
        self.viewBottom.bottom = self.contentView.height;
        self.tbList.height = self.viewBottom.top;
    }else{
        self.viewBottom.bottom = self.view.height - keyboardFrame.size.height;
        self.tbList.height = self.viewBottom.top;
    }
    self.contentView.contentSize = cSize;
}

@end
