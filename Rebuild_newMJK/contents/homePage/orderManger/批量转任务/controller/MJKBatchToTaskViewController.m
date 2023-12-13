//
//  MJKBatchToTaskViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/15.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKBatchToTaskViewController.h"
#import "OrderDetailViewController.h"

#import "MJKBatchToTaskTableViewCell.h"

#import "MJKOrderMoneyListModel.h"
#import "ServiceTaskDetailModel.h"
#import "CGCOrderDetailModel.h"

@interface MJKBatchToTaskViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSArray *dataMoudleArray;
/** bottom*/
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKBatchToTaskViewController

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"批量转任务";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
    [self HttpGetDataMoudleList];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    ServiceTaskDetailModel *model = self.dataArray[indexPath.row];
    MJKBatchToTaskTableViewCell *cell = [MJKBatchToTaskTableViewCell cellWithTableView:tableView];
    cell.model = model;
    cell.rootVC = self;
    __block MJKBatchToTaskTableViewCell *blockCell = cell;
    cell.chooseBlock = ^(NSString * _Nonnull title, NSString * _Nonnull postStr, UITextField * _Nonnull tf) {
        if (tf == blockCell.textFieldType) {
            model.C_TYPE_DD_ID = postStr;
            model.C_TYPE_DD_NAME = title;
        } else if (tf == blockCell.textFieldStartTime) {
            model.D_CONFIRMED_TIME = postStr;
            model.D_ORDER_TIME = [DBTools getTimeFomatFromTimeStampAddThreeTime:model.D_CONFIRMED_TIME];
        } else if (tf == blockCell.textFieldEndTime) {
            model.D_ORDER_TIME = postStr;
        } else if (tf == blockCell.textFieldSale) {
            model.USER_ID = postStr;
            model.USER_NAME = title;
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.deleteButtonActionBlock = ^{
        [weakSelf.dataArray removeObject:model];
        [tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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

#pragma mark 请求数据
- (void)HttpGetDataList {
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-getList"];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"I_TYPE"] = @"2";
    if (self.orderId.length > 0) {
        dic[@"C_A42000_C_ID"] = self.orderId;
    }
    if (self.C_A42000STATUS_DD_ID.length > 0) {
        dic[@"C_A42000STATUS_DD_ID"] = self.C_A42000STATUS_DD_ID;
    }
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            NSArray *arr = [MJKOrderMoneyListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:arr];
            for (MJKOrderMoneyListModel *dataModel in arr) {//移除已经转任务的
                if (dataModel.C_A01200_C_ID.length > 0) {
                    [tempArr removeObject:dataModel];
                }
            }
            for (MJKOrderMoneyListModel *model in weakSelf.dataMoudleArray) {//节点设置的data
                for (MJKOrderMoneyListModel *dataModel in tempArr) {//订单节点的data
                    if ([model.C_NAME isEqualToString:dataModel.C_NAME]) {
                        ServiceTaskDetailModel *taskModel = [[ServiceTaskDetailModel alloc]init];
                        taskModel.C_ID = [DBObjectTools getServiceTaskC_id];
                        taskModel.C_TYPE_DD_NAME = model.C_TYPE_DD_NAME;
                        taskModel.C_TYPE_DD_ID = model.C_TYPE_DD_ID;
                        taskModel.C_A47300_C_ID = dataModel.C_ID;
                        taskModel.USER_ID = dataModel.C_RESPONSIBLE_ROLEID.length > 0 ? dataModel.C_RESPONSIBLE_ROLEID : self.user_id;
                        taskModel.USER_NAME = dataModel.C_RESPONSIBLE_ROLENAME.length > 0 ? dataModel.C_RESPONSIBLE_ROLENAME : self.user_name;
                        taskModel.D_CONFIRMED_TIME = dataModel.D_CONFIRMED_TIME.length > 0 ? dataModel.D_CONFIRMED_TIME : [DBTools getTimeFomatFromCurrentTimeStamp];//D_PLANNEDSTART_TIME
                        taskModel.D_ORDER_TIME = dataModel.D_PLANNED_TIME.length > 0 ? dataModel.D_PLANNED_TIME : [DBTools getTimeFomatFromTimeStampAddThreeTime:taskModel.D_CONFIRMED_TIME];
                        taskModel.C_A42000_C_ID = weakSelf.orderId;
                        taskModel.C_NAME = dataModel.C_NAME;
                        taskModel.C_A41500_C_ID = weakSelf.orderModel.C_A41500_C_ID;
                        taskModel.C_CONTACTPHONE = weakSelf.orderModel.C_PHONE;
                        taskModel.C_ADDRESS = weakSelf.orderModel.C_ADDRESS;
                        taskModel.I_TYPE = model.I_RWTYPE;
                        taskModel.X_REMARK = dataModel.C_NAME;
                        [weakSelf.dataArray addObject:taskModel];
                    }
                }
            }
            
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)HttpGetDataMoudleList {
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47300WebService-getList"];
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    dic[@"I_TYPE"] = @"1";
    if (self.C_A42000STATUS_DD_ID.length > 0) {
        dic[@"C_A42000STATUS_DD_ID"] = self.C_A42000STATUS_DD_ID;
    }
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataMoudleArray = [MJKOrderMoneyListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf HttpGetDataList];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

//A01200WebService-insertRwByList
- (void)HttpSetData {
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A01200WebService-insertRwByList"];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    for (ServiceTaskDetailModel *model in self.dataArray) {
//        model.C_ID = [DBObjectTools getServiceTaskC_id];
        if (model.C_TYPE_DD_ID.length <= 0) {
            [JRToast showWithText:[NSString stringWithFormat:@"%@请选择类型",model.C_NAME]];
            return;
        }
        if (model.D_CONFIRMED_TIME.length <= 0) {
            [JRToast showWithText:[NSString stringWithFormat:@"%@请选择开始时间",model.C_NAME]];
            return;
        }
        if (model.D_ORDER_TIME.length <= 0) {
            [JRToast showWithText:[NSString stringWithFormat:@"%@请选择完成时间",model.C_NAME]];
            return;
        }
        if (model.USER_ID.length <= 0) {
            [JRToast showWithText:[NSString stringWithFormat:@"%@请选择负责人",model.C_NAME]];
            return;
        }
        NSDictionary *dic = [model mj_keyValues];
        [arr addObject:dic];
    }
    if (arr.count > 0) {
        dic[@"pojoList"] = arr;
    } else {
        return;
    }
    dict[@"content"] = dic;
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataMoudleArray = [MJKOrderMoneyListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
//            [weakSelf HttpGetDataList];
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[OrderDetailViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}


#pragma mark - 批量操作
- (void)operationButtonAction:(UIButton *)sender {
    [self HttpSetData];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-50, KScreenWidth, 50)];
        UIButton *operationButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, _bottomView.frame.size.width - 10, 40)];
        operationButton.layer.cornerRadius = 5.f;
        [operationButton setTitleNormal:@"批量操作"];
        [operationButton setTintColor:[UIColor blackColor]];
        [operationButton setBackgroundColor:KNaviColor];
        [operationButton addTarget:self action:@selector(operationButtonAction:)];
        [_bottomView addSubview:operationButton];
    }
    return _bottomView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
