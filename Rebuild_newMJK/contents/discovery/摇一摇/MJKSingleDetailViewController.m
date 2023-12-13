//
//  MJKSingleDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Mcr on 2018/4/19.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSingleDetailViewController.h"

#import "MJKSingleModel.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"

#import "MJKChooseAddressInMapViewController.h"

#import "MJKAMapShowDetailViewController.h"

#import "MJKCheckDetailAddressModel.h"

#import "MJKPhotoView.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#define RemarkCell    @"CGCNewAppointTextCell"

@interface MJKSingleDetailViewController ()<UITableViewDataSource, UITableViewDelegate,BMKMapViewDelegate,BMKGeoCodeSearchDelegate> {
    BMKGeoCodeSearch* _geocodesearch;
}
@property(nonatomic,assign)CLLocationCoordinate2D locationCoordinate;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) NSString *addressStr;

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) MJKSingleModel *model;
@property (nonatomic, strong) NSArray *dataArray;
@property(nonatomic,weak)CGCOrderDetialFooter*footerImageView;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
@end

@implementation MJKSingleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"签到详情";
    [self HttpGetSingleDetail];
    [self.tableview registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
	[self initMapView];
//    [self onGeocode];
	
    [self.view addSubview:self.tableview];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
        cell.topTitleLabel.text = @"备注";
		cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
        cell.textView.text = self.model.X_REMARK;
        cell.textView.editable = NO;
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
		cell.textLabel.font = [UIFont systemFontOfSize:14.f];
		cell.detailTextLabel.font = [UIFont systemFontOfSize:14.f];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.dataArray[indexPath.row];
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = self.model.C_A41500_C_NAME;
        } else if (indexPath.row == 1) {
            cell.detailTextLabel.text = self.model.C_DRIVE_ADDRESS;
            cell.detailTextLabel.numberOfLines = 0;
        } else if (indexPath.row == 2) {
            cell.detailTextLabel.text = self.model.D_FOLLOW_TIME;
        }
        return cell;
}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1 ) {
        CGSize size = [self.model.C_DRIVE_ADDRESS boundingRectWithSize:CGSizeMake(KScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f]} context:nil].size;
        if (size.height + 22 > 44) {
            return size.height + 22;
        } else {
            return 44;
        }
    } else if (indexPath.row == 3) {
        return 100;
    } else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    DBSelf(weakSelf);
	self.tableFootPhoto.imageURLArray = self.model.urlList;
	return self.tableFootPhoto;
   /* NSArray *imageArr;
    if (self.model.urlList.count > 0) {
        imageArr = self.model.urlList;
    }
    
    CGCOrderDetialFooter*footer=[[NSBundle mainBundle]loadNibNamed:@"CGCOrderDetialFooter" owner:nil options:nil].firstObject;
            footer.beforeImageArray=imageArr;
    footer.frame=CGRectMake(0, 0, KScreenWidth, 150);
    footer.deleteOneButton.hidden = footer.deleteSecondButton.hidden = footer.deleteThirdButton.hidden = YES;
    weakSelf.footerImageView = footer;
//    if (imageArr.count > 0) {
//        if (imageArr.count == 1) {
//            footer.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageArr[0]]]];
//        } else if (imageArr.count == 2) {
//            footer.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageArr[0]]]];
//            footer.secondImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageArr[1]]]];
//        } else if (imageArr.count == 3) {
//            footer.firstImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageArr[0]]]];
//            footer.secondImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageArr[1]]]];
//            footer.thirdImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageArr[2]]]];
//        }
//    }
    footer.clickFirstBlock = ^(UIImage*image){
        if (image) {
            //有图片那就放大
            MyLog(@"放大");
            
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.firstPicBtn.imageView image:image];
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
            //                browser.delegate = self;
            //                browser.dismissalStyle = _dismissalStyle;
            //                browser.backgroundStyle = _backgroundStyle;
            //                browser.loadingStyle = _loadingStyle;
            //                browser.pageindicatorStyle = _pageindicatorStyle;
            //                browser.bounces = _bounces;
            [browser showFromViewController:weakSelf];
            
            
            
            
        }else{
            //            //选择图片
            //            self.selectedImage=11;
            //            [weakSelf TouchAddImage];
            
        }
        
    };
    
    footer.clickSecondBlock = ^(UIImage*image){
        if (image) {
            //有图片那就放大
            MyLog(@"放大");
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.secondPicBtn.imageView image:image];
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
            [browser showFromViewController:weakSelf];
            
            
        }else{
            //选择图片
            //            self.selectedImage=22;
            //            [weakSelf TouchAddImage];
            
        }
        
        
        
    };
    
    footer.clickThirdBlock = ^(UIImage*image){
        if (image) {
            //有图片那就放大
            MyLog(@"放大");
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:weakSelf.footerImageView.thirdPicBtn.imageView image:image];
            KSPhotoBrowser *browser = [KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
            [browser showFromViewController:weakSelf];
            
            
        }else{
            //选择图片
            //            self.selectedImage=33;
            //            [weakSelf TouchAddImage];
            
            
        }
        
    };
    return footer;*/
}

- (MJKPhotoView *)tableFootPhoto {
//    DBSelf(weakSelf);
	if (!_tableFootPhoto) {
		_tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
		_tableFootPhoto.isEdit = NO;
		_tableFootPhoto.rootVC = self;
		//        _tableFootPhoto.backUrlArray = ^(NSArray *arr) {
		//            weakSelf.urlList = arr;
		//        };
	}
	return _tableFootPhoto;
}

#pragma mark - http
- (void)HttpGetSingleDetail {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"ReservationWebService-getSignBeanByID"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = self.C_ID;
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.model = [MJKSingleModel yy_modelWithDictionary:data];
			CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.model.B_DRIVE_LAT doubleValue], [self.model.B_DRIVE_LON doubleValue]);
			[weakSelf showMap:coordinate];
            [weakSelf.tableview reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - setter/getter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 150, KScreenWidth, KScreenHeight - NavStatusHeight - 150 - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSArray arrayWithObjects:@"客户",@"签到地点",@"签到时间",@"签到备注", nil];
    }
    return _dataArray;
}


//地图
-(void)showMap:(CLLocationCoordinate2D)coordinate{
	//根据定位信息，添加annotation
	BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
	[annotation setCoordinate:coordinate];
	
	
	[self addAnnotationToMapView:annotation];
}

- (void)addAnnotationToMapView:(id<BMKAnnotation>)annotation
{
    [self.mapView addAnnotation:annotation];
//
    [self.mapView selectAnnotation:annotation animated:YES];
    [self.mapView setZoomLevel:18.1];
	[self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}



- (void)initMapView
{
	if (self.mapView == nil)
	{
		self.mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 150)];
		[self.mapView setDelegate:self];
		
		[self.view addSubview:self.mapView];
	}
}

//-(void)onGeocode
//{
//    _geocodesearch  = [[BMKGeoCodeSearch alloc] init];
//    _geocodesearch.delegate =self;
//    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
//    geocodeSearchOption.city= @"上海";
//    geocodeSearchOption.address = @"龙华中路2307号";
//    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
//    if(flag)
//    {
//        NSLog(@"geo检索发送成功");
//    }
//    else
//    {
//        NSLog(@"geo检索发送失败");
//    }
//
//}
//
//- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
//{
//    //    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
//    //    [_mapView removeAnnotations:array];
//    //    array = [NSArray arrayWithArray:_mapView.overlays];
//    //    [_mapView removeOverlays:array];
//    if (error == 0) {
//        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
//        //        [_mapView addAnnotation:item];
//        //        _mapView.centerCoordinate = result.location;
//        NSString* titleStr;
//        NSString* showmeg;
//
//        titleStr = @"正向地理编码";
//        showmeg = [NSString stringWithFormat:@"纬度:%f,经度:%f",item.coordinate.latitude,item.coordinate.longitude];
//
//        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
//        [myAlertView show];
//    }
//}

@end
