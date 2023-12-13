//
//  MJKOnlineMainHallViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOnlineMainHallViewController.h"

#import "MJKOnlineMainHallModel.h"
#import "MJKOnlineMainHallSubModel.h"

#import "MJKOnlineMainTableViewCell.h"

@interface MJKOnlineMainHallViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) MJKOnlineMainHallModel *hallModel;
@end

@implementation MJKOnlineMainHallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.view.backgroundColor = [UIColor whiteColor];
	self.pagen = 20;
	[self setUpRefresh];
	[self HTTPGetOnlineHallDatas];
	[self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.hallModel.content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKOnlineMainHallSubModel *subModel = self.hallModel.content[indexPath.section];
	MJKOnlineMainTableViewCell *cell = [MJKOnlineMainTableViewCell cellWithTableView:tableView];
	cell.model = subModel;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 99;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKOnlineMainHallSubModel *subModel = self.hallModel.content[indexPath.section];
	if ([subModel.status isEqualToString:@"0"]) {
		return;
	}
	
}

-(void)setUpRefresh{
	self.pages = 1;
	DBSelf(weakSelf);
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
		[weakSelf HTTPGetOnlineHallDatas];
		
		
		[weakSelf.tableView.mj_header endRefreshing];
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf HTTPGetOnlineHallDatas];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark - HTTP request
- (void)HTTPGetOnlineHallDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getOnlineHallList];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:[NSString stringWithFormat:@"%ld",self.pages] forKey:@"currPage"];
	[dic setObject:[NSString stringWithFormat:@"%ld",self.pagen] forKey:@"pageSize"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.hallModel = [MJKOnlineMainHallModel yy_modelWithDictionary:data];
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

@end
