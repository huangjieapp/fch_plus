//
//  MJKDateViewPicker.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/17.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKDateViewPicker.h"

@implementation MJKDateViewPicker

- (instancetype)initWithFrame:(CGRect)frame withStart:(STARTBLOCK)start withEnd:(ENDBLOCK)end withSure:(SUREBLOCK)sure{
	if (self=[super initWithFrame:frame]) {
		
		self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MJKDateViewPicker class]) owner:self options:nil] lastObject];
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
	self.startStr=[DBTools getYearMonthDayTime];
	[self.startTimeBtn setTitleNormal:self.startStr];
	
	[self datePickerAndMethod:111];
	//    [self removeFromSuperview];
}
- (void)endClick{
	
	if (self.endB) {
		self.endB();
	}
	self.endStr=[DBTools getYearMonthDayTime];
	[self.endTimeBtn setTitleNormal:self.endStr];
	
	[self datePickerAndMethod:222];
	
}
- (void)uploadClick{
	if (!self.startStr||!self.endStr) {
		[JRToast showWithText:@"必须选择两个时间才能确定"];
		return;
	}
	NSDate*startDate=[DBTools TimeGetDateStr:self.startStr andFormatterType:@"yyyy-MM-dd"];
	NSDate*endDate=[DBTools TimeGetDateStr:self.endStr andFormatterType:@"yyyy-MM-dd"];
	if (startDate>endDate) {
		[JRToast showWithText:@"开始时间不能大于结束时间"];
		return;
	}
	
	
	
	
	
	
	if (self.sureB) {
		self.sureB(self.startStr, self.endStr);
	}
	[self removeFromSuperview];
	
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
	Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
	Picker.datePickerMode = UIDatePickerModeDate;
	Picker.tag=100;
	
	NSDate *Date = [NSDate date];
	NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	birthformatter.dateFormat = @"yyyy-MM-dd";
	
	
	
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
	formatter.dateFormat = @"yyyy-MM-dd";
	NSString *outputString = [formatter stringFromDate:date];
	
	if (datePicker.tag==111) {
		self.startStr=outputString;
		[self.startTimeBtn setTitleNormal:self.startStr];
	}
	if (datePicker.tag==222) {
		self.endStr=outputString;
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
