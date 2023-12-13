//
//  MJKMarketSettingEditViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKTaskTypeSettingEditViewController.h"

#import "AddCustomerInputTableViewCell.h"
#import "MJKProductShowModel.h"


@interface MJKTaskTypeSettingEditViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *saveButton;//保存按钮
@end

@implementation MJKTaskTypeSettingEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
    self.navigationItem.title = @"任务类型修改";
    self.view.backgroundColor = [UIColor whiteColor];
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-update"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.productModel.C_ID;
    contentDic[@"C_NAME"] = self.productModel.C_NAME;
    [dict setObject:contentDic forKey:@"content"];
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


@end
