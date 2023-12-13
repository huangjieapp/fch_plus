//
//  MJKAttendReportViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKAttendReportViewController.h"
#import "MJKPersonAttendanceViewController.h"
#import "MJKAttendReportDayViewController.h"

#import "CalendarView.h"

#import "MJKWorkReportStatementsListModel.h"
#import "MJKMonthStatementsModel.h"

#import "MJKWorkReportStatementsListCell.h"
#import "MJKAttendanceMonthCell.h"

@interface MJKAttendReportViewController ()<UITableViewDataSource,UITableViewDelegate,CalendarViewDelegate>
/** 日 月 选择*/
@property (nonatomic, strong) NSString *dayOrMonth;
/** 日历*/
@property (nonatomic, strong) CalendarView *calendar;
/** day tableview*/
@property (nonatomic, strong) UITableView *dayTableView;
/** month tableview*/
@property (nonatomic, strong) UITableView *monthTableView;
/** 当前时间*/
@property (nonatomic, strong) NSString *nowDateStr;
/** 日统计view*/
@property (nonatomic, strong) UIView *dayView;
/** 时间 label*/
@property (nonatomic, strong) UILabel *timeLabel;
/** 月统计view*/
@property (nonatomic, strong) UIView *monthView;
/**month label*/
@property (nonatomic, strong) UILabel *monthLabel;
/** month titleView*/
@property (nonatomic, strong) UIView *titleView;
/** month data*/
@property (nonatomic, strong) NSArray *attendanceDataArray;
/** 条*/
@property (nonatomic, assign) NSInteger pagen;
/** 选择的时间*/
@property (nonatomic, strong) NSString *selectTimeStr;
/** 月 考勤 label*/
@property (nonatomic, strong) NSMutableArray *statisticalLabelArray;
/** month data*/
@property (nonatomic, strong) NSArray *monthDataArray;

/** 月筛选*/
@property (nonatomic, strong) NSString *monthC_STATUS_DD_IDStr;

@end

@implementation MJKAttendReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.nowDateStr = [DBTools getWeeksFomatFromCurrentTimeStamp];
	[self createDayUI];
    [self initNavi];
}

- (void)initNavi {
	UISegmentedControl *segmerntedControl = [[UISegmentedControl alloc]initWithItems:@[@"日统计",@"月统计"]];
	segmerntedControl.selectedSegmentIndex = 0;
	[segmerntedControl addTarget:self action:@selector(selectDayOrMonthSegment:) forControlEvents:UIControlEventValueChanged];
	self.navigationItem.titleView = segmerntedControl;
}

-(void)setupRefresh{
	DBSelf(weakSelf);
	self.pagen=20;
	self.monthTableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		weakSelf.pagen=20;
		[weakSelf httpMonthStatisticalListSuccess:nil];

	}];

	self.monthTableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf httpMonthStatisticalListSuccess:nil];

	}];

	[self.monthTableView.mj_header beginRefreshing];

}

#pragma mark - 选择日还是月
- (void)selectDayOrMonthSegment:(UISegmentedControl *)segment {
	
	self.selectTimeStr = self.nowDateStr;
	if (segment.selectedSegmentIndex == 0) {
		self.dayOrMonth = @"日统计";
		
		
		[self.monthView removeFromSuperview];
		self.monthDataArray = nil;
		[self.monthTableView reloadData];
		self.calendar = nil;
		[self createDayUI];
//		[self httpWorkReportStatementsListSuccess:nil];
	} else {
		self.dayOrMonth = @"月统计";
//		self.selectTimeStr = self.nowDateStr;
		[self.dayView removeFromSuperview];
		self.attendanceDataArray = nil;
		[self.dayTableView reloadData];
		self.calendar = nil;
		DBSelf(weakSelf);
		[self httpWorkReportStatementsListSuccess:^(NSArray *modelArray) {
			[weakSelf createMonthUI:modelArray];
		}];
	}
}

- (void)createDayUI {
	self.dayOrMonth = @"日统计";
	self.dayView = [[UIView alloc]initWithFrame:self.view.frame];
	self.view.backgroundColor = [UIColor whiteColor];
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
	sepView.backgroundColor = kBackgroundColor;
	[self.dayView addSubview:sepView];
	
	[self.dayView addSubview:self.dayTableView];
	[self.view addSubview:self.dayView];
	
	self.dayTableView.frame = CGRectMake(0, CGRectGetMaxY(sepView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.calendar.frame.size.height - self.timeLabel.frame.size.height - sepView.frame.size.height);
	[self.monthView removeFromSuperview];
	
	[self httpWorkReportStatementsListSuccess:nil];
}

- (void)createMonthUI:(NSArray *)modelArray {
	[self setupRefresh];
	self.monthView = [[UIView alloc]initWithFrame:self.view.frame];
	[self.view addSubview:self.monthView];
	
	UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 170)];
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
		UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth / 3) * (i % 3), 30 + (i / 3) * 70, KScreenWidth / 3, 70)];
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
		bottomLabel.font = [UIFont systemFontOfSize:14.f];
		NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(人次)",model.C_STATUS_DD_NAME]] ;
		[attStr setAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} range:NSMakeRange(model.C_STATUS_DD_NAME.length, 4)];
		bottomLabel.attributedText = attStr;
		bottomLabel.textAlignment = NSTextAlignmentCenter;
		bottomLabel.textColor = [UIColor blackColor];
		

		[self.statisticalLabelArray addObject:topLabel];
		
		
		UIButton *button = [[UIButton alloc]initWithFrame:bgView.frame];
//		button.tag = i + 1000;
		[button setTitleColor:[UIColor clearColor]];
		[button setTitleNormal:bottomLabel.text];
		[button addTarget:self action:@selector(screenButtonAction:)];
		[titleView addSubview:button];
		
	}
	
	//横向分割线
	UIView *vSepView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, KScreenWidth, 1)];
	vSepView.backgroundColor = kBackgroundColor;
	[titleView insertSubview:vSepView atIndex:999];
	//			[titleView addSubview:vSepView];
	[titleView bringSubviewToFront:vSepView];
	
	//纵向分割线
	for (int i = 0; i < modelArray.count / 3; i++) {
		UIView *hSepView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth / 3) * (i + 1), 30, 1, titleView.frame.size.height - 30)];
		hSepView.backgroundColor = kBackgroundColor;
		[titleView addSubview:hSepView];
		[titleView bringSubviewToFront:hSepView];
	}
	
	
	
	
	//大分割线
	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(titleView.frame), KScreenWidth, 20)];
	sepView.backgroundColor = kBackgroundColor;
	[self.monthView addSubview:sepView];
	
	[self.monthView addSubview:self.monthTableView];
	
	self.monthTableView.frame = CGRectMake(0, CGRectGetMaxY(sepView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.titleView.frame.size.height - sepView.frame.size.height);
	
}
//月筛选
- (void)screenButtonAction:(UIButton *)sender {
	for (MJKWorkReportStatementsListModel *model in self.attendanceDataArray) {
		if ([model.C_STATUS_DD_NAME isEqualToString:[sender.titleLabel.text substringToIndex:model.C_STATUS_DD_NAME.length]]) {
			self.monthC_STATUS_DD_IDStr = model.C_STATUS_DD_ID;
		}
	}
	[self.monthTableView.mj_header beginRefreshing];
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

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		return 1;
	} else {
		return self.monthDataArray.count;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		return self.attendanceDataArray.count;
	} else {
		return 1;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		MJKWorkReportStatementsListModel *model = self.attendanceDataArray[indexPath.row];
		MJKWorkReportStatementsListCell *cell = [MJKWorkReportStatementsListCell cellWithTableView:tableView];
		cell.model = model;
		return cell;
	} else {
		MJKMonthStatementsModel *model = self.monthDataArray[indexPath.section];
		MJKAttendanceMonthCell *cell = [MJKAttendanceMonthCell cellWithTableView:tableView];
		cell.model = model;
		return cell;
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		MJKWorkReportStatementsListModel *model = self.attendanceDataArray[indexPath.row];
		MJKAttendReportDayViewController *vc = [[MJKAttendReportDayViewController alloc]init];
		vc.timeStr = self.timeLabel.text;
		vc.listModel = model;
		[self.navigationController pushViewController:vc animated:YES];
	} else {
		MJKMonthStatementsModel *model = self.monthDataArray[indexPath.section];
		MJKPersonAttendanceViewController *vc = [[MJKPersonAttendanceViewController alloc]init];
		vc.listModel = model;
		vc.timeStr = self.selectTimeStr;
		[self.navigationController pushViewController:vc animated:YES];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		return 44;
	} else {
		return 140;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if ([self.dayOrMonth isEqualToString:@"月统计"]) {
		if (section != 0) {
			return 10;
		}
	}
	return .1f;
}


//MARK:-CalendarViewDelegate
- (void)slidingCalendar:(NSString *)date andDirection:(UISwipeGestureRecognizerDirection)direction {
	DBSelf(weakSelf);
	if ([self.dayOrMonth isEqualToString:@"日统计"]) {
		self.timeLabel.text = date;
		self.selectTimeStr = date;//[date substringToIndex:10];
		[self httpWorkReportStatementsListSuccess:nil];
	} else {
		self.monthLabel.text = [[date substringWithRange:NSMakeRange(5, 2)] stringByAppendingString:@"月"];
		self.selectTimeStr = date;//[date substringToIndex:7];
		[self httpWorkReportStatementsListSuccess:^(NSArray *modelArray) {
			if ([weakSelf.dayOrMonth isEqualToString:@"月统计"]) {
				for (int i = 0; i < modelArray.count; i++) {
					MJKWorkReportStatementsListModel *model = modelArray[i];
					UILabel *label = weakSelf.statisticalLabelArray[i];
					label.text = model.COUNT;
				}
			}
			[weakSelf.monthTableView.mj_header beginRefreshing];
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
	contentDict[@"TYPE"] = @"0";
	
	
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.attendanceDataArray = [MJKWorkReportStatementsListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (completeBlock) {
				completeBlock(weakSelf.attendanceDataArray);
			}
			if ([weakSelf.dayOrMonth isEqualToString:@"月统计"]) {
				
				[weakSelf.monthTableView reloadData];
			} else {
				[weakSelf.dayTableView reloadData];
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
	contentDict[@"TYPE"] = @"0";
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
			weakSelf.monthDataArray = [MJKMonthStatementsModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (completeBlock) {
				completeBlock(weakSelf.monthDataArray);
			}
			if ([weakSelf.dayOrMonth isEqualToString:@"月统计"]) {

				[weakSelf.monthTableView reloadData];
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		[weakSelf.monthTableView.mj_header endRefreshing];
		[weakSelf.monthTableView.mj_footer endRefreshing];
		
	}];
}

#pragma mark - set
- (UITableView *)dayTableView {
	if (!_dayTableView) {
		_dayTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight)];
		_dayTableView.dataSource = self;
		_dayTableView.delegate = self;
		_dayTableView.estimatedRowHeight = 0;
		_dayTableView.estimatedSectionFooterHeight = 0;
		_dayTableView.estimatedSectionHeaderHeight = 0;
		_dayTableView.tableFooterView = [[UIView alloc]init];
	}
	return _dayTableView;
}

- (UITableView *)monthTableView {
	if (!_monthTableView) {
		_monthTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight)];
		_monthTableView.dataSource = self;
		_monthTableView.delegate = self;
		_monthTableView.estimatedRowHeight = 0;
		_monthTableView.estimatedSectionFooterHeight = 0;
		_monthTableView.estimatedSectionHeaderHeight = 0;
		_monthTableView.tableFooterView = [[UIView alloc]init];
	}
	return _monthTableView;
}

- (CalendarView *)calendar {
	if (!_calendar) {
		_calendar = [[CalendarView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 220) andIsNoSel:@"YES"];
		_calendar.delegate = self;
	}
	return _calendar;
}

@end
