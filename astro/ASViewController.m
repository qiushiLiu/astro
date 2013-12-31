//
//  ASViewController.m
//  astro
//
//  Created by kjubo on 13-12-15.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASViewController.h"
#import "ASUrlImageView.h"
@interface ASViewController ()

@end

@implementation ASViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    ASUrlImageView *iv = [[ASUrlImageView alloc] initWithFrame:CGRectMake(50, 150, 200, 100)];
    [iv load:@"http://img2081.poco.cn/mypoco/myphoto/20120203/21/64674696201202032152192010246402235_006.jpg" cacheDir:nil];
    [self.view addSubview:iv];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
