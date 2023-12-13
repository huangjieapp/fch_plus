//
//  CalendarView.m
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#import "CalendarView.h"
//#import "PrefixHeader.h"

#import "MJKVacationContentModel.h"

@interface CalendarView() {
	UISwipeGestureRecognizer *recognizer;
}

@property (nonatomic, weak) UIButton *preBtn;
@property (nonatomic, weak) UIButton *nextBtn;

@property (nonatomic, weak) UILabel *titleLable;
@property (nonatomic, weak) UIView *titleView;
@property (nonatomic, weak) UIView *dateView;

@property (nonatomic, strong) NSMutableArray *dateArray;
@property (nonatomic, strong) NSMutableArray *labelArray;

@property (nonatomic, assign) NSInteger days;
@property (nonatomic, assign) NSInteger firstDays;

@property (nonatomic, strong) NSDate *currentDate;

/** 上一个button日期*/
@property (nonatomic, strong) UIButton *preDayButton;
/** 上一个button颜色*/
@property (nonatomic, strong) UIColor *preColor;
/** 时间点数组*/
@property (nonatomic, strong) NSMutableArray *dotArray;

/** 滑动手势*/
//@property (nonatomic, strong) UISwipeGestureRecognizer *recognizer;


@end

@implementation CalendarView

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}

- (NSMutableArray *)dotArray {
	if (!_dotArray) {
		_dotArray = [NSMutableArray array];
	}
	return _dotArray;
}

- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}

- (NSMutableArray *)dateArray {
    if (!_dateArray) {
        
        _dateArray = [NSMutableArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    }
    return _dateArray;
}

// 获取星期
- (NSInteger)getCurrentWeek:(NSDate *)date {
	
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:date];
	
	NSInteger day = [components weekday];
	return day;
}

// 获取日
- (NSInteger)getCurrentDay:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger day = [components day];
    return day;
}

// 获取月
- (NSInteger)getCurrentMonth:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger month = [components month];
    return month;
}

// 获取年
- (NSInteger)getCurrentYear:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSInteger year = [components year];
    return year;
}

// 一个月有多少天
- (NSInteger)getTotalDaysInMonth:(NSDate *)date {
    
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}

// 每月第一天
- (NSInteger)getFirstDayOfMonth:(NSDate *)date {
	NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"周日",@"1",@"周一",@"2",@"周二",@"3",@"周三",@"4",@"周四",@"5",@"周五",@"6",@"周六", nil];
	double interval = 0;
	NSDate *firstDate = nil;
	NSDate *lastDate = nil;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:date];
	
	if (OK) {
		lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
	}
	
	NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
	[myDateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
	[myDateFormatter setDateFormat:@"EEE"];
	NSString *firstString = [myDateFormatter stringFromDate: firstDate];
	__block NSInteger firstDayOfMonth;
	[dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
		if ([key isEqualToString:firstString]) {
			firstDayOfMonth = [obj integerValue];
		}
	}];
//	NSString *lastString = [myDateFormatter stringFromDate: lastDate];
//    NSInteger firstDayOfMonth = [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:date];
    return firstDayOfMonth;
}

- (NSArray *)getMonthFirstAndLastDayWith:(NSString *)dateStr{
	
	NSDateFormatter *format=[[NSDateFormatter alloc] init];
    format.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[format setDateFormat:@"yyyy-MM-dd"];
	NSDate *newDate=[format dateFromString:dateStr];
	double interval = 0;
	NSDate *firstDate = nil;
	NSDate *lastDate = nil;
	NSCalendar *calendar = [NSCalendar currentCalendar];
	
	BOOL OK = [calendar rangeOfUnit:NSCalendarUnitMonth startDate:& firstDate interval:&interval forDate:newDate];
	
	if (OK) {
		lastDate = [firstDate dateByAddingTimeInterval:interval - 1];
	}else {
		return @[@"",@""];
	}
	
	NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    myDateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[myDateFormatter setDateFormat:@"yyyy-MM-dd"];
	NSString *firstString = [myDateFormatter stringFromDate: firstDate];
	NSString *lastString = [myDateFormatter stringFromDate: lastDate];
	return @[firstString, lastString];
}

// 上个月
- (NSDate *)lastMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

// 下个月
- (NSDate *)nextMonth:(NSDate *)date {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

- (instancetype)initWithFrame:(CGRect)frame andIsNoSel:(NSString *)isNo {
    if (self = [super initWithFrame:frame]) {
        self.isNoSel = isNo;
        self.backgroundColor = kBackgroundColor;
        
        _currentDate = [NSDate date];

        UIButton *preBtn = [[UIButton alloc] init];
        [preBtn setTitle:@"<<" forState:UIControlStateNormal];
        [preBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [preBtn addTarget:self action:@selector(preBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:preBtn];
        self.preBtn = preBtn;
        
        UIButton *nextBtn = [[UIButton alloc] init];
        [nextBtn setTitle:@">>" forState:UIControlStateNormal];
        [nextBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:nextBtn];
        self.nextBtn = nextBtn;
		
		
//        UILabel *titleLable = [[UILabel alloc] init];
//        titleLable.text = @"2010年10月20日";
//        titleLable.textAlignment = NSTextAlignmentCenter;
//        titleLable.textColor = [UIColor blackColor];
//        [self addSubview:titleLable];
//        self.titleLable = titleLable;
		
        
        UIView *titleView = [[UIView alloc] init];
        titleView.backgroundColor = [UIColor clearColor];
        [self addSubview:titleView];
        self.titleView = titleView;
        
        for (int i = 0; i < self.dateArray.count; i++) {
            
            UILabel *label = [[UILabel alloc] init];
            label.text = self.dateArray[i];
            label.textColor = [UIColor darkGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self.titleView addSubview:label];
            [self.labelArray addObject:label];
        }
        
        UIView *dateView = [[UIView alloc] init];
        dateView.backgroundColor = [UIColor clearColor];
        [self addSubview:dateView];
        self.dateView = dateView;
        
        [self loadWithDate:_currentDate];
		
		//左滑
		recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
		[recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
		[self addGestureRecognizer:recognizer];
		//右滑
		recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
		[recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
		[self addGestureRecognizer:recognizer];
    }
    return self;
}
// 左滑右滑选择时间
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
	if (self.noScroll == YES) {
		return;
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
		NSLog(@"swipe down");
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
		NSLog(@"swipe up");
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
		NSLog(@"swipe left");
		NSDate *nextDate = [self nextMonth:_currentDate];
		[self loadWithDate:nextDate];
		
		[self setNeedsLayout];
		
		_currentDate = nextDate;
		self.selectNewDate = [[self getYMD:nextDate]substringWithRange:NSMakeRange(8, 2)];
		if ([self.delegate respondsToSelector:@selector(slidingCalendar:andDirection:)]) {
			[self.delegate slidingCalendar:[self stringFormatterWithDate:nextDate] andDirection:UISwipeGestureRecognizerDirectionLeft];
		}
	}
	if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
		NSLog(@"swipe right");

		NSDate *preDate = [self lastMonth:_currentDate];
		[self loadWithDate:preDate];
		
		[self setNeedsLayout];
		
		_currentDate = preDate;
		self.selectNewDate = [[self getYMD:preDate] substringWithRange:NSMakeRange(8, 2)];;
		if ([self.delegate respondsToSelector:@selector(slidingCalendar:andDirection:)]) {
			[self.delegate slidingCalendar:[self stringFormatterWithDate:preDate] andDirection:UISwipeGestureRecognizerDirectionRight];
		}
	}
}

- (void)setNextOrPreMonth:(NSString *)nextOrPreMonth {
	_nextOrPreMonth = nextOrPreMonth;
	if ([nextOrPreMonth isEqualToString:@"上一个"]) {
		NSDate *preDate = [self lastMonth:_currentDate];
		[self loadWithDate:preDate];
		
		[self setNeedsLayout];
		
		_currentDate = preDate;
		self.selectNewDate = [[self getYMD:preDate]substringWithRange:NSMakeRange(8, 2)];
		if ([self.delegate respondsToSelector:@selector(slidingCalendar:andDirection:)]) {
			[self.delegate slidingCalendar:[self stringFormatterWithDate:preDate] andDirection:UISwipeGestureRecognizerDirectionRight];
		}
	}
	
	if ([nextOrPreMonth isEqualToString:@"下一个"]) {
		NSDate *nextDate = [self nextMonth:_currentDate];
		[self loadWithDate:nextDate];
		
		[self setNeedsLayout];
		
		_currentDate = nextDate;
		self.selectNewDate = [[self getYMD:nextDate]substringWithRange:NSMakeRange(8, 2)];
		if ([self.delegate respondsToSelector:@selector(slidingCalendar:andDirection:)]) {
			[self.delegate slidingCalendar:[self stringFormatterWithDate:nextDate] andDirection:UISwipeGestureRecognizerDirectionLeft];
		}
	}
}


- (void)loadWithDate:(NSDate *)date {
    
    // 移除所有
    if (self.buttonArray) {
        [self.buttonArray removeAllObjects];
    }
	
	if (self.dotArray) {
		[self.dotArray removeAllObjects];
	}
    if (self.dateView.subviews.count > 0) {
          [self.dateView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    // 获取当月有多少天
    _days = [self getTotalDaysInMonth:date];
    _firstDays = [self getFirstDayOfMonth:date];
	
	if (_firstDays <0) {
		_firstDays = 7 + _firstDays;
	}
    
//    self.titleLable.text = [NSString stringWithFormat:@"%zd年%zd月%zd日",[self getCurrentYear:date],[self getCurrentMonth:date],[self getCurrentDay:date]];
	NSLog(@"%zd",[self getCurrentWeek:date]);
    
    for (int i = 1; i <= _days; i++) {
		UIView *dotView = [[UIView alloc]init];
		dotView.backgroundColor = [UIColor orangeColor];
		dotView.hidden = YES;
		
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:[NSString stringWithFormat:@"%zd",i] forState:UIControlStateNormal];
		
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        if (i == [self getCurrentDay:[NSDate date]]) {
//            if (![self.isNoSel isEqualToString:@"NO"]) {
//                button.backgroundColor = KNaviColor;
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                self.preDayButton = button;
//            }
//
//        }
        if([self.isNoSel isEqualToString:@"NO"] || ![self.vcName isEqualToString:@"个人动态日报"]){
            [button addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
        }
        [self.dateView addSubview:button];
		[self.dateView addSubview:dotView];
        [self.buttonArray addObject:button];
		[self.dotArray addObject:dotView];
    }
}

- (void)dateSelect:(UIButton *)sender {
	if (self.vacationModel != nil) {
		self.preDayButton.backgroundColor = self.preColor;
		[self.preDayButton setTitleColor:[UIColor blackColor]];
		self.preDayButton.layer.borderColor = [UIColor clearColor].CGColor;
		self.preDayButton.layer.borderWidth = 0;
		
		NSString *buttonStr = sender.titleLabel.text;
		if ([buttonStr intValue] < 10) {
			buttonStr = [NSString stringWithFormat:@"0%@",buttonStr];
		}
			
		for (MJKVacationContentModel *subModel in self.vacationModel.content) {
		//当天被选中的状态颜色
			if ([buttonStr isEqualToString:subModel.DAYNUMBER]) {
				if ([subModel.C_STATUS_DD_NAME isEqualToString:@"正常出勤"]) {
					
					
					sender.backgroundColor = [UIColor clearColor];
					[sender setTitleColor:KGreenColor];
					sender.layer.borderColor = KGreenColor.CGColor;
					sender.layer.borderWidth = 1.f;
					self.preColor = KGreenColor;
					self.preDayButton = sender;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"迟到早退"]) {
//					self.preDayButton.backgroundColor = [UIColor redColor];
//					[self.preDayButton setTitleColor:[UIColor blackColor]];
//					self.preDayButton.layer.borderColor = [UIColor clearColor].CGColor;
//					self.preDayButton.layer.borderWidth = 0;
					
					sender.backgroundColor = [UIColor clearColor];
					[sender setTitleColor:KBlueColor];
					sender.layer.borderColor = KBlueColor.CGColor;
					sender.layer.borderWidth = 1.f;
					self.preColor = KBlueColor;
					self.preDayButton = sender;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"忘签退"]) {
//					self.preDayButton.backgroundColor = KBlueColor;
//					[self.preDayButton setTitleColor:[UIColor blackColor]];
//					self.preDayButton.layer.borderColor = [UIColor clearColor].CGColor;
//					self.preDayButton.layer.borderWidth = 0;
					
					sender.backgroundColor = [UIColor clearColor];
					[sender setTitleColor:KYellowColor];
					sender.layer.borderColor = KYellowColor.CGColor;
					sender.layer.borderWidth = 1.f;
					self.preColor = KYellowColor;
					self.preDayButton = sender;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"缺勤"]) {
//					self.preDayButton.backgroundColor = KGreenColor;
//					[self.preDayButton setTitleColor:[UIColor blackColor]];
//					self.preDayButton.layer.borderColor = [UIColor clearColor].CGColor;
//					self.preDayButton.layer.borderWidth = 0;
					
					sender.backgroundColor = [UIColor clearColor];
					[sender setTitleColor:KRedColor];
					sender.layer.borderColor = KRedColor.CGColor;
					sender.layer.borderWidth = 1.f;
					self.preColor = KRedColor;
					self.preDayButton = sender;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"休假"]) {
//					self.preDayButton.backgroundColor = KPurpleColor;
//					[self.preDayButton setTitleColor:[UIColor blackColor]];
//					self.preDayButton.layer.borderColor = [UIColor clearColor].CGColor;
//					self.preDayButton.layer.borderWidth = 0;
					
					sender.backgroundColor = [UIColor clearColor];
					[sender setTitleColor:KPurpleColor];
					sender.layer.borderColor = KPurpleColor.CGColor;
					sender.layer.borderWidth = 1.f;
					self.preColor = KPurpleColor;
					self.preDayButton = sender;
				}
				NSString *dateStr ;
				dateStr = [NSString stringWithFormat:@"%zd-%zd-%@",[self getCurrentYear:_currentDate ],[self getCurrentMonth:_currentDate],sender.titleLabel.text];
				
				NSDate *date = [self dateFormatterWithStr:dateStr];
				if ([self.delegate respondsToSelector:@selector(calendarDidDateSelectedDate:)]) {
					[self.delegate calendarDidDateSelectedDate:[self stringFormatterWithDate:date]];
				}
				return;
			} else {
				sender.backgroundColor = [UIColor clearColor];
				[sender setTitleColor:COLOR_RGB(0xFFDD00)];
				sender.layer.borderColor = COLOR_RGB(0xFFDD00).CGColor;
				sender.layer.borderWidth = 1.f;
				self.preColor = [UIColor clearColor];
				self.preDayButton = sender;
				
			}
			
		}
			
		
		
	} else
	
	
	if (![self.isNoSel isEqualToString:@"NO"]) {
		[self.preDayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		self.preDayButton.backgroundColor = [UIColor clearColor];
		
		[sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		sender.backgroundColor = KNaviColor;
		
	self.preDayButton = sender;
	} else {
		
		//小于等于今天不需要选择
		NSDate *date = [NSDate date];
		NSString *nowDate = [self getYMD:date];
		int nowY = [[nowDate substringToIndex:4]intValue];
		int nowM = [[nowDate substringWithRange:NSMakeRange(5, 2)]intValue];
		int nowD = [[nowDate substringFromIndex:8]intValue];
		NSString *currentDate = [self getYMD:_currentDate];
		int selectY = [[currentDate substringToIndex:4]intValue];
		int selectM = [[currentDate substringWithRange:NSMakeRange(5, 2)]intValue];
		int selectD = [sender.titleLabel.text intValue];
		
		if (selectY < nowY) {
			[JRToast showWithText:@"过去以及今天，不能选择"];
			return;
		}
		if (selectY <= nowY) {
			if (selectM < nowM) {
				[JRToast showWithText:@"过去以及今天，不能选择"];
				return;
			}
		}
		if (selectY <= nowY) {
			if (selectM <= nowM) {
				if (selectD <= nowD) {
					[JRToast showWithText:@"过去以及今天，不能选择"];
					return;
				}
			}
		}
		//yes选中
		sender.selected = !sender.isSelected;
		if (sender.isSelected == YES) {
			[sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
			sender.backgroundColor = KNaviColor;
		} else {
			[sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
			sender.backgroundColor = [UIColor clearColor];
		}
		
	}
	if ([self.vcName isEqualToString:@"个人工作汇报"]) {
	for (int i = 0; i < self.buttonArray.count; i++) {
		UIButton *button = self.buttonArray[i];
		NSString *buttonStr = button.titleLabel.text;
		if ([buttonStr intValue] < 10) {
			buttonStr = [NSString stringWithFormat:@"0%@",buttonStr];
		}
		for (NSString *str in self.vacationArr) {
			if ([str isEqualToString:buttonStr]) {
				
					button.backgroundColor = KPurpleColor;
					//					button.selected = YES;
					
					[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					
					
				} else {
					if ([str isEqualToString:buttonStr]) {
						button.backgroundColor = KNaviColor;
						button.selected = YES;
						[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					}
				}
			}
		if ([buttonStr isEqualToString:sender.titleLabel.text]) {
			button.backgroundColor = KNaviColor;
			button.selected = YES;
			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		}
		}
		
	}
	
	
	
	NSLog(@"%zd%zd%@",[self getCurrentYear:_currentDate],[self getCurrentMonth:_currentDate],sender.titleLabel.text);
	NSString *dateStr ;
//	if (self.selecTime.length > 0) {
//		dateStr =  [NSString stringWithFormat:@"%zd-%zd-%@",[self getCurrentYear:[self dateFormatterWithStr:[self.selecTime substringToIndex:10]] ],[self getCurrentMonth:[self dateFormatterWithStr:[self.selecTime substringToIndex:10]]],sender.titleLabel.text];
//	} else {
		dateStr = [NSString stringWithFormat:@"%zd-%zd-%@",[self getCurrentYear:_currentDate ],[self getCurrentMonth:_currentDate],sender.titleLabel.text];
//	}
	
	
	NSDate *date = [self dateFormatterWithStr:dateStr];
//	self.titleLable.text = [self stringFormatterWithDate:date];
	if (self.backSelectDateBlock) {
		self.backSelectDateBlock([self stringFormatterWithDate:date]);
	}
	if ([self.delegate respondsToSelector:@selector(calendarDidDateSelectedDate:)]) {
		[self.delegate calendarDidDateSelectedDate:[self stringFormatterWithDate:date]];
	}
	//休假排班
	if ([self.delegate respondsToSelector:@selector(calendarDateSelectedDate:andIsSelect:)]) {
		[self.delegate calendarDateSelectedDate:[self stringFormatterWithDate:date] andIsSelect:sender.isSelected];
	}
	NSLog(@"%@",date);
	
}

- (NSDate *)dateFormatterWithStr:(NSString *)str {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSDate *date = [dateFormatter dateFromString:str];
	return date;
}

- (NSString *)stringFormatterWithDate:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateFormatter.dateFormat = @"yyyy-MM-dd EEE";
	NSString *str = [dateFormatter stringFromDate:date];
	return str;
}

- (NSString *)getYMD:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateFormatter.dateFormat = @"yyyy-MM-dd";
	NSString *str = [dateFormatter stringFromDate:date];
	return str;
}

- (NSString *)getYM:(NSDate *)date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateFormatter.dateFormat = @"yyyy-MM";
	NSString *str = [dateFormatter stringFromDate:date];
	return str;
}



- (void)preBtnClick {
    
    NSDate *preDate = [self lastMonth:_currentDate];
    [self loadWithDate:preDate];
    
    [self setNeedsLayout];
    
    _currentDate = preDate;
    
}

- (void)nextBtnClick {
    
    NSDate *nextDate = [self nextMonth:_currentDate];
    [self loadWithDate:nextDate];
    
    [self setNeedsLayout];
    
    _currentDate = nextDate;
}

- (void)layoutSubviews {
    [super layoutSubviews];
	
//    self.titleLable.frame = CGRectMake(0, 0, self.width, 40);
	
    self.preBtn.size = CGSizeMake(40, 40);
    self.preBtn.x = 0;
    self.preBtn.y = 0;
    
    self.nextBtn.size = CGSizeMake(40, 40);
    self.nextBtn.y = 0;
    self.nextBtn.x = self.width - self.nextBtn.width;
    
    
    self.titleView.frame = CGRectMake(0, 0, self.width, 40);
    
    for (int i = 0; i < self.labelArray.count; i++) {
        UILabel *label = self.labelArray[i];
        label.width = self.width / 7;
        label.height = self.titleView.height;
        label.y = 0;
        label.x = i * label.width;
        
    }
    
    self.dateView.frame = CGRectMake(0, self.titleView.bottom, self.width,  self.height - self.titleView.bottom);
    
    // 计算有多少行
    NSInteger row = (_firstDays % 7 + _days + 6) / 7;
    
    NSInteger colum = 7;
    CGFloat buttonH = self.dateView.height / row;
    CGFloat buttonW = self.width / 7;
	NSDate *date = [NSDate date];
	NSString *ym = [self getYM:_currentDate];
	NSString *nowStr = [self getYMD:date];
    for (int i = 0; i < self.buttonArray.count; i++) {
		
        UIButton *button = self.buttonArray[i];
		NSString *dayStr = button.titleLabel.text;
		if ([button.titleLabel.text intValue] < 10) {
			dayStr = [NSString stringWithFormat:@"0%@",button.titleLabel.text];
		}
		if ([[NSString stringWithFormat:@"%@-%@",ym,dayStr] isEqualToString:nowStr]) {
			if (self.vacationModel == nil) {
				if (self.isNoNowDateLoop != YES) {
					button.layer.borderColor = KNaviColor.CGColor;
					button.layer.borderWidth = 1.f;
				}
			}
			
		}
        button.width = 25;
        button.height = 25;
        button.x = (_firstDays % 7 + i) % colum * buttonW + ((self.width / 7 - button.width) / 2);
        button.y = (_firstDays % 7 + i) / colum * buttonH;
		button.titleLabel.font = [UIFont systemFontOfSize:12.f];
		button.layer.cornerRadius =  button.width / 2;
		button.layer.masksToBounds = YES;
		UIView *dotView = self.dotArray[i];
		dotView.x = (_firstDays % 7 + i) % colum * buttonW + ((self.width / 7 - 4) / 2) ;
		dotView.centerY = button.centerY;
		dotView.y = CGRectGetMaxY(button.frame) + 2.5;
		dotView.size = CGSizeMake(4, 4);
		dotView.layer.cornerRadius = 2;
		dotView.layer.masksToBounds = YES;
		
    }
    
}
//圆点选中的是那哪个日期
- (void)setDotSelectArray:(NSArray *)dotSelectArray {
	_dotSelectArray = dotSelectArray;
//    for (int i = 0; i < self.buttonArray.count; i++) {
//        UIButton *button = self.buttonArray[i];
//		if ([button.titleLabel.text isEqualToString:@"2"]) {
//			button.backgroundColor = Color(0, 176, 160);
//			[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//			[self.preDayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//			self.preDayButton.backgroundColor = [UIColor clearColor];
//			self.preDayButton = button;
//		}
//        UIView *dotView = self.dotArray[i];
		for (NSString *dayStr in self.dotSelectArray) {
			NSString *str;
			if ([dayStr hasPrefix:@"0"]) {
				str = [dayStr substringFromIndex:1];
			} else {
				str = dayStr;
			}
            UIView *dotView = self.dotArray[str.intValue - 1];
            UIButton *button = self.buttonArray[str.intValue - 1];
//            if ([button.titleLabel.text isEqualToString:str]) {
				dotView.hidden = NO;
                
//            }
//            if ([self.buttonArray containsObject:button]) {
            if(![self.isNoSel isEqualToString:@"NO"]) {
                [button addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
            }

		}
    if (self.dotSelectArray.count > 0) {
        
        NSArray *result = [dotSelectArray sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString *  _Nonnull obj2) {
            
            NSLog(@"%@~%@",obj1,obj2); //3~4 2~1 3~1 3~2
            
            return [obj1 compare:obj2]; //升序
        }];
    
        NSString *ymstr = [self getYM:_currentDate];
        ymstr = [ymstr substringWithRange:NSMakeRange(5, 2)];
        NSString *selectTime = [self.selecTime substringWithRange:NSMakeRange(5, 2)];
        
        
        NSString *str;
        
        if ([dotSelectArray containsObject:self.selectNewDate] && [ymstr isEqualToString:selectTime]) {
            if ([self.selectNewDate hasPrefix:@"0"]) {
                str = [self.selectNewDate substringFromIndex:1];
            } else {
                str = self.selectNewDate;
            }
        } else {
            NSString *dataDay = result[0];
            if ([dataDay hasPrefix:@"0"]) {
                str = [dataDay substringFromIndex:1];
            } else {
                str = dataDay;
            }
        
        }
        
        UIButton *button = self.buttonArray[str.intValue - 1];
        
        [self dateSelect:button];
    }
    
//    }
}

- (void)setSelectNewDate:(NSString *)dateStr {
	_selectNewDate = dateStr;
//    for (int i = 0; i < self.buttonArray.count; i++) {
//        UIButton *button = self.buttonArray[i];
//        NSString *buttonStr = button.titleLabel.text;
//        if (buttonStr.intValue < 10) {
//            buttonStr = [NSString stringWithFormat:@"0%@",buttonStr];
//        }
//        if ([buttonStr isEqualToString:dateStr]) {
//            [self.preDayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//            self.preDayButton.backgroundColor = [UIColor clearColor];
//            if (![self.isNoSel isEqualToString:@"NO"]) {
//                button.backgroundColor = KNaviColor;
//                [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                self.preDayButton = button;
//            }
//            
//        }
//    }
}

- (void)setVacationArr:(NSArray *)vacationArr {
	_vacationArr = vacationArr;
	for (int i = 0; i < self.buttonArray.count; i++) {
		UIButton *button = self.buttonArray[i];
		NSString *buttonStr = button.titleLabel.text;
		if ([buttonStr intValue] < 10) {
			buttonStr = [NSString stringWithFormat:@"0%@",buttonStr];
		}
		for (NSString *str in vacationArr) {
			if ([str isEqualToString:buttonStr]) {
				if ([self.vcName isEqualToString:@"个人工作汇报"]) {
					button.backgroundColor = KPurpleColor;
					//					button.selected = YES;
					
					[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					
				
				} else {
					if ([str isEqualToString:buttonStr]) {
						button.backgroundColor = KNaviColor;
						button.selected = YES;
						[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
					}
				}
			}
			
		}
		if ([self.vcName isEqualToString:@"个人工作汇报"]) {
		if ([buttonStr isEqualToString:[self.selecTime substringWithRange:NSMakeRange(8, 2)]]) {
//            button.backgroundColor = KNaviColor;
//            button.selected = YES;
//            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		}
		}
	}
		
}

- (void)setSelecTime:(NSString *)selecTime {
	_selecTime = selecTime;
	_currentDate = [self dateFormatterWithStr:[self.selecTime substringToIndex:10]];
	[self loadWithDate:_currentDate];
}

- (void)setVacationModel:(MJKVacationModel *)vacationModel {
//	NSMutableArray *normalArr = [NSMutableArray array];
	_vacationModel = vacationModel;
	
	[self.preDayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	self.preDayButton.backgroundColor = [UIColor clearColor];
	self.preDayButton.layer.borderColor = [UIColor clearColor].CGColor;
	self.preDayButton.layer.borderWidth = 0;
	
	NSString *selectTime = [self.selecTime substringWithRange:NSMakeRange(8, 2)];
	for (UIButton *button in self.buttonArray) {
		NSString *buttonStr = button.titleLabel.text;
		if ([buttonStr intValue] < 10) {
			buttonStr = [NSString stringWithFormat:@"0%@",buttonStr];
		}
		
		for (MJKVacationContentModel *subModel in vacationModel.content) {
			//所有的考勤信息
			if ([buttonStr isEqualToString:subModel.DAYNUMBER]) {
				if ([subModel.C_STATUS_DD_NAME isEqualToString:@"正常出勤"]) {
					button.backgroundColor = KGreenColor;//KNaviColor;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"迟到早退"]) {
					button.backgroundColor = KBlueColor;//[UIColor redColor];
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"忘签退"]) {
					button.backgroundColor = KYellowColor;//KBlueColor;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"缺勤"]) {
					button.backgroundColor = KRedColor;//KGreenColor;
				} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"休假"]) {
					button.backgroundColor = KPurpleColor;
				}
			}
			//当天被选中的状态颜色
			if ([buttonStr isEqualToString:selectTime]) {
				if ([selectTime isEqualToString:subModel.DAYNUMBER]) {
					if ([subModel.C_STATUS_DD_NAME isEqualToString:@"正常出勤"]) {
						button.backgroundColor = [UIColor clearColor];
						[button setTitleColor:KGreenColor];
						button.layer.borderColor = KGreenColor.CGColor;
						button.layer.borderWidth = 1.f;
						self.preColor = KGreenColor;
						self.preDayButton = button;
					} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"迟到早退"]) {
						button.backgroundColor = [UIColor clearColor];
						[button setTitleColor:KBlueColor];
						button.layer.borderColor = KBlueColor.CGColor;
						button.layer.borderWidth = 1.f;
						self.preColor = KBlueColor;
						self.preDayButton = button;
					} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"忘签退"]) {
						button.backgroundColor = [UIColor clearColor];
						[button setTitleColor:KYellowColor];
						button.layer.borderColor = KYellowColor.CGColor;
						button.layer.borderWidth = 1.f;
						self.preColor = KYellowColor;
						self.preDayButton = button;
					} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"缺勤"]) {
						button.backgroundColor = [UIColor clearColor];
						[button setTitleColor:KRedColor];
						button.layer.borderColor = KRedColor.CGColor;
						button.layer.borderWidth = 1.f;
						self.preColor = KRedColor;
						self.preDayButton = button;
					} else if ([subModel.C_STATUS_DD_NAME isEqualToString:@"休假"]) {
						button.backgroundColor = [UIColor clearColor];
						[button setTitleColor:KPurpleColor];
						button.layer.borderColor = KPurpleColor.CGColor;
						button.layer.borderWidth = 1.f;
						self.preColor = KPurpleColor;
						self.preDayButton = button;
					}
				}
			}
			
			
		}
		
	}
	
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
