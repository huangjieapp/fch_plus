//
//  MJKMarketSettingDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketSettingDetailViewController.h"
#import "MJKMarketSettingEditViewController.h"

#import "MJKMarketSettingTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"

#import "MJKMarketSetDetailModel.h"

@interface MJKMarketSettingDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKMarketSetDetailModel *detailModel;
@end

@implementation MJKMarketSettingDetailViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self HTTPGetMarkDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"渠道细分详情";
	[self initUI];
	[self.view addSubview:self.tableView];
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		
		
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
}

- (void)initUI {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
	[button setTitle:@"修改" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[button addTarget:self action:@selector(clickEidtButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
	self.navigationItem.rightBarButtonItem = barButton;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 2) {
		MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
		cell.titleLabel.text = @"备注";
		cell.memoTextView.editable = NO;
		cell.memoTextView.text = self.detailModel.X_REMARK;
		return cell;
	} else {
		MJKMarketSettingTableViewCell *cell = [MJKMarketSettingTableViewCell cellWithTableView:tableView];
		if (self.detailModel != nil) {
			[cell updateDetailCellWithTitle:@[@"渠道名称"/*, @"渠道代码",@"渠道状态"*/,@"来源"/*,@"开始时间",@"结束时间"*/][indexPath.row] andDetailContent:@[self.detailModel.C_NAME,/*self.detailModel.C_VOUCHERID,self.detailModel.C_STATUS_DD_NAME,*/self.detailModel.C_CLUESOURCE_DD_NAME/*,self.detailModel.D_START_TIME,self.detailModel.D_END_TIME*/][indexPath.row]];
		}
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

#pragma mark - 点击事件
- (void)clickEidtButton:(UIButton *)sender {
	MJKMarketSettingEditViewController *editVC = [[MJKMarketSettingEditViewController alloc]init];
//    editVC.model = self.detailModel;
	[self.navigationController pushViewController:editVC animated:YES];
}

#pragma mark - HTTP request
- (void)HTTPGetMarkDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getMarketBeanById];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	[tempDic setObject:self.model.C_ID forKey:@"C_ID"];
	[dict setObject:tempDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			self.detailModel = [MJKMarketSetDetailModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

@end
