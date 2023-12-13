//
//  MJKPublicMessageViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPublicMessageViewController.h"

#import "MJKPublicMessageListCell.h"

#import "CGCTalkModel.h"

#import "MJKAddPublicMessageViewController.h"

@interface MJKPublicMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** pagen*/
@property (nonatomic, assign) NSInteger pagen;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKPublicMessageViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView.mj_header beginRefreshing];
}

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
	self.title = @"公共消息模板设置";
	self.view.backgroundColor = [UIColor whiteColor];
	[self configNavi];
	[self.view addSubview:self.tableView];
	[self configRefresh];
}

- (void)configNavi {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitleColor:[UIColor blackColor]];
    [button setTitleNormal:@"+"];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button addTarget:self action:@selector(addMessage)];
    
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = item;
	
}
//下拉刷新
- (void)configRefresh {
	DBSelf(weakSelf);
	self.pagen = 20;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pagen = 20;
		[weakSelf HTTPGetTemplateListWithType];
	}];
	
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf HTTPGetTemplateListWithType];
	}];
}

#pragma mark - 点击事件 新增消息
- (void)addMessage {
	MJKAddPublicMessageViewController *vc = [[MJKAddPublicMessageViewController alloc]init];
	vc.type = PublicMessageAdd;
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGCTalkModel *model = self.dataArray[indexPath.row];
	MJKPublicMessageListCell *cell = [MJKPublicMessageListCell cellWithTableView:tableView];
	cell.model = model;
	return cell;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGCTalkModel *model = self.dataArray[indexPath.row];
	return [MJKPublicMessageListCell cellHeight:model];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	CGCTalkModel *model = self.dataArray[indexPath.row];
	UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf alertDelete:model.C_ID];
	}];
	deleteAction.backgroundColor = KNaviColor;
	return @[deleteAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CGCTalkModel *model = self.dataArray[indexPath.row];
	MJKAddPublicMessageViewController *vc = [[MJKAddPublicMessageViewController alloc]init];
	vc.type = PublicMessageEdit;
	vc.model = model;
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 删除提示
- (void)alertDelete:(NSString *)C_ID {
	DBSelf(weakSelf);
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该模板" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf HTTPDeleteMineMessageRequest:C_ID];
	}];
	
	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark --- HTTPRequest 公共模板列表
- (void)HTTPGetTemplateListWithType {//常用公共模板
	
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_getMessageList];
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:@"1" forKey:@"currPage"];
	[dic setObject:@(self.pagen) forKey:@"pageSize"];
	[dic setObject:@"1" forKey:@"TYPE"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [CGCTalkModel mj_objectArrayWithKeyValuesArray:data[@"content"][0][@"array"]];
			[weakSelf.tableView reloadData];
		} else{
			[JRToast showWithText:data[@"message"]];
		}
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark 删除模板
-(void)HTTPDeleteMineMessageRequest:(NSString *)C_ID
{
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_CGC_templateMessageDeleteByID];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	[dic setObject:C_ID forKey:@"C_ID"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.tableView.mj_header beginRefreshing];
			
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
		
	}];
	
	
	
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
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
