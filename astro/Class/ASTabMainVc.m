//
//  ASMainVc.m
//  astro
//
//  Created by kjubo on 14-2-8.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//
#import "ASNav.h"
#import "ASTabMainVc.h"
#import "ASLoginVc.h"
#import "ASForgetPswVc.h"
#import "ASRegisterVc.h"

@interface ASTabMainVc ()
@property (nonatomic, strong)UINavigationController *vcLogin;
@property (nonatomic, strong)UINavigationController *ncAsk;
@property (nonatomic, strong)UINavigationController *vcRegister;
@end

@implementation ASTabMainVc

- (id)init{
    if(self = [super init]){
        self.vcLogin = [[ASNav shared] newNav:vcForgetPsw];
        self.vcLogin.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_mod_1"] selectedImage:[UIImage imageNamed:@"icon_mod_1_hl"]];
        self.ncAsk = [[ASNav shared] newNav:vcAsk];
        self.ncAsk.tabBarItem =[[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_mod_2"] selectedImage:[UIImage imageNamed:@"icon_mod_2_hl"]];
        self.vcRegister = [[ASNav shared] newNav:vcRegister];
        self.vcRegister.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[UIImage imageNamed:@"icon_mod_3"] selectedImage:[UIImage imageNamed:@"icon_mod_3_hl"]];
        
        [self setViewControllers:[NSArray arrayWithObjects:self.vcLogin, self.ncAsk, self.vcRegister, nil]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
