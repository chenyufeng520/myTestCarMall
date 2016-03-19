//
//  MapViewController.m
//  Project
//
//  Created by 高大鹏 on 15/10/18.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "MapViewController.h"
#import "BSPointAnnotation.h"
#import <MapKit/MapKit.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface MapViewController ()<UIGestureRecognizerDelegate, UIActionSheetDelegate> {
    BMKMapView *_mapView;
    BMKLocationService* _locService;
    BSPointAnnotation *_stadiumPointAnnotation;
    BMKUserLocation *_userLocation;
    NSArray *_points;
    BOOL _isEndFirstLoad;
    BSPointAnnotation *_pa;
}

@property (nonatomic, strong) NSMutableArray *availableMaps;

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _availableMaps = [NSMutableArray array];
    }
    return self;
}

/** 导航栏 */
- (ISTTopBar *)creatTopBarView:(CGRect)frame
{
    // 导航头
    ISTTopBar *tbTop = [[ISTTopBar alloc] initWithFrame:frame];
    [tbTop.btnTitle setTitle:@"地图" forState:UIControlStateNormal];
    
    [tbTop setLetfTitle:nil];
    [tbTop.btnLeft addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    [tbTop.btnRight setTitle:@"定位" forState:UIControlStateNormal];
    [tbTop.btnRight addTarget:self action:@selector(onClickTopBar:) forControlEvents:UIControlEventTouchUpInside];
    
    return tbTop;
}

- (void)loadSubviews
{
    if(_mapView){
        _mapView.delegate = nil;
        _locService.delegate = nil;
        [_mapView removeFromSuperview];
    }
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    _mapView.zoomLevel = 8;
    _mapView.delegate = self;
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_mapView];
    
    _locService = [[BMKLocationService alloc] init];
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层
    
    [self.view bringSubviewToFront:_tbTop];
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    locationBtn.frame = CGRectMake(20, _mapView.maxY-70, 40, 40);
    //    [locationBtn setBackgroundColor:kWhiteColor];
    [locationBtn setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.8]];
    [locationBtn setImage:[UIImage imageNamed:@"定位.png"] forState:UIControlStateNormal];
    [locationBtn addTarget:self action:@selector(locationBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    //    [self.view addSubview:locationBtn];
}

- (void)configLocationAnnotationInfo:(NSArray *)points
{
    [self loadSubviews];
    _points = points;
    for(NSDictionary *info in _points){
        double latitude = [[info objectForKey:@"latitude"] doubleValue];
        double longitude = [[info objectForKey:@"longitude"] doubleValue];
        NSString *title = [info objectForKey:@"title"];
        NSString *subTitle = [info objectForKey:@"subtitle"];
        BSPointAnnotation *annotation = [[BSPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = latitude;
        coor.longitude = longitude;
        annotation.coordinate = coor;
        annotation.title = title;
        annotation.subtitle = [subTitle length]>0?subTitle:nil;
        
        [_mapView addAnnotation:annotation];
    }
    
    
    //选择初始定位类型：
    if(self.centerType == StadiumLocationCenter){
        _mapView.zoomLevel = 17;
        if([_mapView.annotations count] == 0){
            _mapView.zoomLevel = 15;
            self.centerType = UserLocationCenter;
            if(_userLocation){
                [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:YES];
            }
        }
        else{
            [_mapView setCenterCoordinate:((BSPointAnnotation *)[_mapView.annotations firstObject]).coordinate animated:YES];
            [_mapView selectAnnotation:((BSPointAnnotation *)[_mapView.annotations firstObject]) animated:YES];
        }
    }
    else{
        _mapView.zoomLevel = 15;
        if(_userLocation){
            [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:YES];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tbTop = [self creatTopBarView:kTopFrame];
    [self.view addSubview:_tbTop];
}

-(void)viewDidAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _locService.delegate = self;
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark - BMKLocationServiceDelegate
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    //    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    _userLocation = userLocation;
    [_mapView updateLocationData:userLocation];
    
    if(self.centerType == UserLocationCenter && !_isEndFirstLoad){
        _isEndFirstLoad = YES;
        [_mapView setCenterCoordinate:_userLocation.location.coordinate animated:YES];
    }
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}



#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    
}

//根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    NSString *AnnotationViewID = @"AnnotationViewID";
    //根据指定标识查找一个可被复用的标注View，一般在delegate中使用，用此函数来代替新申请一个View
    BMKAnnotationView *annotationView = [view dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil) {
        annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
        ((BMKPinAnnotationView*)annotationView).pinColor = BMKPinAnnotationColorPurple;
        ((BMKPinAnnotationView*)annotationView).animatesDrop = YES;
    }
    
    annotationView.centerOffset = CGPointMake(0, -(annotationView.frame.size.height * 0.5));
    annotationView.annotation = annotation;
    annotationView.canShowCallout = TRUE;
    
    return annotationView;
}

//当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    if (!_canExpand) {
        return;
    }
    NSLog(@"点击annotation view弹出的泡泡");
    _pa = view.annotation;
    
    [self availableMapsApps];
    UIActionSheet *action = [[UIActionSheet alloc] init];
    
    [action addButtonWithTitle:@"使用苹果地图导航"];
    for (NSDictionary *dic in self.availableMaps) {
        [action addButtonWithTitle:[NSString stringWithFormat:@"使用%@导航", dic[@"name"]]];
    }
    [action addButtonWithTitle:@"取消"];
    action.cancelButtonIndex = self.availableMaps.count + 1;
    action.delegate = self;
    [action showInView:self.view];
    
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    BSLog(@"selected!!!");
}

#pragma mark - button methods
/** 顶栏点击事件 */
- (void)onClickTopBar:(UIButton *)btn
{
    if (btn.tag == BSTopBarButtonLeft) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (btn.tag == BSTopBarButtonRight) {
        //        [self availableMapsApps];
        //        UIActionSheet *action = [[UIActionSheet alloc] init];
        //
        //        [action addButtonWithTitle:@"使用苹果地图导航"];
        //        for (NSDictionary *dic in self.availableMaps) {
        //            [action addButtonWithTitle:[NSString stringWithFormat:@"使用%@导航", dic[@"name"]]];
        //        }
        //        [action addButtonWithTitle:@"取消"];
        //        action.cancelButtonIndex = self.availableMaps.count + 1;
        //        action.delegate = self;
        //        [action showInView:self.view];
        [self locationBtnPressed:nil];
    }
}

- (void)locationBtnPressed:(id)sender
{
    if(_userLocation)
    {
        [_mapView setCenterCoordinate:_userLocation.location.coordinate];
    }
}

#pragma mark - 导航

- (void)availableMapsApps {
    [self.availableMaps removeAllObjects];
    
    CLLocationCoordinate2D startCoor = _userLocation.location.coordinate;
    CLLocationCoordinate2D endCoor = ((BSPointAnnotation *)[_mapView.annotations firstObject]).coordinate;
    NSString *toName = ((BSPointAnnotation *)[_mapView.annotations firstObject]).title;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://map/"]]){
        NSString *urlString = [NSString stringWithFormat:@"baidumap://map/direction?origin=latlng:%f,%f|name:我的位置&destination=latlng:%f,%f|name:%@&mode=transit",
                               startCoor.latitude, startCoor.longitude, endCoor.latitude, endCoor.longitude, toName];
        
        NSDictionary *dic = @{@"name": @"百度地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"iosamap://navi?sourceApplication=%@&backScheme=applicationScheme&poiname=fangheng&poiid=BGVIS&lat=%f&lon=%f&dev=0&style=3",
                               @"云华时代", endCoor.latitude, endCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"高德地图",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSString *urlString = [NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%f,%f¢er=%f,%f&directionsmode=transit", endCoor.latitude, endCoor.longitude, startCoor.latitude, startCoor.longitude];
        
        NSDictionary *dic = @{@"name": @"Google Maps",
                              @"url": urlString};
        [self.availableMaps addObject:dic];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        CLLocationCoordinate2D startCoor = _userLocation.location.coordinate;
        CLLocationCoordinate2D endCoor = _pa.coordinate;
        
        if (SYSTEM_VERSION_LESS_THAN(@"6.0")) { // ios6以下，调用google map
            
            NSString *urlString = [[NSString alloc] initWithFormat:@"http://maps.google.com/maps?saddr=%f,%f&daddr=%f,%f&dirfl=d",startCoor.latitude,startCoor.longitude,endCoor.latitude,endCoor.longitude];
            //        @"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",startCoor.latitude,startCoor.longitude,endCoor.latitude,endCoor.longitude
            urlString =  [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSURL *aURL = [NSURL URLWithString:urlString];
            [[UIApplication sharedApplication] openURL:aURL];
        } else{// 直接调用ios自己带的apple map
            
            MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
            MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:endCoor addressDictionary:nil];
            MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:placemark];
            toLocation.name = ((BSPointAnnotation *)[_mapView.annotations firstObject]).title;
            
            [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                           launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
            
        }
    }else if (buttonIndex < self.availableMaps.count+1) {
        NSDictionary *mapDic = self.availableMaps[buttonIndex-1];
        NSString *urlString = mapDic[@"url"];
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [NSURL URLWithString:urlString];
        BSLog(@"\n%@\n%@\n%@", mapDic[@"name"], mapDic[@"url"], urlString);
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - dealloc

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

@end
