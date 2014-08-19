//
//  ASAstroStarsFillVc.m
//  astro
//
//  Created by kjubo on 14-8-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASAstroStarsFillVc.h"
#import "AstroMod.h"

@interface ASAstroStarsFillVc ()
@property (nonatomic, strong) NSMutableArray *starsButton;
@property (nonatomic) NSInteger permit;
@end

@implementation ASAstroStarsFillVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.starsButton = [NSMutableArray array];
    self.permit = [AstroMod getStarsPermit];
    
    self.title = @"星体显示";
    self.navigationItem.leftBarButtonItem = nil;
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"保存"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    CGFloat top = 10;
    for(int i = 0; i < 2; i++){
        UIView *view = [self newGroupView:i];
        view.centerX = self.contentView.width/2;
        view.top = top;
        [self.contentView addSubview:view];
        
        top = view.bottom + 10;
    }
    self.contentView.contentSize = CGSizeMake(self.contentView.width, top);
    
}

- (UIView *)newGroupView:(NSInteger)tag{
    NSArray *stars = tag == 0 ? AstroPlanetPermit : AstroAsteroidPermit;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 1)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 4;
    view.layer.borderColor = [UIColor lightGrayColor].CGColor;
    view.layer.borderWidth = 1;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, view.width - 10, 30)];
    titleView.layer.cornerRadius = 4;
    titleView.backgroundColor = ASColorOrange;
    [view addSubview:titleView];
    
    for(int i = 0; i < 2 ; i++){
        UILabel *lb0 = [[UILabel alloc] init];
        lb0.backgroundColor = [UIColor clearColor];
        lb0.textColor = [UIColor whiteColor];
        lb0.font = [UIFont boldSystemFontOfSize:14];
        lb0.text = tag == 0 ? @"星体" : @"小行星";
        [lb0 sizeToFit];
        lb0.center = CGPointMake(titleView.width/8 + i * titleView.width/2, titleView.height/2);
        [titleView addSubview:lb0];
        
        UILabel *lb1 = [[UILabel alloc] init];
        lb1.backgroundColor = [UIColor clearColor];
        lb1.textColor = [UIColor whiteColor];
        lb1.font = [UIFont boldSystemFontOfSize:14];
        lb1.text = @"是否显示";
        [lb1 sizeToFit];
        lb1.center = CGPointMake(titleView.width/8*3 + i * titleView.width/2, titleView.height/2);
        [titleView addSubview:lb1];
    }
    
    CGFloat top = titleView.bottom + 20;
    for(int i = 0; i < [stars count]; i++){
        int mod = i % 2;
        UILabel *lb0 = [[UILabel alloc] init];
        lb0.backgroundColor = [UIColor clearColor];
        lb0.textColor = [UIColor blackColor];
        lb0.font = [UIFont systemFontOfSize:14];
        lb0.text = stars[i];
        [lb0 sizeToFit];
        lb0.center = CGPointMake(titleView.width/8 + mod * titleView.width/2, top);
        [view addSubview:lb0];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick_selected:) forControlEvents:UIControlEventTouchUpInside];
        if((self.permit & (1<<i)) > 0){
            [btn setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
        }
        [self.starsButton addObject:btn];
        btn.center = CGPointMake(titleView.width/8*3 + mod * titleView.width/2, lb0.centerY);
        [view addSubview:btn];
        
        if(mod == 1){
            top = btn.bottom + 10;
            view.height = btn.bottom + 5;
        }
    }
    return view;
}

- (void)btnClick_selected:(UIButton *)sender{
    BOOL selected = (self.permit & (1<<sender.tag)) > 0;
    selected = !selected;
    if(selected){
        [sender setImage:[UIImage imageNamed:@"btn_check_on"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"btn_check_off"] forState:UIControlStateNormal];
    }
    self.permit ^= 1<<sender.tag;
}

- (void)btnClick_navBack:(UIButton *)sender{
    [AstroMod setStarsPermit:self.permit];
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
