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
    
    self.mod = [[BaziMod alloc] init];
    self.mod.delegate = self;
    
    self.ziwei = [[ZiWeiMod alloc] init];
    self.ziwei.delegate = self;
	// Do any additional setup after loading the view.
    
    self.pan = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.pan];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self showWaiting];
    [self.ziwei load:@"pp/TimeToZiWei" params:nil];
//    [self.mod load:@"pp/TimeToBaZi" params:nil];
}

- (void)modelLoadFinished:(ASObject *)sender{
    [super modelLoadFinished:sender];
//    self.pan.image = [self.ziwei paipan];
//    self.pan.size = self.pan.image.size;
    self.contentView.contentSize = CGSizeMake(self.contentView.width, 560);
    
    for(int i = 0; i < 12; i++){
        ZiWeiGong *g = [self.ziwei.Gong objectAtIndex:i] ;
        ASZiWeiGrid *gd = [[ASZiWeiGrid alloc] initWithGong:g index:i];
        [gd addTarget:self action:@selector(gongSelected:) forControlEvents:UIControlEventTouchUpInside];
        NSMutableString *gn = [[NSMutableString alloc] initWithString:[__ZiWeiGong objectAtIndex:g.GongName]];
        if(self.ziwei.Shen == i){
            if(self.ziwei.Ming == i){
                [gn replaceCharactersInRange:NSMakeRange(0, 1) withString:@"命"];
            }
            [gn replaceCharactersInRange:NSMakeRange(1, 1) withString:@"★"];
            [gn replaceCharactersInRange:NSMakeRange(2, 1) withString:@"身"];
        }
        [gd setGongName:gn];
        [self.gongs addObject:gd];
        [self.contentView addSubview:gd];
    }
    
    for(int i = 0; i < [self.ziwei.Xing count]; i++){
        if(i == 58 ||  i == 59 || i == 62 || i == 63 || i == 66 || i == 64 || i == 67){
            continue;
        }
        ZiWeiStar *star = [self.ziwei.Xing objectAtIndex:i];
        ASZiWeiGrid *gd = [self.gongs objectAtIndex:star.Gong];
        [gd addStar:star withIndex:i];
    }
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
