//
//  MJKSocialMarketViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSocialMarketViewController.h"

#import "MJKSocialMarketHeaderModel.h"
#import "MJKSocialMarketTeamListModel.h"

#import "MJKScoialMarketHeaderView.h"
#import "MJKScoialMarketTeamTableViewCell.h"
#import "MJKScoialMarketTeamDetailTableViewCell.h"

#define accountId [NewUserSession instance].accountId

@interface MJKSocialMarketViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 父节点*/
@property (nonatomic, strong) NSString *parentId;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKScoialMarketHeaderView *headerView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *searchTime;
/** pageSize*/
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** 第几层子数据*/
@property (nonatomic, strong) NSString *subStr;
@end

@implementation MJKSocialMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.title = @"社群营销数据中心";
    self.view.backgroundColor = [UIColor whiteColor];
    self.searchTime = @"1";
    [self configNavi];
    [self.view addSubview:self.tableView];
    
    [self configRefresh];
//    [self httpGetNumberDataValue];
}

- (void)configNavi {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:@"btn-返回"];
    [button addTarget:self action:@selector(backVCAction)];
    button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)backVCAction {
    if ([self.subStr isEqualToString:@"1"]) {
        self.subStr = @"";
        self.title = @"社群营销数据中心";
        [self.tableView.mj_header beginRefreshing];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pageSize = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageSize = 20;
        [weakSelf httpGetNumberDataValue];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize += 20;
        [weakSelf httpGetNumberDataValue];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MJKScoialMarketTeamTableViewCell *cell = [MJKScoialMarketTeamTableViewCell cellWithTableView:tableView];
        if ([self.subStr isEqualToString:@"1"]) {
            cell.nameArray = @[@"分享数", @"浏览人数",@"浏览量", @"意向客户"];
        } else {
            cell.nameArray = @[@"团队数", @"分享数", @"浏览人数",@"浏览量"];
        }
        return cell;
    } else {
        MJKSocialMarketTeamListModel *model = self.dataArray[indexPath.row - 1];
        MJKScoialMarketTeamDetailTableViewCell *cell = [MJKScoialMarketTeamDetailTableViewCell cellWithTableView:tableView];
        if ([self.subStr isEqualToString:@"1"]) {
            cell.subModel = model;
        } else {
            cell.model = model;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return ((KScreenWidth - 50) / 4) * 2 + 154;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.subStr.length <= 0) {
        self.subStr = @"1";
        MJKSocialMarketTeamListModel *model = self.dataArray[indexPath.row - 1];
        self.title = [NSString stringWithFormat:@"%@团队",model.name];
        [tableView.mj_header beginRefreshing];
    }
    
}

#pragma mark - http
- (void)httpGetNumberDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getTeamList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"userToken"] = accountId;
    contentDic[@"type"] = [self.subStr isEqualToString:@"1"] ? @"2" : @"1";
    contentDic[@"searchTime"] = self.searchTime;
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            MJKSocialMarketHeaderModel *model = [MJKSocialMarketHeaderModel mj_objectWithKeyValues:data];
            weakSelf.headerView.numberModel = model;
            [weakSelf httpGetDataValue];
        } else {
            [JRToast showWithText:data[@"message"]];
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
        }
        
    }];
}

- (void)httpGetDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getTeamList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"userToken"] = accountId;
    contentDic[@"type"] = [self.subStr isEqualToString:@"1"] ? @"2" : @"1";
    contentDic[@"searchTime"] = self.searchTime;
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = [NSString stringWithFormat:@"%ld",(long)self.pageSize];
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.dataArray = [MJKSocialMarketTeamListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (MJKScoialMarketHeaderView *)headerView {
    DBSelf(weakSelf);
    if (!_headerView) {
        _headerView = [[NSBundle mainBundle]loadNibNamed:@"MJKScoialMarketHeaderView" owner:nil options:nil].firstObject;
        _headerView.searchTimeActionBlock = ^(UIButton * _Nonnull button) {
            weakSelf.searchTime = [NSString stringWithFormat:@"%ld",button.tag - 100 + 1] ;
//            [weakSelf httpGetNumberDataValue];
            [weakSelf.tableView.mj_header beginRefreshing];
        };
    }
    
    return _headerView;
}


@end
