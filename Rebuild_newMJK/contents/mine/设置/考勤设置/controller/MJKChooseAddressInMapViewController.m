//
//  MJKChooseAddressInMapViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/31.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKChooseAddressInMapViewController.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BMKLocationKit/BMKLocationManager.h>



@interface MJKChooseAddressInMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKLocationManagerDelegate,UISearchBarDelegate> {
	UIView *_topbgView;
	NSString *_cityName;
	CLLocationCoordinate2D _pt;
	BOOL _isAutoMove;
}
@property(nonatomic,weak) BMKMapView *mapView;//地图
@property(nonatomic,strong) BMKLocationService *locService;//定位

@property(nonatomic,weak) UITableView *tableView;

@property(nonatomic,strong) BMKGeoCodeSearch *searcher;//编码

@property(nonatomic,strong) NSArray<BMKPoiInfo *> *dataList;//信息

@property (nonatomic, assign) NSIndexPath *selectIndex;//单选，当前选中的行
/** <#备注#>*/
@property (nonatomic, strong) BMKLocationManager *localManager;
/** address label*/
@property (nonatomic, strong) UILabel *addressLabel;
/** a64900Forms id*/
@property (nonatomic, strong) NSString *a64900FormsID;
/** address dic*/
@property (nonatomic, strong) NSMutableDictionary *addressDic;
/** sureButton 使用此位置*/
@property (nonatomic, strong) UIView *bottomView;
/** 当前位置*/
@property (nonatomic, strong) UIButton *localButton;
@end

@implementation MJKChooseAddressInMapViewController

#pragma mark - UI

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
//	self.navigationController.navigationBar.hidden = NO;
	[self.mapView viewWillAppear];
	self.selectIndex = [NSIndexPath indexPathForRow:0 inSection:0];
	self.searcher.delegate = self;
	self.mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
	
}
-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[self.mapView viewWillDisappear];
	self.mapView.delegate = nil; // 不用时，置nil
	self.searcher.delegate = nil;
}
- (void)viewDidLoad{
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"选择上下班考勤位置";
	self.a64900FormsID = [DBObjectTools getA64900_C_ID];
	[self setupSearchView];
	[self setupMapView];
//	if (self.addressModel != nil) {
//		self.localButton.hidden = YES;
//		self.bottomView.hidden = YES;
//		[self.mapView setCenterCoordinate:CLLocationCoordinate2DMake([self.addressModel.B_SIGNLATITUDE floatValue], [self.addressModel.B_SIGNLONGITUDE floatValue]) animated:YES];
//		[self.mapView setZoomLevel:20];
//	} else {
		[self configLocation];
//	}
	
	
	

}

- (void)configLocation {
	//	[self setupTableView];
	//初始化实例
	_localManager = [[BMKLocationManager alloc] init];
	//设置delegate
	_localManager.delegate = self;
	//设置返回位置的坐标系类型
	_localManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
	//设置距离过滤参数
	_localManager.distanceFilter = kCLDistanceFilterNone;
	//设置预期精度参数
	_localManager.desiredAccuracy = kCLLocationAccuracyBest;
	//设置应用位置类型
	_localManager.activityType = CLActivityTypeAutomotiveNavigation;
	//设置是否自动停止位置更新
	_localManager.pausesLocationUpdatesAutomatically = NO;
	//设置是否允许后台定位
	//	_locationManager.allowsBackgroundLocationUpdates = YES;
	//设置位置获取超时时间
	_localManager.locationTimeout = 10;
	//设置获取地址信息超时时间
	_localManager.reGeocodeTimeout = 10;
	
	[_localManager startUpdatingLocation];
	
	//启动LocationService
	[self.locService startUserLocationService];
}

- (void)setupSearchView {
	UIView *topView = [[UIView alloc]init];
	topView.backgroundColor = [UIColor colorWithHexString:@"0xEFEEF6"];
	[self.view addSubview:topView];
	[topView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(self.view).offset(NavStatusHeight);
		make.height.offset(50);
	}];
	_topbgView = topView;
	
	UISearchBar *searchBar = [[UISearchBar alloc]init];
	searchBar.placeholder = @"搜索";
	searchBar.delegate = self;
	[topView addSubview:searchBar];
	[searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.height.centerY.equalTo(topView);
		
	}];
}

- (void)setupMapView{
	BMKMapView *mapView = [[BMKMapView alloc]init];
	[self.view addSubview:mapView];
	[mapView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.right.equalTo(self.view);
		make.top.equalTo(_topbgView.mas_bottom);
//		make.height.mas_equalTo(@220);
		make.bottom.equalTo(self.view);
	}];
	self.mapView = mapView;
	
	UIButton *button = [[UIButton alloc]init];
	[button setImage:[UIImage imageNamed:@"pin_red"] forState:UIControlStateNormal];
	[mapView addSubview:button];
	[button mas_makeConstraints:^(MASConstraintMaker *make) {
		make.centerX.equalTo(mapView);
		make.centerY.equalTo(mapView.mas_centerY).offset(-10);
//		make.center.equalTo(mapView);
	}];
	
	
//	UIImageView *leftImageView = [[UIImageView alloc]init];
//	UIImageView *rightImageView = [[UIImageView alloc]init];
//	[mapView addSubview:leftImageView];
//	[mapView addSubview:rightImageView];
//
//	UILabel *label = [[UILabel alloc]init];
//	self.addressLabel = label;
//	label.textAlignment = NSTextAlignmentCenter;
//	[mapView addSubview:label];
//	label.numberOfLines = 2;
////	label.backgroundColor = [UIColor redColor];
//
//	[label mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerX.equalTo(button);
//		make.bottom.equalTo(button.mas_top).offset(-5);
//		make.width.equalTo(@(KScreenWidth - 60));
//		make.height.equalTo(@60);
//	}];
	
//	UIImage* leftImage = [UIImage imageNamed:@"icon_paopao_middle_left_highlighted"];
//	leftImage = [leftImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13.333, 19, 19) resizingMode:UIImageResizingModeTile];
//	UIImage* rightImage = [UIImage imageNamed:@"icon_paopao_middle_right_highlighted"];
//	rightImage = [rightImage resizableImageWithCapInsets:UIEdgeInsetsMake(13, 13.333, 19, 19) resizingMode:UIImageResizingModeTile];
//	leftImageView.image = leftImage;
//	rightImageView.image = rightImage;
//	[leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerY.equalTo(label.mas_centerY);
//		make.left.equalTo(label.mas_left).offset(-20);
//		make.width.equalTo(label.mas_width).offset(20).multipliedBy(.5);
//		make.height.equalTo(@80);
//	}];
//	[rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//		make.centerY.equalTo(label.mas_centerY);
//		make.right.equalTo(label.mas_right).offset(20);
//		make.width.equalTo(label.mas_width).offset(20).multipliedBy(.5);
//		make.height.equalTo(@80);
//	}];
	self.mapView.showsUserLocation = YES;//显示定位图层
	self.mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
//	self.mapView.zoomLevel = 16;//地图显示的级别
	
	[mapView setBuildingsEnabled:YES];
	mapView.overlooking = -10;//
	

	
	/*
	 [mapView setUserTrackingMode:BMKUserTrackingModeFollowWithHeading];
	 [mapView setMapType:BMKMapTypeStandard];
	 [mapView setBuildingsEnabled:YES];
	 mapView.overlookEnabled = YES;
	 mapView.overlooking = -10;//
	 [mapView setZoomLevel:16.1f];
	 */
	
	
	
	//下方位置
	UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 50 - SafeAreaBottomHeight, KScreenWidth, 50)];
	[self.view addSubview:bottomView];
	bottomView.backgroundColor = [UIColor whiteColor];
	
	UIImageView *localImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_location"]];
	localImageView.frame = CGRectMake(5, (bottomView.frame.size.height - 20) / 2, 20, 20);
	[bottomView addSubview:localImageView];
	self.bottomView = bottomView;
	
	UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(bottomView.frame.size.width - 70, 5, 60, 40)];
	sureButton.backgroundColor = KNaviColor;
	[sureButton setTitleNormal:@"确定"];
	sureButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[sureButton setTitleColor:[UIColor whiteColor]];
	sureButton.layer.cornerRadius = 5.f;
	[sureButton addTarget:self action:@selector(chooseAddressButtonAction:)];
	[bottomView addSubview:sureButton];
	
	UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(localImageView.frame) + 5, 5, KScreenWidth - 30 - 70, 40)];
	[bottomView addSubview:addressLabel];
	self.addressLabel = addressLabel;
	addressLabel.font = [UIFont systemFontOfSize:14.f];
	addressLabel.textColor = [UIColor blackColor];
	addressLabel.numberOfLines = 0;
	
	UIButton *localButton = [[UIButton alloc]initWithFrame:CGRectMake(25, CGRectGetMinY(bottomView.frame)-60, 40, 40)];
	[localButton setImage:@"定位当前"];
	localButton.layer.cornerRadius = 3.f;
	[self.view addSubview:localButton];
	[localButton addTarget:self action:@selector(localAddressAction:)];
	self.localButton = localButton;
	
	
}

#pragma mark - 使用此位置
- (void)chooseAddressButtonAction:(UIButton *)sender {
	NSLog(@"%f",_pt.latitude);
//	NSMutableArray *arr = [NSMutableArray array];
//	[arr addObject:self.addressDic];
	if (self.backAddressDicBlock) {
		self.backAddressDicBlock(self.addressDic);
	}
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 定位当前位置
- (void)localAddressAction:(UIButton *)sender {
	if (self.addressModel != nil) {
		//发起地理位置检索
		BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
		geoCodeSearchOption.address = self.addressModel.C_NAME;
		//	geoCodeSearchOption.city = @"北京";
		BOOL flag = [self.searcher geoCode:geoCodeSearchOption];
		if(flag)
		{
			NSLog(@"geo检索发送成功");
		}
		else
		{
			NSLog(@"geo检索发送失败");
		}
	} else {
		[_localManager startUpdatingLocation];
	}
	
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	
	//发起地理位置检索
	BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
	geoCodeSearchOption.address = searchBar.text;
//	geoCodeSearchOption.city = @"北京";
	BOOL flag = [self.searcher geoCode:geoCodeSearchOption];
	if(flag)
	{
		NSLog(@"geo检索发送成功");
	}
	else
	{
		NSLog(@"geo检索发送失败");
	}
}


#pragma mark - lazyLoad
- (BMKLocationService *)locService{
	if (_locService == nil) {
		//初始化BMKLocationService
		_locService = [[BMKLocationService alloc]init];
		_locService.delegate = self;
	}
	return _locService;
}

- (BMKGeoCodeSearch *)searcher{
	if (!_searcher) {
		_searcher =[[BMKGeoCodeSearch alloc]init];
	}
	return _searcher;
}

- (NSArray *)dataList {
	if (!_dataList) {
		_dataList = [NSArray array];
	}
	return _dataList;
}


#pragma mark - BMKGeoCodeSearchDelegate
//接收地理编码结果
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
	if (error == BMK_SEARCH_NO_ERROR) {
		//在此处理正常结果
		[self.mapView setCenterCoordinate:result.location animated:YES];
		[self.mapView setZoomLevel:20];
	}
	else {
		NSLog(@"抱歉，未找到结果");
	}
}
//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{

	if (error == BMK_SEARCH_NO_ERROR) {
//		self.addressModel = [[MJKCheckDetailAddressModel alloc]init];
//		self.addressModel.C_ID = self.a64900FormsID;
//		self.addressModel.C_NAME = result.address;
//		self.addressModel.B_SIGNLATITUDE = @(result.location.latitude);
//		self.addressModel.B_SIGNLONGITUDE = @(result.location.longitude)
		
		self.addressDic = [NSMutableDictionary dictionary];
		self.addressDic[@"C_ID"] = self.addressModel != nil ? self.addressModel.C_ID : self.a64900FormsID;
		self.addressDic[@"C_NAME"] = result.address;
		self.addressDic[@"B_SIGNLATITUDE"] = @(result.location.latitude);
		self.addressDic[@"B_SIGNLONGITUDE"] = @(result.location.longitude);
		
		
		
		
		//在此处理正常结果
		if (_isAutoMove == NO) {
			self.dataList = result.poiList;
			_cityName = result.addressDetail.city;
			self.addressLabel.text = result.address;
		}else{
			_isAutoMove = NO;
		}
	}
	else {
		NSLog(@"抱歉，未找到结果");
	}
}
#pragma mark - BMKMapViewDelegate
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
	BMKCoordinateRegion region;
	CLLocationCoordinate2D centerCoordinate = mapView.region.center;
	region.center = centerCoordinate;
	NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
	_pt = centerCoordinate;
	
	//发起反向地理编码检索
	BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
	reverseGeoCodeSearchOption.location = region.center;
	BOOL flag = [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
	if(flag){
		NSLog(@"反geo检索发送成功");
//		[self.locService stopUserLocationService];
	}else{
		NSLog(@"反geo检索发送失败");
	}
}

#pragma mark - BMKLocationServiceDelegate

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
	[self.mapView updateLocationData:userLocation]; //更新地图上的位置
}

#pragma mark - BMKLocationManagerDelegate
-(void)BMKLocationManager:(BMKLocationManager *)manager didUpdateLocation:(BMKLocation *)location orError:(NSError *)error {
//	if (_pt.longitude == 0) {
		[self.mapView setCenterCoordinate:location.location.coordinate animated:YES];
	
	[self.mapView setZoomLevel:20];
//	}else{
//		[self.mapView setCenterCoordinate:_pt animated:YES];
//	}
	[_localManager stopUpdatingLocation];
}



@end
