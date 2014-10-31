//
//  ASPaiPanMainVc.m
//  astro
//
//  Created by kjubo on 14-7-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPaiPanMainVc.h"

@interface ASPaiPanMainVc ()

@end

@implementation ASPaiPanMainVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"占星排盘"];
    self.navigationItem.leftBarButtonItem = nil;
    
    for(int i = 1; i <= 1; i++ ){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 62, 80)];
        btn.tag = i;
        if(i == 1){
            btn.centerX = 60;
        }else if(i == 2){
            btn.centerX = 160;
        }else{
            btn.centerX = 260;
        }
        [btn addTarget:self action:@selector(btnClick_panType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"pan_icon_%d", i]]];
        [btn addSubview:iv];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = PanTypeArray[i - 1];
        [lb sizeToFit];
        lb.top = iv.bottom + 5;
        lb.centerX = btn.width/2;
        [btn addSubview:lb];
        
        [self.contentView addSubview:btn];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (BOOL) hidesBottomBarWhenPushed
{
    return (self.navigationController.topViewController != self);
}


- (void)btnClick_panType:(UIButton *)sender{
    [self navTo:vcBaziPan params:@{@"type" : @(sender.tag)}];
}

@end
