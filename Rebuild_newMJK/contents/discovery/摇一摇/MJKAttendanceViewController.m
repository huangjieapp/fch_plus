//
//  MJKAttendanceViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAttendanceViewController.h"

#import "MJKAttendanceModel.h"
#import "MJKMJKAttendanceDetailModel.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Location/BMKLocationService.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearchOption.h>

#import "MJKAttendanceCell.h"

#define cellHeight 50

@interface MJKAttendanceViewController ()<BMKGeneralDelegate,BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate, UITableViewDataSource, UITableViewDelegate>
/** baidu map manager*/
@property (nonatomic, strong) BMKMapManager *mapManager;
/** baudi map*/
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
//@property (nonatomic, strong) BMKMapView *mapView;
/** baidu location */
@property (nonatomic, strong)  BMKLocationService*locService;
/** baidu search*/
@property (nonatomic, strong) BMKGeoCodeSearch *searcher;
/** geoCodeSearchOption*/
@property (nonatomic, strong)  BMKGeoCodeSearchOption *geoCodeSearchOption;
/** 存储考勤地点*/
@property (nonatomic, strong) NSMutableArray *areaArray;
@property (weak, nonatomic) IBOutlet UIButton *takeWorkButton;
@property (weak, nonatomic) IBOutlet UIButton *offWorkButton;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableviewHeight;
/** cell count*/
@property (nonatomic, assign) NSInteger cellCount;
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *superTableView;
/** 上一个model*/
@property (nonatomic, strong) MJKAttendanceModel *preModel;
/** 定位的经纬*/
@property (nonatomic, assign) CLLocationCoordinate2D ownerCoordinate;
/** 签到详情*/
@property (nonatomic, strong) MJKMJKAttendanceDetailModel *detailModel;
@end

@implementation MJKAttendanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"考勤";
	[self httpAttendanceDetail];
//	self.mapView = [[BMKMapView alloc]initWithFrame:self.superMapView.frame];
//	[self.superMapView addSubview:self.mapView];
	
	_locService = [[BMKLocationService alloc]init];
	_locService.delegate = self;
	
	//地理编码
	_searcher =[[BMKGeoCodeSearch alloc]init];
	_searcher.delegate = self;
	
	_mapView.zoomLevel = 14.1; //地图等级，数字越大越清晰
	_mapView.showsUserLocation = YES;//是否显示定位小蓝点，no不显示，我们下面要自定义的(这里显示前提要遵循代理方法，不可缺少)
	_mapView.userTrackingMode = BMKUserTrackingModeNone;
	//定位
	[_locService startUserLocationService];
	
	[self.superTableView addSubview:self.tableView];
}

//遵循代理写在viewwillappear中
- (void)viewWillAppear:(BOOL)animated {
	[_mapView viewWillAppear];
	_mapView.delegate = self;
	_locService.delegate = self;
	_searcher.delegate = self;
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[_mapView viewWillDisappear];
	_mapView.delegate = nil;
	_locService.delegate = nil;
	_searcher.delegate = nil;
}

#pragma mark - BMKLocationServiceDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
	//（如果直接写在代理方法中，需要在代理方法末尾调用[_locService stopUserLocationService] 方法，让定位停止，要不然一直定位，你的地图就一直锁定在一个位置）。
	_mapView.centerCoordinate = userLocation.location.coordinate;
	
	[_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
	BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
	annotation.coordinate = userLocation.location.coordinate;
//	annotation.title = @"这里是北京";
	[_mapView addAnnotation:annotation];
	
	//发起反向地理编码检索
	BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
	reverseGeoCodeSearchOption.location = userLocation.location.coordinate;
	BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
	if(flag)
	{
		NSLog(@"反geo检索发送成功");
	}
	else
	{
		NSLog(@"反geo检索发送失败");
	}
	
	[_locService stopUserLocationService];
	self.ownerCoordinate = userLocation.location.coordinate;
	[self httpGetAteaShoplistWithLocation:userLocation.location.coordinate];

}
#pragma mark - BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
		BMKPinAnnotationView*annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
		if (annotationView == nil) {
			annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
		}
		annotationView.pinColor = BMKPinAnnotationColorPurple;
		annotationView.canShowCallout= YES;      //设置气泡可以弹出，默认为NO
		annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
		annotationView.draggable = YES;          //设置标注可以拖动，默认为NO
		return annotationView;
	}
	return nil;
}

//实现Deleage处理回调结果
//接收反向地理编码结果
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
	if (error == BMK_SEARCH_NO_ERROR) {
		//在此处理正常结果
		self.addressLabel.text = result.address;
	}
	else {
		NSLog(@"抱歉，未找到结果");
	}
}

#pragma mark - http get area shop list
- (void)httpGetAteaShoplistWithLocation:(CLLocationCoordinate2D)location {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A64900WebService-geta649ALLList"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	contentDict[@"currPage"] = @"1";
	contentDict[@"pageSize"] = @"100";
	contentDict[@"B_SIGNLONGITUDE"] = @(location.longitude);
	contentDict[@"B_SIGNLATITUDE"] = @(location.latitude);
	
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.areaArray = [MJKAttendanceModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (weakSelf.areaArray.count > 0) {
				MJKAttendanceModel *tempModel = weakSelf.areaArray[0];
				for (int i = 1; i < weakSelf.areaArray.count; i++) {
					MJKAttendanceModel *model = weakSelf.areaArray[i];
					if (tempModel.DISTANCE.floatValue > model.DISTANCE.floatValue) {
						tempModel = model;
					}
				}
				tempModel.selected = YES;
				weakSelf.preModel = tempModel;
			}
			
			//table super view height
//			weakSelf.tableviewHeight.constant = (weakSelf.areaArray.count + 2) * cellHeight;
			weakSelf.tableviewHeight.constant = (3 + 2) * cellHeight;
			//根据内容重设tableview的height
			CGRect frame = weakSelf.tableView.frame;
			frame.size.height = weakSelf.tableviewHeight.constant;
			weakSelf.tableView.frame = frame;
			//刷新
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - tableview datascoure / delegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	MJKAttendanceModel *model = self.areaArray[indexPath.row];
	MJKAttendanceCell *cell = [MJKAttendanceCell cellWithTableView:tableView];
	cell.model = model;
	return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.areaArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.preModel.selected = NO;
	MJKAttendanceModel *model = self.areaArray[indexPath.row];
	model.selected = YES;
	self.preModel = model;
	[tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 100)];
	bgView.backgroundColor = [UIColor whiteColor];
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 10, 50)];
	timeLabel.text = [DBTools getWeeksTimeFomatFromCurrentTimeStamp];
	timeLabel.font = [UIFont systemFontOfSize:14.f];
	timeLabel.textColor = KNaviColor;
	timeLabel.textAlignment = NSTextAlignmentCenter;
	[bgView addSubview:timeLabel];
	
	UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(timeLabel.frame), KScreenWidth - 10, 50)];
	titleLabel.text = @"考勤地点";
	titleLabel.textColor = [UIColor darkGrayColor];
	titleLabel.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:titleLabel];
	
	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), KScreenWidth, 1)];
	sepView.backgroundColor = kBackgroundColor;
	[bgView addSubview:sepView];
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 0) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.bounces = NO;
	}
	return _tableView;
}

#pragma mark - 上班/下班
- (IBAction)goToWorkButtonAction:(UIButton *)sender {
	if ([self.detailModel.toworkFlag isEqualToString:@"1"]) {
		return;
	}
	if (self.preModel.C_NAME.length <= 0) {
		[JRToast showWithText:@"请选择考勤地点"];
		return;
	}
	[self httpAddAttendanceWithType:@"0"];
}
- (IBAction)afterWorkButtonAction:(UIButton *)sender {
	if ([self.detailModel.offworkFlag isEqualToString:@"1"]) {
		return;
	}
	if (self.preModel.C_NAME.length <= 0) {
		[JRToast showWithText:@"请选择考勤地点"];
		return;
	}
	[self httpAddAttendanceWithType:@"1"];
}

#pragma mark - 新增考勤
- (void)httpAddAttendanceWithType:(NSString *)type {
	DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A64600WebService-insert"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	contentDict[@"C_A64900_C_ID"] = self.preModel.C_ID;
	contentDict[@"C_SINGNADDRESS"] = self.preModel.C_NAME;
	contentDict[@"C_U03100_C_ID"] = [NewUserSession instance].user.u051Id;
	contentDict[@"TYPE"] = type;
	if ([type isEqualToString:@"0"]) {
		contentDict[@"D_TOWORK_TIME"] = [DBTools getTimeFomatFromCurrentTimeStamp];
	} else if ([type isEqualToString:@"1"]) {
		contentDict[@"D_OFFWORK_TIME"] = [DBTools getTimeFomatFromCurrentTimeStamp];
	}
	
//	contentDict[@"B_SIGNLATITUDE"] = @"31.30003761890081";
//	contentDict[@"B_SIGNLONGITUDE"] = @"121.5165243741942";
	contentDict[@"B_SIGNLATITUDE"] = @(self.ownerCoordinate.latitude);
	contentDict[@"B_SIGNLONGITUDE"] = @(self.ownerCoordinate.longitude);
	
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf httpAttendanceDetail];
			[JRToast showWithText:data[@"message"]];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - 考勤情况
- (void)httpAttendanceDetail {
		DBSelf(weakSelf);
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A64600WebService-detail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKMJKAttendanceDetailModel mj_objectWithKeyValues:data];
			if ([weakSelf.detailModel.toworkFlag isEqualToString:@"1"]) {
				[weakSelf.takeWorkButton setTitleNormal:[NSString stringWithFormat:@"%@ 已打卡",weakSelf.detailModel.D_TOWORK_TIME]];
			}
			if ([weakSelf.detailModel.offworkFlag isEqualToString:@"1"]) {
				[weakSelf.offWorkButton setTitleNormal:[NSString stringWithFormat:@"%@ 已打卡",weakSelf.detailModel.D_OFFWORK_TIME]];
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

@end
