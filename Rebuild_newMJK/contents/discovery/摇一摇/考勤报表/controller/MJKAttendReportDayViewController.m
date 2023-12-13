//
//  MJKAttendReportDayViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAttendReportDayViewController.h"
#import "MJKPersonAttendanceViewController.h"

#import "MJKMonthStatementsModel.h"

#import "MJKAttendanceMonthCell.h"

@interface MJKAttendReportDayViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tablevie*/
@property (nonatomic, strong) UITableView *tableView;
/** time label*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 条数*/
@property (nonatomic, assign) NSInteger pagen;
/** <#备注#>*/
@property (nonatomic, strong) NSArray *statisticalMonthArray;
@end

@implementation MJKAttendReportDayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

-(void)setupRefresh{
	DBSelf(weakSelf);
	self.pagen=20;
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pagen=20;
		[weakSelf httpMonthStatisticalListSuccess:nil];
		
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf httpMonthStatisticalListSuccess:nil];
		
	}];
	
	[self.tableView.mj_header beginRefreshing];
	
}

- (void)initUI {
	self.title = @"日统计详情";
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.timeLabel];
	self.timeLabel.text = self.timeStr;
	[self.view addSubview:self.tableView];
	[self setupRefresh];
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.statisticalMonthArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKMonthStatementsModel *model = self.statisticalMonthArray[indexPath.section];
	MJKAttendanceMonthCell *cell = [MJKAttendanceMonthCell cellWithTableView:tableView];
	cell.model = model;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 20;
	} else {
		return 10;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKMonthStatementsModel *model = self.statisticalMonthArray[indexPath.section];
	MJKPersonAttendanceViewController *vc = [[MJKPersonAttendanceViewController alloc]init];
	vc.listModel = model;
	vc.timeStr = self.timeStr;
	[self.navigationController pushViewController:vc animated:YES];
}

//MARK:月统计
- (void)httpMonthStatisticalListSuccess:(void(^)(NSArray *modelArray))completeBlock {
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-dailyDetail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.timeStr.length > 0) {
		contentDict[@"DATE"] = [self.timeStr substringToIndex:10];
	}
	contentDict[@"TYPE"] = @"0";
	contentDict[@"currPage"] = @"1";
	contentDict[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
	contentDict[@"C_STATUS_DD_ID"] = self.listModel.C_STATUS_DD_ID;
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.statisticalMonthArray = [MJKMonthStatementsModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (completeBlock) {
				completeBlock(weakSelf.statisticalMonthArray);
			}
			
			[weakSelf.tableView reloadData];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
		
	}];
}

//MARK:-set
- (UILabel *)timeLabel {
	if (!_timeLabel) {
		_timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
		_timeLabel.textColor = [UIColor blackColor];
		_timeLabel.textAlignment = NSTextAlignmentCenter;
		_timeLabel.font = [UIFont systemFontOfSize:14.f];
		
	}
	return _timeLabel;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.timeLabel.frame), KScreenWidth, KScreenHeight - SafeAreaBottomHeight - NavStatusHeight - WD_TabBarHeight - self.timeLabel.frame.size.height ) style:UITableViewStylePlain];
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
