//
//  MJKTaskWorkListController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/30.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKTaskWorkListController.h"

#import "MJKTaskWorkListModel.h"

#import "MJKTaskWorkListCell.h"

#import "ServiceTaskWorkListViewController.h"

@interface MJKTaskWorkListController ()
/** data array*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKTaskWorkListController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"任务排班列表";
	self.view.backgroundColor = [UIColor whiteColor];
	[self httpAllRequest];
}

- (void)httpAllRequest {
	[self httpGetTaskListData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKTaskWorkListModel *model = self.dataArray[indexPath.row];
	MJKTaskWorkListCell *cell = [MJKTaskWorkListCell cellWithTableView:tableView];
	cell.listModel = model;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section  {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	MJKTaskWorkListModel *model = self.dataArray[indexPath.row];
	ServiceTaskWorkListViewController *vc = [[ServiceTaskWorkListViewController alloc]init];
	vc.userid = model.USER_ID;
	vc.STATUS_TYPE = @"1";
	[self.navigationController pushViewController:vc animated:YES];
}


//MARK:-http request
- (void)httpGetTaskListData {
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A01200WebService-getSchedulingList"];
	[dict setObject:@{} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKTaskWorkListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

@end
