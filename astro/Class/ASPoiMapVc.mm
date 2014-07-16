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
    
    self.mapView = [[BMKMapView alloc] init];
    [self.mapView  setMapType:BMKMapTypeStandard];
    [self.mapView  setShowsUserLocation:YES];
    //设置缩放级别 (可用值3~19)
    //  19表示最清晰的地图
    self.mapView.zoomLevel = 18;
    [self.contentView addSubview:self.mapView];
    
    self.searchMap = [[BMKSearch alloc] init];
    self.searchMap.delegate = self;
    
    self.searchPoi = [[UISearchBar alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    self.searchPoi.placeholder = @"请输入当事人出生城市名";
    self.searchPoi.delegate = self;
    self.searchPoi.alpha = 0.9;
    [self.contentView addSubview:self.searchPoi];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.frame = self.contentView.bounds;
    [self.mapView viewWillAppear];
    self.mapView.delegate = self;
    
    self.searchBarTag = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.mapView viewWillDisappear];
    self.mapView.delegate = nil;
}

- (void)btnClick_navBack:(UIButton *)sender{
    if(self.searchBarTag){
        return;
    }
    [self.searchPoi resignFirstResponder];
    BOOL geoTag = [self.searchMap reverseGeocode:self.location];
    if(geoTag){
        [self showWaiting];
    }
}

#pragma mark - UISearchBar
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if(searchBar.text.length > 0)
    {
        [searchBar resignFirstResponder];
        //在商品位置的1000米之内进行搜索
        BOOL succ = [self.searchMap geocode:self.searchPoi.text withCity:@""];
        if(!succ){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的地址信息不正确，请重新输入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil];
            [alert show];
        }
        self.searchBarTag = succ;
    }
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
    [self.searchPoi resignFirstResponder];
}

//地图上的地标
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    self.searchBarTag = NO;
    [self.searchPoi resignFirstResponder];
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
    [self.searchPoi resignFirstResponder];
    if(newState == BMKAnnotationViewDragStateEnding){
        id <BMKAnnotation> ann = view.annotation;
        self.location = [ann coordinate];
    }
}

//点击地标
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    [self.searchPoi resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    [self.searchPoi resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    [self.searchPoi resignFirstResponder];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi *)mapPoi{
    [self.searchPoi resignFirstResponder];
}

- (void)onGetAddrResult:(BMKAddrInfo *)result errorCode:(int)error
{
    if(error == BMKErrorOk){
        [self hideWaiting];
        if(self.searchBarTag){
            [self resetAnnotationWithLocation:result.geoPt];
        }else{
            if([self.delegate respondsToSelector:@selector(asPoiMap:)]){
                [self.delegate asPoiMap:result];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}



@end
