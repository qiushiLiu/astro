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

@interface ASAppDelegate ()
//定位的计时器
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSTimer *gpsFetchTimer;
@property (nonatomic, strong) NSTimer *gpsUpdateTimer;
@property (nonatomic) NSInteger locOpenCount;
@property (nonatomic, strong) CLLocation *lastLocation;
@end

@implementation ASAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
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
    
    [[UINavigationBar appearance] setTitleTextAttributes: @{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                            NSFontAttributeName : [UIFont boldSystemFontOfSize:18],
                                                            UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero]
                                                            }];
    //兼容ios7
    if (IOS7_OR_LATER) {
        [[UINavigationBar appearance] setBarTintColor:ASColorDarkGray];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }else{
        [[UINavigationBar appearance] setTintColor:ASColorDarkGray];
        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:ASColorDarkGray size:CGSizeMake(1, 44)]
                                           forBarMetrics:UIBarMetricsDefault];
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [[UITabBar appearance] setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xCECABA) size:CGSizeMake(1, 49)]];
        [[UITabBar appearance] setSelectionIndicatorImage:[UIImage new]];
    }
    
    self.locOpenCount = 0;
    [self handleNextQueryTimerForLm];
    
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

#pragma mark - GPS Method
- (void)start{
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
}

- (void)stop{
    if(self.gpsFetchTimer){
        [self.gpsFetchTimer invalidate];
        self.gpsFetchTimer = nil;
    }
    
    if(self.gpsUpdateTimer){
        [self.gpsUpdateTimer invalidate];
        self.gpsUpdateTimer = nil;
    }
}

- (void)handleNextQueryTimerForLm {
    if(!self.locationManager){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    [self.locationManager startUpdatingLocation];
}

//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSTimeInterval eventAge = [newLocation.timestamp timeIntervalSinceNow];
    if (abs(eventAge) > 5) {
        return;
    }
    if (newLocation.horizontalAccuracy < 0) {
        return;
    }
    if ([newLocation isEqual:oldLocation]) {
        if (self.gpsUpdateTimer!=nil) {
            [self.gpsUpdateTimer invalidate];
            self.gpsUpdateTimer = nil;
        }
        [self fetchAfterSaveLoc:newLocation succ:YES];
    } else {
        self.lastLocation = [newLocation copy];
        if (self.gpsUpdateTimer == nil) {
            self.gpsUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                                   target:self
                                                                 selector:@selector(handleDidUpdateLoc:)
                                                                 userInfo:nil
                                                                  repeats:NO];
        }
    }
}

//更新loc
- (void)handleDidUpdateLoc:(NSTimer *)theTimer {
    //清除timer
    if(self.gpsUpdateTimer){
        [self.gpsUpdateTimer invalidate];
    }
    self.gpsUpdateTimer = nil;
    //保存经纬度
    [self fetchAfterSaveLoc:self.lastLocation succ:YES];
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self fetchAfterSaveLoc:nil succ:NO];
}

- (void)fetchAfterSaveLoc:(CLLocation *)loc succ:(BOOL)succTag{
    [self.locationManager stopUpdatingLocation];
    //更新经纬度
    if (succTag) {
        [[GpsData shared] setMKGpsLocation:loc];
    }
    
    //定时器  下一次更新
    if (self.gpsFetchTimer == nil) {
        self.locOpenCount++;
        double interval = 0;
        if (self.locOpenCount >= 2) {
            if (succTag) {
                interval = 60;
            } else {
                interval = 20;
            }
        } else {
            interval = 0.5;
        }
        self.gpsFetchTimer = [NSTimer scheduledTimerWithTimeInterval:interval
                                                              target:self
                                                            selector:@selector(handleNextQueryTimerForLm:)
                                                            userInfo:nil
                                                             repeats:NO];
    }
}

- (void)handleNextQueryTimerForLm:(NSTimer *)theTimer {
    if(self.gpsFetchTimer){
        [self.gpsFetchTimer invalidate];
    }
    self.gpsFetchTimer = nil;
    [self.locationManager startUpdatingLocation];
}


@end
