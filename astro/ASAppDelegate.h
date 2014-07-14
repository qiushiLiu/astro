//
//  ASAppDelegate.h
//  astro
//
//  Created by kjubo on 13-12-15.
//  Copyright (c) 2013年 kjubo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface ASAppDelegate : UIResponder <UIApplicationDelegate>{
    BMKMapManager *_mapManager;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;

@end
