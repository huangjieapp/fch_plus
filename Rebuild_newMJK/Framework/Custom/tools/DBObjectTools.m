//
//  DBObjectTools.m
//  Mcr_2
//
//  Created by 黄佳峰 on 2017/6/19.
//  Copyright © 2017年 bipi. All rights reserved.
//

#import "DBObjectTools.h"
#import "AdvertiseView.h"   //宏

#import "DBNavigationController.h"

#import "CustomerDetailInfoModel.h"

#import "ReportDetailViewController.h"  //h5 页面
#import "DetailWebviewViewController.h"
#import "MJKClueListViewController.h"
#import "CGCAppointmentListVC.h"
#import "CGCOrderListVC.h"
#import "MJKFlowListViewController.h"
#import "PotentailCustomerListViewController.h"
//#import "MJKOnlineMainHallViewController.h"     //在线展厅
#import "MJKAddFlowViewController.h"   //新增流量
#import "CreatRemindViewController.h"  //新增备忘
#import "AddOrEditlCustomerViewController.h"  //新增潜客
#import "MJKSettingViewController.h"   //设置
#import "WorkCalendarViewController.h"   //工作日历
//#import "WLBarcodeViewController.h"   //二维码
#import "BusinessRunningViewController.h"
#import "CGCBrokerCenterVC.h"//会员中心

#import "MJKFlowMeterViewController.h" // 流量仪

#import "AddNewNoticeViewController.h"   //新增公告
#import "NoticeInfoDetailViewController.h"  //公告列表
#import "ServiceTaskViewController.h"   //服务任务
#import "ServiceOrderListViewController.h"   //服务工单
#import "ShakeitViewController.h"
#import "AssistViewController.h"//协助客户
#import "MJKSchedulingViewController.h"//休假排班
#import "MJKWorkReportStatementsViewController.h"//日报报表
#import "MJKAttendReportViewController.h"//考勤报表
#import "MJKIntegralReportViewController.h"//积分报表


#import "CGCAppointmentListVC.h"//预约列表
#import "CGCOrderListVC.h"//订单列表
#import "ShowHelpViewController.h"
#import "MJKWorkReportViewController.h"//工作汇报

#import "CGCExpandVC.h"//推广
#import "CGCIntegralStoreVC.h"//积分商城
#import "CGCVerificationCenterVC.h"//核销中心
#import "CGCBrokerCenterVC.h"//经纪人中心
#import "CGCTemplateVC.h"
#import "MJKWorkWorldViewController.h"//工作圈
#import "MJKWorkWorldSignViewController.h"//打卡签到
#import "MJKAttendanceViewController.h"
#import "MJKReimbursementViewController.h"//费用报销
#import "MJKAddPayApplyViewController.h"//付款申请
#import "MJKNewSocialMarketViewController.h"//社群营销
#import "MJKSocialVisitorsViewController.h"//社群访客
#import "MJKShareFolderTabViewController.h"//共享文档
#import "MCRVehicleIdentifyViewController.h"//车辆识别
#import "MJKMaterialListViewController.h"
#import "MJKTaskClockViewController.h"//任务打卡
#import "MJKCheckViewController.h"//抽检
#import "MJKAfterManageViewController.h"
#import "MJKCustomerFeedbackViewController.h"
#import "MJKPerformanceViewController.h"
#import "MJKCarSourceHomeViewController.h"
#import "MJKApprolViewController.h"
#import "MJKRegisterManageViewController.h"
#import "MJKHighQualityManageViewController.h"
#import "MJKMortgageListViewController.h"
#import "MJKQualityAssuranceListViewController.h"
#import "MJKInsuranceListViewController.h"


#import "ViewControllerSJUITableViewCellPlayModel.h"



@implementation DBObjectTools

//得到地址的字典
+(NSMutableDictionary*)getAddressDicWithAction:(NSString*)action{
    NSInteger randomNumber=arc4random();
    NSString*randomStr=[NSString stringWithFormat:@"%lu",randomNumber];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:@"" forKey:@"gsonValue"];   //1
    [dic setObject:action forKey:@"action"];    //1
    [dic setObject:[NewUserSession instance].user.u051Id forKey:@"user_id"];    //“”1
    [dic setObject:[KUSERDEFAULT objectForKey:@"oldToken"] ?:[NewUserSession instance].TOKEN  forKey:@"appkey"];     //""1
    [dic setObject:@"S" forKey:@"appType"];   //1
    [dic setObject:randomStr forKey:@"nonceStr"]; //1
    [dic setObject:[DBTools getCurrentTimeStamp] forKey:@"timestamp"];//1  时间戳
    NSString*md5Str=[DBObjectTools getMD5StringWithdict:dic];
    [dic setObject:md5Str forKey:@"signature"];    //1
    return dic;
}


//得到md5 加密
+(NSString*)getMD5StringWithdict:(NSDictionary*)dict{
    NSString*str=[NSString stringWithFormat:@"appkey=%@&nonceStr=%@&timestamp=%@&gsonValue=%@",dict[@"appkey"],dict[@"nonceStr"],dict[@"timestamp"],dict[@"gsonValue"]];
    NSString*md5Str=[DBMD5Tool md5:str];
    
    return md5Str;
    
    
    
}


//得到cid
+(NSString*)getCID{
    //     RandomStr="A02600" + Applacations.mSharedPreferences.getString("UserId", "") + "-" + returnJson.TimeStep() + returnJson.ranCid();
    NSString*timeStamp=[DBTools getCurrentTimeStamp];
    NSInteger randomNumber=arc4random();
    NSString*randomStr=[NSString stringWithFormat:@"%lu",randomNumber];
    
    
    NSString*cid=[NSString stringWithFormat:@"A02600%@-%@%@",@"",timeStamp,randomStr];
    return cid;
}

//协助/设计师
//A47200
+(NSString*)getA47200C_id{
    NSString*c_id=[NSString stringWithFormat:@"A47200%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

+(NSString*)getA47700C_id{
	NSString*c_id=[NSString stringWithFormat:@"A47700%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
}

//得到潜客的c_id   A41500
+(NSString*)getPotentailcustomerC_id{
      NSString*c_id=[NSString stringWithFormat:@"A41500%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

+(NSString*)getA48100C_id{
    NSString*c_id=[NSString stringWithFormat:@"A48100%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//新增线索
+(NSString*)getA41300C_id{
    NSString*c_id=[NSString stringWithFormat:@"A41300%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//新流量处理完成@"A41400-%@"
+(NSString*)getA41400C_id{
    NSString*c_id=[NSString stringWithFormat:@"A41400%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//新怎节点
+(NSString*)getA47300C_id{
	NSString*c_id=[NSString stringWithFormat:@"A47300%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
}
//新增产品
+(NSString*)getA47100C_id{
	NSString*c_id=[NSString stringWithFormat:@"A47100%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
}


//新增考勤地点
+(NSString*)getA64900C_id{
	NSString*c_id=[NSString stringWithFormat:@"A64900%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
}
//A48600_新增汇报
+(NSString*)getA48600C_id{
	NSString*c_id=[NSString stringWithFormat:@"A48600%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
}

//得到跟进的C_id   A41600
+(NSString*)getVustomerFollowC_id{
    NSString*c_id=[NSString stringWithFormat:@"A41600%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
 
    
}

//得到新增公告的C_id   A42100
+(NSString*)getNoticeFollowC_id{
    NSString*c_id=[NSString stringWithFormat:@"A42100%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}

//得到交易id 的C_id   A04200
+(NSString*)getDealC_id{
    NSString*c_id=[NSString stringWithFormat:@"A04200%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;

    
}

/** 新增任务打卡A46400*/
+(NSString*)getA46400C_id{
	NSString*c_id=[NSString stringWithFormat:@"A46400%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
	
	
}

/** 汇报点赞A61200*/
+(NSString*)getWorkReportA61200{
    NSString*c_id=[NSString stringWithFormat:@"A61200%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
    
}

/**汇报评论A46500*/
+(NSString*)getWorkReportCommentsA46500{
	NSString*c_id=[NSString stringWithFormat:@"A46500%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
	
	
}


//新增服务任务的c_id    A01200
+(NSString*)getServiceTaskC_id{
    NSString*c_id=[NSString stringWithFormat:@"A01200%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;

    
}
//新增材料 其他配件的c_id  A04400
+(NSString*)getProductC_id{
    NSString*c_id=[NSString stringWithFormat:@"A04400%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;

    
}

//新增服务工单 其他配件的c_id  A01300
+(NSString*)getServiceOrderC_id{
    NSString*c_id=[NSString stringWithFormat:@"A01300%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}
//  经纪人的C_id   A47700
+(NSString*)brokerCenterC_id{
    NSString*c_id=[NSString stringWithFormat:@"A47700%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}

//新增摇一摇 签到的c_id C_A41600_C_ID
+(NSString*)getShakeSignInC_id{
    NSString*c_id=[NSString stringWithFormat:@"A41600%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}


//流量关联  流量的C_id   A41400_
+(NSString*)flowAboutC_id{
    NSString*c_id=[NSString stringWithFormat:@"A41400%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}
//C_A64900_C_ID 新增考勤
+(NSString*)getA64900_C_ID{
	NSString*c_id=[NSString stringWithFormat:@"A64900%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
	
}

//C_A47200_C_ID协助人
+(NSString*)getA47200_C_ID{
	NSString*c_id=[NSString stringWithFormat:@"A47200%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
	
}

//新增客户标签
+(NSString*)getA46600_C_ID{
	NSString*c_id=[NSString stringWithFormat:@"A46600%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
	
}

//新增标签
+(NSString*)getA46700_C_ID{
	NSString*c_id=[NSString stringWithFormat:@"A46700%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
	return c_id;
	
}

//A47800
+(NSString*)getA47800_C_ID{
    NSString*c_id=[NSString stringWithFormat:@"A47800%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}

///A49500
+(NSString*)getA49500_C_ID{
    NSString*c_id=[NSString stringWithFormat:@"A49500%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}
//A49600
+(NSString*)getA49600_C_ID{
    NSString*c_id=[NSString stringWithFormat:@"A49600%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
    
}

//新增机器人任务
+(NSString*)getA70100C_id{
    NSString*c_id=[NSString stringWithFormat:@"A70100-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//新增产品分类
//A70600
+(NSString*)getA70600C_id{
    NSString*c_id=[NSString stringWithFormat:@"A70600-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//A70800
+(NSString*)getA70800C_id{
    NSString*c_id=[NSString stringWithFormat:@"A70800-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//A43200
+(NSString*)getA43200C_id{
    NSString*c_id=[NSString stringWithFormat:@"A43200-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//A70900
+(NSString*)getA70900C_id{
    NSString*c_id=[NSString stringWithFormat:@"A70900-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//A71000
+(NSString*)getA71000C_id{
    NSString*c_id=[NSString stringWithFormat:@"A71000-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}

//A71300
+(NSString*)getA71300C_id{
    NSString*c_id=[NSString stringWithFormat:@"A71300-%@-%@",[NewUserSession instance].user.u051Id,[self ret8bitString]];
    return c_id;
}


//随机32位随机数
+(NSString *)ret8bitString {
    char data[8];
    for (int x=0;x<8;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:8 encoding:NSUTF8StringEncoding];
}


//随机18位随机数
+(NSString *)ret18bitString {
    char data[18];
    for (int x=0;x<18;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:18 encoding:NSUTF8StringEncoding];
}

//随机24位随机数
+(NSString *)ret20bitString {
    char data[20];
    for (int x=0;x<20;data[x++] = (char)('A' + (arc4random_uniform(26))));
    return [[NSString alloc] initWithBytes:data length:20 encoding:NSUTF8StringEncoding];
}

+(NSString*)getPostStringAddressWithMainDict:(NSDictionary*)dict withtype:(NSString*)type{
    NSString*urlStr;
//     if ([type isEqualToString:@"3"]){
//         //录音专用
//         urlStr=[NSString stringWithFormat:@"%@",HTTP_record_address];
//       
//     }else
    
         
//         if ([type isEqualToString:@"4"]){
//         //支付的地址
//         urlStr=[NSString stringWithFormat:@"%@",HTTP_addNewPayAdress];
//
//    }else{
//
//       
//    }
    
	if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
		urlStr=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[NSUserDefaults standardUserDefaults]objectForKey:@"url"] : HTTP_NewADDRESS];
	} else {
		urlStr=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[NSUserDefaults standardUserDefaults]objectForKey:@"url"] : HTTP_TestNewADDRESS];
	}
    
	
//	urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
	
    //    NSData*JsonData=[NSJSONSerialization JSONObjectWithData:dict options:NSJSONReadingAllowFragments error:nil];
    NSData*JsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString*jsonStr=[[NSString alloc]initWithData:JsonData encoding:NSUTF8StringEncoding];
    NSString*strAddress=[NSString stringWithFormat:@"%@?json=%@",urlStr,jsonStr];
    //    return strAddress;
    MyLog(@"参数为%@",strAddress);
    
    
//    NSString*encodeStr=[strAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString*encodeStr= [strAddress stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    
    return encodeStr;
    
}

+(NSString*)oldGetPostStringAddressWithMainDict:(NSDictionary*)dict withtype:(NSString*)type{
    NSString*urlStr;
    //     if ([type isEqualToString:@"3"]){
    //         //录音专用
    //         urlStr=[NSString stringWithFormat:@"%@",HTTP_record_address];
    //
    //     }else
    
    
    //         if ([type isEqualToString:@"4"]){
    //         //支付的地址
    //         urlStr=[NSString stringWithFormat:@"%@",HTTP_addNewPayAdress];
    //
    //    }else{
    //
    //
    //    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"formal"] isEqualToString:@"YES"]) {
        urlStr=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[NSUserDefaults standardUserDefaults]objectForKey:@"url"] : HTTP_ADDRESS];
    } else {
        urlStr=[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults]objectForKey:@"url"]length] > 0 ? [[NSUserDefaults standardUserDefaults]objectForKey:@"url"] : HTTP_TestADDRESS];
    }
    
    
    //    urlStr=[NSString stringWithFormat:@"%@",HTTP_ADDRESS];
    
    //    NSData*JsonData=[NSJSONSerialization JSONObjectWithData:dict options:NSJSONReadingAllowFragments error:nil];
    NSData*JsonData=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    NSString*jsonStr=[[NSString alloc]initWithData:JsonData encoding:NSUTF8StringEncoding];
    NSString*strAddress=[NSString stringWithFormat:@"%@?json=%@",urlStr,jsonStr];
    //    return strAddress;
    MyLog(@"参数为%@",strAddress);
    
    
    //    NSString*encodeStr=[strAddress stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString*encodeStr= [strAddress stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    
    
    return encodeStr;
    
}




#pragma mark --  跳转专用
+(void)pushVCWithName:(NSString*)name andSelf:(UIViewController *)mainVC{
    MyLog(@"---%@",name);
    
#pragma 报表
  /*  if ([name isEqualToString:@"客户报表"]) {
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypeCustomActive;
        [mainVC.navigationController pushViewController:vc animated:YES];

        
    }else if ([name isEqualToString:@"订单报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypeOrderStatus;
        [mainVC.navigationController pushViewController:vc animated:YES];

        
    }else if ([name isEqualToString:@"跟进报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypeFollow;
        [mainVC.navigationController pushViewController:vc animated:YES];

        
    }else if ([name isEqualToString:@"预约报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypeReserveStatus;
        [mainVC.navigationController pushViewController:vc animated:YES];

        
    }else if ([name isEqualToString:@"线索报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypeCrueSheet;
        [mainVC.navigationController pushViewController:vc animated:YES];

        
    }else if ([name isEqualToString:@"来电报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypePhoneSheet;
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"流量报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=webViewTypeFlowSheet;
        [mainVC.navigationController pushViewController:vc animated:YES];

    }
    */
    if ([name isEqualToString:@"流量报表"]) {
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.title = name;
        vc.webType=1;
        [mainVC.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"到店报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=4;
        vc.title = name;
        [mainVC.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"客户报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=0;
        vc.title = name;
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"交易报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=2;
        vc.title = name;
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"市场报表"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=3;
        vc.title = name;
        [mainVC.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"绩效榜单"]){
        ReportDetailViewController*vc=[[ReportDetailViewController alloc]init];
        vc.webType=5;
        vc.title = name;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"日报报表"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP012_0002"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKWorkReportStatementsViewController *vc = [[MJKWorkReportStatementsViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];

    } else if ([name isEqualToString:@"考勤报表"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP012_0001"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKAttendReportViewController *vc = [[MJKAttendReportViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"积分报表"]) {
        MJKIntegralReportViewController *vc = [[MJKIntegralReportViewController alloc]initWithNibName:@"MJKIntegralReportViewController" bundle:nil];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
    
    
 #pragma 模块
    if ([name isEqualToString:@"协助客户"]) {
        AssistViewController *vc = [[AssistViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
    if ([name isEqualToString:@"名单流量"]) {
        MJKClueListViewController *mjkClueVC = [[MJKClueListViewController alloc]init];
        [mainVC.navigationController pushViewController:mjkClueVC animated:YES];
    }else if ([name isEqualToString:@"预约管理"]){
        if (![[NewUserSession instance].storecode containsObject:@"crm:a416_yuyue:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        CGCAppointmentListVC * vc=[[CGCAppointmentListVC alloc] init];
        [mainVC.navigationController pushViewController:vc animated:YES];

    }else if ([name isEqualToString:@"订单管理"]){
        CGCOrderListVC * vc=[[CGCOrderListVC alloc] init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"门店流量"]) {
        MJKFlowListViewController * vc=[[MJKFlowListViewController alloc] init];
//        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//        [defaultCenter postNotificationName:kJPFNetworkDidReceiveMessageNotification object:nil userInfo:@{@"content" : @"你好"}];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"客户管理"]) {
       PotentailCustomerListViewController * vc=[[PotentailCustomerListViewController alloc] init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"车辆识别"]) {
        MCRVehicleIdentifyViewController *vc = [[MCRVehicleIdentifyViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"车源管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a823:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a823:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCarSourceHomeViewController *vc = [[MJKCarSourceHomeViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"审批管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a425:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a425:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKApprolViewController *vc = [[MJKApprolViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }else if ([name isEqualToString:@"工作日历"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:calendarl:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:calendarl:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        WorkCalendarViewController*vc=[[WorkCalendarViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"公司公告"]) {
        NoticeInfoDetailViewController*vc=[[NoticeInfoDetailViewController alloc]init];
        vc.type=noticeTypeManager;
        [mainVC.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([name isEqualToString:@"人脸识别"]) {
        MJKFlowMeterViewController *meterVC = [[MJKFlowMeterViewController alloc]init];
        [mainVC.navigationController pushViewController:meterVC animated:YES];
        
        
    }else if ([name isEqualToString:@"营业流水"]){
        //APP008_0013
        if (![[NewUserSession instance].appcode containsObject:@"APP008_0013"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        BusinessRunningViewController*vc=[[BusinessRunningViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"任务管理"]){
        ServiceTaskViewController*vc=[[ServiceTaskViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"服务工单"]){

        ServiceOrderListViewController*vc=[[ServiceOrderListViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    } else if ([name isEqualToString:@"工作汇报"]) {
        MJKWorkReportViewController *vc = [[MJKWorkReportViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"话术模板"]) {
//        DBSelf(weakSelf);
        UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *wechat = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
            myView.templateType=CGCTemplateWeiXin;
            DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
            [mainVC presentViewController:nav animated:YES completion:nil];
        }];
        UIAlertAction *message = [UIAlertAction actionWithTitle:@"短信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            CGCTemplateVC *myView=[[CGCTemplateVC alloc] init];
            myView.templateType=CGCTemplateMessage;
            DBNavigationController *nav=[[DBNavigationController alloc]initWithRootViewController:myView];
            [mainVC presentViewController:nav animated:YES completion:nil];
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertV addAction:cancel];
        [alertV addAction:message];
        [alertV addAction:wechat];
        [mainVC presentViewController:alertV animated:YES completion:nil];
    } else if ([name isEqualToString:@"休假排班"]) {
        //休假排班
        MJKSchedulingViewController *vc = [[MJKSchedulingViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];

    } else if ([name isEqualToString:@"工作圈"]) {
        MJKWorkWorldViewController *vc = [[MJKWorkWorldViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"打卡签到"]) {
        MJKWorkWorldSignViewController *vc = [[MJKWorkWorldSignViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"任务打卡"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a464:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a464:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKTaskClockViewController *vc = [[MJKTaskClockViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"粉丝管理"]) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a477:list"] && ![[NewUserSession instance].appcode containsObject:@"crm:a477_zj:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"抽检"]) {
        MJKCheckViewController *vc = [[MJKCheckViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"售后管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a815:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a815:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKAfterManageViewController *vc = [[MJKAfterManageViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"客服反馈"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a814:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a814:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCustomerFeedbackViewController *vc = [[MJKCustomerFeedbackViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"绩效进度"]) {
        if (![[NewUserSession instance].appcode containsObject:@"home:jixiaojindu"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKPerformanceViewController *vc = [[MJKPerformanceViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }  else if ([name isEqualToString:@"上牌管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a805:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        
        if (![[NewUserSession instance].appcode containsObject:@"crm:a805:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKRegisterManageViewController *vc = [[MJKRegisterManageViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"精品管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a806:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a806:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKHighQualityManageViewController *vc = [[MJKHighQualityManageViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"按揭管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a802:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a802:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKMortgageListViewController *vc = [[MJKMortgageListViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"质保管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a804:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a804:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKQualityAssuranceListViewController *vc = [[MJKQualityAssuranceListViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"保险管理"]) {
        if (![[NewUserSession instance].storecode containsObject:@"crm:a803:list"]) {
            [JRToast showWithText:@"请联系 脉车人 开通增强应用"];
            return;
        }
        if (![[NewUserSession instance].appcode containsObject:@"crm:a803:list"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKInsuranceListViewController *vc = [[MJKInsuranceListViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
        
    
    
    
    
#pragma 新增
    if ([name isEqualToString:@"新增流量"]){
        MJKAddFlowViewController*vc=[[MJKAddFlowViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
        
    }else if ([name isEqualToString:@"新增客户"]){
        AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
    }else if ([name isEqualToString:@"新增备忘"]){
        //添加 日历
        CreatRemindViewController*vc=[[CreatRemindViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];

        
        
    }else if ([name isEqualToString:@"新增公告"]){
        AddNewNoticeViewController*vc=[[AddNewNoticeViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
        
        
    }  else if ([name isEqualToString:@"推广素材"]) {
//        ViewControllerSJUITableViewCellPlayModel *vc = [[ViewControllerSJUITableViewCellPlayModel alloc]init];
//        CGCExpandVC *vc = [[CGCExpandVC alloc]init];
//        [mainVC.navigationController pushViewController:vc animated:YES];
        MJKMaterialListViewController *vc= [[MJKMaterialListViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"积分商城"]) {
        CGCIntegralStoreVC *vc = [[CGCIntegralStoreVC alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"核销中心"]) {
        CGCVerificationCenterVC * cvc=[[CGCVerificationCenterVC alloc] init];
        [mainVC.navigationController pushViewController:cvc animated:YES];
    } else if ([name isEqualToString:@"经纪人中心"]) {
        CGCBrokerCenterVC * cvc=[[CGCBrokerCenterVC alloc] init];
        cvc.type = BrokerCenterAgent;
        [mainVC.navigationController pushViewController:cvc animated:YES];
    } else if ([name isEqualToString:@"会员中心"]) {
        //会员客户
        if (![[NewUserSession instance].appcode containsObject:@"APP009_0011"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
        vc.type = BrokerCenterMembers;
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"费用报销"]) {
        MJKReimbursementViewController *vc = [[MJKReimbursementViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"付款申请"]) {
        MJKAddPayApplyViewController *vc = [[MJKAddPayApplyViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"社群营销"]) {
        MJKNewSocialMarketViewController *vc = [[MJKNewSocialMarketViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }  else if ([name isEqualToString:@"社群访客"]) {
        MJKSocialVisitorsViewController *vc = [[MJKSocialVisitorsViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    } else if ([name isEqualToString:@"共享文档"]) {
        MJKShareFolderTabViewController *vc = [[MJKShareFolderTabViewController alloc]init];
        [mainVC.navigationController pushViewController:vc animated:YES];
    }
        
    
    
    
    
    
#pragma 其他
    
     if ([name isEqualToString:@"在线展厅"]) {
//        MJKOnlineMainHallViewController *vc = [[MJKOnlineMainHallViewController alloc]init];//MJKOnlineMainHallViewController
//        NSArray *codeStr = [NewUserSession instance].appcode;
//        //权限待开，测试阶段需要开放
//         if ([codeStr containsObject:@"APP002_0012"]) {
//             [mainVC.navigationController pushViewController:vc animated:YES];
//         } else {
//             [JRToast showWithText:@"账号无权限"];
//             return;
//         }
        
     }else if ([name isEqualToString:@"微信营销"]){
         [JRToast showWithText:@"敬请期待"];
         
         
     }/*else if ([name isEqualToString:@"自媒体"]){
         [JRToast showWithText:@"敬请期待"];
         
         
         
     }*/else if ([name isEqualToString:@"资源中心"]){
         [JRToast showWithText:@"敬请期待"];
         
         
     }else if ([name isEqualToString:@"扫一扫"]){
         //相机权限
         
         AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
         
         if (authStatus ==AVAuthorizationStatusRestricted ||//此应用程序没有被授权访问的照片数据。可能是家长控制权限
             
             authStatus ==AVAuthorizationStatusDenied)  //用户已经明确否认了这一照片数据的应用程序访问
             
         {
             
             // 暂无权限 引导去开启
             UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"请开启相机权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                 
                 if ([[UIApplication sharedApplication]canOpenURL:url]) {
                     
                     [[UIApplication sharedApplication]openURL:url];
                     
                 }
                 
             }];
             
             UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                 
                 
             }];
             [alertV addAction:cancelAction];
             [alertV addAction:trueAction];
             [mainVC presentViewController:alertV animated:YES completion:nil];
             return;
             
         }
         [self showQRCodeViewWithVC:mainVC];
         
         
     }else if ([name isEqualToString:@"考勤签到"]){
    
         ShakeitViewController*shake=[[ShakeitViewController alloc]init];
         [mainVC.navigationController pushViewController:shake animated:YES];
         
         
     }else if ([name isEqualToString:@"设置"]){
         MJKSettingViewController *settingVC = [[MJKSettingViewController alloc]init];
         [mainVC.navigationController pushViewController:settingVC animated:YES];

         
         
     } else if ([name isEqualToString:@"考勤"]) {
         MJKAttendanceViewController *vc = [[MJKAttendanceViewController alloc]initWithNibName:@"MJKAttendanceViewController" bundle:nil];
         [mainVC.navigationController pushViewController:vc animated:YES];
     }
    
    
    
//    else {
//
//        [JRToast showWithText:[NSString stringWithFormat:@"%@???",name]];
//    }
  
}


//跳二维码
//+(void)showQRCodeViewWithVC:(UIViewController*)mainVC{
//
//    //二维码
//    WLBarcodeViewController*QRCode=[[WLBarcodeViewController alloc]initWithBlock:^(NSString *str, BOOL isSuccess) {
//
//        if (isSuccess) {
//            //成功
////            MyLog(@"%@",str);
////            UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"扫描结果" message:str preferredStyle:UIAlertControllerStyleAlert];
////            UIAlertAction*action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
////
////            }];
////            [alertVC addAction:action];
////            [mainVC presentViewController:alertVC animated:YES completion:nil];
//
//
//            [JRToast showWithText:str duration:5];
//
//
//        }else{
//            //
////            UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"扫描结果" message:@"无法识别" preferredStyle:UIAlertControllerStyleAlert];
////            UIAlertAction*action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
////
////            }];
////            [alertVC addAction:action];
////            [mainVC presentViewController:alertVC animated:YES completion:nil];
//
//            [JRToast showWithText:@"无法识别" duration:5];
//
//        }
//
//
//    }];
//
//    [mainVC presentViewController:QRCode animated:YES completion:nil];
//
//
//}



+(void)homePagePushVCWithTimeType:(NSString*)timeType andName:(NSString*)name andSelfView:(UIView*)selfView{
    NSString *nowTime =  [DBTools getTimeFomatFromCurrentTimeStampWithYMD];
    NSString *oneDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
    NSString *threeDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:2 andNowTime:oneDayTime];
    NSString *beforeOneDayTime =  [DBTools getBeforeTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
    UIViewController*mainVC=[DBTools getSuperViewWithsubView:selfView];
    
#pragma 今日待办任务
    if ([timeType isEqualToString:@"今日待办任务"]) {
        if ([name isEqualToString:@"客户跟进"]) {
            PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.timerType=customerListTimeTypeToday;
            [mainVC.navigationController pushViewController:vc animated:YES];
            
        }else if ([name isEqualToString:@"门店流量"]){
            MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
			vc.timerType = flowListTimeTypeToday;
			[mainVC.navigationController pushViewController:vc animated:YES];
            
        }else if ([name isEqualToString:@"名单下发"]){
            MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
			vc.timerType = clueListTimeTypeToday;
			[mainVC.navigationController pushViewController:vc animated:YES];
            
        }else if ([name isEqualToString:@"预约到店"]){
            
            CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
            cvc.IS_ARRIVE_SHOP  = @"未到店";
            cvc.C_TYPE_DD_ID = @"A41600_C_TYPE_0000";
            cvc.BOOK_START_TIME = [nowTime stringByAppendingString:@" 00:00:00"];
            cvc.BOOK_END_TIME = [nowTime stringByAppendingString:@" 23:59:59"];
            [mainVC.navigationController pushViewController:cvc animated:YES];

        }else if ([name isEqualToString:@"订单完工"] || [name isEqualToString:@"交付提醒"]){
            CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.startTime=@"1";
            cvc.statusID=@"0";
            [mainVC.navigationController pushViewController:cvc animated:YES];
            
        }else if ([name isEqualToString:@"粉丝互动"]){
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            [mainVC.navigationController pushViewController:vc animated:YES];
            
		} else if ([name isEqualToString:@"订单跟进"] || [name isEqualToString:@"订单回访"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
			cvc.LASTFOLLOW_TIME_TYPE=@"1";
			cvc.statusStr = @"今日";
			[mainVC.navigationController pushViewController:cvc animated:YES];
		} else if ([name isEqualToString:@"协助客户"]) {
			AssistViewController *vc = [[AssistViewController alloc]init];
			vc.XZCREATE_TIME_TYPE = @"1";
			vc.TYPE = @"0";
			[mainVC.navigationController pushViewController:vc animated:YES];
		} else if ([name isEqualToString:@"任务执行"]) {
			ServiceTaskViewController*vc=[[ServiceTaskViewController alloc]init];
			vc.status = @"3";
			vc.ORDER_TIME = @"1";
			[mainVC.navigationController pushViewController:vc animated:YES];
		}
    }
    
    
    
#pragma 后三天待办任务
    if ([timeType isEqualToString:@"后三天待办任务"]) {
        if ([name isEqualToString:@"客户跟进"]) {
            PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.timerType=customerListTimeTypeThreeDay;
            [mainVC.navigationController pushViewController:vc animated:YES];

            
        }else if ([name isEqualToString:@"预约到店"]){
           
            CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
            cvc.IS_ARRIVE_SHOP  = @"未到店";
            cvc.C_TYPE_DD_ID = @"A41600_C_TYPE_0000";
            cvc.BOOK_START_TIME = [oneDayTime stringByAppendingString:@" 00:00:00"];
            cvc.BOOK_END_TIME = [threeDayTime stringByAppendingString:@" 23:59:59"];
            [mainVC.navigationController pushViewController:cvc animated:YES];
            
        }else if ([name isEqualToString:@"订单完工"] || [name isEqualToString:@"交付提醒"]){
            CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.startTime=@"inThreeDays";
            cvc.statusID=@"0";
            [mainVC.navigationController pushViewController:cvc animated:YES];

            
		} else if ([name isEqualToString:@"订单跟进"] || [name isEqualToString:@"订单回访"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
			cvc.LASTFOLLOW_TIME_TYPE=@"inThreeDays";
			cvc.statusStr = @"后三天";
			[mainVC.navigationController pushViewController:cvc animated:YES];
		} else if ([name isEqualToString:@"任务执行"]) {
			ServiceTaskViewController*vc=[[ServiceTaskViewController alloc]init];
			vc.status = @"3";
			vc.ORDER_TIME = @"inThreeDays";
			[mainVC.navigationController pushViewController:vc animated:YES];
		}
        
        //ORDER_TIME_TYPE传inThreeDays,STATUS_TYPE传3
    }
    
    
#pragma 逾期未处理
    if ([timeType isEqualToString:@"逾期未处理"]) {
        if ([name isEqualToString:@"客户跟进"]) {
            PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
            vc.timerType=customerListTimeTypeOverDay;
            [mainVC.navigationController pushViewController:vc animated:YES];

            
            
        }else if ([name isEqualToString:@"门店流量"]){
			MJKFlowListViewController *vc = [[MJKFlowListViewController alloc]init];
			vc.timerType = flowListTimeTypeOverDay;
			[mainVC.navigationController pushViewController:vc animated:YES];
			
        }else if ([name isEqualToString:@"名单下发"]){
			MJKClueListViewController *vc = [[MJKClueListViewController alloc]init];
			vc.timerType = clueListTimeTypeOverDay;
			[mainVC.navigationController pushViewController:vc animated:YES];
			
        }else if ([name isEqualToString:@"预约到店"]){
            
            CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
            cvc.IS_ARRIVE_SHOP  = @"未到店";
            cvc.C_TYPE_DD_ID = @"A41600_C_TYPE_0000";
            cvc.BOOK_START_TIME = @"2000-01-01 00:00:00";
            cvc.BOOK_END_TIME = [beforeOneDayTime stringByAppendingString:@" 23:59:59"];
            [mainVC.navigationController pushViewController:cvc animated:YES];
            
        }else if ([name isEqualToString:@"订单完工"] || [name isEqualToString:@"交付提醒"]){
           
            CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
            cvc.endTime=[DBTools getProjectYesterdayTime];
            cvc.statusID=@"0";
            [mainVC.navigationController pushViewController:cvc animated:YES];
            
        }else if ([name isEqualToString:@"粉丝互动"]){
            CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
            vc.type = BrokerCenterMembers;
            [mainVC.navigationController pushViewController:vc animated:YES];
            
		} else if ([name isEqualToString:@"订单跟进"] || [name isEqualToString:@"订单回访"]) {
			CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
			cvc.LASTFOLLOW_END_TIME= [DBTools getProjectYesterdayTime];
			cvc.statusStr = @"逾期";
			[mainVC.navigationController pushViewController:cvc animated:YES];
		} else if ([name isEqualToString:@"任务执行"]) {
			ServiceTaskViewController*vc=[[ServiceTaskViewController alloc]init];
			vc.status = @"3";
			vc.ORDER_TIME_END = [DBTools getProjectYesterdayTime];
			[mainVC.navigationController pushViewController:vc animated:YES];
		}

        
        //ORDER_TIME_TYPE传昨天0点0分0秒,STATUS_TYPE传3
    }
    
}


#pragma mark  -- 广告位需要
/**
 *  下载新图片
 */
+ (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName andshoppingID:(NSString*)idd
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        
        NSString *filePath = [DBTools getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [KUSERDEFAULT setValue:imageName forKey:adImageName];
            if ([idd isEqualToString:@""]) {
                
            }else{
                [KUSERDEFAULT setValue:idd forKey:adUrl];
                
            }
            
            [KUSERDEFAULT synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}


/**
 *  删除旧图片
 */
+ (void)deleteOldImage
{
    NSString *imageName = [KUSERDEFAULT valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [DBTools getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
        [KUSERDEFAULT removeObjectForKey:adUrl];
    }
}

/**
 *  提示框 这个取消按钮或者确定按钮没有就传@“”
 */
+(UIAlertController *)getAlertVCwithTitle:(NSString *)title withMessage:(NSString *)Message clickCanel:(CANELCLICK)canelClick sureClick:(SURECLICK)sureClick canelActionTitle:(NSString * )ctitle sureActionTitle:(NSString * )stitle {
    
    UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:title message:Message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:ctitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (canelClick) {
            canelClick();
        }
    }];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:stitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (sureClick) {
            sureClick();
        }
    }];
    
    (ctitle.length>0)?[alertVC addAction:cancel]:0;
    (stitle.length>0)?[alertVC addAction:sure]:0;
    
    return alertVC;
}
//判断是否开启定位
+ (BOOL)isLocationServiceOpenWithSelfView:(UIView*)selfView {
    
    UIViewController*mainVC=[DBTools getSuperViewWithsubView:selfView];
    if ([ CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先开启定位功能\n设置-隐私-定位服务" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (@available(iOS 8.0,*)) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
            }
            } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:yesAction];
        [ac addAction:cancelAction];
        ac.modalPresentationStyle = UIModalPresentationFullScreen;
        [mainVC presentViewController:ac animated:YES completion:nil];
        return NO;
    } else {
        return YES;
    }
}


- (void)openLocation {
    if (@available(iOS 8.0,*)) {
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
    [[UIApplication sharedApplication] openURL:url];
    }
    } else {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
    }
}

#pragma mark - 文本宽高
/**得到宽高*/
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font width:(CGFloat) width{

    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
    
}
/**得到宽度*/
+(CGFloat)getTheWeithWithText:(NSString*)text withSize:(double)size{

    CGRect rect = [text boundingRectWithSize:CGSizeMake(10000, size) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    return rect.size.width;


}



+(void)httpPostGetCustomerDetailInfoWithC_ID:(NSString *)C_ID andCompleteBlock:(void(^)(CustomerDetailInfoModel *customerDetailModel))successBlock{
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    if (C_ID) {
        contentDict[@"C_ID"] = C_ID;
    }
   
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            CustomerDetailInfoModel *detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            if (successBlock) {
                successBlock(detailInfoModel);
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        
    }];
    
    
    
}

+ (void)whbCallWithC_OBJECT_ID:(NSString *)C_OBJECT_ID andC_CALL_PHONE:(NSString *)C_CALL_PHONE andC_NAME:(NSString *)C_NAME andC_OBJECTTYPE_DD_ID:(NSString *)C_OBJECTTYPE_DD_ID andCompleteBlock:(void(^)(void))successBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (C_OBJECT_ID.length > 0) {
        contentDic[@"C_OBJECT_ID"] = C_OBJECT_ID;
    }
    if (C_CALL_PHONE.length > 0) {
        contentDic[@"C_CALL_PHONE"] = C_CALL_PHONE;
    }
    if (C_NAME.length > 0) {
        contentDic[@"C_NAME"] = C_NAME;
    }
    if (C_OBJECTTYPE_DD_ID.length > 0) {
        contentDic[@"C_OBJECTTYPE_DD_ID"] = C_OBJECTTYPE_DD_ID;
    }
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a831/push", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (successBlock) {
                successBlock();
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


@end
