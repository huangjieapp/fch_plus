//
//  MJKMarketSettingEditViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketSettingAddViewController.h"

#import "MJKMarketPickerView.h"
#import "MJKMarketSettingTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"


#import "MJKMarketSetDetailModel.h"


#define InputCell   @"AddCustomerInputTableViewCell"
#define CHooseCell  @"AddCustomerChooseTableViewCell"
#define RemarkCell  @"CGCNewAppointTextCell"
@interface MJKMarketSettingAddViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;//保存按钮
@property (nonatomic, strong) MJKMarketPickerView *pickerView;
@property (nonatomic, strong) MJKMarketSetDetailModel *model;

@property (nonatomic, strong) NSString *random;//32随机数

@end

@implementation MJKMarketSettingAddViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"渠道细分新增";
}

- (void)initUI {
	self.random = [self ret32bitString];
	self.model = [[MJKMarketSetDetailModel alloc]init];
	[self getTimeNow];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.saveButton];
	
    [self.tableView registerNib:[UINib nibWithNibName:InputCell bundle:nil] forCellReuseIdentifier:InputCell];
    [self.tableView registerNib:[UINib nibWithNibName:CHooseCell bundle:nil] forCellReuseIdentifier:CHooseCell];
    [self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    
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
        cell.titleLabel.text = @"备注";
        [cell setBackTextViewBlock:^(NSString *str){
            weakSelf.model.X_REMARK = str;
        }];
        return cell;
    } else {
        MJKMarketSettingTableViewCell *cell = [MJKMarketSettingTableViewCell cellWithTableView:tableView];
        [cell updateAddCellWithTitle:@[@"渠道名称"/*, @"渠道代码",@"渠道状态"*/,@"来源"/*,@"开始时间",@"结束时间"*/][indexPath.row] andModel:self.model andRow:indexPath.row];
        [cell setBackTextBlock:^(NSString *str){
            if (indexPath.row == 0) {
                weakSelf.model.C_NAME = str;
            } else if (indexPath.row == 1) {
                weakSelf.model.C_VOUCHERID = str;
            }
        }];
        return cell;
        
        
    }
    
    
//    if (indexPath.row==0||indexPath.row==1) {
//        AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:InputCell];
//
//        if (indexPath.row==0) {
//            //
//
//        }
//
//
//    }
    
    
    
    
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
	} */else {
		return;
	}
	[self.pickerView popPickerView];
	DBSelf(weakSelf);
	[self.pickerView setSelectTextBlock:^(NSString *name, NSString *code){
		switch (indexPath.row) {
			/*case 2:
                if (name.length > 0) {
                    weakSelf.model.C_STATUS_DD_ID = code.length > 0 ?  code : weakSelf.model.C_STATUS_DD_ID;
                    weakSelf.model.C_STATUS_DD_NAME = name.length > 0 ?  name : weakSelf.model.C_STATUS_DD_NAME ;
                } else {
                    weakSelf.model.C_STATUS_DD_ID = @"0";
                    weakSelf.model.C_STATUS_DD_NAME = @"开启";
                }
				
				break;*/
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
	if (self.model.C_NAME.length <= 0) {
		[JRToast showWithText:@"请输入名称"];
		return;
	}
//    if (self.model.C_VOUCHERID.length <= 0) {
//        [JRToast showWithText:@"请输入代码"];
//        return;
//    }
	if (self.model.C_CLUESOURCE_DD_ID.length <= 0) {
		[JRToast showWithText:@"请选择来源"];
		return;
	}
	
	[self HTTPInsertMarketDatas];
	
}

#pragma mark - HTTP request
- (void)HTTPInsertMarketDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_insertMaketSet];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	//[tempDic setObject:[NSString stringWithFormat:@"A41400-%@",self.random] forKey:@"C_ID"];
	[tempDic setObject:self.model.C_NAME forKey:@"C_NAME"];
//    [tempDic setObject:self.model.C_VOUCHERID forKey:@"C_VOUCHERID"];
    if (self.model.C_STATUS_DD_ID.length > 0) {
        [tempDic setObject:self.model.C_STATUS_DD_ID forKey:@"TYPE"];
    }
	[tempDic setObject:self.model.D_START_TIME.length > 0 ? self.model.D_START_TIME : @"" forKey:@"D_START_TIME"];
	[tempDic setObject:self.model.D_END_TIME.length > 0 ? self.model.D_END_TIME : @"" forKey:@"D_END_TIME"];
    [tempDic setObject:self.model.C_CLUESOURCE_DD_ID.length > 0 ? self.model.C_CLUESOURCE_DD_ID : @"" forKey:@"C_CLUESOURCE_DD_ID"];
	[tempDic setObject:self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"" forKey:@"X_REMARK"];
	[tempDic setObject:@"A41200_C_TYPE_0000" forKey:@"C_TYPE_DD_ID"];
	[dict setObject:tempDic forKey:@"content"];
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

//随机32位随机数
-(NSString *)ret32bitString {
	char data[32];
	for (int x=0;x<32;data[x++] = (char)('A' + (arc4random_uniform(26))));
	return [[NSString alloc] initWithBytes:data length:32 encoding:NSUTF8StringEncoding];
}
//当前时间
- (void)getTimeNow {
	NSDate *date = [NSDate date];
	NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    dataFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dataFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	self.model.D_START_TIME = self.model.D_END_TIME = [dataFormatter stringFromDate:date];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - 48) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
	}
	return _tableView;
}

- (UIButton *)saveButton {
	if (!_saveButton) {
		_saveButton = [[UIButton alloc]initWithFrame:CGRectMake(15, KScreenHeight - 45, KScreenWidth - 30, 40)];
		[_saveButton setTitle:@"保存" forState:UIControlStateNormal];
		[_saveButton setBackgroundColor:KNaviColor];
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
