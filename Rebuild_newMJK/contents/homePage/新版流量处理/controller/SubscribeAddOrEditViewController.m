//
//  CustomerAddOrEditViewController.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "SubscribeAddOrEditViewController.h"
#import "MJKFlowProcessViewController.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"


#import "CGCAppointmentModel.h"
#import "PotentailCustomerEditModel.h"



@interface SubscribeAddOrEditViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong)  CGCAppointmentModel*detailModel;

/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *submitButton;

@end

@implementation SubscribeAddOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预约信息";
    @weakify(self);
    _submitButton  = [UIButton new];
    [self.view addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.right.equalTo(@(-5));
        make.bottom.equalTo(@(-SafeAreaBottomHeight-5));
        make.height.equalTo(@45);
    }];
    _submitButton.layer.cornerRadius = 5.f;
    [_submitButton setBackgroundColor:KNaviColor];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[_submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
//        if (self.returnBlock){
//            self.returnBlock(self.detailModel);
//        }
        if (self.detailModel.C_YS_DD_ID.length <= 0) {
            [JRToast showWithText:@"请选择预算"];
            return;
        }
        if (self.detailModel.C_PAYMENT_DD_ID.length <= 0) {
            [JRToast showWithText:@"请选择购车阶段"];
            return;
        }
        
        if (self.detailModel.C_STAYTIME_DD_ID.length <= 0) {
            [JRToast showWithText:@"请选择购车接待时长"];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DJTESTNOTI" object:[self.detailModel mj_keyValues]];
        for (UIViewController *vc in self.navigationController.viewControllers) {
            if ([vc isKindOfClass:[MJKFlowProcessViewController class]]) {
                [self.navigationController popToViewController:vc animated:YES];
            }
        }
//        [self.navigationController popViewControllerAnimated:YES];
        
    }];
   
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-SafeAreaBottomHeight-55));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    
    [self getLocalData];
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
    DBSelf(weakSelf);
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    AddCustomerInputTableViewCell *icell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    icell.inputTextField.enabled = NO;
    icell.nameTitleLabel.text = model.locatedTitle;
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    ccell.chooseTextField.enabled = NO;
    ccell.nameTitleLabel.text = model.locatedTitle;
    if ([model.locatedTitle isEqualToString:@"预约备注"]) {
        CGCNewAppointTextCell * cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.textView.text=model.nameValue;
        cell.textView.editable = NO;
        return cell;
    } else if ([model.locatedTitle isEqualToString:@"预算"]) {
        ccell.taglabel.hidden = NO;
        ccell.chooseTextField.enabled = YES;
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.C_TYPECODE = @"A41500_C_YS";
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            weakSelf.detailModel.C_YS_DD_ID = postValue;
            weakSelf.detailModel.C_YS_DD_NAME = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"购车阶段"]) {
        ccell.taglabel.hidden = NO;
        ccell.chooseTextField.enabled = YES;
        ccell.C_TYPECODE = @"A41500_C_PAYMENT";
        ccell.textStr = model.nameValue;
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            weakSelf.detailModel.C_PAYMENT_DD_ID = postValue;
            weakSelf.detailModel.C_PAYMENT_DD_NAME = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"接待时长"]) {
        ccell.taglabel.hidden = NO;
        ccell.chooseTextField.enabled = YES;
        ccell.C_TYPECODE = @"A41400_C_STAYTIME";
        ccell.textStr = model.nameValue;
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            weakSelf.detailModel.C_STAYTIME_DD_ID = postValue;
            weakSelf.detailModel.C_STAYTIME_DD_NAME = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else {
        icell.textStr = model.nameValue;
        return icell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    if ([model.locatedTitle isEqualToString:@"预约备注"]) {
        return 100;
    }
    return 44;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


- (void)getLocalData {
   
    NSMutableArray*localArr0 = [NSMutableArray arrayWithObjects:@"客户姓名",@"手机号码",@"性别",@"来源",@"渠道",@"等级",@"预算",@"购车阶段",@"创建时间",@"预约时间",@"邀约类型",@"邀约目标",@"邀约人",@"到店时间",@"预约备注",@"接待时长", nil];
    NSMutableArray*localValueArr0=[NSMutableArray arrayWithObjects:
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        [DBTools getTimeFomatFromCurrentTimeStamp],
                        @"",
                        @"",nil];
    NSMutableArray*localPostNameArr0=[NSMutableArray arrayWithObjects:
                                           @"",
                                           @"",
                                           @"",
                                           @"",
                                           @"",
                                           @"",
                                           @"",
                                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           [DBTools getTimeFomatFromCurrentTimeStamp],
                           @"",
                           @"",nil];
    NSMutableArray*localKeyArr0=[NSMutableArray arrayWithObjects:@"C_A41500_C_ID",@"C_PHONE",@"C_SEX_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"C_LEVEL_DD_ID",@"C_YS_DD_ID",@"C_PAYMENT_DD_ID",@"D_CREATE_TIME",@"D_BOOK_TIME",@"C_MODEFOLLOW_DD_ID",@"C_ISDRIVE_DD_ID",@"IS_ARRIVE_SHOP",@"USER_ID",@"X_REMARK",@"C_STAYTIME_DD_ID", nil];
    
    
    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
    
    
    
    
    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0, nil];
    
   
    [self getCustomerDetail];
    
}


- (void)getCustomerDetail {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/info", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
//            NSDictionary*dict=[data copy];
          
            CGCAppointmentModel *detailModel=[CGCAppointmentModel yy_modelWithDictionary:data[@"data"]];
            if (detailModel.D_ARRIVE_TIME.length <= 0) {
                detailModel.D_ARRIVE_TIME = [DBTools getTimeFomatFromCurrentTimeStamp];
            }
            weakSelf.detailModel = detailModel;
            NSArray *postArray = @[detailModel.C_A41500_C_ID ?:@"",
                                   detailModel.C_PHONE ?:@"",
                                   detailModel.C_SEX_DD_ID ?:@"",
                                   detailModel.C_CLUESOURCE_DD_ID ?:@"",
                                   detailModel.C_A41200_C_ID ?:@"",
                                   detailModel.C_LEVEL_DD_ID ?:@"",
                                   detailModel.C_YS_DD_ID ?:@"",
                                   detailModel.C_PAYMENT_DD_ID ?:@"",
                                   detailModel.D_CREATE_TIME ?:@"",
                                   detailModel.D_BOOK_TIME ?:@"",
                                   detailModel.C_MODEFOLLOW_DD_ID ?:@"",
                                   detailModel.C_ISDRIVE_DD_ID ?:@"",
                                   detailModel.USER_ID ?:@"",
                                   detailModel.D_ARRIVE_TIME ?:@"",
                                   detailModel.X_REMARK ?:@"",
                                   detailModel.C_STAYTIME_DD_ID ?: @""];
            
            NSArray *nameArray = @[detailModel.C_A41500_C_NAME ?:@"",
                                   detailModel.C_PHONE ?:@"",
                                   detailModel.C_SEX_DD_NAME ?:@"",
                                   detailModel.C_CLUESOURCE_DD_NAME ?:@"",
                                   detailModel.C_A41200_C_NAME ?:@"",
                                   detailModel.C_LEVEL_DD_NAME ?:@"",
                                   detailModel.C_YS_DD_NAME ?:@"",
                                   detailModel.C_PAYMENT_DD_NAME ?:@"",
                                   detailModel.D_CREATE_TIME ?:@"",
                                   detailModel.D_BOOK_TIME ?:@"",
                                   detailModel.C_MODEFOLLOW_DD_NAME ?:@"",
                                   detailModel.C_ISDRIVE_DD_NAME ?:@"",
                                   detailModel.USER_NAME ?:@"",
                                   detailModel.D_ARRIVE_TIME ?:@"",
                                   detailModel.X_REMARK ?:@"",
                                   detailModel.C_STAYTIME_DD_NAME ?: @""];
            
            NSArray *localArray = weakSelf.localDatas[0];
            for (int i = 0; i < localArray.count; i++) {
                PotentailCustomerEditModel *model = localArray[i];
                model.nameValue = nameArray[i];
                model.postValue = postArray[i];
            }
        }else{
            
          
            
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView reloadData];
        
        
        
    }];
}

@end
