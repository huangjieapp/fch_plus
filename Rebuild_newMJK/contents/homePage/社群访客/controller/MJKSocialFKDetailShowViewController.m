//
//  MJKSocialFKDetailShowViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/1/21.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKSocialFKDetailShowViewController.h"
#import "MJKSocialFKDetailShowTableViewCell.h"
#import "MJKSocialFKModel.h"

@interface MJKSocialFKDetailShowViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKSocialFKDetailShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"访客中心";
    [self.view addSubview:self.tableView];
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pageSize = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageSize = 20;
        [weakSelf httpGetPersonDataValue];
        
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageSize += 20;
        [weakSelf httpGetPersonDataValue];
        
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
    MJKSocialFKDetailShowTableViewCell *cell = [MJKSocialFKDetailShowTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
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

- (void)httpGetPersonDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getCustomerList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    //{"currPage":1,"userToken":"1000000840178329","type":1,"pageSize":10}
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = @(self.pageSize);
    contentDic[@"type"] = @"1";
    contentDic[@"userToken"] = self.userToken;
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
