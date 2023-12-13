//
//  MJKCustomerFeedbackViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/9/24.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCustomerFeedbackViewController.h"
#import "MJKOldCustomerConsultViewController.h"

#import "CFDropDownMenuView.h"

#import "MJKFlowListTableViewCell.h"

#import "MJKCustomerFeedbackModel.h"

#import "MJKClueListViewModel.h"

@interface MJKCustomerFeedbackViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CFDropDownMenuView*menuView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, assign) NSInteger pageSize;

@property (nonatomic, strong)NSMutableArray *saleArr;
@property (nonatomic, strong)NSMutableArray *saleCodeArr;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *dataTableDic;
@end

@implementation MJKCustomerFeedbackViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self getList];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"客服反馈";
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
      self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self getEmpAll];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT + 40);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    [self configRefresh];
}

- (void)configRefresh {
    self.pageSize = 20;
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageSize = 20;
        [weakSelf getList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize += 20;
        [weakSelf getList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUI {
    DBSelf(weakSelf);
    NSMutableArray *ZXLXArray   = [NSMutableArray array];
    NSMutableArray *ZXLXCodeArray   = [NSMutableArray array];
    
        [ZXLXArray addObject:@"全部"];
        [ZXLXCodeArray addObject:@""];
    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81400_C_ZXLX"];
    for (MJKDataDicModel*model in dataArray) {
        [ZXLXArray addObject:model.C_NAME];
        [ZXLXCodeArray addObject:model.C_VOUCHERID];
    }
    
    NSMutableArray *JJCDArray   = [NSMutableArray array];
    NSMutableArray *JJCDCodeArray   = [NSMutableArray array];
    [JJCDArray addObject:@"全部"];
    [JJCDCodeArray addObject:@""];
    NSMutableArray*JJCDdataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81400_C_JJCD"];
    for (MJKDataDicModel*model in JJCDdataArray) {
        [JJCDArray addObject:model.C_NAME];
        [JJCDCodeArray addObject:model.C_VOUCHERID];
    }
    
    NSMutableArray *STATUSDArray   = [NSMutableArray array];
    NSMutableArray *STATUSCodeArray   = [NSMutableArray array];
    [STATUSDArray addObject:@"全部"];
    [STATUSCodeArray addObject:@""];
    NSMutableArray*STATUSdataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81500_C_STATUS"];
    for (MJKDataDicModel*model in STATUSdataArray) {
        [STATUSDArray addObject:model.C_NAME];
        [STATUSCodeArray addObject:model.C_VOUCHERID];
    }
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    self.menuView = menuView;
    menuView.VCName = @"客户管理";
    menuView.dataSourceArr=[@[self.saleArr,
                              ZXLXArray,
                              JJCDArray,
                              STATUSDArray] mutableCopy];
    
   
    menuView.defaulTitleArray= @[@"销售",@"咨询类型",@"紧急程度",@"状态"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        
        if (selectedSection.integerValue == 0) {
            weakSelf.dataTableDic[@"XSGW_USER_ID"] = self.saleCodeArr[selectedRow.integerValue];
        } else if (selectedSection.integerValue ==1) {
            weakSelf.dataTableDic[@"C_ZXLX_DD_ID"] = ZXLXCodeArray[selectedRow.integerValue];
        }else if (selectedSection.integerValue ==2) {
            weakSelf.dataTableDic[@"C_JJCD_DD_ID"] = JJCDCodeArray[selectedRow.integerValue];
        }else if (selectedSection.integerValue ==3) {
            weakSelf.dataTableDic[@"C_STATUS_DD_ID"] = STATUSCodeArray[selectedRow.integerValue];
        }
        [weakSelf.tableView.mj_header beginRefreshing];
        

       
    };
    [self.view addSubview:menuView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCustomerFeedbackModel *model= self.dataArray[indexPath.row];
    MJKFlowListTableViewCell *cell = [MJKFlowListTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = model.C_KH_NAME;
    cell.handImageView.hidden = YES;
    cell.firstNameLabel.hidden = NO;
    if (model.C_KH_NAME.length > 0) {
        cell.firstNameLabel.text = [model.C_KH_NAME substringToIndex:1];
    } else {
        cell.firstNameLabel.text = @"";
    }
    cell.saleNameLabel.text = model.C_OWNER_ROLENAME;
    cell.statusLabel.text = model.C_STATUS_DD_NAME;
    cell.subTitleLabel.text = model.C_ZXLX_DD_NAME;
    cell.proceTimeLabel.text = model.C_JJCD_DD_NAME;
    if ([model.C_STATUS_DD_ID isEqualToString:@"A81400_C_STATUS_0000"]) {
        cell.statusLabel.textColor = KNaviColor;
    } else {
        cell.statusLabel.textColor = DBColor(114, 218, 73);//绿
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[NewUserSession instance].appcode containsObject:@"crm:a814:detail"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    MJKCustomerFeedbackModel *model= self.dataArray[indexPath.row];
    MJKOldCustomerConsultViewController *vc = [[MJKOldCustomerConsultViewController alloc]init];
    vc.C_ID = model.C_ID;
    vc.C_A47700_C_ID = model.C_A47700_C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getList {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
    [self.dataTableDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            contentDic[key] = obj;
        }
    }];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a814/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] integerValue] == 200) {
            self.dataArray = [MJKCustomerFeedbackModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [self.tableView  reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getEmpAll {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserList parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
           weakSelf.saleArr = [NSMutableArray array];
            weakSelf.saleCodeArr = [NSMutableArray array];
            [weakSelf.saleArr addObject:@"全部"];
            [weakSelf.saleCodeArr addObject:@""];
            

            MJKClueListViewModel *clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            for (MJKClueListSubModel *subModel in clueListModel.data) {
                subModel.user_id = subModel.u031Id;
                subModel.user_name = subModel.nickName;
                subModel.C_HEADPIC = subModel.avatar;
                [weakSelf.saleArr addObject:subModel.nickName];
                [weakSelf.saleCodeArr addObject:subModel.u031Id];
            }
            clueListModel.content = clueListModel.data;
            
            [weakSelf initUI];
            
            
            

        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (NSMutableDictionary *)dataTableDic {
    if (!_dataTableDic) {
        _dataTableDic = [NSMutableDictionary dictionary];
    }
    return _dataTableDic;
}



@end
