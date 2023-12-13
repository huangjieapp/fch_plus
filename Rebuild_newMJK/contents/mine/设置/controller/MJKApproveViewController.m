//
//  MJKApproveViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKApproveViewController.h"

#import "MJKAppoveModel.h"

#import "MJKApproveTableViewCell.h"

@interface MJKApproveViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKAppoveModel *appoveModel;
@end

@implementation MJKApproveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"自动审批设置";
	[self.view addSubview:self.tableView];
	[self HTTPGetApproveDatas];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKApproveTableViewCell *cell = [MJKApproveTableViewCell cellWithTableView:tableView];
	[cell updataCellWithTitle:@[@"自动战败", @"自动激活", @"价格自动审批", @"自动取消审批"][indexPath.row] andRow:indexPath.row andModel:self.appoveModel];
	[cell setBackBoolBlock:^(NSString *str){
		switch (indexPath.row) {
			case 0:
				weakSelf.appoveModel.C_ISAUTOFAIL = str;
				break;
			case 1:
				weakSelf.appoveModel.C_ISAUTOACT = str;
				break;
			case 2:
				weakSelf.appoveModel.C_ISAUTOPRICE = str;
				break;
			case 3:
				weakSelf.appoveModel.C_ISAUTOCANCEL = str;
				break;
				
			default:
				break;
		}
		[weakSelf HTTPUpdataApproveDatas];
	}];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

#pragma mark - HTTP request
- (void)HTTPGetApproveDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getAppoveList];
	[dict setObject:@{@"C_ID" : [NewUserSession instance].user.u051Id} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.appoveModel = [MJKAppoveModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPUpdataApproveDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updataAppoveList];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	[dic setObject:self.appoveModel.C_ISAUTOFAIL forKey:@"C_ISAUTOFAIL"];
	[dic setObject:self.appoveModel.C_ISAUTOACT forKey:@"C_ISAUTOACT"];
	[dic setObject:self.appoveModel.C_ISAUTOPRICE forKey:@"C_ISAUTOPRICE"];
	[dic setObject:self.appoveModel.C_ISAUTOCANCEL forKey:@"C_ISAUTOCANCEL"];
	[dic setObject:[NewUserSession instance].user.u051Id forKey:@"C_ID"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPGetApproveDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}
@end
