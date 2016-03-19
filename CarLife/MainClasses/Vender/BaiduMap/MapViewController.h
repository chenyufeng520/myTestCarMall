//
//  MapViewController.h
//  Project
//
//  Created by 高大鹏 on 15/10/18.
//  Copyright © 2015年 高大鹏. All rights reserved.
//

#import "ISTBaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>

typedef enum{
    UserLocationCenter = 0,
    StadiumLocationCenter
}CenterType;

@interface MapViewController : ISTBaseViewController <BMKMapViewDelegate,BMKLocationServiceDelegate>

@property (nonatomic, assign) CenterType centerType;
@property (nonatomic, assign) BOOL canExpand;

- (void)configLocationAnnotationInfo:(NSArray *)points;

@end
