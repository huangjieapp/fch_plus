//
//  SHMineViewController.m
//  mcr_sh_master
//
//  Created by 黄佳峰 on 2017/7/6.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "SHMineViewController.h"
#import "SHMineTopTableViewCell.h"
#import "MJKNewGroupShopsViewController.h"


#import "MJKSettingViewController.h"
#import "PersonInfoViewController.h"
#import "RegardingMJKViewController.h"

#import "ReporterViewController.h"

#import "ShakeitViewController.h"//考勤签到
#import "WorkCalendarViewController.h"//工作日历
//#import "WLBarcodeViewController.h"//扫一扫
#import "MJKSchedulingViewController.h"//休假排班
#import "MJKWorkReportStatementsViewController.h"//工作汇报报表
#import "DBWebViewController.h"


#import "MJKUpdatePasswordView.h"
#import "MJKSetTypeViewController.h"


#import "MJKQrCodeViewController.h"


//#import "MinePersonDataViewController.h"
//#import "AboutIntroductionViewController.h"
//#import "NewMySettingViewController.h"

#import "SHLoginViewController.h"

#import "MJKOtherLoginViewController.h"
#import "MJKBusinessCardSetViewController.h"
#import "WXApi.h"


#define CELL0    @"SHMineTopTableViewCell"
@interface SHMineViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;

@property(nonatomic,strong)NSMutableArray*localDatas;
/** <#注释#> */
@property (nonatomic, strong) MJKUpdatePasswordView *passwordView;

@end

@implementation SHMineViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];

    [self rightItemUI];
//    if ([[NewUserSession instance].C_ISGROUP isEqualToString:@"true"]) {
//        [self changeCustomerShop];
//    }
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight - SafeAreaBottomHeight - TabbarDeHeight - 59, KScreenWidth - 40, 50)];
    [button setTitleNormal:@"切换集团下属门店"];
    [button setTitleColor:[UIColor whiteColor]];
    button.layer.cornerRadius = 5.f;
    [button setBackgroundColor:[UIColor colorWithHex:@"#F5CD63"]];
    [button addTarget:self action:@selector(changeLAction)];
    if (![[NewUserSession instance].user.groupType isEqualToString:@"U03100_C_ISGROUP_0001"]) {
        [self.view addSubview:button];
    }
	
}

- (void)changeLAction {
    MJKNewGroupShopsViewController *vc = [[MJKNewGroupShopsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  --UI
-(void)rightItemUI{
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
	[button setTitleNormal:@"修改密码"];
	[button addTarget:self action:@selector(clickChangeCode)];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button setTitleColor:[UIColor blackColor]];
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:button];
    item.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=item;
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.localDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray*array=self.localDatas[section];
    return array.count;
    
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
         cell.selectionStyle=0;
    }
    
    
    if (indexPath.section==0) {
        SHMineTopTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
        cell.refresh=NO;
        cell.selectionStyle=0;
        [cell.qrcodeButton addTarget:self action:@selector(clickQrcodeAction)];

        return cell;
    }
	
    
    NSDictionary*dict=self.localDatas[indexPath.section][indexPath.row];
    cell.imageView.image=[UIImage imageNamed:dict[@"image"]];
    cell.textLabel.text=dict[@"title"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    
    
//    if (indexPath.section==1&&indexPath.row==0) {
//        //座机呼转
//        UISwitch*switchButton=[[UISwitch alloc]initWithFrame:CGRectMake(KScreenWidth-70, 7, 60, 10)];
//        //判断是否打开
//        if ([[NewUserSession instance].C_FORWARD isEqualToString:@"false"]) {
//            [switchButton setOn:NO];
//        }else{
//             [switchButton setOn:YES];
//        }
//
//
//
//        [switchButton addTarget:self action:@selector(clickSwitch:) forControlEvents:UIControlEventValueChanged];
//        [cell addSubview:switchButton];
//        cell.accessoryType=UITableViewCellAccessoryNone;
//
//    }
	
    
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    if (indexPath.section==0&&indexPath.row==0) {
        PersonInfoViewController*vc=[[PersonInfoViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
//	/* else if (indexPath.section==1&&indexPath.row==0){
//        //资源中心
//
//
//    }*/ else if (indexPath.section==1&&indexPath.row==0){
//        //考勤签到
//        ShakeitViewController *vc = [[ShakeitViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//	}  else if (indexPath.section == 1 && indexPath.row == 1) {
//		//工作汇报报表
//		if (![[NewUserSession instance].appcode containsObject:@"APP012_0002"]) {
//			[JRToast showWithText:@"账号无权限"];
//			return;
//		}
//		MJKWorkReportStatementsViewController *vc = [[MJKWorkReportStatementsViewController alloc]init];
//		[self.navigationController pushViewController:vc animated:YES];
//	} else if (indexPath.section == 1 && indexPath.row == 2) {
//		//休假排班
//		MJKSchedulingViewController *vc = [[MJKSchedulingViewController alloc]init];
//		[self.navigationController pushViewController:vc animated:YES];
//	} else if (indexPath.section == 1 && indexPath.row == 3) {
//        //工作日历
//        WorkCalendarViewController*vc=[[WorkCalendarViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if (indexPath.section == 1 && indexPath.row == 1) {
//        [JRToast showWithText:@"敬请期待"];
        //扫一扫
        //二维码
        //相机权限

//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//
//        if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
//
//            authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
//
//        {
//
//            // 无权限 引导去开启
//            UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"请开启相机权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//
//                if ([[UIApplication sharedApplication]canOpenURL:url]) {
//
//                    [[UIApplication sharedApplication]openURL:url];
//
//                }
//
//            }];
//
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//
//            }];
//            [alertV addAction:cancelAction];
//            [alertV addAction:trueAction];
//            [self presentViewController:alertV animated:YES completion:nil];
//            return;
//
//        }
//
//        WLBarcodeViewController*QRCode=[[WLBarcodeViewController alloc]initWithBlock:^(NSString *str, BOOL isSuccess) {
//
//            if (isSuccess) {
//                //成功
//                MyLog(@"%@",str);
//                if (str.length > 0) {
//                    if ([str hasPrefix:@"DP"] || [str hasPrefix:@"dp"]) {
//                        MJKOtherLoginViewController *vc = [[MJKOtherLoginViewController alloc]init];
//                        vc.deviceID = str;
//                        [weakSelf.navigationController pushViewController:vc animated:YES];
//                    }
//                }
//            }else{
//                [JRToast showWithText:@"无法识别" duration:5];
//            }
//        }];
//
//        [self presentViewController:QRCode animated:YES completion:nil];
//    }
	else if (indexPath.section==1&&indexPath.row==0){
        //关于脉车人
        RegardingMJKViewController*vc=[[RegardingMJKViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (indexPath.section==1&&indexPath.row==1){
        //设置
		MJKSetTypeViewController *vc = [[MJKSetTypeViewController alloc]init];
		
//		MJKSettingViewController *settingVC = [[MJKSettingViewController alloc]init];
		[self.navigationController pushViewController:vc animated:YES];
//        NewMySettingViewController *myView=[[NewMySettingViewController alloc]initWithNibName:@"NewMySettingViewController" bundle:nil];
//        [self.navigationController pushViewController:myView animated:YES];

        
    }
    
    
    
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 90;
    }else{
        return 44;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}



#pragma mark  --touch
- (void)clickQrcodeAction {
#warning xiugai
//    if ([[NewUserSession instance].I_MP boolValue] == 0) {
//        MJKBusinessCardSetViewController *vc = [[MJKBusinessCardSetViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
//        [self HTTPCardData];
//    }
    MJKQrCodeViewController *vc = [[MJKQrCodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
    

//点击修改密码
-(void)clickChangeCode{
//    
    DBSelf(weakSelf);
    MJKUpdatePasswordView *passwordView = [[NSBundle mainBundle]loadNibNamed:@"MJKUpdatePasswordView" owner:nil options:nil].firstObject;
	[[UIApplication sharedApplication].keyWindow addSubview:passwordView];
    self.passwordView = passwordView;
	
    passwordView.backPasswordBlock = ^(NSString *oldCode, NSString *newCode) {
    
        [weakSelf changeCodeWithNewCode:newCode withOldCode:oldCode];
	};
}


-(void)clickSwitch:(UISwitch*)sender{
   BOOL isOn=sender.isOn;
    DBSelf(weakSelf);
    
    if (isOn) {
        //打开
        MyLog(@"打开");
        //
        NSString*showStr=[NSString stringWithFormat:@"是否将电话转至%@",[NewUserSession instance].user.phonenumber];
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:showStr preferredStyle:UIAlertControllerStyleAlert];
       UIAlertAction*action0=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           [sender setOn:NO];
           
       }];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           //吊接口 更改当前的号码
            [weakSelf changePhoneSetWithType:YES andswitch:sender];
        }];
        [alertVC addAction:action0];
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];
        
        
        
        
        
        
        
    }else{
        //关闭
        MyLog(@"关闭");
        NSString*showStr=[NSString stringWithFormat:@"是否关闭电话呼转至手机"];
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:showStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*action0=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [sender setOn:YES];
            
        }];
        UIAlertAction*action1=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //吊接口 更改当前的号码
            [weakSelf changePhoneSetWithType:NO andswitch:sender];
            
        }];
        [alertVC addAction:action0];
        [alertVC addAction:action1];
        [self presentViewController:alertVC animated:YES completion:nil];

        
        
        
    }
    
}

#pragma mark  --getDatas
- (void)HTTPCardData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-qrcodeToCard"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"C_ID"] = [NewUserSession instance].user.u051Id;
    dic[@"appid"] = [NewUserSession instance].C_APPID;
    dic[@"appsecret"] = [NewUserSession instance].C_APPSECRET;
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            MJKCardView *cardView = [[NSBundle mainBundle]loadNibNamed:@"MJKCardView" owner:nil options:nil].firstObject;
            cardView.rootVC = weakSelf;
            __block MJKCardView *cardViewBlock = cardView;
            [cardView.qrcodeImageView sd_setImageWithURL:[NSURL URLWithString:data[@"qrcode"]]];
            cardView.qrCodeStr = data[@"qrcode"];
            cardView.vcName = @"我的";
            cardView.editButtonActionBlock = ^(UIImage *image){
                MJKBusinessCardSetViewController *vc = [[MJKBusinessCardSetViewController alloc]init];
                vc.presonImage = image;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                [cardViewBlock removeFromSuperview];
            };
            cardView.showButtonActionBlock = ^{
                WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
               launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
               launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/homepage/homepage?usertoken=%@&accountid=%@&phone=%@",[NewUserSession instance].accountId,[NewUserSession instance].user.u051Id,[NewUserSession instance].user.phonenumber] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
               launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
               [WXApi sendReq:launchMiniProgramReq  completion:nil];
            };
            [[UIApplication sharedApplication].keyWindow addSubview:cardView];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

//选中了 就是改成呼叫到手机   没选中就是座机
-(void)changePhoneSetWithType:(BOOL)isSelected andswitch:(UISwitch*)sender{
    NSString*C_PHONE=[NewUserSession instance].user.phonenumber;
    NSString*C_INTERNAL=[NewUserSession instance].user.C_INTERNAL;
    
    NSString *urlStr;
    if (isSelected) {
        urlStr=[NSString stringWithFormat:@"%@C_PHONE=%@&C_INTERNAL=%@",HTTP_PhoneAddress,C_PHONE,C_INTERNAL];

    }else{
        
        urlStr=[NSString stringWithFormat:@"%@C_PHONE=&C_INTERNAL=%@",HTTP_PhoneAddress,C_INTERNAL];

    }
    
    HttpManager*manager=[[HttpManager alloc]init];
//    [manager getDataFromNetworkNoHudWithUrl:urlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        
//        
//    }];
    
    NSString *str1 = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager postDataFromNetworkNoHudWithUrl:str1 parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (!sender.on) {
                [KUSERDEFAULT setObject:@"false" forKey:@"C_FORWARD"];
                [KUSERDEFAULT synchronize];
                [NewUserSession instance].C_FORWARD=@"false";
                
            }else{
                [KUSERDEFAULT setObject:@"true" forKey:@"C_FORWARD"];
                [KUSERDEFAULT synchronize];
                [NewUserSession instance].C_FORWARD=@"true";

                
            }
            
            
        }else{
            [sender setOn:!sender.on];
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
}

-(void)httpUnlockWeChat{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47700WebService-updateWeChat"];
    NSDictionary*dict=@{};
    [mainDict setObject:dict forKey:@"content"];
    NSString*params=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:params parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"解除成功,请在名片编辑中重新开通名片绑定微信。"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
-(void)changeCodeWithNewCode:(NSString*)newCode withOldCode:(NSString*)oldCode{
    DBSelf(weakSelf);
    [weakSelf changeNewCodeWithNewCode:newCode withOldCode:oldCode];
 
}

-(void)changeNewCodeWithNewCode:(NSString*)newCode withOldCode:(NSString*)oldCode{
    NSMutableDictionary*mainDict=[NSMutableDictionary dictionary];
    mainDict[@"oldPassword"] = oldCode;
    mainDict[@"newPassword"] = newCode;
    
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/system/updatePwd", HTTP_IP] parameters:mainDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
            [weakSelf.passwordView removeFromSuperview];
            [KUSERDEFAULT removeObjectForKey:saveLoginCode];
            [NewUserSession cleanUser];
            
            
        }else{
             [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
    
    
    
    
    
}

- (void)changeCustomerShop {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, KScreenHeight - 60 - TabbarDeHeight - SafeAreaBottomHeight, KScreenWidth - 20, 40)];
	[button setTitle:@"切换经销商" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.backgroundColor = KNaviColor;
	button.layer.masksToBounds = YES;
	button.layer.cornerRadius = 5.f;
	[self.view addSubview:button];
	[button addTarget:self action:@selector(changeCoustomerShopAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeCoustomerShopAction {
	ReporterViewController *myView=[[ReporterViewController alloc]initWithNibName:@"ReporterViewController" bundle:nil];
	UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:myView];
	[self presentViewController:nav animated:YES completion:nil];
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

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

-(NSMutableArray *)localDatas{
    if (!_localDatas) {
        _localDatas=[NSMutableArray array];
        NSDictionary*dict=@{};
        NSArray*array0=@[dict];
        
//        NSDictionary*dictt0=@{@"image":@"资源中心",@"title":@"资源中心"};
        NSDictionary*dictt1=@{@"image":@"考勤签到",@"title":@"考勤签到"};
		NSDictionary*dictt5=@{@"image":@"工作汇报报表图标黄色",@"title":@"日报报表"};
		NSDictionary*dictt4=@{@"image":@"休假排班",@"title":@"休假排班"};
        NSDictionary*dictt2=@{@"image":@"工作日历",@"title":@"工作日历"};
        NSDictionary*dictt3=@{@"image":@"扫一扫",@"title":@"扫一扫"};
        NSArray*array1=@[/*dictt0,*/dictt1,dictt5,dictt4,dictt2,/*dictt3*/];   //dictt0
        
        NSDictionary*dictttt0=@{@"image":@"logo-2",@"title":@"关于房车汇5.0"};
        NSDictionary*dictttt1=@{@"image":@"设置-1",@"title":@"设置"};
        NSDictionary*dictttt2=@{@"image":@"扫一扫",@"title":@"扫一扫"};
        NSArray*array2=@[dictttt0,dictttt1];
        
        [_localDatas addObject:array0];
//        [_localDatas addObject:array1];
        [_localDatas addObject:array2];
        
        
        
    }
    
    return _localDatas;
}


@end
