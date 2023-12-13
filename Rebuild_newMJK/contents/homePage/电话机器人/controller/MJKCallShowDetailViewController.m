//
//  MJKCallShowDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCallShowDetailViewController.h"

#import "MJKCallShowDetailTableViewCell.h"

#import "MJKCallShowDetailModel.h"

#import <objc/runtime.h>
#import "MJKShowSendView.h"

#import "MJKTelephoneRobotViewController.h"

@interface MJKCallShowDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 批量拨打按钮*/
@property (nonatomic, strong)  UIButton *batchCallButton;
/** totalLabel*/
@property (nonatomic, strong) UILabel *totalLabel;
/** listDataArray*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
/** totalStr*/
@property (nonatomic, strong) NSString *totalStr;
@end

@implementation MJKCallShowDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.title = @"呼叫任务查看";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self HTTPListData];
    
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.batchCallButton];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 90, NavStatusHeight, 90, 20)];
    imageView.image = [UIImage imageNamed:@"all_bg"];
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 90, 20)];
    self.totalLabel.font = [UIFont systemFontOfSize:12.f];
    self.totalLabel.textColor = [UIColor darkGrayColor];
    self.totalLabel.text = @"总计:0";
    self.totalLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:imageView];
    [imageView addSubview:self.totalLabel];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCallShowDetailModel *model = self.listDataArray[indexPath.row];
    MJKCallShowDetailTableViewCell *cell = [MJKCallShowDetailTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKCallShowDetailModel *model = self.listDataArray[indexPath.row];
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [weakSelf HTTPDeleteData:model.X_REMARK];
        [weakSelf.listDataArray removeObject:model];
        [tableView reloadData];
        weakSelf.totalStr = [NSString stringWithFormat:@"%ld",[weakSelf.totalStr integerValue] - 1];
        weakSelf.totalLabel.text = [NSString stringWithFormat:@"总计:%@",weakSelf.totalStr];
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return @[deleteAction];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    bgView.backgroundColor = kBackgroundColor;
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)batchCallAction {
    if (self.listDataArray.count <= 0) {
        [JRToast showWithText:@"无呼叫任务"];
        return;
    }
    DBSelf(weakSelf);
     MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:self.view.frame andButtonTitleArray:@[@"取消",@"确认"] andTitle:@"" andMessage:[NSString stringWithFormat:@"共有%@个客户需要电话任务呼叫\n请再次确认,之后不可修改!",self.totalStr]];
    __block MJKShowSendView *showViewBlock = showView;
    showView.buttonActionBlock = ^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"确认"]) {
            [weakSelf HTTPSubmitData];
        }
    };
    
    [self.view addSubview:showView];
}

- (void)HTTPListData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70100WebService-getHJList"];
    NSMutableDictionary *contentDic=[NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.listDataArray = [MJKCallShowDetailModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
            weakSelf.totalStr = data[@"countNumber"];
            weakSelf.totalLabel.text = [NSString stringWithFormat:@"总计:%@",weakSelf.totalStr];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (void)HTTPDeleteData:(NSString *)X_REMARK {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70100WebService-deteleHJ"];
    NSMutableDictionary *contentDic=[NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    if (X_REMARK.length > 0) {
        contentDic[@"X_REMARK"] = X_REMARK;
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
//            [weakSelf HTTPListData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (void)HTTPSubmitData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70100WebService-insert"];
    NSMutableDictionary *contentDic=[NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    for (NSMutableDictionary *dic in self.searchDataArray) {
        if ([dic[@"C_ID"] length] > 0) {
            [contentDic setObject:dic[@"C_ID"] forKey:dic[@"id"]];
        }
        if ([dic[@"title"] isEqualToString:@"呼叫话术模板"]) {
            [contentDic setObject:dic[@"content"] forKey:@"nlpEventName"];
        }
    }
    //    contentDic[@"idList"] = self.listDataDic[@"idList"];
    //    contentDic[@"C_SOURCE_DD_ID"] = self.C_SOURCE_DD_ID;
    contentDic[@"nlpThemeId"] = self.nlpThemeId;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MJKTelephoneRobotViewController class]]) {
                    [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

#pragma mark - set
- (UIButton *)batchCallButton {
    if (!_batchCallButton) {
        _batchCallButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 44, KScreenWidth, 44)];
        [_batchCallButton setBackgroundColor:KNaviColor];
        [_batchCallButton setTitleNormal:@"批量拨打"];
        [_batchCallButton setTitleColor:[UIColor blackColor]];
        _batchCallButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_batchCallButton addTarget:self action:@selector(batchCallAction)];
    }
    return _batchCallButton;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - SafeAreaBottomHeight - 44) style:UITableViewStyleGrouped];
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
