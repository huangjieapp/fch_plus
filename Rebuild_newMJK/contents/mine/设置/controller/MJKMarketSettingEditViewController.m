//
//  MJKMarketSettingEditViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketSettingEditViewController.h"

#import "MJKMarketPickerView.h"
#import "MJKMarketSettingTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"

@interface MJKMarketSettingEditViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;//保存按钮
@property (nonatomic, strong) MJKMarketPickerView *pickerView;

@property (nonatomic, strong) MJKMarketSetDetailModel *model;
@end

@implementation MJKMarketSettingEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"渠道细分修改";
    self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.saveButton];
    [self HTTPGetMarkDatas];
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.row == 2) {
		MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
		cell.memoTextView.text = self.model.X_REMARK;
        cell.titleLabel.text = @"备注";
		[cell setBackTextViewBlock:^(NSString *str){
			weakSelf.model.X_REMARK = str;
		}];
		return cell;
	} else {
		
		MJKMarketSettingTableViewCell *cell = [MJKMarketSettingTableViewCell cellWithTableView:tableView];
        [cell updateEditCellWithTitle:@[@"渠道名称"/*, @"渠道代码",@"渠道状态"*/,@"来源"/*,@"开始时间",@"结束时间"*/][indexPath.row] andDetailContent:@[self.model.C_NAME.length > 0 ? self.model.C_NAME : @"",/*self.model.C_VOUCHERID.length > 0 ? self.model.C_VOUCHERID : @"",self.model.C_STATUS_DD_NAME,*/self.model.C_CLUESOURCE_DD_NAME.length > 0 ? self.model.C_CLUESOURCE_DD_NAME : @""/*,self.model.D_START_TIME,self.model.D_END_TIME*/][indexPath.row]];
		[cell setBackTextBlock:^(NSString *str){
			if (indexPath.row == 0) {
				weakSelf.model.C_NAME = str;
			} else if (indexPath.row == 1) {
				weakSelf.model.C_VOUCHERID = str;
			}
		}];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2) {
		return 44 + 66;
	} else {
		return 44;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self.view endEditing:YES];
	self.pickerView = nil;
	/*if (indexPath.row == 2) {
		self.pickerView.hidden = NO;
		self.pickerView.dataArray = @[@"开启", @"关闭"];
		self.pickerView.style = PickerViewDataStyle;
	} else*/ if (indexPath.row == 1) {
		self.pickerView.hidden = NO;
		NSArray <MJKDataDicModel *>*arr = [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
		self.pickerView.modelArray = arr;
		self.pickerView.style = PickerViewDataStyle;
	}/* else if (indexPath.row == 3 || indexPath.row == 4) {
		self.pickerView.hidden = NO;
		self.pickerView.style = PickerViewDateStyle;
	}*/ else {
		return;
	}
	[self.pickerView popPickerView];
	DBSelf(weakSelf);
	[self.pickerView setSelectTextBlock:^(NSString *name, NSString *code){
		switch (indexPath.row) {
//            case 2:
//                if (name.length > 0) {
//                    weakSelf.model.C_STATUS_DD_ID = code.length > 0 ?  code : weakSelf.model.C_STATUS_DD_ID;
//                    weakSelf.model.C_STATUS_DD_NAME = name.length > 0 ?  name : weakSelf.model.C_STATUS_DD_NAME ;
//                } else {
//                    weakSelf.model.C_STATUS_DD_ID = @"0";
//                    weakSelf.model.C_STATUS_DD_NAME = @"开启";
//                }
//
//                break;
            case 1:
                weakSelf.model.C_CLUESOURCE_DD_ID = code.length > 0 ? code : weakSelf.model.C_CLUESOURCE_DD_ID;
                weakSelf.model.C_CLUESOURCE_DD_NAME = name.length > 0 ?  name : weakSelf.model.C_CLUESOURCE_DD_NAME;
                break;
			/*case 3:
				weakSelf.model.D_START_TIME = name.length > 0 ? name : weakSelf.model.D_START_TIME;
				break;
			case 4:
				weakSelf.model.D_END_TIME = name.length > 0 ? name : weakSelf.model.D_END_TIME;
				break;*/
				
			default:
				break;
		}
		[weakSelf.tableView reloadData];
	}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}

#pragma mark - 点击事件
- (void)saveButtonAction:(UIButton *)sender {
	[self HTTPUpdateMarketDatas];
	
}

#pragma mark - HTTP request
- (void)HTTPUpdateMarketDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updateMaketSet];
	[dict setObject:@{@"C_ID" : self.model.C_ID, @"C_NAME" : self.model.C_NAME, /*@"C_VOUCHERID" : self.model.C_VOUCHERID, @"TYPE" : self.model.C_STATUS_DD_ID, @"D_START_TIME" : self.model.D_START_TIME, @"D_END_TIME" : self.model.D_END_TIME,*/ @"C_CLUESOURCE_DD_ID" : self.model.C_CLUESOURCE_DD_ID, @"X_REMARK" : self.model.X_REMARK} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPGetMarkDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getMarketBeanById];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    [tempDic setObject:self.C_ID forKey:@"C_ID"];
    [dict setObject:tempDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            self.model = [MJKMarketSetDetailModel yy_modelWithDictionary:data];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 50) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

- (UIButton *)saveButton {
	if (!_saveButton) {
		_saveButton = [[UIButton alloc]initWithFrame:CGRectMake(15, KScreenHeight - 45, KScreenWidth - 30, 40)];
		[_saveButton setTitle:@"保存" forState:UIControlStateNormal];
		[_saveButton setBackgroundColor:KNaviColor/*DBColor(229, 227, 43)*/];
		_saveButton.layer.cornerRadius = 5.0f;
		[_saveButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _saveButton;
}

- (MJKMarketPickerView *)pickerView {
	if (!_pickerView) {
		_pickerView = [[MJKMarketPickerView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:_pickerView];
	}
	return _pickerView;
}

@end
