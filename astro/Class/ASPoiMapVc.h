//
//  ASPoiMapVc.h
//  astro
//
//  Created by kjubo on 14-7-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "BMapKit.h"

@protocol ASPoiMapVcDelegate <NSObject>
@optional
- (void)asPoiMap:(BMKAddrInfo *)info;
@end

@interface ASPoiMapVc : ASBaseViewController<BMKMapViewDelegate, BMKSearchDelegate, UISearchBarDelegate>
@property (nonatomic, assign) id<ASPoiMapVcDelegate> delegate;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *poiName;
@end
