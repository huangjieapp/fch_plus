//
//  MJKAddOrderNodeViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddOrderNodeViewController.h"
#import "MJKOrderStatusViewController.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKRecheckTableViewCell.h"
#import "MJKDefaultTaskTableViewCell.h"
#import "DBPickerView.h"

#import "MJKShowOrderPlanModel.h"

@interface MJKAddOrderNodeViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 提交按钮*/
@property (nonatomic, strong) UIButton *commitButton;
/** MJKShowOrderPlanModel*/
@property (nonatomic, strong) MJKShowOrderPlanModel *planModel;
@end

@implementation MJKAddOrderNodeViewController

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
	if (self.type == NodeAdd) {
		self.title = @"新增节点";
		self.planModel = [[MJKShowOrderPlanModel alloc]init];
        self.planModel.I_RWTYPE = @"0";
	} else {
		self.title = @"编辑节点";
		[self httpGetOrderTrajectoryData];
	}
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.commitButton];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.row == 0) {
		AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
		cell.nameTitleLabel.text = @"节点名称";
		cell.inputTextField.text = self.planModel.C_NAME;
		cell.inputTextField.hidden = NO;
		cell.inputTextView.hidden = YES;
		cell.changeTextBlock = ^(NSString *textStr) {
			weakSelf.planModel.C_NAME = textStr;
		};
		return cell;
	} else if (indexPath.row == 1) {
		AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = @"节点对应的任务";
		cell.Type = chooseTypeNil;
        cell.chooseTextField.text = self.planModel.C_TYPE_DD_NAME;
		
		
		cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            
            MJKOrderStatusViewController *vc = [[MJKOrderStatusViewController alloc]init];
            vc.vcName = @"节点对应的任务";
            vc.backBlack = ^(NSDictionary * _Nonnull dic) {
                weakSelf.planModel.C_TYPE_DD_ID = dic[@"c_id"];
                weakSelf.planModel.C_TYPE_DD_NAME = dic[@"name"];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
		};
		return cell;
    } else if (indexPath.row == 2) {
        MJKRecheckTableViewCell *cell = [MJKRecheckTableViewCell cellWithTableView:tableView];
        cell.titleLabel.text = @"是否需要外出";
        cell.switchButton.on =  [self.planModel.I_RWTYPE isEqualToString:@"1"] ? YES : NO;
        cell.switchButtonActionBlock = ^{
            if ([weakSelf.planModel.I_RWTYPE isEqualToString:@"1"]) {
                weakSelf.planModel.I_RWTYPE = @"0";
            } else {
                weakSelf.planModel.I_RWTYPE = @"1";
            }
        };
        return cell;
    } else if (indexPath.row == 3) {
        AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = @"关联订单状态";
        cell.Type = chooseTypeNil;
        cell.chooseTextField.text = self.planModel.C_A42000STATUS_DD_NAME;
        
        
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MJKOrderStatusViewController *vc = [[MJKOrderStatusViewController alloc]init];
            vc.vcName = @"关联订单状态";
            vc.C_VOUCHERID = weakSelf.planModel.C_A42000STATUS_DD_ID;
            vc.backBlack = ^(NSDictionary * _Nonnull dic) {
                weakSelf.planModel.C_A42000STATUS_DD_ID = dic[@"c_id"];
                weakSelf.planModel.C_A42000STATUS_DD_NAME = dic[@"name"];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        };
        return cell;
    } else {
        MJKDefaultTaskTableViewCell*cell=[MJKDefaultTaskTableViewCell cellWithTableView:tableView];
        cell.timeDotTF.inputView = [UIView new];
        cell.timeHourTF.keyboardType = UIKeyboardTypeNumberPad;
        [cell.timeDotTF addTarget:self action:@selector(timeDotSelect:) forControlEvents:UIControlEventEditingDidBegin];
        [cell.timeHourTF addTarget:self action:@selector(timeHourInput:) forControlEvents:UIControlEventEditingChanged];
        if (self.planModel.C_DYSJD_DD_NAME.length > 0) {
            cell.timeDotTF.text = self.planModel.C_DYSJD_DD_NAME;
        }
        if (self.planModel.I_DYXS.length > 0) {
            cell.timeHourTF.text = self.planModel.I_DYXS;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 72;
    }
    return 44;
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

#pragma mark - 轨迹详情
- (void)httpGetOrderTrajectoryData {
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-getBeanById"];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"C_ID"] = self.c_id;
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			weakSelf.planModel = [MJKShowOrderPlanModel mj_objectWithKeyValues:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)timeHourInput:(UITextField *)tf {
    self.planModel.I_DYXS = tf.text;
}

- (void)timeDotSelect:(UITextField *)tf{
    DBSelf(weakSelf);
    
    MJKOrderStatusViewController *vc = [[MJKOrderStatusViewController alloc]init];
    vc.vcName = @"选择时间点";
    vc.backBlack = ^(NSDictionary * _Nonnull dic) {
        weakSelf.planModel.C_DYSJD_DD_ID = dic[@"c_id"];
        weakSelf.planModel.C_DYSJD_DD_NAME = dic[@"name"];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 新增节点
- (void)httpAddNode {
	DBSelf(weakSelf);
	NSString *actionStr;
	if (self.type == NodeAdd) {
		actionStr = @"A47300WebService-insert";
	} else {
		actionStr = @"A47300WebService-update";
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	if (self.type == NodeAdd) {
		dic[@"C_ID"] = [DBObjectTools getA47300C_id];
	} else {
		dic[@"C_ID"] = self.c_id;
	}
	dic[@"C_NAME"] = self.planModel.C_NAME;
	dic[@"I_SORTIDX"] = [NSString stringWithFormat:@"%ld",self.index];
	dic[@"C_TYPE_DD_ID"] = self.planModel.C_TYPE_DD_ID;
	dic[@"I_RWTYPE"] = self.planModel.I_RWTYPE;
    if (self.planModel.C_A42000STATUS_DD_ID.length > 0) {
        dic[@"C_A42000STATUS_DD_ID"] = self.planModel.C_A42000STATUS_DD_ID;
    }
    if (self.planModel.C_DYSJD_DD_ID.length > 0) {
        dic[@"C_DYSJD_DD_ID"] = self.planModel.C_DYSJD_DD_ID;
    }
    if (self.planModel.I_DYXS.length > 0) {
        dic[@"I_DYXS"] = self.planModel.I_DYXS;
    }
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - 点击提交按钮
- (void)commitButtonAction {
	if (self.planModel.C_NAME.length <= 0) {
		[JRToast showWithText:@"请输入节点名称"];
		return;
	}
	if (self.planModel.C_TYPE_DD_ID.length <= 0) {
		[JRToast showWithText:@"请选择关联类型"];
		return;
	}
	if (self.planModel.I_RWTYPE.length <= 0) {
		[JRToast showWithText:@"请选择是否外出"];
		return;
	}
	[self httpAddNode];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.bounces = NO;
	}
	return _tableView;
}

- (UIButton *)commitButton {
	if (!_commitButton) {
		_commitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), KScreenWidth, 55)];
		_commitButton.backgroundColor = KNaviColor;
		[_commitButton setTitleNormal:@"提交"];
		[_commitButton setTitleColor:[UIColor blackColor]];
		[_commitButton addTarget:self action:@selector(commitButtonAction)];
	}
	return _commitButton;
}

@end
