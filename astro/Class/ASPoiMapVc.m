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
@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation ASPoiMapVc
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择出生地";
    self.navigationItem.leftBarButtonItem = nil;
    
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
    
    if([GpsData shared].haveMKGpsTag){
        self.placemark = [[CLPlacemark alloc] initWithPlacemark:[GpsData shared].placemark];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.frame = self.contentView.bounds;
    if(self.placemark){
        [self resetAnnotationWithLocation:self.placemark.location.coordinate];
    }
}

- (void)btnClick_navBack:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(asPoiMap:)]){
        [self.delegate asPoiMap:self.placemark];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tapMap:(UITapGestureRecognizer *)sender{
    if (sender.state == UIGestureRecognizerStateEnded){  //这个状态判断很重要
        //坐标转换
        CGPoint touchPoint = [sender locationInView:self.mapView];
        CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
        //这里的touchMapCoordinate.latitude和touchMapCoordinate.longitude就是你要的经纬度，
        [self resetAnnotationWithLocation:touchMapCoordinate];
    }
}

//重新添加大头针
- (void)resetAnnotationWithLocation:(CLLocationCoordinate2D)loc
{
    //先清理以前的所有覆盖物
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [self.mapView removeAnnotations:array];
    self.location = loc;
    //进入这个区域
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 10000, 10000);
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = loc;
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
            CLPlacemark *mark = [placemarks firstObject];
            [self resetAnnotationWithLocation:mark.location.coordinate];
        }
    }];
}

#pragma mark - 定位相关
//这个方法由百度地图调用, 每隔一秒执行一次
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self resetAnnotationWithLocation:userLocation.coordinate];
}


@end
