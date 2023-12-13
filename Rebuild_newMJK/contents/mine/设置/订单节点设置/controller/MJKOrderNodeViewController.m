//
//  MJKOrderNodeViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/12.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKOrderNodeViewController.h"

#import "MJKOrderNodeCell.h"

#import "MJKOrderMoneyListModel.h"
#import "MJKNodeListModel.h"

#import "MJKAddOrderNodeViewController.h"//新增节点

@interface MJKOrderNodeViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** data array*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** MJKNodeListModel*/
@property (nonatomic, strong) NSMutableArray *nodePxArray;
@end

@implementation MJKOrderNodeViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	self.title = @"订单节点设置";
	[self.view addSubview:self.tableView];
	[self configRefresh];
}

- (void)configRefresh {
	DBSelf(weakSelf);
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		[weakSelf HttpGetDataList];
	}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKOrderNodeCell *cell = [MJKOrderNodeCell cellWithTableView:tableView];
	if (indexPath.row == self.dataArray.count) {
        [cell.addButton setBackgroundColor:[UIColor whiteColor]];
		[cell.addButton setImage:@"订单节点设置-新增"];
		cell.titleLabel.text = @"新增节点";
		cell.titleLabel.textColor = [UIColor lightGrayColor];
		cell.upButton.hidden = cell.downButton.hidden = YES;
		cell.contentLabel.hidden = YES;
		cell.linkButton.hidden = cell.editButton.hidden = cell.deleteButton.hidden = cell.signButton.hidden = YES;
		cell.addObjectBlock = ^{
			MJKAddOrderNodeViewController *vc = [[MJKAddOrderNodeViewController alloc]init];
			vc.type = NodeAdd;
			vc.index = self.dataArray.count;
			[weakSelf.navigationController pushViewController:vc animated:YES];
		};
	} else {
		MJKOrderMoneyListModel *model = self.dataArray[indexPath.row];
		if (indexPath.row == 0) {//如果第一条，不可再向上
			[cell.upButton setImage:@"icon_up_gray"];
			cell.upButton.enabled = NO;
		} else if (indexPath.row == self.dataArray.count - 1) {//如果最后一条，不可向下
			[cell.downButton setImage:@"icon_down_gray"];
			cell.downButton.enabled = NO;
		} else {
			cell.upButton.enabled = YES;
			cell.downButton.enabled = YES;
		}
		
		cell.model = model;
		//上下移动数据
		cell.exchangeObjectBlock = ^(NSString * _Nonnull name) {
			if ([name isEqualToString:@"up"]) {
				//两个排序值交换
				MJKNodeListModel *model0 = weakSelf.nodePxArray[indexPath.row];
				MJKNodeListModel *model1 = weakSelf.nodePxArray[indexPath.row - 1];
				model0.I_SORTIDX = indexPath.row - 1;
				model1.I_SORTIDX = indexPath.row;
                [weakSelf.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:indexPath.row - 1];
			} else {
				//两个排序值交换
				MJKNodeListModel *model0 = weakSelf.nodePxArray[indexPath.row];
				MJKNodeListModel *model1 = weakSelf.nodePxArray[indexPath.row + 1];
				model0.I_SORTIDX = indexPath.row + 1;
				model1.I_SORTIDX = indexPath.row;
                [weakSelf.dataArray exchangeObjectAtIndex:indexPath.row withObjectAtIndex:indexPath.row + 1];
				
			}
			[weakSelf HttpNodePx];
		};
		//编辑数据
		cell.editObjectBlock = ^(NSString * _Nonnull name) {
			if ([name isEqualToString:@"edit"]) {
				MJKAddOrderNodeViewController *vc = [[MJKAddOrderNodeViewController alloc]init];
				vc.type = NodeEdit;
				vc.c_id = model.C_ID;
				vc.index = model.I_SORTIDX.integerValue;
				[weakSelf.navigationController pushViewController:vc animated:YES];
			} else {
				[weakSelf deleteNodeAlert:model.C_ID];
			}
		};
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArray.count) {
        MJKAddOrderNodeViewController *vc = [[MJKAddOrderNodeViewController alloc]init];
        vc.type = NodeAdd;
        vc.index = self.dataArray.count;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
	bgView.backgroundColor = [UIColor whiteColor];
	
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(71, 0, 10, 10)];
	imageView.image = [UIImage imageNamed:@"topimg"];
	[bgView addSubview:imageView];
	return bgView;
	
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
	bgView.backgroundColor = [UIColor whiteColor];
	
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(71, 0, 10, 10)];
	imageView.image = [UIImage imageNamed:@"topimg"];
	[bgView addSubview:imageView];
	return bgView;
}

#pragma mark - 删除节点提示弹框
- (void)deleteNodeAlert:(NSString *)C_ID {
	DBSelf(weakSelf);
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除该节点" preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf HttpDeleteNode:C_ID];
	}];
	
	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 轨迹列表
- (void)HttpGetDataList {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-getList"];
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"I_TYPE"] = @"1";
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	DBSelf(weakSelf);
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKOrderMoneyListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			weakSelf.nodePxArray = [MJKNodeListModel mj_objectArrayWithKeyValuesArray:data[@"pxList"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		[weakSelf.tableView.mj_header endRefreshing];
	}];
}

#pragma mark 排序
- (void)HttpNodePx {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-setPx"];
	NSMutableDictionary *dic=[NSMutableDictionary new];
	//数组模型转字典
	NSArray *arr = [MJKNodeListModel mj_keyValuesArrayWithObjectArray:self.nodePxArray];
	dic[@"pxList"] = arr;
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	DBSelf(weakSelf);
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
//			[JRToast showWithText:data[@"message"]];
			[weakSelf HttpGetDataList];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark 删除节点
- (void)HttpDeleteNode:(NSString *)C_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-delete"];
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = C_ID;
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	DBSelf(weakSelf);
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HttpGetDataList];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}



@end
