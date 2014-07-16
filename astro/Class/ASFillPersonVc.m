//
//  ASFillPersonVc.m
//  astro
//
//  Created by kjubo on 14-7-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASFillPersonVc.h"
#import "ZJSwitch.h"


@interface ASPerson : NSObject
@property (nonatomic, strong) NSDate *Birth;
@property (nonatomic) NSInteger Gender;
@property (nonatomic) NSInteger Daylight;
@property (nonatomic) NSInteger TimeZone;
//@property (nonatomic) float latitude;   //纬度
//@property (nonatomic) float longitude;  //经度
//@property (nonatomic, strong) NSString *poiName;    //地理位置
@end

@implementation ASPerson
- (id)init{
    if(self = [super init]){
        self.TimeZone = 4;  //东八区
        self.Gender = 1;    //男
        self.Birth = [[NSDate alloc] initWithYear:1990 month:1 day:1 hour:12 minute:0 second:0];
    }
    return self;
}

@end

@interface ASFillPersonVc ()
@property (nonatomic, weak) ASPostQuestion *question;

@property (nonatomic, strong) UIButton *btnDate;
@property (nonatomic, strong) UIButton *btnTime;
@property (nonatomic, strong) ZJSwitch *swDaylight; //夏令时
@property (nonatomic, strong) UIButton *btnTimeZone;//时区
@property (nonatomic, strong) ZJSwitch *swGender;   //性别
@property (nonatomic, strong) ASPickerView *picker; //选择器
@property (nonatomic, strong) UIButton *btnPoi;     //地址
@property (nonatomic, strong) ASPerson *person;
@end

@implementation ASFillPersonVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.person = [[ASPerson alloc] init];
    
    self.title = @"当事人信息";
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"确定"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];

    CGFloat top = 20;
    CGFloat left = 20;

    UIView *titleView = [ASPostQuestionVc titleView:CGRectMake(left, top, 280, 30) title:[NSString stringWithFormat:@"请输入第%@当事人信息", NumberToCharacter[self.personTag]]];
    [self.contentView addSubview:titleView];
    top = titleView.bottom + 10;
    
    UILabel *lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"阳历生日";
    [self.contentView addSubview:lb];
    
    self.btnDate = [self newPickerButton:CGRectMake(lb.right + 10, top, 100, 30)];
    [self.btnDate setTitle:@"请选择日期" forState:UIControlStateNormal];
    [self.btnDate addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnDate];
    
    self.btnTime = [self newPickerButton:CGRectMake(self.btnDate.right + 10, top, 100, 30)];
    [self.btnTime setTitle:@"请选择时间" forState:UIControlStateNormal];
    [self.btnTime addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnTime];
    top = self.btnTime.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"夏 令 时";
    [self.contentView addSubview:lb];
    
    self.swDaylight = [[ZJSwitch alloc] initWithFrame:CGRectMake(lb.right + 10, top, 80, 30)];
    self.swDaylight.textFont = [UIFont systemFontOfSize:16];
    self.swDaylight.onText = @"是";
    self.swDaylight.offText = @"否";
    [self.swDaylight setTintColor:ASColorBlue];
    [self.swDaylight setOnTintColor:ASColorDarkRed];
    [self.contentView addSubview:self.swDaylight];
    top = self.swDaylight.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"所属时区";
    [self.contentView addSubview:lb];
    
    self.btnTimeZone = [self newPickerButton:CGRectMake(lb.right + 10, top, 100, 30)];
    [self.btnTimeZone setTitle:@"东8区" forState:UIControlStateNormal];
    [self.btnTimeZone addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnTimeZone];
    top = self.btnTimeZone.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"性       别";
    [self.contentView addSubview:lb];
    
    self.swGender = [[ZJSwitch alloc] initWithFrame:CGRectMake(lb.right + 10, top, 80, 30)];
    self.swGender.textFont = [UIFont systemFontOfSize:16];
    self.swGender.onText = @"女";
    self.swGender.offText = @"男";
    [self.swGender setTintColor:ASColorBlue];
    [self.swGender setOnTintColor:ASColorDarkRed];
    [self.contentView addSubview:self.swGender];
    top = self.swGender.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"出生地点";
    [self.contentView addSubview:lb];
    
    self.btnPoi = [self newPickerButton:CGRectMake(lb.right + 10, top, 160, 30)];
    [self.btnPoi setTitle:@"请选择出生城市" forState:UIControlStateNormal];
    [self.btnPoi addTarget:self action:@selector(btnClick_poi:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPoi];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)setParentVc:(ASPostQuestionVc *)parentVc{
    _parentVc = parentVc;
    self.question = _parentVc.question;
}

- (void)reloadData{
    self.swDaylight.on = self.person.Daylight > 0;
    self.swGender.on = self.person.Gender == 0;
    [self.btnDate setTitle:[self.person.Birth toStrFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [self.btnTime setTitle:[self.person.Birth toStrFormat:@"hh-mm"] forState:UIControlStateNormal];
    [self.btnTimeZone setTitle:TimeZoneArray[self.person.TimeZone] forState:UIControlStateNormal];
}

- (UILabel *)newPerfixTextLabel{
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    lb.backgroundColor = [UIColor clearColor];
    lb.font = [UIFont systemFontOfSize:14];
    lb.textColor = [UIColor blackColor];
    return lb;
}

- (UIButton *)newPickerButton:(CGRect)frame{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    UIImageView *ivArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"black_arrow_down"]];
    ivArrow.right = btn.width - 8;
    ivArrow.centerY = btn.height/2;
    [btn addSubview:ivArrow];
    
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [btn setBackgroundImage:[[UIImage imageNamed:@"input_white_bg"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    btn.titleLabel.font = [UIFont systemFontOfSize:12];
    return btn;
}

- (void)btnClick_picker:(UIButton *)sender{
    self.picker.trigger = sender;
    if(self.btnDate == sender){
        self.picker.trigger = sender;
        [self.picker setDatePickerMode:UIDatePickerModeDate selected:self.person.Birth];
    }else if(self.btnTime == sender){
        [self.picker setDatePickerMode:UIDatePickerModeTime selected:self.person.Birth];
    }else if(self.btnTimeZone == sender){
        [self.picker setDataSource:TimeZoneArray selected:@(self.person.TimeZone)];
    }
    [self.picker showPickerView];
}

- (void)btnClick_poi:(UIButton *)sender{
    ASPoiMapVc *vc = [[ASPoiMapVc alloc] init];
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_navBack:(UIButton *)sender{
    ASFateChart *chart = nil;
    if(self.question && [self.question.Chart count] > 0){
        chart = [self.question.Chart objectAtIndex:0];
    }
    if(chart){
        if(self.personTag == 0){
            chart.FirstBirth = (NSDate<NSDate> *)self.person.Birth;
            chart.FirstDayLight = self.swDaylight.on;
            chart.FirstGender = self.swGender.on;
            chart.FirstTimeZone = self.person.TimeZone - 12;
        }else{
            chart.SecondBirth = (NSDate<NSDate> *)self.person.Birth;
            chart.SecondDayLight = self.swDaylight.on;
            chart.SecondGender = self.swGender.on;
            chart.SecondTimeZone = self.person.TimeZone - 12;
        }
    }
    [self dismissViewControllerAnimated:YES completion:^{
        [self.parentVc reloadPerson:self.personTag];
    }];
}

#pragma mark - ASPoiMapDelegate Method
- (void)asPoiMap:(BMKAddrInfo *)info{
    ASFateChart *chart = nil;
    if(self.question && [self.question.Chart count] > 0){
        chart = [self.question.Chart objectAtIndex:0];
    }
    NSString *poiName = [NSString stringWithFormat:@"%@, %@", info.addressComponent.province , info.addressComponent.city];
    [self.btnPoi setTitle:poiName forState:UIControlStateNormal];
    if(chart){
        if(self.personTag == 0){
            chart.FirstPoiName = [poiName copy];
            chart.FirstPoi = [NSString stringWithFormat:@"%f|%f", info.geoPt.longitude, info.geoPt.latitude];
        }else{
            chart.SecondPoiName = [poiName copy];
            chart.SecondPoi = [NSString stringWithFormat:@"%f|%f", info.geoPt.longitude, info.geoPt.latitude];
        }
    }
}

#pragma mark - ASPickerViewDelegate Method
- (void)asPickerViewDidSelected:(ASPickerView *)picker{
    if(self.picker.trigger == self.btnDate){
        self.person.Birth = [self.picker pickerDate];
    }else if(self.picker.trigger == self.btnTime){
        self.person.Birth = [self.picker pickerDate];
    }else if(self.picker.trigger == self.btnTimeZone){
        self.person.TimeZone = [self.picker selectedRowInComponent:0];
    }
    [self reloadData];
}

@end
