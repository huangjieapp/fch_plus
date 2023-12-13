//
//  DocumentSignViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/10.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "DocumentSignViewController.h"
#import "ContractSignViewController.h"
#import "ViewTheContractViewController.h"

#import "CustomerInputTableViewCell.h"
#import "CustomerChooseTableViewCell.h"
#import "CustomerRemarkTableViewCell.h"

#import "PotentailCustomerEditModel.h"
#import "CGCOrderDetailModel.h"

@interface DocumentSignViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *submitButton;

/** <#注释#> */
@property (nonatomic, strong) CGCOrderDetailModel *orderModel;
@end

@implementation DocumentSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"交车文件签署";
    @weakify(self);
    
    [self getDetailVales];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-55-AdaptSafeBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[CustomerInputTableViewCell class] forCellReuseIdentifier:@"CustomerInputTableViewCell"];
    [_tableView registerClass:[CustomerChooseTableViewCell class] forCellReuseIdentifier:@"CustomerChooseTableViewCell"];
    [_tableView registerClass:[CustomerRemarkTableViewCell class] forCellReuseIdentifier:@"CustomerRemarkTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    _submitButton = [UIButton new];
    [self.view addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5 -AdaptSafeBottomHeight);
        make.height.mas_equalTo(50);
    }];
    [_submitButton setBackgroundColor:KNaviColor];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = KSuperBigFont;
    _submitButton.layer.cornerRadius = 5.f;
    
    
    [[_submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
//            ContractSignViewController *vc = [ContractSignViewController new];
//        vc.C_ID = self.orderModel.C_ID;
//            [self.navigationController pushViewController:vc animated:YES];
        
        [self updateOrderInfo];
    }];
    
}

- (void)updateOrderInfo {
    DBSelf(weakSelf);
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length <= 0) {
                if ([model.locatedTitle isEqualToString:@"开票单位(销售)"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"合同编号"] ||
                    [model.locatedTitle isEqualToString:@"车款开票价"] ||
                    [model.locatedTitle isEqualToString:@"销售电话"] ||
                    [model.locatedTitle isEqualToString:@"服务费"] ||
                    [model.locatedTitle isEqualToString:@"配件款"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
            }
        }
    }
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *a801 = [NSMutableDictionary dictionary];
    NSMutableDictionary *htpojo = [NSMutableDictionary dictionary];
    
    for (NSArray *arr in self.localDatas) {
        for (int i = 0; i < arr.count; i++) {
            PotentailCustomerEditModel *model = arr[i];
            if (model.postValue.length > 0) {
                if (i != 6) {
                    if ([model.locatedTitle isEqualToString:@"开票类型"] ||
                        [model.locatedTitle isEqualToString:@"有无授权委托书"] ||
                        [model.locatedTitle isEqualToString:@"有无代付款证明"] ||
                        [model.locatedTitle isEqualToString:@"有无特殊情况告知书"] ||
                        [model.locatedTitle isEqualToString:@"车款开票价"] ||
                        [model.locatedTitle isEqualToString:@"个人"] ||
                        [model.locatedTitle isEqualToString:@"身份证号"] ||
                        [model.locatedTitle isEqualToString:@"收件人"] ||
                        [model.locatedTitle isEqualToString:@"收件电话"] ||
                        [model.locatedTitle isEqualToString:@"特殊情况告知"]) {
                        a801[model.keyValue] = model.postValue;
                    } else if ([model.locatedTitle isEqualToString:@"开票单位(销售)"]) {
                        htpojo[model.keyValue] = model.postValue;
                    } else {
                        if ([model.locatedTitle isEqualToString:@"车身及内饰颜色"]) {
                            NSArray *arr = [model.postValue componentsSeparatedByString:@"/"];
                            if (arr.count == 2) {
                                contentDic[@"C_A823N_COLOR"] = arr[0];
                                contentDic[@"C_A823W_COLOR"] = arr[1];
                            }
                        } else {
                            contentDic[model.keyValue] = model.postValue;
                        }
                    }
                }
            }
        }
    }
        
    
    a801[@"C_ID"] = self.orderModel.a801.C_ID;
    
    if (htpojo.allKeys.count > 0) {
        a801[@"htPojo"] = htpojo;
    }
    
    if (a801.allKeys.count > 0) {
        contentDic[@"a801"] = a801;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/api/crm/a420/edit", HTTP_IP];
    contentDic[@"C_ID"] = self.orderModel.C_ID;
    
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:path parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            ContractSignViewController *vc = [ContractSignViewController new];
            vc.C_ID = self.orderModel.C_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getLocalData {
    NSMutableArray*localArr0=[NSMutableArray arrayWithObjects:@"购车类型",@"开票类型",@"有无授权委托书",@"有无代付款证明",@"有无特殊情况告知书", nil] ;
    NSMutableArray *localValueArr0=[NSMutableArray arrayWithObjects:self.orderModel.C_PURCHASEWAY_DD_NAME ?: @"",
                                    self.orderModel.a801.C_FP_TYPE_NAME ?: ([self.orderModel.C_PURCHASEWAY_DD_ID isEqualToString:@"A42000_C_PURCHASEWAY_0001"] ? @"个人发票" : @""),
                                    self.orderModel.a801.I_SFSQWT ? ([self.orderModel.a801.I_SFSQWT isEqualToString:@"0"] ? @"无" : @"有") : @"无",
                                    self.orderModel.a801.I_SFDFK ? ([self.orderModel.a801.I_SFDFK isEqualToString:@"0"] ? @"无" : @"有") : @"无",
                                    self.orderModel.a801.I_GZD ? ([self.orderModel.a801.I_GZD isEqualToString:@"0"] ? @"无" : @"有") : @"无", nil];
    NSMutableArray *localPostNameArr0=[NSMutableArray arrayWithObjects:self.orderModel.C_PURCHASEWAY_DD_ID ?: @"",
                                       self.orderModel.a801.C_FP_TYPE ?: ([self.orderModel.C_PURCHASEWAY_DD_ID isEqualToString:@"A42000_C_PURCHASEWAY_0001"] ? @"A801_C_FP_TYPE_0000" : @""),
                                       self.orderModel.a801.I_SFSQWT ?: @"0",
                                       self.orderModel.a801.I_SFDFK ?: @"0",
                                       self.orderModel.a801.I_GZD ?: @"0", nil];
    NSMutableArray *localKeyArr0=[NSMutableArray arrayWithObjects:@"C_PURCHASEWAY_DD_ID",@"C_FP_TYPE",@"I_SFSQWT",@"I_SFDFK",@"I_GZD", nil];
    
    
    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
    
    NSMutableArray*localArr1=[NSMutableArray arrayWithObjects:@"开票单位(销售)",@"合同编号",@"车款开票价",@"销售电话",@"服务费",@"配件款", nil] ;
    NSMutableArray *localValueArr1=[NSMutableArray arrayWithObjects:self.orderModel.a801.htPojo.C_FQFGSZT_NAME ?: @"",
                                    self.orderModel.C_VOUCHERID ?: @"",
                                    self.orderModel.a801.B_KPJ ?: @"",
                                    self.orderModel.C_OWNER_PHONE ?: @"",
                                    self.orderModel.B_SERVICEFEE ?: @"",
                                    self.orderModel.B_BOUTIQUE_COST ?: @"", nil];
    NSMutableArray *localPostNameArr1=[NSMutableArray arrayWithObjects:self.orderModel.a801.htPojo.C_FQFGSZT_ID ?: @"",
                                       self.orderModel.C_VOUCHERID ?: @"",
                                       self.orderModel.a801.B_KPJ ?: @"",
                                       self.orderModel.C_OWNER_PHONE ?: @"",
                                       self.orderModel.B_SERVICEFEE ?: @"",
                                       self.orderModel.B_BOUTIQUE_COST ?: @"", nil];
    NSMutableArray *localKeyArr1=[NSMutableArray arrayWithObjects:@"C_FQFGSZT_ID",@"C_VOUCHERID",@"B_KPJ",@"C_OWNER_PHONE",@"B_SERVICEFEE",@"B_BOUTIQUE_COST", nil];

    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }
    NSMutableArray*localArr2;
    NSMutableArray *localValueArr2;
    NSMutableArray *localPostNameArr2;
    NSMutableArray *localKeyArr2;
    if ([self.orderModel.C_PURCHASEWAY_DD_ID isEqualToString:@"A42000_C_PURCHASEWAY_0001"]) {//个人购车
        localArr2=[NSMutableArray arrayWithObjects:@"个人",@"身份证号", nil] ;
        localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_GR ?: @"",
                                        self.orderModel.a801.C_FP_SFZ ?: @"", nil];
        localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_GR ?: @"",
                                           self.orderModel.a801.C_FP_SFZ ?: @"", nil];
         localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_GR",@"C_FP_SFZ", nil];
    } else {
        if ([self.orderModel.a801.C_FP_TYPE isEqualToString:@"A801_C_FP_TYPE_0001"]) {//普票
            localArr2=[NSMutableArray arrayWithObjects:@"开票单位(购买)",@"单位税号", nil] ;
            localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                            self.orderModel.a801.C_FP_TAX ?: @"", nil];
            localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                               self.orderModel.a801.C_FP_TAX ?: @"", nil];
             localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_COMPANY",@"C_FP_TAX", nil];
        } else if ([self.orderModel.a801.C_FP_TYPE isEqualToString:@"A801_C_FP_TYPE_0002"]) {//专票
            localArr2=[NSMutableArray arrayWithObjects:@"开票单位(购买)",@"单位税号",@"单位联系电话",@"单位联系地址",@"开户行",@"账号", nil] ;
            localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                            self.orderModel.a801.C_FP_TAX ?: @"",
                                            self.orderModel.a801.C_FP_PHONE ?: @"",
                                            self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                            self.orderModel.a801.C_FP_BANK ?: @"",
                                            self.orderModel.a801.C_FP_ACCOUNT ?: @"", nil];
            localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                               self.orderModel.a801.C_FP_TAX ?: @"",
                                               self.orderModel.a801.C_FP_PHONE ?: @"",
                                               self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                               self.orderModel.a801.C_FP_BANK ?: @"",
                                               self.orderModel.a801.C_FP_ACCOUNT ?: @"", nil];
             localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_COMPANY",@"C_FP_TAX",@"C_FP_PHONE",@"C_FP_ADDRESS",@"C_FP_BANK",@"C_FP_ACCOUNT", nil];
        } else if ([self.orderModel.a801.C_FP_TYPE isEqualToString:@"A801_C_FP_TYPE_0003"]) {//电专
            localArr2=[NSMutableArray arrayWithObjects:@"开票单位(购买)",@"单位税号",@"单位联系电话",@"单位联系地址",@"开户行",@"账号",@"邮箱", nil] ;
            localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                            self.orderModel.a801.C_FP_TAX ?: @"",
                                            self.orderModel.a801.C_FP_PHONE ?: @"",
                                            self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                            self.orderModel.a801.C_FP_BANK ?: @"",
                                            self.orderModel.a801.C_FP_ACCOUNT ?: @"",
                            self.orderModel.a801.C_FP_EMAIL ?: @"", nil];
            localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                               self.orderModel.a801.C_FP_TAX ?: @"",
                                               self.orderModel.a801.C_FP_PHONE ?: @"",
                                               self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                               self.orderModel.a801.C_FP_BANK ?: @"",
                                               self.orderModel.a801.C_FP_ACCOUNT ?: @"",
                               self.orderModel.a801.C_FP_EMAIL ?: @"", nil];
             localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_COMPANY",@"C_FP_TAX",@"C_FP_PHONE",@"C_FP_ADDRESS",@"C_FP_BANK",@"C_FP_ACCOUNT",@"C_FP_EMAIL", nil];
        }
    }
    
    NSMutableArray*saveLocalArr2=[NSMutableArray array];
    for (int i=0; i<localArr2.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr2[i];
        model.nameValue=localValueArr2[i];
        model.postValue=localPostNameArr2[i];
        model.keyValue=localKeyArr2[i];
        
        [saveLocalArr2 addObject:model];
    }
    
    NSMutableArray*localArr3=[NSMutableArray arrayWithObjects:@"交付日期",@"公里数",@"类型",@"品牌",@"车型",@"车身及内饰颜色",@"发动机",@"车架号", nil] ;
    NSMutableArray *localValueArr3=[NSMutableArray arrayWithObjects:self.orderModel.D_START_TIME ?: @"",
                                    self.orderModel.B_A823GLS ?: @"",
                                    @"",
                                    self.orderModel.C_A70600_C_NAME ?: @"",
                                    self.orderModel.C_A49600_C_NAME ?: @"",
                                    self.orderModel.C_GDSPR ?: @"",
                                    self.orderModel.C_A823N_COLOR ?  [NSString stringWithFormat:@"%@/%@",self.orderModel.C_A823N_COLOR, self.orderModel.C_A823W_COLOR] : @"",
                                    self.orderModel.C_VIN ?: @"", nil];
    NSMutableArray *localPostNameArr3=[NSMutableArray arrayWithObjects:self.orderModel.D_START_TIME ?: @"",
                                       self.orderModel.B_A823GLS ?: @"",
                                       @"",
                                       self.orderModel.C_A70600_C_ID ?: @"",
                                       self.orderModel.C_A49600_C_ID ?: @"",
                                       self.orderModel.C_GDSPR ?: @"",
                                       self.orderModel.C_A823N_COLOR ?  [NSString stringWithFormat:@"%@/%@",self.orderModel.C_A823N_COLOR, self.orderModel.C_A823W_COLOR] : @"",
                                       self.orderModel.C_VIN ?: @"", nil];
    NSMutableArray *localKeyArr3=[NSMutableArray arrayWithObjects:@"D_START_TIME",@"B_A823GLS",@"",@"C_A70600_C_ID",@"C_A49600_C_ID",@"C_GDSPR",@"C_A823N_COLOR/C_A823W_COLOR",@"C_VIN", nil];

    
    NSMutableArray*saveLocalArr3=[NSMutableArray array];
    for (int i=0; i<localArr3.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr3[i];
        model.nameValue=localValueArr3[i];
        model.postValue=localPostNameArr3[i];
        model.keyValue=localKeyArr3[i];
        
        [saveLocalArr3 addObject:model];
    }
    
    
    NSMutableArray*localArr4=[NSMutableArray arrayWithObjects:@"收件人",@"收件电话",@"邮寄地址", nil] ;
    NSMutableArray *localValueArr4=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_SJR_NAME ?: @"",
                                    self.orderModel.a801.C_SJR_PHONE ?: @"",
                                    self.orderModel.C_ADDRESS ?: @"", nil];
    NSMutableArray *localPostNameArr4=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_SJR_NAME ?: @"",
                                       self.orderModel.a801.C_SJR_PHONE ?: @"",
                                       self.orderModel.C_ADDRESS ?: @"", nil];
    NSMutableArray *localKeyArr4=[NSMutableArray arrayWithObjects:@"C_SJR_NAME",@"C_SJR_PHONE",@"C_ADDRESS", nil];
    
    NSMutableArray*saveLocalArr4=[NSMutableArray array];
    for (int i=0; i<localArr4.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr4[i];
        model.nameValue=localValueArr4[i];
        model.postValue=localPostNameArr4[i];
        model.keyValue=localKeyArr4[i];
        
        [saveLocalArr4 addObject:model];
    }
    
    NSMutableArray*localArr5=[NSMutableArray arrayWithObjects:@"特殊情况告知", nil] ;
    NSMutableArray *localValueArr5=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_INFORM_THE_SINGLE ?:@"", nil];
    NSMutableArray *localPostNameArr5=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_INFORM_THE_SINGLE ?:@"", nil];
    NSMutableArray *localKeyArr5=[NSMutableArray arrayWithObjects:@"C_INFORM_THE_SINGLE", nil];

    
    NSMutableArray*saveLocalArr5=[NSMutableArray array];
    for (int i=0; i<localArr5.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr5[i];
        model.nameValue=localValueArr5[i];
        model.postValue=localPostNameArr5[i];
        model.keyValue=localKeyArr5[i];
        
        [saveLocalArr5 addObject:model];
    }
    
    NSMutableArray*localArr6 ;
    NSMutableArray *localValueArr6;
    NSMutableArray *localPostNameArr6;
    NSMutableArray *localKeyArr6;
    if (self.orderModel.a801.htPojo.htUrl.length > 0) {
        localArr6=[NSMutableArray arrayWithObjects:@"查看合同", nil] ;
        localValueArr6=[NSMutableArray arrayWithObjects:@"查看", nil];
        localPostNameArr6=[NSMutableArray arrayWithObjects:@"查看", nil];
         localKeyArr6=[NSMutableArray arrayWithObjects:@"htUrl", nil];
    }
    
    NSMutableArray*saveLocalArr6=[NSMutableArray array];
    for (int i=0; i<localArr6.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr6[i];
        model.nameValue=localValueArr6[i];
        model.postValue=localPostNameArr6[i];
        model.keyValue=localKeyArr6[i];
        
        [saveLocalArr6 addObject:model];
    }
    
    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0,saveLocalArr1,saveLocalArr2,saveLocalArr3,saveLocalArr4,saveLocalArr5,saveLocalArr6, nil];
    [self.tableView reloadData];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.localDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.localDatas[section];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    NSArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
    CustomerInputTableViewCell *icell = [tableView dequeueReusableCellWithIdentifier:@"CustomerInputTableViewCell"];
    CustomerChooseTableViewCell *ccell = [tableView dequeueReusableCellWithIdentifier:@"CustomerChooseTableViewCell"];
    icell.titleLabel.text = ccell.titleLabel.text = model.locatedTitle;
    icell.inputTextField.text  = ccell.chooseTextField.text = model.nameValue ?: @"";
    ccell.chooseStr = model.postValue;
    ccell.titleStr = model.nameValue;
    ccell.chooseButton.enabled = ccell.chooseTextField.enabled = icell.inputTextField.enabled = YES;
    ccell.mustLabel.hidden = icell.mustLabel.hidden = YES;
    if (indexPath.section == 1) {
        ccell.mustLabel.hidden = icell.mustLabel.hidden = NO;
    }
    if (indexPath.section == 3) {
        ccell.chooseButton.enabled = ccell.chooseTextField.enabled = icell.inputTextField.enabled = NO;
        icell.inputTextField.text  = ccell.chooseTextField.text = model.nameValue.length > 0 ? model.nameValue : @" ";
    }
    if ([model.locatedTitle isEqualToString:@"购车类型"] ||
        [model.locatedTitle isEqualToString:@"开票类型"] ||
        [model.locatedTitle isEqualToString:@"有无授权委托书"] ||
        [model.locatedTitle isEqualToString:@"有无代付款证明"] ||
        [model.locatedTitle isEqualToString:@"有无特殊情况告知书"] ||
        [model.locatedTitle isEqualToString:@"开票单位(销售)"] ||
        [model.locatedTitle isEqualToString:@"查看合同"]) {
        if ([model.locatedTitle isEqualToString:@"购车类型"]) {
            ccell.chooseButton.enabled = ccell.chooseTextField.enabled = NO;
            ccell.type = CustomerChooseTypeWithTYPECODE;
            ccell.typeStr = @"A42000_C_PURCHASEWAY";
        } else if ([model.locatedTitle isEqualToString:@"开票类型"]) {
            ccell.type = CustomerChooseTypeWithTYPECODE;
            ccell.typeStr = @"A801_C_FP_TYPE";
            ccell.sourceStr = self.orderModel.C_PURCHASEWAY_DD_ID;//个人购车
        } else if ([model.locatedTitle isEqualToString:@"有无授权委托书"]) {
            ccell.type = CustomerChooseTypeYW;
        } else if ([model.locatedTitle isEqualToString:@"有无代付款证明"]) {
            ccell.type = CustomerChooseTypeYW;
        } else if ([model.locatedTitle isEqualToString:@"有无特殊情况告知书"]) {
            ccell.type = CustomerChooseTypeYW;
        } else if ([model.locatedTitle isEqualToString:@"开票单位(销售)"]) {
            ccell.type = CustomerChooseTypeWithMainData;
            ccell.typeStr = @"A80000_C_TYPE_0007";
        } else if ([model.locatedTitle isEqualToString:@"查看合同"]) {
            ccell.type = CustomerChooseTypeNil;
        }
        
        ccell.chooseBlock = ^(NSString * _Nonnull str, NSString * _Nonnull postValue) {
            @strongify(self);
            model.nameValue = str;
            model.postValue = postValue;
            if ([model.locatedTitle isEqualToString:@"开票类型"]) {
                
//                NSMutableArray *tempArr2 = self.localDatas[2];
//                [tempArr2 removeAllObjects];
                NSMutableArray*localArr2;
                NSMutableArray *localValueArr2;
                NSMutableArray *localPostNameArr2;
                NSMutableArray *localKeyArr2;
                
                if ([postValue isEqualToString:@"A801_C_FP_TYPE_0001"]) {//普票
                    localArr2=[NSMutableArray arrayWithObjects:@"开票单位(购买)",@"单位税号", nil] ;
                    localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                                    self.orderModel.a801.C_FP_TAX ?: @"", nil];
                    localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                                       self.orderModel.a801.C_FP_TAX ?: @"", nil];
                     localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_COMPANY",@"C_FP_TAX", nil];
                } else if ([postValue isEqualToString:@"A801_C_FP_TYPE_0002"]) {//专票
                    localArr2=[NSMutableArray arrayWithObjects:@"开票单位(购买)",@"单位税号",@"单位联系电话",@"单位联系地址",@"开户行",@"账号", nil] ;
                    localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                                    self.orderModel.a801.C_FP_TAX ?: @"",
                                                    self.orderModel.a801.C_FP_PHONE ?: @"",
                                                    self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                                    self.orderModel.a801.C_FP_BANK ?: @"",
                                                    self.orderModel.a801.C_FP_ACCOUNT ?: @"", nil];
                    localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                                       self.orderModel.a801.C_FP_TAX ?: @"",
                                                       self.orderModel.a801.C_FP_PHONE ?: @"",
                                                       self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                                       self.orderModel.a801.C_FP_BANK ?: @"",
                                                       self.orderModel.a801.C_FP_ACCOUNT ?: @"", nil];
                     localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_COMPANY",@"C_FP_TAX",@"C_FP_PHONE",@"C_FP_ADDRESS",@"C_FP_BANK",@"C_FP_ACCOUNT", nil];
                } else if ([postValue isEqualToString:@"A801_C_FP_TYPE_0003"]) {//电专
                    localArr2=[NSMutableArray arrayWithObjects:@"开票单位(购买)",@"单位税号",@"单位联系电话",@"单位联系地址",@"开户行",@"账号",@"邮箱", nil] ;
                    localValueArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                                    self.orderModel.a801.C_FP_TAX ?: @"",
                                                    self.orderModel.a801.C_FP_PHONE ?: @"",
                                                    self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                                    self.orderModel.a801.C_FP_BANK ?: @"",
                                                    self.orderModel.a801.C_FP_ACCOUNT ?: @"",
                                    self.orderModel.a801.C_FP_EMAIL ?: @"", nil];
                    localPostNameArr2=[NSMutableArray arrayWithObjects:self.orderModel.a801.C_FP_COMPANY ?: @"",
                                                       self.orderModel.a801.C_FP_TAX ?: @"",
                                                       self.orderModel.a801.C_FP_PHONE ?: @"",
                                                       self.orderModel.a801.C_FP_ADDRESS ?: @"",
                                                       self.orderModel.a801.C_FP_BANK ?: @"",
                                                       self.orderModel.a801.C_FP_ACCOUNT ?: @"",
                                       self.orderModel.a801.C_FP_EMAIL ?: @"", nil];
                     localKeyArr2=[NSMutableArray arrayWithObjects:@"C_FP_COMPANY",@"C_FP_TAX",@"C_FP_PHONE",@"C_FP_ADDRESS",@"C_FP_BANK",@"C_FP_ACCOUNT",@"C_FP_EMAIL", nil];
                }
                
                NSMutableArray*saveLocalArr2=[NSMutableArray array];
                for (int i=0; i<localArr2.count; i++) {
                    PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
                    model.locatedTitle=localArr2[i];
                    model.nameValue=localValueArr2[i];
                    model.postValue=localPostNameArr2[i];
                    model.keyValue=localKeyArr2[i];
                    
                    [saveLocalArr2 addObject:model];
                }
                
                self.localDatas[2] = saveLocalArr2;
                
            } else if ([model.locatedTitle isEqualToString:@"查看合同"]) {
                ViewTheContractViewController *vc = [ViewTheContractViewController new];
                vc.htUrl = self.orderModel.a801.htPojo.htUrl;
                [self.navigationController pushViewController:vc animated:YES];
            }
            [tableView reloadData];
        };
        
        return ccell;
    } else {
        [[[icell.inputTextField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:icell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UITextField * _Nullable x) {
            if ([model.locatedTitle isEqualToString:@"开票单位(购买)"]) {
                self.orderModel.a801.C_FP_COMPANY = x.text;
            } else if ([model.locatedTitle isEqualToString:@"单位税号"]) {
                self.orderModel.a801.C_FP_TAX = x.text;
            } else if ([model.locatedTitle isEqualToString:@"单位联系电话"]) {
                self.orderModel.a801.C_FP_PHONE = x.text;
            } else if ([model.locatedTitle isEqualToString:@"单位联系地址"]) {
                self.orderModel.a801.C_FP_ADDRESS = x.text;
            } else if ([model.locatedTitle isEqualToString:@"开户行"]) {
                self.orderModel.a801.C_FP_BANK = x.text;
            } else if ([model.locatedTitle isEqualToString:@"账号"]) {
                self.orderModel.a801.C_FP_ACCOUNT = x.text;
            } else if ([model.locatedTitle isEqualToString:@"邮箱"]) {
                self.orderModel.a801.C_FP_EMAIL = x.text;
            }
            
            model.nameValue = x.text;
            model.postValue = x.text;
        }];
        return icell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return .1f;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    } else {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        bgView.backgroundColor = kBackgroundColor;
        
        UILabel *label = [UILabel new];
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@17);
            make.top.bottom.equalTo(@0);
        }];
        label.textColor = [UIColor darkGrayColor];
        label.font = KNomarlFont;
        label.text = @[@"",@"开票信息-销售方",@"开票信息-购买方",@"车辆信息",@"邮寄信息",@"特殊情况告知书",@""][section];
        
        return bgView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)getDetailVales{
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (self.C_ID.length==0) {
        [JRToast showWithText:@"订单不存在"];
    }
    [dic setObject:self.C_ID forKey:@"C_ID"];
    
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/info", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200)  {
            NSDictionary*dict=[data[@"data"] copy];
            weakSelf.orderModel=[CGCOrderDetailModel yy_modelWithDictionary:dict];
            [weakSelf getLocalData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];

    

}


@end
