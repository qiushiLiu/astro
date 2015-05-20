//
//  ASDiceViewController.m
//  astro
//
//  Created by kjubo on 15/1/4.
//  Copyright (c) 2015年 kjubo. All rights reserved.
//

#import "ASDiceViewController.h"
#import "ASDiceView.h"
#import "Paipan.h"
#import "CustomIOSAlertView.h"
@implementation ASDiceResult
@end


@interface ASDiceViewController ()<ASDiceViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITextField *tfQuestion;
@property (nonatomic, strong) ASDiceView *panView;
@property (nonatomic, strong) UIButton *btnStart;
@property (nonatomic, strong) UITableView *tbResult;
@property (nonatomic, strong) NSMutableArray *arr;
@end

@implementation ASDiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"占星骰子";
    self.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bj_01"]]; //dice_bg
    
    self.tfQuestion = [[UITextField alloc] initWithFrame:CGRectMake(10, 15, 230, 30)];
    self.tfQuestion.background = [UIImage imageNamed:@"dice_input"];
    self.tfQuestion.clearButtonMode = UITextFieldViewModeAlways;
    self.tfQuestion.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, self.tfQuestion.height)];
    self.tfQuestion.font = [UIFont systemFontOfSize:13];
    self.tfQuestion.textColor = UIColorFromRGB(0x00FFFF);
    self.tfQuestion.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入您要占卜的事情~" attributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0x00FFFF)}];
    self.tfQuestion.leftViewMode = UITextFieldViewModeAlways;
    self.tfQuestion.returnKeyType = UIReturnKeyDone;
    self.tfQuestion.delegate = self;
    [self.contentView addSubview:self.tfQuestion];
    
    self.btnStart = [ASControls newRedButton:CGRectMake(0, 15, 60, 30) title:@"开始"];
    self.btnStart.right = DF_WIDTH - 10;
    [self.btnStart addTarget:self action:@selector(btnClick_start) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnStart];
    
    self.panView = [[ASDiceView alloc] initWithFrame:CGRectMake(0, self.tfQuestion.bottom + 4, 320, 320)];
    self.panView.delegate = self;
    [self.contentView addSubview:self.panView];
    
    UIImageView *ivLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dice_logo"]];
    ivLogo.bottom = self.panView.bottom - 5;
    ivLogo.left = 5;
    [self.contentView addSubview:ivLogo];
    
    self.tbResult = [[UITableView alloc] initWithFrame:CGRectMake(0, self.panView.bottom + 20, DF_WIDTH, 1) style:UITableViewStylePlain];
    self.tbResult.backgroundColor = [UIColor clearColor];
    self.tbResult.separatorColor = [UIColor clearColor];
    self.tbResult.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tbResult.scrollEnabled = NO;
    self.tbResult.rowHeight = 120;
    self.tbResult.delegate = self;
    self.tbResult.dataSource = self;
    [self.contentView addSubview:self.tbResult];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    [self.panView addGestureRecognizer:tap];
    
    self.arr = [NSMutableArray array];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)hideKeyBoard{
    [self.tfQuestion resignFirstResponder];
}

- (void)btnClick_start{
    [self hideKeyBoard];
    self.tfQuestion.enabled = NO;
    self.contentView.scrollEnabled = NO;
    [self.panView start];
}

#pragma mark - UITableView Delegate Method
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self hideKeyBoard];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"DiceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        UIImageView *ivBg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, DF_WIDTH - 10, 100)];
        ivBg.image = [[UIImage imageNamed:@"dice_text_bg"] stretchableImageWithLeftCapWidth:30 topCapHeight:30];
        [cell.contentView addSubview:ivBg];
        
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(ivBg.left + 20, ivBg.top + 5, ivBg.width -40, ivBg.height - 10)];
        lb.textAlignment = NSTextAlignmentLeft;
        lb.tag = 100;
        lb.backgroundColor = [UIColor clearColor];
        lb.lineBreakMode = NSLineBreakByCharWrapping;
        lb.numberOfLines = 0;
        [cell.contentView addSubview:lb];
    }
    ASDiceResult *item = self.arr[indexPath.row];
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:100];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:@"#占卜结果#\n"
                                                                attributes:@{NSForegroundColorAttributeName : ASColorBlue,
                                                                             NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
    if([item.question length] > 0){
        NSString *question = [NSString stringWithFormat:@"%@\n", item.question];
        [str appendAttributedString:[[NSAttributedString alloc] initWithString:question
                                                                    attributes:@{NSForegroundColorAttributeName : ASColorDarkGray,
                                                                                 NSFontAttributeName : [UIFont systemFontOfSize:14]}]];
    }
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:item.info
                                                                attributes:@{NSForegroundColorAttributeName : ASColorBlue,
                                                                             NSFontAttributeName : [UIFont boldSystemFontOfSize:16]}]];
    lb.attributedText = str;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ASDiceResult *item = self.arr[indexPath.row];
    if(item){
        NSString *html = [NSString stringWithFormat:@"<body style=\"background-color: transparent;\">%@</body>", item.result];
        CustomIOSAlertView *alert = [[CustomIOSAlertView alloc] init];
        UIWebView *wbView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, DF_WIDTH - 40, 240)];
        wbView.opaque = NO;
        wbView.backgroundColor = [UIColor clearColor];
        [wbView loadHTMLString:html baseURL:nil];
        [alert setContainerView:wbView];
        [alert setButtonTitles:@[@"确定"]];
        [alert setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            [alertView close];
        }];
        [alert show];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == self.tfQuestion){
        [self btnClick_start];
    }
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    int limit = 40;
    return !([textField.text length]>limit && [string length] > range.length);
}

#pragma mark - ASDiceViewDelegate
- (void)didFinishedDiceView:(ASDiceView *)dv{
    self.tfQuestion.enabled = YES;
    self.contentView.scrollEnabled = YES;
    [self showWaiting];
    NSInteger star = self.panView.star + 1;
    NSInteger gong = self.panView.gong + 1;
    NSInteger constellation = self.panView.constellation + 1;
    [HttpUtil load:@"pp/GetDiceInfo"
            params:@{@"star" : @(self.panView.star),
                     @"house" : @(gong),
                     @"constellation" : @(self.panView.constellation)}
        completion:^(BOOL succ, NSString *message, id json) {
            ASDiceResult *item = [[ASDiceResult alloc] init];
            item.question = [self.tfQuestion.text trim];
            item.info = [NSString stringWithFormat:@"%@ %@宫 %@", __AstroStar[star], @(gong), __Constellation[constellation]];
            item.result = json;
            [self.arr insertObject:item atIndex:0];
            [self.tbResult reloadData];
            self.tbResult.height = self.tbResult.contentSize.height;
            self.contentView.contentSize = CGSizeMake(DF_WIDTH, self.tbResult.bottom);
            [self hideWaiting];
        }];
}

@end
