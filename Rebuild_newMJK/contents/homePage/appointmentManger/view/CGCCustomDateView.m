//
//  CGCCustomDateView.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCCustomDateView.h"



@implementation CGCCustomDateView




- (instancetype)initWithFrame:(CGRect)frame withStart:(STARTBLOCK)start withEnd:(ENDBLOCK)end withSure:(SUREBLOCK)sure{
    if (self=[super initWithFrame:frame]) {
        
        self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCCustomDateView class]) owner:self options:nil] lastObject];
        self.startB = start;
        self.endB = end;
        self.sureB = sure;
        [self.startTimeBtn addTarget:self action:@selector(sClick)];
        [self.endTimeBtn addTarget:self action:@selector(endClick)];
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

    if (self.startB) {
        self.startB();
    }
    self.startStr=[DBTools getTimeFomatFromCurrentTimeStamp];
    if (self.startStr.length > 0) {
        self.startStr = [self.startStr substringToIndex:10];
    }
    [self.startTimeBtn setTitleNormal:self.startStr];
  
    [self datePickerAndMethod:111];
//    [self removeFromSuperview];
}
- (void)endClick{
    
    if (self.endB) {
        self.endB();
    }
     self.endStr=[DBTools getTimeFomatFromCurrentTimeStamp];
    if (self.endStr.length > 0) {
        self.endStr = [self.endStr substringToIndex:10];
    }
     [self.endTimeBtn setTitleNormal:self.endStr];
    
    [self datePickerAndMethod:222];

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
    
    NSDate*startDate=[DBTools TimeGetDateStr:self.startStr andFormatterType:@"yyyy-MM-dd HH:mm:ss"];
    NSDate*endDate=[DBTools TimeGetDateStr:self.endStr andFormatterType:@"yyyy-MM-dd HH:mm:ss"];
	NSInteger result = [self compareDate:self.startStr withDate:self.endStr];
    if (!self.canFirstOneSave&&result == -1) {
        [JRToast showWithText:@"开始时间不能大于等于结束时间"];
        return;
    }
   
    
    
    
    
    
    if (self.sureB) {
        self.sureB(self.startStr, self.endStr);
    }
    [self removeFromSuperview];

}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
	NSInteger aa = 0;
	NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    dateformater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
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


- (void)datePickerAndMethod:(NSInteger)index
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.bounds;
    [btn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
//    if (self.isNoHMS == YES) {
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
        Picker.datePickerMode = UIDatePickerModeDate;
//    } else {
//        Picker.datePickerMode = UIDatePickerModeDateAndTime;
//    }
    Picker.tag=100;
    
    NSDate *Date = [NSDate date];
    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    
    [Picker setDate:Date animated:YES];
    Picker.tag=index;
    [Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:Picker];
    [self.pickerBtn addSubview:view];
    [self.window addSubview:self.pickerBtn];
    
    
    
}

- (void)showDate:(UIDatePicker *)datePicker
{
    
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *outputString = [formatter stringFromDate:date];
    
   
   
    if (datePicker.tag==111) {
        self.startStr=outputString;
        if (self.startStr.length > 10) {
            self.startStr = [self.startStr substringToIndex:10];
        }
        [self.startTimeBtn setTitleNormal:self.startStr];
    }
    if (datePicker.tag==222) {
        self.endStr=outputString;
        if (self.endStr.length > 10) {
            self.endStr = [self.endStr substringToIndex:10];
        }
        [self.endTimeBtn setTitleNormal:self.endStr];

    }
    
}

- (void)dissmissPicker{
    
    [self.pickerBtn removeFromSuperview];
}

- (void)layoutSubviews{

    self.width=KScreenWidth;
    self.height=KScreenHeight;

}

@end
