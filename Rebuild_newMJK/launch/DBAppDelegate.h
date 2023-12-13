//
//  AppDelegate.h
//  Mcr_2
//
//  Created by bipi on 2016/11/28.
//  Copyright © 2016年 bipi. All rights reserved.
//

#import <UIKit/UIKit.h>

//定位 首先获取定位权限
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>


@interface DBAppDelegate : UIResponder <UIApplicationDelegate>{

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) AMapLocationManager *locationManager;

@end

