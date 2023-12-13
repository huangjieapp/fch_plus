//
//  MJKMarketSettingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKTaskTypeSettingViewController.h"
#import "MJKTaskTypeSettingDetailViewController.h"
#import "MJKTaskTypeSettingAddViewController.h"
#import "MJKTaskTypeSettingEditViewController.h"

#import "MJKSettingHeadView.h"
#import "CustomerLvevelNextFollowModel.h"

#import "MJKMarketSettingTableViewCell.h"

@interface MJKTaskTypeSettingViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MJKSettingHeadView *headView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) UIButton *addButton;//添加
@property (nonatomic, strong) NSArray *productArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *searchStr;
@end

@implementation MJKTaskTypeSettingViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
    [self HTTPGetMarkDatas];
	
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"任务类型";
	[self initUI];
}

- (void)initUI {
	
		[self.view addSubview:self.searchBar];
	
	
	self.headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.searchBar.frame.size.height, KScreenWidth, 30)];
	[self.view addSubview:self.headView];
	
		self.headView.headTitleArray = @[@"任务名称", @""];
	
	
	[self.view addSubview:self.tableView];
	self.pagen = 20;
	[self setUpRefresh];
	[self.view addSubview:self.addButton];
	
}

-(void)setUpRefresh{
	self.pages = 1;
	DBSelf(weakSelf);
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
        [weakSelf HTTPGetMarkDatas];
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
	}];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.productArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomerLvevelNextFollowModel *model = self.productArray[indexPath.row];
    MJKMarketSettingTableViewCell *cell = [MJKMarketSettingTableViewCell cellWithTableView:tableView];
    [cell updateCell:model.C_NAME andStatus:@""];
    return cell;
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
	return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	CustomerLvevelNextFollowModel *model = self.productArray[indexPath.row];
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否确认删除" message:nil preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf HTTPDeleteDatas:model.C_ID];
	}];
	
	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
	
	
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKProductShowModel *model = self.productArray[indexPath.row];
    MJKTaskTypeSettingEditViewController *detailVC = [[MJKTaskTypeSettingEditViewController alloc]init];
    detailVC.productModel = model;
    [self.navigationController pushViewController:detailVC animated:YES];
	
	
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchStr = searchText;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 点击事件
- (void)addButtonAction:(UIButton *)sender {
	
		MJKTaskTypeSettingAddViewController *addVC = [[MJKTaskTypeSettingAddViewController alloc]init];
		[self.navigationController pushViewController:addVC animated:YES];
	
}

#pragma mark - HTTP request
- (void)HTTPGetMarkDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-getList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0002";
    contentDic[@"ISPAGE"] = @"1";
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = [NSString stringWithFormat:@"%ld", (long)self.pagen];
    contentDic[@"C_NAME"] = self.searchStr;
    [dict setObject:contentDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.productArray = [CustomerLvevelNextFollowModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
	}];
}

- (void)HTTPDeleteDatas:(NSString *)C_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-delete"];
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

#pragma mark - set
- (UISearchBar *)searchBar {
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 50)];
		_searchBar.placeholder = @"分类名称";
		_searchBar.delegate = self;
	}
	return _searchBar;
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.searchBar.frame.size.height + self.headView.frame.size.height, KScreenWidth, KScreenHeight - self.searchBar.frame.size.height - self.headView.frame.size.height - 64) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
	}
	return _tableView;
}

- (UIButton *)addButton {
	if (!_addButton) {
		_addButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 40) / 2, KScreenHeight - 40 - 10, 40, 40)];
		[_addButton setBackgroundImage:[UIImage imageNamed:@"addimg.png"] forState:UIControlStateNormal];
		[_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:_addButton];
	}
	return _addButton;
}

@end
