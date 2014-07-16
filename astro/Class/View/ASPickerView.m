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

@property (nonatomic) UIDatePickerMode datePickerMode;
@property (nonatomic, strong) NSArray *dataSource;
@end

@implementation ASPickerView

- (id)initWithParentViewController:(ASBaseViewController *)vc
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 202)];
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
        
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
        self.datePicker.top = btnView.bottom;
        [self addSubview:self.datePicker];
        
        self.picker = [[UIPickerView alloc] initWithFrame:self.datePicker.frame];
        self.picker.delegate = self;
        [self addSubview:self.picker];
    }
    return self;
}

- (void)setDataSource:(NSArray *)data selected:(id)selected{
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
    if(selected){
        NSArray *sl = nil;
        if(![selected isKindOfClass:[NSArray class]]){
            sl = @[selected];
        }else{
            sl = selected;
        }
        for(int i = 0; i < [sl count]; i++){
            NSInteger index = [sl[i] intValue];
            if(index < 0){
                index = 0;
            }
            [self.picker selectRow:index inComponent:i animated:YES];
        }
    }
}

- (void)setDatePickerMode:(UIDatePickerMode)datePickerMode selected:(NSDate *)date{
    _datePickerMode = datePickerMode;
    _dataSource = nil;
    [self reloadPicker];
    if(date){
        self.datePicker.date = date;
    }else{
        self.datePicker.date = [NSDate date];
    }
}

- (NSDate *)pickerDate{
    return [self.datePicker.date copy];
}

- (void)reloadPicker{
    if(self.datePickerMode < 0){    //自定义模式
        self.picker.hidden = NO;
        self.datePicker.hidden = YES;
        [self.picker reloadAllComponents];
    }else{
        self.picker.hidden = YES;
        self.datePicker.hidden = NO;
        self.datePicker.datePickerMode = self.datePickerMode;
        if(self.datePickerMode == UIDatePickerModeDate){
            self.datePicker.minimumDate = [[NSDate alloc] initWithYear:1900 month:1 day:1 hour:0 minute:0 second:0];
            self.datePicker.maximumDate = [[NSDate alloc] initWithYear:2200 month:12 day:31 hour:23 minute:59 second:59];
        }
        self.datePicker.date = [NSDate date];
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
