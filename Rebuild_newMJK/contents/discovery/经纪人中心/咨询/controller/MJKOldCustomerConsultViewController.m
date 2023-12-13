//
//  MJKOldCustomerSalesViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/11/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKOldCustomerConsultViewController.h"
#import "MJKChooseNewBrandViewController.h"

#import "MJKOldCustomerConsultModel.h"

#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "CGCNewAppointTextCell.h"

@interface MJKOldCustomerConsultViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *cellArray;
/** <#注释#>*/
@property (nonatomic, strong) MJKOldCustomerConsultModel *model;
@end

@implementation MJKOldCustomerConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"咨询信息";
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self httpGetConsult];
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
    if ([cellStr isEqualToString:@"客户"]) {
        if (self.model.C_KH_NAME.length > 0) {
            icell.textStr = self.model.C_KH_NAME;
        }
        icell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_KH_NAME = textStr;
        };
        return icell;
    } else if ([cellStr isEqualToString:@"客户电话"]) {
        if (self.model.C_KH_PHONE.length > 0) {
            icell.textStr = self.model.C_KH_PHONE;
        }
        icell.textFieldLength = 11;
        icell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        icell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_KH_PHONE = textStr;
        };
        return icell;
    } else if ([cellStr isEqualToString:@"咨询类型"]) {
        if (self.model.C_ZXLX_DD_ID.length > 0) {
            ccell.textStr = self.model.C_ZXLX_DD_NAME;
        }
        ccell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        ccell.C_TYPECODE = @"A81400_C_ZXLX";
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_ZXLX_DD_NAME = str;
            weakSelf.model.C_ZXLX_DD_ID = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([cellStr isEqualToString:@"紧急程度"]) {
        if (self.model.C_JJCD_DD_ID.length > 0) {
            ccell.textStr = self.model.C_JJCD_DD_NAME;
        }
        ccell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        ccell.C_TYPECODE = @"A81500_C_JJCD";
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_JJCD_DD_NAME = str;
            weakSelf.model.C_JJCD_DD_ID = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([cellStr isEqualToString:@"车架号"]) {
        if (self.model.C_VIN.length > 0) {
            icell.textStr = self.model.C_VIN;
        }
        icell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_VIN = textStr;
        };
        return icell;
    }  else if ([cellStr isEqualToString:@"责任人"]) {
        if (self.model.C_OWNER_ROLENAME.length > 0) {
            icell.textStr = self.model.C_OWNER_ROLENAME;
        }
        icell.inputTextField.enabled = NO;
        return icell;
    } else if ([cellStr isEqualToString:@"销售顾问"]) {
        if (self.model.C_XSGW_ROLENAME.length > 0) {
            icell.textStr = self.model.C_XSGW_ROLENAME;
        }
        icell.inputTextField.enabled = NO;
        return icell;
    } else if ([cellStr isEqualToString:@"接待人"]) {
        if (self.model.C_JDR.length > 0) {
            icell.textStr = self.model.C_JDR;
        }
        icell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_JDR = textStr;
        };
        return icell;
    } else if ([cellStr isEqualToString:@"接待时间"]) {
        if (self.model.D_JDSJ.length > 0) {
            ccell.textStr = self.model.D_JDSJ;
        }
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.D_JDSJ = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([cellStr isEqualToString:@"解决时间"]) {
        if (self.model.D_JJSJ.length > 0) {
            ccell.textStr = self.model.D_JJSJ;
        }
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.D_JJSJ = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([cellStr isEqualToString:@"跟进情况反馈"]) {
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=cellStr;
        if (self.model.C_GJQKFK.length > 0) {
            cell.beforeText=self.model.C_GJQKFK;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_GJQKFK=textStr;
        };
        
        
        
        //屏幕的上移问题
        cell.startInputBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = weakSelf.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                weakSelf.view.frame = frame;
                
            }];
        };
        
        cell.endBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = weakSelf.view.frame;
                
                frame.origin.y = 0.0;
                
                weakSelf.view.frame = frame;
                
            }];
            
            
        };
        return cell;
        
    } else if ([cellStr isEqualToString:@"最终结果"]) {
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=cellStr;
        if (self.model.C_ZZJG.length > 0) {
            cell.beforeText=self.model.C_ZZJG;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_ZZJG=textStr;
        };
        
        
        
        //屏幕的上移问题
        cell.startInputBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = weakSelf.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                weakSelf.view.frame = frame;
                
            }];
        };
        
        cell.endBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = weakSelf.view.frame;
                
                frame.origin.y = 0.0;
                
                weakSelf.view.frame = frame;
                
            }];
            
            
        };
        return cell;
        
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"最终结果"] || [cellStr isEqualToString:@"跟进情况反馈"]) {
        return 120;
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

- (void)httpGetConsult {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A47700_C_ID.length > 0) {
        contentDic[@"C_A47700_C_ID"] = self.C_A47700_C_ID;
    }
    
    if (self.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_SYSTEMDA814Info parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.model = [MJKOldCustomerConsultModel mj_objectWithKeyValues:data[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpAddConsult {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [self.model mj_keyValues];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMDA814Add parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpEditConsult {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [self.model mj_keyValues];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMDA814Edit parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitButtonAction {
    if (self.C_ID.length > 0) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a814:edit"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
        [self httpEditConsult];
    } else {
    [self httpAddConsult];
    }
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, KScreenWidth, KScreenHeight - NAVIHEIGHT - AdaptTabHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-55-AdaptTabHeight, KScreenWidth, 55)];
        UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, _bottomView.frame.size.width - 10, 45)];
        submitButton.layer.cornerRadius = 5.f;
        [submitButton setTitleNormal:@"提交"];
        [submitButton setTintColor:[UIColor blackColor]];
        [submitButton setBackgroundColor:KNaviColor];
        [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:submitButton];
    }
    return _bottomView;
}


- (NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"客户",@"客户电话",@"车架号",@"咨询类型",@"紧急程度",@"责任人",@"销售顾问",@"接待人",@"接待时间",@"解决时间",@"跟进情况反馈",@"最终结果"];
    }
    return _cellArray;
}

@end
