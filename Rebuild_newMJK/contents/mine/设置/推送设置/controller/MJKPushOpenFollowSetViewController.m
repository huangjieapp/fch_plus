//
//  MJKPushOpenFollowSetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKPushOpenFollowSetViewController.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKPushDefaultListModel.h"
#import "MJKClueListSubModel.h"

#import "MJKPushOpenSetSection0Cell.h"
#import "MJKPushOpenFollowSetCell.h"
#import "MJKPushOpenSetSection1Cell.h"
#import "MJKPushOpenMessageCell.h"

@interface MJKPushOpenFollowSetViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** push user model array*/
@property (nonatomic, strong) NSArray *pushUserArray;
/** section1Array*/
@property (nonatomic, strong) NSArray *section1Array;
@end

@implementation MJKPushOpenFollowSetViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = @"推送设置";
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
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
    
    if (self.detailModel.I_TYPE == 0 && self.detailModel.I_WECHAT == 0 && self.detailModel.I_JGTS == 0) {
        [JRToast showWithText:@"请开启推送方式"];
        return;
    }
    
    if (self.detailModel.C_FIRSTPUSH.length <= 0 && self.detailModel.C_SECONDPUSH.length <= 0 && self.detailModel.C_THIRDPUSH.length <= 0) {
        [JRToast showWithText:@"请开启推送时间"];
        return;
    }
	NSMutableArray *defaulArr = [NSMutableArray array];
	for (MJKPushDefaultListModel *model in self.detailModel.defaultList) {
		NSDictionary *dic = model.mj_keyValues;
		[defaulArr addObject:dic];
	}
    
    if (self.detailModel.defaultList.count > 0) {
        if (defaulArr.count <= 0) {
            [JRToast showWithText:@"请选择推送人"];
            return;
        }
    }
    
	[self httpOpenOrCloseMessagePush:self.detailModel andDefault:defaulArr andCompleteBlock:^{
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
	if (section == 0) {
		return self.section1Array.count;
	} else if (section == 1) {
		if ([self.typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
			return 1;
		} else {
			return 3;
		}
	} else {
		return self.detailModel.defaultList.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.section == 0) {
//        MJKPushOpenSetSection0Cell *cell = [MJKPushOpenSetSection0Cell cellWithTableView:tableView];
//        cell.model = self.detailModel;
//        cell.openSwitchBlock = ^(BOOL isOn) {
//            weakSelf.detailModel.I_TYPE = isOn == YES ? 1 : 0;
//            [weakSelf httpOpenOrCloseMessagePush:weakSelf.detailModel andDefault:nil andCompleteBlock:nil];
//        };
//        return cell;
        NSString *titleStr = self.section1Array[indexPath.row];
        MJKPushOpenMessageCell *cell = [MJKPushOpenMessageCell cellWithTableView:tableView];
        cell.titleLabel.text = titleStr;
        cell.model = self.detailModel;
        cell.openSwitchBlock = ^(BOOL isOn) {
            NSMutableArray *defaulArr = [NSMutableArray array];
            for (MJKPushDefaultListModel *model in self.detailModel.defaultList) {
                NSDictionary *dic = model.mj_keyValues;
                [defaulArr addObject:dic];
            }
            [weakSelf httpOpenOrCloseMessagePush:weakSelf.detailModel andDefault:defaulArr andCompleteBlock:nil];
        };
        return cell;
	} else if (indexPath.section == 1) {
		MJKPushOpenFollowSetCell *cell = [MJKPushOpenFollowSetCell cellWithTableView:tableView];
		[cell updateCellWithModel:self.detailModel andRow:indexPath.row andTypeNumber:self.typeNumber];
		return cell;
	} else  {
		MJKPushDefaultListModel *model = self.detailModel.defaultList[indexPath.row];
		MJKPushOpenSetSection1Cell *cell = [MJKPushOpenSetSection1Cell cellWithTableView:tableView];
		cell.model = model;
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.f;
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
	if (section == 0) {
		label.text = @"消息推送方式";
	} else if (section == 1) {
		label.text = @"推送时间";
	} else {
		label.text = @"默认推送人";
	}
	
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)httpOpenOrCloseMessagePush:(MJKCustomReturnSubModel *)model  andDefault:(NSArray *)defaultArr andCompleteBlock:(void(^)(void))completeBlock {
//	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_ID"] = model.C_ID;
	dic[@"I_TYPE"] = @(model.I_TYPE);
    dic[@"I_WECHAT"] = @(model.I_WECHAT);
    dic[@"I_JGTS"] = @(model.I_JGTS);

	if (defaultArr.count > 0) {
		dic[@"defaultList"] = defaultArr;
	} else {
		dic[@"defaultList"] = @[];
	}
	dic[@"C_FIRSTPUSH"] = model.C_FIRSTPUSH;

	dic[@"C_SECONDPUSH"] = model.C_SECONDPUSH;

	dic[@"C_THIRDPUSH"] = model.C_THIRDPUSH;
	
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
