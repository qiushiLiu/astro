//
//  ASCommentVc.m
//  astro
//
//  Created by kjubo on 14/10/31.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASCommentVc.h"
#import "ASQaAnswer.h"
#import "ASQaComment.h"
#import "ASUserCenterVc.h"
#import "ASNav.h"
#import "ASAppDelegate.h"

@interface ASCommentVc ()
@property (nonatomic, strong) UITableView *tbList;
@property (nonatomic, strong) UIView *viewBottom;
@property (nonatomic, strong) UITextField *tfComment;
@property (nonatomic, strong) UIButton *btnSumbit;
@property (nonatomic, strong) ASQaAnswer *answer;
@property (nonatomic) BOOL becomeEdit;
@end

@implementation ASCommentVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //table
    self.tbList = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height) style:UITableViewStylePlain];
    self.tbList.backgroundColor = [UIColor whiteColor];
    self.tbList.separatorColor = [UIColor clearColor];
    if ([self.tbList respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tbList setSeparatorInset:UIEdgeInsetsZero];
    }
    self.tbList.delegate = self;
    self.tbList.dataSource = self;
    [self.contentView addSubview:self.tbList];
    
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
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setTitle:self.title];
    self.viewBottom.bottom = self.contentView.height;
    self.tbList.height = self.viewBottom.top;
    [self loadMore];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNavToParams:(NSDictionary *)params{
    self.answer = params[@"answer"];
    self.title = params[@"title"];
    self.becomeEdit = [params[@"becomeEdit"] intValue] > 0;
}

- (void)loadMore{
    [self showWaiting];
    [HttpUtil load:@"qa/GetCommentByAnswer"
            params:@{@"sysno" : Int2String(self.answer.SysNo)}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                if(!self.answer.TopComments){
                    self.answer.TopComments = (NSMutableArray<ASQaComment, Optional> *)[NSMutableArray array];
                }
                [self.answer.TopComments removeAllObjects];
                [self.answer.TopComments addObjectsFromArray:[ASQaComment arrayOfModelsFromDictionaries:json]];
                [self.tbList reloadData];
                if(self.becomeEdit){
                    self.becomeEdit = NO;
                    [self.tfComment becomeFirstResponder];
                }
                self.tfComment.text = @"";
            }else{
                [self alert:message];
            }
        }];
}

- (void)btnClick_submit{
    if(![ASGlobal isLogined]){
        ASAppDelegate *appDelegate = (ASAppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate showNeedLoginAlertView];
        return;
    }
    
    NSString *context = [self.tfComment.text trim];
    if([context length] == 0){
        [self alert:@"请输入评论内容"];
        return;
    }
    [self.tfComment resignFirstResponder];
    [self showWaiting];
    [HttpUtil load:@"qa/AddComment"
            params:@{@"CustomerSysNo" : Int2String([ASGlobal shared].user.SysNo),
                     @"AnswerSysNo" : Int2String(self.answer.SysNo),
                     @"QuestionSysNo" : Int2String(self.answer.QuestionSysNo),
                     @"Context" : context}
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                [self loadMore];
            }else{
                [self alert:message];
            }
        }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if([[textField.text trim] length] > 0){
        [self btnClick_submit];
    }
    return YES;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.pageKey];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.pageKey];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        ASAskDetailCellView *cv = [[ASAskDetailCellView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 1)];
        cv.tag = 200;
        [cell.contentView addSubview:cv];
    }
    ASAskDetailCellView *cv = (ASAskDetailCellView *)[cell.contentView viewWithTag:200];
    cv.delegate = self;
    [cv setQaProtocol:self.answer canDel:NO canComment:NO floor:indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ASAskDetailCellView heightForQaProtocol:self.answer canDelOrComment:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tfComment resignFirstResponder];
}

#pragma mark - ASAskDetailCellView Delegate
- (void)detailCellClickFace:(NSInteger)uid{
    ASUserCenterVc *vc = [[ASUserCenterVc alloc] init];
    vc.uid = uid;
    [self.navigationController pushViewController:vc animated:YES];
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
