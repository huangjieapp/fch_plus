//
//  MJKSchedulingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/1.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSchedulingViewController.h"

#import "CalendarView.h"

#import "MJKVacationModel.h"
#import "MJKVacationContentModel.h"

@interface MJKSchedulingViewController ()<CalendarViewDelegate>

/** CalendarView*/
@property (nonatomic, strong) CalendarView *calendar;
/** month*/
@property (nonatomic, strong) UILabel *monthLabel;
/** setting button*/
@property (nonatomic, strong) UIButton *settingButton;
/** 设置*/
@property (nonatomic, assign) BOOL isEdit;
/** 选择的日期*/
@property (nonatomic, strong) NSMutableArray *dateArray;
/** 选择的月份*/
@property (nonatomic, strong) NSString *monthStr;
/** 详情休假日期model*/
@property (nonatomic, strong) MJKVacationModel *vModel;
@end

@implementation MJKSchedulingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI {
	self.title = @"休假排班";
	self.view.backgroundColor = [UIColor whiteColor];
	[self configTitleMonth];
	[self configCalendar];
	[self.view addSubview:self.settingButton];
	[self httpDetailVacation];
}

//MARK:-配置头月份
- (void)configTitleMonth {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
	[self.view addSubview:bgView];
	UILabel *monthLabel = [[UILabel alloc]initWithFrame:CGRectMake((KScreenWidth - 60) / 2, 0, 60, 40)];
	self.monthLabel = monthLabel;
	NSDate *date = [NSDate date];
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	df.dateFormat = @"MM";
	monthLabel.text = [df stringFromDate:date];
	[bgView addSubview:monthLabel];
	monthLabel.font = [UIFont systemFontOfSize:14.f];
	monthLabel.textColor = [UIColor blackColor];
	monthLabel.textAlignment = NSTextAlignmentCenter;
	
	//上一个月按钮
	UIButton *preButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(monthLabel.frame) - 10 - 20, 0, 20, 40)];
	[bgView addSubview:preButton];
	[preButton setTitleNormal:@"<"];
	[preButton setTitleColor:[UIColor blackColor]];
	[preButton addTarget:self action:@selector(nextOrPreMonthButtonAction:)];
	
	//下一个月
	UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(monthLabel.frame) + 10 , 0, 20, 40)];
	[bgView addSubview:nextButton];
	[nextButton setTitleNormal:@">"];
	[nextButton setTitleColor:[UIColor blackColor]];
	[nextButton addTarget:self action:@selector(nextOrPreMonthButtonAction:)];
	
}
//MARK:-上一个月和下一个月
- (void)nextOrPreMonthButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"<"]) {
		self.calendar.nextOrPreMonth = @"上一个";
	} else {
		self.calendar.nextOrPreMonth = @"下一个";
	}
}

//MARK:// 当前时间
- (NSString *)nowDateStr {
	NSDate *date = [NSDate date];
	NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	df.dateFormat = @"yyyy-MM-dd";
	return [df stringFromDate:date];
}

#pragma mark 配置日历
- (void)configCalendar {
	[self.view addSubview:self.calendar];
}

//MARK:-CalendarViewDelegate
- (void)calendarDateSelectedDate:(NSString *)date andIsSelect:(BOOL)isSelect {
	if (date.length > 0) {
		self.monthStr = [date substringToIndex:7];
		if (isSelect == YES) {
			[self.dateArray addObject:[date substringWithRange:NSMakeRange(8, 2)]];
		} else {
			if ([self.dateArray containsObject:[date substringWithRange:NSMakeRange(8, 2)]]) {
				[self.dateArray removeObject:[date substringWithRange:NSMakeRange(8, 2)]];
			}
		}
	}
	
	NSLog(@"===========--------%@",self.dateArray);
}

- (void)slidingCalendar:(NSString *)date andDirection:(UISwipeGestureRecognizerDirection)direction {
	DBSelf(weakSelf);
	//滑动日历会重新加载日历
	for (UIButton *button in self.calendar.buttonArray) {
		if (self.isEdit == YES) {
		button.enabled = YES;
		
		} else {
			button.enabled = NO;
		}
	}
	if (date.length > 7) {
		self.monthLabel.text = [date substringWithRange:NSMakeRange(5, 2)];
	}
	NSInteger month = self.monthLabel.text.integerValue;
	NSString *monthStr;
	if (direction == UISwipeGestureRecognizerDirectionLeft) {
		month -= 1;
		if (month < 10) {
			monthStr = [NSString stringWithFormat:@"%@0%ld",[date substringToIndex:5],month];
		} else {
			monthStr = [NSString stringWithFormat:@"%@%ld",[date substringToIndex:5],month];
		}
		
	} else if (direction == UISwipeGestureRecognizerDirectionRight) {
		month += 1;
		if (month < 10) {
			monthStr = [NSString stringWithFormat:@"%@0%ld",[date substringToIndex:5],month];
		} else {
			monthStr = [NSString stringWithFormat:@"%@%ld",[date substringToIndex:5],month];
		}
	}
	if (self.isEdit == YES) {
		[self httpSetVacationDate:monthStr andSuccess:^{
			
			weakSelf.monthStr = [date substringToIndex:7];
			[weakSelf httpDetailVacation];
		}];
	} else {
		self.monthStr = [date substringToIndex:7];
		[self httpDetailVacation];
	}
	
	
	
	
}

//MARK:-休假排班设置按钮
- (void)settingButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"休假排班设置"]) {
		[sender setTitleNormal:@"保存"];
		self.title = @"休假排班设置";
		self.isEdit = YES;
		for (UIButton *button in self.calendar.buttonArray) {
			button.enabled = YES;
		}
	} else if ([sender.titleLabel.text isEqualToString:@"保存"]) {
		if (self.monthStr.length <= 0) {
			[JRToast showWithText:@"请选择日期"];
			return;
		}
		
		[self httpSetVacationDate:self.monthStr andSuccess:^{
			[sender setTitleNormal:@"休假排班设置"];
			self.title = @"休假排班";
			self.isEdit = NO;
			for (UIButton *button in self.calendar.buttonArray) {
				button.enabled = NO;
			}
		}];
	}
}

//MARK://-休假设置
- (void)httpSetVacationDate:(NSString *)monthStr andSuccess:(void(^)(void))complete {
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-setVacation"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	contentDict[@"C_U03100_C_ID"] = [NewUserSession instance].user.u051Id;
	if (self.monthStr.length > 0) {
		contentDict[@"MONTH"] = monthStr;
	}
	if (self.dateArray.count > 0) {
		contentDict[@"DATES"] = self.dateArray;
	}
	
	
//	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
			if (complete) {
				complete();
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

//MARK: 休假详情
- (void)httpDetailVacation{
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A48800WebService-monthDetail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.monthStr.length > 0) {
		contentDict[@"DATE"] = self.monthStr;
	} else {
		contentDict[@"DATE"] = [[self nowDateStr] substringToIndex:7];
	}
	contentDict[@"C_U03100_C_ID"] = [NewUserSession instance].user.u051Id;
	contentDict[@"TYPE"] = @"0";
	contentDict[@"C_STATUS_DD_ID"] = @"A48800_C_STATUS_0005";
	
	
	DBSelf(weakSelf);
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.vModel = [MJKVacationModel mj_objectWithKeyValues:data];
			NSMutableArray *arr = [NSMutableArray array];
			[weakSelf.dateArray removeAllObjects];
			for (MJKVacationContentModel *subModel in weakSelf.vModel.content) {
				[arr addObject:subModel.DAYNUMBER];
				[weakSelf.dateArray addObject:subModel.DAYNUMBER];
			}
			weakSelf.calendar.vacationArr = arr;
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
}

#pragma mark - set
- (CalendarView *)calendar {
	if (!_calendar) {
		
		_calendar = [[CalendarView alloc] initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, 220) andIsNoSel:@"NO"];
		_calendar.delegate = self;
		for (UIButton *button in _calendar.buttonArray) {
			button.enabled = NO;
		}
	}
	return _calendar;
}

- (UIButton *)settingButton {
	if (!_settingButton) {
		_settingButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 50, KScreenWidth, 50)];
		[_settingButton setTitleColor:[UIColor blackColor]];
		[_settingButton setTitleNormal:@"休假排班设置"];
		_settingButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
		_settingButton.backgroundColor = KNaviColor;
		[_settingButton addTarget:self action:@selector(settingButtonAction:)];
	}
	return _settingButton;
}

- (NSMutableArray *)dateArray {
	if (!_dateArray) {
		_dateArray = [NSMutableArray array];
	}
	return _dateArray;
}

@end
