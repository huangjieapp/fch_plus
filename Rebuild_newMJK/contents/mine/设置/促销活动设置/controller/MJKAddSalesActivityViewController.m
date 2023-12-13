//
//  MJKAddSalesActivityViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/10.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddSalesActivityViewController.h"

#import "DBPickerView.h"

#import "MJKMarketSetDetailModel.h"

@interface MJKAddSalesActivityViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *activityNameTF;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTF;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTF;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
/** 开始时间*/
@property (nonatomic, strong) NSString *startTime;
/** 结束时间*/
@property (nonatomic, strong) NSString *endTime;
/** 活动名称*/
@property (nonatomic, strong) NSString *activityName;
/** MJKMarketSetDetailModel*/
@property (nonatomic, strong) MJKMarketSetDetailModel *model;
@end

@implementation MJKAddSalesActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
	
	if (self.salesActivityType == SalesActivityAdd) {
		self.title = @"促销活动新增";
		self.model = [[MJKMarketSetDetailModel alloc]init];
	} else {
		self.title = @"促销活动修改";
		[self HTTPGetMarkDatas];
	}
	
	[self.activityNameTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
	[self.startTimeTF addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventEditingDidBegin];
	self.startTimeTF.inputView = [[UIView alloc]init];
	[self.endTimeTF addTarget:self action:@selector(pickerView:) forControlEvents:UIControlEventEditingDidBegin];
	self.endTimeTF.inputView = [[UIView alloc]init];
	self.startTimeTF.tintColor = self.endTimeTF.tintColor = [UIColor clearColor];
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//	[self pickerView:textField];
//}

- (void)pickerView:(UITextField *)textField {
	DBSelf(weakSelf);
	DBPickerView *pickerView = [[DBPickerView alloc]initWithFrame:self.view.frame andCurrentType:PickViewTypeBirthday andmtArrayDatas:nil andSelectStr:nil andTitleStr:textField == self.startTimeTF ? @"开始时间" : @"结束时间" andBlock:^(NSString *title, NSString *indexStr) {
		if (textField == self.startTimeTF) {
			weakSelf.model.D_START_TIME = title;
			weakSelf.startTimeTF.text = [NSString stringWithFormat:@"%@>",title];
		} else {
			weakSelf.model.D_END_TIME = title;
			weakSelf.endTimeTF.text = [NSString stringWithFormat:@"%@>",title];
		}
		
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:pickerView];
	pickerView.cancelBlock = ^{
		[weakSelf.startTimeTF resignFirstResponder];
		[weakSelf.endTimeTF resignFirstResponder];
	};
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
	self.model.X_REMARK = textView.text;
}

- (void)changeText:(UITextField *)textField {
	self.model.C_NAME = textField.text;
}

- (IBAction)submitButtonAction:(id)sender {
	if (self.model.C_NAME.length <= 0) {
		[JRToast showWithText:@"请输入活动名称"];
		return;
	}
	if (self.model.D_START_TIME.length <= 0) {
		[JRToast showWithText:@"请选择开始时间"];
		return;
	}
	if (self.model.D_END_TIME.length <= 0) {
		[JRToast showWithText:@"请选择结束时间"];
		return;
	}
	if (self.salesActivityType == SalesActivityAdd) {
		[self HTTPInsertMarketDatas];
	} else {
		[self HTTPUpdateMarketDatas];
	}
}

#pragma mark - HTTP request
- (void)HTTPInsertMarketDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_insertMaketSet];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	//[tempDic setObject:[NSString stringWithFormat:@"A41400-%@",self.random] forKey:@"C_ID"];
	[tempDic setObject:self.model.C_NAME forKey:@"C_NAME"];
//	[tempDic setObject:self.model.C_VOUCHERID forKey:@"C_VOUCHERID"];
//	[tempDic setObject:self.model.C_STATUS_DD_ID forKey:@"TYPE"];
	[tempDic setObject:self.model.D_START_TIME.length > 0 ? [self.model.D_START_TIME stringByAppendingString:@" 00:00:00"] : @"" forKey:@"D_START_TIME"];
	[tempDic setObject:self.model.D_END_TIME.length > 0 ? [self.model.D_END_TIME stringByAppendingString:@" 00:00:00"] : @"" forKey:@"D_END_TIME"];
	//	[tempDic setObject:self.model.C_CLUESOURCE_DD_ID.length > 0 ? self.model.C_CLUESOURCE_DD_ID : @"" forKey:@"C_CLUESOURCE_DD_ID"];
	[tempDic setObject:self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"" forKey:@"X_REMARK"];
	[tempDic setObject:@"A41200_C_TYPE_0001" forKey:@"C_TYPE_DD_ID"];
	[dict setObject:tempDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//编辑
- (void)HTTPUpdateMarketDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updateMaketSet];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	[tempDic setObject:self.model.C_ID forKey:@"C_ID"];
	[tempDic setObject:self.model.C_NAME forKey:@"C_NAME"];
	//	[tempDic setObject:self.model.C_VOUCHERID forKey:@"C_VOUCHERID"];
	//	[tempDic setObject:self.model.C_STATUS_DD_ID forKey:@"TYPE"];
	[tempDic setObject:self.model.D_START_TIME.length > 0 ? [self.model.D_START_TIME stringByAppendingString:@" 00:00:00"] : @"" forKey:@"D_START_TIME"];
	[tempDic setObject:self.model.D_END_TIME.length > 0 ? [self.model.D_END_TIME stringByAppendingString:@" 00:00:00"] : @"" forKey:@"D_END_TIME"];
	//	[tempDic setObject:self.model.C_CLUESOURCE_DD_ID.length > 0 ? self.model.C_CLUESOURCE_DD_ID : @"" forKey:@"C_CLUESOURCE_DD_ID"];
	[tempDic setObject:self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"" forKey:@"X_REMARK"];
//	[tempDic setObject:@"A41200_C_TYPE_0001" forKey:@"C_TYPE_DD_ID"];
	[dict setObject:tempDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}
//详情
- (void)HTTPGetMarkDatas {
	DBSelf(weakSelf);
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getMarketBeanById];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	[tempDic setObject:self.C_ID forKey:@"C_ID"];
	[dict setObject:tempDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		
		if ([data[@"code"] integerValue]==200) {
			weakSelf.model = [MJKMarketSetDetailModel yy_modelWithDictionary:data];
			weakSelf.activityNameTF.text = weakSelf.model.C_NAME;
			weakSelf.startTimeTF.text =[NSString stringWithFormat:@"%@>",weakSelf.model.D_START_TIME] ;
			weakSelf.endTimeTF.text =[NSString stringWithFormat:@"%@>",weakSelf.model.D_END_TIME] ;
			weakSelf.textView.text = weakSelf.model.X_REMARK;
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

@end
