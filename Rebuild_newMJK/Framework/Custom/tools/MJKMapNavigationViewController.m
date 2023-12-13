//
//  MJKMapNavigationViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/6/4.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMapNavigationViewController.h"

@interface MJKMapNavigationViewController ()

@property (nonatomic, strong) CLGeocoder *geoC;
/** <#注释#>*/
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;
@end

@implementation MJKMapNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self geocodeAddress];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleName"];
    
    UIAlertAction *baiduAction = [UIAlertAction actionWithTitle:@"百度地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *str = [[NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=%@&coord_type=bd09ll&mode=driving&src=%@",self.C_ADDRESS,app_Name] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            NSURL *url = [NSURL URLWithString:str];
            [[UIApplication sharedApplication] openURL:url];
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        [self addAction:baiduAction];
    }
    
    UIAlertAction *amapAction = [UIAlertAction actionWithTitle:@"高德地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString*str = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&dname=%@&dev=1&style=2",app_Name,self.C_ADDRESS] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        [self addAction:amapAction];
    }
    
    
    UIAlertAction *tencentAction = [UIAlertAction actionWithTitle:@"腾讯地图" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString*str = [[NSString stringWithFormat:@"qqmap://map/routeplan?type=drive&fromcoord=CurrentLocation&to=%@&tocoord=%f,%f&referer=LE5BZ-G4Z6X-PLR4I-T7YNP-KPQOT-6CBNJ",self.C_ADDRESS,self.locationCoordinate.latitude,self.locationCoordinate.longitude]stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:str];
        [[UIApplication sharedApplication] openURL:url];
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        [self addAction:tencentAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [self addAction:cancelAction];
}


- (void)geocodeAddress {
    // 根据地址关键字, 进行地理编码
    [self.geoC geocodeAddressString:self.C_ADDRESS completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        /**
         *  CLPlacemark : 地标对象
         *  location : 对应的位置对象
         *  name : 地址全称
         *  locality : 城市
         *  按相关性进行排序
         */
        CLPlacemark *pl = [placemarks firstObject];
        
        if(error == nil)
        {
            NSLog(@"%f----%f", pl.location.coordinate.latitude, pl.location.coordinate.longitude);
            
            NSLog(@"%@", pl.name);
            self.locationCoordinate = pl.location.coordinate;
        }
    }];

}

- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}

@end
