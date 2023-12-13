//
//  MJKCustomerFeedbackDetailViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/9/24.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCustomerFeedbackOperationViewController.h"
#import "MJKAfterManageViewController.h"

#import "MJKOldCustomerSalesModel.h"

#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"

#import "MJKCustomerFeedbackModel.h"

#import "PotentailCustomerEditModel.h"
#import "MJKCustomerFeedbackModel.h"

#import "CGCNewAppointTextCell.h"

@interface MJKCustomerFeedbackOperationViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_STATUS_DD_ID;
@property (nonatomic, strong) NSString *C_STATUS_DD_NAME;
@property (nonatomic, strong) NSString *C_JJCD_DD_ID;
@property (nonatomic, strong) NSString *C_JJCD_DD_NAME;
@property (nonatomic, strong) NSString *X_REMARK;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKCustomerFeedbackOperationViewController

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
    [self.view addSubview:self.bottomView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0002"]) {
        
        return 3;
    } else {
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    DBSelf(weakSelf);
    if (indexPath.row == 0) {
        ccell.nameTitleLabel.text = @"是否受理";
        ccell.Type = ChooseTableViewTypeA81500_C_STATUS;
        ccell.textStr = self.C_STATUS_DD_NAME?: @"";
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.C_STATUS_DD_NAME = str;
            weakSelf.C_STATUS_DD_ID = postValue;
            [weakSelf.tableView reloadData];
        };
        return ccell;
    } else if (indexPath.row == 1) {
        ccell.nameTitleLabel.text = @"紧急程度";
        ccell.Type=ChooseTableViewTypeA81500_C_JJCD;
        ccell.textStr = self.C_JJCD_DD_NAME ?:  @"";
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.C_JJCD_DD_NAME = str;
            weakSelf.C_JJCD_DD_ID = postValue;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if (indexPath.row == 2) {
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//            cell.mustLabel.hidden = NO;
        cell.topTitleLabel.text=@"不受理原因";
        cell.beforeText=self.X_REMARK ?: @"";
        
        
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.X_REMARK=textStr;
        };
        
        
        
        
        return cell;
        
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
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
    if (self.C_STATUS_DD_ID.length <=0 ) {
        [JRToast showWithText:@"请选择是否受理"];
        return;
        
    }
    if (self.C_JJCD_DD_ID.length <=0 ) {
        [JRToast showWithText:@"请选择紧急程度"];
        return;
        
    }
    if ([self.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0002"]) {
    if (self.X_REMARK.length <=0 ) {
        [JRToast showWithText:@"请输入未受理原因"];
        return;
        
    }
    }
    
    [self httpGetOperationSlt];
}

- (void)httpGetOperationSlt {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.model.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.model.C_ID;
    }
    if (self.C_STATUS_DD_ID.length > 0) {
        contentDic[@"C_STATUS_DD_ID"] = self.C_STATUS_DD_ID;
    }
    if (self.C_JJCD_DD_ID.length > 0) {
        contentDic[@"C_JJCD_DD_ID"] = self.C_JJCD_DD_ID;
    }
    if (self.X_REMARK.length > 0) {
        contentDic[@"X_REMARK"] = self.X_REMARK;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a815/operationSl", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
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


@end
