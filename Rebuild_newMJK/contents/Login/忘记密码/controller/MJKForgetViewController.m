//
//  MJKForgetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKForgetViewController.h"
#import "SHLoginViewController.h"

@interface MJKForgetViewController ()
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *validationCodeTextField;
@property (weak, nonatomic) IBOutlet UILabel *warnningLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
/** 账号对应的手机号*/
@property (nonatomic, strong) NSString *phoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;

@end

@implementation MJKForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.topLayout.constant = SafeAreaTopHeight;
	[self.navigationController.navigationBar setBarTintColor:KNaviColor];
	self.title = @"忘记密码";
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn-返回" highImage:nil isLeft:YES target:self andAction:@selector(back)];
	if (self.name.length > 0) {
		self.accountTextField.text  = self.name;
	}
}
- (IBAction)showPasswordAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.isSelected == YES) {
        self.passwordTextField.secureTextEntry = NO;
        self.againPasswordTextField.secureTextEntry = NO;
    } else {
        self.passwordTextField.secureTextEntry = YES;
        self.againPasswordTextField.secureTextEntry = YES;
    }
}

- (void)back {
	[self dismissViewControllerAnimated:YES completion:nil];
}

-(void)checkAccount:(NSString*)name andPassword:(NSString*)password{
    DBSelf(weakSelf);
    
    
    [KUSERDEFAULT removeObjectForKey:@"new_url"];
    [KUSERDEFAULT removeObjectForKey:@"url"];
    [KUSERDEFAULT removeObjectForKey:@"ip"];
    [KUSERDEFAULT removeObjectForKey:@"ipImage"];
    [KUSERDEFAULT removeObjectForKey:@"accountCheck"];
    
     NSMutableDictionary *contentDict=[NSMutableDictionary new];
    
    
    [contentDict setObject:name forKey:@"username"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/user/validateApp",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if ([data[@"code"] integerValue]==200) {
            
            [KUSERDEFAULT setObject:data[@"data"][@"url"] forKey:@"new_url"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@mobile_user/entranceToResponseBody.bk",data[@"data"][@"url_old"]]  forKey:@"url"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@mobile_user",data[@"data"][@"url_old"]]  forKey:@"ip"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@mobile_user/uploadFileQINIU.bk?",data[@"data"][@"url_old"]]  forKey:@"ipImage"];
            
            [KUSERDEFAULT setObject:data[@"data"][@"project"] forKey:@"accountCheck"];
           
            [self httpGetIphoneNumber];
            
        } else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
    
    
    
    
    //    [self getLoginUserInfo];
    
}

#pragma mark - 获取验证码按钮
- (IBAction)validationCodeButtonAction:(UIButton *)sender {
	if (self.accountTextField.text.length > 0) {
        if (self.accountTextField.text.length > 0) {
            [self checkAccount:self.accountTextField.text andPassword:@""];
        } else {
            [JRToast showWithText:@"请输入账号"];
        }
	} else {
		[JRToast showWithText:@"请输入账号"];
	}
	
}
#pragma mark - 下一步按钮
- (IBAction)nextButtonAction:(UIButton *)sender {
	if (self.accountTextField.text.length <= 0) {
		[JRToast showWithText:@"请输入账号"];
		return;
	}
	if (self.validationCodeTextField.text.length <= 0) {
		[JRToast showWithText:@"请输入验证码"];
		return;
	}
    if (self.passwordTextField.text.length <= 0) {
        [JRToast showWithText:@"请输入新密码"];
        return;
    }
    
    if (self.passwordTextField.text.length >= 15) {
        [JRToast showWithText:@"密码不能超过15位"];
        return;
    }
    
    if (self.againPasswordTextField.text.length <= 0) {
        [JRToast showWithText:@"请确认新密码"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.againPasswordTextField.text]) {
        [JRToast showWithText:@"两次密码不匹配"];
        return;
    }
	DBSelf(weakSelf);
	[self httpValidationCode:^(NSString *C_ID) {
        UIViewController *vc =self.presentingViewController;
        //SHLoginViewController要跳转的界面
        
        while (![vc isKindOfClass:[SHLoginViewController class]]) {
            vc = vc.presentingViewController;
        }
        [vc dismissViewControllerAnimated:YES completion:nil];
	}];
	
}

#pragma mark - 获取账号对应的手机号码
/**
 200：操作成功
 201：账号未绑定手机号码，请联系管理员！
 202：账号不存在！
 */

- (void)httpGetIphoneNumber {
	DBSelf(weakSelf);
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	if (self.accountTextField.text.length > 0) {
		contentDict[@"username"] = self.accountTextField.text;
	}
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/getPhonenumber", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
      
		MyLog(@"%@",data);
		
		if ([data[@"code"] integerValue]==200) {
			weakSelf.warnningLabel.hidden = YES;
			[weakSelf alertSendCode:data];
			weakSelf.phoneNumber = data;
		} else if ([data[@"code"] integerValue]==201) {
			weakSelf.warnningLabel.hidden = NO;
			weakSelf.warnningLabel.text = data[@"msg"];
		} else if ([data[@"code"] integerValue]==202) {
			weakSelf.warnningLabel.hidden = NO;
			weakSelf.warnningLabel.text = data[@"msg"];
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
		contentDict[@"C_ACCOUNTNAME"] = self.accountTextField.text;
	}
	contentDict[@"C_TYPE_DD_ID"] = @"A63800_C_TYPE_0000";
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a638/sendVerificationCode",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        
		MyLog(@"%@",data);
		
		if ([data[@"code"] integerValue]==200) {
			weakSelf.warnningLabel.hidden = NO;
			weakSelf.warnningLabel.text = data[@"msg"];
		}else{
			[JRToast showWithText:data[@"msg"]];
			
		}
	}];
	
}
#pragma mark 验证账号和验证码是否匹配
- (void)httpValidationCode:(void(^)(NSString *C_ID))compeleteBlock {
	NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
	if (self.accountTextField.text.length > 0) {
		contentDict[@"C_ACCOUNTNAME"] = self.accountTextField.text;
	}
	if (self.validationCodeTextField.text.length > 0) {
		contentDict[@"C_VERIFYCODE"] = self.validationCodeTextField.text;
	}
    if (self.passwordTextField.text.length > 0) {
        contentDict[@"C_PASSWORD"] = self.passwordTextField.text;
    }
	contentDict[@"C_TYPE_DD_ID"] = @"A63800_C_TYPE_0000";
    
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/a638/verificationCode",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        
		MyLog(@"%@",data);
		
		if ([data[@"code"] integerValue]==200) {
			if (compeleteBlock) {
				compeleteBlock(data[@"C_ID"]);
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
			
		}
	}];
	
}

@end
