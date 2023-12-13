//
//  MJKWorkReportStatementsViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/7.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportStatementsViewController.h"
#import "MJKDayStatisticalDetailViewController.h"
#import "MJKPersonalWorkReportViewController.h"

#import "CalendarView.h"
#import "MJKWorkReportStatementsListCell.h"
#import "MJKStatementsMonthCell.h"

#import "MJKWorkReportStatementsListModel.h"
#import "MJKMonthStatementsModel.h"
#import "MJKMonthStatementsContentModel.h"
#import "MJKWorkReportListModel.h"


@interface MJKWorkReportStatementsViewController ()<CalendarViewDelegate, UITableViewDataSource, UITableViewDelegate>
/** day or month*/
@property (nonatomic, strong) NSString *dayOrMonth;
/** 日历*/
@property (nonatomic, strong) CalendarView *calendar;
/** 当前时间*/
@property (nonatomic, strong) NSString *nowDateStr;
/** 时间 label*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *sepView;
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** WorkReportStatementsListModel array*/
@property (nonatomic, strong) NSArray *reportStatementsListArray;
/** 日统计view*/
@property (nonatomic, strong) UIView *dayView;
/** 月统计view*/
@property (nonatomic, strong) UIView *monthView;
/**month label*/
@property (nonatomic, strong) UILabel *monthLabel;
/** month titleView*/
@property (nonatomic, strong) UIView *titleView;
/** 选择的时间*/
@property (nonatomic, strong) NSString *selectTimeStr;
/** 统计label*/
@property (nonatomic, strong) NSMutableArray *statisticalLabelArray;
/** 条*/
@property (nonatomic, assign) NSInteger pagen;
/** 月统计列表*/
@property (nonatomic, strong) NSArray *statisticalMonthArray;
/** 月 时间*/
@property (nonatomic, strong) NSString *monthDateStr;
/** 月 筛选*/
@property (nonatomic, strong) NSString *monthC_STATUS_DD_IDStr;

@end

@implementation MJKWorkReportStatementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.nowDateStr = [DBTools getWeeksFomatFromCurrentTimeStamp];
	
	[self createDayUI];
	[self initNavi];
}

-(void)setupRefresh{
	DBSelf(weakSelf);
	self.pagen=20;
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pagen=20;
		[weakSelf httpMonthStatisticalListSuccess:nil];
		
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf httpMonthStatisticalListSuccess:nil];
		
	}];
	
	[self.tableView.mj_header beginRefreshing];
	
}

- (void)createDayUI {
	self.dayView = [[UIView alloc]initWithFrame:self.view.frame];
	self.view.backgroundColor = [UIColor whiteColor];
	self.dayOrMonth = @"日统计";
	[self.dayView addSubview:self.calendar];
	self.selectTimeStr = self.nowDateStr;
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame), KScreenWidth, 40)];
	self.timeLabel = timeLabel;
	timeLabel.textColor = [UIColor blackColor];
	[self.dayView addSubview:timeLabel];
	timeLabel.text = self.nowDateStr;
	timeLabel.textAlignment = NSTextAlignmentCenter;
	
	//分割线
	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(timeLabel.frame), KScreenWidth, 20)];
	self.sepView = sepView;
	sepView.backgroundColor = kBackgroundColor;
	[self.dayView addSubview:sepView];
	
	[self.dayView addSubview:self.tableView];
	[self.view addSubview:self.dayView];
	
	self.tableView.frame = CGRectMake(0, CGRectGetMaxY(sepView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.calendar.frame.size.height - self.timeLabel.frame.size.height - self.sepView.frame.size.height);
	[self.monthView removeFromSuperview];
	
	[self httpWorkReportStatementsListSuccess:nil];
}

- (void)createMonthUI:(NSArray *)modelArray {
	[self setupRefresh];
	self.monthView = [[UIView alloc]initWithFrame:self.view.frame];
	[self.view addSubview:self.monthView];
	self.monthDateStr = self.nowDateStr;
	UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 100)];
	self.titleView = titleView;
	[self.monthView addSubview:titleView];
	UIView *monthView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	[titleView addSubview:monthView];
	monthView.backgroundColor = kBackgroundColor;
	UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth - 60) / 2, 0, 60, 30)];
	self.monthLabel = monthLabel;
	[monthView addSubview:monthLabel];
	if (self.nowDateStr.length > 0) {
		monthLabel.text = [[self.nowDateStr substringWithRange:NSMakeRange(5, 2)] stringByAppendingString:@"月"];
	}
	monthLabel.textColor = [UIColor blackColor];
	monthLabel.font = [UIFont systemFontOfSize:14.f];
	monthLabel.textAlignment = NSTextAlignmentCenter;
	
	//上一个月按钮
	UIButton *preButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(monthLabel.frame) - 10 - 20, 0, 20, 30)];
	[monthView addSubview:preButton];
	[preButton setTitleNormal:@"<"];
	[preButton setTitleColor:[UIColor blackColor]];
	[preButton addTarget:self action:@selector(nextOrPreMonthButtonAction:)];
	
	//下一个月
	UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(monthLabel.frame) + 10 , 0, 20, 30)];
	[monthView addSubview:nextButton];
	[nextButton setTitleNormal:@">"];
	[nextButton setTitleColor:[UIColor blackColor]];
	[nextButton addTarget:self action:@selector(nextOrPreMonthButtonAction:)];
	
	//titleView加左滑右滑手势实现上个月下个月
	//左滑
	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
	[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
	[titleView addGestureRecognizer:recognizer];
	//右滑
	recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
	[recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
	[titleView addGestureRecognizer:recognizer];
	
	self.statisticalLabelArray = [NSMutableArray array];
	for (int i = 0; i < modelArray.count; i++) {
		MJKWorkReportStatementsListModel *model = modelArray[i];
		UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth / 3) * i, CGRectGetMaxY(monthLabel.frame), KScreenWidth / 3, 70)];
		bgView.backgroundColor = [UIColor whiteColor];
		[titleView addSubview:bgView];
		
		UILabel *topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, bgView.frame.size.width, 30)];
		[bgView addSubview:topLabel];
		topLabel.text = model.COUNT;
		topLabel.textAlignment = NSTextAlignmentCenter;
		topLabel.textColor = [UIColor blackColor];
		topLabel.font = [UIFont systemFontOfSize:14.f];
		
		UILabel *bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLabel.frame), bgView.frame.size.width, 30)];
		[bgView addSubview:bottomLabel];
		bottomLabel.text = model.C_STATUS_DD_NAME;
		bottomLabel.textAlignment = NSTextAlignmentCenter;
		bottomLabel.textColor = [UIColor blackColor];
		bottomLabel.font = [UIFont systemFontOfSize:14.f];
		
		[self.statisticalLabelArray addObject:topLabel];
		
		UIButton *button = [[UIButton alloc]initWithFrame:bgView.frame];
		[titleView addSubview:button];
		[button setTitleNormal:model.C_STATUS_DD_NAME];
		[button setTitleColor:[UIColor clearColor]];
		[button addTarget:self action:@selector(screenButtonAction:)];
	}
	
	//分割线
	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), KScreenWidth, 20)];
	sepView.backgroundColor = kBackgroundColor;
	[self.monthView addSubview:sepView];
	
	[self.monthView addSubview:self.tableView];
	
	self.tableView.frame = CGRectMake(0, CGRectGetMaxY(sepView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.titleView.frame.size.height - self.sepView.frame.size.height);
	
}

//月筛选
- (void)screenButtonAction:(UIButton *)sender {
	for (MJKWorkReportStatementsListModel *subModel in self.reportStatementsListArray) {
		if ([sender.titleLabel.text isEqualToString:subModel.C_STATUS_DD_NAME]) {
			self.monthC_STATUS_DD_IDStr = subModel.C_STATUS_DD_ID;
		}
	}
	[self.tableView.mj_header beginRefreshing];
}

//MARK:-上一个月和下一个月
- (void)nextOrPreMonthButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"<"]) {
		self.calendar.nextOrPreMonth = @"上一个";
	} else {
		self.calendar.nextOrPreMonth = @"下一个";
	}
}

// 左滑右滑选择时间
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
		NSLog(@"swipe down");
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
		NSLog(@"swipe up");
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		NSLog(@"swipe left");
		self.calendar.nextOrPreMonth = @"下一个";
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		NSLog(@"swipe right");
		self.calendar.nextOrPreMonth = @"上一个";
	}
}

- (void)initNavi {
	UISegmentedControl *segmerntedControl = [[UISegmentedControl alloc]initWithItems:@[@"日统计",@"月统计"]];
	segmerntedControl.selectedSegmentIndex = 0;
	[segmerntedControl addTarget:self action:@selector(selectDayOrMonthSegment:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmerntedControl;
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		return 1;
	} else {
		return self.statisticalMonthArray.count;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		return self.reportStatementsListArray.count;
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		MJKWorkReportStatementsListModel *model = self.reportStatementsListArray[indexPath.row];
		MJKWorkReportStatementsListCell *cell = [MJKWorkReportStatementsListCell cellWithTableView:tableView];
		cell.model = model;
		return cell;
	} else {
		MJKMonthStatementsModel *model = self.statisticalMonthArray[indexPath.section];
		MJKStatementsMonthCell *cell = [MJKStatementsMonthCell cellWithTableView:tableView];
		[cell updateCellWithModel:model];
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		return .1f;
	} else {
		return 10;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.dayOrMonth isEqualToString:@"月统计"]) {
		return 140;
	} else {
		return 44;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		MJKWorkReportStatementsListModel *model = self.reportStatementsListArray[indexPath.row];
		MJKDayStatisticalDetailViewController *vc = [[MJKDayStatisticalDetailViewController alloc]init];
		vc.timeStr = self.timeLabel.text;
		vc.listModel = model;
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		MJKMonthStatementsModel *model = self.statisticalMonthArray[indexPath.section];
		MJKPersonalWorkReportViewController *vc = [[MJKPersonalWorkReportViewController alloc]init];
		MJKWorkReportListModel *reportModel = [[MJKWorkReportListModel alloc]init];
		reportModel.USERID = model.C_U03100_C_ID;
		reportModel.C_HEADIMGURL = model.C_HEADIMGURL;
		reportModel.USERNAME = model.C_NAME;
		vc.listModel = reportModel;
		vc.USERID = model.C_U03100_C_ID;
		vc.createTime = [[self.monthDateStr substringToIndex:10] stringByAppendingString:@" 00:00:00"] ;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

//MARK:-CalendarViewDelegate
- (void)slidingCalendar:(NSString *)date andDirection:(UISwipeGestureRecognizerDirection)direction {
	DBSelf(weakSelf);
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		self.timeLabel.text = date;
		self.selectTimeStr = [date substringToIndex:10];
		[self httpWorkReportStatementsListSuccess:nil];
	} else {
		self.monthLabel.text = [[date substringWithRange:NSMakeRange(5, 2)] stringByAppendingString:@"月"];
		self.selectTimeStr = [date substringToIndex:7];
		self.monthDateStr = date;
		[self httpWorkReportStatementsListSuccess:^(NSArray *modelArray) {
			if ([weakSelf.dayOrMonth isEqualToString:@"月统计"]) {
				for (int i = 0; i < modelArray.count; i++) {
					MJKWorkReportStatementsListModel *model = modelArray[i];
					UILabel *label = weakSelf.statisticalLabelArray[i];
					label.text = model.COUNT;
				}
			}
			[weakSelf.tableView.mj_header beginRefreshing];
		}];
	}
}

- (void)calendarDidDateSelectedDate:(NSString *)date {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		self.timeLabel.text = date;
		self.selectTimeStr = [date substringToIndex:10];
		[self httpWorkReportStatementsListSuccess:nil];
	} else {
		
	}
}

#pragma mark - 选择日还是月
- (void)selectDayOrMonthSegment:(UISegmentedControl *)segment {
	if (segment.selectedSegmentIndex == 0) {
		self.dayOrMonth = @"日统计";
		self.calendar = nil;
		self.selectTimeStr = self.nowDateStr;
		[self createDayUI];
		[self.monthView removeFromSuperview];
		self.statisticalMonthArray = nil;
		[self.tableView reloadData];
		[self httpWorkReportStatementsListSuccess:nil];
	} else {
		self.dayOrMonth = @"月统计";
		self.selectTimeStr = self.nowDateStr;
		[self.dayView removeFromSuperview];
		self.statisticalLabelArray = nil;
		[self.tableView reloadData];
		DBSelf(weakSelf);
		[self httpWorkReportStatementsListSuccess:^(NSArray *modelArray) {
			[weakSelf createMonthUI:modelArray];
		}];
	}
}

//MARK:-http
- (void)httpWorkReportStatementsListSuccess:(void(^)(NSArray *modelArray))completeBlock {
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-dailyList"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.nowDateStr.length > 0) {
		if ([self.dayOrMonth isEqualToString:@"日统计"]) {
			contentDict[@"DATE"] = [self.selectTimeStr substringToIndex:10];
		} else {
			contentDict[@"DATE"] = [self.selectTimeStr substringToIndex:7];
		}
	}
	contentDict[@"TYPE"] = @"1";
	
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.reportStatementsListArray = [MJKWorkReportStatementsListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (completeBlock) {
				completeBlock(weakSelf.reportStatementsListArray);
			}
			if ([weakSelf.dayOrMonth isEqualToString:@"日统计"]) {
				
				[weakSelf.tableView reloadData];
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

//MARK:月统计
- (void)httpMonthStatisticalListSuccess:(void(^)(NSArray *modelArray))completeBlock {
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-dailyDetail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.nowDateStr.length > 0) {
		if ([self.dayOrMonth isEqualToString:@"日统计"]) {
			contentDict[@"DATE"] = [self.selectTimeStr substringToIndex:10];
		} else {
			contentDict[@"DATE"] = [self.selectTimeStr substringToIndex:7];
		}
	}
	contentDict[@"TYPE"] = @"1";
	if (self.monthC_STATUS_DD_IDStr.length > 0) {
		contentDict[@"C_STATUS_DD_ID"] = self.monthC_STATUS_DD_IDStr;
	}
	contentDict[@"currPage"] = @"1";
	contentDict[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.statisticalMonthArray = [MJKMonthStatementsModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (completeBlock) {
				completeBlock(weakSelf.statisticalMonthArray);
			}
			if ([weakSelf.dayOrMonth isEqualToString:@"月统计"]) {
				
				[weakSelf.tableView reloadData];
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		[weakSelf.tableView.mj_header endRefreshing];
		[weakSelf.tableView.mj_footer endRefreshing];
		
	}];
}

//MARK:-set
- (CalendarView *)calendar {
	if (!_calendar) {
		_calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 220) andIsNoSel:@"YES"];
		_calendar.delegate = self;
	}
	return _calendar;
}

- (UITableView *)tableView {
	if (!_tableView) {
		
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sepView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.calendar.frame.size.height - self.timeLabel.frame.size.height - self.sepView.frame.size.height) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

@end
