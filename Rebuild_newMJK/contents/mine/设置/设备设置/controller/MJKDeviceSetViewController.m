//
//  MJKDeviceSetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKDeviceSetViewController.h"
#import "MJKEditDeviceSetViewController.h"

#import "MJKDeviceTitleView.h"
#import "MJKDeviceSetListCell.h"
#import "MJKDevicePushScreenSetCell.h"

#import "MJKFlowInstrumentSubModel.h"

@interface MJKDeviceSetViewController ()<UITableViewDataSource, UITableViewDelegate>
/** titleView*/
@property (nonatomic, strong) MJKDeviceTitleView *titleView;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** pagen*/
@property (nonatomic, assign) NSInteger pagen;
/** data array*/
@property (nonatomic, strong) NSArray *dataArray;
/** add button*/
@property (nonatomic, strong) UIButton *addButton;
/** 是否默认推送*/
@property (nonatomic, assign) BOOL isNormalSet;
/** 选择的默认屏*/
@property (nonatomic, strong) NSMutableArray *screenArray;
@end

@implementation MJKDeviceSetViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	NSString *refresh = [[NSUserDefaults standardUserDefaults]objectForKey:@"isRefresh"];
	if ([refresh isEqualToString:@"YES"]) {
		[self.tableView.mj_header beginRefreshing];
	}
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isRefresh"];
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.title = @"屏幕管理设置";
	[self initRefresh];
	[self.view addSubview:self.titleView];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.addButton];
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn-返回" highImage:nil isLeft:YES target:self andAction:@selector(back)];
	
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
	[button setTitleNormal:@"推送屏"];
	[button setTitleColor:[UIColor blackColor]];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button addTarget:self action:@selector(pushScreen)];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = item;
	
}

- (void)initRefresh {
	DBSelf(weakSelf);
	self.pagen = 20;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf httpGetDeviceList];
	}];
	
//	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//
//	}];
	[self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKFlowInstrumentSubModel *model = self.dataArray[indexPath.row];
	if (self.isNormalSet == NO) {
		MJKDeviceSetListCell *cell = [MJKDeviceSetListCell cellWithTableView:tableView];
		cell.model = model;
		cell.editButtonActionBlock = ^{
			MJKEditDeviceSetViewController *vc = [[MJKEditDeviceSetViewController alloc]initWithNibName:@"MJKEditDeviceSetViewController" bundle:nil];
			vc.model = model;
			[weakSelf.navigationController pushViewController:vc animated:YES];
		};
		cell.deleteButtonActionBlock = ^{
			[weakSelf alertV:model];
		};
		return cell;
	} else {
		MJKDevicePushScreenSetCell *cell = [MJKDevicePushScreenSetCell cellWithTableView:tableView];
		cell.model = model;
		cell.selectBackBlock = ^{
			for (MJKFlowInstrumentSubModel *model in self.dataArray) {
				if ([model.ISCHECK isEqualToString:@"true"]) {
					[weakSelf.screenArray addObject:model.C_ID];
				} else {
					if ([weakSelf.screenArray containsObject:model.C_ID]) {
						[weakSelf.screenArray removeObject:model.C_ID];
					}
				}
			}
			[weakSelf httpDefaultDevice];
		};
		return cell;
	}
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

#pragma mark - 删除屏幕
- (void)alertV:(MJKFlowInstrumentSubModel *)model {
	DBSelf(weakSelf);
	NSString *message = [NSString stringWithFormat:@"是否删除%@位置的屏幕",model.C_POSITION];
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf httpDeleteDevice:model];
	}];
	
	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 推送屏
- (void)pushScreen {
	self.isNormalSet = YES;
	self.navigationItem.rightBarButtonItem.customView.hidden = YES;
	self.addButton.hidden = YES;
	[self.tableView reloadData];
}

- (void)back {
	if (self.isNormalSet == NO) {
		[self.navigationController popViewControllerAnimated:YES];
	} else {
		self.isNormalSet = NO;
		self.navigationItem.rightBarButtonItem.customView.hidden = NO;
		self.addButton.hidden = NO;
		[self.tableView reloadData];
	}
}

#pragma mark - http data
- (void)httpGetDeviceList {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getFlowSetList];
	[dict setObject:@{@"currPage" : @"1", @"pageSize" : @"1000", @"TYPE" : @"4", @"ISPAGE" : @"1"} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKFlowInstrumentSubModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
				[weakSelf.tableView reloadData];
			[weakSelf.tableView.mj_header endRefreshing];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}


#pragma mark - http delete
- (void)httpDeleteDevice:(MJKFlowInstrumentSubModel *)model {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_deleteFlowSet];
	NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
	contentDic[@"C_ID"] = model.C_ID;
	[dict setObject:contentDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.tableView.mj_header beginRefreshing];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark 配置默认推送屏
- (void)httpDefaultDevice {
	NSString *screenStr = [self.screenArray componentsJoinedByString:@","];
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-setDefaultScreen"];
	NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
	contentDic[@"X_DEFAULTSCREEN"] = screenStr;
	[dict setObject:contentDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
//			[weakSelf.tableView.mj_header beginRefreshing];
			[weakSelf httpGetDeviceList];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - 添加屏幕设置
- (void)addButtonAction:(UIButton *)sender {
	MJKEditDeviceSetViewController *vc = [[MJKEditDeviceSetViewController alloc]initWithNibName:@"MJKEditDeviceSetViewController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - set
- (MJKDeviceTitleView *)titleView {
	if (!_titleView) {
		_titleView = [[MJKDeviceTitleView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40) andTitleArr:@[@"编号",@"位置",@"操作"]];
	}
	return _titleView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), KScreenWidth, KScreenHeight - self.titleView.frame.origin.y - self.titleView.frame.size.height - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (UIButton *)addButton {
	if (!_addButton) {
		_addButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 50) / 2, KScreenHeight - SafeAreaBottomHeight - 50 - 30, 50, 50)];
		[_addButton setImage:@"addimg"];
		[_addButton addTarget:self action:@selector(addButtonAction:)];
	}
	return _addButton;
}

- (NSMutableArray *)screenArray {
	if (!_screenArray) {
		_screenArray = [NSMutableArray array];
	}
	return _screenArray;
}
@end
