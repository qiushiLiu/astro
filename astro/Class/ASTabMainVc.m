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
#import "UITabBarItem+Universal.h"

@interface ASTabMainVc ()
@property (nonatomic, strong)UINavigationController *vcLogin;
@property (nonatomic, strong)UINavigationController *ncAsk;
@property (nonatomic, strong)UINavigationController *ncRegister;
@property (nonatomic, strong)UINavigationController *ncUserCenter;
@property (nonatomic, strong)UINavigationController *ncLesson;
@end

@implementation ASTabMainVc

- (id)init{
    if(self = [super init]){
        self.vcLogin = [[ASNav shared] newNav:vcLogin];
        self.vcLogin.tabBarItem =[UITabBarItem itemWithTitle:@"应用" image:[UIImage imageNamed:@"icon_mod_1"] selectedImage:[UIImage imageNamed:@"icon_mod_1_hl"]];
        self.ncAsk = [[ASNav shared] newNav:vcAsk];
        self.ncAsk.tabBarItem =[UITabBarItem itemWithTitle:@"咨询" image:[UIImage imageNamed:@"icon_mod_2"] selectedImage:[UIImage imageNamed:@"icon_mod_2_hl"]];
        self.ncRegister = [[ASNav shared] newNav:vcRegister];
        self.ncRegister.tabBarItem = [UITabBarItem itemWithTitle:@"排盘" image:[UIImage imageNamed:@"icon_mod_3"] selectedImage:[UIImage imageNamed:@"icon_mod_3_hl"]];
        self.ncUserCenter = [[ASNav shared] newNav:vcRegister];
        self.ncUserCenter.tabBarItem = [UITabBarItem itemWithTitle:@"课程" image:[UIImage imageNamed:@"icon_mod_4"] selectedImage:[UIImage imageNamed:@"icon_mod_4_hl"]];
        self.ncLesson = [[ASNav shared] newNav:vcRegister];
        self.ncLesson.tabBarItem = [UITabBarItem itemWithTitle:@"我的" image:[UIImage imageNamed:@"icon_mod_5"] selectedImage:[UIImage imageNamed:@"icon_mod_5_hl"]];
        [self setViewControllers:[NSArray arrayWithObjects:self.vcLogin, self.ncAsk, self.ncRegister, self.ncUserCenter, self.ncLesson, nil]];
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
