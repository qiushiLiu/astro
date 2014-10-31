//
//  ASPoiMapVc.m
//  astro
//
//  Created by kjubo on 14-7-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPoiMapVc.h"

@interface ASPoiMapVc ()
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UISearchBar *searchPoi;
@property (nonatomic, strong) NSString *poiName;
@property (nonatomic, strong) CLLocation *loc;
@end

@implementation ASPoiMapVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择出生地";
    self.navigationItem.leftBarButtonItem = nil;
    
    self.loc = [[CLLocation alloc] initWithLatitude:39.928 longitude:116.416];
    self.poiName = @"安徽省 徐州市";
    
    UIButton *btn = [ASControls newDarkRedButton:CGRectMake(0, 0, 56, 28) title:@"确定"];
    [btn addTarget:self action:@selector(btnClick_navBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.mapView = [[MKMapView alloc] init];
    [self.mapView  setMapType:MKMapTypeStandard];
    [self.mapView  setShowsUserLocation:NO];
    self.mapView.delegate = self;
    [self.contentView addSubview:self.mapView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMap:)];
    [self.mapView addGestureRecognizer:tap];
    
    self.searchPoi = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    self.searchPoi.placeholder = @"请输入当事人出生城市名";
    self.searchPoi.delegate = self;
    self.searchPoi.alpha = 0.9;
    [self.contentView addSubview:self.searchPoi];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.frame = self.contentView.bounds;
    [self resetAnnotationWithLocation:self.loc distance:1200000];
}

- (void)btnClick_navBack:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(asPoiMap:poiName:)]){
        [self.delegate asPoiMap:self.loc poiName:self.poiName];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapMap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){  //这个状态判断很重要
        //坐标转换
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        
        CLLocation *location = [[CLLocation alloc]initWithCoordinate:touchMapCoordinate
                                                            altitude:CLLocationDistanceMax
                                                  horizontalAccuracy:kCLLocationAccuracyBest
                                                    verticalAccuracy:kCLLocationAccuracyBest
                                                           timestamp:[NSDate date]];
        [[GpsData shared].geocoder reverseGeocodeLocation:location
                                        completionHandler:^(NSArray *placemarks, NSError *error) {
                                            if (!error){
                                                CLPlacemark *placemark = [placemarks firstObject];
                                                [self resetPlacemark:placemark];
                                            }
                                        }];
    }
}

- (void)resetPlacemark:(CLPlacemark *)placemark{
    if(!placemark){
        return;
    }
    self.loc = placemark.location;
    NSMutableString *str = [NSMutableString string];
    if([placemark.administrativeArea length] > 0){
        [str appendString:placemark.administrativeArea];
    }
    if([placemark.locality length] > 0){
        if([str length] > 0){
            [str appendFormat:@" "];
        }
        [str appendString:placemark.locality];
    }
    self.poiName = str;
    [self resetAnnotationWithLocation:self.loc distance:250000];
}

//重新添加大头针
- (void)resetAnnotationWithLocation:(CLLocation *)loc distance:(CGFloat)distance
{
    //先清理以前的所有覆盖物
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [self.mapView removeAnnotations:array];
    //进入这个区域
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, distance, distance);
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = loc.coordinate;
    [self.mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:point];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if([self.searchPoi.text length] == 0){
        return;
    }
    [self.searchPoi resignFirstResponder];
    [self showWaiting];
    [[GpsData shared].geocoder geocodeAddressString:self.searchPoi.text completionHandler:^(NSArray *placemarks, NSError *error) {
        [self hideWaiting];
        if(error){
            [self alert:[NSString stringWithFormat:@"%@", error]];
        }else{
            CLPlacemark *placemark = [placemarks firstObject];
            [self resetPlacemark:placemark];
        }
    }];
}
@end
