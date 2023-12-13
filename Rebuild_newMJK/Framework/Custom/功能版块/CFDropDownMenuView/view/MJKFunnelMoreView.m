//
//  MJKFunnelMoreView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKFunnelMoreView.h"

#import "MJKFunnelChooseModel.h"

#import "MJKFunnelMoreViewCell.h"



@interface MJKFunnelMoreView ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** naviView*/
@property (nonatomic, strong) UIView *naviView;
/** 上一个index*/
@property (nonatomic, strong) NSIndexPath *preIndexPath;
/** 上一个model*/
@property (nonatomic, strong) MJKFunnelChooseModel *perModel;
@end

@implementation MJKFunnelMoreView

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		UIView *naviView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, SafeAreaTopHeight)];
		self.naviView = naviView;
		naviView.backgroundColor = KNaviColor;
		[self addSubview:naviView];
        
		UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0,SafeAreaTopHeight == 88 ? 44 : 20, 44, 44)];
		[backButton setImage:@"btn-返回"];
		[backButton addTarget:self action:@selector(backAction)];
		[naviView addSubview:backButton];
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 50, SafeAreaTopHeight == 88 ? 44 : 20, 44, 44)];
		[button setTitleNormal:@"确定"];
		[button setTitleColor:[UIColor blackColor]];
		[naviView addSubview:button];
		[button addTarget:self action:@selector(sureAction)];
		[self addSubview:self.tableView];
	}
	return self;
}

- (void)backAction {
	for (MJKFunnelChooseModel *model in self.dataArray) {
		if ([self.perModel.c_id isEqualToString:model.c_id]) {
			model.isSelected = YES;
		} else {
			model.isSelected = NO;
		}
		
	}
	[self removeFromSuperview];
}

- (void)sureAction {
	if (self.backModelArrayBlock) {
		self.backModelArrayBlock(self.dataArray);
	}
	[self removeFromSuperview];
}

- (void)setDataArray:(NSArray *)dataArray {
	_dataArray = dataArray;
	[self.tableView reloadData];
	for (MJKFunnelChooseModel *model in self.dataArray) {
		if (model.isSelected == YES) {
			self.perModel = model;
		}
		
	}
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKFunnelChooseModel *model = self.dataArray[indexPath.row];
	if (model.isSelected == YES) {
		self.preIndexPath = indexPath;
	}
	MJKFunnelMoreViewCell *cell = [MJKFunnelMoreViewCell cellWithTableView:tableView];
	cell.model = model;
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.preIndexPath != nil) {
		MJKFunnelChooseModel *model = self.dataArray[self.preIndexPath.row];
		model.isSelected = NO;
		[tableView reloadRowsAtIndexPaths:@[self.preIndexPath] withRowAnimation:UITableViewRowAnimationNone];
	}
	MJKFunnelChooseModel *model = self.dataArray[indexPath.row];
	model.isSelected = YES;
	[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
	self.preIndexPath = indexPath;
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.naviView.frame), self.frame.size.width, self.frame.size.height - self.naviView.frame.size.height) style:UITableViewStylePlain];
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

@end
