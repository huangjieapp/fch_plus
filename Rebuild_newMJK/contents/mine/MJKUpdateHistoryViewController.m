//
//  MJKUpdateHistoryViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKUpdateHistoryViewController.h"
#import "MJKUpdateHistoryDetailViewController.h"

#import "MJKUpdateHistory.h"

@interface MJKUpdateHistoryViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** data*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKUpdateHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initUI];
}

- (void)initUI {
	self.title = @"更新历史";
	[self.view addSubview:self.tableView];
	[self httpGetHistoryDatas];
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKUpdateHistory *model = self.dataArray[indexPath.row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
	if (!cell) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
	}
	cell.textLabel.text = [NSString stringWithFormat:@"脉居客%@",model.C_VERSION_NUMBER];
	cell.detailTextLabel.text = model.D_CREATE_TIME;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//http://121.40.174.159:8585/MJK2.0/mobile/report/about.jsp?C_ID=A42400IAC00001-1634DD76E031209P2TJ4F2DNF6SDMR2F8&C_TYPE_DD_ID=A42400_C_TYPE_0005&APPTYPE=1
	MJKUpdateHistory *model = self.dataArray[indexPath.row];
	MJKUpdateHistoryDetailViewController *vc = [[MJKUpdateHistoryDetailViewController alloc]init];
	vc.C_ID = model.C_ID;
	vc.C_TYPE_DD_ID = model.C_TYPE_DD_ID;
	vc.APPTYPE = @"0";
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - datas
- (void)httpGetHistoryDatas {
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	contentDict[@"C_APP_DD_ID"] = @"A42400_C_APP_0000";
	
	DBSelf(weakSelf);
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a424/historyList", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKUpdateHistory mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
			[self.tableView reloadData];
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
		
	}];
}


- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight) style:UITableViewStylePlain];
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

@end
