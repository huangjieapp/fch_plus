//
//  MJKMarketSettingEditViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKTaskTypeSettingAddViewController.h"
#import "AddCustomerInputTableViewCell.h"
#import "MJKProductShowModel.h"

@interface MJKTaskTypeSettingAddViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;//保存按钮

@property (nonatomic, strong) NSString *random;//32随机数

/** MJKProductShowModel*/
@property (nonatomic, strong) MJKProductShowModel *productModel;

@end

@implementation MJKTaskTypeSettingAddViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initUI];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title=@"任务类型新增";
    self.productModel = [[MJKProductShowModel alloc]init];
    self.productModel.C_ID = [DBObjectTools getA70600C_id];
    self.productModel.C_TYPE_DD_ID = @"A70600_C_TYPE_0002";
}

- (void)initUI {
	self.random = [self ret32bitString];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.saveButton];
	
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    cell.nameTitleLabel.text = @"分类名称";
    if (self.productModel.C_NAME.length > 0) {
        cell.inputTextField.text = self.productModel.C_NAME;
    }
    //        UIButton*findCopyButton=[cell viewWithTag:110];
    cell.inputTextField.delegate=self;
    cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
    [cell.inputTextField addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
    return cell;
}

- (void)changeText:(UITextField *)tf {
    self.productModel.C_NAME = tf.text;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    return 44;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.view endEditing:YES];
}

#pragma mark - 点击事件
- (void)saveButtonAction:(UIButton *)sender {
    if (self.productModel.C_NAME.length <= 0) {
        [JRToast showWithText:@"请输入分类名称"];
        return;
    }
	
	[self HTTPInsertMarketDatas];
	
}

#pragma mark - HTTP request
- (void)HTTPInsertMarketDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-insert"];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    tempDic[@"C_ID"] = self.productModel.C_ID;
    tempDic[@"C_NAME"] = self.productModel.C_NAME;
    tempDic[@"C_TYPE_DD_ID"] = self.productModel.C_TYPE_DD_ID;
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

@end
