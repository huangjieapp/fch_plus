//
//  MJKReimbursementViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKReimbursementViewController.h"

#import "CFDropDownMenuView.h"

#import "CGCCustomDateView.h"

#import "MJKReimbursementCategoryModel.h"

#import "MJKAddReimbursementViewController.h"

@interface MJKReimbursementViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *TableChooseDatas;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *TableSelectedChooseDatas;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *dataDic;

/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;
@end

@implementation MJKReimbursementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"费用报销";
    self.view.backgroundColor = kBackgroundColor;
    [self configUI];
}

- (void)configUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitleNormal:@"+"];
    button.titleLabel.font = [UIFont systemFontOfSize:28.f];
    [button setTitleColor:[UIColor blackColor]];
    [button addTarget:self action:@selector(addApplyAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    DBSelf(weakSelf);
    [self httpGetCategoryDataWithBlock:^(NSArray *categroyArr) {
        [weakSelf addChooseViewWithCategroyArray:categroyArr];
    }];
    [self.view addSubview:self.tableView];
    [self configRefresh];
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

-(void)addChooseViewWithCategroyArray:(NSArray *)categroyArray {
    NSMutableArray *categoryArr = [NSMutableArray array];
    NSMutableArray *categoryCodeArr = [NSMutableArray array];
    for (MJKReimbursementCategoryModel *model in categroyArray) {
        [categoryArr addObject:model.name];
        [categoryCodeArr addObject:model.objectId];
    }
    
    NSArray * arrivalShopTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * arrivalShopTimeCodeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    
    NSArray *statusArr = [NSArray arrayWithObjects:@"全部",@"待审批",@"已审批",@"驳回", nil];
    NSArray *statusCodeArr = [NSArray arrayWithObjects:@"",@"APPROVE_STATUS_0000",@"APPROVE_STATUS_0002",@"APPROVE_STATUS_0001", nil];
    
    NSArray *payStatusArr = [NSArray arrayWithObjects:@"全部",@"已付款",@"未付款", nil];
    NSArray *payStatusCodeArr = [NSArray arrayWithObjects:@"",@"OPERATION_STATE_0001",@"OPERATION_STATE_0000", nil];
    
    self.TableChooseDatas = [NSMutableArray arrayWithObjects:categoryArr,statusArr,payStatusArr,arrivalShopTimeArr, nil];
    self.TableSelectedChooseDatas = [NSMutableArray arrayWithObjects:categoryCodeArr, statusCodeArr, payStatusCodeArr, arrivalShopTimeCodeArr, nil];
    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    menuView.dataSourceArr=self.TableChooseDatas;
    menuView.defaulTitleArray=@[@"类别",@"审批状态",@"付款状态",@"付款时间"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=weakSelf.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]) {
            //类别
            selectKey=@"classificationId";
        }else if ([selectedSection isEqualToString:@"1"]){
            //审批状态
            selectKey=@"dicApproverStateDdId";
        }else if ([selectedSection isEqualToString:@"2"]){
            //付款状态
            selectKey=@"dicOperationStateDdId";
        }else if ([selectedSection isEqualToString:@"3"]){
            //时间
            [weakSelf.dataDic removeObjectForKey:@"start_time"];
            [weakSelf.dataDic removeObjectForKey:@"end_time"];
            selectKey=@"search_type";
            if ([title isEqualToString:@"自定义"]) {
                [weakSelf showTimeAlertVC];
                return ;
            }
            
        }
        [weakSelf.dataDic setObject:selectValue forKey:selectKey];
        [weakSelf.tableView.mj_header beginRefreshing];

    };
    [self.view addSubview:menuView];
}

-(void)showTimeAlertVC{
    //自定义的选择时间界面。
    DBSelf(weakSelf);
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        [weakSelf.dataDic removeObjectForKey:@"search_type"];
        [weakSelf.dataDic setObject:start forKey:@"start_time"];
        [weakSelf.dataDic setObject:end forKey:@"end_time"];
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
}

#pragma mark - 新增报销
- (void)addApplyAction:(UIButton *)sender {
    MJKAddReimbursementViewController *vc = [[MJKAddReimbursementViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UITableViewCell new];
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

#pragma mark - http data
- (void)httpGetCategoryDataWithBlock:(void(^)(NSArray *categroy))successBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"FinanceWebService-getClassificationList"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"type"] = @"SR";
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            NSArray *categroyArray = [MJKReimbursementCategoryModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            if (successBlock) {
                successBlock(categroyArray);
            }
        }else{
            if (successBlock) {
                successBlock(@[]);
            }
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (void)HTTPListdData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"FinanceWebService-getMmReimbursementList"];
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"currPage"] = @"1";
    dic[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pagen];
    [self.dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setObject:obj forKey:key];
    }];
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            
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
