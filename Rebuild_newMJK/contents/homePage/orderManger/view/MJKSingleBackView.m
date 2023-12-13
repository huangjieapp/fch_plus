//
//  MJKSingleBackView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/22.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKSingleBackView.h"

#import "MJKDataDicModel.h"

@interface MJKSingleBackView ()< UIPickerViewDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray *failChooseArray;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bgViewLayout;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *remarkStr;

@property (nonatomic, copy) void(^reasonBlock)(NSString *typeStr, NSString *timerStr, NSString *remarkStr);
@end

@implementation MJKSingleBackView

- (instancetype)initWithFrame:(CGRect)frame andReasonBlock:(void(^)(NSString *type, NSString *timeStr, NSString *Remark))reasonBlock {
	if (self = [super initWithFrame:frame]) {
		self=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MJKSingleBackView class]) owner:self options:nil] lastObject];
		[self setCloseView];
		[self datePicker];
		[self typeView];
		self.remarkTextField.delegate = self;
		[self.remarkTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
		self.reasonBlock = reasonBlock;
	}
	return self;
}

- (void)setCloseView {
	UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
	[self addGestureRecognizer:tapGR];
}

- (void)datePicker {
//	UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
//	view.backgroundColor=[UIColor whiteColor];
	UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 218)];
	Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
	Picker.datePickerMode = UIDatePickerModeDateAndTime;
	
	NSDate *Date = [NSDate date];
	NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
    birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	
	
	
	[Picker setDate:Date animated:YES];
	
	self.timeTextField.text = [birthformatter stringFromDate:Date];
	self.timeStr = [birthformatter stringFromDate:Date];
	self.timeTextField.inputView = Picker;
	[Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
//	[view addSubview:Picker];
}

- (void)showDate:(UIDatePicker *)datePicker
{
	
	NSDate *date = datePicker.date;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
	NSString *outputString = [formatter stringFromDate:date];
	self.timeTextField.text = outputString;
	self.timeStr = outputString;
	
}

- (void)typeView {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"name"] = @"请选择退单原因类型";
	dict[@"id"] = @"";
	[self.failChooseArray addObject:dict];
	for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42000_C_CANCELREMARK"] ) {
		NSMutableDictionary *dic = [NSMutableDictionary dictionary];
		dic[@"name"] = model.C_NAME;
		dic[@"id"] = model.C_VOUCHERID;
		[self.failChooseArray addObject:dic];
	}
	UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 218)];
	pickerView.delegate = self;
	self.typeTextField.inputView = pickerView;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return self.failChooseArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return self.failChooseArray[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	self.typeTextField.text = self.failChooseArray[row][@"name"];
	self.typeStr = self.failChooseArray[row][@"id"];
}

- (IBAction)cancelAction:(UIButton *)sender {
	[self removeFromSuperview];
}
- (IBAction)trueAction:(UIButton *)sender {
	if (self.timeStr.length <= 0) {
		[JRToast showWithText:@"请选择时间"];
		return;
	}
	if (self.typeStr.length <= 0) {
		[JRToast showWithText:@"请选择退单类型"];
		return;
	}
	if (self.remarkStr.length <= 0) {
		[JRToast showWithText:@"请填写退单备注"];
		return;
	}
	if (self.reasonBlock) {
		self.reasonBlock(self.typeStr, self.timeStr, self.remarkStr);
	}
	[self removeFromSuperview];
}

- (void)closeView {
	[self removeFromSuperview];
}

- (void)layoutSubviews{
	
	self.width=KScreenWidth;
	self.height=KScreenHeight;
	
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == self.remarkTextField) {
		self.bgViewLayout.constant = -90;
	}
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == self.remarkTextField) {
		self.bgViewLayout.constant = 0;
	}
}

- (void)textChange:(UITextField *)textField {
	if (textField == self.remarkTextField) {
		self.remarkStr = textField.text;
	}
}

- (NSMutableArray *)failChooseArray {
	if (!_failChooseArray) {
		_failChooseArray = [NSMutableArray array];
	}
	return _failChooseArray;
}


@end
