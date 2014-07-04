//
//  ASPostQuestionVc.m
//  astro
//
//  Created by kjubo on 14-6-26.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPostQuestionVc.h"
#import "ASFillQuestionVc.h"
#import "ASFillPersonVc.h"
@interface ASPostQuestionVc()
@property (nonatomic) BOOL hasReward;
@property (nonatomic, strong) UIButton *btnQuestionType;    //问题分类
@property (nonatomic, strong) UIButton *btnPanType;         //排盘分类
@property (nonatomic, strong) UITextField *tfReward;        //悬赏输入
@property (nonatomic, strong) UIView *rewardView;           //悬赏图层（可能会不显示）
@property (nonatomic, strong) UIButton *btnQuestion;        //问题按钮
@property (nonatomic, strong) UILabel *lbQuestion;          //问题内容
@property (nonatomic, strong) UIButton *btnFirstPersonInfo; //第一当事人按钮
@property (nonatomic, strong) UILabel *lbFirstPersonInfo;   //第一当事人
@property (nonatomic, strong) UIButton *btnSecondPersonInfo; //第二当事人按钮
@property (nonatomic, strong) UILabel *lbSecondPersonInfo;  //第二当事人
@end

@implementation ASPostQuestionVc
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self setTitle:@"发帖"];
    
    UIButton *btn = [ASControls newRedButton:CGRectMake(0, 0, 56, 28) title:@"发布"];
    [btn addTarget:self action:@selector(post) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat left = 20, top = 20;
    UILabel *lb = [self newRedTextLabel];
    lb.text = @"分       类";
    lb.origin = CGPointMake(left, top);
    [self.contentView addSubview:lb];
    
    self.btnQuestionType = [self newRedButtom:@"本命性格"];
    self.btnQuestionType.top = top;
    [self.btnQuestionType addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnQuestionType];
    top = self.btnQuestionType.bottom + 10;
    
    lb = [self newRedTextLabel];
    lb.text = @"排盘类型";
    lb.origin = CGPointMake(left, top);
    [self.contentView addSubview:lb];
    
    self.btnPanType = [self newRedButtom:@"比较盘"];
    self.btnPanType.top = top;
    [self.contentView addSubview:self.btnPanType];
    top = self.btnPanType.bottom + 10;
    
    self.rewardView = [[UIView alloc] initWithFrame:CGRectMake(0, top, self.contentView.width, 50)];
    self.rewardView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.rewardView];
    
    lb = [self newRedTextLabel];
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
    
    self.btnFirstPersonInfo = [self newPersonButton:1];
    self.btnFirstPersonInfo.centerX = self.contentView.width/2;
    [self.btnFirstPersonInfo addTarget:self action:@selector(btnClick_fillPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnFirstPersonInfo];
    
    self.btnSecondPersonInfo = [self newPersonButton:2];
    self.btnSecondPersonInfo.centerX = self.contentView.width/2;
    [self.btnSecondPersonInfo addTarget:self action:@selector(btnClick_fillPerson:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnSecondPersonInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.rewardView.hidden = !self.hasReward;
    CGFloat buttonsTop = self.hasReward ? self.rewardView.bottom + 5 : self.rewardView.top;
    
    self.btnQuestion.top = buttonsTop;
    self.btnFirstPersonInfo.top = self.btnQuestion.bottom + 10;
    self.btnSecondPersonInfo.top = self.btnFirstPersonInfo.bottom + 10;
    
    self.contentView.contentSize = CGSizeMake(self.contentView.width, self.btnSecondPersonInfo.bottom + 20);
}

- (void)setNavToParams:(NSDictionary *)params{
    self.hasReward = YES;// [params[@"hasReward"] boolValue];
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
    
    UILabel *lbPrefix = [self newRedTextLabel];
    lbPrefix.text = @"问题内容";
    [lbPrefix sizeToFit];
    lbPrefix.left = icon.right + 10;
    lbPrefix.centerY = btn.height/2;
    [btn addSubview:lbPrefix];
    
    self.lbQuestion = [self newGrayTextLabel:CGRectMake(lbPrefix.right + 10, 0, 180, 28)];
    self.lbQuestion.centerY = btn.height/2;
    [btn addSubview:self.lbQuestion];
    
    return btn;
}

- (UIButton *)newPersonButton:(NSInteger)personTag{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 280, 60)];
    btn.backgroundColor = [UIColor whiteColor];
    btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    btn.layer.borderWidth = 1;
    btn.layer.cornerRadius = 5;
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_person_%d", personTag]]];
    icon.origin = CGPointMake(10, 5);
    [btn addSubview:icon];
    
    UIImageView *arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
    arrow.highlightedImage = [UIImage imageNamed:@"arrow_right_hl"];
    arrow.right = btn.width - 10;
    arrow.centerY = icon.centerY;
    [btn addSubview:arrow];
    
    UILabel *lbPrefix = [self newRedTextLabel];
    if(personTag == 0){
        lbPrefix.text = @"第一当事人";
    }else{
        lbPrefix.text = @"第二当事人";
    }
    [lbPrefix sizeToFit];
    lbPrefix.left = icon.right + 10;
    lbPrefix.centerY = icon.centerY;
    [btn addSubview:lbPrefix];

    UIImageView *ivLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line_dash"]];
    ivLine.left = lbPrefix.left - 5;
    ivLine.top = icon.bottom;
    [btn addSubview:ivLine];
    
    UILabel *lb = [self newGrayTextLabel:CGRectMake(lbPrefix.right + 10, 0, 180, 28)];
    lb.top = icon.bottom + 10;
    [btn addSubview:lb];
    
    if(personTag == 0){
        self.lbFirstPersonInfo = lb;
    }else{
        self.lbSecondPersonInfo = lb;
    }
    
    return btn;
}

- (UILabel *)newRedTextLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = ASColorDarkRed;
    return lb;
}

- (UILabel *)newGrayTextLabel:(CGRect)frame{
    UILabel *lb = [[UILabel alloc] initWithFrame:frame];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:16];
    lb.textColor = [UIColor lightGrayColor];
    lb.numberOfLines = 1;
    lb.lineBreakMode = NSLineBreakByTruncatingTail;
    return lb;
}

- (UIButton *)newRedButtom:(NSString *)title{
    UIButton *btn = [ASControls newOrangeButton:CGRectMake(100, 0, 120, 30) title:title];
    UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"white_arrow_down"]];
    iv.right = btn.width - 10;
    iv.centerY = btn.height/2;
    [btn addSubview:iv];
    return btn;
}

+ (UIView *)titleView:(CGRect)frame title:(NSString *)title{
    UIView *titleView = [[UIView alloc] initWithFrame:frame];
    titleView.backgroundColor = UIColorFromRGB(0xc0a037);
    titleView.layer.cornerRadius = titleView.height/2;
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, titleView.width - 15, titleView.height)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = [UIColor whiteColor];
    lb.text = @"请输入问题内容";
    [titleView addSubview:lb];
    return titleView;
}

#pragma mark - UIButton Click Method

- (void)btnClick_picker:(UIButton *)sender{
    
}

- (void)btnClick_fillQuestion:(UIButton *)sender{
    ASFillQuestionVc *vc = [[ASFillQuestionVc alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{
    }];
}

- (void)btnClick_fillPerson:(UIButton *)sender{
    ASFillPersonVc *vc = [[ASFillPersonVc alloc] init];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:^{
    }];
}

- (void)post{
    
}
@end
