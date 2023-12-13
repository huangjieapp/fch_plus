//
//  MJKGoodPaperViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKGoodPaperViewController.h"

#import "MJKCustomReturnSubModel.h"

#import "MJKGoodPaperInputTableViewCell.h"
#import "MJKGoodPaperSwitchTableViewCell.h"

@interface MJKGoodPaperViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** bottom*/
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKGoodPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"喜报设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self HTTPDatas];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == self.dataArray.count - 1) {
        MJKGoodPaperInputTableViewCell *cell = [MJKGoodPaperInputTableViewCell cellWithTableView:tableView];
        cell.inputTextView.text = model.X_FIRSTREMARK;
        cell.textViewChangeBlock = ^(NSString * _Nonnull str) {
            model.X_FIRSTREMARK = str;
        };
        return cell;
    } else {
        MJKGoodPaperSwitchTableViewCell *cell = [MJKGoodPaperSwitchTableViewCell cellWithTableView:tableView];
        cell.contentTF.text = model.C_NAME;
        cell.openSwitch.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
        cell.openSwitchBlock = ^(BOOL isOn) {
            model.C_STATUS_DD_ID = isOn == YES ? @"A47500_C_STATUS_0000" : @"A47500_C_STATUS_0001";
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 65;
    } else if (indexPath.row == self.dataArray.count - 1) {
        return 100;
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

- (void)HTTPDatas {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = @"41";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}
-(void)updateDatasWithArray:(NSArray *)array{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : array} compliation:^(id data, NSError *error) {
    
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark - click
- (void)saveButtonAction {
    NSMutableArray *arr = [NSMutableArray array];
    for (MJKCustomReturnSubModel *model in self.dataArray) {
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"C_ID"] = model.C_ID;
        contentDic[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
        contentDic[@"X_FIRSTREMARK"] = model.X_FIRSTREMARK;
        [arr addObject:contentDic];
    }
    [self updateDatasWithArray:arr];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        button.backgroundColor = KNaviColor;
        [button setTitleNormal:@"保存"];
        [button setTitleColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(saveButtonAction)];
        button.layer.cornerRadius = 5.f;
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

@end
