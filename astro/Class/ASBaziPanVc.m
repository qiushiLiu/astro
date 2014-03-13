//
//  ASBaiPanVc.m
//  astro
//
//  Created by kjubo on 14-3-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaziPanVc.h"

@interface ASBaziPanVc ()
@property (nonatomic, strong) UIImageView *pan;
@end

@implementation ASBaziPanVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mod = [[BaziMod alloc] init];
    self.mod.delegate = self;
	// Do any additional setup after loading the view.
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 485)];
    [self.contentView addSubview:self.pan];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showWaiting];
    [self.mod load:@"pp/TimeToBaZi" params:nil];
}

- (void)modelLoadFinished:(ASObject *)sender{
    [super modelLoadFinished:sender];
    [self hideWaiting];
    self.pan.image = [self.mod paipan];
}

@end
