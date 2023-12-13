//
//  MJKSalesPromotionActivityViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/10.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKSalesPromotionActivityViewController.h"
#import "MJKAddSalesActivityViewController.h"

#import "MJKMarketSubModel.h"

#import "MJKSalesPromotionActivityCell.h"

@interface MJKSalesPromotionActivityViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
/** pages*/
@property (nonatomic, assign)  NSInteger pages;
/** searchStr*/
@property (nonatomic, strong) NSString *searchStr;
/** data*/
@property (nonatomic, strong) NSArray *dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@end

@implementation MJKSalesPromotionActivityViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
	self.title = @"促销活动设置";
	self.tableView.tableFooterView = [[UIView alloc]init];
	self.searchStr = @"";
	[self setRefresh];
}

- (void)setRefresh {
	DBSelf(weakSelf);
	self.pages = 20;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 20;
		[weakSelf HTTPSalesPromotionActivityDatas];
	}];
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pages += 20;
		[weakSelf HTTPSalesPromotionActivityDatas];
	}];
//	[self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKMarketSubModel *model = self.dataArray[indexPath.row];
	MJKSalesPromotionActivityCell *cell = [MJKSalesPromotionActivityCell cellWithTableView:tableView];
	cell.model = model;
	return cell;
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	self.searchStr = searchText;
	[self.tableView.mj_header beginRefreshing];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKMarketSubModel *subModel = self.dataArray[indexPath.row];
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf HTTPDeleteDatas:subModel.C_ID];
	}];
	
	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKMarketSubModel *subModel = self.dataArray[indexPath.row];
	MJKAddSalesActivityViewController *vc = [[MJKAddSalesActivityViewController alloc]initWithNibName:@"MJKAddSalesActivityViewController" bundle:nil];
	vc.C_ID = subModel.C_ID;
	vc.salesActivityType = SalesActivityEdit;
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新增促销活动
- (IBAction)addButtonAction:(UIButton *)sender {
	MJKAddSalesActivityViewController *vc = [[MJKAddSalesActivityViewController alloc]initWithNibName:@"MJKAddSalesActivityViewController" bundle:nil];
	vc.salesActivityType = SalesActivityAdd;
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http 促销活动
- (void)HTTPSalesPromotionActivityDatas {
	DBSelf(weakSelf);
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKMarketSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
	
}

- (void)HTTPDeleteDatas:(NSString *)C_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A41200WebService-DeleteByID"];
	[dict setObject:@{@"C_ID" : C_ID} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.tableView.mj_header beginRefreshing];
			[JRToast showWithText:@"删除成功"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}



@end
