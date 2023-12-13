//
//  MJKRegisterManageViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/11/2.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKRegisterManageViewController.h"
#import "MJKRegistrationViewController.h"

#import "CFDropDownMenuView.h"
#import "NaviCountView.h"
#import "MJKCarSourceHomeTableViewCell.h"
#import "CGCCustomDateView.h"

#import "MJKNewUserModel.h"
#import "MJKRegisterManageModel.h"


@interface MJKRegisterManageViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) CFDropDownMenuView *dropDownMenuView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableDictionary *saveTableDataDic;


@property (nonatomic, strong) NSMutableDictionary *saveTableFunnelDataDic;
/** <#注释#> */
@property (nonatomic, strong) NaviCountView *naviCountView;
/** <#注释#> */
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, strong) FunnelShowView*funnelView;
@end

@implementation MJKRegisterManageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"refresh"] isEqualToString:@"yes"]) {
        [self getDataList];
        [KUSERDEFAULT removeObjectForKey:@"refresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上牌管理";
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    _dropDownMenuView = [[CFDropDownMenuView alloc] initWithFrame:CGRectMake(0, NAVIHEIGHT, KScreenWidth - 40, 40)];
    // 注:  需先 赋值数据源dataSourceArr二维数组  再赋值defaulTitleArray一维数组
    
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    self.funnelView = funnelView;
    funnelView.rootVC = self;
    
    
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
    
    NSDictionary *dddic = @{@"title" : @"上牌完成时间", @"content" : timeArr};
    
    
    
    [self httpGetUserListWithModelArrayBlock:^(NSArray *saleArray) {
        @strongify(self);
        NSMutableArray * saleNameArr=[NSMutableArray arrayWithArray:@[@"全部"]];
        NSMutableArray *saleIdArr = [NSMutableArray arrayWithArray:@[@""]];
        for (MJKNewUserModel* model in saleArray) {
            [saleNameArr addObject:model.nickName.length > 0 ? model.nickName : @""];
            [saleIdArr addObject:model.u051Id.length > 0 ? model.u051Id : @""];
        }
        
        
        NSMutableArray*saleAllArr=[NSMutableArray array];
        for (int i=0; i<saleNameArr.count; i++) {
            MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
            model.name=saleNameArr[i];
            model.c_id=saleIdArr[i];
            [saleAllArr addObject:model];
        }
        
        NSDictionary *ZRdic3 = @{@"title" : @"上牌落户员", @"content" : saleAllArr};
        
        funnelView.allDatas = [@[dic2,ZRdic3,dddic] mutableCopy];
        
        
        NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A80500_C_SPCLX"];
        NSMutableArray*mtArray=[NSMutableArray array];
        NSMutableArray*postArray=[NSMutableArray array];
        [postArray addObject:@""];
        [mtArray addObject:@"全部"];
        for (MJKDataDicModel*model in dataArray) {
            [mtArray addObject:model.C_NAME];
            [postArray addObject:model.C_VOUCHERID];
        }
        
        NSMutableArray*statusArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A80500_C_STATUS"];
        NSMutableArray*statusNameArray=[NSMutableArray array];
        NSMutableArray*statusCodeArray=[NSMutableArray array];
        [statusCodeArray addObject:@""];
        [statusNameArray addObject:@"全部"];
        for (MJKDataDicModel*model in statusArray) {
            [statusNameArray addObject:model.C_NAME];
            [statusCodeArray addObject:model.C_VOUCHERID];
        }
        
       
        self.dropDownMenuView.dataSourceArr = @[saleNameArr, @[], mtArray, statusNameArray ].mutableCopy;
        
        self.dropDownMenuView.defaulTitleArray = [NSArray arrayWithObjects:@"销售",@"车型",@"类型", @"状态", nil];
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
                self.saveTableDataDic[@"C_OWNER_ROLEID"] = saleIdArr[selectedRow.intValue];
            } else if (selectedSection.intValue == 1) {
                
            } else if (selectedSection.intValue == 2) {
                self.saveTableDataDic[@"C_SPCLX_DD_ID"] = postArray[selectedRow.intValue];
            } else if (selectedSection.intValue == 3) {
                self.saveTableDataDic[@"C_STATUS_DD_ID"] = statusCodeArray[selectedRow.intValue];
            }
            [self.tableView.mj_header beginRefreshing];
        };
                    
        
    }];
    
    // 下拉列表 起始y
    _dropDownMenuView.startY = CGRectGetMaxY(_dropDownMenuView.frame);
    
    /**
     *  回调方式一: block
     */
    
    
    
    [self.view addSubview:_dropDownMenuView];
    
    
    //这个是筛选的view
   
    
    
    //回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
        
        NSString *keyValue = @"";
        for (NSDictionary*dict in array) {
            NSString*indexStr=dict[@"index"];
            MJKFunnelChooseModel*model=dict[@"model"];
                if ([indexStr isEqualToString:@"1"]) {//是否过保
                    keyValue = @"C_SPLHYXM_ROLEID";
                } else  if ([indexStr isEqualToString:@"2"]) {//责任人
                    if ([model.c_id isEqualToString:@"999"]) {
                        
                    } else {
                        keyValue = @"FINISH_TIME_TYPE";
                        [self.saveTableFunnelDataDic removeObjectForKey:@"FINISH_START_TIME"];
                        [self.saveTableFunnelDataDic removeObjectForKey:@"FINISH_END_TIME"];
                    }
                }
                
                [self.saveTableFunnelDataDic setObject:model.c_id forKey:keyValue];
            }
            
        
        [self.tableView.mj_header beginRefreshing];
        
        
        
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
    DBSelf(weakSelf);
    
    
    funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
        if (arriveTimes.length > 0) {
            if ([jieshaoren isEqualToString:@"vin"]) {
                [weakSelf.saveTableFunnelDataDic setObject:arriveTimes forKey:@"C_VIN"];
            }
        }
    };
    
    funnelView.resetBlock = ^{
        weakSelf.pageSize=20;
        [weakSelf.saveTableFunnelDataDic removeAllObjects];
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        [weakSelf.dropDownMenuView hide];
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
                [self.saveTableDataDic removeObjectForKey:@"FINISH_TIME_TYPE"];
                [self.saveTableFunnelDataDic setObject:start forKey:@"FINISH_START_TIME"];
                [self.saveTableFunnelDataDic setObject:end forKey:@"FINISH_END_TIME"];
            }

        }];
        [[UIApplication sharedApplication].windows[0] addSubview:dateView];
        
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
    
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pageSize = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageSize = 20;
        [weakSelf getDataList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize += 20;
        [weakSelf getDataList];
        
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)getDataList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pageSize);
    [self.saveTableDataDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            contentDic[key] = obj;
        }
    }];
    [self.saveTableFunnelDataDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            contentDic[key] = obj;
        }
    }];
//    contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a805/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.naviCountView.countLabel.text = [NSString stringWithFormat:@"总计:%@",data[@"data"][@"countNumber"]];
            weakSelf.dataArray = [MJKRegisterManageMainModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)httpGetUserListWithModelArrayBlock:(void(^)(NSArray *saleArray))saleArrayBlock{
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


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MJKRegisterManageMainModel *model = self.dataArray[section];
    return model.content.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKRegisterManageMainModel *model = self.dataArray[indexPath.section];
    MJKRegisterManageModel *subModel = model.content[indexPath.row];
    MJKCarSourceHomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKCarSourceHomeTableViewCell"];
    cell.headLabel.hidden = NO;
    cell.headImageView.hidden = YES;
    if (subModel.C_KH_NAME.length > 0) {
        cell.headLabel.text = [subModel.C_KH_NAME substringToIndex:1];
    } else {
        cell.headLabel.text = @"";
    }
    
    cell.titleLabel.text = subModel.C_KH_NAME;
    cell.rightLabel.text = subModel.C_SPCLX_DD_NAME;
    cell.subLabel.text = [NSString stringWithFormat:@"车架号:%@", subModel.C_VIN];
    cell.remarkLabel.text = [NSString stringWithFormat:@"%@ %@",subModel.C_A70600_C_NAME, subModel.C_A49600_C_NAME];
    cell.statusLabel.text = subModel.C_STATUS_DD_NAME;
    cell.shopLabel.text = [NSString stringWithFormat:@"%@/%@",subModel.C_OWNER_ROLENAME, subModel.C_SPLHYXM_ROLENAME];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[NewUserSession instance].appcode containsObject:@"crm:a805:detail"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    MJKRegisterManageMainModel *model = self.dataArray[indexPath.section];
    MJKRegisterManageModel *subModel = model.content[indexPath.row];
    MJKRegistrationViewController *vc= [[MJKRegistrationViewController alloc]init];
    vc.C_ID = subModel.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJKRegisterManageMainModel *model = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [UILabel new];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
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

@end
