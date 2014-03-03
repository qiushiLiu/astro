//
//  ASAppDelegate.m
//  astro
//
//  Created by kjubo on 13-12-15.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import "ASAppDelegate.h"
#import "ASNav.h"
#import "ASTabMainVc.h"
#import "ASShareBindVc.h"

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
    
    [[UINavigationBar appearance] setBarTintColor:ASColorDarkGray];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor whiteColor], NSForegroundColorAttributeName
                                                           ,[UIFont boldSystemFontOfSize:18], NSFontAttributeName
                                                           ,nil]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                                       ASColorDarkGray, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont boldSystemFontOfSize:12], UITextAttributeFont,
                                                       ASColorBlue, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];
    
    //初始化window
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    ASTabMainVc *vc = [[ASTabMainVc alloc] init];
    //配置页面到导航vc
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    self.nav = nc;
    self.nav.navigationBarHidden = YES;
    
    //设置rootViewController
    self.window.rootViewController = self.nav;
    [self.window makeKeyAndVisible];
    
    //兼容ios7
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [[UITextField appearance] setTintColor:ASColorDarkGray];
//        [application setStatusBarStyle:UIStatusBarStyleLightContent];
//        self.window.clipsToBounds =YES;
//        self.window.frame = CGRectMake(0, 20, self.window.frame.size.width, self.window.frame.size.height - 20);
//        self.window.bounds = CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height);
    }
    
    return YES;
}

#pragma mark -  解析url
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    NSString *aburl = [url absoluteString];
    if (aburl.length<3) {
        return NO;
    }
    if([aburl hasPrefix:@"sinaweibosso"]) {
        [ASShareBindVc handleOpenURL:url];
        return NO;
    }
//    else if([aburl hasPrefix:@"xms-alipay"]) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:kMsgForAppSchemeLinkForAlipay object:url];
//        return NO;
//    }
//    else if ([aburl hasPrefix:@"wx"]) {
//        [WXApi handleOpenURL:url delegate:self];
//        return NO;
//    }
    else {
//        [SchemePushUtil notifyToProcessAppSchemeUrl:aburl];
        return YES;
    }
}

#pragma mark - DeviceToken

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
//    NSString *token = [NSString stringWithFormat:@"%@", deviceToken];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err {
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"Error:%@",str);
}


//接收到服务器消息
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //重置软件角标
    [UIApplication.sharedApplication setApplicationIconBadgeNumber:0];
    
    //获得推送数据
    //容错
    if (userInfo==nil) {
        return;
    }
    NSDictionary *param = [userInfo objectForKey:@"acme"];
    //容错
    if (param==nil) {
        return;
    }
}

#pragma mark - Application Active Changed
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
