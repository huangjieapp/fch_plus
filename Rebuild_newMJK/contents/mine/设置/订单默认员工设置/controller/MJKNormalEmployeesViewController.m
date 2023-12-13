//
//  MJKNormalEmployeesViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKNormalEmployeesViewController.h"
#import "MJKChooseEmployeesViewController.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKClueListSubModel.h"

#import "MJKRecheckTableViewCell.h"

@interface MJKNormalEmployeesViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKNormalEmployeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"订单相关负责人设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self HTTPNormalEmployeesDatas];
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
    if (model.X_REMARKNAME.length > 0) {
        cell.nameLabel.hidden = NO;
        cell.nameLabel.text = model.X_REMARKNAME;
    }
    cell.switchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0001"] ? NO : YES;
    cell.switchButtonActionBlock = ^{
        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
            model.X_REMARKNAME = @"";
            model.X_REMARK = @"";
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf httpSetRecheck:model];
        } else {
            
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                 model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
                model.X_REMARK = showModel.user_id;
                model.X_REMARKNAME = showModel.user_name;
                [weakSelf httpSetRecheck:model];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
           
            
        }
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

- (void)HTTPNormalEmployeesDatas {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = @"27";
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

-(void)httpSetRecheck:(MJKCustomReturnSubModel *)model {
    //    DBSelf(weakSelf);
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = model.C_ID;
    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    
//    if (model.X_REMARK.length > 0) {
        contentDict[@"X_REMARK"] = model.X_REMARK;
//    }
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([model.C_NAME isEqualToString:@"默认设计负责人"]) {
                [NewUserSession instance].configData.C_DESIGNER_ROLEID = model.X_REMARK;
                [NewUserSession instance].configData.C_DESIGNER_ROLENAME = model.X_REMARKNAME;
            } else if ([model.C_NAME isEqualToString:@"默认下单负责人"]) {
                [NewUserSession instance].configData.C_BILLINGID = model.X_REMARK;
                [NewUserSession instance].configData.C_BILLINGNAME = model.X_REMARKNAME;
            } else if ([model.C_NAME isEqualToString:@"默认仓储物流负责人"]) {
                [NewUserSession instance].configData.C_WLCCRY_ROLEID = model.X_REMARK;
                [NewUserSession instance].configData.C_WLCCRY_ROLENAME = model.X_REMARKNAME;
            } else if ([model.C_NAME isEqualToString:@"默认安装负责人"]) {
                [NewUserSession instance].configData.C_AZRY_ROLEID = model.X_REMARK;
                [NewUserSession instance].configData.C_AZRY_ROLENAME = model.X_REMARKNAME;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
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
