//
//  ASPoiMapVc.h
//  astro
//
//  Created by kjubo on 14-7-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASBaseViewController.h"

@protocol ASPoiMapVcDelegate <NSObject>
@optional
- (void)asPoiMap:(CLPlacemark *)mark;
@end

@interface ASPoiMapVc : ASBaseViewController<MKMapViewDelegate, UISearchBarDelegate>
@property (nonatomic, assign) id<ASPoiMapVcDelegate> delegate;
@property (nonatomic) CLLocationCoordinate2D location;
@property (nonatomic, strong) NSString *poiName;
@end
