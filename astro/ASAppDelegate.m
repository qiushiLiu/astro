//
//  ASAppDelegate.m
//  astro
//
//  Created by kjubo on 13-12-15.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASNav.h"

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //第一次活跃
//    self.firstActiveTag = YES;
    //设置状态栏
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleBlackOpaque;
    //可以接收服务器推送消息
    [UIApplication.sharedApplication registerForRemoteNotificationTypes:(UIRemoteNotificationTypeSound |
                                                                         UIRemoteNotificationTypeBadge |
                                                                         UIRemoteNotificationTypeAlert)];
    
    //设置时区
    NSTimeZone *tzGMT = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [NSTimeZone setDefaultTimeZone:tzGMT];
    
    //解析
    if (launchOptions) {
        //推送的消息
        NSDictionary *p1 = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (p1) {
        }
    }
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0x80776d)];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName
                                                           ,[UIFont boldSystemFontOfSize:18], NSFontAttributeName
                                                           ,nil]];
    
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    //初始化导航
    UINavigationController *nc = [[ASNav shared] newNav:vcLogin];
    self.nav = nc;
    
    //设置rootViewController
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
//    //兼容ios7
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        [application setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.window.clipsToBounds =YES;
//        self.window.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height - 20);
//        self.window.bounds = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
//    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
