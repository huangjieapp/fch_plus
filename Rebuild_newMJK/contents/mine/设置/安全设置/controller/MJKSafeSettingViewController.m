//
//  MJKSafeSettingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSafeSettingViewController.h"

#import "MJKCustomReturnSubModel.h"

#import "MJKWorkReportSetCell.h"
#import "MJKSeaSettingCell.h"

@interface MJKSafeSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** MJKCustomReturnModel array*/
@property (nonatomic, strong) NSMutableArray *safeModelArray;
/** 编辑*/
@property (nonatomic, assign) BOOL isEdit;
/** <#备注#>*/
@property (nonatomic, strong) NSMutableArray *daysArray;

@end

@implementation MJKSafeSettingViewController

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
	self.title = @"安全设置";
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
	[self HTTPSafeSetDatas];
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.safeModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKCustomReturnSubModel *model = self.safeModelArray[indexPath.row];
	MJKWorkReportSetCell *cell = [MJKWorkReportSetCell cellWithTableView:tableView];
	cell.safeModel = model;
	cell.openSwitchBlock = ^(BOOL isOn) {
		if (isOn == YES) {
			model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
		} else {
			model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
		}
		[weakSelf httpSetSafeWithModel:model];
	};
	return cell;
}

//开启输入
- (void)alertStyleWithTextField:(id)model {
	DBSelf(weakSelf);
	MJKCustomReturnSubModel *returnModel = (MJKCustomReturnSubModel *)model;
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入未登录系统,启用短信验证天数" preferredStyle:UIAlertControllerStyleAlert];
	[alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		
		textField.placeholder = @"请输入天数";
		
		textField.keyboardType = UIKeyboardTypeNumberPad;
		returnModel.I_NUMBER.length > 0 ? textField.text = returnModel.I_NUMBER : nil;
		
	}];
	
	UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSArray * arr = alertC.textFields;
		UITextField * field = arr[0];
		returnModel.I_NUMBER = field.text;
		[weakSelf httpSetSeaDaysWithArray:@[@{@"C_ID" : returnModel.C_ID, @"I_NUMBER" : returnModel.I_NUMBER,@"C_STATUS_DD_ID" : returnModel.C_STATUS_DD_ID}] andBlock:^{
			[weakSelf HTTPSafeSetDatas];
		}];
		
	}];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:determineAction];
	[alertC addAction:cancelAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
}

//MARK:-http
- (void)HTTPSafeSetDatas {
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"TYPE"] = @"3";
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			if (weakSelf.safeModelArray.count > 0) {
				[weakSelf.safeModelArray removeAllObjects];
			}
			NSArray *array = data[@"data"][@"content"];
			for (NSDictionary *dic in array) {
				MJKCustomReturnSubModel *safeModel = [MJKCustomReturnSubModel yy_modelWithDictionary:dic];
				[weakSelf.safeModelArray addObject:safeModel];
			}
			
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

//MARK: -  http set sea
-(void)httpSetSafeWithModel:(MJKCustomReturnSubModel *)model {
		DBSelf(weakSelf);
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
	NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
	contentDict[@"C_ID"] = model.C_ID;
	contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
//			[JRToast showWithText:data[@"message"]];
			if ([model.C_NAME isEqualToString:@"未登录系统"]) {
				if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
					[weakSelf alertStyleWithTextField:model];
				}
			}
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
	
}

#pragma mark - http set sea days
-(void)httpSetSeaDaysWithArray:(NSArray *)array andBlock:(void(^)(void))completeBlock {
	//	DBSelf(weakSelf);
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : array} compliation:^(id data, NSError *error) {
	
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			//			[JRToast showWithText:data[@"message"]];
			if (completeBlock) {
				completeBlock();
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
	}];
	
}

//MARK:-set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (NSMutableArray *)safeModelArray {
	if (!_safeModelArray) {
		_safeModelArray = [NSMutableArray array];
	}
	return _safeModelArray;
}

- (NSMutableArray *)daysArray {
	if (!_daysArray) {
		_daysArray = [NSMutableArray array];
	}
	return _daysArray;
}

@end
