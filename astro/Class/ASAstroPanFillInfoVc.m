//
//  ASAstroPanFillInfoVc.m
//  astro
//
//  Created by kjubo on 14-7-30.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAstroPanFillInfoVc.h"
#import "ASQuestionButton.h"

@interface ASAstroPanFillInfoVc ()
@property (nonatomic, strong) UIButton *btnPanType;
@property (nonatomic, strong) ASQuestionButton *btnFirstPersonInfo; //第一当事人
@property (nonatomic, strong) ASQuestionButton *btnSecondPersonInfo;//第二当事人
@property (nonatomic, strong) ASQuestionButton *btnPermitInfo;      //容许度
@property (nonatomic, strong) ASQuestionButton *btnStarsInfo;       //星体信息
@property (nonatomic, strong) ASPickerView *panTypePicker;          //选择
@end

@implementation ASAstroPanFillInfoVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat left = 20, top = 20;
    UILabel *lb = [ASControls newRedTextLabel:CGRectMake(left, top, 80, 30)];
    lb.text = @"排盘类型";
    [self.contentView addSubview:lb];
    
    self.btnPanType = [ASControls newRedButton:CGRectMake(lb.right, top, 200, 30) title:@"本命盘"];
    [self.btnPanType addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPanType];
    top = self.btnPanType.bottom + 10;
    
    self.btnFirstPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_0" preFix:@"第一当事人"];
    self.btnFirstPersonInfo.centerX = self.contentView.width/2;
    [self.btnFirstPersonInfo addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnFirstPersonInfo];
    top = self.btnFirstPersonInfo.bottom + 10;
    
    self.btnSecondPersonInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_1" preFix:@"第二当事人"];
    self.btnSecondPersonInfo.centerX = self.contentView.width/2;
    [self.btnSecondPersonInfo addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnSecondPersonInfo];
    top = self.btnSecondPersonInfo.bottom + 10;
    
    self.btnPermitInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_2" preFix:@"相位容许度"];
    self.btnPermitInfo.centerX = self.contentView.width/2;
    [self.btnPermitInfo addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPermitInfo];
    top = self.btnPermitInfo.bottom + 10;
    
    self.btnStarsInfo = [[ASQuestionButton alloc] initWithFrame:CGRectMake(0, top, 280, 60) iconName:@"icon_fill_3" preFix:@"星体显示"];
    self.btnStarsInfo.centerX = self.contentView.width/2;
    [self.btnStarsInfo addTarget:self action:@selector(btnClick_fill:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnStarsInfo];
    
    self.panTypePicker = [[ASPickerView alloc] initWithParentViewController:self];
    self.panTypePicker.datePickerMode = -1;
    self.panTypePicker.delegate = self;
    self.panTypePicker.picker.delegate = self;
    self.panTypePicker.picker.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.btnStarsInfo setInfoText:[AstroMod getStarsPermitTextInfo]];
    [self.btnPermitInfo setInfoText:[AstroMod getAnglePermitTextInfo]];
    [self loadPersonInfo];
}

- (void)loadPersonInfo{
    [self.btnFirstPersonInfo setInfoText:[ASFillPersonVc stringForBirth:self.model.birth gender:self.model.Gender daylight:self.model.IsDaylight poi:self.model.position.name timeZone:self.model.zone]];
    [self.btnSecondPersonInfo setInfoText:[ASFillPersonVc stringForBirth:self.model.birth1 gender:self.model.Gender1 daylight:self.model.IsDaylight1 poi:self.model.position1.name timeZone:self.model.zone1]];
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btnClick_fill:(UIButton *)sender{
    if(sender == self.btnFirstPersonInfo){
        ASFillPersonVc *vc = [[ASFillPersonVc alloc] init];
        vc.delegate = self;
        vc.trigger = sender;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if(sender == self.btnSecondPersonInfo){
        ASFillPersonVc *vc = [[ASFillPersonVc alloc] init];
        vc.delegate = self;
        vc.trigger = sender;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if(sender == self.btnPermitInfo){
        ASPermitInfoVc *vc = [[ASPermitInfoVc alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }else if(sender == self.btnStarsInfo){
        ASAstroStarsFillVc *vc = [[ASAstroStarsFillVc alloc] init];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nc animated:YES completion:nil];
    }
}

- (void)btnClick_picker:(UIButton *)sender{
    self.panTypePicker.trigger = sender;
    [self.panTypePicker showPickerView];
}

#pragma mark - ASFillPersonVc Delegate Method
- (void)ASFillPerson:(ASPerson *)person trigger:(id)trigger{
    if(trigger == self.btnFirstPersonInfo){
        self.model.Gender = person.Gender;
        self.model.birth = (NSDate<NSDate> *)person.Birth;
        self.model.zone = person.TimeZone;
        self.model.IsDaylight = person.Daylight;
        self.model.position.name = person.poiName;
        self.model.position.latitude = person.latitude;
        self.model.position.longitude = person.longitude;
    }else{
        self.model.Gender1 = person.Gender;
        self.model.birth1 = (NSDate<NSDate> *)person.Birth;
        self.model.zone1 = person.TimeZone;
        self.model.IsDaylight1 = person.Daylight;
        self.model.position1.name = person.poiName;
        self.model.position1.latitude = person.latitude;
        self.model.position1.longitude = person.longitude;
    }
    [self loadPersonInfo];
}

#pragma mark - ASPickerView Delegate
- (void)asPickerViewDidSelected:(ASPickerView *)picker{
    NSMutableString *str = [NSMutableString string];
    int type = [self.panTypePicker.picker selectedRowInComponent:0];
    int subType = [self.panTypePicker.picker selectedRowInComponent:1];
    [str appendString:AstroTypeArray[type]];
    switch (type) {
        case 1:
            [str appendString:@">"];
            [str appendString:AstroZuheArray[subType]];
            break;
        case 2:
            [str appendString:@">"];
            [str appendString:AstroTuiyunArray[subType]];
            break;
        default:
            break;
    }
    [self.btnPanType setTitle:str forState:UIControlStateNormal];
}

#pragma mark - UIPickerView DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(component == 0){
        return [AstroTypeArray count];
    }else if(component == 1){
        NSInteger rowCount = 0;
        switch ([self.panTypePicker.picker selectedRowInComponent:0]) {
            case 0:
                rowCount = 0;
                break;
            case 1:
                rowCount = [AstroZuheArray count];
                break;
            case 2:
                rowCount = [AstroTuiyunArray count];
                break;
            default:
                break;
        }
        return rowCount;
    }
    return 0;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    NSString *title = nil;
    if(component == 0){
        title = [AstroTypeArray objectAtIndex:row];
    }else if(component == 1){
        switch ([self.panTypePicker.picker selectedRowInComponent:0]) {
            case 1:
                title = [AstroZuheArray objectAtIndex:row];
                break;
            case 2:
                title = [AstroTuiyunArray objectAtIndex:row];
                break;
            default:
                break;
        }
    }
    
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setFont:[UIFont boldSystemFontOfSize:16]];
    }
    if(component == 0){
        tView.textAlignment = NSTextAlignmentCenter;
    }else{
        tView.textAlignment = NSTextAlignmentLeft;
    }
    // Fill the label text here
    tView.text = title;
    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if(component == 0){
        return 90;
    }
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(component == 0){
        [self.panTypePicker.picker reloadAllComponents];
    }
}

@end
