//
//  CustomerViewController.m
//  match
//
//  Created by huangjie on 2022/7/23.
//

#import "MJKCarSourceHomeViewController.h"
#import "MJKCarSourceNewDetailViewController.h"
#import "MJKCarSourceNewAddOrEditViewController.h"
#import "MJKCarSourceHomeWLViewController.h"
#import "CGCOrderListVC.h"
#import "MJKOldCustomerSalesViewController.h"

#import "MJKCarSourceHomeModel.h"
#import "MJKNewUserModel.h"
#import "MJKAdditionalInfoModel.h"

#import "MJKCarSourceHomeTableViewCell.h"

#import "CFDropDownMenuView.h"
#import "NaviCountView.h"
#import "NaviSearchView.h"
#import "MJKCarSourceStatusView.h"
#import "CGCCustomDateView.h"

#import "VideoAndImageModel.h"

@interface MJKCarSourceHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIButton *addButton;
/** <#注释#> */
@property (nonatomic, strong) CFDropDownMenuView *dropDownMenuView;
/** <#注释#> */
@property (nonatomic, strong) NaviCountView *naviCountView;

@property (nonatomic, strong) NaviSearchView *naviSearchView;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *saveTableDataDic;
@property (nonatomic, strong) NSMutableDictionary *saveTableFunnelDataDic;
/** <#注释#> */
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *topChooseDict;
/** <#注释#> */
@property (nonatomic, strong) NSString *SEARCH_NAMEORCONTACT;
/** <#注释#> */
@property (nonatomic, strong) MJKCarSourceStatusView *carStatusView;

@end

@implementation MJKCarSourceHomeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self getCarSourceList];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.title = @"车源管理";
    self.view.backgroundColor = [UIColor whiteColor];
//    _naviSearchView = [[NaviSearchView alloc]initWithView:self.navigationItem.titleView andReturnBlock:^(NSString * _Nonnull str) {
//
//    }];
//    _naviSearchView.searchTextField.placeholder = @"请输入姓名/手机";
//
//    [[_naviSearchView.searchTextField rac_signalForControlEvents:UIControlEventEditingDidEnd] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self);
//        self.SEARCH_NAMEORCONTACT = self.naviSearchView.searchTextField.text;
//        [self.tableView.mj_header beginRefreshing];
//    }];
//
    self.saveTableDataDic[@"C_STATUS_DD_ID"] = @"1";
    _addButton = [UIButton new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_addButton];
    [_addButton setImage:[UIImage imageNamed:@"icon_add_source"] forState:UIControlStateNormal];
    if ([self.VCName isEqualToString:@"车源"]) {
        _addButton.hidden = YES;
    } else {
        _addButton.hidden = NO;
    }
    
    _dropDownMenuView = [[CFDropDownMenuView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, KScreenWidth-40, 40)];
    NSMutableArray *statusNameArray = [NSMutableArray array];
    NSMutableArray *statusCodeArray = [NSMutableArray array];
    [statusCodeArray addObject:@""];
    [statusNameArray addObject:@"全部"];
    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42000_C_STATUS"];
    for (MJKDataDicModel*model in dataArray) {
        [statusNameArray addObject:model.C_NAME];
        [statusCodeArray addObject:model.C_VOUCHERID];
    }
    // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
    [self httpGetUserListWithModelArrayBlock:^(NSArray *saleArray) {
        [self getDictDataListDatasCompliation:^(NSArray *typeArray) {
            [self geta800DatasCompliationWithC_TYPE_DD_ID:@"A80000_C_TYPE_0010" andBlock:^(NSArray *deployDatas) {
                @strongify(self);
                NSMutableArray * saleNameArr=[NSMutableArray arrayWithArray:@[@"全部"]];
                NSMutableArray *saleIdArr = [NSMutableArray arrayWithArray:@[@""]];
//                for (MJKNewUserModel* model in saleArray) {
//                    [saleNameArr addObject:model.nickName.length > 0 ? model.nickName : @""];
//                    [saleIdArr addObject:model.u051Id.length > 0 ? model.u051Id : @""];
//                }
                NSMutableArray*data1Array=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A82300_C_TYPE"];
                for (MJKDataDicModel*model in data1Array) {
                    [saleNameArr addObject:model.C_NAME];
                    [saleIdArr addObject:model.C_VOUCHERID];
                }
                
                NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A82300_C_STATUS"];
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKDataDicModel*model in dataArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_VOUCHERID];
                }
                
                
                NSMutableArray*statusNameArray=[NSMutableArray array];
                NSMutableArray*statusCodeArray=[NSMutableArray array];
                [statusCodeArray addObject:@""];
                [statusNameArray addObject:@"全部"];
                [statusCodeArray addObject:@"1"];
                [statusNameArray addObject:@"库存"];
                for (MJKAdditionalInfoModel *model in typeArray) {
                    [statusNameArray addObject:model.dictLabel];
                    [statusCodeArray addObject:model.dictValue];
                }
                
                NSMutableArray*szdNameArray=[NSMutableArray array];
                NSMutableArray*szdCodeArray=[NSMutableArray array];
                [szdCodeArray addObject:@""];
                [szdNameArray addObject:@"全部"];
                for (MJKAdditionalInfoModel *model in deployDatas) {
                    [szdNameArray addObject:model.C_NAME];
                    [szdCodeArray addObject:model.C_ID];
                }
                
                self.dropDownMenuView.VCName = @"车源管理";
                self.dropDownMenuView.dataSourceArr = @[
                    saleNameArr,
                                                    @[],
                    statusNameArray,
                    szdNameArray
                                                    ].mutableCopy;
                
                self.dropDownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"车辆类型",@"车型",@"库存", @"车辆所在地", nil];
                self.dropDownMenuView.chooseCarTypeBlock = ^(NSString *typeStr) {
                    @strongify(self);
                    MyLog(@"");
                    NSArray *arr = [typeStr componentsSeparatedByString:@","];
                    self.saveTableDataDic[@"C_A70600_C_ID"] = arr[0];
                    self.saveTableDataDic[@"C_A49600_C_ID"] = arr[1];
                    [self.tableView.mj_header beginRefreshing];
                };
                
                self.dropDownMenuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {

                    @strongify(self);
                    /**
                     实际开发情况 --- 仅需要拿到currentTitle / currentTitleArray 作为参数 向服务器请求数据即可
                     */
                    if(selectedSection.intValue == 0) {
                        self.saveTableDataDic[@"C_TYPE_DD_ID"] = saleIdArr[selectedRow.intValue];
                    } else if (selectedSection.intValue == 1) {
                        
                    } else if (selectedSection.intValue == 2) {
                        self.saveTableDataDic[@"C_STATUS_DD_ID"] = statusCodeArray[selectedRow.intValue];
                    } else if (selectedSection.intValue == 3) {
                        self.saveTableDataDic[@"C_A80000SZD_C_ID"] = szdCodeArray[selectedRow.intValue];
                    }
                    [self.tableView.mj_header beginRefreshing];
                };
            }];
            
        }];
        
    }];
//    _dropDownMenuView.dataSourceArr = @[
//                                        @[],
//                                        statusNameArray,
//                                        @[],
//                                        @[]
//                                        ].mutableCopy;
    
    
    
    // 下拉列表 起始y
    _dropDownMenuView.startY = CGRectGetMaxY(_dropDownMenuView.frame);
    
    /**
     *  回调方式一: block
     */
    
    
    
    [self.view addSubview:_dropDownMenuView];
    
    
    //这个是筛选的view
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    funnelView.rootVC = self;
    
    NSString*typeStr=@"厂家";
    NSMutableArray*typeArr=[NSMutableArray array];
    MJKFunnelChooseModel*typeModel=[[MJKFunnelChooseModel alloc]init];
    typeModel.name=@"全部";
    typeModel.c_id=@"";
    [typeArr addObject:typeModel];
    for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71000_C_TYPE"]) {
        MJKFunnelChooseModel*typeFunnelModel=[[MJKFunnelChooseModel alloc]init];
        typeFunnelModel.name=model.C_NAME;
        typeFunnelModel.c_id=model.C_VOUCHERID;
        [typeArr addObject:typeFunnelModel];
    }
    NSDictionary *dic1 = @{@"title" : @"车源编号", @"content" : @[]};
    NSDictionary *dic2 = @{@"title" : @"车架号", @"content" : @[]};
    
    NSArray *timeNameArr = @[@"全部",@"本周",@"上周",@"本月",@"上月",@"今年",@"去年",@"今天",@"昨天",@"最近7天",@"最近30天",@"自定义"];
    NSArray * timeIdArr = @[@" ",@"9",@"10",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"999"];
    
    NSMutableArray*timeArr=[NSMutableArray array];
    for (int i=0; i<timeNameArr.count; i++) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=timeNameArr[i];
        model.c_id=timeIdArr[i];
        [timeArr addObject:model];
    }
    
    NSDictionary *dddic = @{@"title" : @"到店时间", @"content" : timeArr};
    
    
    NSMutableArray*cktimeArr=[NSMutableArray array];
    for (int i=0; i<timeNameArr.count; i++) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=timeNameArr[i];
        model.c_id=timeIdArr[i];
        [cktimeArr addObject:model];
    }
    
    NSDictionary *ckdic = @{@"title" : @"出库时间", @"content" : cktimeArr};
    
    NSString*spztStr=@"物流审批状态";
    NSMutableArray*spztArr=[NSMutableArray array];
    MJKFunnelChooseModel*spztModel=[[MJKFunnelChooseModel alloc]init];
    spztModel.name=@"全部";
    spztModel.c_id=@"";
    [spztArr addObject:spztModel];
    for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_STATUS"]) {
        MJKFunnelChooseModel*typeFunnelModel=[[MJKFunnelChooseModel alloc]init];
        typeFunnelModel.name=model.C_NAME;
        typeFunnelModel.c_id=model.C_VOUCHERID;
        [spztArr addObject:typeFunnelModel];
    }
    NSDictionary *spztdic = @{@"title" : spztStr, @"content" : spztArr};
    
    
    [self geta800DatasCompliationWithC_TYPE_DD_ID:@"A80000_C_TYPE_0006" andBlock:^(NSArray *deployDatas) {
        NSMutableArray*cjArr=[NSMutableArray array];
        MJKFunnelChooseModel*cjModel=[[MJKFunnelChooseModel alloc]init];
        cjModel.name=@"全部";
        cjModel.c_id=@"";
        [cjArr addObject:cjModel];
        for (MJKAdditionalInfoModel *model in deployDatas) {
            MJKFunnelChooseModel*typeFunnelModel=[[MJKFunnelChooseModel alloc]init];
            typeFunnelModel.name=model.C_NAME;
            typeFunnelModel.c_id=model.C_ID;
            [cjArr addObject:typeFunnelModel];
        }
        
        NSDictionary*dic7=@{@"title":typeStr,@"content":cjArr};
        funnelView.allDatas = [@[dic1,dic2,dddic,ckdic,dic7,spztdic] mutableCopy];
    }];
    
    
    
    
    funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
        @strongify(self);
        if ([jieshaoren isEqualToString:@"vin"]) {
            self.saveTableFunnelDataDic[@"C_VIN"] = arriveTimes;
        } else if ([jieshaoren isEqualToString:@"car"]) {
             self.saveTableFunnelDataDic[@"C_VOUCHERID"] = arriveTimes;
        }
    };
    
    
    //回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
        NSString *keyValue = @"";
        for (NSDictionary*dict in array) {
            NSString*indexStr=dict[@"index"];
            MJKFunnelChooseModel*model=dict[@"model"];
            if ([indexStr isEqualToString:@"2"]) {//到货时间
                if ([model.c_id isEqualToString:@"999"]) {
                    
                } else {
                    keyValue = @"ARRIVAL_TIME_TYPE";
                    
                    [self.saveTableFunnelDataDic setObject:model.c_id forKey:keyValue];
                    [self.saveTableFunnelDataDic removeObjectForKey:@"ARRIVAL_START_TIME"];
                    [self.saveTableFunnelDataDic removeObjectForKey:@"ARRIVAL_END_TIME"];
                }
             } else if ([indexStr isEqualToString:@"3"]) {//出库时间
                 
                 if ([model.c_id isEqualToString:@"999"]) {
                 } else {
                     keyValue = @"CKSJ_TIME_TYPE";
                     
                     [self.saveTableFunnelDataDic setObject:model.c_id forKey:keyValue];
                     [self.saveTableFunnelDataDic removeObjectForKey:@"CKSJ_START_TIME"];
                     [self.saveTableFunnelDataDic removeObjectForKey:@"CKSJ_END_TIME"];
                 }
             } else  if ([indexStr isEqualToString:@"4"]) {//厂家
                keyValue = @"C_A80000CJ_C_ID";
                 [self.saveTableFunnelDataDic setObject:model.c_id forKey:keyValue];
            } else if ([indexStr isEqualToString:@"5"]) {//物流审批状态
                keyValue = @"C_A829STATUS_DD_ID";
                [self.saveTableFunnelDataDic setObject:model.c_id forKey:keyValue];
            }
            
        }
        [self.tableView.mj_header beginRefreshing];
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    
    funnelView.resetBlock = ^{
        @strongify(self);
        self.pageSize=20;
//        [self.saveTableDataDic removeAllObjects];
        [self.saveTableFunnelDataDic removeAllObjects];
        [self.tableView.mj_header beginRefreshing];
    };
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        @strongify(self);
        [self.dropDownMenuView hide];
        //显示 左边的view
        [funnelView show];
        
    };
    
    
    funnelView.viewCustomTimeBlock = ^(NSInteger selectedSession){
        MyLog(@"自定义时间");
        
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{

        } withEnd:^{

        } withSure:^(NSString *start, NSString *end) {
            @strongify(self);
            self.pageSize=20;

            if (selectedSession == 2) {
                [self.saveTableFunnelDataDic removeObjectForKey:@"ARRIVAL_TIME_TYPE"];
                [self.saveTableFunnelDataDic setObject:start forKey:@"ARRIVAL_START_TIME"];
                [self.saveTableFunnelDataDic setObject:end forKey:@"ARRIVAL_END_TIME"];
            } else  if (selectedSession == 3) {
                [self.saveTableFunnelDataDic removeObjectForKey:@"CKSJ_TIME_TYPE"];
                [self.saveTableFunnelDataDic setObject:start forKey:@"CKSJ_START_TIME"];
                [self.saveTableFunnelDataDic setObject:end forKey:@"CKSJ_END_TIME"];
            }

        }];
        [[UIApplication sharedApplication].keyWindow addSubview:dateView];
    };
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT + self.dropDownMenuView.frame.size.height);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MJKCarSourceHomeTableViewCell class] forCellReuseIdentifier:@"MJKCarSourceHomeTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    _naviCountView = [NaviCountView new];
    [self.view addSubview:_naviCountView];
    [_naviCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.equalTo(_tableView.mas_top);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(20);
    }];
    
    [self httpGetUserListWithModelArrayBlock:nil];
    
    [self configRefresh];
    
    [self addAction];
}


- (void)geta800DatasCompliationWithC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID andBlock:(void(^)(NSArray*deployDatas))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMA800List parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            if (typeArray.count <= 0) {
                [JRToast showWithText:@"暂无数据"];
                return;
            }
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)getDictDataListDatasCompliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"dictType"] = @"A82300_C_STATUS";
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMDICDATALIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            deployDatasBlock(typeArray);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)addAction {
    @weakify(self);
    [[_addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (![[NewUserSession instance].appcode containsObject:@"crm:a823:add"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCarSourceNewAddOrEditViewController *vc = [MJKCarSourceNewAddOrEditViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }];
}

- (void)configRefresh {
    self.pageSize = 20;
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageSize = 20;
        [weakSelf getCarSourceList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize += 20;
        [weakSelf getCarSourceList];
    }];
    [self.tableView.mj_header beginRefreshing];
}






#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MJKCarSourceHomeModel *model = self.dataArray[section];
    return model.content.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCarSourceHomeModel *model = self.dataArray[indexPath.section];
    MJKCarSourceHomeSubModel *subModel = model.content[indexPath.row];
    MJKCarSourceHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKCarSourceHomeTableViewCell"];
    if (subModel.fileListFp.count > 0) {
        cell.headLabel.hidden = YES;
        cell.headImageView.hidden = NO;
        VideoAndImageModel *vm = subModel.fileListFp[0];
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:vm.url]];
    } else {
        cell.headLabel.hidden = NO;
        cell.headImageView.hidden = YES;
        if (subModel.C_CAR_TYPE.length > 0) {
            cell.headLabel.text = [subModel.C_CAR_TYPE substringToIndex:1];
        } else {
            cell.headLabel.text = @"";
        }
    }
    cell.titleLabel.text = subModel.C_CAR_TYPE;
    cell.rightLabel.text = [NSString stringWithFormat:@"%@ %@ %@",subModel.C_A70600_C_NAME, subModel.C_A49600_C_NAME, subModel.C_A80000CJ_C_NAME];
    cell.subLabel.text = [NSString stringWithFormat:@"%@座 %@/%@ %@ %@", subModel.I_SEAT, subModel.C_W_COLOR, subModel.C_N_COLOR, subModel.C_ENVIRONMENTAL_PROTECTION, subModel.C_VOUCHERID];
    cell.statusLabel.text = subModel.C_STATUS_DD_NAME;
    cell.shopLabel.text = subModel.C_A80000SZD_C_NAME;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJKCarSourceHomeModel *model = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [UILabel new];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.equalTo(bgView);
    }];
    label.textColor = [UIColor colorWithHex:@"#333333"];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = model.total;
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCarSourceHomeModel *model = self.dataArray[indexPath.section];
    MJKCarSourceHomeSubModel *subModel = model.content[indexPath.row];
    if ([self.VCName isEqualToString:@"车源"]) {
        if (self.chooseOrderBlock) {
            self.chooseOrderBlock(subModel);
        }
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        MJKCarSourceNewDetailViewController *vc = [MJKCarSourceNewDetailViewController new];
        vc.C_ID = subModel.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.VCName isEqualToString:@"车源"]) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKCarSourceHomeModel *model = self.dataArray[indexPath.section];
    MJKCarSourceHomeSubModel *subModel = model.content[indexPath.row];
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"物流" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a823:wuliu"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        MJKCarSourceHomeWLViewController *vc = [MJKCarSourceHomeWLViewController new];
        vc.C_A82300_C_ID = subModel.C_ID;
        vc.C_A80000_DD_ID = subModel.C_A80000SZD_C_ID;
        vc.C_A80000_DD_NAME = subModel.C_A80000SZD_C_NAME;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    action1.backgroundColor = KNaviColor;
    
    UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"锁定" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        CGCOrderListVC *vc = [CGCOrderListVC new];
        vc.isTab = @"无";
        vc.carChoose = @"是";
        __block NSString *C_A42000_C_ID = @"";
        __block NSString *C_CYSTATUS_DD_ID = @"";
        vc.chooseOrderBlock = ^(NSString *orderId) {
            MJKCarSourceStatusView *view = [[MJKCarSourceStatusView alloc]initWithFrame:self.view.bounds];;
            weakSelf.carStatusView = view;
            view.chooseBlock = ^(NSString * _Nonnull str, NSString * _Nonnull postValue) {
                C_A42000_C_ID = orderId;
                C_CYSTATUS_DD_ID = postValue;
            };
            
            [[view.trueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                [weakSelf saveCarSourceSdData:C_A42000_C_ID andC_A82300_C_ID:subModel.C_ID andC_CYSTATUS_DD_ID:C_CYSTATUS_DD_ID];
            }];
            [[UIApplication sharedApplication].windows[0] addSubview:view];
            
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    action2.backgroundColor = [UIColor colorWithHex:@"#aaaaaa"];
    
    UITableViewRowAction *action3 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"售后" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MJKOldCustomerSalesViewController *vc = [MJKOldCustomerSalesViewController new];
        vc.C_TYPE_DD_ID = @"A81500_C_TYPE_0000";
        vc.C_A47700_C_ID = subModel.C_ID;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    action3.backgroundColor = DBColor(50,151,234);
    return @[  action3,action2, action1];
}

- (void)getCarSourceList {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pageSize);
    [self.saveTableDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        contentDic[key] = obj;
    }];
    [self.saveTableFunnelDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        contentDic[key] = obj;
    }];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            self.dataArray = [MJKCarSourceHomeModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            self.naviCountView.countLabel.text = [NSString stringWithFormat:@"总计:%@",data[@"data"][@"countNumber"]];
            [self.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)saveCarSourceSdData:(NSString *)orderId andC_A82300_C_ID:(NSString *)C_A82300_C_ID andC_CYSTATUS_DD_ID:(NSString *)C_CYSTATUS_DD_ID {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A42000_C_ID"] = orderId;
    contentDic[@"C_A82300_C_ID"] = C_A82300_C_ID;
    contentDic[@"C_CYSTATUS_DD_ID"] = C_CYSTATUS_DD_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/cysd", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            [self.carStatusView removeFromSuperview];
            [self getCarSourceList];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetUserListWithModelArrayBlock:(void(^)(NSArray *saleArray))saleArrayBlock{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMUserList parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            NSArray *arr = [MJKNewUserModel  mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (saleArrayBlock) {
                saleArrayBlock(arr);
            }
            
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
 }

#pragma mark - lazy


- (NSMutableDictionary *)topChooseDict {
    if (!_topChooseDict) {
        _topChooseDict = [NSMutableDictionary dictionary];
    }
    return _topChooseDict;
}

- (NSMutableDictionary *)saveTableDataDic {
    if (!_saveTableDataDic) {
        _saveTableDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTableDataDic;
}

- (NSMutableDictionary *)saveTableFunnelDataDic {
    if (!_saveTableFunnelDataDic) {
        _saveTableFunnelDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTableFunnelDataDic;
}


- (void)dealloc {
    NSLog(@"销毁---%s", __func__);
}

@end
