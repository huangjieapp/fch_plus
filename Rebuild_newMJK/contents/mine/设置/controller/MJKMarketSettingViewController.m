//
//  MJKMarketSettingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketSettingViewController.h"
#import "MJKMarketSettingDetailViewController.h"
#import "MJKMarketSettingAddViewController.h"
#import "MJKPhoneSetViewController.h"
#import "MJKMarketSettingEditViewController.h"

#import "MJKSettingHeadView.h"
#import "MJKMarketSettingTableViewCell.h"

#import "MJKMarketModel.h"
#import "MJKMarketSubModel.h"
#import "MJKPhoneSetListModel.h"
#import "MJKPhoneSetListSubModel.h"
#import "MJKPhoneSetListSaleModel.h"

@interface MJKMarketSettingViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MJKSettingHeadView *headView;
@property (nonatomic, strong) UISearchBar *searchBar;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKMarketModel *marketModel;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, strong) UIButton *addButton;//添加
@property (nonatomic, strong) MJKPhoneSetListModel *phoneListModel;
@end

@implementation MJKMarketSettingViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([self.title isEqualToString:@"电话分配设置"]) {
		[self HTTPGetPhoneDatas];
	} else {
		[self HTTPGetMarkDatas:@""];
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	if ([self.title isEqualToString:@"电话分配设置"]) {
		self.searchBar.frame = CGRectZero;
	} else {
		[self.view addSubview:self.searchBar];
	}
	
	self.headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.searchBar.frame.size.height, KScreenWidth, 30)];
	[self.view addSubview:self.headView];
	if ([self.title isEqualToString:@"电话分配设置"]) {
		self.headView.headTitleArray = @[@"电话来源", @"电话号码", @"重新分配"];
	} else {
		self.headView.headTitleArray = @[@"渠道名称"];
	}
	
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
		if ([weakSelf.title isEqualToString:@"电话分配设置"]) {
			[weakSelf HTTPGetPhoneDatas];
		} else {
			[weakSelf HTTPGetMarkDatas:@""];
		}
		
		[weakSelf.tableView.mj_header endRefreshing];
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		if ([weakSelf.title isEqualToString:@"电话分配设置"]) {
			[weakSelf HTTPGetPhoneDatas];
		} else {
			[weakSelf HTTPGetMarkDatas:@""];
		}
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.title isEqualToString:@"电话分配设置"]) {
		return self.phoneListModel.content.count;
	} else {
		return self.dataArray.count;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MJKPhoneSetListSubModel *subModel = self.phoneListModel.content[section];
	if ([self.title isEqualToString:@"电话分配设置"]) {
		return subModel.array.count;
	} else {
        MJKMarketModel *model = self.dataArray[section];
		return model.content.count;
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.title isEqualToString:@"电话分配设置"]) {
		MJKPhoneSetListSubModel *subModel = self.phoneListModel.content[indexPath.section];
		MJKPhoneSetListSaleModel *saleModel = subModel.array[indexPath.row];
		MJKMarketSettingTableViewCell *cell = [MJKMarketSettingTableViewCell cellWithTableView:tableView];
		if (indexPath.row == 0) {
			[cell updatePhoneCellWith:subModel.total andPhone:subModel.totalphone];
			cell.titleLabel.textColor = cell.phoneLabel.textColor = [UIColor grayColor];
		} else {
			[cell updatePhoneCellWith:saleModel.C_U03100_C_NAME andPhone:saleModel.C_INTERNAL];
			cell.arrowImageView.hidden = YES;
		}
		
		return cell;
	} else {
        MJKMarketModel *model = self.dataArray[indexPath.section];
		MJKMarketSubModel *subModel = model.content[indexPath.row];
		MJKMarketSettingTableViewCell *cell = [MJKMarketSettingTableViewCell cellWithTableView:tableView];
		[cell updateCell:subModel.C_NAME andStatus:subModel.C_STATUS_DD_NAME];
		return cell;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.title isEqualToString:@"电话分配设置"]) {
        return nil;
    } else {
        MJKMarketModel *model = self.dataArray[section];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
        label.textColor = [UIColor darkGrayColor];
        label.text = model.total;
        label.font = [UIFont systemFontOfSize:14.f];
        [bgView addSubview:label];
        return bgView;
    }
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
    MJKMarketModel *model = self.dataArray[indexPath.section];
	MJKMarketSubModel *subModel = model.content[indexPath.row];
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



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self.title isEqualToString:@"电话分配设置"]) {
		if (section == 0) {
			return .1;
		}
		return 20;
	} else {
		return 30;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if ([self.title isEqualToString:@"电话分配设置"]) {
		MJKPhoneSetViewController *phoneDetail = [[MJKPhoneSetViewController alloc]init];
		MJKPhoneSetListSubModel *subModel = self.phoneListModel.content[indexPath.section];
		phoneDetail.phoneModel = subModel;
		if (indexPath.row != 0) {
			return;
		}
		[self.navigationController pushViewController:phoneDetail animated:YES];
	} else {
        
        MJKMarketModel *model = self.dataArray[indexPath.section];
//        MJKMarketSettingDetailViewController *detailVC = [[MJKMarketSettingDetailViewController alloc]init];
        MJKMarketSubModel *subModel = model.content[indexPath.row];
//        detailVC.model = subModel;
//        [self.navigationController pushViewController:detailVC animated:YES];
        MJKMarketSettingEditViewController *editVC = [[MJKMarketSettingEditViewController alloc]init];
        editVC.C_ID = subModel.C_ID;
        [self.navigationController pushViewController:editVC animated:YES];
	}
	
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
	//self.saleName = searchText;
	[self HTTPGetMarkDatas:searchText];
}

#pragma mark - 点击事件
- (void)addButtonAction:(UIButton *)sender {
	if ([self.title isEqualToString:@"电话分配设置"]) {
		MJKPhoneSetViewController *phoneVC = [[MJKPhoneSetViewController alloc]init];
		phoneVC.titleStr = self.title;
		[self.navigationController pushViewController:phoneVC animated:YES];
	} else {
		MJKMarketSettingAddViewController *addVC = [[MJKMarketSettingAddViewController alloc]init];
		[self.navigationController pushViewController:addVC animated:YES];
	}
}

#pragma mark - HTTP request
- (void)HTTPGetMarkDatas:(NSString *)str {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A41200WebService-getList"];
	[dict setObject:@{@"currPage" : [NSString stringWithFormat:@"%ld",self.pages], @"pageSize" : [NSString stringWithFormat:@"%ld",self.pagen], @"TYPE" : @"1", @"STATUS" : @"0", @"SEARCH_NAMEORCONTACT" : str, @"C_TYPE_DD_ID" : @"A41200_C_TYPE_0000"} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			self.dataArray = [MJKMarketModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPGetPhoneDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getPhoneList];
	[dict setObject:@{@"currPage" : [NSString stringWithFormat:@"%ld",self.pages], @"pageSize" : [NSString stringWithFormat:@"%ld",self.pagen]} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.phoneListModel = [MJKPhoneSetListModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
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

#pragma mark - set
- (UISearchBar *)searchBar {
	if (!_searchBar) {
		_searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 50)];
		_searchBar.placeholder = @"渠道名称";
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
