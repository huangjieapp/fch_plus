//
//  DocumentSignViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/10.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "ContractSignViewController.h"

#import "CustomerInputTableViewCell.h"
#import "CustomerChooseTableViewCell.h"
#import "CustomerRemarkTableViewCell.h"

#import "PotentailCustomerEditModel.h"
#import "CGCOrderDetailModel.h"

@interface ContractSignViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *submitButton;
/** <#注释#> */
/** <#注释#> */
@property (nonatomic, strong) CGCOrderDetailModel *detailModel;
@end

@implementation ContractSignViewController

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
        [self submintContractSign];
    }];
    
}

- (void)submintContractSign {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    for (NSArray *arr in self.localDatas) {
        for (int i = 0; i < arr.count; i++) {
            PotentailCustomerEditModel *model = arr[i];
            if (model.postValue.length > 0) {
                contentDic[model.keyValue] = model.postValue;
            }
        }
    }
    contentDic[@"C_A42000_C_ID"] = self.detailModel.C_ID;
    
    NSString *path = [NSString stringWithFormat:@"%@/api/crm/a420/getAgreementUrl", HTTP_IP];
    
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:path parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getLocalData {
    NSMutableArray*localArr0 ;
    NSMutableArray *localValueArr0;
    NSMutableArray *localPostNameArr0;
    NSMutableArray *localKeyArr0;
    if ([self.detailModel.a801.htPojo.I_FQFLX isEqualToString:@"2"]) {
        localArr0=[NSMutableArray arrayWithObjects:@"发起方类型",@"发起方姓名",@"发起方手机号", nil] ;
        localValueArr0=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_FQFLX ? ([self.detailModel.a801.htPojo.I_FQFLX isEqualToString:@"1"] ? @"单位" : @"个人") : @"",
                        [NewUserSession instance].user.nickName ?: @"",
                        [NewUserSession instance].user.dzqPhone ?: @"", nil];
        localPostNameArr0=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_FQFLX ?: @"",
                           [NewUserSession instance].user.nickName ?: @"",
                           [NewUserSession instance].user.dzqPhone ?: @"", nil];
        localKeyArr0=[NSMutableArray arrayWithObjects:@"I_FQFLX",@"C_FQFGR_NAME",@"C_FQFGR_PHONE", nil];
    } else {
        localArr0=[NSMutableArray arrayWithObjects:@"发起方类型",@"公司名称",@"发起方姓名",@"发起方手机号", nil] ;
        localValueArr0=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_FQFLX ? ([self.detailModel.a801.htPojo.I_FQFLX isEqualToString:@"1"] ? @"单位" : @"个人") : @"",
                        self.detailModel.a801.htPojo.C_FQFGSZT_NAME ?: @"",
                        [NewUserSession instance].user.nickName ?: @"",
                        [NewUserSession instance].user.dzqPhone ?: @"", nil];
        localPostNameArr0=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_FQFLX ?: @"",
                           self.detailModel.a801.htPojo.C_FQFGSZT_ID ?: @"",
                           [NewUserSession instance].user.nickName ?: @"",
                           [NewUserSession instance].user.dzqPhone ?: @"", nil];
        localKeyArr0=[NSMutableArray arrayWithObjects:@"I_FQFLX",@"C_FQFGSZT_ID",@"C_FQFGR_NAME",@"C_FQFGR_PHONE", nil];
    }
    
    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
    
    NSMutableArray*localArr1;
    NSMutableArray *localValueArr1;
    NSMutableArray *localPostNameArr1;
    NSMutableArray *localKeyArr1;
    if ([self.detailModel.a801.htPojo.I_JSFLX isEqualToString:@"1"]) {
        localArr1=[NSMutableArray arrayWithObjects:@"接收方类型",@"账号", nil] ;
        localValueArr1=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_JSFLX ? ([self.detailModel.a801.htPojo.I_JSFLX isEqualToString:@"1"] ? @"内部账号" : @"外部账号") : @"",
                        self.detailModel.a801.htPojo.C_JSF_ID ?: @"", nil];
        localPostNameArr1=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_JSFLX ?: @"",
                           self.detailModel.a801.htPojo.C_JSF_ID ?: @"", nil];
        localKeyArr1=[NSMutableArray arrayWithObjects:@"I_JSFLX",@"C_JSF_ID", nil];
    } else {
        localArr1=[NSMutableArray arrayWithObjects:@"接收方类型",@"姓名",@"手机号", nil] ;
        localValueArr1=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_JSFLX ? ([self.detailModel.a801.htPojo.I_JSFLX isEqualToString:@"1"] ? @"内部账号" : @"外部账号") : @"",
                        self.detailModel.a801.htPojo.C_JSF_NAME ?: @"",
                        self.detailModel.a801.htPojo.C_JSF_PHONE ?: @"", nil];
        localPostNameArr1=[NSMutableArray arrayWithObjects:self.detailModel.a801.htPojo.I_JSFLX ?: @"",
                           self.detailModel.a801.htPojo.C_JSF_NAME ?: @"",
                           self.detailModel.a801.htPojo.C_JSF_PHONE ?: @"", nil];
        localKeyArr1=[NSMutableArray arrayWithObjects:@"I_JSFLX",@"C_JSF_NAME",@"C_JSF_PHONE", nil];
    }
    
    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }
    
    
    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0,saveLocalArr1, nil];
    
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
    icell.inputTextField.text  = ccell.chooseTextField.text = model.nameValue;
    ccell.chooseStr = model.postValue;
    ccell.titleStr = model.nameValue;
    ccell.chooseButton.enabled = ccell.chooseTextField.enabled = icell.inputTextField.enabled = YES;
    if ([model.locatedTitle isEqualToString:@"发起方类型"] ||
        [model.locatedTitle isEqualToString:@"公司名称"] ||
        [model.locatedTitle isEqualToString:@"接收方类型"] ||
        [model.locatedTitle isEqualToString:@"账号"]) {
        if ([model.locatedTitle isEqualToString:@"发起方类型"]) {
            ccell.type = CustomerChooseTypeDG;
        } else if ([model.locatedTitle isEqualToString:@"公司名称"]) {
            ccell.type = CustomerChooseTypeWithMainData;
            ccell.typeStr = @"A80000_C_TYPE_0007";
        } else if ([model.locatedTitle isEqualToString:@"接收方类型"]) {
            ccell.type = CustomerChooseTypeNW;
        } else if ([model.locatedTitle isEqualToString:@"账号"]) {
            ccell.type = CustomerChooseTypeWithMainData;
            ccell.typeStr = @"A80000_C_TYPE_0004";
        }
        
        ccell.chooseBlock = ^(NSString * _Nonnull str, NSString * _Nonnull postValue) {
            @strongify(self);
            model.nameValue = str;
            model.postValue = postValue;
            if ([model.locatedTitle isEqualToString:@"发起方类型"]) {
                self.detailModel.a801.htPojo.I_FQFLX = postValue;
                [self getLocalData];
            } else if ([model.locatedTitle isEqualToString:@"公司名称"]) {
                self.detailModel.a801.htPojo.C_FQFGSZT_ID = postValue;
                self.detailModel.a801.htPojo.C_FQFGSZT_NAME = str;
            } else if ([model.locatedTitle isEqualToString:@"接收方类型"]) {
                self.detailModel.a801.htPojo.I_JSFLX = postValue;
                [self getLocalData];
            } else if ([model.locatedTitle isEqualToString:@"账号"]) {
                self.detailModel.a801.htPojo.C_JSF_ID = postValue;
                self.detailModel.a801.htPojo.C_JSF_NAME = postValue;
            }
            [tableView reloadData];
        };
        
        return ccell;
    } else {
        if ([model.locatedTitle isEqualToString:@"发起方姓名"] ||
            [model.locatedTitle isEqualToString:@"发起方手机号"]) {
            icell.inputTextField.enabled = NO;
        }
        [[[icell.inputTextField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:icell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UITextField * _Nullable x) {
            @strongify(self);
            model.nameValue = x.text;
            model.postValue = x.text;
            if ([model.locatedTitle isEqualToString:@"发起方姓名"]) {
                self.detailModel.a801.htPojo.C_FQFGR_NAME = x.text;
            } else if ([model.locatedTitle isEqualToString:@"发起方手机号"]) {
                self.detailModel.a801.htPojo.C_FQFGR_PHONE = x.text;
            } else if ([model.locatedTitle isEqualToString:@"姓名"]) {
                self.detailModel.a801.htPojo.C_JSF_NAME = x.text;
            } else if ([model.locatedTitle isEqualToString:@"手机号"]) {
                self.detailModel.a801.htPojo.C_JSF_PHONE = x.text;
            }
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
        label.text = @[@"发起方",@"接收方"][section];
        
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
            weakSelf.detailModel=[CGCOrderDetailModel yy_modelWithDictionary:dict];
            [weakSelf getLocalData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];

    

}

@end
