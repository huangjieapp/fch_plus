//
//  MJKCustomerLabelViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKCustomerLabelViewController.h"
#import "MJKAddCustomerTheLabelViewController.h"//新增标签类型

#import "MJKCustomerLabelModel.h"
#import "MJKCustomerTheLabelModel.h"
#import "MJKCustomerTheLabelSubModel.h"

#import "MJKCustomerLabelCell.h"
#import "MJKAddCustomerTheLabelView.h"

@interface MJKCustomerLabelViewController ()<UITableViewDataSource, UITableViewDelegate>
/** table*/
@property (nonatomic, strong) UITableView *tableView;
/** data Array*/
@property (nonatomic, strong) NSArray *dataArray;
/** label array*/
@property (nonatomic, strong) NSArray *labelArray;

@end

@implementation MJKCustomerLabelViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self HTTPLabelListData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = @"潜客标签设置";
	[self initUI];
//	[self HTTPAddCustomerLabelDatas];
//	[self HTTPLabelListData];
}

- (void)initUI {
	[self.view addSubview:self.tableView];
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, KScreenHeight - SafeAreaBottomHeight - 50, KScreenWidth - 20, 40)];
	[button setTitleNormal:@"新增标签类型"];
	[button setTitleColor:[UIColor blackColor]];
	[button setBackgroundColor:KNaviColor];
	button.layer.cornerRadius = 5.f;
	[button addTarget:self action:@selector(addCustomerButtonAction)];
	[self.view addSubview:button];
}
#pragma mark - 新增标签按钮事件
- (void)addCustomerButtonAction {
	MJKAddCustomerTheLabelViewController *vc = [[MJKAddCustomerTheLabelViewController alloc]initWithNibName:@"MJKAddCustomerTheLabelViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.labelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKCustomerTheLabelModel *model = self.labelArray[indexPath.row];
	MJKCustomerLabelCell *cell = [MJKCustomerLabelCell cellWithTableView:tableView];
	cell.model = model;
	cell.deleteCustomerLabelBlock = ^{
		[weakSelf alertControllerWithModel:model];
	};
	cell.addLabelBlock = ^(UIButton * _Nonnull button) {
		MJKAddCustomerTheLabelView *tlV = [[NSBundle mainBundle]loadNibNamed:@"MJKAddCustomerTheLabelView" owner:nil options:nil].firstObject;
		tlV.inputLabelMessageBlock = ^(NSString * _Nonnull str) {
			[weakSelf HTTPAddLabelDataWithName:str andC_A46600_C_ID:model.type_id];
		};
		[[UIApplication sharedApplication].keyWindow addSubview:tlV];
	};
	//删除单个标签
	cell.deleteTheLabelBlock = ^(NSString * _Nonnull C_ID) {
		[weakSelf HTTPDeleteTheLabelData:C_ID];
	};
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKCustomerTheLabelModel *model = self.labelArray[indexPath.row];
	return [MJKCustomerLabelCell heightForCell:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

#pragma mark - 弹窗提示
- (void)alertControllerWithModel:(MJKCustomerTheLabelModel *)model {
	DBSelf(weakSelf);
	NSString *str = [NSString stringWithFormat:@"是否删除标签类型%@",model.type_name];
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
	
	//修改message
	NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str];
	[alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, str.length)];
	[alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f] range:NSMakeRange(0, str.length)];
	[alertC setValue:alertControllerMessageStr forKey:@"attributedMessage"];

	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf HTTPDeleteCustomerLabelData:model.type_id];
	}];
	[yesAction setValue:KNaviColor forKey:@"titleTextColor"];

	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

	}];
	[noAction setValue:[UIColor lightGrayColor] forKey:@"titleTextColor"];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];

	[self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - http request
#pragma mark 标签类型列表
- (void)HTTPAddCustomerLabelDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46600WebService-getList"];
	[dict setObject:@{} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKCustomerLabelModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}
#pragma mark 删除标签类型
- (void)HTTPDeleteCustomerLabelData:(NSString *)C_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46600WebService-delete"];
	NSMutableDictionary *mtDict = [NSMutableDictionary dictionary];
	mtDict[@"C_ID"] = C_ID;
	[dict setObject:mtDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPLabelListData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark 删除标签类型
- (void)HTTPDeleteTheLabelData:(NSString *)C_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46700WebService-delete"];
	NSMutableDictionary *mtDict = [NSMutableDictionary dictionary];
	mtDict[@"C_ID"] = C_ID;
	[dict setObject:mtDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPLabelListData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark 新增标签
- (void)HTTPAddLabelDataWithName:(NSString *)name andC_A46600_C_ID:(NSString *)C_A46600_C_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46700WebService-insert"];
	NSMutableDictionary *mtDict = [NSMutableDictionary dictionary];
	mtDict[@"C_ID"] = [DBObjectTools getA46700_C_ID];
	mtDict[@"C_NAME"] = name;
	mtDict[@"C_A46600_C_ID"] = C_A46600_C_ID;
	[dict setObject:mtDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPLabelListData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark 标签列表
- (void)HTTPLabelListData {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46700WebService-getList"];
	NSMutableDictionary *mtDict = [NSMutableDictionary dictionary];
	mtDict[@"currPage"] = @"1";
	mtDict[@"pageSize"] = @"10000";
	[dict setObject:mtDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.labelArray = [MJKCustomerTheLabelModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - SafeAreaBottomHeight - NavStatusHeight - WD_TabBarHeight - 60) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

@end
