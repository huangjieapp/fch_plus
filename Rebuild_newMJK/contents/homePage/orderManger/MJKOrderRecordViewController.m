//
//  MJKOrderRecordViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKOrderRecordViewController.h"

#import "addDealViewController.h"

#import "MJKOrderRecordModel.h"

#import "MJKOrderRecordTableViewCell.h"

@interface MJKOrderRecordViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *totalView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) UILabel *totalLabel;//已付金额
@end

@implementation MJKOrderRecordViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"收款记录";
	self.view.backgroundColor = kBackgroundColor;
	if (@available(iOS 11.0,*)) {	self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
   	[self initUI];
	[self createNav];
}

- (void)initUI {
	[self.view addSubview:self.totalView];
	[self.view addSubview:self.tableView];
	[self setRefresh];
}

- (void)createNav {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
	[button setTitleNormal:@"收款/退款"];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button setTitleColor:[UIColor blackColor]];
	[button addTarget:self action:@selector(addOrderRecord)];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = item;
}

- (void)setRefresh {
	DBSelf(weakSelf);
	self.pagen = 20;
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pagen = 20;
		[weakSelf httpPostGetshowInfo];
		
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		self.pagen += 20;
		[weakSelf httpPostGetshowInfo];
	}];
//	[self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKOrderRecordModel *model = self.dataArr[indexPath.row];
	MJKOrderRecordTableViewCell *cell = [MJKOrderRecordTableViewCell cellWithTableView:tableView];
	cell.timeLabel.text = [NSString stringWithFormat:@"%@ %@",model.D_CREATE_DATE, model.D_CREATE_TIME];
	cell.totalLabel.text = model.AMOUNT;
	cell.categoryLabel.text = model.C_TYPE_DD_NAME;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 60;
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


- (void)addOrderRecord{
	addDealViewController *vc = [[addDealViewController alloc]init];
	vc.C_ORDER_ID = self.C_A42000_C_ID;
	vc.vcName = @"收款/退款";
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http request
-(void)httpPostGetshowInfo{
	self.dataArr = nil;
	DBSelf(weakSelf);	NSDictionary*contentDict=@{@"pageNum":@"1",@"pageSize":@(self.pagen),@"C_ORDER_ID":self.C_A42000_C_ID};
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a042/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			MJKOrderRecordMainModel *model = [MJKOrderRecordMainModel yy_modelWithDictionary:data[@"data"]];
			NSString *yfStr = [NSString stringWithFormat:@"%@元",model.yfTotal];
			CGSize size = [yfStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 40.f) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:20.f]} context:nil].size;
			weakSelf.totalLabel.frame = CGRectMake(KScreenWidth - size.width - 10, 0, size.width, 40);
			weakSelf.totalLabel.text = yfStr;
			
			NSArray *arr = data[@"data"][@"content"];
			for (int i = 0; i < arr.count; i++) {
				MJKOrderRecordModel *model = [MJKOrderRecordModel yy_modelWithDictionary:arr[i]];
				[weakSelf.dataArr addObject:model];
			}
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
		
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
		
	}];
	
	
}

#pragma mark - set
- (UIView *)totalView {
	if (!_totalView) {
		_totalView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
		_totalView.backgroundColor = [UIColor whiteColor];
		UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
		nameLabel.text = @"已付金额";
		nameLabel.font = [UIFont systemFontOfSize:14.f];
		nameLabel.textColor = [UIColor blackColor];
		[_totalView addSubview:nameLabel];
		
		self.totalLabel = [[UILabel alloc]init];
		self.totalLabel.font = [UIFont systemFontOfSize:20.f];
		self.totalLabel.textColor = [UIColor blackColor];
		[_totalView addSubview:self.totalLabel];
	}
	return _totalView;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.totalView.frame) + 1, KScreenWidth - 20, KScreenHeight - self.totalView.frame.size.height - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight)];
		_tableView.delegate = self;
		_tableView.dataSource =self;
		_tableView.backgroundColor = kBackgroundColor;
		_tableView.tableFooterView=[[UIView alloc] init];
	}
	return _tableView;
}

- (NSMutableArray *)dataArr {
	if (!_dataArr) {
		_dataArr = [NSMutableArray array];
	}
	return _dataArr;
}

@end
