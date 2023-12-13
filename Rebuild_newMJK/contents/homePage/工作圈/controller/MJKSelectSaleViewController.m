//
//  MJKMarketViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKSelectSaleViewController.h"
#import "MJKClueListViewModel.h"
#import "MJKFlowListSecondSubModel.h"
#import "MJKFlowListViewController.h"
#import "MJKAddFlowViewController.h"
#import "MJKFlowDetailViewController.h"
#import "MJKClueListViewController.h"
#import "CGCWXHelpVC.h"
#import "SHChatViewController.h"

#import "MJKClueMarketTableViewCell.h"
#import "CGCSellModel.h"

#import "MJKSelectSaleCell.h"

#define marketCell @"marketCell"

@interface MJKSelectSaleViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) MJKClueListViewModel *clueListModel;
@end

@implementation MJKSelectSaleViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"选择人员";
	self.view.backgroundColor = [UIColor whiteColor];
		[self getAllSalesListWithName:@""];
	[self initSearchBar];
	[self.view addSubview:self.tableview];
	[self.view addSubview:self.submitButton];
	[self.tableview registerNib:[UINib nibWithNibName:@"MJKClueMarketTableViewCell" bundle:nil] forCellReuseIdentifier:marketCell];
	if ([self.rootViewController isKindOfClass:[CGCWXHelpVC class]]||[self.rootViewController isKindOfClass:[SHChatViewController class]]) {
		self.tableview.frame = self.view.frame;
		self.submitButton.hidden = YES;
	}
	
	if (@available(iOS 11.0, *)) {
		self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentAlways;
	}else {
		self.automaticallyAdjustsScrollViewInsets = YES;
	}
	
}

- (void)initSearchBar {
	UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 5, KScreenWidth, 30)];
	searchBar.delegate = self;
	searchBar.placeholder = @"搜索姓名";
	UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:30.0f];
	//设置背景图片
	[searchBar setBackgroundImage:searchBarBg];
	//设置背景色
	[searchBar setBackgroundColor:[UIColor clearColor]];
	//设置文本框背景
	[searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
	
	UITextField *searchField = [searchBar valueForKey:@"searchField"];
	
	if (searchField) {
		
		[searchField setBackgroundColor:[UIColor whiteColor]];
		
		searchField.layer.cornerRadius = 14.0f;
		
		searchField.layer.borderColor = [UIColor grayColor].CGColor;
		
		searchField.layer.borderWidth = 1;
		
		searchField.layer.masksToBounds = YES;
		
	}
	[self.view addSubview:searchBar];
}
//自定义searchBar背景
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
	CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
	UIGraphicsBeginImageContext(r.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, r);
	
	UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return img;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
		[self getAllSalesListWithName:searchText];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.clueListModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKSelectSaleCell *cell = [MJKSelectSaleCell cellWithTableView:tableView];
	cell.subModel = self.clueListModel.data[indexPath.row];
//	MJKClueListSubModel *subModel = self.clueListModel.content[indexPath.row];
//		cell.countLabel.hidden = NO;
//		cell.countLabel.text = subModel.COUNT;
	
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
	
	
	
}


- (void)submitButtonAction:(UIButton *)sender {
	if (self.backSuccessBlock) {
		self.backSuccessBlock();
	}
	NSMutableArray *nameArr = [NSMutableArray array];
	NSMutableArray *codeArr = [NSMutableArray array];
	for (MJKClueListSubModel *model in self.clueListModel.data) {
		if (model.isSelected == YES) {
			[nameArr addObject:model.nickName];
			[codeArr addObject:model.u051Id];
		}
	}
	NSString *nameStr = [nameArr componentsJoinedByString:@","];
	NSString *codeStr = [codeArr componentsJoinedByString:@","];
	if (self.backSelectParameterBlock) {
		self.backSelectParameterBlock(codeStr, nameStr);
	}
	[self.navigationController popViewControllerAnimated:YES];
}

//销售顾问
- (void)getAllSalesListWithName:(NSString *)name {
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			NSArray *arr = data[@"data"];
			if (arr.count <= 0) {
				//				[JRToast showWithText:@"无下级"];
			}
			
			weakSelf.clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
			
			
			[weakSelf.tableview reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
}


- (UITableView *)tableview {
	if (!_tableview) {
		_tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight - 50 - NavStatusHeight - SafeAreaBottomHeight - 40) style:UITableViewStyleGrouped];
		_tableview.dataSource = self;
		_tableview.delegate = self;
		_tableview.estimatedRowHeight = 0;
		_tableview.estimatedSectionHeaderHeight = 0;
		_tableview.estimatedSectionFooterHeight = 0;
	}
	return _tableview;
}

- (UIButton *)submitButton {
	if (!_submitButton) {
		_submitButton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 45, self.view.frame.size.width - 40, 40)];
		_submitButton.backgroundColor = DBColor(255,195,0);
		_submitButton.layer.cornerRadius = 5.0f;
		[_submitButton setTitle:[self.vcName isEqualToString:@"订单"] ? @"确定" : @"重新指派" forState:UIControlStateNormal];
		_submitButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		[_submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _submitButton;
}

@end
