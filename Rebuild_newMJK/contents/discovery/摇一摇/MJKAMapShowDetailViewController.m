//
//  MJKAMapShowDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAMapShowDetailViewController.h"

@interface MJKAMapShowDetailViewController ()<MAMapViewDelegate, AMapLocationManagerDelegate>
@property(nonatomic,assign)CLLocationCoordinate2D locationCoordinate;

@property (nonatomic, copy) AMapLocatingCompletionBlock completionBlock;
@end

@implementation MJKAMapShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"签到地址";
	[self.view setBackgroundColor:[UIColor whiteColor]];
	
	//    [self initToolBar];
	
	//    [self initNavigationBar];
	
	[self initMapView];
	
//	[self initCompleteBlock];
	
//	[self configLocationManager];
//	[self reGeocodeAction];
	
	[self showMap];
	
	
	
}

-(void)showMap{
	//根据定位信息，添加annotation
	MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
	[annotation setCoordinate:self.PubCoordinate];
	
	
	[self addAnnotationToMapView:annotation];
}

- (void)addAnnotationToMapView:(id<MAAnnotation>)annotation
{
	[self.mapView addAnnotation:annotation];
	
	[self.mapView selectAnnotation:annotation animated:YES];
	[self.mapView setZoomLevel:15.1 animated:NO];
	[self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}
	

- (void)configLocationManager
{
	self.locationManager = [[AMapLocationManager alloc] init];
	
	[self.locationManager setDelegate:self];
	
	//设置期望定位精度
	[self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
	
	//设置不允许系统暂停定位
	[self.locationManager setPausesLocationUpdatesAutomatically:NO];
	
	//设置允许在后台定位
	[self.locationManager setAllowsBackgroundLocationUpdates:NO];
	
	//设置定位超时时间
	[self.locationManager setLocationTimeout:10];
	
	//设置逆地理超时时间
	[self.locationManager setReGeocodeTimeout:10];
	
	//设置开启虚拟定位风险监测，可以根据需要开启
	[self.locationManager setDetectRiskOfFakeLocation:NO];
}

- (void)cleanUpAction
{
	//停止定位
	[self.locationManager stopUpdatingLocation];
	
	[self.locationManager setDelegate:nil];
	
	[self.mapView removeAnnotations:self.mapView.annotations];
}

- (void)reGeocodeAction
{
	[self.mapView removeAnnotations:self.mapView.annotations];
	
	//进行单次带逆地理定位请求
	[self.locationManager requestLocationWithReGeocode:YES completionBlock:self.completionBlock];
}

- (void)locAction
{
	[self.mapView removeAnnotations:self.mapView.annotations];
	
	//进行单次定位请求
	[self.locationManager requestLocationWithReGeocode:NO completionBlock:self.completionBlock];
}

- (void)initCompleteBlock
{
	__weak MJKAMapShowDetailViewController *weakSelf = self;
	self.completionBlock = ^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error)
	{
		if (error != nil && error.code == AMapLocationErrorLocateFailed)
		{
			//定位错误：此时location和regeocode没有返回值，不进行annotation的添加
			NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.localizedDescription);
			return;
		}
		else if (error != nil
				 && (error.code == AMapLocationErrorReGeocodeFailed
					 || error.code == AMapLocationErrorTimeOut
					 || error.code == AMapLocationErrorCannotFindHost
					 || error.code == AMapLocationErrorBadURL
					 || error.code == AMapLocationErrorNotConnectedToInternet
					 || error.code == AMapLocationErrorCannotConnectToHost))
		{
			//逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
			NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.localizedDescription);
		}
		else if (error != nil && error.code == AMapLocationErrorRiskOfFakeLocation)
		{
			//存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
			NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.localizedDescription);
			return;
		}
		else
		{
			//没有错误：location有返回值，regeocode是否有返回值取决于是否进行逆地理操作，进行annotation的添加
		}
		
		//根据定位信息，添加annotation
		MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
		[annotation setCoordinate:location.coordinate];
		
		//有无逆地理信息，annotationView的标题显示的字段不一样
		if (regeocode)
		{
			NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@",
									regeocode.city.length > 0 ? regeocode.city: @"",
									regeocode.district.length > 0 ? regeocode.district: @"",
									regeocode.street.length > 0 ? regeocode.street: @"",
									regeocode.number.length > 0 ? regeocode.number: @""];
			[annotation setTitle:[NSString stringWithFormat:@"%@", addressStr]];
			[annotation setSubtitle:[NSString stringWithFormat:@"%@-%@-%.2fm", regeocode.citycode, regeocode.adcode, location.horizontalAccuracy]];
		}
		else
		{
			[annotation setTitle:[NSString stringWithFormat:@"lat:%f;lon:%f;", location.coordinate.latitude, location.coordinate.longitude]];
			[annotation setSubtitle:[NSString stringWithFormat:@"accuracy:%.2fm", location.horizontalAccuracy]];
		}
		
		MJKAMapShowDetailViewController *strongSelf = weakSelf;
		[strongSelf addAnnotationToMapView:annotation];
		
		
		//
		if (location.coordinate.latitude&&location.coordinate.longitude) {
			weakSelf.locationCoordinate=location.coordinate;
		}
		if (regeocode) {
//			weakSelf.localAddress=regeocode.formattedAddress;
		}
		
		
		
	};
}

- (void)initMapView
{
	if (self.mapView == nil)
	{
		self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight)];
		[self.mapView setDelegate:self];
		
		[self.view addSubview:self.mapView];
	}
}


@end
