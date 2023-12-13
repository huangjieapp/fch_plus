//
//  MJKRAndPViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/30.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKRAndPViewController.h"

#import "MJKCustomReturnSubModel.h"

#import "MJKPushSetListCell.h"
#import "MJKRewardsView.h"
#import "MJKPunishmentView.h"

@interface MJKRAndPViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** segmentedView*/
@property (nonatomic, strong) UIView *segmentedView;
/** segmentedControl*/
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKRAndPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"奖惩制度设置";
    [self.view addSubview:self.segmentedView];
    [self.view addSubview:self.tableView];
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (weakSelf.segmentedControl.selectedSegmentIndex == 0) {
            [weakSelf HTTPRPSetDatasWithType:@"38"];
        } else {
            [weakSelf HTTPRPSetDatasWithType:@"39"];
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
    DBSelf(weakSelf);
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    MJKPushSetListCell *cell = [MJKPushSetListCell cellWithTableView:tableView];
    cell.selectedSegmentIndex = self.segmentedControl.selectedSegmentIndex;
    cell.rpModel = model;
    __block MJKPushSetListCell *blockCell = cell;
    cell.openSwitchBlock = ^(BOOL isOn) {
        model.C_STATUS_DD_ID = isOn == YES ? @"A47500_C_STATUS_0000" : @"A47500_C_STATUS_0001";
        if (weakSelf.segmentedControl.selectedSegmentIndex == 0) {
            if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                NSString *str;
                if (model.C_NAME.length > 0) {
                    str = [model.C_NAME substringToIndex:3];
                }
                model.C_XFTYPE_DD_ID = @"A47500_C_XFTYPE_0000";
                MJKRewardsView *rv = [[NSBundle mainBundle]loadNibNamed:@"MJKRewardsView" owner:nil options:nil].lastObject;
                if ([str isEqualToString:@"夜猫奖"] || [str isEqualToString:@"早鸟奖"]) {
                    rv.hiddenStr = @"隐藏";
                }
//                rv.model = model;
                rv.cancelViewBlock = ^{
                    blockCell.openSwitchButton.on = NO;
                    model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                rv.fixedOrRandomBlock = ^(NSString * _Nonnull str) {
                    model.C_XFTYPE_DD_ID = str;
                };
                rv.changeValueBlock = ^(NSString * _Nonnull type, NSString * _Nonnull str) {
                    if ([type isEqualToString:@"number"]) {
                        model.I_INDEXNUMBER = str;
                    } else if ([type isEqualToString:@"money"]) {
                        model.B_FIXEDNUMBER = str;
                    } else if ([type isEqualToString:@"randomFirst"]) {
                        model.B_MINNUMBER = str;
                    } else {
                        model.B_MAXNUMBER = str;
                    }
                };
                rv.sureButtonActionBlock = ^{
                    [weakSelf httpOpenOrClosePush:model];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:rv];
            } else {
                [weakSelf httpOpenOrClosePush:model];
            }
        } else {
            if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                MJKPunishmentView *rv = [[NSBundle mainBundle]loadNibNamed:@"MJKPunishmentView" owner:nil options:nil].lastObject;
//                rv.model = model;
                rv.cancelViewBlock = ^{
                    blockCell.openSwitchButton.on = NO;
                    model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                
                rv.changeValueBlock = ^(NSString * _Nonnull str) {
                    model.B_FIXEDNUMBER = str;
                };
                rv.sureButtonActionBlock = ^{
                    [weakSelf httpOpenOrClosePush:model];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:rv];
            }  else {
                [weakSelf httpOpenOrClosePush:model];
            }
        }
        
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
    DBSelf(weakSelf);
    __block MJKPushSetListCell *blockCell = [tableView cellForRowAtIndexPath:indexPath];
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    
    if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
        if (weakSelf.segmentedControl.selectedSegmentIndex == 0) {
    //        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                NSString *str;
                if (model.C_NAME.length > 0) {
                    str = [model.C_NAME substringToIndex:3];
                }
//                model.C_XFTYPE_DD_ID = @"A47500_C_XFTYPE_0000";
                MJKRewardsView *rv = [[NSBundle mainBundle]loadNibNamed:@"MJKRewardsView" owner:nil options:nil].lastObject;
                if ([str isEqualToString:@"夜猫奖"] || [str isEqualToString:@"早鸟奖"]) {
                    rv.hiddenStr = @"隐藏";
                }
                rv.model = model;
//                rv.cancelViewBlock = ^{
//                    blockCell.openSwitchButton.on = NO;
//                    model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                };
                rv.fixedOrRandomBlock = ^(NSString * _Nonnull str) {
                    model.C_XFTYPE_DD_ID = str;
                };
                rv.changeValueBlock = ^(NSString * _Nonnull type, NSString * _Nonnull str) {
                    if ([type isEqualToString:@"number"]) {
                        model.I_INDEXNUMBER = str;
                    } else if ([type isEqualToString:@"money"]) {
                        model.B_FIXEDNUMBER = str;
                    } else if ([type isEqualToString:@"randomFirst"]) {
                        model.B_MINNUMBER = str;
                    } else {
                        model.B_MAXNUMBER = str;
                    }
                };
                rv.sureButtonActionBlock = ^{
                    [weakSelf httpOpenOrClosePush:model];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:rv];
    //        } else {
    //            [weakSelf httpOpenOrClosePush:model];
    //        }
        } else {
    //        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                MJKPunishmentView *rv = [[NSBundle mainBundle]loadNibNamed:@"MJKPunishmentView" owner:nil options:nil].lastObject;
                rv.model = model;
//                rv.cancelViewBlock = ^{
//                    blockCell.openSwitchButton.on = NO;
//                    model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//                };
            
                rv.changeValueBlock = ^(NSString * _Nonnull str) {
                    model.B_FIXEDNUMBER = str;
                };
                rv.sureButtonActionBlock = ^{
                    [weakSelf httpOpenOrClosePush:model];
                };
                [[UIApplication sharedApplication].keyWindow addSubview:rv];
    //        }  else {
    //            [weakSelf httpOpenOrClosePush:model];
    //        }
        }
    }
}

#pragma mark - touch action
- (void)segmentedChangeValue:(UISegmentedControl *)sender {
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - http data
- (void)HTTPRPSetDatasWithType:(NSString *)type {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = type;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)httpOpenOrClosePush:(MJKCustomReturnSubModel *)model {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = model.C_ID;
    dic[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        dic[@"I_INDEXNUMBER"] = model.I_INDEXNUMBER;
        if ([model.C_XFTYPE_DD_ID isEqualToString:@"A47500_C_XFTYPE_0000"]) {
            dic[@"B_FIXEDNUMBER"] = model.B_FIXEDNUMBER;
        } else {
            dic[@"B_MINNUMBER"] = model.B_MINNUMBER;
            dic[@"B_MAXNUMBER"] = model.B_MAXNUMBER;
        }
        
        dic[@"C_XFTYPE_DD_ID"] = model.C_XFTYPE_DD_ID;
    } else {
        dic[@"B_FIXEDNUMBER"] = model.B_FIXEDNUMBER;
        dic[@"C_XFTYPE_DD_ID"] = @"A47500_C_XFTYPE_0000";
    }
    
    
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.segmentedView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.segmentedView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIView *)segmentedView {
    if (!_segmentedView) {
        _segmentedView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 55)];
        self.segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"红包", @"罚单"]];
        self.segmentedControl.frame = CGRectMake((KScreenWidth - 200) / 2, 10, 200, 35);
        self.segmentedControl.tintColor = KNaviColor;
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl addTarget:self action:@selector(segmentedChangeValue:) forControlEvents:UIControlEventValueChanged];
        [_segmentedView addSubview:self.segmentedControl];
        
    }
    return _segmentedView;
}

@end
