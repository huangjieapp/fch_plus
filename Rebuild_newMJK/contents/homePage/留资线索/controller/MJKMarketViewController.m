//
//  MJKMarketViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketViewController.h"
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

#define marketCell @"marketCell"

@interface MJKMarketViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) MJKClueListViewModel *clueListModel;
@end

@implementation MJKMarketViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	if ([self.vcName isEqualToString:@"订单"]) {
		self.title = @"选择人员";
	} else {
		self.title=@"选择员工";
	}
	self.view.backgroundColor = [UIColor whiteColor];
	if ([self.title isEqualToString:@"选择人员"]) {
		[self getAllSalesListWithName:@""];
	} else {
		[self getSalesListDatasName:@""];
	}
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
	if ([self.title isEqualToString:@"选择人员"]) {
		[self getAllSalesListWithName:searchText];
	} else {
		[self getSalesListDatasName:searchText];
	}
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.clueListModel.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKClueMarketTableViewCell *cell = [MJKClueMarketTableViewCell cellWithTableView:tableView];
	cell.subModel = self.clueListModel.data[indexPath.row];
	MJKClueListSubModel *subModel = self.clueListModel.data[indexPath.row];
	if ([self.rootViewController isKindOfClass:[MJKFlowListViewController class]]) {
		cell.countLabel.hidden = NO;
		cell.countLabel.text = subModel.COUNT;
	}
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.rootViewController isKindOfClass:[CGCWXHelpVC class]]||[self.rootViewController isKindOfClass:[SHChatViewController class]]) {
    
    MJKClueListSubModel *model=self.clueListModel.data[indexPath.row];
   
    }


}


- (void)submitButtonAction:(UIButton *)sender {
	if (self.backSuccessBlock) {
		self.backSuccessBlock();
	}
#pragma 通用情况
	if (self.chooseArray.count <= 0 && self.rootViewController == nil) {
		for (MJKClueListSubModel *model in self.clueListModel.data) {
			if (model.isSelected == YES) {
				if (self.alertName.length > 0) {
					NSString *str;
					if ([self.alertName isEqualToString:@"到货"]) {
						str = [NSString stringWithFormat:@"是否更改为收货人为%@",model.user_name];
					} else {
						str = [NSString stringWithFormat:@"是否更改为验收人为%@",model.user_name];
					}
					UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
					
					UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
						if (self.backSelectParameterBlock) {
							self.backSelectParameterBlock(model.u051Id, model.nickName);
						}
						[self.navigationController popViewControllerAnimated:YES];
					}];
					
					UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
						
					}];
					
					[alertV addAction:falseAction];
					[alertV addAction:trueAction];
					
					[self presentViewController:alertV animated:YES completion:nil];
				} else {
					if (self.backSelectParameterBlock) {
						self.backSelectParameterBlock(model.user_id, model.user_name);
					}
				}
				
			}
			
		}
		[self.navigationController popViewControllerAnimated:YES];
		return;
	}
	
	
	
    
#pragma 其他
    
	NSMutableArray *idArr = [NSMutableArray array];
	__block NSString *userId;
	if ([self.rootViewController isKindOfClass:[MJKFlowListViewController class]])/*如果是展厅流量*/ {
		[self.chooseArray enumerateObjectsUsingBlock:^(MJKFlowListSecondSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[idArr addObject:obj.C_ID];
		}];
	} else {
		[self.chooseArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
			[idArr addObject:obj.C_ID];
		}];
	}
	
	[self.clueListModel.data enumerateObjectsUsingBlock:^(MJKClueListSubModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if (obj.isSelected == YES) {
			userId = obj.u031Id;
		}
	}];
	NSString *chooseStr = [idArr componentsJoinedByString:@","];
	if (userId.length > 0) {
		if (self.rootViewController == nil) {
			[self updateAssignClues:chooseStr andSale:userId];
		} else {
			if ([self.rootViewController isKindOfClass:[MJKFlowListViewController class]]  || [self.rootViewController isKindOfClass:[MJKFlowDetailViewController class]]) {
				[self updateAssignFlow:chooseStr andSale:userId];
			} else {
				for (MJKClueListSubModel *model in self.clueListModel.data) {
					if (model.isSelected == YES) {
						if (self.backSelectParameterBlock) {
							self.backSelectParameterBlock(model.u051Id, model.nickName);
						}
					}
				}
			}
		}
			
		
	} else {
		[JRToast showWithText:@"请选择员工"];
	}
}

- (void)updateAssignClues:(NSString *)chooseStr andSale:(NSString *)userId {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/assign", HTTP_IP] parameters:@{@"C_ID" : chooseStr, @"USER_ID" : userId} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
				if ([controller isKindOfClass:[MJKClueListViewController class]]) {
					[weakSelf.navigationController popToViewController:controller animated:YES];
				} else {
					[weakSelf.navigationController popViewControllerAnimated:YES];
				}
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)updateAssignFlow:(NSString *)chooseStr andSale:(NSString *)userId {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:@{@"C_ID" : self.C_ID.length > 0 ? self.C_ID : chooseStr, @"USER_ID" : userId, @"TYPE" : @"4"} compliation:^(id data, NSError *error) {
       
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			for (UIViewController *controller in weakSelf.navigationController.viewControllers) {
				if ([self.rootViewController isKindOfClass:[MJKFlowListViewController class]] || [self.rootViewController isKindOfClass:[MJKFlowDetailViewController class]]) {
					if ([controller isKindOfClass:[MJKFlowListViewController class]]) {
//						[[NSUserDefaults standardUserDefaults]objectForKey:@"isBack"]
						[[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"isBack"];
						[weakSelf.navigationController popToViewController:controller animated:YES];
					}
				}
					
				
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

//销售顾问
- (void)getAllSalesListWithName:(NSString *)name {NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
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

- (void)getSalesListDatasName:(NSString *)name {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserList parameters:@{@"C_NAME" : name, @"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			NSArray *arr = data[@"data"];
			if (arr.count <= 0) {
//				[JRToast showWithText:@"无下级"];
			}
			
			weakSelf.clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
			if ([weakSelf.rootViewController isKindOfClass:[CGCWXHelpVC class]] || [self.vcName isEqualToString:@"全部员工"]) {
				NSMutableArray <CGCSellModel *>*sellArray = [NSMutableArray array];
				for (NSDictionary * div in data[@"data"]) {
					CGCSellModel * model=[CGCSellModel yy_modelWithDictionary:div];
					[sellArray addObject:model];
				}
				for (int i = 0; i < weakSelf.clueListModel.data.count; i++) {
					CGCSellModel * model = sellArray[i];
					MJKClueListSubModel *subModel = weakSelf.clueListModel.data[i];
					subModel.user_id = model.u051Id;
					subModel.user_name = model.nickName;
					subModel.C_HEADPIC = model.avatar;
				}
			}
			
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
