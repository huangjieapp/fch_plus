//
//  CGCCustomDateView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKNewSelectHourView.h"
#import "DBPickerView.h"
#import "LYSDatePickerController.h"


@interface MJKNewSelectHourView ()<LYSDatePickerSelectDelegate>
@end

@implementation MJKNewSelectHourView

- (void)setStartStr:(NSString *)startStr {
    _startStr = startStr;
    [self.startTimeBtn setTitleNormal:startStr];
}

-(void)setEndStr:(NSString *)endStr {
    _endStr = endStr;
    [self.endTimeBtn setTitleNormal:endStr];
}

- (void)setHourStr:(NSString *)hourStr {
    _hourStr = hourStr;
    [self.hourBtn setTitleNormal:hourStr];
}

- (instancetype)initWithFrame:(CGRect)frame withStart:(STARTBLOCK)start withEnd:(ENDBLOCK)end withHour:(HOURLOCK)hour withSure:(SUREBLOCK)sure{
    if (self=[super initWithFrame:frame]) {
        
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MJKNewSelectHourView class]) owner:self options:nil] lastObject];
        self.startB = start;
        self.endB = end;
        self.hourB = hour;
        self.sureB = sure;
        
        [self.startTimeBtn addTarget:self action:@selector(sClick)];
        [self.endTimeBtn addTarget:self action:@selector(endClick)];
        [self.hourBtn addTarget:self action:@selector(hourClick)];
        [self.showBtn addTarget:self action:@selector(uploadClick)];
        
        [self.canelBtn addTarget:self action:@selector(removeView)];
        [self.bgBtn addTarget:self action:@selector(removeView)];
        
        
    }
    
    return self;
    
    
}
- (void)removeView{
    if (self.clickCancelBlock) {
        self.clickCancelBlock();
    }
    
    
    [self removeFromSuperview];
    
}

- (void)sClick{
    DBSelf(weakSelf);
    if (self.startB) {
        self.startB();
    }
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDate = [dateFormat stringFromDate:[NSDate date]];
    NSString *selectStr = [currentDate substringFromIndex:11];
    NSString *ymd = [currentDate substringToIndex:10];
    
    if (self.startStr.length <= 0) {
        self.startStr=selectStr;
        [self.startTimeBtn setTitleNormal:self.startStr];
    }
    
    LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
    datePicker.headerView.backgroundColor = [UIColor whiteColor];;
    datePicker.indicatorHeight = 0;
    datePicker.selectDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",ymd,self.startStr]];
    datePicker.delegate = self;
    datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
    datePicker.headerView.leftItem.textColor = [UIColor whiteColor];
    datePicker.headerView.rightItem.textColor = [UIColor whiteColor];
    datePicker.pickHeaderHeight = 40;
    datePicker.pickType = LYSDatePickerTypeTime;
    datePicker.minuteLoop = YES;
    datePicker.headerView.titleDateFormat = @"HH:mm";
    datePicker.headerView.showTimeLabel = YES;
    datePicker.headerView.leftItem.textColor = [UIColor blackColor];
    datePicker.headerView.rightItem.textColor = [UIColor blackColor];
    datePicker.weakDayType = LYSDatePickerWeakDayTypeUSDefault;
    datePicker.showWeakDay = YES;
    [datePicker setDidSelectDatePicker:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *currentDate = [dateFormat stringFromDate:date];
        weakSelf.startStr = currentDate;
        [weakSelf.startTimeBtn setTitleNormal:self.startStr];
        //        [weakSelf selectTimeShowBack:currentDate];
    }];
    [datePicker showDatePickerWithController:self.rootVC];
//    [self datePickerAndMethod:111];
    //    [self removeFromSuperview];
}
- (void)endClick{
    DBSelf(weakSelf);
    if (self.endB) {
        self.endB();
    }
//    if (self.endStr.length <= 0) {
//        self.endStr=[[[DBTools getTimeFomatFromCurrentTimeStamp] substringWithRange:NSMakeRange(11, 2)]stringByAppendingString:@":00" ];
//        [self.endTimeBtn setTitleNormal:self.endStr];
//    }
    
    
//    [self datePickerAndMethod:222];
//    NSMutableArray *timeArray = [NSMutableArray array];
//    for (int i = 0; i < 24; i++) {
//        if (i < 10) {
//            [timeArray addObject:[NSString stringWithFormat:@"0%d",i]];;
//        } else {
//            [timeArray addObject:[NSString stringWithFormat:@"%d",i]];
//        }
//    }
//        [self datePickerAndMethod:111];
//    DBPickerView *pickView = [[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:timeArray andSelectStr:[self.endStr substringToIndex:2] andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
//        weakSelf.endStr=[title stringByAppendingString:@":00" ];
//        [weakSelf.endTimeBtn setTitleNormal:weakSelf.endStr];
//    }];
//    [[UIApplication sharedApplication].keyWindow addSubview:pickView];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *currentDate = [dateFormat stringFromDate:[NSDate date]];
    NSString *selectStr = [currentDate substringFromIndex:11];
    NSString *ymd = [currentDate substringToIndex:10];
    
    if (self.endStr.length <= 0) {
        self.endStr=selectStr;
        [self.endTimeBtn setTitleNormal:self.endStr];
    }
    
    LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
    datePicker.headerView.backgroundColor = [UIColor whiteColor];;
    datePicker.indicatorHeight = 0;
    datePicker.selectDate = [dateFormat dateFromString:[NSString stringWithFormat:@"%@ %@",ymd,self.endStr]];
    datePicker.delegate = self;
    datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
    datePicker.headerView.leftItem.textColor = [UIColor whiteColor];
    datePicker.headerView.rightItem.textColor = [UIColor whiteColor];
    datePicker.pickHeaderHeight = 40;
    datePicker.pickType = LYSDatePickerTypeTime;
    datePicker.minuteLoop = YES;
    datePicker.headerView.titleDateFormat = @"HH:mm";
    datePicker.headerView.showTimeLabel = YES;
    datePicker.headerView.leftItem.textColor = [UIColor blackColor];
    datePicker.headerView.rightItem.textColor = [UIColor blackColor];
    datePicker.weakDayType = LYSDatePickerWeakDayTypeUSDefault;
    datePicker.showWeakDay = YES;
    [datePicker setDidSelectDatePicker:^(NSDate *date) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormat setDateFormat:@"HH:mm"];
        NSString *currentDate = [dateFormat stringFromDate:date];
        weakSelf.endStr = currentDate;
        [weakSelf.endTimeBtn setTitleNormal:self.endStr];
//        [weakSelf selectTimeShowBack:currentDate];
    }];
    [datePicker showDatePickerWithController:self.rootVC];
    
}

- (void)hourClick {
    DBSelf(weakSelf);
    if (self.hourB) {
        self.hourB();
    }
    
    NSMutableArray *timeArray = [NSMutableArray array];
    for (int i = 2; i <= 5; i++) {
        [timeArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    DBPickerView *pickView = [[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:timeArray andSelectStr:[self.endStr substringToIndex:2] andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
        weakSelf.hourStr = title;
        [weakSelf.hourBtn setTitleNormal:self.hourStr];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:pickView];

}


- (void)uploadClick{
    if (self.canFirstOneSave==NO) {
        if (!self.startStr||!self.endStr) {
            [JRToast showWithText:@"必须选择两个时间才能确定"];
            return;
        }
        
        
    }else{
        if (!self.startStr) {
            [JRToast showWithText:@"必须选择第一个时间才能确定"];
            return;
        }
        
        
    }
    
    NSInteger result = [self compareDate:self.startStr withDate:self.endStr];
    if (!self.canFirstOneSave&&result == -1) {
        [JRToast showWithText:@"开始时间不能大于等于结束时间"];
        return;
    }
    
    
    
    
    
    
    if (self.sureB) {
        self.sureB(self.startStr, self.endStr, self.hourStr);
    }
    [self removeFromSuperview];
    
}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    dateformater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateformater setDateFormat:@"HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result==NSOrderedSame)
    {
        aa=0;
    }else if (result==NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}







- (void)dissmissPicker{
    
    [self.pickerBtn removeFromSuperview];
}

- (void)layoutSubviews{
    
    self.width=KScreenWidth;
    self.height=KScreenHeight;
    
}

@end
