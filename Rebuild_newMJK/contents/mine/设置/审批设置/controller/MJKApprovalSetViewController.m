//
//  MJKApprovalSetViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/9/10.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKApprovalSetViewController.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKRecheckTableViewCell.h"

@interface MJKApprovalSetViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** data array*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKApprovalSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"审批设置";
    [self.view addSubview:self.tableView];
    [self getList];
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
    MJKRecheckTableViewCell *cell = [MJKRecheckTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = model.C_NAME;
    cell.switchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0001"] ? NO : YES;
    cell.switchButtonActionBlock = ^{
        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
        } else {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
        }
        [weakSelf httpSetRecheck:model];
    };
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

- (void)getList {
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"TYPE"] = @"37";
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)httpSetRecheck:(MJKCustomReturnSubModel *)model {
    //    DBSelf(weakSelf);
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = model.C_ID;
    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([model.C_NAME isEqualToString:@"潜客战败"]) {
                [NewUserSession instance].configData.IS_QKZB = model.C_STATUS_DD_ID;
            } else if ([model.C_NAME isEqualToString:@"潜客激活"]) {
                [NewUserSession instance].configData.IS_QKJH = model.C_STATUS_DD_ID;
            } else if ([model.C_NAME isEqualToString:@"潜客转出"]) {
                [NewUserSession instance].configData.IS_QKZC = model.C_STATUS_DD_ID;
            } else if ([model.C_NAME isEqualToString:@"订单价格"]) {
                [NewUserSession instance].configData.IS_DDJG = model.C_STATUS_DD_ID;
            } else if ([model.C_NAME isEqualToString:@"订单取消"]) {
                [NewUserSession instance].configData.IS_DDQX = model.C_STATUS_DD_ID;
            } else if ([model.C_NAME isEqualToString:@"订单交付"]) {
                [NewUserSession instance].configData.IS_DDJF = model.C_STATUS_DD_ID;
            }
            [JRToast showWithText:@"操作成功"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
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
