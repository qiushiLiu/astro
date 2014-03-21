//
//  ASBaiPanVc.m
//  astro
//
//  Created by kjubo on 14-3-6.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaziPanVc.h"
#import "ASZiWeiGrid.h"
#import "ZiWeiStar.h"
#import "AstroStar.h"
#import "Paipan.h"

@interface ASBaziPanVc ()
@property (nonatomic, strong) UIImageView *pan;
@property (nonatomic, strong) NSMutableArray *gongs;
@property (nonatomic, strong) ASZiWeiGrid *lastSelected;
@end

@implementation ASBaziPanVc

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.gongs = [[NSMutableArray alloc] init];
    
    self.bazi = [[BaziMod alloc] init];
    self.bazi.delegate = self;
    
    self.ziwei = [[ZiWeiMod alloc] init];
    self.ziwei.delegate = self;
    
    self.astro = [[AstroMod alloc] init];
    self.astro.delegate = self;
	// Do any additional setup after loading the view.
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.pan];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self showWaiting];
    [self.astro load:@"pp/TimeToAstro" params:nil];
//    [self.ziwei load:@"pp/TimeToZiWei" params:nil];
//    [self.mod load:@"pp/TimeToBaZi" params:nil];
}

- (void)modelLoadFinished:(ASObject *)sender{
    [super modelLoadFinished:sender];
    self.pan.image = [self.astro paipan];
    self.pan.size = self.pan.image.size;
    self.contentView.contentSize = CGSizeMake(self.contentView.width, 560);
    [self hideWaiting];
}

- (void)gongSelected:(ASZiWeiGrid *)sender{
    if(self.lastSelected
       && self.lastSelected !=  sender){
        self.lastSelected.selected = NO;
    }
    self.lastSelected = sender;
    sender.selected = !sender.selected;
}

@end
