//
//  CGCAppiontDetailVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2017/8/31.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "CGCAppiontDetailVC.h"
#import "CGCNewAppointmentCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCAppiontTelCell.h"
#import "CGCAppointmentModel.h"
#import "CGCAlertDateView.h"

#import "CGCOperationalLog.h"

#import "CustomerDetailViewController.h"

#import "CustomerDetailInfoModel.h"
#import "CustomerFollowAddEditViewController.h"

#import "MJKShowSendView.h"
#import "MJKMessagePushNotiViewController.h"

#import "CGCAppointmentListVC.h"

@interface CGCAppiontDetailVC ()<UITableViewDelegate,UITableViewDataSource>
    @property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CGCAppointmentModel *detailModel;
@property (nonatomic, strong) CGCAlertDateView *alertDateView;

@end

@implementation CGCAppiontDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
    [self HTTPGetAppiontDetail];
    [self.view addSubview:self.tableView];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//	if ([self.assitStr isEqualToString:@"协助"]) {
//		[[NSUserDefaults standardUserDefaults] setObject:@"协助" forKey:@"VCName"];
//	}
}
    
#pragma mark -- createNav
- (void)createNav{
    if ([self.isDiss isEqualToString:@"未到店"]) {
         self.title=@"预约处理";
    }else{
         self.title=@"预约详情";
    }
   
    self.view.backgroundColor=CGCTABBGColor;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"23-顶右button" highImage:@"" isLeft:NO target:self andAction:@selector(appiontTimeList)];
   
}

    
#pragma mark -- createFoot
- (void)createFoot{

    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    UIButton * btn=[self btnWithY:20.0 title:@"已到店" withTag:111];
    UIButton * btn1=[self btnWithY:70.0 title:@"延期到店" withTag:222];
    UIButton * btn2=[self btnWithY:120.0 title:@"取消预约" withTag:333];
    
    [view addSubview:btn];
    [view addSubview:btn1];
    [view addSubview:btn2];
    
    self.tableView.tableFooterView=view;
}


- (UIButton *)btnWithY:(CGFloat)y title:(NSString *)title  withTag:(NSInteger)tag{

    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=CGRectMake(15, y, KScreenWidth-30, 40);
    [btn setTitleColor:DBColor(0, 0, 0)];
    [btn setTitleNormal:title];
    btn.tag=tag;
    btn.titleLabel.font=[UIFont systemFontOfSize:14];
    btn.backgroundColor=KNaviColor;
    btn.layer.cornerRadius=4.0;
    btn.layer.masksToBounds=YES;
    [btn addTarget:self action:@selector(footClick:)];
    return btn;

}
- (void)footClick:(UIButton *)btn{
    if(btn.tag==111){
		if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:dd"]) {
			[JRToast showWithText:@"账号无权限"];
			return ;
		}
      CGCAlertDateView *alertDate=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
            
        } withSureClick:^(NSString *title, NSString *dateStr) {
            if (dateStr.length>0) {
                
                NSMutableDictionary *dic=[NSMutableDictionary new];
				[dic setObject:self.C_ID forKey:@"C_ID"];
				[dic setObject:@"0" forKey:@"type"];
				[dic setObject:dateStr forKey:@"D_ARRIVE_TIME"];
				dateStr.length>0?[dic setObject:[dateStr substringFromIndex:title.length] forKey:@"X_REMARK"]:[dic setObject:@"" forKey:@"X_REMARK"];
                [self HTTPOperationInfo:dic];
            }
            
        } withHight:195.0 withText:@"请填写已到店信息" withDatas:nil];
        
        
        [self.view addSubview:alertDate];

        
    }
    if(btn.tag==222){
		if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:yq"]) {
			[JRToast showWithText:@"账号无权限"];
			return ;
		}
        CGCAlertDateView *alertDate=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
            
        } withSureClick:^(NSString *title, NSString *dateStr) {
            if (dateStr.length>0) {
                
                NSMutableDictionary *dic=[NSMutableDictionary new];
                [dic setObject:self.C_ID forKey:@"C_ID"];
                [dic setObject:@"1" forKey:@"type"];
//                [dic setObject:@"A41600_C_STATUS_0002" forKey:@"C_STATUS_DD_ID"];
                [dic setObject:dateStr forKey:@"D_ARRIVE_TIME"];
                [self HTTPOperationInfo:dic];
            }
            
        } withHight:150.0 withText:@"请填写延期到店信息" withDatas:nil];
        
        
        [self.view addSubview:alertDate];

    }
    if(btn.tag==333){
		if (![[NewUserSession instance].appcode containsObject:@"crm:a416_yuyue:qx"]) {
			[JRToast showWithText:@"账号无权限"];
			return ;
		}
        
        UIAlertController *alert=[DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"确认取消预约?" clickCanel:^{
            
        } sureClick:^{
            NSMutableDictionary *dic=[NSMutableDictionary new];
            [dic setObject:self.C_ID forKey:@"C_ID"];
            [dic setObject:@"2" forKey:@"type"];
//            [dic setObject:@"A41600_C_STATUS_0003" forKey:@"C_STATUS_DD_ID"];
            [self HTTPOperationInfo:dic];
        } canelActionTitle:@"取消" sureActionTitle:@"确定"];
        [self presentViewController:alert animated:YES completion:^{
            
        }];

    }

}

    
#pragma mark -- tableViewDelegate
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 16;
}
    
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGCNewAppointmentCell * cell=[CGCNewAppointmentCell cellWithTableView:tableView];
    cell.detailWidthLayout.constant = KScreenWidth - 120;
      [cell hidenIcon:indexPath];
    if (indexPath.row==0) {
        cell.rightCustomerImageView.hidden = NO;
        cell.leadingWith.constant = 20;
        cell.detailLab.text=self.detailModel.C_A41500_C_NAME;
    }
    if (indexPath.row==1) {
        CGCAppiontTelCell * cell=[CGCAppiontTelCell cellWithTableView:tableView];
        NSString *str;
        if (self.detailModel.C_PHONE.length > 0) {
            if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
                str = self.detailModel.C_PHONE;
            } else {
                str = [self.detailModel.C_PHONE stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
            }
            
        }
        cell.numLab.text=str;
        [cell.telBtn addTarget:self action:@selector(selectTelephone:)];
        return cell;
    }
    if (indexPath.row==2) {
        cell.detailLab.text=self.detailModel.C_SEX_DD_NAME;
    }
    if (indexPath.row==3) {
        cell.detailLab.text=self.detailModel.C_CLUESOURCE_DD_NAME;
    }
    if (indexPath.row==4) {
        cell.detailLab.text=self.detailModel.C_A41200_C_NAME;
    }
    if (indexPath.row==5) {
        cell.detailLab.text=self.detailModel.C_LEVEL_DD_NAME;
    }
    if (indexPath.row==6) {
        cell.detailLab.text=self.detailModel.C_YS_DD_NAME;
    }
    
    if (indexPath.row==7) {
        cell.detailLab.text=self.detailModel.C_PAYMENT_DD_NAME;
    }

    
    if (indexPath.row==8) {
        cell.detailLab.text=self.detailModel.D_CREATE_TIME;
    }

    
    if (indexPath.row==9) {
        cell.detailLab.text=self.detailModel.D_BOOK_TIME;
    }

    
    if (indexPath.row==10) {
        cell.detailLab.text=self.detailModel.C_MODEFOLLOW_DD_NAME;
    }

    
    if (indexPath.row==11) {
        cell.detailLab.text=self.detailModel.C_ISDRIVE_DD_NAME;
    }
    
    if (indexPath.row==12) {
        cell.detailLab.text=self.detailModel.IS_ARRIVE_SHOP;
    }
    
    if (indexPath.row==13) {
        cell.detailLab.text=self.detailModel.USER_NAME;
    }
    
    if (indexPath.row==14) {
        cell.detailLab.text=self.detailModel.D_ARRIVE_TIME;
    }
    


  
  
    
    if (indexPath.row==15) {
        CGCNewAppointTextCell * cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//        cell.remarkText.userInteractionEnabled=NO;
//        cell.remarkText.text=self.detailModel.X_REMARK;
//        cell.remarkLab.text=self.detailModel.X_REMARK;
        cell.textView.text=self.detailModel.X_REMARK;
        cell.textView.editable = NO;
        return cell;
    }
    
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
		//客户详情里输入框下面弹框内容，如果是协助就只有新增预约
       [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
		PotentailCustomerListDetailModel*mainModel=[[PotentailCustomerListDetailModel alloc]init];
        mainModel.C_A41500_C_ID=self.detailModel.C_A41500_C_ID;
        vc.mainModel=mainModel;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }
    
    
}


    
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==15) {
        return 100;
    }
    
    return 44;
}
    
#pragma mark -- touch
    
- (void)appiontTimeList{//导航右侧时钟按钮

    CGCOperationalLog * logVC=[[CGCOperationalLog alloc] init];
    logVC.C_ID=self.C_ID;
    [self.navigationController pushViewController:logVC animated:YES];
    
}
    

#pragma  mark --- 拨打电话
    //电话
- (void)telephoneCall:(NSInteger)index{
    if (self.detailModel.C_PHONE.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.detailModel.C_PHONE]]];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

- (void)whbcallBack:(NSInteger)index {
     if (self.detailModel.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:self.detailModel.C_ID andC_CALL_PHONE:self.detailModel.C_PHONE andC_NAME:self.detailModel.C_A41500_C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0006" andCompleteBlock:nil];
         
     } else {
        [JRToast showWithText:@"无电话号码"];
    }
   
}

- (void)closePhone {
    [self alertViewFollow];
}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
        infoModel.C_ID=weakSelf.detailModel.C_A41500_C_ID;
        infoModel.C_HEADIMGURL=weakSelf.detailModel.C_HEADIMGURL;
        infoModel.C_NAME=weakSelf.detailModel.C_A41500_C_NAME;
        infoModel.C_STAGE_DD_ID = weakSelf.detailModel.C_STAGE_DD_ID;
        infoModel.C_STAGE_DD_NAME = weakSelf.detailModel.C_STAGE_DD_NAME;
        infoModel.C_LEVEL_DD_NAME=weakSelf.detailModel.C_LEVEL_DD_NAME;
        infoModel.C_LEVEL_DD_ID=weakSelf.detailModel.C_LEVEL_DD_ID;
        
        
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpAdd;
        vc.infoModel=infoModel;
        vc.vcSuper=weakSelf;
        vc.followText=nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}

//座机
- (void)landLineCall:(NSInteger)index{
    
    NSString *buttonTitle = @"用座机拨打";
//        CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
//        myView.typeStr=buttonTitle;
//        myView.nameStr=C_PHONE;
//        myView.callStr=C_PHONE;
//        [self.navigationController pushViewController:myView animated:YES];
    
}
//回呼
- (void)callBack:(NSInteger)index{
    
    NSString *buttonTitle = @"回呼到手机";
    //    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    //    myView.typeStr=buttonTitle;
    //    myView.callStr=C_PHONE;
    //    [self.navigationController pushViewController:myView animated:YES];
    
}


    //回呼
- (void)callBack{
        
    
        
    
}
    
#pragma mark -- 网络请求 request
- (void)HTTPGetAppiontDetail{
    DBSelf(weakSelf);
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    [dic setObject:self.C_ID forKey:@"C_ID"];
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/info", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        [weakSelf.view addSubview:self.tableView];
        if ([data[@"code"] integerValue]==200) {
//            NSDictionary*dict=[data copy];
          
            weakSelf.detailModel=[CGCAppointmentModel yy_modelWithDictionary:data[@"data"]];
        }else{
            
          
            
            [JRToast showWithText:data[@"msg"]];
        }
        
        if ([weakSelf.detailModel.IS_ARRIVE_SHOP isEqualToString:@"未到店"]) {
            [weakSelf createFoot];
        }
        
        if ([weakSelf.detailModel.IS_ARRIVE_SHOP isEqualToString:@"未到店"]) {
            weakSelf.title=@"预约处理";
        }else{
            weakSelf.title=@"预约详情";
        }
        [weakSelf.tableView reloadData];
        
    }];
//    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        [self.view addSubview:self.tableView];
//        if ([data[@"code"] integerValue]==200) {
//            NSDictionary*dict=[data copy];
//
//          self.detailModel=[CGCAppointmentModel yy_modelWithDictionary:dict];
//        }else{
//
//
//
//            [JRToast showWithText:data[@"message"]];
//        }
//
//        if ([self.detailModel.IS_ARRIVE_SHOP isEqualToString:@"未到店"]) {
//            [self createFoot];
//        }
//
//        if ([self.detailModel.IS_ARRIVE_SHOP isEqualToString:@"未到店"]) {
//            self.title=@"预约处理";
//        }else{
//            self.title=@"预约详情";
//        }
//        [self.tableView reloadData];
//
//    }];
    

}


- (void)HTTPOperationInfo:(NSDictionary *)dic{
    DBSelf(weakSelf);
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/operation",HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        [weakSelf.view addSubview:weakSelf.tableView];
        if ([data[@"code"] integerValue]==200) {
            if ([dic[@"TYPE"] isEqualToString:@"0"]) {
                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0003"]) {//到店
                    [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.detailModel.C_A41500_C_ID andC_ID:weakSelf.C_ID andC_TYPE_DD_ID:@"A47500_C_YYTSDW_0003"];
                }  else {
                    if (weakSelf.reBlock) {
                        weakSelf.reBlock();
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                }
            } else if ([dic[@"TYPE"] isEqualToString:@"1"] && [dic[@"C_STATUS_DD_ID"] isEqualToString:@"A41600_C_STATUS_0003"]) {//取消预约
                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0001"]) {//取消
                    [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.detailModel.C_A41500_C_ID andC_ID:weakSelf.C_ID andC_TYPE_DD_ID:@"A47500_C_YYTSDW_0001"];
                }  else {
                    if (weakSelf.reBlock) {
                        weakSelf.reBlock();
                    }
                    
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
                
            } else if ([dic[@"TYPE"] isEqualToString:@"1"] && [dic[@"C_STATUS_DD_ID"] isEqualToString:@"A41600_C_STATUS_0002"]) {
               if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0002"]) {
                   //A47500_C_YYTSDW_0002
                   [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.detailModel.C_A41500_C_ID andC_ID:weakSelf.C_ID andC_TYPE_DD_ID:@"A47500_C_YYTSDW_0002"];
               }  else {
                   if (weakSelf.reBlock) {
                       weakSelf.reBlock();
                   }
                   
                   [weakSelf.navigationController popViewControllerAnimated:YES];
               }
            } else {
                if (weakSelf.reBlock) {
                    weakSelf.reBlock();
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];

}


- (void)pushInfoWithC_A41500_C_ID:(NSString *)C_A41500_C_ID andC_ID:(NSString *)C_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPushMsg"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    dic[@"C_OBJECTID"] = C_ID;
    dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            //            weakSelf.dataDic = data[@"content"];
            MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:@[@"否",@"是"] andTitle:@"" andMessage:@"是否给客户发送通知消息?"];
            showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                if ([str isEqualToString:@"否"]) {
                    if (self.reBlock) {
                        self.reBlock();
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    vc.dataDic = data[@"content"];
                    vc.C_A41500_C_ID = C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = C_TYPE_DD_ID;
                    vc.C_ID = C_ID;
                    if ([C_TYPE_DD_ID isEqualToString:@"A47500_C_YYTSDW_0001"]) {
                        vc.titleNameXCX = @"预约取消通知";
                    } else if ([C_TYPE_DD_ID isEqualToString:@"A47500_C_YYTSDW_0002"]) {
                        vc.titleNameXCX = @"预约延期通知";
                    } else {
                        vc.titleNameXCX = @"预约到店通知";
                    }
                    vc.backActionBlock = ^{
//                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
//                            if ([vc isKindOfClass:[CGCAppointmentListVC class]]) {
//                                [weakSelf.navigationController popToViewController:vc animated:YES];
//                            } else if ([vc isKindOfClass:[CustomerDetailViewController class]]) {
                                [weakSelf.navigationController popToViewController:weakSelf.rootVC animated:YES];
//                            }
//                        }
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
//            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0001"]) {//取消
//                [weakSelf.view addSubview:showView];
//            } else if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_YYTSDW_0002"]) {
                [weakSelf.view addSubview:showView];
//            } else {
//                if (self.reBlock) {
//                    self.reBlock();
//                }
//
//                [self.navigationController popViewControllerAnimated:YES];
//            }
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}


#pragma mark -- set
- (UITableView *)tableView{
    
    if (_tableView==nil) {
        _tableView=[[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc] init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        if ([self.isDiss isEqualToString:@"未到店"]) {
//            [self createFoot];
//        }

    }
    
    return _tableView;
}


#pragma mark -- otherDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    
}


@end
