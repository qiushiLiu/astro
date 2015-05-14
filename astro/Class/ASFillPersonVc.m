//
//  ASFillPersonVc.m
//  astro
//
//  Created by kjubo on 14-7-4.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASFillPersonVc.h"
#import "ZJSwitch.h"
#import "ASHistoryPersonTableView.h"

@interface ASFillPersonVc ()
@property (nonatomic) NSInteger type;   //0:Astro  1:BaZi&ZiWei
@property (nonatomic, strong) ASPickerView *picker; //选择器
@property (nonatomic, strong) UIButton *btnDate;
@property (nonatomic, strong) UIButton *btnTime;
@property (nonatomic, strong) ZJSwitch *swDaylight; //夏令时
@property (nonatomic, strong) ZJSwitch *swRealTime; //真太阳时
@property (nonatomic, strong) UIButton *btnTimeZone;//时区
@property (nonatomic, strong) ZJSwitch *swGender;   //性别
@property (nonatomic, strong) UIView *viewTimeZone; //时区
@property (nonatomic, strong) UIView *viewRealTime; //真时区
@property (nonatomic, strong) UIView *viewPoi;      //地址选择层
@property (nonatomic, strong) UIButton *btnPoi;     //地址
@property (nonatomic, strong) UIButton *btnCurrent; //当前位置
@end

@implementation ASFillPersonVc

- (id)initWithType:(NSInteger)type{
    if(self = [super init]){
        self.person = [[ASPerson alloc] init];
        self.type = type;
    }
    return self;
}

+ (NSString *)stringForBirth:(NSDate *)birth gender:(NSInteger)gender daylight:(NSInteger)daylight poi:(NSString *)poi timeZone:(NSInteger)timeZone{
    NSMutableString *str = [NSMutableString stringWithString:[birth toStrFormat:@"yyyy-MM-dd HH:mm"]];
    if(daylight > 0){
        [str appendString:@" 夏令时"];
    }
    if(gender == 1){
        [str appendString:@" 男"];
    }else{
        [str appendString:@" 女"];
    }
    [str appendString:@" "];
    if([poi length] > 0){
        [str appendString:poi];
        [str appendString:@" "];
    }
    [str appendString:TimeZoneArray[timeZone + 12]];
    return str;
}

+ (NSString *)stringForBirth:(NSDate *)birth gender:(NSInteger)gender daylight:(NSInteger)daylight poi:(NSString *)poi{
    NSMutableString *str = [NSMutableString stringWithString:[birth toStrFormat:@"yyyy-MM-dd HH:mm"]];
    if(daylight > 0){
        [str appendString:@" 夏令时"];
    }
    if(gender == 1){
        [str appendString:@" 男"];
    }else{
        [str appendString:@" 女"];
    }
    [str appendString:@" "];
    if([poi length] > 0){
        [str appendString:poi];
        [str appendString:@" "];
    }
    return str;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"当事人信息";
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"确定"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat top = 20;
    CGFloat left = 20;
    
    UIView *titleView = [ASControls titleView:CGRectMake(left, top, 280, 30) title:@"请输入当事人信息"];
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
    [self.swDaylight addTarget:self action:@selector(sw_change:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.swDaylight];
    top = self.swDaylight.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"性       别";
    [self.contentView addSubview:lb];
    
    self.swGender = [[ZJSwitch alloc] initWithFrame:CGRectMake(lb.right + 10, top, 80, 30)];
    self.swGender.textFont = [UIFont systemFontOfSize:16];
    self.swGender.offText = @"女";
    self.swGender.onText = @"男";
    [self.swGender setTintColor:ASColorBlue];
    [self.swGender setOnTintColor:ASColorDarkRed];
    [self.swGender addTarget:self action:@selector(sw_change:) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:self.swGender];
    top = self.swGender.bottom + 10;
    
    self.viewTimeZone = [[UIView alloc] initWithFrame:CGRectMake(titleView.left, top, 300, 30)];
    [self.contentView addSubview:self.viewTimeZone];
    
    lb = [self newPerfixTextLabel];
    lb.text = @"所属时区";
    [self.viewTimeZone addSubview:lb];
    
    self.btnTimeZone = [self newPickerButton:CGRectMake(lb.right + 10, 0, 100, 30)];
    [self.btnTimeZone setTitle:@"东8区" forState:UIControlStateNormal];
    [self.btnTimeZone addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewTimeZone addSubview:self.btnTimeZone];

    self.viewRealTime = [[UIView alloc] initWithFrame:CGRectMake(titleView.left, top, 300, 30)];
    self.viewRealTime.hidden = YES;
    [self.contentView addSubview:self.viewRealTime];
    lb = [self newPerfixTextLabel];
    lb.text = @"真太阳时";
    [self.viewRealTime addSubview:lb];
    
    self.swRealTime = [[ZJSwitch alloc] initWithFrame:CGRectMake(lb.right + 10, 0, 80, 30)];
    self.swRealTime.textFont = [UIFont systemFontOfSize:16];
    self.swRealTime.on = YES;
    self.swRealTime.offText = @"否";
    self.swRealTime.onText = @"是";
    [self.swRealTime setTintColor:ASColorBlue];
    [self.swRealTime setOnTintColor:ASColorDarkRed];
    [self.swRealTime addTarget:self action:@selector(sw_change:) forControlEvents:UIControlEventValueChanged];
    [self.viewRealTime addSubview:self.swRealTime];

    top = self.viewRealTime.bottom + 10;

    self.viewPoi = [[UIView alloc] initWithFrame:CGRectMake(titleView.left, top, 300, 30)];
    [self.contentView addSubview:self.viewPoi];
    
    lb = [self newPerfixTextLabel];
    lb.text = @"出生地点";
    [self.viewPoi addSubview:lb];
    
    self.btnPoi = [self newPickerButton:CGRectMake(lb.right + 10, 0, 160, self.viewPoi.height)];
    [self.btnPoi setTitle:@"请选择出生城市" forState:UIControlStateNormal];
    self.btnPoi.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.btnPoi addTarget:self action:@selector(btnClick_poi:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewPoi addSubview:self.btnPoi];
    
    self.btnCurrent = [[UIButton alloc] initWithFrame:CGRectMake(self.btnPoi.right + 10, 0, 28, 28)];
    self.btnCurrent.centerY = self.btnPoi.centerY;
    [self.btnCurrent setImage:[UIImage imageNamed:@"icon_dingwei"] forState:UIControlStateNormal];
    [self.btnCurrent addTarget:self action:@selector(btnClick_getCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];
    [self.viewPoi addSubview:self.btnCurrent];
    
    self.picker = [[ASPickerView alloc] initWithParentViewController:self];
    self.picker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSAssert(self.person, @"person 不能为空!");
    [self reloadData];
}

- (void)reloadData{
    self.swDaylight.on = self.person.DayLight > 0;
    self.swGender.on = self.person.Gender > 0;
    [self.btnDate setTitle:[self.person.Birth toStrFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [self.btnTime setTitle:[self.person.Birth toStrFormat:@"hh:mm"] forState:UIControlStateNormal];
    [self.btnTimeZone setTitle:TimeZoneArray[self.person.TimeZone] forState:UIControlStateNormal];
    [self.btnPoi setTitle:self.person.poiName forState:UIControlStateNormal];
    if(self.type > 0){
        self.viewRealTime.hidden = NO;
        self.viewTimeZone.hidden = YES;
        [self.swRealTime setOn:self.person.RealTime];
    }else{
        self.viewRealTime.hidden = YES;
        self.viewTimeZone.hidden = NO;
    }
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

- (void)sw_change:(ZJSwitch *)sender{
    if(sender == self.swRealTime){
        self.person.RealTime = sender.on;
        self.viewPoi.hidden = !self.swRealTime.on;
    }else if(sender == self.swGender){
        self.person.Gender = self.swGender.on;
    }else if(sender == self.swDaylight){
        self.person.DayLight = self.swDaylight.on;
    }
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
    self.person.Gender = self.swGender.on;
    self.person.DayLight = self.swDaylight.on;
    ASPoiMapVc *vc = [[ASPoiMapVc alloc] init];
    vc.delegate = self;
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)btnClick_getCurrentLocation:(UIButton *)sender{
    if([GpsData shared].haveMKGpsTag){
        self.person.latitude = [GpsData shared].loc.coordinate.latitude;
        self.person.longitude = [GpsData shared].loc.coordinate.longitude;
        self.person.poiName = [[GpsData shared].placemark copy];
        [self reloadData];
    }else{
        [self alert:@"获取定位信息错误\n请确保已经在设置->隐私中打开定位功能。"];
    }
}

- (void)btnClick_navBack:(UIButton *)sender{
    self.person.DayLight = self.swDaylight.on ? 1 : 0;
    self.person.Gender = self.swGender.on ? 1 : 0;
    [[ASHistoryPersonTableView shared] addPerson:self.person];
    if([self.delegate respondsToSelector:@selector(ASFillPerson:trigger:)]){
        [self.delegate ASFillPerson:self.person trigger:self.trigger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ASPoiMapDelegate Method
- (void)asPoiMap:(CLLocation *)location poiName:(NSString *)poiName{
    self.person.poiName = poiName;
    self.person.latitude = location.coordinate.latitude;
    self.person.longitude = location.coordinate.longitude;
    [self.btnPoi setTitle:self.person.poiName forState:UIControlStateNormal];
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
