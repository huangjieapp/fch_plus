//
//  CalendarView.h
//  日历
//
//  Created by apple on 2017/12/28.
//  Copyright © 2017年 HEJJY. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKVacationModel.h"

@protocol CalendarViewDelegate <NSObject>

@optional
- (void)slidingCalendar:(NSString *)date andDirection:(UISwipeGestureRecognizerDirection)direction;
/**选中的日期*/
- (void)calendarDidDateSelectedDate:(NSString *)date;
/**选中的日期*/
- (void)calendarDateSelectedDate:(NSString *)date andIsSelect:(BOOL)isSelect;

@end


@interface CalendarView : UIView
/** 当前天不需要圈圈*/
@property (nonatomic, assign) BOOL isNoNowDateLoop;
/** 不可滑动*/
@property (nonatomic, assign) BOOL noScroll;
/** MJKVacationModel 休假详情model*/
@property (nonatomic, strong) MJKVacationModel *vacationModel;
/** 那个页面过来的*/
@property (nonatomic, strong) NSString *vcName;
@property (nonatomic, strong) NSMutableArray *buttonArray;
/** 日期事件*/
@property (nonatomic, strong) NSArray *dotSelectArray;
/** 返回时间*/
@property (nonatomic, copy) void(^backSelectDateBlock)(NSString *date);
@property (nonatomic, strong)NSString *selectNewDate;
/** 休假日期*/
@property (nonatomic, strong)NSArray *vacationArr;
@property (nonatomic, weak) id<CalendarViewDelegate> delegate;
/** 上一个月和下一个月*/
@property (nonatomic, strong) NSString *nextOrPreMonth;
/** 不需要取消上一个选择的button*/
@property (nonatomic, strong) NSString *isNoSel;
/** 选择的时间*/
@property (nonatomic, strong) NSString *selecTime;
- (instancetype)initWithFrame:(CGRect)frame andIsNoSel:(NSString *)isNo;
@end
