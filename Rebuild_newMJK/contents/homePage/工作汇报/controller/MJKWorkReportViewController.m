//
//  MJKWorkReportViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/6/27.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportViewController.h"

#import "CGCNavSearchTextView.h"
#import "MJKWorkReportListCell.h"

#import "MJKWorkReportListModel.h"
#import "MJKWorkReportDetailModel.h"

#import "MJKCommentsViewController.h"
#import "MJKAddWorkReporeViewController.h"
#import "MJKPersonalWorkReportViewController.h"

#define addImageWidth 25

@interface MJKWorkReportViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 搜索框*/
@property (nonatomic, strong) CGCNavSearchTextView *CurrentTitleView;
/** 条*/
@property (nonatomic, assign) NSInteger pageSize;
/** dataListArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** cell高度*/
@property (nonatomic, assign) NSInteger cellHeight;
/** cellArray 不释放cell*/
@property (nonatomic, strong) NSMutableArray *cellArray;
/** 查找字段*/
@property (nonatomic, strong) NSString *SEARCH_CONTENT;
/** 无数据时*/
@property (nonatomic, strong) UIView *noDataView;
@end

@implementation MJKWorkReportViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self getReportList];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
}

- (void)initUI {
	//搜索框
	[self setupSearchBar];
	[self.view addSubview:self.tableView];
	[self setRefresh];
	[self setNaviRightButtonItem];
	[self noDataViewLabel];
}

- (void)setRefresh {
	DBSelf(weakSelf);
	self.pageSize = 20;
	self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pageSize = 20;
		[weakSelf getReportList];
	}];
	
	self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pageSize += 20;
		[weakSelf getReportList];
	}];
	[self.tableView.mj_header beginRefreshing];
}

- (void)setNaviRightButtonItem {
	UIView *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
	UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"新增日报图标"]];
	imageView.frame = CGRectMake((itemView.frame.size.width - addImageWidth) / 2, (itemView.frame.size.height - addImageWidth) / 2, addImageWidth, addImageWidth);
	UIButton *button = [[UIButton alloc]initWithFrame:itemView.frame];
//	[button setImage:[UIImage imageNamed:@"新增日报图标"] forState:UIControlStateNormal];
//	button.imageEdgeInsets = UIEdgeInsetsMake(5, 30, 5, 0);
	[button addTarget:self action:@selector(addWorkreportAction:)];
	[itemView addSubview:imageView];
	[itemView addSubview:button];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:itemView];
	self.navigationItem.rightBarButtonItem = item;
}

#pragma 新增汇报
- (void)addWorkreportAction:(UIButton *)sender {
	//新增
	MJKAddWorkReporeViewController *vc = [[MJKAddWorkReporeViewController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 设置导航搜索框
- (void)setupSearchBar {
	DBSelf(weakSelf);
	self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"搜索姓名/备注" withRecord:^{//点击录音
		
		
	} withText:^{//开始编辑
		MyLog(@"编辑");
		
	}withEndText:^(NSString *str) {//结束编辑
		NSLog(@"%@____",str);
		weakSelf.SEARCH_CONTENT = str;
		[weakSelf.tableView.mj_header beginRefreshing];
	}];
	self.CurrentTitleView.recordBtn.hidden = YES;
	self.navigationItem.titleView=self.CurrentTitleView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKWorkReportListModel *listModel = self.dataArray[indexPath.section];
//	MJKWorkReportListCell *cell = [MJKWorkReportListCell cellWithTableView:tableView];
	MJKWorkReportListCell *cell = self.cellArray[indexPath.section];
	cell.rootVC = self;
	cell.listModel = listModel;
	
	//点击个人
	cell.didSelectPersonalBlock = ^{
		MJKPersonalWorkReportViewController *vc = [[MJKPersonalWorkReportViewController alloc]init];
		vc.USERID = listModel.USERID;
		vc.createTime = listModel.D_CREATE_TIME;
		vc.listModel = listModel;
		[weakSelf.navigationController pushViewController:vc animated:YES];
	};
	
	// cell高度
	cell.backCellHeightBlock = ^(NSInteger cellHeight) {
		weakSelf.cellHeight = cellHeight;
		[weakSelf.tableView beginUpdates];
		[weakSelf.tableView endUpdates];
	};

	cell.praiseBlock = ^(BOOL isSelected) {
		weakSelf.view.userInteractionEnabled = NO;
		if (isSelected == YES) {
			[weakSelf httpCancelPraiseAction:listModel.C_ID];
		} else {
			[weakSelf httpPraiseAction:listModel.C_ID];
		}
	};

	cell.commentsBlock = ^{
		MJKCommentsViewController *vc = [[MJKCommentsViewController alloc]init];
		vc.C_OBJECTID = listModel.C_ID;
		vc.typeStr = @"评论";
		[weakSelf.navigationController pushViewController:vc animated:YES];
	};
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKWorkReportListModel *listModel = self.dataArray[indexPath.section];
	CGSize mrSize;
	if (listModel.X_MRPLANDETAILED.length > 0) {
		mrSize = [[NSString stringWithFormat:@"%@\n备注:\n%@",listModel.X_MRPLANDETAILED, listModel.X_MRPLAN] boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	} else {
		mrSize = [listModel.X_MRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	}
	CGSize zrSize = [listModel.X_ZRPLAN boundingRectWithSize:CGSizeMake(KScreenWidth - 10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	NSInteger mrHeight;
	if (listModel.X_MRPLAN.length > 0 || listModel.X_MRPLANDETAILED.length > 0) {
		mrHeight = mrSize.height + 23;
	} else {
		mrHeight = 44;
	}
	
	NSInteger zrHeight;
	if (listModel.X_ZRPLAN.length > 0) {
		zrHeight = zrSize.height + 23;
	} else {
		zrHeight = 44;
	}
	
	CGSize remarkSize = [[NSString stringWithFormat:@"备注:\n%@",listModel.X_REMARK] boundingRectWithSize:CGSizeMake(KScreenWidth - 15, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	NSInteger remarkHeight;
	if (listModel.X_REMARK.length > 0) {
		remarkHeight = remarkSize.height + 25;
	} else {
		remarkHeight = 0;
	}
	
	NSInteger headerHeight = 22 * 3;
	NSInteger footHight = listModel.urlList.count > 0 ? 200 + 10 : 60;
	NSInteger rowHeight = listModel.content.count * 30 + 1 * 44 + mrHeight + zrHeight + remarkHeight + footHight + 10;
	if (self.cellHeight != 0) {
		if (listModel.isSelected == YES) {
			return self.cellHeight + headerHeight + rowHeight;
		} else {
			return headerHeight + rowHeight;
		}
		
	} else {
		return headerHeight + rowHeight;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return 1;
	} else {
		return 10;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
	view.backgroundColor = kBackgroundColor;
	if (section == 0) {
		return nil;
	} else {
		return view;
	}
}
#pragma mark -
- (void)noDataViewLabel {
	UIView *view = [[UIView alloc]initWithFrame:self.view.frame];
	view.backgroundColor = [UIColor whiteColor];
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (KScreenHeight - 40) / 2, KScreenWidth, 40)];
	label.text = @"暂无日报";
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	label.textAlignment = NSTextAlignmentCenter;
	[view addSubview:label];
	view.hidden = YES;
	[self.view addSubview:view];
	self.noDataView = view;
}
#pragma mark - get report list
- (void)getReportList {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A48600WebService-getList"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"currPage"] = @"1";
	dic[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pageSize];
	if (self.SEARCH_CONTENT.length > 0) {
		dic[@"SEARCH_CONTENT"] = self.SEARCH_CONTENT;
	}
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		weakSelf.cellArray = nil;
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKWorkReportListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
			if (weakSelf.dataArray.count > 0) {
				weakSelf.noDataView.hidden = YES;
			} else {
				weakSelf.noDataView.hidden = NO;
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
		weakSelf.view.userInteractionEnabled = YES;
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark 点赞
- (void)httpPraiseAction:(NSString *)C_OBJECT_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-insertFabulous"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECT_ID"] = C_OBJECT_ID;
	dic[@"C_ID"] = [DBObjectTools getWorkReportA61200];
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getReportList];
			[JRToast showWithText:@"点赞成功"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark 取消点赞
- (void)httpCancelPraiseAction:(NSString *)C_OBJECT_ID {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-deleteFabulous"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_OBJECT_ID"] = C_OBJECT_ID;
	[dict setObject:dic forKey:@"content"];
	DBSelf(weakSelf);
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getReportList];
			[JRToast showWithText:@"点赞取消"];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		[self.tableView.mj_header endRefreshing];
		[self.tableView.mj_footer endRefreshing];
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStylePlain];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.tableFooterView = [[UIView alloc]init];
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
	}
	return _tableView;
}

- (NSMutableArray *)cellArray {
	if (!_cellArray) {
		_cellArray = [NSMutableArray array];
		for (int i = 0; i < self.dataArray.count; i++) {
			MJKWorkReportListCell *cell = [MJKWorkReportListCell cellWithTableView:self.tableView];
			[_cellArray addObject:cell];
		}
	}
	return _cellArray;
}

- (void)dealloc {
	
}
@end
