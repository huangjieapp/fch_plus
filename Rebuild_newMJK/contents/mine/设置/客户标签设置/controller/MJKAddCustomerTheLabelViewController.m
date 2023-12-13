//
//  MJKAddCustomerTheLabelViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/15.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddCustomerTheLabelViewController.h"

@interface MJKAddCustomerTheLabelViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *colorTypeButtonArray;
/** color array*/
@property (nonatomic, strong) NSArray *colorArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
/** 上一个button*/
@property (nonatomic, strong) UIButton *preButton;
/** 标签类型id，前台生成（规则A46600-加随机数）*/
@property (nonatomic, strong) NSString *C_ID;
/** type name*/
@property (nonatomic, strong) NSString *typeName;
/** 传颜色码，如#ff8000这种*/
@property (nonatomic, strong) NSString *C_COLOR_DD_ID;
@end

@implementation MJKAddCustomerTheLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
	self.title = @"新增标签类型";
	self.C_ID = [DBObjectTools getA46600_C_ID];
	self.C_COLOR_DD_ID = self.colorArray[0];
	for (int i = 0; i < self.colorTypeButtonArray.count; i++) {
		UIButton *button = self.colorTypeButtonArray[i];
		button.tag = 100 + i;
		[button setBackgroundColor:[UIColor colorWithHexString:self.colorArray[i]] ];
		if (i == 0) {
			button.layer.borderWidth = 1.f;
			button.layer.borderColor = [UIColor blackColor].CGColor;
			self.preButton = button;
		}
	}
}

#pragma mark - 输入名称
- (IBAction)textChangeTextTF:(UITextField *)sender {
	self.typeName = sender.text;
}

#pragma mark - 选择类型颜色
- (IBAction)colorTypeButtonAction:(UIButton *)sender {
	self.preButton.layer.borderColor = [UIColor clearColor].CGColor;
	self.preButton.layer.borderWidth = 0.0f;
	sender.layer.borderColor = [UIColor blackColor].CGColor;
	sender.layer.borderWidth = 1.f;
	self.C_COLOR_DD_ID = self.colorArray[sender.tag - 100];
	self.preButton = sender;
}

#pragma mark - 提交
- (IBAction)submitButtonAction:(id)sender {
	if (self.typeName.length <= 0) {
		[JRToast showWithText:@"请输入类型名称"];
		return;
	}
	[self HTTPAddCustomerLabelDatas];
}

#pragma mark - HTTP request
- (void)HTTPAddCustomerLabelDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46600WebService-insert"];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	[tempDic setObject:self.C_ID forKey:@"C_ID"];
	[tempDic setObject:self.typeName forKey:@"C_NAME"];
	[tempDic setObject:self.C_COLOR_DD_ID forKey:@"C_COLOR_DD_ID"];
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

#pragma mark - set
- (NSArray *)colorArray {
	if (!_colorArray) {
		_colorArray = [NSArray arrayWithObjects:@"#FFC64A",@"#C68EEF",@"#FF89CD",@"#FF0000",@"#98E5FF",@"#57FF9E",@"#E8FFB0",@"#FFD1D2",@"#5288F8",@"#EEFF52", nil];
	}
	return _colorArray;
}

@end
