//
//  SHLoginViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/3.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHLoginViewController.h"
#import "DBTabBarViewController.h"

#import "MJKDiviceCheckViewController.h"
#import "BPush.h"

#import "DBNavigationController.h"
#import "DGJRegisterViewController.h"
#import "MJKNewGroupShopsViewController.h"
//history
//#import "CoreDataManager.h"
//#import "Model+CoreDataClass.h"
#import "ReporterViewController.h"   //集团不是false跳转
//#import "ApplicationInViewController.h"  //申请入驻界面
#import "MJKForgetViewController.h"
#import "MJKLoginAccountTableViewCell.h"


#import "MJKGroupReportViewController.h"

#import "MJKShowSendView.h"

#import "WXApi.h"

@interface SHLoginViewController ()<UITableViewDataSource, UITableViewDelegate>{
    //都是history问题
    NSMutableArray *_dataArr;   //这个是数字字典 选择的时候用的
    NSString *C_ISGROUP;   //集团
    NSString*D_LASTUPDATE_TIME;  //最后一次登录时间
}

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITableView *userAccountTableView;

@property(nonatomic,assign)BOOL canSave;

//两个推送的值
@property(nonatomic,retain)NSString *BchannelId;
@property(nonatomic,retain)NSString *BPushappId;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *accountArray;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *selectAccountArray;


@end

@implementation SHLoginViewController
//发版时要注释
- (IBAction)longTapChangeUrl:(UILongPressGestureRecognizer *)sender {
//    if (sender.state == UIGestureRecognizerStateBegan) {
//        if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"formal"] isEqualToString:@"YES"]) {
//            [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"formal"];
//            [JRToast showWithText:@"切换成测试环境"];
//        } else {
//            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"formal"];
//            [JRToast showWithText:@"切换成正式环境"];
//        }
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	//正式环境
    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"formal"];
    
    
    
	
    self.loginButton.layer.cornerRadius=20;
    self.loginButton.layer.masksToBounds=YES;
    
    
    if ([KUSERDEFAULT objectForKey:saveLoginName]&&[KUSERDEFAULT objectForKey:saveLoginCode]) {
        self.nameTextfield.text=[KUSERDEFAULT objectForKey:saveLoginName];
        self.codeTextField.text=[KUSERDEFAULT objectForKey:saveLoginCode];
        
    }
    
    
    //开始推动的绑定
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            // 绑定返回值
            NSLog(@"%@",result);
            if (result) {
                NSString *appid = [result valueForKey:BPushRequestAppIdKey];
                NSString *userid = [result valueForKey:BPushRequestUserIdKey];
                NSString *channelid = [result valueForKey:BPushRequestChannelIdKey];
                self.BPushappId = appid;
                self.BchannelId = channelid;
    //            self.userId = userid;
                
            }
            
        }];
    });
    
    
    [self.nameTextfield addTarget:self action:@selector(editBeginAction:) forControlEvents:UIControlEventEditingDidBegin];
    [self.nameTextfield addTarget:self action:@selector(editChangeAction:) forControlEvents:UIControlEventEditingChanged];

    NSString *filePath = [self dataFilePath];
    //检查数据文件在不在
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSFileManager* fm = [NSFileManager defaultManager];
        [fm createFileAtPath:filePath contents:nil attributes:nil];
        //设置属性值
        NSMutableArray *arr = [NSMutableArray array];
        //写入文件
        [arr writeToFile:filePath atomically:YES];
    } else {
        self.accountArray = [NSMutableArray arrayWithContentsOfFile:filePath];
        
    }
    
}

-(NSString *)dataFilePath{
    
    //查找Document目录并在其后附加数据文件的文件名，这样就得到了数据文件的完整的路径
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"UserAccount.plist"];
    
}

- (void)editBeginAction:(UITextField *)sender {
    if (self.nameTextfield.text.length > 0) {
        self.selectAccountArray = [NSMutableArray array];
        [self.selectAccountArray addObject:self.nameTextfield.text];
    } else {
        
    self.selectAccountArray = [NSMutableArray arrayWithArray:self.accountArray];
    }
    if (self.accountArray.count > 0) {
        self.userAccountTableView.hidden = NO;
    }
    [self.userAccountTableView reloadData];
}

- (void)editChangeAction:(UITextField *)sender {
    self.selectAccountArray = [NSMutableArray array];
    if (sender.text.length <= 0) {
        [self.selectAccountArray addObjectsFromArray:self.accountArray];
    }
     NSMutableArray* accountArray = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
    for (NSString *str in accountArray) {
        if ([str containsString:sender.text]) {
            [self.selectAccountArray addObject:str];
        }
    }
    [self.userAccountTableView reloadData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectAccountArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKLoginAccountTableViewCell *cell = [MJKLoginAccountTableViewCell cellWithTableView:tableView];
        cell.accountLabel.text = self.selectAccountArray[indexPath.row];
    
        
        
    cell.deleteAccountActionBlock = ^{
        NSMutableArray* accountArray = [NSMutableArray arrayWithContentsOfFile:[weakSelf dataFilePath]];
        if ([weakSelf.accountArray containsObject:self.selectAccountArray[indexPath.row]]) {
            [accountArray removeObject:self.selectAccountArray[indexPath.row]];
            [weakSelf.selectAccountArray removeObject:self.selectAccountArray[indexPath.row]];
        }
        [accountArray writeToFile:[weakSelf dataFilePath] atomically:NO];
        
        weakSelf.accountArray = [NSMutableArray arrayWithContentsOfFile:[weakSelf dataFilePath]];
        if (weakSelf.accountArray.count <= 0) {
            tableView.hidden = YES;
        }
        [tableView reloadData];
        
    };
    cell.contentView.backgroundColor = kBackgroundColor;
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![self.nameTextfield.text isEqualToString:self.selectAccountArray[indexPath.row]]) {
        self.nameTextfield.text = self.selectAccountArray[indexPath.row];
        self.codeTextField.text = @"";
    }
    
    [self.nameTextfield resignFirstResponder];
    self.userAccountTableView.hidden = YES;
}


-(NSString*)judegeSave{
    self.canSave=YES;
    if (self.nameTextfield.text.length<1) {
        self.canSave=NO;
        return @"请输入用户名";
    }
    
    if (self.codeTextField.text.length<1) {
        self.canSave=NO;
        return @"请输入密码";
    }
   
    return @"";
    
}

#pragma mark  -- touch
- (IBAction)Login:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"url"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ip"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"ipImage"];
    [KUSERDEFAULT removeObjectForKey:@"tabSelect"];
    
    [KUSERDEFAULT removeObjectForKey:@"customerTabName"];
    
    [KUSERDEFAULT removeObjectForKey:@"clueTabName"];
    
   
    
    
    
    
    NSString*str=[self judegeSave];
    
    
   
    
//    if (![EMClient sharedClient].isAutoLogin) {
//   
//        [[EMClient sharedClient] registerWithUsername:self.nameTextfield.text password:self.codeTextField.text completion:^(NSString *aUsername, EMError *aError) {
//            NSLog(@"%s---line:---%d",__func__,__LINE__);
//        }];
//        [[EMClient sharedClient] loginWithUsername:self.nameTextfield.text password:self.codeTextField.text  completion:^(NSString *aUsername, EMError *aError) {
//         [[EMClient sharedClient].options setIsAutoLogin:YES];
//             NSLog(@"%s---line:---%d",__func__,__LINE__);
//        }];
//     }
   
    
    if (self.canSave) {
        
        
//        [self LoginDataWithName:self.nameTextfield.text andPassword:self.codeTextField.text];
        [self checkAccount:self.nameTextfield.text andPassword:self.codeTextField.text];
        
        
        
        
        
    }else{
        [JRToast showWithText:str];
    }
    
    
    
}

- (IBAction)forgetCode:(id)sender {
    MJKForgetViewController *vc = [[MJKForgetViewController alloc]initWithNibName:@"MJKForgetViewController" bundle:nil];
	DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:vc];
	if (self.nameTextfield.text.length > 0) {
		vc.name = self.nameTextfield.text;
	}
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
	[self presentViewController:nav animated:YES completion:nil];
    
}
- (IBAction)applyForIn:(id)sender {
//    ApplicationInViewController *myView=[[ApplicationInViewController alloc]initWithNibName:@"ApplicationInViewController" bundle:nil];
//    [self presentViewController:myView animated:YES completion:^{
//        
//    }];

    DGJRegisterViewController*vc=[[DGJRegisterViewController alloc]init];
    DBNavigationController*navi=[[DBNavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/





#pragma mark  --data
-(void)checkAccount:(NSString*)name andPassword:(NSString*)password{
    if ([name isEqualToString:@"159791985801"]) {
        if ([KUSERDEFAULT objectForKey:@"notLogin"]) {
            [JRToast showWithText:@"账号不存在"];
            [KUSERDEFAULT removeObjectForKey:@"notLogin"];
            return;
        }
    }
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
        
//    }]
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        
        if ([data[@"code"] integerValue]==200) {
            [KUSERDEFAULT setObject:data[@"data"][@"url"] forKey:@"new_url"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@mobile_user/entranceToResponseBody.bk",data[@"data"][@"url_old"]]  forKey:@"url"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@mobile_user",data[@"data"][@"url_old"]]  forKey:@"ip"];
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@mobile_user/uploadFileQINIU.bk?",data[@"data"][@"url_old"]]  forKey:@"ipImage"];
            
            [KUSERDEFAULT setObject:data[@"data"][@"project"] forKey:@"accountCheck"];
            [self LoginDataWithName:name andPassword:password];
            
        } else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
    
    
    
    
    //    [self getLoginUserInfo];
    
}

- (void)getTokenWithUsername:(NSString *)username andPassword:(NSString *)password andSuccessBlock:(void(^)(void))successBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"username"] = username;
    contentDic[@"password"] = password;
    contentDic[@"appType"] = @"0";
    contentDic[@"imei"] = [DBTools uuid];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMLOGIN parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:data[@"token"] forKey:@"token"];
            [KUSERDEFAULT setObject:data[@"oldToken"] forKey:@"oldToken"];
            if ([data[@"dqrnumber"] integerValue] <= 15 && [data[@"dqrnumber"] integerValue] >= 0) {
                NSArray *buttonTitleArray;
                if ([data[@"isfkr"] boolValue] == YES) {
                    buttonTitleArray = @[@"我知道了"];
                } else {
                    buttonTitleArray = @[@"我知道了"];
                }
                MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:buttonTitleArray andTitle:@"通知" andMessage:data[@"content"]];
                showView.isFkr = YES;
                showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                    [weakSelf getNewUserInfoWithSuccessBlock:^{
                        if (successBlock) {
                            successBlock();
                        }
                    }];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:showView];
            } else {

                [weakSelf getNewUserInfoWithSuccessBlock:^{
                    if (successBlock) {
                        successBlock();
                    }
                }];
            }
        } else if ([data[@"code"] integerValue] == 5021) {
            NSArray *buttonTitleArray;
            if ([data[@"isfkr"] boolValue] == YES) {
                buttonTitleArray = @[];
            } else {
                buttonTitleArray = @[];
            }
            MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:buttonTitleArray andTitle:@"通知" andMessage:data[@"msg"]];
            showView.isFkr = YES;
            [[UIApplication sharedApplication].keyWindow addSubview:showView];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getNewUserInfoWithSuccessBlock:(void(^)(void))successBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_SYSTEMGETUSERINFO parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [NewUserSession saveUserInfoWithDic:data];
            [weakSelf saveDataDicUseFMDBWithLastLoginTime];
            if (successBlock) {
                successBlock();
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)LoginDataWithName:(NSString*)name andPassword:(NSString*)password{
    DBSelf(weakSelf);
    
    [NewUserSession instance].user.u051Id=@"";
    [NewUserSession instance].TOKEN=@"";
            [weakSelf getTokenWithUsername:name andPassword:password andSuccessBlock:^{
                         NSMutableArray* accountArray = [NSMutableArray arrayWithContentsOfFile:[self dataFilePath]];
                            if (![accountArray containsObject:name]) {
                                [accountArray insertObject:name atIndex:0];
                                if (accountArray.count > 10) {
                                    [accountArray removeLastObject];
                                }
                                [accountArray writeToFile:[self dataFilePath] atomically:NO];
                            }
                            
                            
                            [KUSERDEFAULT setObject:name forKey:saveLoginName];
                            [KUSERDEFAULT setObject:password forKey:saveLoginCode];

                if([[NewUserSession instance].user.groupType isEqualToString:@"U03100_C_ISGROUP_0001"]) {
                    
                       
                        [NewUserSession instance].jobStr = @"员工";
                        DBTabBarViewController*tab=[[DBTabBarViewController alloc]initWithNibName:@"DBTabBarViewController" bundle:nil];
                        tab.fileDic = self.fileDic;
                        [UIApplication sharedApplication].keyWindow.rootViewController=tab;
                } else {
                    [NewUserSession instance].jobStr = @"门店";
                    MJKGroupReportViewController *vc = [[MJKGroupReportViewController alloc]init];
                    
                    DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:vc];
                    [UIApplication sharedApplication].keyWindow.rootViewController=nav;
                }

                         
                
                [KVNProgress dismiss];

            }];

            
       
    
   
    
}





#pragma mark  隐藏键盘
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}

//touch began
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.userAccountTableView.hidden = YES;
    [[self findFirstResponderBeneathView:self.view] resignFirstResponder];
}


- (UIView*)findFirstResponderBeneathView:(UIView*)view
{
    // Search recursively for first responder
    for ( UIView *childView in view.subviews ) {
        if ( [childView respondsToSelector:@selector(isFirstResponder)] && [childView isFirstResponder] )
            return childView;
        UIView *result = [self findFirstResponderBeneathView:childView];
        if ( result )
            return result;
    }
    return nil;
}


-(void)saveDataDicUseFMDBWithLastLoginTime {

    [[FMDBManager sharedFMDBManager]deleteAllDataModel];


    NSArray*array=[NewUserSession instance].datadict;
    for (NSDictionary*dict in array) {
        MJKDataDicModel*model=[MJKDataDicModel yy_modelWithDictionary:dict];
        NSLog(@"%@---%@",model.C_NAME,model.C_TYPECODE);
        
//        if ([model.FLAG isEqualToString:@"INSERT"]) {
            [[FMDBManager sharedFMDBManager] addDataModel:model];
            
//        }else if ([model.FLAG isEqualToString:@"DELETE"]){
//            [[FMDBManager sharedFMDBManager] deleteDataModel:model];
//
//        }else if ([model.FLAG isEqualToString:@"UPDATE"]){
//            [[FMDBManager sharedFMDBManager] updateDataModel:model];
//
//        }else{
//            [JRToast showWithText:@"数据库错误"];
//        }
        
        
    }
    
    
    
    //关闭数据库
    [[FMDBManager sharedFMDBManager].fmdb close];
    
    
    
}

//-(void)saveDataDicUseFMDBWithLastLoginTime:(NSString*)lastLoginTimer{
//    //如果是第一次  那就清空数字字典
//
//    if ([lastLoginTimer isEqualToString:@"1950-01-01 00:00:00"]) {
//        [[FMDBManager sharedFMDBManager]deleteAllDataModel];
//    }
//
//
//   NSArray*array=[NewUserSession instance].datadict;
//    for (NSDictionary*dict in array) {
//        MJKDataDicModel*model=[MJKDataDicModel yy_modelWithDictionary:dict];
//        NSLog(@"%@---%@",model.C_NAME,model.C_TYPECODE);
//
//            [[FMDBManager sharedFMDBManager] deleteDataModel:model];
//        if ([model.FLAG isEqualToString:@"INSERT"]) {
//            [[FMDBManager sharedFMDBManager] addDataModel:model];
//
//        }else if ([model.FLAG isEqualToString:@"DELETE"]){
//            [[FMDBManager sharedFMDBManager] deleteDataModel:model];
//
//        }else if ([model.FLAG isEqualToString:@"UPDATE"]){
//            [[FMDBManager sharedFMDBManager] updateDataModel:model];
//
//        }else{
//            [JRToast showWithText:@"数据库错误"];
//        }
//
//
//    }
//
//
//
//    //关闭数据库
//    [[FMDBManager sharedFMDBManager].fmdb close];
//
//
//
//}




#pragma mark  -- history
////历史的问题
//-(void)histroyLoginOf:(NSDictionary*)dataDic{
//    //如果是第一次  那就清空数字字典
//    NSString*lastLoginTime=[KUSERDEFAULT objectForKey:saveLastLoginTime];
//    if ([lastLoginTime isEqualToString:@"1950-01-01 00:00:00"]) {
////        [[CoreDataManager manager] deleData];
//    }
//    _dataArr=[[NSMutableArray alloc]init];
//    _dataArr=[dataDic objectForKey:@"datadict"];    //数字字典
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_FIRSTLOGIN_DD_NAME"] forKey:@"C_FIRSTLOGIN_DD_NAME"]; //否
//    
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_U05100_C_ID"] forKey:@"C_U05100_C_ID"];
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_A40300_C_ID"] forKey:@"C_A40300_C_ID"];
//    
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"appcode"] forKey:@"appcode"];
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"D_LASTUPDATE_TIME"] forKey:@"D_LASTUPDATE_TIME"];
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"TOKEN"] forKey:@"TOKEN"];
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"user_id"] forKey:@"user_id"];
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_HEADIMGURL"] forKey:@"C_HEADIMGURL"];//头像
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_EMAILADDRESS"] forKey:@"C_EMAILADDRESS"];//邮箱
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_MOBILENUMBER"] forKey:@"C_MOBILENUMBER"];//手机号码
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_NAME"] forKey:@"C_NAME"];//名称
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_IDENTITYCODE"] forKey:@"C_IDENTITYCODE"];//身份证
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_WECHAT"] forKey:@"C_WECHAT"];//微信号
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_ACCOUNTNAME"] forKey:@"C_ACCOUNTNAME"];//账号
//    
//    [KUSERDEFAULT setObject:self.nameTextfield.text forKey:@"nameText"];
//    [KUSERDEFAULT setObject:self.codeTextField.text forKey:@"passText"];
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_ABBREVATION"] forKey:@"C_ABBREVATION"];//C_ABBREVATION  经销商简称
//    
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"IS_BH"] forKey:@"IS_BH"];//拨号
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"IS_SJ"] forKey:@"IS_SJ"];//手机
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"IS_DH"] forKey:@"IS_DH"];//电话
//    
//    
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_INTERNAL"] forKey:@"C_INTERNAL"];//内部号码
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_EXTERNAL"] forKey:@"C_EXTERNAL"];//外部号码
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_FORWARD"] forKey:@"C_FORWARD"];//外部号码
//    
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_A50100_C_ID"] forKey:@"C_A50100_C_ID"];//微信营销id
//    [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_ISGROUP"] forKey:@"C_ISGROUP"];//是否是集团   false
//    C_ISGROUP=[dataDic objectForKey:@"C_ISGROUP"];
//    
//    
//    NSString *CurrentDay=[DBTools getYearMonthDayTime];
//    [KUSERDEFAULT setObject:CurrentDay forKey:@"login_flag"];//保存当天时间
//    
//    [KUSERDEFAULT synchronize];
//    
//    
//    [self performSelectorOnMainThread:@selector(saveAction) withObject:nil waitUntilDone:YES];
//    
//    
//    
//    
//    
//}
//
//#pragma mark把数据写入数据库
//-(void)saveAction{
//    for (int i=0; i<_dataArr.count; i++) {
//        //数字字典的使用
//        
//        NSMutableDictionary *dic=_dataArr[i];
//        NSString* c_FATHERVOUCHERID=[dic objectForKey:@"C_FATHERVOUCHERID"];
//        NSString* c_ID=[dic objectForKey:@"C_ID"];
//        NSString* c_NAME=[dic objectForKey:@"C_NAME"];
//        NSString* c_TYPECODE=[dic objectForKey:@"C_TYPECODE"];
//        NSString* c_VOUCHERID=[dic objectForKey:@"C_VOUCHERID"];
//        NSNumber* i_SORTIDX=@([[dic objectForKey:@"I_SORTIDX"] integerValue]);
//        NSLog(@"%@",c_NAME);
//        
//        
//        
//        if ([[dic objectForKey:@"FLAG"] isEqualToString:@"INSERT"]) {
//            NSLog(@"INSERT%d",i);
////            [[CoreDataManager manager]addUser:^(Model *User1) {
////                User1.c_FATHERVOUCHERID=c_FATHERVOUCHERID;
////                User1.c_ID=c_ID;
////                User1.c_NAME=c_NAME;
////                User1.c_TYPECODE=c_TYPECODE;
////                User1.c_VOUCHERID=c_VOUCHERID;
////                User1.i_SORTIDX=i_SORTIDX;
////                
////            }];
//            
//        }else if ([[dic objectForKey:@"FLAG"]isEqualToString:@"UPDATE"]){
//            
//            NSLog(@"UPDATE%d",i);
//            
////            [[CoreDataManager manager]removeModel:c_ID];
//            
//            
////            [[CoreDataManager manager]addUser:^(Model *User1) {
////                User1.c_FATHERVOUCHERID=c_FATHERVOUCHERID;
////                User1.c_ID=c_ID;
////                User1.c_NAME=c_NAME;
////                User1.c_TYPECODE=c_TYPECODE;
////                User1.c_VOUCHERID=c_VOUCHERID;
////                User1.i_SORTIDX=i_SORTIDX;
////            }];
//        }else if ([[dic objectForKey:@"FLAG"]isEqualToString:@"DELETE"]){
//            
//            NSLog(@"DELETE%d",i);
//            
////            [[CoreDataManager manager]removeModel:c_ID];
//            
//            
//            
//        }
//        
//        
//        
//        //        搞不懂这什么玩意
//        //        if (_addcb) {
//        //            _addcb();
//        //        }
//    }
//    
//    
//    //这里跳转
//    
//    //    [KVNProgress dismiss];
//    
//    
//}



//-(void)getLoginUserInfo{
//    //5616322571093379553
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:@"UserWebService-login" forKey:@"action"];
//    [dic setObject:@"" forKey:@"user_id"];
//    [dic setObject:@"" forKey:@"gsonValue"];
//    [dic setObject:@"" forKey:@"appkey"];
//    [dic setObject:@"S" forKey:@"appType"];
//    NSInteger arc=[MyUtil getRandomNumber];
//    [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//    [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//    [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
//    NSMutableDictionary *dic1=[NSMutableDictionary new];
//    
//    
//    [dic1 setObject:self.nameTextfield.text forKey:@"C_ACCOUNTNAME"];
//    [dic1 setObject:self.codeTextField.text forKey:@"C_PASSWORD"];
//    
//    
//    //没有channelID 和 C_PUSH_ID 两个参数
//    if (self.BchannelId) {
//        [dic1 setObject:self.BchannelId forKey:@"C_CHANNEL_ID"];
//        [dic1 setObject:self.BPushappId forKey:@"C_PUSH_ID"];
//    }else
//    {
//        [dic1 setObject:@"" forKey:@"C_CHANNEL_ID"];
//        [dic1 setObject:@"" forKey:@"C_PUSH_ID"];
//    }
//    
//    
//    [dic1 setObject:@"0" forKey:@"C_PHONETYPE"];
//    
//    
//    
//    //最后登录的时间   如果换了账号  或者没有值   那就给他1950    登录成功后  会赋值的
//     D_LASTUPDATE_TIME=[KUSERDEFAULT objectForKey:@"D_LASTUPDATE_TIME"];
//    if (!D_LASTUPDATE_TIME) {
//        D_LASTUPDATE_TIME=@"1950-01-01 00:00:00";
//    }
//    NSString *name=[KUSERDEFAULT objectForKey:@"nameText"];
//    if (![name isEqualToString:self.nameTextfield.text]) {
//        D_LASTUPDATE_TIME=@"1950-01-01 00:00:00";
//    }
//    [dic1 setObject:D_LASTUPDATE_TIME forKey:@"D_LASTUPDATE_TIME"];
//    
//    //a62bd41a-7f61-42df-ad7d-f7d3ad422cd8
//    
//    [dic setObject:dic1 forKey:@"content"];
//    
//    NSString *str=[dic JSONString];
//    NSString *respone=[HttpPost getPost:str];
//    if (![respone isEqualToString:@""])
//    {
//        
//        NSDictionary *  dataDic = [respone objectFromJSONString];
//        
//        
//        
//        
//        NSString *errcode = [dataDic objectForKey:@"code"];
//        if ([errcode isEqualToString:@"200"]) {
//            
//            
//            //如果是第一次  那就清空数字字典
//            if ([D_LASTUPDATE_TIME isEqualToString:@"1950-01-01 00:00:00"]) {
//                [[CoreDataManager manager] deleData];
//            }
//             _dataArr=[[NSMutableArray alloc]init];
//            _dataArr=[dataDic objectForKey:@"datadict"];    //数字字典
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_FIRSTLOGIN_DD_NAME"] forKey:@"C_FIRSTLOGIN_DD_NAME"]; //否
//            
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_U05100_C_ID"] forKey:@"C_U05100_C_ID"];
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_A40300_C_ID"] forKey:@"C_A40300_C_ID"];
//            
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"appcode"] forKey:@"appcode"];
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"D_LASTUPDATE_TIME"] forKey:@"D_LASTUPDATE_TIME"];
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"TOKEN"] forKey:@"TOKEN"];
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"user_id"] forKey:@"user_id"];
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_HEADIMGURL"] forKey:@"C_HEADIMGURL"];//头像
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_EMAILADDRESS"] forKey:@"C_EMAILADDRESS"];//邮箱
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_MOBILENUMBER"] forKey:@"C_MOBILENUMBER"];//手机号码
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_NAME"] forKey:@"C_NAME"];//名称
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_IDENTITYCODE"] forKey:@"C_IDENTITYCODE"];//身份证
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_WECHAT"] forKey:@"C_WECHAT"];//微信号
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_ACCOUNTNAME"] forKey:@"C_ACCOUNTNAME"];//账号
//            
//            [KUSERDEFAULT setObject:self.nameTextfield.text forKey:@"nameText"];
//            [KUSERDEFAULT setObject:self.codeTextField.text forKey:@"passText"];
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_ABBREVATION"] forKey:@"C_ABBREVATION"];//C_ABBREVATION  经销商简称
//            
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"IS_BH"] forKey:@"IS_BH"];//拨号
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"IS_SJ"] forKey:@"IS_SJ"];//手机
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"IS_DH"] forKey:@"IS_DH"];//电话
//            
//            
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_INTERNAL"] forKey:@"C_INTERNAL"];//内部号码
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_EXTERNAL"] forKey:@"C_EXTERNAL"];//外部号码
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_FORWARD"] forKey:@"C_FORWARD"];//外部号码
//            
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_A50100_C_ID"] forKey:@"C_A50100_C_ID"];//微信营销id
//            [KUSERDEFAULT setObject:[dataDic objectForKey:@"C_ISGROUP"] forKey:@"C_ISGROUP"];//是否是集团   false
//            C_ISGROUP=[dataDic objectForKey:@"C_ISGROUP"];
//           
//            
//            NSString *CurrentDay=[MyUtil getCurrentDay];
//            [KUSERDEFAULT setObject:CurrentDay forKey:@"login_flag"];//保存当天时间
//            
//            [KUSERDEFAULT synchronize];
//            
//            
//            [self performSelectorOnMainThread:@selector(saveAction) withObject:nil waitUntilDone:YES];
//            
//            
//        }else
//        {
//            [KVNProgress showErrorWithStatus:[dataDic objectForKey:@"message"]];
//            
//        }
//        
//    }else{
//        
//        [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//        
//    }
//    
//    [KVNProgress dismiss];
//    
//}








@end
