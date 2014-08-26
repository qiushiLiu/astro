//
//  ASPermitInfoVc.m
//  astro
//
//  Created by kjubo on 14-8-25.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPermitInfoVc.h"
#import "ZJSwitch.h"
#import "AstroMod.h"
@interface ASPermitInfoVc ()
@property (nonatomic, strong) NSMutableArray *switches;
@property (nonatomic, strong) NSMutableArray *sliders;
@property (nonatomic, strong) NSMutableArray *permit;
@end

@implementation ASPermitInfoVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.switches = [NSMutableArray array];
    self.sliders = [NSMutableArray array];
    self.permit = [NSMutableArray arrayWithArray:[AstroMod getAnglePermit]];
    
    self.title = @"容许度设置";
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat top = 30;
    for(int i = 0; i < 5; i++){
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, top, 50, 30)];
        lb.textAlignment = NSTextAlignmentCenter;
        lb.backgroundColor = [UIColor clearColor];
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont boldSystemFontOfSize:16];
        lb.text = AstroAnglePermit[i];
        lb.layer.borderColor = ASColorDarkRed.CGColor;
        lb.layer.borderWidth = 1;
        lb.layer.cornerRadius = 6;
        [self.contentView addSubview:lb];
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(lb.right + 15, 0, 150, 16)];
        slider.tag = i;
        slider.centerY = lb.centerY;
        slider.maximumValue = 10;
        slider.minimumValue = 0;
        slider.maximumTrackTintColor = ASColorBlue;
        slider.minimumTrackTintColor = ASColorDarkRed;
        [slider addTarget:self action:@selector(slider_change:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:slider];
        [self.sliders addObject:slider];
        
        ZJSwitch *sw  = [[ZJSwitch alloc] initWithFrame:CGRectMake(slider.right + 15, 0, 65, 20)];
        sw.tag = i;
        sw.centerY = lb.centerY;
        sw.textFont = [UIFont systemFontOfSize:13];
        sw.offText = @"关闭";
        [sw addTarget:self action:@selector(switch_change:) forControlEvents:UIControlEventValueChanged];
        [sw setTintColor:ASColorBlue];
        [sw setOnTintColor:ASColorDarkRed];
        [self.contentView addSubview:sw];
        [self.switches addObject:sw];
        
        top = lb.bottom + 30;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadPermit];
}

- (void)loadPermit{
    for(int i = 0; i < [AstroAnglePermit count]; i++){
        int value = [self.permit[i] intValue];
        ZJSwitch *sw = self.switches[i];
        UISlider *slider = self.sliders[i];
        slider.value = abs(value);
        sw.onText = [NSString stringWithFormat:@"%d°", value];
        [sw setOn:(value > 0)];
    }
}

- (void)slider_change:(UISlider *)sender{
    int value = round(sender.value);
    sender.value = value;
    ZJSwitch *sw = self.switches[sender.tag];
    sw.onText = [NSString stringWithFormat:@"%d°", value];
}

- (void)switch_change:(ZJSwitch *)sender{
    UISlider *slider = self.sliders[sender.tag];
    slider.enabled = sender.on;
    int value = round(slider.value);
    sender.onText = [NSString stringWithFormat:@"%d°", value];
}

- (void)btnClick_navBack:(UIButton *)sender{
    for(int i = 0; i < [AstroAnglePermit count]; i++){
        ZJSwitch *sw = self.switches[i];
        UISlider *sl = self.sliders[i];
        self.permit[i] = @(sw.on ? (int)sl.value : (int)(-sl.value));
        [AstroMod setAnglePermit:self.permit];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
