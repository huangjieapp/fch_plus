//
//  DateViewWithHourMonth.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "DateViewWithHourMinute.h"

@interface DateViewWithHourMinute ()<UIPickerViewDelegate, UIPickerViewDataSource>
/** 分*/
@property (nonatomic, strong)NSMutableArray *minuteArray;
/** 时*/
@property (nonatomic, strong) NSMutableArray *hourArray;
/** 选择的时间*/
@property (nonatomic, strong) NSString *hourStr;
/** 选择的时间*/
@property (nonatomic, strong) NSString *minuteStr;
/** 选择的时间*/
@property (nonatomic, strong) NSString *amorpmStr;
/**12 or 24 小时制*/
@property (nonatomic, assign) NSInteger hourMode;
@end

@implementation DateViewWithHourMinute

- (instancetype)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		[self configUI];
	}
	return self;
}

- (void)configUI {
	self.hourMode = [self checkDateSetting24Hours] == YES ? 24 : 12;
	
	UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	view.backgroundColor = KColorGrayBGView;
	[self addSubview:view];
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 70, 0, 60, view.frame.size.height)];
	[button setTitleNormal:@"完成"];
	[button setTitleColor:RGBA(0, 122, 255, 1)];
	button.titleLabel.font = [UIFont systemFontOfSize:13.f];
	[button addTarget:self action:@selector(buttonClick:)];
	[view addSubview:button];
	
	UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, view.frame.size.height)];
	[cancelButton setTitleNormal:@"取消"];
	[cancelButton setTitleColor:RGBA(0, 122, 255, 1)];
	cancelButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
	[cancelButton addTarget:self action:@selector(buttonClick:)];
	[view addSubview:cancelButton];
	
	UIPickerView *pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(view.frame), KScreenWidth, self.frame.size.height - view.size.height)];
	pickView.delegate = self;
	[self addSubview:pickView];
}

#pragma mark - buttonClick
- (void)buttonClick:(UIButton *)sender {
	//没有选择默认情况下
	if ([sender.titleLabel.text isEqualToString:@"完成"]) {
	
		if (self.hourStr.length <= 0) {
			self.hourStr = self.hourArray[0];
		}
		if ([self.amorpmStr isEqualToString:@"下午"]) {
			self.hourStr = [NSString stringWithFormat:@"%ld",[self.hourStr integerValue] + 12];
			if ([self.hourStr isEqualToString:@"24"]) {
				self.hourStr = @"0";
			}
		}
		
		
		if (self.minuteStr.length <= 0) {
			self.minuteStr = self.minuteArray[0];
		}
		NSString *timeStr = [NSString stringWithFormat:@"%@:%@",self.hourStr, self.minuteStr];
		if ([self.delegate respondsToSelector:@selector(selectTimeBack:)]) {
			[self.delegate selectTimeBack:timeStr];
		}
	} else {
		
	}
	[self removeFromSuperview];
}

- (NSDate *)dateFormatter:(NSString *)timeStr {
	NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    dateF.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateF.dateFormat = @"HH:mm";
	return [dateF dateFromString:timeStr];
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	if (self.hourMode == 12) {
		return 3;
	} else {
		return 2;
	}
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (self.hourMode == 12) {
		if (component == 0) {
			return 2;
		} else if (component == 1) {
			return self.hourArray.count;
		} else {
			return self.minuteArray.count;
		}
	} else {
		if (component == 0) {
			return self.hourArray.count;
		} else {
			return self.minuteArray.count;
		}
	}
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (self.hourMode == 12) {
		if (component == 0) {
			return @[@"上午",@"下午"][row];
		} else if (component == 1) {
			return self.hourArray[row];
		} else {
			return self.minuteArray[row];
		}
	} else {
		if (component == 0) {
			return self.hourArray[row];
		} else {
			return self.minuteArray[row];
		}
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (self.hourMode == 12) {
		if (component == 0) {
			self.amorpmStr = @[@"上午",@"下午"][row];
		} else if (component == 1) {
			self.hourStr = self.hourArray[row];
		} else {
			self.minuteStr = self.minuteArray[row];
		}
	} else {
		if (component == 0) {
			self.hourStr = self.hourArray[row];
		} else {
			self.minuteStr = self.minuteArray[row];
		}
	}
}

#pragma mark - 检测小时制
- (BOOL)checkDateSetting24Hours{
	BOOL is24Hours = YES;
	NSString *dateStr = [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]];
	NSArray  *sysbols = @[[[NSCalendar currentCalendar] AMSymbol],[[NSCalendar currentCalendar] PMSymbol]];
	for (NSString *symbol in sysbols) {
		if ([dateStr rangeOfString:symbol].location != NSNotFound) {//find
			is24Hours = NO;
			break;
		}
	}
	return is24Hours;
}

#pragma mark - set
- (NSMutableArray *)hourArray {
	if (!_hourArray) {
		_hourArray = [NSMutableArray array];
		for (int i = 0; i < self.hourMode; i++) {
//			if (i < 10) {
//				[_hourArray addObject:[NSString stringWithFormat:@"0%d",i]];
//			} else {
				[_hourArray addObject:[NSString stringWithFormat:@"%d",self.hourMode == 12 ? i + 1 : i]];
//			};
		}
		
	}
	return _hourArray;
}

- (NSMutableArray *)minuteArray {
	if (!_minuteArray) {
		_minuteArray = [NSMutableArray array];
		for (int i = 0; i < 60; i++) {
			if (i < 10) {
				[_minuteArray addObject:[NSString stringWithFormat:@"0%d",i]];
			} else {
				[_minuteArray addObject:[NSString stringWithFormat:@"%d",i]];
			}
		}
	}
	return _minuteArray;
}

@end
