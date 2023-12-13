//
//  MJKSocialMarketViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/26.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewSocialMarketViewController.h"
#import "MJKSocialPresonShareViewController.h"

#import "CGCCustomDateView.h"

#import "MJKSocialMarketHeaderModel.h"
#import "MJKSocialMarketTeamListModel.h"

#import "MJKScoialMarketTeamTableViewCell.h"
#import "MJKScoialMarketTeamDetailTableViewCell.h"
#import "MJKNewScoialMarketTeamDetailTableViewCell.h"
#import "MJKNewScoialMarketTeamTableViewCell.h"


@interface MJKNewSocialMarketViewController ()<UITableViewDataSource, UITableViewDelegate>{
    NSString *_accountId;
}
/** 父节点*/
@property (nonatomic, strong) NSString *parentId;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *searchTime;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
/** pageSize*/
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** 第几层子数据*/
@property (nonatomic, strong) NSString *subStr;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *perButton;
@property (nonatomic, strong) UIView *perSepView;
/** <#注释#>*/
@property (nonatomic, strong) MJKSocialMarketHeaderModel *socialMarketHeaderModel;
@end

@implementation MJKNewSocialMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    _accountId = [NewUserSession instance].accountId;
    self.title = @"社群营销数据中心";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configHeaderView];
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

- (void)configHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50 + (i * ((KScreenWidth - 100) / 5)), 5, (KScreenWidth - 100) / 5, 45)];
        [button setTitleNormal:@[@"今天",@"7天",@"30天",@"90天",@"自定义"][i]];
        [button setTitleColor:[UIColor blackColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        button.tag = 100 + i;
        if (i == 0) {
            [button setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
            self.perButton = button;
            
            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y, button.frame.size.width, 2)];
            self.perSepView = sepView;
            sepView.backgroundColor = [UIColor colorWithHex:@"#3E5687"];
            [headerView addSubview:sepView];
        }
        [button addTarget:self action:@selector(chooseTimeAction:)];
        [headerView addSubview:button];
        
        
    }
    
    [self.view addSubview:headerView];
}

- (void)chooseTimeAction:(UIButton *)sender {
    DBSelf(weakSelf);
    if ([sender.titleLabel.text isEqualToString:@"自定义"]) {
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
            
        } withSure:^(NSString *start, NSString *end) {
            MyLog(@"11--%@   22--%@",start,end);
            weakSelf.startTime = start;
            weakSelf.endTime = end;
            weakSelf.searchTime = @"";
            
            [weakSelf.tableView.mj_header beginRefreshing];
            
        }];


        dateView.clickCancelBlock = ^{
        
            
        };



        [[UIApplication sharedApplication].keyWindow addSubview:dateView];
    } else {

    self.searchTime = [NSString stringWithFormat:@"%ld",sender.tag - 100 + 1] ;
        self.startTime = @"";
        self.endTime = @"";
        [self.tableView.mj_header beginRefreshing];
    }
    self.perSepView.centerX = sender.centerX;
    [sender setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
    
    [self.perButton setTitleColor:[UIColor blackColor]];
    
    self.perButton = sender;
}

- (void)backVCAction {
    if ([self.subStr isEqualToString:@"1"]) {
        self.subStr = @"";
        self.title = @"社群营销数据中心";
        _accountId = [NewUserSession instance].accountId;
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
        if ([self.subStr isEqualToString:@"1"]) {
        MJKScoialMarketTeamTableViewCell *cell = [MJKScoialMarketTeamTableViewCell cellWithTableView:tableView];
        cell.model = self.socialMarketHeaderModel;
            cell.nameArray = @[@"素材量", @"分享/转发",@"浏览人数/次数", @"线索量"];
        return cell;
        } else {
            MJKNewScoialMarketTeamDetailTableViewCell *cell = [MJKNewScoialMarketTeamDetailTableViewCell cellWithTableView:tableView];
            cell.model = self.socialMarketHeaderModel;
            return cell;
        }
    } else {
        MJKSocialMarketTeamListModel *model = self.dataArray[indexPath.row - 1];
        if ([self.subStr isEqualToString:@"1"]) {
            MJKScoialMarketTeamDetailTableViewCell *cell = [MJKScoialMarketTeamDetailTableViewCell cellWithTableView:tableView];
            
                cell.subModel = model;
            return cell;
        } else {
            
            MJKNewScoialMarketTeamTableViewCell *cell = [MJKNewScoialMarketTeamTableViewCell cellWithTableView:tableView];
           
                cell.model = model;
            
            return cell;
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 70;
    }
    return 44;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.subStr.length <= 0) {
        self.subStr = @"1";
        MJKSocialMarketTeamListModel *model = self.dataArray[indexPath.row - 1];
        self.title = [NSString stringWithFormat:@"%@团队",model.name];
        _accountId = model.objectid;
        [tableView.mj_header beginRefreshing];
    } else if ([self.subStr isEqualToString:@"1"]) {
        MJKSocialPresonShareViewController *vc = [[MJKSocialPresonShareViewController alloc]init];
        vc.accountId =  _accountId;
        vc.searchTime = self.searchTime;
        vc.startTime = self.startTime;
        vc.endTime = self.endTime;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

#pragma mark - http
- (void)httpGetNumberDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getAllTeamNumber"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if ([self.subStr isEqualToString:@"1"]) {
        contentDic[@"userToken"] = _accountId;
    }
    contentDic[@"type"] = [self.subStr isEqualToString:@"1"] ? @"2" : @"1";
    if (self.searchTime.length > 0) {
        contentDic[@"searchTime"] = self.searchTime;
    }
    if (self.startTime.length > 0) {
        contentDic[@"startTime"] = self.startTime;
    }
    if (self.endTime.length > 0) {
        contentDic[@"endTime"] = self.endTime;
    }
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.socialMarketHeaderModel = [MJKSocialMarketHeaderModel mj_objectWithKeyValues:data];
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
    contentDic[@"userToken"] = _accountId;
    contentDic[@"type"] = [self.subStr isEqualToString:@"1"] ? @"2" : @"1";
    if (self.searchTime.length > 0) {
        contentDic[@"searchTime"] = self.searchTime;
    }
    if (self.startTime.length > 0) {
        contentDic[@"startTime"] = self.startTime;
    }
    if (self.endTime.length > 0) {
        contentDic[@"endTime"] = self.endTime;
    }
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = [NSString stringWithFormat:@"%ld",(long)self.pageSize];
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            weakSelf.socialMarketHeaderModel = [MJKSocialMarketHeaderModel mj_objectWithKeyValues:data];
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 55, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
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
