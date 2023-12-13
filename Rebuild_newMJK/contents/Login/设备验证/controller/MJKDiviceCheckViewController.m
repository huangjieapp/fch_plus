//
//  MJKDiviceCheckViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/10.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKDiviceCheckViewController.h"
#import "DBTabBarViewController.h"
#import "GGVerifyCodeViewBtn.h"

#import "MJKGroupReportViewController.h"

@interface MJKDiviceCheckViewController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
/** phone*/
@property (nonatomic, strong) NSString *phoneNumber;
@property (weak, nonatomic) IBOutlet UIView *checkView;
@property (weak, nonatomic) IBOutlet UIView *sendCheckView;
@property (weak, nonatomic) IBOutlet UILabel *remindLabel;
@property (weak, nonatomic) IBOutlet GGVerifyCodeViewBtn *sendAgainButton;
@property (weak, nonatomic) IBOutlet UIButton *trueButton;
/** 验证码*/
@property (nonatomic, strong) NSString *codeStr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *checkTopLayout;

@end

@implementation MJKDiviceCheckViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开始验证";
	self.checkTopLayout.constant = SafeAreaTopHeight;
	self.checkView.hidden = YES;
	
	[self httpGetIphoneNumber];
	[self setBarButtonItem];
	
}

- (void)closeViewAction {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backButtonAction {
	[self.view endEditing:YES];
	if ([self.title isEqualToString:@"开始验证"]) {
		[self dismissViewControllerAnimated:YES completion:nil];
	} else {
		self.title = @"开始验证";
		self.sendCheckView.hidden = NO;
		self.checkView.hidden = YES;
//		self.navigationItem.rightBarButtonItem.customView.hidden = NO;
//		self.navigationItem.leftBarButtonItem.customView.hidden = YES;
	}
	
}

- (IBAction)beginCheckAction:(UIButton *)sender {
	self.remindLabel.text = [NSString stringWithFormat:@"我们已给你的手机号码%@发送了一条验证短信。",[self.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
	[self alertSendCode:self.phoneNumber];
	
	
	
}

- (IBAction)sendAgainButtonAction:(UIButton *)sender {
	[self.sendAgainButton timeFailBeginFrom:60];
	[self httpSendCode:self.phoneNumber];
}

- (void)setBarButtonItem {
	UIButton *closeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[closeButton setTitleNormal:@"关闭"];
	[closeButton setTitleColor:[UIColor blackColor]];
	closeButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[closeButton addTarget:self action:@selector(closeViewAction)];
	
	UIBarButtonItem *closeItem = [[UIBarButtonItem alloc]initWithCustomView:closeButton];
//	self.navigationItem.rightBarButtonItem = closeItem;
	
	UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[backButton setImage:@"btn-返回"];
	backButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[backButton addTarget:self action:@selector(backButtonAction)];
	backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backItem;
}

//输入验证码
- (IBAction)textFieldChang:(UITextField *)sender {
	if (sender.text.length >= 4) {
		self.trueButton.enabled = YES;
		[self.trueButton setBackgroundColor:KNaviColor];
	} else {
		self.trueButton.enabled = NO;
		[self.trueButton setBackgroundColor:COLOR_RGB(0xD6D6D6)];
	}
	self.codeStr = sender.text;
}
- (IBAction)trueButtonAction:(UIButton *)sender {
	[self.view endEditing:YES];
	DBSelf(weakSelf);
	[self httpValidationCode:^(NSString *C_ID) {
		[weakSelf LoginDataWithName];
//		[weakSelf closeViewAction];
	}];
}

//MARK:-获取账号对应的手机号码
- (void)httpGetIphoneNumber {
	DBSelf(weakSelf);
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	if (self.C_ACCOUNTNAME.length > 0) {
		contentDict[@"username"] = self.C_ACCOUNTNAME;
	}
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/getPhonenumber", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			NSString *phoneStr = data;
			weakSelf.phoneLabel.text = [phoneStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
			weakSelf.phoneNumber = phoneStr;
		}else{
			[JRToast showWithText:data[@"msg"]];
			
		}
	}];
	
}

#pragma 提示是否发送验证码
- (void)alertSendCode:(NSString *)str {
	DBSelf(weakSelf);
	
	NSString *alertStr = [NSString stringWithFormat:@"是否发送验证码到%@",[str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:alertStr preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		[weakSelf httpSendCode:str];
	}];
	UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:falseAction];
	[alertC addAction:trueAction];
	[self presentViewController:alertC animated:YES completion:nil];
}
#pragma mark 发送验证码
- (void)httpSendCode:(NSString *)str {
	DBSelf(weakSelf);
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	if (str.length > 0) {
		contentDict[@"C_ACCOUNTNAME"] = self.C_ACCOUNTNAME;
	}
	contentDict[@"C_TYPE_DD_ID"] = self.isMoreTimeNotLoggedIn == YES ? @"A63800_C_TYPE_0002" : @"A63800_C_TYPE_0001";
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a638/sendVerificationCode",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		
		if ([data[@"code"] integerValue]==200) {
			weakSelf.remindLabel.text = [NSString stringWithFormat:@"我们已给你的手机号码%@发送了一条验证短信。",[self.phoneNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
			
			weakSelf.title = @"填写验证码";
			weakSelf.sendCheckView.hidden = YES;
			weakSelf.checkView.hidden = NO;
//			weakSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
//			weakSelf.navigationItem.leftBarButtonItem.customView.hidden = NO;
			[weakSelf.sendAgainButton timeFailBeginFrom:60];
		}else{
			[JRToast showWithText:data[@"msg"]];
			
		}
	}];
	
}
#pragma mark 验证账号和验证码是否匹配
- (void)httpValidationCode:(void(^)(NSString *C_ID))compeleteBlock {
	//	DBSelf(weakSelf);
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	if (self.phoneNumber.length > 0) {
		contentDict[@"C_ACCOUNTNAME"] = self.C_ACCOUNTNAME;
	}
	if (self.codeStr.length > 0) {
		contentDict[@"C_VERIFYCODE"] = self.codeStr;
	}
	contentDict[@"C_TYPE_DD_ID"] = self.isMoreTimeNotLoggedIn == YES ? @"A63800_C_TYPE_0002" : @"A63800_C_TYPE_0001";
    if ([contentDict[@"C_TYPE_DD_ID"] isEqualToString:@"A63800_C_TYPE_0001"]) {
        contentDict[@"C_PHONEIMEI"] = [DBTools uuid];
    }
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a638/verificationCode",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);

		if ([data[@"code"] integerValue]==200) {
			if (compeleteBlock) {
				compeleteBlock(data[@"C_ID"]);
			}
//			[JRToast showWithText:data[@"message"]];
		}else{
			[JRToast showWithText:data[@"msg"]];

		}
	}];

}

#pragma mark  --登陆
-(void)LoginDataWithName{
	
	[NewUserSession instance].user.u051Id=@"";
	[NewUserSession instance].TOKEN=@"";
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_Login];
	
	
	
	//这里的C_CHANNEL_ID和C_PUSH_ID  是推送的  先推送的有值了就传 没有就@“”
	if (!_BchannelId) {
		_BchannelId=@"";
	}
	if (!_BPushappId) {
		_BPushappId=@"";
	}
	
	//上次登录的时间   如果换了账号  或者没有值   那就给他1950    登录成功后  会赋值的
	NSString*lastLoginTime=[KUSERDEFAULT objectForKey:saveLastLoginTime];
	if (!lastLoginTime) {
		lastLoginTime=@"1950-01-01 00:00:00";
	}
//	NSString *LoginAccount=[KUSERDEFAULT objectForKey:saveLoginName];
//	if (![LoginAccount isEqualToString:self.nameTextfield.text]) {
//		lastLoginTime=@"1950-01-01 00:00:00";
//	}
//	[KUSERDEFAULT setObject:lastLoginTime forKey:saveLastLoginTime];
	
	
	NSDictionary*contentDict=@{@"C_ACCOUNTNAME":[KUSERDEFAULT objectForKey:saveLoginName],@"C_PASSWORD":[KUSERDEFAULT objectForKey:saveLoginCode],@"C_CHANNEL_ID":_BchannelId,@"C_PUSH_ID":_BPushappId,@"C_PHONETYPE":@"0",@"D_LASTUPDATE_TIME":@"1950-01-01 00:00:00",@"C_PHONEIMEI" : [DBTools uuid] };//[[UIDevice currentDevice].identifierForVendor UUIDString]
	[dict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		
		if ([data[@"code"] integerValue]==200) {
			//            //历史的问题赋值  给历史登录赋值
			//            [self histroyLoginOf:data];
			
			
			[NewUserSession saveUserInfoWithDic:data];
			[KUSERDEFAULT setObject:[NewUserSession instance].D_LASTUPDATE_TIME forKey:saveLastLoginTime];
			
			//给数据字典  用fmdb数据库 保存好
			[self saveDataDicUseFMDBWithLastLoginTime:lastLoginTime];
			
			
			if (![[NewUserSession instance].user.groupType isEqualToString:@"U03100_C_ISGROUP_0001"]) {
				//                ReporterViewController *myView=[[ReporterViewController alloc]initWithNibName:@"ReporterViewController" bundle:nil];
                MJKGroupReportViewController *vc = [[MJKGroupReportViewController alloc]init];
				UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:vc];
				[self presentViewController:nav animated:YES completion:nil];
				
				//                [JRToast showWithText:@"集团么 又是怎样  业务逻辑？"];
				
			}else{
				DBTabBarViewController*tab=[[DBTabBarViewController alloc]initWithNibName:@"DBTabBarViewController" bundle:nil];
				[UIApplication sharedApplication].keyWindow.rootViewController=tab;
			}
			
			
			//			[KUSERDEFAULT setObject:name forKey:saveLoginName];
			//			[KUSERDEFAULT setObject:password forKey:saveLoginCode];
			//			MJKDiviceCheckViewController *vc = [[MJKDiviceCheckViewController alloc]initWithNibName:@"MJKDiviceCheckViewController" bundle:nil];
			//			vc.C_ACCOUNTNAME = name;
			//			DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:vc];
			//			[self presentViewController:nav animated:YES completion:nil];
			
		} else{
			[JRToast showWithText:data[@"message"]];
			
			[KUSERDEFAULT removeObjectForKey:saveLoginName];
			[KUSERDEFAULT removeObjectForKey:saveLoginCode];
			
		}
		
		
	}];
	
	
	
	
	//    [self getLoginUserInfo];
	
}

-(void)saveDataDicUseFMDBWithLastLoginTime:(NSString*)lastLoginTimer{
	//如果是第一次  那就清空数字字典
	
	if ([lastLoginTimer isEqualToString:@"1950-01-01 00:00:00"]) {
		[[FMDBManager sharedFMDBManager]deleteAllDataModel];
	}
	
	
	NSArray*array=[NewUserSession instance].datadict;
	for (NSDictionary*dict in array) {
		MJKDataDicModel*model=[MJKDataDicModel yy_modelWithDictionary:dict];
		NSLog(@"%@---%@",model.C_NAME,model.C_TYPECODE);
		
		if ([model.FLAG isEqualToString:@"INSERT"]) {
			[[FMDBManager sharedFMDBManager] addDataModel:model];
			
		}else if ([model.FLAG isEqualToString:@"DELETE"]){
			[[FMDBManager sharedFMDBManager] deleteDataModel:model];
			
		}else if ([model.FLAG isEqualToString:@"UPDATE"]){
			[[FMDBManager sharedFMDBManager] updateDataModel:model];
			
		}else{
			[JRToast showWithText:@"数据库错误"];
		}
		
		
	}
	
	
	
	//关闭数据库
	[[FMDBManager sharedFMDBManager].fmdb close];
	
	
	
}



@end
