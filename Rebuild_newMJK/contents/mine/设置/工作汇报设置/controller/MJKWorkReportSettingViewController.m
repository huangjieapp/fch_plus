//
//  MJKWorkReportSettingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportSettingViewController.h"

#import "MJKWorkReportSetCell.h"
#import "MJKSeaSettingCell.h"

#import "MJKDataDicModel.h"
#import "MJKCustomReturnSubModel.h"

@interface MJKWorkReportSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 是否编辑*/
@property (nonatomic, assign) BOOL isEdit;
/** 公海规则设置*/
@property (nonatomic, strong) NSArray *seaArrayList;
/** 天数数组*/
@property (nonatomic, strong) NSMutableArray *daysArray;
@end

@implementation MJKWorkReportSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
	if ([self.vcName isEqualToString:@"汇报"]) {
		self.title = @"个人汇报内容设置";
	} else {
		self.title = @"公海流转规则设置";
	}
	
	[self initUI];
}

- (void)initUI {
	self.view.backgroundColor = kBackgroundColor;
	[self.view addSubview:self.tableView];
	if ([self.vcName isEqualToString:@"汇报"]) {
		[self httpGetWorkReportSettingList];
	} else {
		[self getSeaSetList];
	}
//	NSMutableArray *arr = [NSMutableArray array];
	//默认数据
	for (MJKDataDicModel *model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A48700_C_TYPE"]) {
		[self.dataArray addObject:model];
//		//升序
//		self.dataArray = [arr sortedArrayUsingComparator:^NSComparisonResult(MJKDataDicModel * _Nonnull obj1, MJKDataDicModel * _Nonnull obj2) {
//			return [obj1.C_VOUCHERID compare:obj2.C_VOUCHERID];
//		}];
	}
}

#pragma mark - 编辑按钮
- (void)editAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
		[sender setTitleNormal:@"完成"];
		self.isEdit = YES;
//		if (![self.vcName isEqualToString:@"汇报"]) {
			[self.tableView reloadData];
//		}
	} else {
		[sender setTitleNormal:@"编辑"];
		self.isEdit = NO;
		if ([self.vcName isEqualToString:@"汇报"]) {
			[self httpSetWorkReport];
		} else {
			DBSelf(weakSelf);
			[self.view endEditing:YES];
			[self httpSetSeaDaysWithArray:self.daysArray andBlock:^{
				[weakSelf getSeaSetList];
			}];
		}
		
	}
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.vcName isEqualToString:@"汇报"]) {
		return self.dataArray.count;
	} else {
		return self.seaArrayList.count;
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKWorkReportSetCell *cell = [MJKWorkReportSetCell cellWithTableView:tableView];
	if ([self.vcName isEqualToString:@"汇报"]) {
		MJKDataDicModel *model = self.dataArray[indexPath.row];
		//编辑状态时的cell
        cell.nameLabel.text = model.C_NAME;
        if (model.isSelected == YES) {
            cell.openSwitchButton.on = YES;
        } else {
            cell.openSwitchButton.on = NO;
        }
        cell.openSwitchBlock = ^(BOOL isOn) {
            if (isOn == YES) {
                model.selected = YES;
            } else {
                model.selected = NO;
            }
            [weakSelf httpSetWorkReport];
        };

	} else {
		MJKCustomReturnSubModel *model = self.seaArrayList[indexPath.row];
		cell.openSwitchBlock = ^(BOOL isOn) {
			if (isOn == YES) {
				model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";//开启
			} else {
				model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";//关闭
			}
			[weakSelf httpSetSeaWithModel:model];
		};

		cell.seaModel = model;
		if (indexPath.row == self.seaArrayList.count - 1) {
			cell.nameLabel.text = model.C_NAME;
		}
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (![self.vcName isEqualToString:@"汇报"]) {
		return;
	}
	if (self.isEdit == YES) {
		MJKDataDicModel *model = self.dataArray[indexPath.row];
		model.selected = !model.isSelected;
		[tableView reloadData];
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

//开启输入
- (void)alertStyleWithTextField:(id)model {
	DBSelf(weakSelf);
	MJKCustomReturnSubModel *returnModel = (MJKCustomReturnSubModel *)model;
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
	[alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		if ([returnModel.C_NAME isEqualToString:@"领用量"]) {
			textField.placeholder = @"请输入领用量";
        } else if ([returnModel.C_NAME hasPrefix:@"每人有效客户"]) {
            textField.placeholder = @"请输入个数";
        }
        else {
			textField.placeholder = @"请输入天数";
		}
		textField.keyboardType = UIKeyboardTypeNumberPad;
		returnModel.I_NUMBER.length > 0 ? textField.text = returnModel.I_NUMBER : nil;
		
	}];
	
	UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		NSArray * arr = alertC.textFields;
		UITextField * field = arr[0];
		returnModel.I_NUMBER = field.text;
		[weakSelf httpSetSeaDaysWithArray:@[@{@"C_ID" : returnModel.C_ID, @"I_NUMBER" : returnModel.I_NUMBER,@"C_STATUS_DD_ID" : returnModel.C_STATUS_DD_ID}] andBlock:^{
			[weakSelf getSeaSetList];
		}];
		
	}];
	
	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:determineAction];
	[alertC addAction:cancelAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - http get work report setting list
-(void)httpGetWorkReportSettingList{
	DBSelf(weakSelf);
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getReport"];
	NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSString *str = data[@"X_WORKREPORT"];
			NSArray *arr = [str componentsSeparatedByString:@","];
			//默认选中的数据
			for (NSString *str in arr) {
				for (MJKDataDicModel *model in weakSelf.dataArray) {
					if ([str isEqualToString:model.C_VOUCHERID]) {
						model.selected = YES;
					}
				}
			}
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
	
}
#pragma mark - http get sea setting list
-(void)getSeaSetList {
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"TYPE"] = @"2";
	
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	DBSelf(weakSelf);
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			weakSelf.seaArrayList = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}
#pragma mark - http sett work report
-(void)httpSetWorkReport {
	DBSelf(weakSelf);
	//选中的数据
	NSMutableArray *arr = [NSMutableArray array];
	for (MJKDataDicModel *model in weakSelf.dataArray) {
		if (model.isSelected == YES) {
			[arr addObject:model.C_VOUCHERID];
		}
	}
	NSString *str = [arr componentsJoinedByString:@","];
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"UserWebService-setReport"];
	NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
	contentDict[@"X_WORKREPORT"] = str;
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
			[weakSelf httpGetWorkReportSettingList];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
	}];
	
}

#pragma mark - http set sea
-(void)httpSetSeaWithModel:(MJKCustomReturnSubModel *)model {
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
			//[model.C_NAME isEqualToString:@"自己归还自己不能领用"]
//            MJKCustomReturnSubModel *returnModel = self.seaArrayList.lastObject;
            if (![model.C_NAME isEqualToString:@"自己归还的客户，不能领用"]) {
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


#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight , KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.delegate=self;
		_tableView.dataSource=self;
		_tableView.estimatedRowHeight=0;
		_tableView.estimatedSectionHeaderHeight=0;
		_tableView.estimatedSectionFooterHeight=0;
		_tableView.bounces = NO;
	}
	return _tableView;
}

- (NSArray *)dataArray {
	if (!_dataArray) {
		_dataArray = [NSMutableArray array];
	}
	return _dataArray;
}

- (NSMutableArray *)daysArray {
	if (!_daysArray) {
		_daysArray = [NSMutableArray array];
	}
	return _daysArray;
}

@end
