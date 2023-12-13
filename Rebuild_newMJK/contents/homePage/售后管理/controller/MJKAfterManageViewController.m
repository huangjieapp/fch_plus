//
//  MJKAfterManageViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2022/2/21.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKAfterManageViewController.h"
#import "MJKOldCustomerSalesViewController.h"

#import "MJKNewUserModel.h"
#import "MJKAdditionalInfoModel.h"
#import "MJKOldCustomerSalesModel.h"
#import "MJKProductShowModel.h"

#import "CFDropDownMenuView.h"
#import "PotentailCustomerListCell.h"
#import "CGCCustomDateView.h"

@interface MJKAfterManageViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic,strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic,strong) CFDropDownMenuView *menuView;
/** <#注释#> */
@property (nonatomic,strong) FunnelShowView*funnelView;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveTableDataDic;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveTimeDataDic;
@property (nonatomic, strong) NSMutableDictionary *saveSelTableDict;

@property (nonatomic,assign) NSInteger pagen;
/** <#注释#> */
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation MJKAfterManageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self httpGetAfterSalesList];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DBSelf(weakSelf);
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"售后管理";
    [self.view addSubview:self.tableView];
    [self httpGetUserListWithModelArrayBlock:^(NSArray *saleArray) {
        [weakSelf chooseView:saleArray];
    }];
    if (self.C_STATUS_DD_ID.length > 0) {
        self.saveSelTableDict[@"C_STATUS_DD_ID"] = self.C_STATUS_DD_ID;
    }
    
    if (self.NEXTCOMMENT_START_TIME.length > 0) {
        self.saveSelTableDict[@"NEXTCOMMENT_TIME_TYPE"] = self.NEXTCOMMENT_TIME_TYPE;
    }
    if (self.NEXTCOMMENT_START_TIME.length > 0) {
        self.saveSelTableDict[@"NEXTCOMMENT_START_TIME"] = self.NEXTCOMMENT_START_TIME;
    }
    if (self.NEXTCOMMENT_END_TIME.length > 0) {
        self.saveSelTableDict[@"NEXTCOMMENT_END_TIME"] = self.NEXTCOMMENT_END_TIME;
    }
    
    [self configRefresh];
    
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf httpGetAfterSalesList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf httpGetAfterSalesList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)chooseView:(NSArray *)saleArray {
    [self httpGetUserListWithModelArrayBlock:^(NSArray *saleArray) {
        [self getDictDataListDatasWithDictType:@"A81500_C_TYPE" Compliation:^(NSArray *typeArray) {
            [self getDictDataListDatasWithDictType:@"A81500_C_STATUS" Compliation:^(NSArray *statusArray) {
                
                CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
                menuView.VCName = @"订单管理";
                NSMutableArray * saleNameArr=[NSMutableArray arrayWithArray:@[@"全部"]];
                NSMutableArray *saleIdArr = [NSMutableArray arrayWithArray:@[@""]];
                for (MJKNewUserModel* model in saleArray) {
                    [saleNameArr addObject:model.nickName.length > 0 ? model.nickName : @""];
                    [saleIdArr addObject:model.u051Id.length > 0 ? model.u051Id : @""];
                }
                
                
                NSMutableArray * typeNameArr=[NSMutableArray array];
                [typeNameArr addObject:@"全部"];
                NSMutableArray *typeIdArr = [NSMutableArray array];
                [typeIdArr addObject:@""];
                for (MJKAdditionalInfoModel* model in typeArray) {
                    [typeNameArr addObject:model.dictLabel.length > 0 ? model.dictLabel : @""];
                    [typeIdArr addObject:model.dictValue.length > 0 ? model.dictValue : @""];
                }
                
                NSArray *timeNameArr = @[@"全部",@"本周",@"上周",@"本月",@"上月",@"今年",@"去年",@"今天",@"昨天",@"最近7天",@"最近30天",@"自定义"];
                NSArray * timeIdArr = @[@" ",@"9",@"10",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"999"];
                
                NSMutableArray * statusNameArr=[NSMutableArray array];
                [statusNameArr addObject:@"全部"];
                NSMutableArray *statusIdArr = [NSMutableArray array];
                [statusIdArr addObject:@""];
                for (MJKAdditionalInfoModel* model in statusArray) {
                    [statusNameArr addObject:model.dictLabel.length > 0 ? model.dictLabel : @""];
                    [statusIdArr addObject:model.dictValue.length > 0 ? model.dictValue : @""];
                }
                
                
                
                menuView.dataSourceArr=[@[saleNameArr, typeNameArr, timeNameArr, statusNameArr] mutableCopy];
                
                menuView.defaulTitleArray=@[@"销售",@"销售类型",@"报修时间",@"状态"];
                
                
                
                menuView.startY=CGRectGetMaxY(menuView.frame);
                self.menuView=menuView;
                [self.view addSubview:self.menuView];
                
#pragma   各种筛选的点击事件
                DBSelf(weakSelf);
                
                
                self.menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
                    NSLog(@"%@---%@--%@",selectedSection,selectedRow,title);
                    NSArray *arr = @[saleIdArr, typeIdArr, timeIdArr, statusIdArr];
                    NSMutableArray*subArray = arr[selectedSection.integerValue];
                    NSString*selectValue=subArray[[selectedRow integerValue]];
                    weakSelf.pagen=20;
                    NSString*selectKey;
                    if ([selectedSection isEqualToString:@"0"]) {
                        //员工
                        selectKey=@"C_XSGW_ROLEID";
                    }else if ([selectedSection isEqualToString:@"1"]){
                        //类型
                        selectKey=@"C_TYPE_DD_ID";
                    }else if ([selectedSection isEqualToString:@"2"]){
                        //创建时间
                        selectKey=@"BXRQ_TIME_TYPE";
                        if ([title isEqualToString:@"自定义"]) {
                            
                            CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:weakSelf.view.bounds withStart:^{
                                
                            } withEnd:^{
                                
                            } withSure:^(NSString *start, NSString *end) {
                                
                                [weakSelf.tableView.mj_header beginRefreshing];
                                
                            }];
                            dateView.isNoHMS = YES;
                            [weakSelf.view addSubview:dateView];
                        }
                    }else if ([selectedSection isEqualToString:@"3"]){
                        //卖车时间
                        selectKey=@"C_STATUS_DD_ID";
                    }
                    if (![title isEqualToString:@"自定义"]) {
                        [weakSelf.saveSelTableDict setObject:selectValue forKey:selectKey];
                        [weakSelf.tableView.mj_header beginRefreshing];
                    }
                };
                
                
                //这个是筛选的view
                FunnelShowView*funnelView=[FunnelShowView funnelShowView];
                self.funnelView = funnelView;
                funnelView.rootVC = self;
                
                
                NSDictionary *dic = @{@"title" : @"客户", @"content" : @[]};
                NSDictionary *dic1 = @{@"title" : @"品牌车型", @"content" : @[]};
                NSDictionary *dic2 = @{@"title" : @"车架号", @"content" : @[]};
                
                NSMutableArray *mtArr23 = [NSMutableArray array];
                NSArray * array23=@[@"全部",@"是",@"否"];
                NSArray * arraySel23=@[@"", @"1", @"0"];
                for (int i=0; i<array23.count; i++) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=array23[i];
                    funnelModel.c_id=arraySel23[i];
                    [mtArr23 addObject:funnelModel];
                    
                }
                NSDictionary *dic3 = @{@"title" : @"是否过保", @"content" : mtArr23};
                
                
                NSMutableArray * saleNameArrZR=[NSMutableArray arrayWithArray:@[@"全部"]];
                NSMutableArray *saleIdArrZR = [NSMutableArray arrayWithArray:@[@""]];
                
                NSMutableArray *ZRArr = [NSMutableArray array];
                MJKFunnelChooseModel*funnelModelZR=[[MJKFunnelChooseModel alloc]init];
                funnelModelZR.name=@"全部";
                funnelModelZR.c_id=@"";
                [ZRArr addObject:funnelModelZR];
                for (MJKNewUserModel* model in saleArray) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=model.nickName;
                    funnelModel.c_id=model.u051Id;
                    [ZRArr addObject:funnelModel];
                    
                }
                NSDictionary *ZRdic3 = @{@"title" : @"责任人", @"content" : ZRArr};
                
                NSMutableArray *cjArr = [NSMutableArray array];
                MJKFunnelChooseModel*funnelModelcj=[[MJKFunnelChooseModel alloc]init];
                funnelModelcj.name=@"全部";
                funnelModelcj.c_id=@"";
                [cjArr addObject:funnelModelcj];
                for (MJKNewUserModel* model in saleArray) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=model.nickName;
                    funnelModel.c_id=model.u051Id;
                    [cjArr addObject:funnelModel];
                    
                }
                NSDictionary *cjdic3 = @{@"title" : @"创建人", @"content" : cjArr};
                
                
                NSMutableArray*dataMYDArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81300_C_STATUS"];
                
                NSMutableArray *mydArr = [NSMutableArray array];
                MJKFunnelChooseModel*funnelModelMYD=[[MJKFunnelChooseModel alloc]init];
                funnelModelMYD.name=@"全部";
                funnelModelMYD.c_id=@"";
                [mydArr addObject:funnelModelMYD];
                for (MJKDataDicModel*model in dataMYDArray) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=model.C_NAME;
                    funnelModel.c_id=model.C_VOUCHERID;
                    [mydArr addObject:funnelModel];
                    
                }
                NSDictionary *myddic3 = @{@"title" : @"满意度状态", @"content" : mydArr};
                
                NSMutableArray*dataHFArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81300_C_HFJG"];
                
                NSMutableArray *hfArr = [NSMutableArray array];
                MJKFunnelChooseModel*funnelModelHF=[[MJKFunnelChooseModel alloc]init];
                funnelModelHF.name=@"全部";
                funnelModelHF.c_id=@"";
                [hfArr addObject:funnelModelHF];
                for (MJKDataDicModel*model in dataHFArray) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=model.C_NAME;
                    funnelModel.c_id=model.C_VOUCHERID;
                    [hfArr addObject:funnelModel];
                    
                }
                NSDictionary *hfddic3 = @{@"title" : @"满意度状态", @"content" : hfArr};
                
                NSMutableArray*datawxhArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A81500_C_WWXYY"];
                
                NSMutableArray *wxhArr = [NSMutableArray array];
                MJKFunnelChooseModel*funnelModelwxh=[[MJKFunnelChooseModel alloc]init];
                funnelModelwxh.name=@"全部";
                funnelModelwxh.c_id=@"";
                [wxhArr addObject:funnelModelwxh];
                for (MJKDataDicModel*model in datawxhArray) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=model.C_NAME;
                    funnelModel.c_id=model.C_VOUCHERID;
                    [wxhArr addObject:funnelModel];
                    
                }
                NSDictionary *wxhddic3 = @{@"title" : @"未修好原因", @"content" : wxhArr};
                
                funnelView.allDatas = [@[dic,dic1,dic2,dic3,ZRdic3,cjdic3,wxhddic3,myddic3,hfddic3] mutableCopy];
                
                //    NSArray * titleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近3天",@"最近30天",@"自定义"];
                //    NSArray * idArr=@[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"9",@"10",@"13",@"30",@"999"];
                
                
                //回调
                funnelView.sureBlock = ^(NSMutableArray *array) {
                    NSString *keyValue = @"";
                    for (NSDictionary*dict in array) {
                        NSString*indexStr=dict[@"index"];
                        MJKFunnelChooseModel*model=dict[@"model"];
                        if ([indexStr isEqualToString:@"3"]) {//是否过保
                            keyValue = @"I_SFGB";
                        } else  if ([indexStr isEqualToString:@"4"]) {//责任人
                            keyValue = @"C_OWNER_ROLEID";
                        } else  if ([indexStr isEqualToString:@"5"]) {//创建人
                            keyValue = @"C_CREATOR_ROLEID";
                        } else  if ([indexStr isEqualToString:@"6"]) {//未修好原因
                            keyValue = @"C_WWXYY_DD_ID";
                        }else  if ([indexStr isEqualToString:@"7"]) {//满意度状态
                            keyValue = @"C_A813STATUS_DD_ID";
                        } else  if ([indexStr isEqualToString:@"8"]) {//满意度回访
                            keyValue = @"C_A813HFJG_DD_ID";
                        }

                        [self.saveTableDataDic setObject:model.c_id forKey:keyValue];
                    }
                    
                    
                    [self.tableView.mj_header beginRefreshing];
                    
                };
                [[UIApplication sharedApplication].keyWindow addSubview:funnelView];
                
                funnelView.chooseProductBlock = ^(MJKProductShowModel *productModel) {
                    [weakSelf.saveTableDataDic setObject:productModel.C_TYPE_DD_ID forKey:@"C_A70600_C_ID"];
                    [weakSelf.saveTableDataDic setObject:productModel.C_ID forKey:@"C_A49600_C_ID"];
                };
                
                funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
                    if (arriveTimes.length > 0) {
                        if ([jieshaoren isEqualToString:@"vin"]) {
                            [weakSelf.saveTableDataDic setObject:arriveTimes forKey:@"C_VIN"];
                        } else if ([jieshaoren isEqualToString:@"customer"]) {
                            [weakSelf.saveTableDataDic setObject:arriveTimes forKey:@"C_KH_NAME"];
                        }
                    }
                };
                
                funnelView.resetBlock = ^{
                    self.pagen=20;
                    [weakSelf.saveTableDataDic removeAllObjects];
                    [weakSelf.saveTimeDataDic removeAllObjects];
                    [weakSelf.tableView.mj_header beginRefreshing];
                };
                
                //这个是漏斗按钮
                CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
                
                [self.view addSubview:funnelButton];
                funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
                    [menuView hide];
                    //显示 左边的view
                    [funnelView show];
                    
                };
                
                
                funnelView.viewCustomTimeBlock = ^(NSInteger selectedSession){
                    MyLog(@"自定义时间");
                   
                    
                };
                
            }];
        }];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MJKOldCustomerSalesMainModel *model = self.dataArray[section];
    return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKOldCustomerSalesMainModel *model = self.dataArray[indexPath.section];
    
    MJKOldCustomerSalesModel *subModel = model.content[indexPath.row];
    PotentailCustomerListCell *cell = [PotentailCustomerListCell cellWithTableView:tableView];
    cell.afterModel = subModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (![[NewUserSession instance].appcode containsObject:@"crm:a815:detail"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    MJKOldCustomerSalesMainModel *model = self.dataArray[indexPath.section];
    
    MJKOldCustomerSalesModel *subModel = model.content[indexPath.row];
    MJKOldCustomerSalesViewController *vc = [[MJKOldCustomerSalesViewController alloc]init];
    vc.C_ID = subModel.C_ID;
    vc.C_TYPE_DD_ID = subModel.C_TYPE_DD_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MJKOldCustomerSalesMainModel *model = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, 30)];
    label.textColor = [UIColor colorWithHex:@"#777777"];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = model.total;
    [bgView addSubview:label];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)getDictDataListDatasWithDictType:(NSString *)dictType Compliation:(void(^)(NSArray*typeArray))deployDatasBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (dictType.length > 0) {
        contentDic[@"dictType"] = dictType;
    }
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

-(void)httpGetAfterSalesList {
   DBSelf(weakSelf);
   NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pagen);
    [self.saveTimeDataDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length  >  0) {
            contentDic[key] = obj;
        }
    }];
    
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length  >  0) {
            contentDic[key] = obj;
        }
    }];
    
    [self.saveTableDataDic enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length  >  0) {
            contentDic[key] = obj;
        }
    }];
   HttpManager*manager=[[HttpManager alloc]init];
   [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMDA815List parameters:contentDic compliation:^(id data, NSError *error) {
       MyLog(@"%@",data);
       if ([data[@"code"] integerValue] == 200) {
           weakSelf.dataArray = [MJKOldCustomerSalesMainModel  mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
           [weakSelf.tableView reloadData];
       } else {
           [JRToast showWithText:data[@"msg"]];
       }
       [weakSelf.tableView.mj_header endRefreshing];
       [weakSelf.tableView.mj_footer endRefreshing];
   }];
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        CGRect frame = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - SafeAreaBottomHeight);
        
        _tableView=[[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView=[[UIView alloc] init];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    return _tableView;
}

- (NSMutableDictionary *)saveSelTableDict {
    if (!_saveSelTableDict) {
        _saveSelTableDict = [NSMutableDictionary dictionary];
    }
    return _saveSelTableDict;
}

- (NSMutableDictionary *)saveTableDataDic {
    if (!_saveTableDataDic) {
        _saveTableDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTableDataDic;
}

- (NSMutableDictionary *)saveTimeDataDic {
    if (!_saveTimeDataDic) {
        _saveTimeDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTimeDataDic;
}

@end
