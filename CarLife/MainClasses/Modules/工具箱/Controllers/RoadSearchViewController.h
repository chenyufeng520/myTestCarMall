//
//  RoadSearchViewController.h
//  DianCheWuLiu
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "ISTBaseViewController.h"
#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件

#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

@interface RoadSearchViewController : ISTBaseViewController<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,UITextFieldDelegate>

{
    BMKMapView* _mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch* _searcher;
    BMKRouteSearch* _routesearch;
    UITextField *_startTF;
    UITextField *_endTF;
    UITextField *_startRoadTF;
    UITextField *_endRoadTF;
    float jingdu1;
    float weidu1;
    float jingdu2;
    float weidu2;
    int currentPoint;

}

@end
