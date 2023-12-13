//
//  MJKSharePublicFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKSharePresonalFolderViewController.h"
#import "MJKShareFolderViewController.h"

#import "MJKFolderTableViewCell.h"

#import "MJKFileDetailModel.h"

@interface MJKSharePresonalFolderViewController ()<UITableViewDataSource, UITableViewDelegate>
/** */
@property (nonatomic, strong)  UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKSharePresonalFolderViewController

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
    [self.view addSubview:self.tableView];
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf HTTPGetSaleDatas];
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
    MJKFileDetailModel *model = self.dataArray[indexPath.row];
    MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
    cell.folderNameTF.text = model.USER_NAME;
    cell.folderNameTF.enabled = NO;
    cell.deleteButton.hidden = cell.editButton.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    MJKFileDetailModel *model = self.dataArray[indexPath.row];
    MJKShareFolderViewController *vc = [[MJKShareFolderViewController alloc]init];
    vc.user_id = model.USER_ID;
    vc.vcName = @"个人文档";
    vc.user_name = model.USER_NAME;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http data
- (void)HTTPGetSaleDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70800WebService-getGrWj"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKFileDetailModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
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
