//
//  ASPaiPanMainVc.m
//  astro
//
//  Created by kjubo on 14-7-28.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPaiPanMainVc.h"
#import "ASAstroPanVc.h"
#import "ASBaZiPanVc.h"
#import "ASZiWeiPanVc.h"
#import "ASDiceViewController.h"

@interface ASPaiPanMainVc ()

@end

@implementation ASPaiPanMainVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"排盘"];
    self.navigationItem.leftBarButtonItem = nil;
    
    for(int i = 0; i < [PanTypeArray count]; i++ ){
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 85)];
        btn.tag = i;
        int col = i % 3;
        int row = i / 3;
        if(col == 0){
            btn.centerX = 60;
        }else if(col == 1){
            btn.centerX = 160;
        }else if(col == 2){
            btn.centerX = 260;
        }
        btn.top = 40 + row * 95;
        [btn addTarget:self action:@selector(btnClick_panType:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"pan_icon_%@", @(i + 1)]]];
        [btn addSubview:iv];
        
        UILabel *lb = [[UILabel alloc] init];
        lb.backgroundColor = [UIColor clearColor];
        lb.font = [UIFont systemFontOfSize:14];
        lb.text = PanTypeArray[i];
        [lb sizeToFit];
        lb.bottom = btn.height - 5;
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
    if(sender.tag == 0){
        ASAstroPanVc *vc = [[ASAstroPanVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(sender.tag == 1){
        ASZiWeiPanVc *vc = [[ASZiWeiPanVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(sender.tag == 2){
        ASBaZiPanVc *vc = [[ASBaZiPanVc alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if(sender.tag == 3){
        ASDiceViewController *vc = [[ASDiceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
