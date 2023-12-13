//
//  MJKTelephoneRobotViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/19.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotResultViewController.h"

#import "CGCSellModel.h"
#import "MJKTelephoneRobotModel.h"

#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"
#import "MJKTelephoneRobotResultCell.h"
#import "MJKTelephoneRobotListCell.h"

#import "MJKTelephoneRobotProcessViewController.h"

@interface MJKTelephoneRobotResultViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *TableChooseDatas;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *TableSelectedChooseDatas;

/** 筛选数据字典*/
@property (nonatomic, strong) NSMutableDictionary *dataDic;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;
/** dataArray*/
@property (nonatomic, strong) NSArray *listDataArray;

/** <#注释#>*/
@property (nonatomic, strong) UILabel *totalLabel;
@end

@implementation MJKTelephoneRobotResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"呼叫任务结果";
    self.view.backgroundColor = kBackgroundColor;

    [self configUI];
}

- (void)configUI {
    DBSelf(weakSelf);
    [self.view addSubview:self.tableView];
    [self httpGetEmployeesDataWithBlock:^(NSArray *employessArray) {
        [self httpGetIntentionsDataWithBlock:^(NSArray *intentionsArray) {
            [weakSelf configRefresh];
            [weakSelf addChooseViewWithEmployessArray:employessArray andIntentionsArr:intentionsArray];
        }];
    }];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf HTTPListdData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf HTTPListdData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addChooseViewWithEmployessArray:(NSArray *)employessArray andIntentionsArr:(NSArray *)intentionsArray {
    NSMutableArray *employessArr = [NSMutableArray array];
    NSMutableArray *employessCodeArr = [NSMutableArray array];
    [employessArr addObject:@"全部"];
    [employessCodeArr addObject:@""];
    for (CGCSellModel *model in employessArray) {
        [employessArr addObject:model.nickName];
        [employessCodeArr addObject:model.u051Id];
    }
    
    NSMutableArray *statusArr = [NSMutableArray array];
    NSMutableArray *statusCodeArr = [NSMutableArray array];
    [statusArr addObject:@"全部"];
    [statusCodeArr addObject:@""];
    for (NSString *str in intentionsArray) {
        [statusArr addObject:str];
        [statusCodeArr addObject:str];
    }
    
    
    NSMutableArray *arrivalShopTimeArr = [NSMutableArray array];
    NSMutableArray *arrivalShopTimeCodeArr = [NSMutableArray array];
    [arrivalShopTimeArr addObject:@"全部"];
    [arrivalShopTimeCodeArr addObject:@""];
    for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A70200_C_STATUS"]) {
        [arrivalShopTimeArr addObject:model.C_NAME];
        [arrivalShopTimeCodeArr addObject:model.C_VOUCHERID];
    }
    
    NSArray *fromArr = [NSArray arrayWithObjects:@"全部",@"15秒以内",@"30秒以内",@"60秒以内",@"60秒以上", nil];
    NSArray *fromCodeArr = [NSArray arrayWithObjects:@"",@"0",@"1",@"2",@"3", nil];
    
    
    
    self.TableChooseDatas = [NSMutableArray arrayWithObjects:employessArr,statusArr,arrivalShopTimeArr, fromArr, nil];
    self.TableSelectedChooseDatas = [NSMutableArray arrayWithObjects:employessCodeArr, statusCodeArr, arrivalShopTimeCodeArr, fromCodeArr, nil];
    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    menuView.dataSourceArr=self.TableChooseDatas;
    menuView.defaulTitleArray=@[@"员工",@"意图",@"通话结果",@"通话时长"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=weakSelf.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]) {
            selectKey=@"USER_ID";
        }else if ([selectedSection isEqualToString:@"1"]){
            selectKey=@"intentionDesc";
        }else if ([selectedSection isEqualToString:@"2"]){
            selectKey=@"C_STATUS_DD_ID";
            
        } else if ([selectedSection isEqualToString:@"3"]) {
            selectKey=@"billsearch";
        }
        [weakSelf.dataDic setObject:selectValue forKey:selectKey];
        [weakSelf.tableView.mj_header beginRefreshing];
        
    };
    [self.view addSubview:menuView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(menuView.frame) - 70, CGRectGetMaxY(menuView.frame), 70, 20)];
    imageView.image = [UIImage imageNamed:@"all_bg"];
    [self.view addSubview:imageView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    label.text = @"总计:0";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:12.f];
    self.totalLabel = label;
    [imageView addSubview:label];
}

-(void)showTimeAlertVC{
    //自定义的选择时间界面。
    DBSelf(weakSelf);
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        [weakSelf.dataDic removeObjectForKey:@"CREATE_TIME_TYPE"];
        [weakSelf.dataDic setObject:start forKey:@"CREATE_START_TIME"];
        [weakSelf.dataDic setObject:end forKey:@"CREATE_END_TIME"];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTelephoneRobotModel *model = self.listDataArray[indexPath.row];
//    MJKTelephoneRobotResultCell *cell = [MJKTelephoneRobotResultCell cellWithTableView:tableView];
    MJKTelephoneRobotListCell *cell = [MJKTelephoneRobotListCell cellWithTableView:tableView];
    cell.resultModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTelephoneRobotModel *model = self.listDataArray[indexPath.row];
    MJKTelephoneRobotProcessViewController *vc = [[MJKTelephoneRobotProcessViewController alloc]init];
    vc.C_ID = model.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    bgView.backgroundColor = kBackgroundColor;
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - http data
- (void)httpGetEmployeesDataWithBlock:(void(^)(NSArray *employessArray))successBlock {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *employessArray = [CGCSellModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (successBlock) {
                successBlock(employessArray);
            }
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)httpGetIntentionsDataWithBlock:(void(^)(NSArray *intentionsArray))successBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70200WebService-getIntentionDescList"];
    [dict setObject:@{} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *intentionsArray = [data[@"content"] copy];
            if (successBlock) {
                successBlock(intentionsArray);
            }
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)HTTPListdData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70200WebService-getListByA701Id"];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"currPage"] = @"1";
    dic[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
    dic[@"C_A70100_C_ID"] = self.C_A70100_C_ID;
    if (self.C_STATUS_DD_ID.length > 0) {
        dic[@"C_STATUS_DD_ID"] = self.C_STATUS_DD_ID;
    }
    if (self.intentionDesc.length > 0) {
        dic[@"intentionDesc"] = self.intentionDesc;
    }
    [self.dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setObject:obj forKey:key];
    }];
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.listDataArray = [MJKTelephoneRobotModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"总计:%@",data[@"countNumber"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
}



#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 40) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _tableView;
}

- (NSMutableDictionary *)dataDic {
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}

@end
