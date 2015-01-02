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
#import "ASPaiPanMainVc.h"

#import "UITabBarItem+Universal.h"

@interface ASTabMainVc ()
//@property (nonatomic, strong)UINavigationController *vcApplication;
@property (nonatomic, strong)UINavigationController *ncAsk;
@property (nonatomic, strong)UINavigationController *ncPaipan;
@property (nonatomic, strong)UINavigationController *ncUserCenter;
//@property (nonatomic, strong)UINavigationController *ncLesson;

@end

@implementation ASTabMainVc

- (id)init{
    if(self = [super init]){
        self.delegate = self;
        
//        self.vcApplication = [[ASNav shared] newNav:vcAsk];
//        self.vcApplication.tabBarItem =[UITabBarItem itemWithTitle:@"应用" image:[UIImage imageNamed:@"icon_mod_1"] selectedImage:[UIImage imageNamed:@"icon_mod_1_hl"]];
        self.ncAsk = [[ASNav shared] newNav:vcAsk];
        self.ncAsk.tabBarItem =[UITabBarItem itemWithTitle:@"咨询" image:[UIImage imageNamed:@"icon_mod_2"] selectedImage:[UIImage imageNamed:@"icon_mod_2_hl"]];
        self.ncPaipan = [[ASNav shared] newNav:vcPanMain];
        self.ncPaipan.tabBarItem = [UITabBarItem itemWithTitle:@"排盘" image:[UIImage imageNamed:@"icon_mod_3"] selectedImage:[UIImage imageNamed:@"icon_mod_3_hl"]];
//        self.ncLesson = [[ASNav shared] newNav:vcRegister];
//        self.ncLesson.tabBarItem = [UITabBarItem itemWithTitle:@"课程" image:[UIImage imageNamed:@"icon_mod_4"] selectedImage:[UIImage imageNamed:@"icon_mod_4_hl"]];
        self.ncUserCenter = [[ASNav shared] newNav:vcUserCenter];
        self.ncUserCenter.tabBarItem = [UITabBarItem itemWithTitle:@"我的" image:[UIImage imageNamed:@"icon_mod_5"] selectedImage:[UIImage imageNamed:@"icon_mod_5_hl"]];
        [self setViewControllers:[NSArray arrayWithObjects:self.ncAsk, self.ncPaipan, self.ncUserCenter, nil]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification:) name:Notification_MainVc object:nil];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)notification:(NSNotification *)sender{
    if([sender.name isEqual:Notification_MainVc]){
        self.selectedIndex = 0;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if(viewController == self.ncUserCenter
       && ![ASGlobal isLogined]){
        UINavigationController *nc = [[ASNav shared] newNav:vcLogin];
        [self presentViewController:nc animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
