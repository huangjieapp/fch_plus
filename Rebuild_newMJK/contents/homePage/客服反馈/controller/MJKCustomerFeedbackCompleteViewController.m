//
//  MJKCustomerFeedbackDetailViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/9/24.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCustomerFeedbackCompleteViewController.h"
#import "MJKAfterManageViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKOldCustomerSalesModel.h"

#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"

#import "MJKCustomerFeedbackModel.h"

#import "PotentailCustomerEditModel.h"
#import "MJKCustomerFeedbackModel.h"

#import "CGCNewAppointTextCell.h"
#import "MJKClueListSubModel.h"

@interface MJKCustomerFeedbackCompleteViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_OWNER_ROLEID;
@property (nonatomic, strong) NSString *C_OWNER_ROLENAME;
@property (nonatomic, strong) NSString *C_WXRY_ROLEID;
@property (nonatomic, strong) NSString *C_WXRY_ROLENAME;
@property (nonatomic, strong) NSString *I_SFCSFY;
@property (nonatomic, strong) NSString *B_FYJE;
@property (nonatomic, strong) NSString *C_WXFA;
@property (nonatomic, strong) NSString *X_KHYJ;
@property (nonatomic, strong) NSString *C_WWXYY_DD_ID;
@property (nonatomic, strong) NSString *C_WWXYY_DD_NAME;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *cellArray;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKCustomerFeedbackCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"售后处理";
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight-55);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    self.C_OWNER_ROLEID = self.model.C_OWNER_ROLEID;
    self.C_OWNER_ROLENAME = self.model.C_OWNER_ROLENAME;
    [self.view addSubview:self.bottomView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSString *cellStr = self.cellArray[indexPath.row];
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    ccell.nameTitleLabel.text = cellStr;
    AddCustomerInputTableViewCell *icell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    icell.nameTitleLabel.text = cellStr;
    if ([cellStr isEqualToString:@"责任人"]) {
        if (self.C_OWNER_ROLENAME.length > 0) {
            ccell.textStr = self.C_OWNER_ROLENAME;
        }
        ccell.Type = chooseTypeNil;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    //        vc.isAllEmployees = @"是";
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                weakSelf.C_OWNER_ROLENAME=model.user_name;
                weakSelf.C_OWNER_ROLEID=model.u051Id;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    }  else if ([cellStr isEqualToString:@"维修人员"]) {
        if (self.C_WXRY_ROLENAME.length > 0) {
            ccell.textStr = self.C_WXRY_ROLENAME;
        }
        ccell.Type = chooseTypeNil;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    //        vc.isAllEmployees = @"是";
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                weakSelf.C_WXRY_ROLENAME=model.user_name;
                weakSelf.C_WXRY_ROLEID=model.u051Id;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    } else if ([cellStr isEqualToString:@"是否产生费用"]) {
        if (self.I_SFCSFY.length > 0) {
            ccell.textStr = [self.I_SFCSFY isEqualToString:@"0"] ? @"否" : @"是";
        }
        ccell.Type = chooseTypeIsOutType;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            if ([postValue isEqualToString:@"1"]) {
                if (![weakSelf.cellArray containsObject:@"费用金额"]) {
                [weakSelf.cellArray insertObject:@"费用金额" atIndex:3];
                }
            } else {
                if ([weakSelf.cellArray containsObject:@"费用金额"]) {
                    [weakSelf.cellArray removeObject:@"费用金额"];
                }
            }
            weakSelf.I_SFCSFY = postValue;
            [tableView reloadData];
        };
        return ccell;
    } else if ([cellStr isEqualToString:@"费用金额"]) {
        if (self.B_FYJE.length > 0) {
            icell.textStr = self.B_FYJE;
        }
        icell.changeTextBlock = ^(NSString *textStr) {
            self.B_FYJE = textStr;
        };
        return icell;
    } else if ([cellStr isEqualToString:@"维修方案"]) {
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//            cell.mustLabel.hidden = NO;
        cell.topTitleLabel.text=cellStr;
        if (self.C_WXFA.length > 0) {
            cell.beforeText=self.C_WXFA;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.C_WXFA=textStr;
        };
        
        
        
        
        return cell;
        
    } else if ([cellStr isEqualToString:@"客户意见"]) {
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//            cell.mustLabel.hidden = NO;
        cell.topTitleLabel.text=cellStr;
        if (self.X_KHYJ.length > 0) {
            cell.beforeText=self.X_KHYJ;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.X_KHYJ=textStr;
        };
        
        
        
        //屏幕的上移问题
        
        return cell;
        
    } else if ([cellStr isEqualToString:@"未维修好原因"]) {
        if (self.C_WWXYY_DD_NAME.length > 0) {
            ccell.textStr = self.C_WWXYY_DD_NAME;
        }
        ccell.Type = ChooseTableViewTypeWWXYY;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.C_WWXYY_DD_ID = postValue;
            weakSelf.C_WWXYY_DD_NAME = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"维修方案"] || [cellStr isEqualToString:@"客户意见"]) {
        return 120;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)submitAction {
    if (self.C_OWNER_ROLEID.length <=0 ) {
        [JRToast showWithText:@"请选择责任人"];
        return;
        
    }
    if (self.I_SFCSFY.length <=0 ) {
        [JRToast showWithText:@"请选择是否产生费用"];
        return;
        
    }
    if (self.C_WXFA.length <=0 ) {
        [JRToast showWithText:@"请输入维修方案"];
        return;
        
    }
    
    
    if (self.X_KHYJ.length <=0 ) {
        [JRToast showWithText:@"请输入客户意见"];
        return;
        
    }
    
    [self httpGetOperationWc];
}

- (void)httpGetOperationWc {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.model.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.model.C_ID;
    }
    if (self.C_OWNER_ROLEID.length > 0) {
        contentDic[@"C_OWNER_ROLEID"] = self.C_OWNER_ROLEID;
    }
    if (self.C_WXRY_ROLEID.length > 0) {
        contentDic[@"C_WXRY_ROLEID"] = self.C_WXRY_ROLEID;
    }
    if (self.I_SFCSFY.length > 0) {
        contentDic[@"I_SFCSFY"] = self.I_SFCSFY;
    }
    if (self.C_WXFA.length > 0) {
        contentDic[@"C_WXFA"] = self.C_WXFA;
    }
    if (self.X_KHYJ.length > 0) {
        contentDic[@"X_KHYJ"] = self.X_KHYJ;
    }
    if (self.I_SFCSFY.length > 0) {
        contentDic[@"C_WWXYY_DD_ID"] = self.C_WWXYY_DD_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a815/operationWc", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            for (UIViewController *vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MJKAfterManageViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 45)];
        [button setTitleNormal:@"提交"];
        [button setTitleColor:[UIColor blackColor]];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(submitAction)];
        [button setBackgroundColor:KNaviColor];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [@[@"责任人",@"维修人员",@"是否产生费用",@"维修方案",@"客户意见",@"未维修好原因"] mutableCopy] ;
    }
    return _cellArray;
}


@end
