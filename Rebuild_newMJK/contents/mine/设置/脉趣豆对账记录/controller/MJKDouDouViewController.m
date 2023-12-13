//
//  MJKDouDouViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKDouDouViewController.h"

#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"

#import "MJKClueListViewModel.h"
#import "MJKClueListSubModel.h"
#import "MJKRedPackageModel.h"

#import "MJKDouDouTableViewCell.h"

@interface MJKDouDouViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIImageView *totalImageView;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) MJKClueListViewModel* saleDatasModel;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *doudouArray;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_TYPE_DD_ID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *TRADESUCCESS_TIME_TYPE;
@property (nonatomic, strong) NSString *QUEREN_START_TIME;
@property (nonatomic, strong) NSString *QUEREN_END_TIME;
@property (nonatomic, strong) NSString *USER_ID;
@end

@implementation MJKDouDouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }

    self.title = @"脉趣豆对账记录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self configTotal];
    [self getSalesListDatas];
    [self setupRefresh];
}

-(void)setupRefresh{
    DBSelf(weakSelf);
    self.pagen=20;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen=20;
        [weakSelf getDouDouData];
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf getDouDouData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)configTotal {
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 100, SafeAreaTopHeight + 40, 100, 20)];
    imageView.image = [UIImage imageNamed:@"all_bg"];
    self.totalImageView = imageView;
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    label.textColor = [UIColor darkGrayColor];
    label.text = @"总计:100";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    self.totalLabel = label;
    [imageView addSubview:label];
}

- (void)chooseView{
    
    NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
    NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
    for (MJKClueListSubModel *clueListSubModel in self.saleDatasModel.data) {
        [saleArr addObject:clueListSubModel.nickName];
        [saleSelectedArr addObject:clueListSubModel.u051Id];
    }
    
    NSArray*timeStr = @[@"全部",@"本周",@"上周",@"本月",@"上月",@"今年",@"去年",@"今天",@"昨天",@"最近7天",@"最近30天",@"自定义"];
    NSArray*timeKeyStr = @[@" ",@"9",@"10",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"999"];
    
    //A71100_C_TYPE
    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A71100_C_TYPE"];
    NSMutableArray*lsStr=[NSMutableArray array];
    NSMutableArray*lsKeyStr=[NSMutableArray array];
    [lsStr addObject:@"流水"];
    [lsKeyStr addObject:@""];
    for (MJKDataDicModel*model in dataArray) {
        [lsStr addObject:model.C_NAME];
        [lsKeyStr addObject:model.C_VOUCHERID];
    }
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
   
    menuView.dataSourceArr=[@[saleArr,
                               timeStr,
                              lsStr] mutableCopy];
    menuView.defaulTitleArray=@[@"员工",@"时间",@"流水"];
    
    
    menuView.startY=CGRectGetMaxY(menuView.frame);
    [self.view addSubview:menuView];
    
    
#pragma   各种筛选的点击事件
    DBSelf(weakSelf);
    
    
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        NSLog(@"%@---%@--%@",selectedSection,selectedRow,title);
        
        switch ([selectedSection intValue]) {
            case 0:{
                weakSelf.USER_ID = saleSelectedArr[selectedRow.integerValue];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
                break;
            case 1:{
                if ([title isEqualToString:@"全部"]) {
                    weakSelf.QUEREN_START_TIME=@"";
                    weakSelf.QUEREN_END_TIME=@"";
                    weakSelf.TRADESUCCESS_TIME_TYPE=@"";
                }
                if ([title isEqualToString:@"自定义"]) {
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:weakSelf.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        weakSelf.QUEREN_START_TIME=start;
                        weakSelf.QUEREN_END_TIME=end;
                        weakSelf.TRADESUCCESS_TIME_TYPE=@"";
                        //                        [weakSelf HTTPGetOrderList];
                        [weakSelf.tableView.mj_header beginRefreshing];
                        
                    }];
                    dateView.isNoHMS = YES;
                    [weakSelf.view addSubview:dateView];
                }
                
                weakSelf.QUEREN_START_TIME=@"";
                weakSelf.QUEREN_END_TIME=@"";
                weakSelf.TRADESUCCESS_TIME_TYPE=timeKeyStr[selectedRow.integerValue];
                //                [weakSelf HTTPGetOrderList];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
                break;
            case 2:{
                weakSelf.C_TYPE_DD_ID = lsKeyStr[selectedRow.integerValue];
                [weakSelf.tableView.mj_header beginRefreshing];
            }
                break;
            default:
                break;
        }
        
        
    };
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.doudouArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKRedPackageModel *model = self.doudouArray[indexPath.row];
    MJKDouDouTableViewCell *cell = [MJKDouDouTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.doudouArray.count > 0) {
        return 44;
    } else {
        return .1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.doudouArray.count > 0) {
        return 10;
    } else {
        return .1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(74, 44 - 8, 8, 8)];
    imageView.image = [UIImage imageNamed:@"topimg"];
    [bgView addSubview:imageView];
    if (self.doudouArray.count > 0) {
        return bgView;
    } else {
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 8)];
    bgView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(74, 0, 8, 8)];
    imageView.image = [UIImage imageNamed:@"bottomimg"];
    [bgView addSubview:imageView];
    if (self.doudouArray.count > 0) {
        return bgView;
    } else {
        return nil;
    }
}

-(void)getSalesListDatas {NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            [weakSelf chooseView];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

- (void)getDouDouData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A71100WebService-getList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"ISPAGE"] = @"1";
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = @(self.pagen);
    contentDic[@"C_STATUS_DD_ID"] = @"A71100_C_STATUS_0001";
    if (self.C_TYPE_DD_ID.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    }
    if (self.TRADESUCCESS_TIME_TYPE.length > 0) {
        contentDic[@"TRADESUCCESS_TIME_TYPE"] = self.TRADESUCCESS_TIME_TYPE;
    }
    if (self.QUEREN_START_TIME.length > 0) {
        contentDic[@"QUEREN_START_TIME"] = self.QUEREN_START_TIME;
    }
    if (self.QUEREN_END_TIME.length > 0) {
        contentDic[@"QUEREN_END_TIME"] = self.QUEREN_END_TIME;
    }
    if (self.USER_ID.length > 0) {
        contentDic[@"USER_ID"] = self.USER_ID;
    }
    contentDic[@"orderType"] = @"1";
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.doudouArray = [MJKRedPackageModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
            weakSelf.totalLabel.text=[NSString stringWithFormat:@"交易笔数:%@ 合计(豆):%@" ,data[@"countNumber"],data[@"je_sum"]];
            CGRect imageViewFrame = weakSelf.totalImageView.frame;
            CGRect labelFrame = weakSelf.totalLabel.frame;
            CGFloat width = [weakSelf.totalLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
            imageViewFrame.size.width = width + 20;
            imageViewFrame.origin.x = KScreenWidth - imageViewFrame.size.width;
            labelFrame.size.width = width + 20;
            weakSelf.totalImageView.frame = imageViewFrame;
            weakSelf.totalLabel.frame = labelFrame;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 40, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - 40 - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
