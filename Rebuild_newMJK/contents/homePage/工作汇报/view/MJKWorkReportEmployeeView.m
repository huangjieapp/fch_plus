//
//  MJKWorkReportEmployeeView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKWorkReportEmployeeView.h"
#import "LTSCalendarDayView.h"
#import "LTSCalendarContentView.h"

#import "LTSCalendarEventSource.h"
#import "LTSCalendarMonthView.h"
#import "LTSCalendarWeekView.h"

#import "CalendarView.h"

@interface MJKWorkReportEmployeeView ()<CalendarViewDelegate>{
	NSMutableDictionary *eventsByDate;
}
@property (nonatomic,strong) UIView *headerView;
// 手指触摸 开始滚动 tableView 的offectY
@property (nonatomic,assign)CGFloat dragStartOffectY;
// 手指离开 屏幕 tableView 的offectY
@property (nonatomic,assign)CGFloat dragEndOffectY;
/** CalendarView*/
@property (nonatomic, strong) CalendarView *calendar;
@end

@implementation MJKWorkReportEmployeeView

- (void)awakeFromNib {
	[super awakeFromNib];
	self.headImageView.layer.cornerRadius = 5;
	self.headImageView.layer.masksToBounds = YES;
	[self initUI];
	
}

- (CalendarView *)calendar {
	if (!_calendar) {
		
		_calendar = [[CalendarView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 220) andIsNoSel:@"YES"];
		_calendar.delegate = self;
		_calendar.isNoNowDateLoop = YES;
	}
	return _calendar;
}

#pragma mark - CalendarViewDelegate
- (void)slidingCalendar:(NSString *)date andDirection:(UISwipeGestureRecognizerDirection)direction {
	self.timeLabel.text = date;
	if (self.dateBlock) {
		self.dateBlock(date);
	}
}

- (void)calendarDidDateSelectedDate:(NSString *)date {
	if (self.didSelectDateBlock) {
		self.didSelectDateBlock(date);
	}
	self.timeLabel.text = date;
}

- (void)setCreateTime:(NSString *)createTime {
	_createTime = createTime;
	self.calendar.selecTime = createTime;
	if (createTime.length > 0) {
		NSString *str = [createTime substringWithRange:NSMakeRange(8, 2)];
		self.calendar.selectNewDate = str;
	}
	
	self.timeLabel.text = [[self dateFormatter] stringFromDate:[[self dateFormatter1] dateFromString:self.createTime ] ];
}

- (void)initUI {
	[self.calendarView addSubview:self.calendar];
}

- (NSDateFormatter *)dateFormatter
{
	static NSDateFormatter *dateFormatter;
	if(!dateFormatter){
		dateFormatter = [NSDateFormatter new];
		dateFormatter.dateFormat = @"yyyy-MM-dd EEE";
	}

	return dateFormatter;
}

- (NSDateFormatter *)dateFormatter1
{
	static NSDateFormatter *dateFormatter1;
	if(!dateFormatter1){
		dateFormatter1 = [NSDateFormatter new];
		dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	}

	return dateFormatter1;
}

- (void)setDotArray:(NSArray *)dotArray {
	_dotArray = dotArray;
	self.calendar.dotSelectArray = dotArray;
}
//
- (void)setModel:(MJKWorkReportListModel *)model {
	_model = model;
    if (model.C_ID.length <= 0) {
        self.noReportView.hidden = NO;
    } else {
        self.noReportView.hidden = YES;
    }
    
	[self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_HEADIMGURL] placeholderImage:[UIImage imageNamed:@"logo-images"]];
	self.nameLabel.text = model.USERNAME;
    if (model.D_LASTUPDATE_TIME.length > 0) {
//        self.addressLaebl.hidden = NO;
        self.addressLaebl.textColor = [UIColor grayColor];
        self.addressLaebl.text = [NSString stringWithFormat:@"日报更新于%@",model.D_LASTUPDATE_TIME];
    }
	NSString *selectDate;
	if (self.timeLabel.text.length > 10) {
		selectDate = [self.timeLabel.text substringToIndex:10];
	}
	NSString *createDate;
	if (self.createTime.length > 10) {
		 createDate = [self.createTime substringToIndex:10];
	}
	NSDate *nowDate = [NSDate date];
	NSString *nowDateStr = [[[self dateFormatter] stringFromDate:nowDate] substringToIndex:10];
	
	
	//编辑按钮是本人并且是选中的天
	if ([self.model.USERID isEqualToString:[NewUserSession instance].user.u051Id] && [selectDate isEqualToString:nowDateStr]) {
		self.editButton.hidden = NO;
	} else {
		self.editButton.hidden = YES;
	}
}

- (IBAction)editButtonAction:(UIButton *)sender {
	if (self.editBlock) {
		self.editBlock();
	}
}

- (void)setVacationArr:(NSArray *)vacationArr {
	_vacationArr = vacationArr;
	self.calendar.vcName = self.vcName;
	self.calendar.vacationArr = vacationArr;
}
@end
