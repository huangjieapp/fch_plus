//
//  MJKNewWorkReportSettingViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNewWorkReportSettingViewController.h"
#import "MJKNewAddWorkReportViewController.h"

#import "MJKSettingHeadView.h"
#import "MJKNewWorkReportCell.h"

#import "MJKPKModel.h"

@interface MJKNewWorkReportSettingViewController ()<UITableViewDataSource, UITableViewDelegate>
/** MJKSettingHeadView*/
@property (nonatomic, strong) MJKSettingHeadView *headView;
/** tabnleView*/
@property (nonatomic, strong) UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** addButton*/
@property (nonatomic, strong) UIButton *addButton;
@end

@implementation MJKNewWorkReportSettingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日报汇报内容设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    self.headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
    [self.view addSubview:self.headView];
    self.headView.headTitleArray = @[@"模板名称", @"人数"];
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view addSubview:self.tableView];
    
    [self configRefresh];
    
    [self.view addSubview:self.addButton];
    
    
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getListDatas];
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
    MJKPKModel *model = self.dataArray[indexPath.row];
    MJKNewWorkReportCell *cell = [MJKNewWorkReportCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKPKModel *model = self.dataArray[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf deleteGroup:model.C_ID];
    }];
    deleteAction.backgroundColor = KNaviColor;
    return @[deleteAction];
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
    MJKPKModel *model = self.dataArray[indexPath.row];
    
    MJKNewAddWorkReportViewController *vc = [[MJKNewAddWorkReportViewController alloc]init];
    vc.C_ID = model.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)deleteGroup:(NSString *)c_id{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48100WebService-delete"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = c_id;
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            [weakSelf getListDatas];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
}

#pragma mark - http request
-(void)getListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48100WebService-getAllList"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_TYPE_DD_ID"] = @"A48100_C_TYPE_0001";
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKPKModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)addButtonAction:(UIButton *)sender {
    MJKNewAddWorkReportViewController *vc = [[MJKNewAddWorkReportViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headView.frame), KScreenWidth, KScreenHeight - self.headView.frame.size.height - self.headView.frame.origin.y - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 50) / 2, KScreenHeight - 80, 50, 50)];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"addimg.png"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
