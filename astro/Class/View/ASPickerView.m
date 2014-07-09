//
//  ASPickerView.m
//  astro
//
//  Created by kjubo on 14-7-7.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPickerView.h"

@interface ASPickerView ()
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIButton *btnCancel;
@property (nonatomic, strong) UIButton *btnOk;
@end

@implementation ASPickerView

- (id)initWithFrame:(CGRect)frame parentViewController:(ASBaseViewController *)vc
{
    self = [super initWithFrame:frame];
    if (self) {
        self.parentVc = vc;
        self.hidden = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self.parentVc.view addSubview:self];
        
        UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        btnView.backgroundColor = ASColorDarkGray;
        [self addSubview:btnView];
        
        self.btnCancel = [ASControls newMMButton:CGRectMake(0, 0, 120, 32) title:@"取消"];
        self.btnCancel.centerX = btnView.width/4;
        self.btnCancel.centerY = btnView.height/2;
        [self.btnCancel addTarget:self action:@selector(btnClick_cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnCancel];
        
        self.btnOk = [ASControls newRedButton:CGRectMake(0, 0, 120, 32) title:@"确定"];
        self.btnOk.centerX = btnView.width * 0.75;
        self.btnOk.centerY = btnView.height/2;
        [self.btnOk addTarget:self action:@selector(btnClick_submit:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnOk];
        
        self.picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, btnView.bottom, self.width, self.height - btnView.height)];
        self.picker.delegate = self;
        [self addSubview:self.picker];
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:self.picker.frame];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        [self addSubview:self.datePicker];
    }
    return self;
}

- (void)setDataSource:(NSArray *)data{
    if(!data){
        return;
    }
    _datePickerMode = - 1;
    id firstObj = [data firstObject];
    if(firstObj && [firstObj isKindOfClass:[NSArray class]]){
        _dataSource = [data copy];
    }else{
        _dataSource = [NSArray arrayWithObjects:data, nil];
    }
    [self reloadPicker];
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode{
    _datePickerMode = datePickerMode;
    self.dataSource = nil;
    [self reloadPicker];
}

- (void)reloadPicker{
    if(self.datePickerMode < 0){    //自定义模式
        self.picker.hidden = NO;
        self.datePicker.hidden = YES;
        [self.picker reloadAllComponents];
    }else{
        self.picker.hidden = NO;
        self.datePicker.hidden = YES;
        [self.datePicker reloadInputViews];
    }
}

- (void)showPickerView{
    self.top = self.parentVc.view.height;
    self.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottom = self.parentVc.view.height;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidePickerView{
    self.bottom = self.parentVc.view.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.top = self.parentVc.view.height;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

#pragma mark - UIPickerView DataSource
- (NSInteger)selectedRowInComponent:(NSInteger)component{
    return [self.picker selectedRowInComponent:component];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [self.dataSource count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray *items = [self.dataSource objectAtIndex:component];
    return [items count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSArray *items = [self.dataSource objectAtIndex:component];
    return [items objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 44;
}

- (void)btnClick_cancel:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(asPickerViewDidCancel:)]){
        [self.delegate asPickerViewDidCancel:self];
    }
    [self hidePickerView];
}

- (void)btnClick_submit:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(asPickerViewDidSelected:)]){
        [self.delegate asPickerViewDidSelected:self];
    }
    [self hidePickerView];
}

@end
