//
//  ASAstroTransitVc.m
//  astro
//
//  Created by kjubo on 14-9-12.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAstroTransitVc.h"

@interface ASAstroTransitVc ()
@property (nonatomic, strong) UIButton *btnDate;
@property (nonatomic, strong) UIButton *btnPoi;     //地址
@property (nonatomic, strong) ASPickerView *picker;
@end

@implementation ASAstroTransitVc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    UIView *titleView = [ASControls titleView:CGRectMake(left, top, 280, 30) title:@"请输入推运信息"];
    [self.contentView addSubview:titleView];
    top = titleView.bottom + 10;
    
    UILabel *lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"推 运 到";
    [self.contentView addSubview:lb];
    
    self.btnDate = [self newPickerButton:CGRectMake(lb.right + 10, top, 100, 30)];
    [self.btnDate setTitle:@"请选择日期" forState:UIControlStateNormal];
    [self.btnDate addTarget:self action:@selector(btnClick_picker:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnDate];
    top = self.btnDate.bottom + 10;
    
    lb = [self newPerfixTextLabel];
    lb.origin = CGPointMake(titleView.left, top);
    lb.text = @"推运地点";
    [self.contentView addSubview:lb];
    
    self.btnPoi = [self newPickerButton:CGRectMake(lb.right + 10, top, 160, 30)];
    [self.btnPoi setTitle:@"请选择出生城市" forState:UIControlStateNormal];
    self.btnPoi.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.btnPoi addTarget:self action:@selector(btnClick_poi:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.btnPoi];
    
    self.picker = [[ASPickerView alloc] initWithParentViewController:self];
    self.picker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData{
    [self.btnDate setTitle:[self.transitTime toStrFormat:@"yyyy-MM-dd"] forState:UIControlStateNormal];
    [self.btnPoi setTitle:self.transitPosition.name forState:UIControlStateNormal];
}

- (void)btnClick_picker:(UIButton *)sender{
    self.picker.trigger = sender;
    if(self.btnDate == sender){
        self.picker.trigger = sender;
        [self.picker setDatePickerMode:UIDatePickerModeDate selected:self.transitTime];
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
    [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - ASPoiDelegate
- (void)asPoiMap:(CLLocation *)location poiName:(NSString *)poiName{
    self.transitPosition.name = poiName;
    self.transitPosition.latitude = location.coordinate.latitude;
    self.transitPosition.longitude = location.coordinate.longitude;
    [self reloadData];
}

#pragma mark - ASPickerViewDelegate Method
- (void)asPickerViewDidSelected:(ASPickerView *)picker{
    if(self.picker.trigger == self.btnDate){
        self.transitTime = [self.picker pickerDate];
    }
    [self reloadData];
}
@end
