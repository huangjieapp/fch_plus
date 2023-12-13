//
//  MJKCarSourceViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/16.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCarSourceViewController.h"

#import "MJKCarSourceModel.h"
#import "MJKCarSourceSubModel.h"

#import "MJKProductShowModel.h"

#import "MJKCarSourceTableViewCell.h"

@interface MJKCarSourceViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** submit view*/
@property (nonatomic, strong) UIView *bottomView;
/** 每页条数*/
@property (nonatomic, assign) NSInteger pagen;
/** dataArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MJKCarSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"选择车源";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self configRefresh];
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf getCarSourceData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf getCarSourceData];
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
    MJKCarSourceSubModel *model = self.dataArray[indexPath.row];
    MJKCarSourceTableViewCell *cell = [MJKCarSourceTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
- (void)getCarSourceData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A71000WebService-list"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"currPage"] = @"1";
    dic[@"pageSize"] = [NSString stringWithFormat:@"%ld",(long)self.pagen];
    dic[@"TYPE"] = @"0";
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *mainArray = [MJKCarSourceModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            weakSelf.dataArray = [NSMutableArray array];
            for (MJKCarSourceModel *model in mainArray) {
                NSArray *arr = [MJKCarSourceSubModel mj_objectArrayWithKeyValuesArray:model.content];
                [weakSelf.dataArray addObjectsFromArray:arr];
            }
            for (MJKCarSourceSubModel *model in weakSelf.dataArray) {
                for (MJKProductShowModel *subModel in self.productArray) {
                    if ([subModel.C_ID isEqualToString:model.C_ID]) {
                        model.selected = YES;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - click
- (void)submitAction:(UIButton *)sender {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MJKCarSourceSubModel *model in self.dataArray) {
        if (model.isSelected == YES) {
            MJKProductShowModel *subModel = [[MJKProductShowModel alloc]init];
            subModel.X_FMPICURL = model.C_BY_A49600_C_PICTURE;
            subModel.X_REMARK = model.C_BY_A49600_C_NAME;
            subModel.B_HDJ = model.C_XSCKJ;
            subModel.C_ID = model.C_ID;
            [arr addObject:subModel];
        }
    }
    if (self.chooseProductBlock) {
        self.chooseProductBlock(arr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.bottomView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 45)];
        [button setTitleNormal:@"提交"];
        [button setTitleColor:[UIColor blackColor]];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(submitAction:)];
        [button setBackgroundColor:KNaviColor];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

@end
