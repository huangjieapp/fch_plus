//
//  MJKOrderStatusViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKOrderStatusViewController.h"

#import "MJKOrderStatusTableViewCell.h"

@interface MJKOrderStatusViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *preDic;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKOrderStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.vcName;
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    if ([self.vcName isEqualToString:@"关联订单状态"]) {
        for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42000_C_STATUS"] ) {
            if ([model.C_VOUCHERID isEqualToString:@"A42000_C_STATUS_0000"] ||
                [model.C_VOUCHERID isEqualToString:@"A42000_C_STATUS_0001"] ||
                [model.C_VOUCHERID isEqualToString:@"A42000_C_STATUS_0003"]) {
                continue;
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"name"] = model.C_NAME;
            dic[@"c_id"] = model.C_VOUCHERID;
            if ([model.C_VOUCHERID isEqualToString:self.C_VOUCHERID]) {
                dic[@"isSelect"] = @"1";
                self.preDic = dic;
            } else {
                dic[@"isSelect"] = @"0";
            }
            
            [self.dataArray addObject:dic];
        }
    } else if ([self.vcName isEqualToString:@"节点对应的任务"]) {
        for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TYPE"] ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"name"] = model.C_NAME;
            dic[@"c_id"] = model.C_VOUCHERID;
            dic[@"isSelect"] = @"0";
            [self.dataArray addObject:dic];
        }
    }
    else {
        for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A47300_C_DYSJD"] ) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic[@"name"] = model.C_NAME;
            dic[@"c_id"] = model.C_VOUCHERID;
            dic[@"isSelect"] = @"0";
            [self.dataArray addObject:dic];
        }
    }
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    MJKOrderStatusTableViewCell *cell = [MJKOrderStatusTableViewCell cellWithTableView:tableView];
    cell.dataDic = dic;
    cell.selectButton.tag = indexPath.row;
    [cell.selectButton addTarget:self action:@selector(selectButtonAction:)];
    return cell;
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

- (void)selectButtonAction:(UIButton *)sender {
    if ([self.preDic[@"isSelect"] isEqualToString:@"1"]) {
        self.preDic[@"isSelect"] = @"0";
    } else {
        self.preDic[@"isSelect"] = @"1";
    }
    NSMutableDictionary *dic = self.dataArray[sender.tag];
    if ([dic[@"isSelect"] isEqualToString:@"1"]) {
        dic[@"isSelect"] = @"0";
    } else {
        dic[@"isSelect"] = @"1";
    }
    self.preDic = dic;
    [self.tableView reloadData];
}

- (void)commitButtonAction {
    for (NSDictionary *dic in self.dataArray) {
        if ([dic[@"isSelect"] isEqualToString:@"1"]) {
            if (self.backBlack) {
                self.backBlack(dic);
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 44)];
        [button setTitleNormal:@"提交"];
        [button setBackgroundColor:KNaviColor];
        [button setTitleColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(commitButtonAction)];
        button.layer.cornerRadius = 5.f;
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

@end
