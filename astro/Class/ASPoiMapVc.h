//
//  ASPoiMapVc.h
//  astro
//
//  Created by kjubo on 14-7-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"
#import "BMapKit.h"
#import "ASFillPersonVc.h"

@interface ASPoiMapVc : ASBaseViewController<BMKMapViewDelegate, BMKSearchDelegate, UISearchBarDelegate>
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *poiName;
@property (nonatomic, weak) ASFillPersonVc *parentVc;
@end
