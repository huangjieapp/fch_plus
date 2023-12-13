//
//  MJKWorkReportSettingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/9.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKConfigWorkReportViewController.h"

#import "MJKWorkReportSetCell.h"
#import "MJKSeaSettingCell.h"

#import "MJKDataDicModel.h"
#import "MJKCustomReturnSubModel.h"

@interface MJKConfigWorkReportViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 数据*/
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MJKConfigWorkReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.title = @"汇报内容";
    
    [self initUI];
}

- (void)initUI {
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    //默认数据
    for (MJKDataDicModel *model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A48700_C_TYPE"]) {
        [self.dataArray addObject:model];
    }
    if (self.workArray.count > 0) {
        for (MJKDataDicModel *model in self.workArray) {
            for (MJKDataDicModel *subModel in self.dataArray) {
                if ([model.C_VOUCHERID isEqualToString:subModel.C_VOUCHERID]) {
                    subModel.selected = YES;
                }
            }
        }
    }
    [self configLeftItem];
}

- (void)configLeftItem {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setImage:@"btn-返回"];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    [button addTarget:self action:@selector(backButtonAvtion:)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

- (void)backButtonAvtion:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray array];
    for (MJKDataDicModel *model in self.dataArray) {
        if (model.isSelected == YES) {
            [arr addObject:model];
        }
    }
    if (self.backSelectArrayBlock) {
        self.backSelectArrayBlock(arr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKWorkReportSetCell *cell = [MJKWorkReportSetCell cellWithTableView:tableView];
        MJKDataDicModel *model = self.dataArray[indexPath.row];
        //编辑状态时的cell
        cell.nameLabel.text = model.C_NAME;
        if (model.isSelected == YES) {
            cell.openSwitchButton.on = YES;
        } else {
            cell.openSwitchButton.on = NO;
        }
        cell.openSwitchBlock = ^(BOOL isOn) {
            if (isOn == YES) {
                model.selected = YES;
            } else {
                model.selected = NO;
            }
        };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight , KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (NSArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
