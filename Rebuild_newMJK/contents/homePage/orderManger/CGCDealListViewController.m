//
//  CGCDealListViewController.m
//  mcr_sh_master
//
//  Created by FishYu on 2017/8/25.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "CGCDealListViewController.h"

#import "CGCNewDealView.h"

@interface CGCDealListViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) CGCNewDealView * dealView;//更多操作弹层

@property (nonatomic,copy) NSString * money;//金额

@property (nonatomic,copy) NSString * remark;//备注

@end

@implementation CGCDealListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"新增交易";
    [self.view addSubview:self.dealView];
    
}


#pragma mark --- 请求二维码图片
- (void)request{
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    
    [dic setObject:@"1" forKey:@"trade_amount"];
    [dic setObject:self.orderId forKey:@"merchant_order_no"];
    [dic setObject:@"" forKey:@"remark"];
    [dic setObject:[UserSession instance].user_id forKey:@"user_id"];
    
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"4"];
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager getDataFromNetworkWithUrl:encodeUrlStr parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
    
}

#pragma mark -- set
- (CGCNewDealView *)dealView{
    
    if (_dealView==nil) {
        _dealView=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CGCNewDealView class]) owner:self options:nil] lastObject];
        _dealView.frame=CGRectMake(0, 64, KScreenWidth, KScreenHeight-64);
        
        _dealView.moneyLab.keyboardType=UIKeyboardTypeDecimalPad;
        _dealView.remarksTextField.keyboardType=UIKeyboardTypeDefault;
        _dealView.moneyLab.delegate=self;
        _dealView.remarksTextField.delegate=self;
        _dealView.moneyLab.tag=111;
        _dealView.remarksTextField.tag=222;
        _dealView.scanBgView.hidden=YES;
        [_dealView.wxBtn addTarget:self action:@selector(btnClick:)];
        [_dealView.zfBtn addTarget:self action:@selector(btnClick:)];
        [_dealView.xjBtn addTarget:self action:@selector(btnClick:)];
        [_dealView.xyBtn addTarget:self action:@selector(btnClick:)];
        [_dealView.finishBtn addTarget:self action:@selector(HTTPsubmitDate)];
    }
    return _dealView;
}


#pragma mark --- HTTPRequest
- (void)HTTPsubmitDate{
    
    if (self.money.length==0||[self.money intValue]==0) {
        [JRToast showWithText:@"请输入金额"];
        return;
    }
    if (self.orderId.length==0) {
        [JRToast showWithText:@"订单不存在"];
        return;
    }
    
    NSMutableDictionary *dic=[DBObjectTools getAddressDicWithAction:HTTP_CGC_A04200WebServiceinsert];
    
    NSMutableDictionary *dic1=[NSMutableDictionary new];
    NSString * C_A04200_C_ID=[DBObjectTools getVustomerFollowC_id];
    [dic1 setObject:C_A04200_C_ID forKey:@"C_A04200_C_ID"];
    [dic1 setObject:self.orderId forKey:@"C_ORDER_ID"];
    [dic1 setObject:self.money forKey:@"B_AMOUNT"];
    self.remark.length>0?[dic1 setObject:self.remark forKey:@"X_REMARK"]:[dic1 setObject:@"" forKey:@"X_REMARK"];
    
    [dic setObject:dic1 forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.tabBlock) {
                self.tabBlock();
            }
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            
            
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
    
}

#pragma mark --  几种支付方法的点击事件
- (void)btnClick:(UIButton *)btn{
    
    if (self.remark.length==0) {
        
        [JRToast showWithText:@"请输入金额"];
        return;
    }
    
    
    if (btn.tag==1111) {
        _dealView.scanBgView.hidden=NO;
        self.dealView.wxBtn.selected=YES;
        self.dealView.payTitleLab.text=@"微信收款";
        self.dealView.scanClueLab.text=@"使用微信'扫一扫'向商户付款";
        self.dealView.scanBgView.layer.borderColor=CGCWEiXINColor.CGColor;
        self.dealView.payBgView.backgroundColor=CGCWEiXINColor;
    }else{
        self.dealView.wxBtn.selected=NO;
    }
    
    if (btn.tag==2222) {
        _dealView.scanBgView.hidden=NO;
        self.dealView.zfBtn.selected=YES;
        self.dealView.payTitleLab.text=@"支付宝收款";
        self.dealView.scanClueLab.text=@"使用微信'扫一扫'向商户付款";
        self.dealView.scanBgView.layer.borderColor=CGCZHIFUBAOColor.CGColor;
        self.dealView.payBgView.backgroundColor=CGCZHIFUBAOColor;
    }else{
        self.dealView.zfBtn.selected=NO;
    }
    
    if (btn.tag==3333) {
        self.dealView.xjBtn.selected=YES;
        self.dealView.scanBgView.layer.borderColor=[UIColor clearColor].CGColor;
        self.dealView.payBgView.backgroundColor=[UIColor clearColor];
        self.dealView.scanClueLab.hidden=YES;
        self.dealView.xjClueLab.hidden=NO;
        self.dealView.xjClueLab.text=@"收到现金，即可点击完成本次交易";
        
    }else{
        self.dealView.xjBtn.selected=NO;
        self.dealView.xjClueLab.hidden=YES;
        
    }
    
    if (btn.tag==4444) {
        _dealView.scanBgView.hidden=NO;
        self.dealView.xyBtn.selected=YES;
        self.dealView.payTitleLab.text=@"信用卡收款";
        self.dealView.scanBgView.layer.borderColor=[UIColor blackColor].CGColor;
        self.dealView.payBgView.backgroundColor=[UIColor blackColor];
        self.dealView.xyCardLab.hidden=NO;
    }else{
        self.dealView.xyBtn.selected=NO;
        self.dealView.xyCardLab.hidden=YES;
    }
}


#pragma mark --- textfileDelegate


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag==111) {
        
        self.money=textField.text;
        
    }
    if (textField.tag==222) {
        
        self.remark=textField.text;
        
    }
    
}

@end
