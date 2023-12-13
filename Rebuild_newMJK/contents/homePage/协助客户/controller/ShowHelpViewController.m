//
//  ShowHelpViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "ShowHelpViewController.h"
#import "AddHelperViewController.h"//新增协助

#import "HelperTableViewCell.h"

#import "CustomerDetailInfoModel.h"
#import "CGCOrderDetailModel.h"
#import "ServiceTaskDetailModel.h"

#import "HelperModel.h"

@interface ShowHelpViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, strong) HelperMainModel *model;

/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
///** 客户详情model*/
//@property (nonatomic, strong) CustomerDetailInfoModel *detailInfoModel;
///** 订单详情model*/
//@property (nonatomic, strong) CGCOrderDetailModel *detailModel;

@end

@implementation ShowHelpViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self HTTPGetHelperList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"协助人列表";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //    [self initRightItem];
    [self.view addSubview:self.bottomView];
}

- (void)initRightItem {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"+" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button addTarget:self action:@selector(addHelp:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HelperModel *subModel = self.model.content[indexPath.row];
    HelperTableViewCell *cell = [HelperTableViewCell cellWithTableView:tableView];
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:subModel.C_HEADIMGURL]];
    cell.nameLabel.text = subModel.C_ASSISTANTNAME;
    cell.timeLabel.hidden = NO;
    cell.timeLabel.text = subModel.D_CREATE_TIME;
    cell.typeLabel.text = subModel.C_TYPE_DD_NAME;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    HelperModel *subModel = self.model.content[indexPath.row];
    if (self.backSelectParameterBlock) {
        self.backSelectParameterBlock(subModel.C_ASSISTANT, subModel.C_ASSISTANTNAME);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    HelperModel *subModel = self.model.content[indexPath.row];
    UITableViewRowAction *delAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"取消协助" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSString *message = [NSString stringWithFormat:@"是否取消%@的协助",subModel.C_ASSISTANTNAME];
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf HTTPDeleteHelper:subModel.C_ID];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:cancelAction];
        [alertVC addAction:sureAction];
        [weakSelf presentViewController:alertVC animated:YES completion:nil];
        
        
    }];
    delAction.backgroundColor = [UIColor redColor];
    
    return @[delAction];
}

#pragma mark - HTTP Request
- (void)HTTPGetHelperList {
    DBSelf(weakSelf);
    self.listArr = [NSMutableArray array];
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-getListByA415id"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] =  self.orderID.length > 0 ? self.orderID : self.C_A41500_C_ID;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.model = [HelperMainModel yy_modelWithDictionary:data];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)HTTPDeleteHelper:(NSString *)C_ID {
    DBSelf(weakSelf);
    self.listArr = [NSMutableArray array];
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-delete"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = C_ID;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf HTTPGetHelperList];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - 点击事件
- (void)addHelp:(UIButton *)sender {
    DBSelf(weakSelf);
    AddHelperViewController *vc = [[AddHelperViewController alloc]init];
    if ([self.assistStr isEqualToString:@"协助"]) {
        if ([[NewUserSession instance].appcode containsObject:@"APP016_0017"]) {
            vc.isAllHepler = @"是";
        }
    } else if ([self.vcName isEqualToString:@"订单"]) {
        if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
            vc.isAllHepler = @"是";
        }
    } else if ([self.vcName isEqualToString:@"任务"]) {
        vc.isAllHepler = @"是";
    } else {
        if ([[NewUserSession instance].appcode containsObject:@"APP004_0028"]) {
            vc.isAllHepler = @"是";
        }
    }
    
    if ([self.vcName isEqualToString:@"客户"]) {
        [self httpPostGetCustomerDetailInfo:^(CustomerDetailInfoModel *model) {
            vc.C_A41500_C_ID = model.C_A41500_C_ID;
            vc.orderID = weakSelf.orderID;
            vc.C_DESIGNER_ROLEID = model.C_DESIGNER_ROLEID;
            vc.C_ID = model.C_ID;
            vc.helpName = self.vcName;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
        
    } else if ([self.vcName isEqualToString:@"任务"]) {
        vc.orderID = self.orderID;
        vc.vcName = @"任务";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.vcName isEqualToString:@"订单"]) {
        [self getDetailVales:^(CGCOrderDetailModel *model) {
            vc.C_A41500_C_ID = model.C_A41500_C_ID;
            vc.orderID = weakSelf.orderID;
            vc.C_DESIGNER_ROLEID = model.C_DESIGNER_ROLEID;
            vc.C_ID = model.C_ID;
            vc.helpName = self.vcName;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
    
    
}

#pragma mark  --getCustomerDetailDatas
-(void)httpPostGetCustomerDetailInfo:(void(^)(CustomerDetailInfoModel *model))completeBlcok{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:@{@"C_ID":self.C_A41500_C_ID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            CustomerDetailInfoModel *detailInfoModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            if (completeBlcok) {
                completeBlcok(detailInfoModel);
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
    }];
    
    
    
}

#pragma mark --- request  订单详情

-(void)getDetailVales:(void(^)(CGCOrderDetailModel *model))completeBlcok{
    
    
    
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    if (self.orderID.length==0) {
        [JRToast showWithText:@"订单不存在"];
    }
    self.orderID?[dic setObject:self.orderID forKey:@"C_ID"]:0;
    
    
    //    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/info", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSDictionary*dict=[data[@"data"] copy];
            CGCOrderDetailModel *detailModel=[CGCOrderDetailModel yy_modelWithDictionary:dict];
            if (completeBlcok) {
                completeBlcok(detailModel);
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
    
    
}

- (void)HttpGetDetail:(void(^)(CGCOrderDetailModel *model))completeBlcok {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_ServiceTaskDetail];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:self.C_ID forKey:@"C_ID"];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            ServiceTaskDetailModel *mainDatasModel=[ServiceTaskDetailModel yy_modelWithDictionary:data];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - 64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        [button setBackgroundColor:KNaviColor];
        [button setTitleNormal:@"新增协助人"];
        [button setTitleColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(addHelp:) forControlEvents:UIControlEventTouchUpInside];
        button.layer.cornerRadius = 5.f;
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

@end
