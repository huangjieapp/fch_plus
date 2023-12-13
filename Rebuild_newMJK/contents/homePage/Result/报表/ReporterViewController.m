//
//  ReporterViewController.m
//  mcr_s
//
//  Created by bipyun on 16/12/7.
//  Copyright © 2016年 match. All rights reserved.
//

#import "ReporterViewController.h"
//#import "HttpPost.h"
#import "MBProgressHUD.h"
#import "KVNProgress.h"
//#import "MyUtil.h"
//#import "JSONKit.h"
#import "repoterTableViewCell.h"
#import "RepoterListViewController.h"
//#import "TabBarViewController.h"
//#import "LoginViewController.h"
#import "SHLoginViewController.h"
#import "DBTabBarViewController.h"
@interface ReporterViewController ()<MBProgressHUDDelegate>
{

    MBProgressHUD *mbprogress;
    NSMutableArray *dateArray;
    NSString * C_GRPCODE;
    NSString *C_ORGCODE;
    NSString *C_LOCCODE;
    
}
@end

@implementation ReporterViewController
-(void)viewWillAppear:(BOOL)animated
{

    self.navigationController.navigationBarHidden=YES;
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    mbprogress = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:mbprogress];
    mbprogress.delegate = self;
    mbprogress.color=[UIColor whiteColor];
    dateArray=[[NSMutableArray alloc]init];
     [self refersh];
    
}
-(void)refersh
{
    [mbprogress show:YES];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self gethttpValues];
	});
//    dispatch_after([MyUtil set_dispatch_time:0.3], dispatch_get_main_queue(), ^{
//
//    });
	
}

#pragma mark 无数据时cell分割线隐藏
-(void)setExtraCellLineHidden: (UITableView *)tableView

{
    
    UIView *view = [UIView new];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    
}
-(void)gethttpValues
{
    
	NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:@"A40300WebService-getDealerList"];
	
	NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
	[dic1 setObject:@"1" forKey:@"currPage"];
	[dic1 setObject:@"10" forKey:@"pageSize"];

	[dic setObject:dic1 forKey:@"content"];
	
	
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
			itemsArray=[data objectForKey:@"content"];
			
			for (NSDictionary *contentDic in itemsArray) {
				
				[dateArray addObject:contentDic];
			}
			self.labelName.text=[NSString stringWithFormat:@"%@",[data objectForKey:@"count"]];

			
		}else{
			[JRToast showWithText:data[@"message"]];
			//
			if ([[data objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
				UIWindow *window = [UIApplication sharedApplication].keyWindow;
				//首页界面
				SHLoginViewController *myView=[[SHLoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
				window.rootViewController=myView;
			}
		}
		[mbprogress hide:YES];
		[self.mainTab reloadData];
		
	}];
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:@"A40300WebService-getDealerList" forKey:@"action"];
//    [dic setObject:[MyUtil getuser_id] forKey:@"user_id"];
//    [dic setObject:@"" forKey:@"gsonValue"];
//    [dic setObject:[MyUtil getuser_token] forKey:@"appkey"];
//    [dic setObject:@"S" forKey:@"appType"];
//    NSInteger arc=[MyUtil getRandomNumber];
//    [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//    [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//    [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
//    NSMutableDictionary *dic1=[NSMutableDictionary new];
//    [dic1 setObject:[NSString stringWithFormat:@"%d",currPage] forKey:@"currPage"];
//    [dic1 setObject:@"10" forKey:@"pageSize"];
//    [dic setObject:dic1 forKey:@"content"];
//
//
//    NSString *str=[dic JSONString];
//    NSString *respone=[HttpPost getPost:str];
//    if (![respone isEqualToString:@""])
//    {
//
//        NSDictionary *  dataDic1 = [respone objectFromJSONString];
//
//        NSString *errcode = [dataDic1 objectForKey:@"code"];
//        if ([errcode isEqualToString:@"200"]) {
//
//            NSMutableArray *itemsArray=[[NSMutableArray alloc]init];
//            itemsArray=[dataDic1 objectForKey:@"content"];
//
//            for (NSDictionary *contentDic in itemsArray) {
//
//                [dateArray addObject:contentDic];
//            }
//            self.labelName.text=[NSString stringWithFormat:@"%@",[dataDic1 objectForKey:@"count"]];
//        }else
//        {
//            [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//
//            if ([[dataDic1 objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                //首页界面
//                LoginViewController *myView=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//                window.rootViewController=myView;
//            }
//
//        }
//
//    }else{
//
//        [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//
//    }
	
	
   
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return dateArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    repoterTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"repoterTableViewCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dic=[dateArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=[dic objectForKey:@"C_NAME"];
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic=[dateArray objectAtIndex:indexPath.row];
    C_GRPCODE=[dic objectForKey:@"GRPCODE"];
    C_ORGCODE=[dic objectForKey:@"ORGCODE"];
    C_LOCCODE=[dic objectForKey:@"LOCCODE"];
    
    [mbprogress show:YES];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[self gosunmitValues];
	});
//    dispatch_after([MyUtil set_dispatch_time:0.3], dispatch_get_main_queue(), ^{
//
//    });
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
    
}

-(void)gosunmitValues
{
    
    
//    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
//    [dic setObject:@"UserWebService-synchronizeUserCommon" forKey:@"action"];
//    [dic setObject:[MyUtil getuser_id] forKey:@"user_id"];
//    [dic setObject:@"" forKey:@"gsonValue"];
//    [dic setObject:[MyUtil getuser_token] forKey:@"appkey"];
//    [dic setObject:@"S" forKey:@"appType"];
//    NSInteger arc=[MyUtil getRandomNumber];
//    [dic setObject:[NSString stringWithFormat:@"%li",arc]  forKey:@"nonceStr"];//随机数
//    [dic setObject:[MyUtil getMD5String] forKey:@"signature"];//MD5
//    [dic setObject:[MyUtil getCurrentTimeStamp] forKey:@"timestamp"];//时间戳
//    NSMutableDictionary *dic1=[NSMutableDictionary new];
//    [dic1 setObject:C_GRPCODE forKey:@"C_GRPCODE"];
//    [dic1 setObject:[MyUtil getuser_id] forKey:@"user_id"];
//    [dic1 setObject:C_ORGCODE forKey:@"C_ORGCODE"];
//    [dic1 setObject:C_LOCCODE forKey:@"C_LOCCODE"];
//    [dic setObject:dic1 forKey:@"content"];
//
//
//    NSString *str=[dic JSONString];
//    NSString *respone=[HttpPost getPost:str];
//    if (![respone isEqualToString:@""])
//    {
//
//        NSDictionary *  dataDic1 = [respone objectFromJSONString];
//
//        NSString *errcode = [dataDic1 objectForKey:@"code"];
//        if ([errcode isEqualToString:@"200"]) {
//
//            [KVNProgress showSuccessWithStatus:[dataDic1 objectForKey:@"message"]];
//
//            TabBarViewController *tabbar=[[TabBarViewController alloc]initWithNibName:@"TabBarViewController" bundle:nil];
//            [self presentViewController:tabbar animated:YES completion:nil];
//
//        }else
//        {
//            [KVNProgress showErrorWithStatus:[dataDic1 objectForKey:@"message"]];
//            if ([[dataDic1 objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
//                UIWindow *window = [UIApplication sharedApplication].keyWindow;
//                //首页界面
//                LoginViewController *myView=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//                window.rootViewController=myView;
//            }
//        }
//
//    }else{
//
//        [KVNProgress showErrorWithStatus:[MyUtil getMessage]];
//
//    }
	
	NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:@"UserWebService-synchronizeUserCommon"];
	
	NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
	[dic1 setObject:C_GRPCODE forKey:@"C_GRPCODE"];
	[dic1 setObject:[NewUserSession instance].user.u051Id forKey:@"user_id"];
	[dic1 setObject:C_ORGCODE forKey:@"C_ORGCODE"];
	[dic1 setObject:C_LOCCODE forKey:@"C_LOCCODE"];

	[dic setObject:dic1 forKey:@"content"];
	
	
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			DBTabBarViewController*tab=[[DBTabBarViewController alloc]initWithNibName:@"DBTabBarViewController" bundle:nil];
			[self presentViewController:tab animated:YES completion:nil];
			
			
		}else{
			[JRToast showWithText:data[@"message"]];
			//
			if ([[data objectForKey:@"message"] isEqualToString:@"该账号已在其他地方登陆"]) {
				UIWindow *window = [UIApplication sharedApplication].keyWindow;
				//首页界面
				SHLoginViewController *myView=[[SHLoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
				window.rootViewController=myView;
			}
		}
		
		[mbprogress hide:YES];
	}];
	
	
    
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

- (IBAction)reporterbutton:(id)sender {
    RepoterListViewController *myView=[[RepoterListViewController alloc]initWithNibName:@"RepoterListViewController" bundle:nil];
    myView.type=@"reoprt";
    [self.navigationController pushViewController:myView animated:YES];
}
@end
