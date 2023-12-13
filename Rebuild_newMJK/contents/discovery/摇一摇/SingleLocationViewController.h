//
//  SingleLocationViewController.h
//  officialDemoLoc
//
//  Created by 刘博 on 15/9/21.
//  Copyright © 2015年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import "DBBaseViewController.h"

typedef NS_ENUM(NSInteger,LocatedType){
    LocatedTypeShakeIt=0,
    LocatedTypeShowMap,
    
};


@interface SingleLocationViewController : DBBaseViewController

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString *addressStr;

@property(nonatomic,assign)LocatedType locateType;
@property(nonatomic,assign)CLLocationCoordinate2D PubCoordinate;;    //jing维度

@end
