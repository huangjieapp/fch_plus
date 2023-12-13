//
//  MJKDeviationViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKDeviationViewController.h"

#import "MJKDeviationTableViewCell.h"

@interface MJKDeviationViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 偏差值*/
@property (nonatomic, strong) NSMutableArray *deviationArray;
@end

@implementation MJKDeviationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.title = @"偏差范围";
	[self.view addSubview:self.tableView];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.deviationArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKDeviationTableViewCell *cell = [MJKDeviationTableViewCell cellWithTableView:tableView];
	cell.meterLabel.text = [NSString stringWithFormat:@"%@米",self.deviationArray[indexPath.row]];
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.backMeterBlock) {
		self.backMeterBlock(self.deviationArray[indexPath.row]);
	}
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (NSMutableArray *)deviationArray {
	if (!_deviationArray) {
		_deviationArray = [NSMutableArray array];
		for (int i = 1; i < 11; i++) {
			[_deviationArray addObject:[NSString stringWithFormat:@"%d",i * 100]];
		}
	}
	return _deviationArray;
}

@end
