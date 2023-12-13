//
//  MJKPushOpenSetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenSetViewController.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKPushDefaultListModel.h"
#import "MJKClueListSubModel.h"

#import "MJKPushOpenSetSection0Cell.h"
#import "MJKPushOpenSetSection1Cell.h"
#import "MJKPushOpenSetSection2Cell.h"
#import "MJKPushOpenMessageCell.h"

@interface MJKPushOpenSetViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** push user model array*/
@property (nonatomic, strong) NSArray *pushUserArray;

/** section1Array*/
@property (nonatomic, strong) NSArray *section1Array;
@property (nonatomic, strong) NSString *nickName;
@end

@implementation MJKPushOpenSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"推送设置";
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
	//自定义推送人
	[self getSalesListDatas];
	[self configNaviItem];
}

- (void)configNaviItem {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[button setTitleNormal:@"确定"];
	[button setTitleColor:[UIColor blackColor]];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
	[button addTarget:self action:@selector(commitButtonAction:)];
}

#pragma mark - 确定按钮事件
- (void)commitButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
	NSMutableArray *selectCustomerArr = [NSMutableArray array];
	for (MJKClueListSubModel *model in self.pushUserArray) {
		if (model.isSelected == YES) {
			[selectCustomerArr addObject:model.u051Id];
		}
	}
	NSMutableArray *defaulArr = [NSMutableArray array];
	for (MJKPushDefaultListModel *model in self.detailModel.defaultList) {
		NSDictionary *dic = model.mj_keyValues;
		[defaulArr addObject:dic];
	}
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MJKPushDefaultListModel *listModel in self.detailModel.defaultList) {
        if ([listModel.ISCHECK isEqualToString:@"true"]) {
            NSDictionary *dic = [listModel mj_keyValues];
            [arr addObject:dic];
        }
    }
    if (self.detailModel.I_TYPE == 0 && self.detailModel.I_WECHAT == 0 && self.detailModel.I_JGTS == 0) {
        [JRToast showWithText:@"请开启推送方式"];
        return;
    }
    if (self.detailModel.defaultList.count > 0) {
        NSString *defaultSelect;
        for (NSDictionary *dic in defaulArr) {
            if ([dic[@"ISCHECK"] boolValue] == 0) {
                defaultSelect = @"未选";
            } else {
                defaultSelect = @"已选";
                break;
            }
        }
        if (selectCustomerArr.count <= 0 && [defaultSelect isEqualToString:@"未选"]) {
            [JRToast showWithText:@"请选择推送人"];
            return;
        }
    }
    
	[self httpOpenOrCloseMessagePush:self.detailModel andCustomerArr:selectCustomerArr andDefaultArr:defaulArr andCompleteBlock:^{
		[weakSelf.navigationController popViewControllerAnimated:YES];
	}];
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (self.detailModel.defaultList.count > 0) {
		return 3;
	} else {
		return 2;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (self.detailModel.defaultList.count > 0) {
		if (section == 0) {
			return self.section1Array.count;
		} else if (section == 1) {
			return self.detailModel.defaultList.count;
		} else {
			return self.pushUserArray.count;
		}
	} else {
		if (section == 0) {
			return self.section1Array.count;
		} else {
			return self.pushUserArray.count;
		}
	}
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (self.detailModel.defaultList.count > 0) {
		if (indexPath.section == 0) {
            NSString *titleStr = self.section1Array[indexPath.row];
            MJKPushOpenMessageCell *cell = [MJKPushOpenMessageCell cellWithTableView:tableView];
            cell.titleLabel.text = titleStr;
            cell.model = self.detailModel;
            cell.openSwitchBlock = ^(BOOL isOn) {
                NSMutableArray *selectCustomerArr = [NSMutableArray array];
                for (MJKClueListSubModel *model in self.pushUserArray) {
                    if (model.isSelected == YES) {
                        [selectCustomerArr addObject:model.u031Id];
                    }
                }
                NSMutableArray *defaulArr = [NSMutableArray array];
                for (MJKPushDefaultListModel *model in self.detailModel.defaultList) {
                    NSDictionary *dic = model.mj_keyValues;
                    [defaulArr addObject:dic];
                }
                [weakSelf httpOpenOrCloseMessagePush:weakSelf.detailModel andCustomerArr:selectCustomerArr andDefaultArr:defaulArr andCompleteBlock:nil];
            };
            return cell;
		} else if (indexPath.section == 1) {
			MJKPushDefaultListModel *model = self.detailModel.defaultList[indexPath.row];
			MJKPushOpenSetSection1Cell *cell = [MJKPushOpenSetSection1Cell cellWithTableView:tableView];
			cell.model = model;
			return cell;
		} else {
			MJKClueListSubModel *model = self.pushUserArray[indexPath.row];
			MJKPushOpenSetSection2Cell *cell = [MJKPushOpenSetSection2Cell cellWithTableView:tableView];
            
            cell.nModel = model;
                cell.nCustomerArray = self.detailModel.customList;
            
			return cell;
		}
	} else {
		if (indexPath.section == 0) {
            NSString *titleStr = self.section1Array[indexPath.row];
            MJKPushOpenMessageCell *cell = [MJKPushOpenMessageCell cellWithTableView:tableView];
            cell.titleLabel.text = titleStr;
            cell.model = self.detailModel;
            cell.openSwitchBlock = ^(BOOL isOn) {
                NSMutableArray *selectCustomerArr = [NSMutableArray array];
                for (MJKClueListSubModel *model in self.pushUserArray) {
                    if (model.isSelected == YES) {
                        [selectCustomerArr addObject:model.u051Id];
                    }
                }
                NSMutableArray *defaulArr = [NSMutableArray array];
                for (MJKPushDefaultListModel *model in self.detailModel.defaultList) {
                    NSDictionary *dic = model.mj_keyValues;
                    [defaulArr addObject:dic];
                }
                [weakSelf httpOpenOrCloseMessagePush:weakSelf.detailModel andCustomerArr:selectCustomerArr andDefaultArr:defaulArr andCompleteBlock:nil];
            };
            return cell;
		} else {
			MJKClueListSubModel *model = self.pushUserArray[indexPath.row];
			MJKPushOpenSetSection2Cell *cell = [MJKPushOpenSetSection2Cell cellWithTableView:tableView];
            cell.nModel = model;
                cell.nCustomerArray = self.detailModel.customList;
           
			return cell;
		}
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.detailModel.defaultList.count > 0) {
        if (section == 0) {
            
            return 30.f;
        } else if (section == 1) {
            
            return 30.f;
        } else {
            return 80;
        }
    } else {
        if (section == 0) {
            
            return 30.f;
        } else {
            return 80;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	bgView.backgroundColor = kBackgroundColor;
	
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
	label.textColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:label];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), KScreenWidth, 50)];
    searchBar.placeholder = @"搜索姓名";
    searchBar.delegate = self;
    
	if (self.detailModel.defaultList.count > 0) {
		if (section == 0) {
			label.text = @"消息推送方式";
		} else if (section == 1) {
			label.text = @"默认推送人";
		} else {
			label.text = @"自定义推送人";
            [bgView addSubview:searchBar];
		}
	} else {
		if (section == 0) {
			label.text = @"消息推送方式";
		} else {
			label.text = @"自定义推送人";
            [bgView addSubview:searchBar];
		}
	}
	
	
	return bgView;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.nickName = searchBar.text;
    [self getSalesListDatas];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)httpOpenOrCloseMessagePush:(MJKCustomReturnSubModel *)model  andCustomerArr:(NSArray *)customerArr andDefaultArr:(NSArray *)defaultArr andCompleteBlock:(void(^)(void))completeBlock {
//	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_ID"] = model.C_ID;
	dic[@"I_TYPE"] = @(model.I_TYPE);
    dic[@"I_WECHAT"] = @(model.I_WECHAT);
    dic[@"I_JGTS"] = @(model.I_JGTS);
    
	if (customerArr.count > 0) {
		dic[@"customList"] = customerArr;
	} else {
		dic[@"customList"] = @[];
	}
	if (defaultArr.count > 0) {
		dic[@"defaultList"] = defaultArr;
	} else {
		dic[@"defaultList"] = @[];
	}
//	[dict setObject:dic forKey:@"content"];
//	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[HTTP_IP stringByAppendingString:@"/api/system/a475/edit"] parameters:dic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			//			[JRToast showWithText:data[@"message"]];
			[weakSelf.tableView reloadData];
			if (completeBlock) {
				completeBlock();
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}
#pragma mark 推送人
-(void)getSalesListDatas {
	DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.nickName.length > 0) {
        dic[@"nickName"] = self.nickName;
    }
    dic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[HTTP_IP stringByAppendingString:@"/api/system/user/list"] parameters:dic compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
            
			weakSelf.pushUserArray = [MJKClueListSubModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
	
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (NSArray *)section1Array {
    if (!_section1Array) {
        _section1Array = @[@"短信通知",@"公众号通知",@"软件通知"];
    }
    return _section1Array;
}

@end
