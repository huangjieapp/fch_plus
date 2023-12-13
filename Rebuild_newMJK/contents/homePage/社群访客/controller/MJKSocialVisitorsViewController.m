//
//  MJKSocialMarketViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSocialVisitorsViewController.h"
#import "MJKSocialFKDetailShowViewController.h"

#import "MJKSocialFKModel.h"

#import "MJKSocialFKHeaderView.h"
#import "MJKSocialFKTableViewCell.h"
#import "MJKSocialFKDetailTableViewCell.h"


@interface MJKSocialVisitorsViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSString *_accountId;
}
/** 父节点*/
@property (nonatomic, strong) NSString *parentId;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** pageSize*/
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** 第几层子数据*/
@property (nonatomic, strong) NSString *subStr;

@end

@implementation MJKSocialVisitorsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    _accountId = [NewUserSession instance].accountId;
    self.title = @"社群访客中心";
    self.view.backgroundColor = [UIColor whiteColor];
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
        self.title = @"社群访客中心";
        _accountId = [NewUserSession instance].accountId;
        [self.tableView.mj_header beginRefreshing];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if ([weakSelf.subStr isEqualToString:@"1"]) {
            [weakSelf httpGetPersonDataValue];
        } else {
            [weakSelf httpGetNumberDataValue];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKSocialFKModel *model = self.dataArray[indexPath.row];
    if ([self.subStr isEqualToString:@"1"]) {
        MJKSocialFKDetailTableViewCell *cell = [MJKSocialFKDetailTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    } else {
        MJKSocialFKTableViewCell *cell = [MJKSocialFKTableViewCell cellWithTableView:tableView];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJKSocialFKHeaderView *headerView = [[MJKSocialFKHeaderView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    if ([self.subStr isEqualToString:@"1"]) {
        headerView.titleArray = @[@"累计访客数",@"今日活跃数",@"新客户数"];
    } else {
        headerView.titleArray = @[@"团队数",@"累计访客数",@"今日活跃数",@"新客户数"];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.subStr.length <= 0) {
        self.subStr = @"1";
        MJKSocialFKModel *model = self.dataArray[indexPath.row];
        self.title = [NSString stringWithFormat:@"%@的访客情况",model.name];
        _accountId = model.objectid;
        [tableView.mj_header beginRefreshing];
    } else if ([self.subStr isEqualToString:@"1"]) {
        MJKSocialFKDetailShowViewController *vc = [[MJKSocialFKDetailShowViewController alloc]init];
        vc.userToken = _accountId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - http
- (void)httpGetNumberDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getTeamFKList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.dataArray = [MJKSocialFKModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
}

- (void)httpGetPersonDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getTeamGRList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"userToken"] = _accountId;
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.dataArray = [MJKSocialFKModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
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

@end
