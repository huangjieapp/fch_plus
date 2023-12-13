//
//  MJKEditDeviceSetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/31.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKEditDeviceSetViewController.h"
#import "MJKScanViewController.h"

#import "MJKFlowInstrumentSubModel.h"

@interface MJKEditDeviceSetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberTF;
@property (weak, nonatomic) IBOutlet UITextField *locationTF;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UIButton *scanfButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation MJKEditDeviceSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.topLayout.constant = NavStatusHeight;
	self.view.backgroundColor = kBackgroundColor;
	if (self.model != nil) {
		self.title = @"修改屏幕";
		self.numberTF.text = self.model.C_NUMBER;
		self.locationTF.text = self.model.C_POSITION;
	} else {
		self.title = @"新增屏幕";
	}
}

#pragma mark - 按钮点击事件
#pragma mark 扫一扫
- (IBAction)scanfButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
	MJKScanViewController *vc = [[MJKScanViewController alloc]init];
	vc.scanContentBackBlock = ^(NSString * _Nonnull str) {
		weakSelf.numberTF.text = str;
	};
	[self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 提交
- (IBAction)commitButtonAction:(UIButton *)sender {
	if (self.numberTF.text.length <= 0) {
		[JRToast showWithText:@"请输入屏幕编号或扫描二维码"];
		return;
	}
	
	if (self.locationTF.text.length <= 0) {
		[JRToast showWithText:@"请输入屏幕位置"];
		return;
	}
	[self httpEditDevice];
}

#pragma mark - http data
- (void)httpEditDevice {
	NSString *actionStr = [self.title isEqualToString:@"新增屏幕"] ? HTTP_insertFlowSet : HTTP_updataFlowSet;
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction: actionStr];
	NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
	if (![self.title isEqualToString:@"新增屏幕"]) {
		contentDic[@"C_ID"] = self.model.C_ID;
	}
	contentDic[@"C_NUMBER"] = self.numberTF.text;
	contentDic[@"TYPE"] = @"4";
	contentDic[@"C_POSITION"] = self.locationTF.text;
	[dict setObject:contentDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isRefresh"];
			[JRToast showWithText:data[@"message"]];
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

@end
