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
- (void)asPoiMap:(CLLocation *)location poiName:(NSString *)poiName;
@end

@interface ASPoiMapVc : ASBaseViewController<MKMapViewDelegate, UISearchBarDelegate>
@property (nonatomic, assign) id<ASPoiMapVcDelegate> delegate;
@end
