//
//  MJKTelephoneRobotViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/19.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotViewController.h"

#import "CGCSellModel.h"
#import "MJKTelephoneRobotModel.h"
#import "MJKTelephoneRobotListModel.h"

#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"
#import "CGCMoreCollection.h"
#import "MJKTelephoneRobotListCell.h"

#import "MJKAddTelephoneRobotViewController.h"
#import "MJKTelephoneRobotDetailViewController.h"

@interface MJKTelephoneRobotViewController ()<UITableViewDataSource, UITableViewDelegate>
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

/** <#注释#>*/
@property (nonatomic, strong) UIImageView *totalImageView;

@end

@implementation MJKTelephoneRobotViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"AI外呼";
    self.view.backgroundColor = kBackgroundColor;
    
    [self configNavi];
    [self configUI];
}

- (void)configNavi {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitleNormal:@"+"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:28.f];
    [button addTarget:self action:@selector(addTeleRobot:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)configUI {
    DBSelf(weakSelf);
    [self.dataDic setObject:@"1" forKey:@"CREATE_TIME_TYPE"];
    [self.view addSubview:self.tableView];
    [self httpGetEmployeesDataWithBlock:^(NSArray *employessArray) {
        [weakSelf configRefresh];
        [weakSelf addChooseViewWithEmployessArray:employessArray];
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

- (void)addChooseViewWithEmployessArray:(NSArray *)employessArray {
    NSMutableArray *employessArr = [NSMutableArray array];
    NSMutableArray *employessCodeArr = [NSMutableArray array];
    [employessArr addObject:@"全部"];
    [employessCodeArr addObject:@""];
    for (CGCSellModel *model in employessArray) {
        [employessArr addObject:model.user_name];
        [employessCodeArr addObject:model.user_id];
    }

    NSMutableArray *statusArr = [NSMutableArray array];
    NSMutableArray *statusCodeArr = [NSMutableArray array];
    [statusArr addObject:@"全部"];
    [statusCodeArr addObject:@""];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A70100_C_STATUS"] ) {
        [statusArr addObject:model.C_NAME];
        [statusCodeArr addObject:model.C_VOUCHERID];
    }
    
    NSArray *arrivalShopTimeArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray *arrivalShopTimeCodeArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];

    
    NSMutableArray *fromArr = [NSMutableArray array];
    NSMutableArray *fromCodeArr = [NSMutableArray array];
    [fromArr addObject:@"全部"];
    [fromCodeArr addObject:@""];
    [fromArr addObject:@"我的"];
    [fromCodeArr addObject:[NewUserSession instance].user.u051Id];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A70100_C_SOURCE"] ) {
        [fromArr addObject:model.C_NAME];
        [fromCodeArr addObject:model.C_VOUCHERID];
    }

    self.TableChooseDatas = [NSMutableArray arrayWithObjects:employessArr,statusArr,arrivalShopTimeArr, fromArr, nil];
    self.TableSelectedChooseDatas = [NSMutableArray arrayWithObjects:employessCodeArr, statusCodeArr, arrivalShopTimeCodeArr, fromCodeArr, nil];
    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    menuView.VCName = @"AI外呼";
    menuView.dataSourceArr=self.TableChooseDatas;
    menuView.defaulTitleArray=@[@"员工",@"状态",@"今天",@"任务来源"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=weakSelf.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];

        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]) {
            //员工
            selectKey=@"USER_ID";
        }else if ([selectedSection isEqualToString:@"1"]){
            //状态
            selectKey=@"C_STATUS_DD_ID";
        }else if ([selectedSection isEqualToString:@"2"]){
            //时间
            [weakSelf.dataDic removeObjectForKey:@"CREATE_START_TIME"];
            [weakSelf.dataDic removeObjectForKey:@"CREATE_END_TIME"];
            selectKey=@"CREATE_TIME_TYPE";
            if ([title isEqualToString:@"自定义"]) {
                [weakSelf showTimeAlertVC];
                return ;
            }

        } else if ([selectedSection isEqualToString:@"3"]) {
            //来源渠道
            selectKey=@"C_SOURCE_DD_ID";
        }
        [weakSelf.dataDic setObject:selectValue forKey:selectKey];
        [weakSelf.tableView.mj_header beginRefreshing];

    };
    [self.view addSubview:menuView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(menuView.frame) - 180, CGRectGetMaxY(menuView.frame), 180, 20)];
    self.totalImageView = imageView;
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

#pragma mark - 新增电话机器人
- (void)addTeleRobot:(UIButton *)sender {
    
    CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:@[@"机器人名单列表",@"机器人客户列表",@"机器人粉丝列表"] withTitleArr:@[@"名单列表",@"客户列表",@"粉丝列表"] withTitle:@"请选择号码来源" withSelectIndex:^(NSInteger index, NSString *title) {
        if (title.length > 0) {
            MJKAddTelephoneRobotViewController *vc = [[MJKAddTelephoneRobotViewController alloc]init];
            if ([title isEqualToString:@"名单列表"]) {
                vc.C_SOURCE_DD_ID = @"A70100_C_SOURCE_0000";
            } else if ([title isEqualToString:@"客户列表"]) {
                vc.C_SOURCE_DD_ID = @"A70100_C_SOURCE_0002";
            } else if ([title isEqualToString:@"粉丝列表"]) {
                vc.C_SOURCE_DD_ID = @"A70100_C_SOURCE_0001";
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
}



#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MJKTelephoneRobotListModel *model = self.listDataArray[section];
    return model.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTelephoneRobotListModel *model = self.listDataArray[indexPath.section];
    MJKTelephoneRobotModel *subModel = model.content[indexPath.row];
    MJKTelephoneRobotListCell *cell = [MJKTelephoneRobotListCell cellWithTableView:tableView];
    cell.model = subModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTelephoneRobotListModel *model = self.listDataArray[indexPath.section];
    MJKTelephoneRobotModel *subModel = model.content[indexPath.row];
    MJKTelephoneRobotDetailViewController *vc = [[MJKTelephoneRobotDetailViewController alloc]init];
    vc.C_ID = subModel.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MJKTelephoneRobotListModel *model = self.listDataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 25)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = model.total;
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - http data
- (void)httpGetEmployeesDataWithBlock:(void(^)(NSArray *employessArray))successBlock {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserList parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *employessArray = [CGCSellModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (successBlock) {
                successBlock(employessArray);
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)HTTPListdData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70100WebService-getList"];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"currPage"] = @"1";
    dic[@"pageSize"] = [NSString stringWithFormat:@"%ld",(long)self.pagen];
    [self.dataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dic setObject:obj forKey:key];
    }];

    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];

    HttpManager*manager=[[HttpManager alloc]init];

    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            
            weakSelf.listDataArray = [MJKTelephoneRobotListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
            
            CGSize size = [[NSString stringWithFormat:@"任务数:%@ 电话数:%@ 时长:%@分钟",data[@"allCount"][@"idCount"],data[@"allCount"][@"numberSum"],data[@"allCount"][@"zzwhhsSum"]] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
            CGRect imageFrame = weakSelf.totalImageView.frame;
            imageFrame.size.width = size.width;
            imageFrame.origin.x = KScreenWidth - imageFrame.size.width;
            weakSelf.totalImageView.frame = imageFrame;
            
            CGRect totalFramw = weakSelf.totalLabel.frame;
            totalFramw.size.width = imageFrame.size.width;
            weakSelf.totalLabel.frame = totalFramw;
            
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"任务数:%@ 电话数:%@ 时长:%@分钟",data[@"allCount"][@"idCount"],data[@"allCount"][@"numberSum"],data[@"allCount"][@"zzwhhsSum"]];
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
