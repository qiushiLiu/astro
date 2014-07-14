//
//  ASPoiMapVc.m
//  astro
//
//  Created by kjubo on 14-7-14.
//  Copyright (c) 2014年 kjubo. All rights reserved.
//

#import "ASPoiMapVc.h"

@interface ASPoiMapVc ()
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKSearch *searchMap;
@property (nonatomic, strong) UISearchBar *searchBar;
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
    
    _mapView = [[BMKMapView alloc] init];
    [_mapView  setMapType:BMKMapTypeStandard];
    [_mapView  setShowsUserLocation:YES];
    //设置缩放级别 (可用值3~19)
    //  19表示最清晰的地图
    _mapView.zoomLevel = 18;
    
    self.searchMap = [[BMKSearch alloc] init];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    self.searchBar.delegate = self;
    self.searchBar.alpha = 0.7;
    [self.contentView addSubview:self.searchBar];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.frame = self.contentView.bounds;
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)btnClick_navBack:(UIButton *)sender{
    [self.searchMap reverseGeocode:self.location];
}

//重新添加大头针
-(void)resetAnnotationWithLocation:(CLLocationCoordinate2D)loc
{
    //先清理以前的所有覆盖物
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [self.mapView removeAnnotations:array];
    
    self.location = loc;
    
    //进入这个区域
    BMKCoordinateRegion region = BMKCoordinateRegionMakeWithDistance(loc, 600, 600);
    [self.mapView setRegion:region];
    
    //新加的代码---添加大头针
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = loc;
    [self.mapView addAnnotation:annotation];
}

#pragma mark - 定位相关
//这个方法由百度地图调用, 每隔一秒执行一次
-(void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    [self.mapView setShowsUserLocation:NO];
    [self resetAnnotationWithLocation:userLocation.coordinate];
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    [self.searchBar resignFirstResponder];
}

//地图上的地标
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    [_searchBar resignFirstResponder];
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *pin = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        pin.pinColor = BMKPinAnnotationColorRed;
        pin.animatesDrop = YES;// 设置该标注点动画显示
        pin.draggable = YES;
        return pin;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState fromOldState:(BMKAnnotationViewDragState)oldState{
    [_searchBar resignFirstResponder];
    if(newState == BMKAnnotationViewDragStateEnding){
        id <BMKAnnotation> ann = view.annotation;
        self.location = [ann coordinate];
    }
}

//点击地标
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    [self.searchBar resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    [self.searchBar resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self.searchBar resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    [self.searchBar resignFirstResponder];
}

- (void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error
{
    if(error == BMKErrorOk){
        [self resetAnnotationWithLocation:result.geoPt];
    }
}



@end
