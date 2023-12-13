//
//  MJKCompanyAddressTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCompanyAddressTableViewCell.h"
#import "MJKCompanyInfoModel.h"

#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

@interface MJKCompanyAddressTableViewCell ()<BMKLocationManagerDelegate, BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
/** <#注释#>*/
@property (nonatomic, strong) BMKLocationManager *locationManager;
//@property (nonatomic, strong) BMKMapView *mapView;
/** <#注释#>*/
@property (nonatomic, strong) BMKGeoCodeSearch *search;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end

@implementation MJKCompanyAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [_addressTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingDidEnd];
    
    _mapView.delegate = self;
    _mapView.userTrackingMode = BMKUserTrackingModeNone;
    //显示定位图层
    _mapView.showsUserLocation = YES;
    _mapView.zoomLevel = 18;
    
    _locationManager = [[BMKLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
    _locationManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.allowsBackgroundLocationUpdates = NO;// YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
    _locationManager.locationTimeout = 10;
    _locationManager.reGeocodeTimeout = 10;

    //开始定位
//    [_locationManager startUpdatingLocation];
    //结束定位
    //[locationManager stopUpdatingLocation];
    _search = [[BMKGeoCodeSearch alloc] init];
    _search.delegate = self;
//        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//        geoCodeSearchOption.address = @"杨浦区国定东路200号";
//        geoCodeSearchOption.city = @"上海";
//        BOOL flag = [_search geoCode: geoCodeSearchOption];
//        if (flag) {
//            NSLog(@"geo检索发送成功");
//        }  else  {
//            NSLog(@"geo检索发送失败");
//        }
    
    UIButton *button = [[UIButton alloc]init];
    [button setImage:[UIImage imageNamed:@"pin_red"] forState:UIControlStateNormal];
    [_mapView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_mapView);
        make.centerY.equalTo(_mapView.mas_centerY).offset(-10);
        //        make.center.equalTo(mapView);
    }];
}

#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
    if (error) {
        NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
    }
    if (!location) {
        return;
    }
    [self.mapView setCenterCoordinate:location.location.coordinate];
    [_locationManager stopUpdatingLocation];
    self.model.B_GSDZ_LAT = [NSString stringWithFormat:@"%lf",location.location.coordinate.latitude];
    self.model.B_GSDZ_LON = [NSString stringWithFormat:@"%lf",location.location.coordinate.longitude];
}

/**
 正向地理编码检索结果回调
 
 @param searcher 检索对象
 @param result 正向地理编码检索结果
 @param error 错误码，@see BMKCloudErrorCode
 */
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error {
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        CLLocationCoordinate2D lo = result.location;
        [self.mapView setCenterCoordinate:lo];
        self.model.B_GSDZ_LAT = [NSString stringWithFormat:@"%lf",result.location.latitude];
        self.model.B_GSDZ_LON = [NSString stringWithFormat:@"%lf",result.location.longitude];
    }
    else {
        NSLog(@"检索失败");
    }
}

/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"%@",result.address);
//    CLLocationCoordinate2D lo = result.location;
//    [self.mapView setCenterCoordinate:lo];
//    self.model.B_GSDZ_LAT = [NSString stringWithFormat:@"%f",result.location.latitude];
//    self.model.B_GSDZ_LON = [NSString stringWithFormat:@"%f",result.location.longitude];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    BMKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center = centerCoordinate;
    NSLog(@" regionDidChangeAnimated %f,%f",centerCoordinate.latitude, centerCoordinate.longitude);
    //    _pt = centerCoordinate;
    
    //发起反向地理编码检索
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = region.center;
    BOOL flag = [_search reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag){
        NSLog(@"反geo检索发送成功");
        //        [self.locService stopUserLocationService];
    }else{
        NSLog(@"反geo检索发送失败");
    }
}

- (void)changeText:(UITextField *)sender {
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.address = sender.text;
//    geoCodeSearchOption.city = @"上海";
    BOOL flag = [_search geoCode: geoCodeSearchOption];
    if (flag) {
        NSLog(@"geo检索发送成功");
    }  else  {
        NSLog(@"geo检索发送失败");
    }
    if (self.textChangeBlock) {
        self.textChangeBlock(sender.text);
    }
}

- (void)setModel:(MJKCompanyInfoModel *)model {
    _model = model;
    self.addressTF.text = model.C_ADDRESS;
    BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geoCodeSearchOption.address = model.C_ADDRESS;
        geoCodeSearchOption.city = @"上海";
    if (self.model.B_GSDZ_LAT.length > 0 && self.model.B_GSDZ_LAT.integerValue != 0) {
        [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.model.B_GSDZ_LAT.floatValue, self.model.B_GSDZ_LON.floatValue)];
    } else if ((self.model.C_ADDRESS.length > 0)) {
        BMKGeoCodeSearchOption *geoCodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
        geoCodeSearchOption.address = model.C_ADDRESS;
        //    geoCodeSearchOption.city = @"上海";
        BOOL flag = [_search geoCode: geoCodeSearchOption];
        if (flag) {
            NSLog(@"geo检索发送成功");
        }  else  {
            NSLog(@"geo检索发送失败");
        }
    } else {
        [_locationManager startUpdatingLocation];
    }
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKCompanyAddressTableViewCell";
    MJKCompanyAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
