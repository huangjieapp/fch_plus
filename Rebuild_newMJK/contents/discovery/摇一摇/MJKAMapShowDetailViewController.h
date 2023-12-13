//
//  MJKAMapShowDetailViewController.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJKAMapShowDetailViewController : UIViewController
@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString *addressStr;

@property(nonatomic,assign)CLLocationCoordinate2D PubCoordinate;;    //jing维度
@end
