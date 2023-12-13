//
//  VerificationDetailVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/5/16.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "VerificationDetailVC.h"
#import "VerificationCell.h"
#import "VerificationHeadView.h"
#import "PointorderModel.h"
#import "CGCVerificationDetailModel.h"

//#import "WLBarcodeViewController.h"
#import "MQVC.h"

#import "CGCTemplateVC.h"
#import "CommonCallViewController.h"


@interface VerificationDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) VerificationHeadView  *headView;

@property (nonatomic, strong) CGCVerificationDetailModel *detailModel;

//@property (nonatomic, strong) WLBarcodeViewController*QRCodeVC;

@end

@implementation VerificationDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"订单详情";
    [self HttpGetDetail];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

- (void)HttpGetDetail{
    DBSelf(weakSelf);
    if (self.pModel.sid.length==0) {
        [KVNProgress showErrorWithStatus:@"订单不存在"];
        return;
    }
    NSMutableDictionary * dict=[NSMutableDictionary dictionary];
    [dict setValue:self.pModel.sid forKey:@"id"];
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_getCancelAfterVerificationInfo dict:dict target:self finished:^(id responsed) {
        if ([responsed[@"code"] intValue]==200) {
             weakSelf.detailModel=[CGCVerificationDetailModel yy_modelWithJSON:responsed[@"content"]];
          
        }else{
            [KVNProgress showErrorWithStatus:responsed[@"message"]];
        }
         [self.tableView reloadData];
         [self reloadHead];
    } failed:^(id error) {
        [KVNProgress showErrorWithStatus:@"网络请求失败"];
    }];
}


- (void)reloadHead{
    [self.headView.headImg sd_setImageWithURL:[NSURL URLWithString:self.detailModel.product_img] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.headView.nameLab.text=self.detailModel.product_name;
    self.headView.storeLab.text=self.detailModel.storename;
    self.headView.timeLab.text=self.detailModel.showTime;
}

- (void)httpRequestQRCodeWithStr:(NSString *)codeStr{
    
    

    NSArray * arr=  [codeStr componentsSeparatedByString:@","];
    
    for (NSString * str in arr) {
        if (str.length==0) {
            [JRToast showWithText:@"扫码失败"];
            return;
        }
    }
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:arr[0] forKey:@"phone"];
    [dic setObject:arr[1] forKey:@"takecode"];
    [dic setObject:arr[2] forKey:@"id"];
    
    
    [[POPRequestManger defaultManger] requestWithMethod:POST url:HTTP_pointTake dict:dic target:self finished:^(id responsed) {
        if ([responsed[@"code"] intValue]==200) {
            
            [JRToast showWithText:@"核销成功"];
            [self performSelector:@selector(backQR) withObject:self afterDelay:1.0];
        }else{
           
        }
      
        
    } failed:^(id error) {
       
    }];
}


- (void)backQR{
    DBSelf(weakSelf);
//    [self.QRCodeVC dismissViewControllerAnimated:NO completion:^{
//        if (weakSelf.hxBlock) {
//            weakSelf.hxBlock();
//        }
//        [self.navigationController popViewControllerAnimated:NO];
//    }];
}

//- (void)verificationClick:(UIButton *)btn{
//
//    DBSelf(weakSelf);
//
//    WLBarcodeViewController*QRCode=[[WLBarcodeViewController alloc]initWithBlock:^(NSString *str, BOOL isSuccess) {
//
//        if (isSuccess) {
//            //成功
//            MyLog(@"%@",str);
//
//            [weakSelf httpRequestQRCodeWithStr:str];
//
//        }else{
//            //
//
//
//            [JRToast showWithText:@"无法识别" duration:5];
//
//
//        }
//
//
//    }];
//    self.QRCodeVC=QRCode;
//
//    QRCode.isType=@"isOk";
//    QRCode.qrBlock = ^{
//        [weakSelf goMQ];
//    };
//    [self presentViewController:QRCode animated:YES completion:nil];
//
//
//
//
//
//
//
//
//}


- (void)goMQ{
//    [self.QRCodeVC dismissViewControllerAnimated:NO completion:^{
//
//    }];
    MQVC * mvc=[[MQVC alloc] init];
    mvc.sid=self.detailModel.sid;
    mvc.phone=self.detailModel.consumer_phone;
    [self.navigationController pushViewController:mvc animated:NO];
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake( 0, 0, WIDE, HIGHT-SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.backgroundColor=CGCTABBGColor;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
       
        _tableView.tableHeaderView=self.headView;
        
        UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDE, 80)];
        view.backgroundColor=[UIColor whiteColor];
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor]];
        btn.frame=CGRectMake(20, 20, WIDE-40, 40);
        [btn setTitleNormal:@"扫码核销"];
        btn.backgroundColor=CGCTABBGColor;
        [btn addTarget:self action:@selector(verificationClick:)];
        btn.layer.borderColor=[UIColor blackColor].CGColor;
        btn.layer.borderWidth=1;
        btn.layer.cornerRadius=4;
        btn.layer.masksToBounds=YES;
        [view addSubview:btn];
        if ([self.pModel.status isEqualToString:@"未兑换"]) {
            _tableView.tableFooterView=view;
        }
       
        
    }
    
    return _tableView;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    VerificationCell * cell=[VerificationCell cellWithTableView:tableView];
        cell.titLab.text=@[@[@"产品名称",@"订单备注"],@[@"使用积分",@"支付金额"]][indexPath.section][indexPath.row];
    if (self.detailModel!=nil) {
        cell.desLab.text=@[@[self.detailModel.product_name,self.detailModel.product_remark],@[self.detailModel.take_code,self.detailModel.product_price]][indexPath.section][indexPath.row];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    return 50;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) {
        return 2;
    }
    return  2;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}



- (NSMutableArray *)dataArray{
    
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (VerificationHeadView *)headView{
    DBSelf(weakSelf);
    if (_headView==nil) {
        _headView=[VerificationHeadView getView];
      
        
        _headView.verBlock = ^(NSString *titStr) {
            if ([titStr isEqualToString:@"电话"]) {
                [weakSelf selectTelephone:0];
            }
            if ([titStr isEqualToString:@"短信"]) {
                [weakSelf messClick];
            }
            if ([titStr isEqualToString:@"微信"]) {
                [weakSelf wxClick];
            }
        };
        
    }
    return  _headView;
}


//电话
- (void)telephoneCall:(NSInteger)index{
//    if (self.detailModel.C_PHONE.length>0) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:self.detailModel.C_PHONE]]];
//    }
    
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
//    myView.nameStr=self.detailModel.C_NAME;
//    myView.callStr=self.detailModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
//    myView.nameStr=self.detailModel.C_NAME;
//    myView.callStr=self.detailModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//短信
- (void)messClick{
    
    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
    vc.templateType=CGCTemplateMessage;
    vc.titStr=self.detailModel.consumer_name;
    vc.customPhoneArr=[@[self.detailModel.consumer_phone] mutableCopy];
    vc.cusDetailModel.C_ID=self.detailModel.consumer_id;
//    vc.cusDetailModel.C_HEADIMGURL=self.detailModel.C_HEADIMGURL;
    vc.cusDetailModel.C_NAME=self.detailModel.consumer_name;
//    vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailModel.C_LEVEL_DD_NAME;
//    vc.cusDetailModel.C_LEVEL_DD_ID=self.detailModel.C_LEVEL_DD_ID;
    [self.navigationController pushViewController:vc animated:YES];

    
}

//微信
- (void)wxClick{
    
    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
    vc.templateType=CGCTemplateWeiXin;
    vc.titStr=self.detailModel.consumer_name;
//    vc.customIDArr=[@[self.mainModel.C_A41500_C_ID] mutableCopy];
    vc.cusDetailModel.C_ID=self.detailModel.consumer_id;
//    vc.cusDetailModel.C_HEADIMGURL=self.detailInfoModel.C_HEADIMGURL;
    vc.cusDetailModel.C_NAME=self.detailModel.consumer_name;
//    vc.cusDetailModel.C_LEVEL_DD_NAME=self.detailInfoModel.C_LEVEL_DD_NAME;
//    vc.cusDetailModel.C_LEVEL_DD_ID=self.detailInfoModel.C_LEVEL_DD_ID;
    [self.navigationController pushViewController:vc animated:YES];
    
}




@end
