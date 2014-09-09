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
@property (nonatomic) BOOL searchBarTag;    //是否是搜索框输入的搜索
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
    
    self.searchPoi = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    self.searchPoi.placeholder = @"请输入当事人出生城市名";
    self.searchPoi.delegate = self;
    self.searchPoi.alpha = 0.9;
    [self.contentView addSubview:self.searchPoi];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.frame = self.contentView.bounds;
//    [self.mapView viewWillAppear];

    
    self.searchBarTag = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)btnClick_navBack:(UIButton *)sender{
    if(self.searchBarTag){
        return;
    }
    [self.searchPoi resignFirstResponder];
//    BOOL geoTag = [self.searchMap reverseGeocode:self.location];
//    if(geoTag){
//        [self showWaiting];
//    }
}

//重新添加大头针
-(void)resetAnnotationWithLocation:(CLLocationCoordinate2D)loc
{
    //先清理以前的所有覆盖物
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    self.location = loc;
    
    //进入这个区域
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 6000000, 6000000);
    [self.mapView setRegion:region];
}

#pragma mark - 定位相关
//这个方法由百度地图调用, 每隔一秒执行一次
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self.mapView setShowsUserLocation:NO];
    [self resetAnnotationWithLocation:userLocation.coordinate];
}


@end
