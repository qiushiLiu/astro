//
//  ASPostQuestionVc.m
//  astro
//
//  Created by kjubo on 14-6-26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPostQuestionVc.h"
#import "ASFillQuestionVc.h"
#import "ASCache.h"
#import "ASCategory.h"
#import "ASFateChart.h"
#import "ASQuestionButton.h"

@interface ASPostQuestionVc()
@property (nonatomic) BOOL hasReward;
@property (nonatomic, strong) NSString *topCateId;
@property (nonatomic, strong) NSString *cate;
@property (nonatomic, strong) NSArray *cateList;
@property (nonatomic, strong) NSMutableArray *pickerDataSource;

@property (nonatomic) NSInteger questionTypeSelected;       //问题分类选中行
@property (nonatomic) NSInteger panTypeSelected;            //排盘类型选中行

@property (nonatomic, strong) UIButton *btnQuestionType;    //问题分类
@property (nonatomic, strong) UIButton *btnPanType;         //排盘分类
@property (nonatomic, strong) UITextField *tfReward;        //悬赏输入
@property (nonatomic, strong) UIView *rewardView;           //悬赏图层（可能会不显示）
@property (nonatomic, strong) UIButton *btnQuestion;        //问题按钮
@property (nonatomic, strong) UILabel *lbQuestion;          //问题内容
@property (nonatomic, strong) ASQuestionButton *btnFirstPersonInfo; //第一当事人按钮
@property (nonatomic, strong) ASQuestionButton *btnSecondPersonInfo; //第二当事人按钮
@property (nonatomic, strong) ASPickerView *picker;
@end

@implementation ASPostQuestionVc
- (id)init{
    if(self = [super init]){
        self.question = [[ASPostQuestion alloc] init];
        self.question.CustomerSysNo = [ASGlobal shared].user.SysNo;
        self.questionTypeSelected = -1;
        self.panTypeSelected = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"发帖"];
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"发布"];
    [btn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap_ContentView:)];
    [self.contentView addGestureRecognizer:tapGesture];
    
    CGFloat left = 20, top = 20;
    UILabel *lb = [ASControls newRedTextLabel:CGRectMake(0, 0, 100, 30)];
    lb.text = @"分       类";
    lb.origin = CGPointMake(left, top);
    [self.contentView addSubview:lb];
    
    self.btnQuestionType = [self newRedButtom:@"本命性格"];
    self.btnQuestionType.top = top;
    [self.btnQuestionType addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnQuestionType];
    top = self.btnQuestionType.bottom + 10;
    
    lb = [ASControls newRedTextLabel:CGRectMake(0, 0, 100, 30)];
    lb.text = @"排盘类型";
    lb.origin = CGPointMake(left, top);
    [self.contentView addSubview:lb];
    
    self.btnPanType = [self newRedButtom:@"不排盘"];
    self.btnPanType.top = top;
    [self.btnPanType addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPanType];
    top = self.btnPanType.bottom + 10;
    
    self.rewardView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.contentView.width, 50)];
    self.rewardView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.rewardView];
    
    lb = [ASControls newRedTextLabel:CGRectMake(0, 0, 100, 30)];
    lb.text = @"悬       赏";
    lb.origin = CGPointMake(left, 0);
    [self.rewardView addSubview:lb];
    
    self.tfReward = [ASControls newTextField:CGRectMake(100, 0, 120, 30)];
    self.tfReward.keyboardType = UIKeyboardTypeNumberPad;
    self.tfReward.delegate = self;
    [self.rewardView addSubview:self.tfReward];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(self.tfReward.left, self.tfReward.bottom, 200, 18)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:12];
    lb.textColor = [UIColor redColor];
    lb.text = @"更高的悬赏获得解答的几率越高";
    [self.rewardView addSubview:lb];
    
    self.btnQuestion = [self newQuestionButton];
    self.btnQuestion.centerX = self.contentView.width/2;
    [self.btnQuestion addTarget:self action:@selector(btnClick_fillQuestion:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnQuestion];
    
    self.btnFirstPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, 0, 280, 60) iconName:@"icon_fill_0" preFix:@"第一当事人"];
    self.btnFirstPersonInfo.tag = 1;
    self.btnFirstPersonInfo.centerX = self.contentView.width/2;
    [self.btnFirstPersonInfo addTarget:self action:@selector(btnClick_fillPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnFirstPersonInfo];
    
    self.btnSecondPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, 0, 280, 60) iconName:@"icon_fill_1" preFix:@"第二当事人"];
    self.btnFirstPersonInfo.tag = 2;
    self.btnSecondPersonInfo.centerX = self.contentView.width/2;
    [self.btnSecondPersonInfo addTarget:self action:@selector(btnClick_fillPerson:) forControlEvents:UIControlEventTouchUpInside];
    self.btnSecondPersonInfo.hidden = YES;
    [self.contentView addSubview:self.btnSecondPersonInfo];
    
    self.picker = [[ASPickerView alloc] initWithParentViewController:self];
    self.picker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.rewardView.hidden = !self.hasReward;
    CGFloat buttonsTop = self.hasReward ? self.rewardView.bottom + 5 : self.rewardView.top;
    
    self.btnQuestion.top = buttonsTop;
    self.btnFirstPersonInfo.top = self.btnQuestion.bottom + 10;
    self.btnSecondPersonInfo.top = self.btnFirstPersonInfo.bottom + 10;
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width, self.btnSecondPersonInfo.bottom + 20);
    
    [self reloadPickerSelected];
}

- (void)setNavToParams:(NSDictionary *)params{
    self.hasReward = YES;// [params[@"hasReward"] boolValue];
    self.cate = params[@"cate"];
    self.question.CateSysNo = [self.cate intValue];
    
    self.topCateId = params[@"topCateId"];
    ASCacheObject *obj = [[ASCache shared] readDicFiledsWithDir:NSStringFromClass([ASCategory class]) key:self.topCateId];
    if(obj){
        NSData *data = [obj.value dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        self.cateList = [ASCategory arrayOfModelsFromData:data error:&error];
        if(error){
            NSLog(@"%@", error.description);
        }
        self.pickerDataSource = [NSMutableArray array];
        for(ASCategory *item in self.cateList){
            [self.pickerDataSource addObject:item.Name];
        }
    }
}

- (void)reloadPickerSelected{
    if(self.questionTypeSelected < 0){
        [self.btnQuestionType setTitle:@"请选择" forState:UIControlStateNormal];
    } else if([self.cateList count] > self.questionTypeSelected){
        ASCategory *item = self.cateList[self.questionTypeSelected];
        self.question.CateSysNo = item.SysNo;
        [self.btnQuestionType setTitle:item.Name forState:UIControlStateNormal];
    }
    if([RelationArray count] > self.panTypeSelected){
        if([self.question.Chart count] > 0){
            ASFateChart *chart = [self.question.Chart objectAtIndex:0];
            chart.ChartType = self.panTypeSelected + 1;
        }
        if(self.panTypeSelected == 0){
            self.btnSecondPersonInfo.hidden = YES;
        }else{
            self.btnSecondPersonInfo.hidden = NO;
        }
        [self.btnPanType setTitle:RelationArray[self.panTypeSelected] forState:UIControlStateNormal];
    }
}

#pragma mark - UIControl Create Method

- (UIButton *)newQuestionButton{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 280, 40)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_question"]];
    icon.left = 10;
    icon.centerY = btn.height/2;
    [btn addSubview:icon];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.highlightedImage = [UIImage imageNamed:@"arrow_right_hl"];
    arrow.right = btn.width - 10;
    arrow.centerY = btn.height/2;
    [btn addSubview:arrow];
    
    UILabel *lbPrefix = [ASControls newRedTextLabel:CGRectMake(0, 0, 100, 30)];
    lbPrefix.text = @"问题内容";
    [lbPrefix sizeToFit];
    lbPrefix.left = icon.right + 10;
    lbPrefix.centerY = btn.height/2;
    [btn addSubview:lbPrefix];
    
    self.lbQuestion = [ASControls newGrayTextLabel:CGRectMake(lbPrefix.right + 10, 0, 180, 28)];
    self.lbQuestion.centerY = btn.height/2;
    [btn addSubview:self.lbQuestion];
    
    return btn;
}

- (UIButton *)newRedButtom:(NSString *)title{
    UIButton *btn = [ASControls newOrangeButton:CGRectMake(100, 0, 120, 30) title:title];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_arrow_down"]];
    iv.right = btn.width - 10;
    iv.centerY = btn.height/2;
    [btn addSubview:iv];
    return btn;
}

- (void)reloadQuestion{
    self.lbQuestion.text = [self.question.Title copy];
}

- (void)reloadPerson:(NSInteger)tag{
    if([self.question.Chart count] > 0){
        ASFateChart *chart = [self.question.Chart objectAtIndex:0];
        if(tag == 0){ //第一当事人
            [self.btnFirstPersonInfo setInfoText:[ASFillPersonVc stringForBirth:chart.FirstBirth gender:chart.FirstGender daylight:chart.FirstDayLight poi:chart.FirstPoiName timeZone:chart.FirstTimeZone]];
        }else{ //第二当事人
            [self.btnSecondPersonInfo setInfoText:[ASFillPersonVc stringForBirth:chart.SecondBirth gender:chart.SecondGender daylight:chart.SecondDayLight poi:chart.SecondPoiName timeZone:chart.SecondTimeZone]];
        }
    }
}

- (void)tap_ContentView:(UITapGestureRecognizer *)tap{
    [self.tfReward resignFirstResponder];
    [self.picker hidePickerView];
}

#pragma mark - ASPickerView Delegate
- (void)asPickerViewDidSelected:(ASPickerView *)picker{
    if(picker.trigger == self.btnQuestionType){
        self.questionTypeSelected = [self.picker selectedRowInComponent:0];
    }else if(picker.trigger == self.btnPanType){
        self.panTypeSelected = [self.picker selectedRowInComponent:0];
    }
    [self reloadPickerSelected];
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == NSAlertViewOK){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - ASFillQuestionVcDelegate Method
- (void)ASFillPerson:(ASPerson *)person trigger:(id)trigger{
    ASFateChart *chart = nil;
    if(self.question && [self.question.Chart count] > 0){
        chart = [self.question.Chart objectAtIndex:0];
    }
    if(chart){
        if(trigger == self.btnFirstPersonInfo){
            chart.FirstBirth = (NSDate<NSDate> *)person.Birth;
            chart.FirstDayLight = person.Daylight;
            chart.FirstGender = person.Gender;
            chart.FirstTimeZone = person.TimeZone;
        }else if(trigger == self.btnSecondPersonInfo){
            chart.SecondBirth = (NSDate<NSDate> *)person.Birth;
            chart.SecondDayLight = person.Daylight;
            chart.SecondGender = person.Gender;
            chart.SecondTimeZone = person.TimeZone;
        }
    }
}

#pragma mark - UIButton Click Method
- (void)btnClick_picker:(UIButton *)sender{
    self.picker.trigger = sender;
    if(sender == self.btnQuestionType){
        [self.picker setDataSource:self.pickerDataSource selected:@(self.questionTypeSelected)];
    }else if(sender == self.btnPanType){
        NSInteger selected = 0;
        if([self.question.Chart count] > 0){
            ASFateChart *chart = [self.question.Chart objectAtIndex:0];
            selected = chart.ChartType - 1;
        }
        [self.picker setDataSource:RelationArray selected:@(selected)];
    }
    [self.picker showPickerView];
}

- (void)btnClick_fillQuestion:(UIButton *)sender{
    ASFillQuestionVc *vc = [[ASFillQuestionVc alloc] init];
    vc.parentVc = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_fillPerson:(UIButton *)sender{
    ASFillPersonVc *vc = [[ASFillPersonVc alloc] init];
    vc.delegate = self;
    vc.trigger = sender;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)post{
    [self hideWaiting];
    [HttpUtil post:kUrlAddQuestionWithChart
            params:nil
              body:[self.question toJSONString]
        completion:^(BOOL succ, NSString *message, id json) {
            [self hideWaiting];
            if(succ){
                ASCustomer *user = [[ASCustomer alloc] initWithDictionary:json error:NULL];
                [ASGlobal login:user];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Question_NeedUpdate object:nil];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发帖成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
            }else{
                [self alert:message];
            }
        }];
}
@end
