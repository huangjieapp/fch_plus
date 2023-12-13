//
//  MJKMarketPickerView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKMarketPickerView.h"

@interface MJKMarketPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *backgroundView;
@property(nonatomic,strong)UIView*mainView;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *code;

@end

@implementation MJKMarketPickerView

- (void)popPickerView {
	[self addSubview:self.backgroundView];
    [self addSubview:self.mainView];
	if (self.style == PickerViewDateStyle) {
		[self addSubview:self.datePicker];
	} else {
		[self addSubview:self.pickerView];
	}
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	if (self.modelArray.count > 0) {
		return self.modelArray.count;
	} else {
		return self.dataArray.count;
	}
	
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	if (self.modelArray.count > 0) {
		return  self.modelArray[row].C_NAME;
	} else {
		return self.dataArray[row];
	}
	
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	if (self.modelArray.count > 0) {
		self.name = self.modelArray[row].C_NAME;
		self.code = self.modelArray[row].C_VOUCHERID;
	} else {
		self.name = self.dataArray[row];
		if ([self.name isEqualToString:@"开启"]) {
			self.code = @"0";
		} else {
			self.code = @"1";
		}
	}
}

#pragma mark - 点击事件
-(void)clickCancelBtn{
     [self removeFromSuperview];
    
}

-(void)clickSureBtn{
    if (self.selectTextBlock) {
        
        if (self.dataArray.count > 0 || self.modelArray.count > 0) {
            if (self.code.length <= 0) {
                self.name = self.modelArray[0].C_NAME;
                self.code = self.modelArray[0].C_VOUCHERID;
            }
            self.selectTextBlock(self.name, self.code);
        } else {
            NSDate *selected = self.datePicker.date;
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *destDateString = [dateFormatter stringFromDate:selected];
            self.selectTextBlock(destDateString , @"");
        }
        
    }
    [self removeFromSuperview];
    
}


- (void)dateChanged:(UIDatePicker *)datePicker {
	
}

- (void)closePickerView:(UIGestureRecognizer *)sender {
	 [self removeFromSuperview];
}

#pragma mark - set
- (UIView *)backgroundView {
	if (!_backgroundView) {
		_backgroundView = [[UIView alloc]initWithFrame:self.frame];
		_backgroundView.backgroundColor = [UIColor blackColor];
		_backgroundView.alpha = 0.5;
		[self addSubview:_backgroundView];
		UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closePickerView:)];
		[_backgroundView addGestureRecognizer:tapGR];
	}
	return _backgroundView;
}

-(UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 240, KScreenWidth, 240)];
        _mainView.backgroundColor=[UIColor whiteColor];
        
        UIButton*cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(5, 5, 45, 30)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor blackColor]];
        [cancelButton addTarget:self action:@selector(clickCancelBtn)];
        [_mainView addSubview:cancelButton];
        
        UIButton*sureButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-5-45, 5, 45, 30)];
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor blackColor]];
        [sureButton addTarget:self action:@selector(clickSureBtn)];
        [_mainView addSubview:sureButton];
        
    }
    return _mainView;
}


- (UIDatePicker *)datePicker {
	if (!_datePicker) {
		_datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, KScreenHeight - 200, KScreenWidth, 200)];
		_datePicker.datePickerMode = UIDatePickerModeDateAndTime;
		NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
        if (@available(iOS 13.4, *)) {
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
		_datePicker.locale = locale;
		_datePicker.backgroundColor = [UIColor whiteColor];
		[_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	}
	return _datePicker;
}

- (UIPickerView *)pickerView {
	if (!_pickerView) {
		_pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 200, KScreenWidth, 200)];
		_pickerView.backgroundColor = [UIColor whiteColor];
		_pickerView.delegate = self;
	}
	return _pickerView;
}

//- (void)setDataArray:(NSArray *)dataArray {
//	_dataArray = dataArray;
//	[self.pickerView reloadAllComponents];
//}

@end
