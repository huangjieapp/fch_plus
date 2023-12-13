//
//  MJKWorkWorldSignViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/26.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKWorkWorldSignViewController.h"

#import "MJKScratchableLatexPhotoView.h"

#import "MJKWorkWorldSignCell.h"

#import "MJKSingleModel.h"

#import "MJKCustomerChooseViewController.h"//选择客户
#import "MJKSelectSaleViewController.h"

#import <BMKLocationKit/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "ServiceTaskViewController.h"
#import "ServiceTaskSubModel.h"

@interface MJKWorkWorldSignViewController ()<UITextViewDelegate,BMKGeoCodeSearchDelegate, UITableViewDataSource, UITableViewDelegate, BMKLocationManagerDelegate> {
	BMKGeoCodeSearch *getCodeSearch;
//	BMKLocationService *locationService;
}
/** textView*/
@property (nonatomic, strong) UITextView *textView;
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** MJKScratchableLatexPhotoView *photoView*/
@property (nonatomic, strong) MJKScratchableLatexPhotoView *photoView;
/** BMKLocationManager *locationManager*/
@property (nonatomic, strong) BMKLocationManager *locManager;
/** address*/
@property (nonatomic, strong) NSString *addressStr;
/** customer name*/
@property (nonatomic, strong) NSString *customerName;
/** sale name*/
@property (nonatomic, strong) NSString *saleName;
/** MJKSingleModel*/
@property (nonatomic, strong) MJKSingleModel *signModel;

/** header height*/
@property (nonatomic, assign) CGFloat headerHeight;
@end

@implementation MJKWorkWorldSignViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[_locManager startUpdatingLocation];
	_locManager.delegate=self;
	getCodeSearch.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[_locManager stopUpdatingLocation];
	_locManager.delegate=nil;
	getCodeSearch.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self initUI];
}

- (void)initUI {
	self.title = @"签到打卡";
	self.view.backgroundColor = [UIColor whiteColor];
	
	self.signModel = [[MJKSingleModel alloc]init];
	[self configNavi];
	[self configLocation];
	[self.view addSubview:self.tableView];
//	[self.view addSubview:self.textView];
	
//	MJKScratchableLatexPhotoView *photoView = [[MJKScratchableLatexPhotoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), KScreenWidth, (KScreenWidth - 20) / 3)];
//	photoView.rootVC = self;
//	photoView.backUrlArray = ^(NSArray * _Nonnull arr, CGFloat height) {
//		NSLog(@"%@ %f",arr, height);
//	};
//	[self.view addSubview:photoView];
	
	
}

- (void)configNavi {
	
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
	[button setTitleNormal:@"发表"];
	[button setTitleColor:[UIColor blackColor]];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button addTarget:self action:@selector(publishedAction:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)configLocation {
	if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
		
	} else {
		[JRToast showWithText:@"请开启定位服务\n设置->隐私->定位服务"];
		return;
	}
	getCodeSearch = [[BMKGeoCodeSearch alloc]init];
	_locManager = [[BMKLocationManager alloc] init];
	_locManager.delegate = self;
	_locManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
	_locManager.distanceFilter = kCLLocationAccuracyBestForNavigation;
	_locManager.desiredAccuracy = kCLLocationAccuracyBest;
	_locManager.activityType = CLActivityTypeAutomotiveNavigation;
	_locManager.pausesLocationUpdatesAutomatically = NO;
	_locManager.allowsBackgroundLocationUpdates = NO;// YES的话是可以进行后台定位的，但需要项目配置，否则会报错，具体参考开发文档
	_locManager.locationTimeout = 10;
	_locManager.reGeocodeTimeout = 10;
	[_locManager setLocatingWithReGeocode:YES];
	//开始定位
	[_locManager startUpdatingLocation];
	//结束定位
	//[locationManager stopUpdatingLocation];
}

#pragma mark - BMKLocationManagerDelegate
/**
 *  @brief 连续定位回调函数。
 *  @param manager 定位 BMKLocationManager 类。
 *  @param location 定位结果，参考BMKLocation。
 *  @param error 错误信息。
 */
- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didUpdateLocation:(BMKLocation * _Nullable)location orError:(NSError * _Nullable)error{
	if (error)
	{
		NSLog(@"locError:{%ld - %@};", (long)error.code, error.localizedDescription);
	} if (location) {//得到定位信息，添加annotation
		if (location.location) {
			NSLog(@"LOC = %@",location.location);
			//完成地理反编码
			//1.创建反向地理编码选项对象
			BMKReverseGeoCodeSearchOption *reverseOption=[[BMKReverseGeoCodeSearchOption alloc]init];
			//2.给反向地理编码选项对象的坐标点赋值
			reverseOption.location=location.location.coordinate;
			//3.执行反地理编码
			[getCodeSearch reverseGeoCode:reverseOption];
		}
		if (location.rgcData) {
			NSLog(@"rgc = %@",[location.rgcData description]);
		}
	}
}

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
	self.signModel.C_DRIVE_ADDRESS = result.address;
	self.signModel.B_DRIVE_LON = [NSString stringWithFormat:@"%f",result.location.longitude];
	self.signModel.B_DRIVE_LAT = [NSString stringWithFormat:@"%f",result.location.latitude];
	[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKWorkWorldSignCell *cell = [MJKWorkWorldSignCell cellWithTableView:tableView];
    cell.titleLabel.textColor = [UIColor darkGrayColor];
	if (indexPath.row == 0) {
		cell.titleImageView.image = [UIImage imageNamed:@"签到地点图标"];
		cell.titleLabel.text = self.signModel.C_DRIVE_ADDRESS.length > 0 ? self.signModel.C_DRIVE_ADDRESS : @"地址";
		cell.rightArrow.hidden = YES;
	} else if (indexPath.row == 1) {
		cell.titleImageView.image = [UIImage imageNamed:@"签到任务图标"];
		cell.titleLabel.text = self.signModel.C_A01200_C_NAME.length > 0 ? self.signModel.C_A01200_C_NAME : @"任务";
		cell.rightArrow.hidden = NO;
	} else {
		cell.titleImageView.image = [UIImage imageNamed:@"艾特图标"];
		cell.titleLabel.text = self.saleName.length > 0 ? self.saleName: @"提醒谁看";
		cell.rightArrow.hidden = NO;
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.row == 1) {
        ServiceTaskViewController*vc=[[ServiceTaskViewController alloc]init];
        vc.vcName = @"打卡";
        vc.chooseTaskBlock = ^(ServiceTaskSubModel *model) {
            weakSelf.signModel.C_A01200_C_ID = model.C_ID;
            weakSelf.signModel.C_A01200_C_NAME = [NSString stringWithFormat:@"%@-%@",model.C_A41500_C_NAME, model.C_TYPE_DD_NAME];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
		[self.navigationController pushViewController:vc animated:YES];
	} else if (indexPath.row == 2) {
		MJKSelectSaleViewController *vc = [[MJKSelectSaleViewController alloc]init];
		vc.vcName = @"订单";
		vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
			weakSelf.saleName = nameStr;
			weakSelf.signModel.X_REMINDING = codeStr;
			[weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
		};
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (self.headerHeight + 90 > 230) {
		return 90 + self.headerHeight;
	}
	return 230;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 275)];
	bgView.backgroundColor = [UIColor whiteColor];
	
	[bgView addSubview:self.textView];
	[bgView addSubview:self.photoView];
	
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

#pragma mark - 发表
- (void)publishedAction:(UIButton *)sender {
	if (self.signModel.B_DRIVE_LON.length <= 0 || self.signModel.B_DRIVE_LAT.length <= 0) {
		[JRToast showWithText:@"请打开定位功能"];
		return;
	}
//    if (self.signModel.C_A41500_C_ID.length <= 0) {
//        [JRToast showWithText:@"请选择客户"];
//        return;
//    }
	if (self.signModel.X_REMARK.length <= 0) {
		[JRToast showWithText:@"请输入内容"];
		return;
	}
//    if (self.signModel.urlList.count <= 0) {
//        [JRToast showWithText:@"请选择图片"];
//        return;
//    }
    if (self.signModel.urlList.count > 0) {
        [self httpPostSignInWithImageStr:self.signModel.urlList];
    } else {
        [self httpPostSignInWithImageStr:nil];
    }
}

//接口
-(void)httpPostSignInWithImageStr:(NSArray*)imageArray{
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"ReservationWebService-insertSign"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:[DBObjectTools getShakeSignInC_id] forKey:@"C_ID"];
	[contentDict setObject:[DBTools getTimeFomatFromCurrentTimeStamp] forKey:@"D_FOLLOW_TIME"];
	if (self.signModel.B_DRIVE_LON&&self.signModel.B_DRIVE_LAT) {
		[contentDict setObject:self.signModel.B_DRIVE_LON forKey:@"B_DRIVE_LON"];
		[contentDict setObject:self.signModel.B_DRIVE_LAT forKey:@"B_DRIVE_LAT"];
	}else{
		[contentDict setObject:@"" forKey:@"B_DRIVE_LON"];
		[contentDict setObject:@"" forKey:@"B_DRIVE_LAT"];
	}
	
	if (self.signModel.C_A41500_C_ID.length > 0) {
		contentDict[@"C_A41500_C_ID"] = self.signModel.C_A41500_C_ID;
		contentDict[@"C_A41500_C_NAME"] = self.signModel.C_A41500_C_NAME;
	} /*else {
	   contentDict[@"C_A41500_C_ID"] = @"";
	   contentDict[@"C_A41500_C_NAME"] = @"";
	   }*/
    
    if (self.signModel.C_A01200_C_ID.length > 0) {
        contentDict[@"C_A01200_C_ID"] = self.signModel.C_A01200_C_ID;
    }
	[contentDict setObject:self.signModel.C_DRIVE_ADDRESS.length > 0 ? self.signModel.C_DRIVE_ADDRESS : @"" forKey:@"C_DRIVE_ADDRESS"];
	NSString *str = self.signModel.X_REMARK;
	//	if (self.model.X_REMARK.length > 0) {
	//		 str = [NSString stringWithFormat:@"%@-%@",self.localAddress, self.model.X_REMARK ];
	//	} else {
	//		str = self.localAddress;
	//	}
	if (str.length > 0) {
		[contentDict setObject:str > 0 ? str : @"" forKey:@"X_REMARK"];
	}
	
	if (self.signModel.X_REMINDING.length > 0) {
		[contentDict setObject:self.signModel.X_REMINDING forKey:@"X_REMINDING"];
	}
	[contentDict setObject:@"1" forKey:@"IS_WORKCIRCLE"];
	
	contentDict[@"urlList"] = imageArray.count > 0 ? imageArray : @[];
	
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isRefresh"];
			[self.navigationController popViewControllerAnimated:YES];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
	
	
	
	
	
}

- (void)textViewDidChange:(UITextView *)textView {
	self.signModel.X_REMARK = textView.text;
}

#pragma mark - set
- (UITextView *)textView {
	if (!_textView) {
		_textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 90)];
		_textView.delegate = self;
		// _placeholderLabel
		UILabel *placeHolderLabel = [[UILabel alloc] init];
		placeHolderLabel.text = @"这一刻的想法...";
		placeHolderLabel.numberOfLines = 0;
		placeHolderLabel.textColor = [UIColor lightGrayColor];
		[placeHolderLabel sizeToFit];
		[_textView addSubview:placeHolderLabel];
		
		// same font
		_textView.font = [UIFont systemFontOfSize:14.f];
		placeHolderLabel.font = [UIFont systemFontOfSize:14.f];
		
		[_textView setValue:placeHolderLabel forKey:@"_placeholderLabel"];
		
	}
	return _textView;
}

- (MJKScratchableLatexPhotoView *)photoView {
	DBSelf(weakSelf);
	if (!_photoView) {
		_photoView = [[MJKScratchableLatexPhotoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.textView.frame), KScreenWidth, (KScreenWidth - 20) / 3)];
		_photoView.rootVC = self;
		_photoView.backUrlArray = ^(NSArray * _Nonnull arr, CGFloat height) {
			NSLog(@"%@ %f",arr, height);
			weakSelf.signModel.urlList = arr;
			weakSelf.headerHeight = height;
			if (height + 90 > 230) {
				[weakSelf.tableView reloadData];
			}
		};
	}
	return _photoView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.bounces = NO;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}
@end
