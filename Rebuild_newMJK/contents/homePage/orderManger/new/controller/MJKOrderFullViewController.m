//
//  MJKOrderFullViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/28.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKOrderFullViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKCarSourceHomeViewController.h"
#import "MJKChooseNewBrandViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKClueListSubModel.h"
#import "CGCOrderDetailModel.h"
#import "MJKCarSourceHomeModel.h"
#import "MJKProductShowModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"

@interface MJKOrderFullViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKOrderFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.Type == FullTypeFull) {
        self.title = @"订单全款";
    } else {
        self.title = @"订单出库";
    }
    
    [self getLocalDatas];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight - 55);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = NO;
    _tableView.backgroundColor = [UIColor clearColor];
    //    [_tableView registerClass:[OrderHeaderTableViewCell class] forCellReuseIdentifier:@"OrderHeaderTableViewCell"];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    _bottomView.backgroundColor = [UIColor whiteColor];
    
    UIButton *submitButton = [UIButton new];
    [_bottomView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
    }];
    [submitButton setBackgroundColor:KNaviColor];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    submitButton.layer.cornerRadius = 5.f;
    @weakify(self);
    [[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self submitOrder];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.localDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.localDatas[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    AddCustomerInputTableViewCell *icell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    if ([model.locatedTitle isEqualToString:@"备注"]) {
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=model.locatedTitle;
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.beforeText=model.nameValue;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue=textStr;
            model.postValue=textStr;
        };
        
        
        
        //屏幕的上移问题
        cell.startInputBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                self.view.frame = frame;
                
            }];
        };
        
        cell.endBlock = ^{
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                
                frame.origin.y = 0.0;
                
                self.view.frame = frame;
                
            }];
            
            
        };
        return cell;
    } if ([model.locatedTitle isEqualToString:@"绑定车源"]) {
        ccell.taglabel.hidden = YES;
        if (self.Type == FullTypeOut) {
            ccell.taglabel.hidden = NO;
        }
        ccell.Type = chooseTypeNil;
        ccell.textStr = model.nameValue;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MJKCarSourceHomeViewController *vc = [MJKCarSourceHomeViewController new];
            vc.VCName = @"车源";
            vc.chooseOrderBlock = ^(MJKCarSourceHomeSubModel * _Nonnull carModel) {
                for (int i = 0; i < weakSelf.localDatas.count; i++) {
                    NSArray *arr = weakSelf.localDatas[i];
                    for (int j = 0; j < arr.count; j++) {
                        PotentailCustomerEditModel *tempModel = arr[j];
                        PotentailCustomerEditModel *tmodel = weakSelf.localDatas[i][j];
                        if ([tempModel.locatedTitle isEqualToString:@"品牌车型"]) {
                            tmodel.postValue = carModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@",carModel.C_A70600_C_ID, carModel.C_A49600_C_ID] : @"";
                            tempModel.nameValue = carModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@",carModel.C_A70600_C_NAME, carModel.C_A49600_C_NAME] : @"";
                        }
                        if ([tempModel.locatedTitle isEqualToString:@"具体型号"]) {
                            tmodel.postValue = carModel.C_CAR_TYPE;
                            tempModel.nameValue = carModel.C_CAR_TYPE;
                        }
                        if ([tempModel.locatedTitle isEqualToString:@"车架号全号"]) {
                            tmodel.postValue = carModel.C_VIN;
                            tempModel.nameValue = carModel.C_VIN;
                        }
                        if ([tempModel.locatedTitle isEqualToString:@"厂家"]) {
                            tmodel.postValue = carModel.C_A80000CJ_C_ID;
                            tempModel.nameValue = carModel.C_A80000CJ_C_NAME;
                        }
                    }
                }
                model.postValue = carModel.C_ID;
                model.nameValue = carModel.C_VOUCHERID;
//                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView reloadData];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"品牌车型"]) {
        ccell.taglabel.hidden = NO;
        ccell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.Type = chooseTypeNil;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
           MJKChooseNewBrandViewController *vc = [[MJKChooseNewBrandViewController alloc]init];
           vc.rootVC = weakSelf;
            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                MJKProductShowModel *productModel = productArray[0];
                model.postValue = [NSString stringWithFormat:@"%@,%@", productModel.C_TYPE_DD_ID,productModel.C_ID];
                model.nameValue = [NSString stringWithFormat:@"%@,%@", productModel.C_TYPE_DD_NAME,productModel.C_NAME];
                    
                    
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
           [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"厂家"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80000_C_TYPE;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0006";
        ccell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"上牌地"]) {
            ccell.taglabel.hidden = NO;
        
        ccell.Type = ChooseTableViewTypeCity;
        ccell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"收款方式"]) {
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.C_TYPECODE = @"A42000_C_SKFS";
        ccell.textStr = model.nameValue;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"行业"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.C_TYPECODE = @"A41500_C_INDUSTRY";
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.nameValue = str;
            model.postValue = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"全款时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.nameValue = str;
            model.postValue = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"收款人"]) {
        ccell.Type = chooseTypeNil;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            //        vc.isAllEmployees = @"是";
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull cmodel) {
                model.nameValue=cmodel.nickName;
                model.postValue=cmodel.u051Id;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [self.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
        
    } else if ([model.locatedTitle isEqualToString:@"收款账号"])  {
        ccell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.Type = ChooseTableViewTypeA800YJSHZH;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0004";
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"保险公司"]) {
        if (self.Type == FullTypeOut) {
            ccell.taglabel.hidden = NO;
        }
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.Type = ChooseTableViewTypeA800YJSHZH;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0000";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"出库时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.nameValue = str;
            model.postValue = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"交强险到期日期"]) {
        if (self.Type == FullTypeOut) {
            ccell.taglabel.hidden = NO;
        }
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.nameValue = str;
            model.postValue = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"商业险到期日期"]) {
        if (self.Type == FullTypeOut) {
            ccell.taglabel.hidden = NO;
        }
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.nameTitleLabel.text = model.locatedTitle;
        ccell.textStr = model.nameValue;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.nameValue = str;
            model.postValue = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else {
        icell.nameTitleLabel.text = model.locatedTitle;
        icell.textStr = model.nameValue;
        icell.allNumber = @"否";
        icell.tagLabel.hidden = YES;
        icell.inputTextField.keyboardType = UIKeyboardTypeDefault;
        if ([model.locatedTitle isEqualToString:@"开票价"] ||
            [model.locatedTitle isEqualToString:@"全包价"] ||
            [model.locatedTitle isEqualToString:@"车价"] ||
            [model.locatedTitle isEqualToString:@"收款金额"]) {
            icell.allNumber = @"是";
            icell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        if ([model.locatedTitle isEqualToString:@"具体型号"] ||
            [model.locatedTitle isEqualToString:@"车架号全号"] ||
            [model.locatedTitle isEqualToString:@"发动机全号"] ||
            [model.locatedTitle isEqualToString:@"车价"] ||
            [model.locatedTitle isEqualToString:@"开票名称"]) {
            icell.tagLabel.hidden = NO;
        }
        if (self.Type == FullTypeOut) {
            if ([model.locatedTitle isEqualToString:@"开票价"] ||
                [model.locatedTitle isEqualToString:@"邮寄地址"] ||
                [model.locatedTitle isEqualToString:@"车主姓名"] ||
                [model.locatedTitle isEqualToString:@"车主电话"] ||
                [model.locatedTitle isEqualToString:@"提车人姓名"] ||
                [model.locatedTitle isEqualToString:@"提车人电话"] ||
                [model.locatedTitle isEqualToString:@"用车人姓名"] ||
                [model.locatedTitle isEqualToString:@"用车人电话"] ||
                [model.locatedTitle isEqualToString:@"陪同人姓名"] ||
                [model.locatedTitle isEqualToString:@"陪同人电话"] ||
                [model.locatedTitle isEqualToString:@"车主身份证"]) {
                icell.tagLabel.hidden = NO;
            }
        }
        icell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return icell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    if ([model.locatedTitle isEqualToString:@"备注"]) {
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

- (void)submitOrder {
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length <=0) {
                if (self.Type == FullTypeOut) {
                    if ([model.locatedTitle isEqualToString:@"绑定车源"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"%@必填", model.locatedTitle]];
                        return;
                    }
                }
                if ([model.locatedTitle isEqualToString:@"品牌车型"] ||
                    [model.locatedTitle isEqualToString:@"具体型号"] ||
                    [model.locatedTitle isEqualToString:@"车架号全号"] ||
                    [model.locatedTitle isEqualToString:@"厂家"] ||
                    [model.locatedTitle isEqualToString:@"发动机全号"] ||
                    [model.locatedTitle isEqualToString:@"车价"] ||
                    [model.locatedTitle isEqualToString:@"行业"] ||
                    [model.locatedTitle isEqualToString:@"上牌地"] ||
                    [model.locatedTitle isEqualToString:@"开票名称"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"%@必填", model.locatedTitle]];
                    return;
                }
                if (self.Type == FullTypeOut) {
                    if ([model.locatedTitle isEqualToString:@"上牌地"] ||
                        [model.locatedTitle isEqualToString:@"开票价"] ||
                        [model.locatedTitle isEqualToString:@"开票名称"] ||
                        [model.locatedTitle isEqualToString:@"邮寄地址"] ||
                        [model.locatedTitle isEqualToString:@"车主姓名"] ||
                        [model.locatedTitle isEqualToString:@"车主电话"] ||
                        [model.locatedTitle isEqualToString:@"提车人姓名"] ||
                        [model.locatedTitle isEqualToString:@"提车人电话"] ||
                        [model.locatedTitle isEqualToString:@"用车人姓名"] ||
                        [model.locatedTitle isEqualToString:@"用车人电话"] ||
                        [model.locatedTitle isEqualToString:@"陪同人姓名"] ||
                        [model.locatedTitle isEqualToString:@"陪同人电话"] ||
                        [model.locatedTitle isEqualToString:@"保险公司"] ||
                        [model.locatedTitle isEqualToString:@"交强险到期日期"] ||
                        [model.locatedTitle isEqualToString:@"商业险到期日期"] ||
                        [model.locatedTitle isEqualToString:@"车主身份证"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"%@必填", model.locatedTitle]];
                        return;
                    }
                }
            }
        }
    }
    
    DBSelf(weakSelf);
    [self HttpApprovalRequestWithSuccessBlock:^{
        
            [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)HttpApprovalRequestWithSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
        contentDic[@"C_OBJECT_ID"] = self.omodel.C_ID;
    NSMutableDictionary *a420 = [NSMutableDictionary dictionary];
    NSMutableDictionary *a801 = [NSMutableDictionary dictionary];
    if (self.Type == FullTypeFull) {
        contentDic[@"C_TYPE_DD_ID"] = @"A42500_C_TYPE_0006";
        a420[@"D_SEND_TIME"] = [DBTools getYearMonthDayTime];
    } else {
        contentDic[@"C_TYPE_DD_ID"] = @"A42500_C_TYPE_0016";
        a420[@"D_SHSJ_TIME"] = [DBTools getYearMonthDayTime];
    }
    
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length > 0) {
                if ([model.keyValue isEqualToString:@"C_VIN"] ||
                    [model.keyValue isEqualToString:@"C_GDSPR"] ||
                    [model.keyValue isEqualToString:@"C_BILLING"] ||
                    [model.keyValue isEqualToString:@"C_INDUSTRY_DD_ID"] ||
                    [model.keyValue isEqualToString:@"C_ADDRESS"] ||
                    [model.keyValue isEqualToString:@"C_SHR_ROLEID"] ||
                    [model.keyValue isEqualToString:@"X_REMARK"] ||
                    [model.keyValue isEqualToString:@"B_GUIDEPRICE"] ||
                    [model.keyValue isEqualToString:@"C_SPD"] ||
                    [model.keyValue isEqualToString:@"B_KPJ"] ||
                    [model.keyValue isEqualToString:@"B_CASHDISCOUNT"] ||
                    [model.keyValue isEqualToString:@"C_SKFS_DD_ID"] ||
                    [model.keyValue isEqualToString:@"B_AMOUNT"]) {
                    a420[model.keyValue] = model.postValue;
                } else if ([model.keyValue isEqualToString:@"C_A70600_C_ID,C_A49600_C_ID"]) {
                    NSArray *keyArr = [model.keyValue componentsSeparatedByString:@","];
                    NSArray *postArr = [model.postValue componentsSeparatedByString:@","];
                    for (int i = 0; i < keyArr.count; i++) {
                        a420[keyArr[i]] = postArr[i];
                    }
                }
                
                if ([model.keyValue isEqualToString:@"C_A80000CJ_C_ID"] ||
                    [model.keyValue isEqualToString:@"C_CZ"] ||
                    [model.keyValue isEqualToString:@"C_CZ_PHONE"] ||
                    [model.keyValue isEqualToString:@"C_TCR"] ||
                    [model.keyValue isEqualToString:@"C_TCR_PHONE"] ||
                    [model.keyValue isEqualToString:@"C_YCR"] ||
                    [model.keyValue isEqualToString:@"C_YCR_PHONE"] ||
                    [model.keyValue isEqualToString:@"C_PTR_NAME"] ||
                    [model.keyValue isEqualToString:@"C_PTR_PHONE"] ||
                    [model.keyValue isEqualToString:@"D_JQX_END"] ||
                    [model.keyValue isEqualToString:@"D_SYX_END"] ||
                    [model.keyValue isEqualToString:@"C_A80000BX_C_ID"] ||
                    [model.keyValue isEqualToString:@"C_SFZ"] ||
                    [model.keyValue isEqualToString:@"C_ZCZJ"]) {
                    a801[model.keyValue] = model.postValue;
                }
            }
        }
    }
    
    if (a801.allKeys.count > 0) {
        a420[@"a801"] = a801;
    }
    if (a420.allKeys.count > 0) {
        contentDic[@"a420"] = a420;
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:HTTP_SYSTEMD425APPROVAL parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            if (completeBlock) {
                completeBlock();
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

//MJKApprovalRequest

- (void)getLocalDatas {
    NSArray*localArr=@[];
    NSArray*localValueArr=@[];
    NSArray*localPostNameArr=@[];
    NSArray*localKeyArr=@[];
    
    if (self.Type == FullTypeFull) {
        localArr=@[@"绑定车源",@"品牌车型",@"具体型号",@"车架号全号",@"厂家",@"发动机全号",@"车价",@"行业",@"上牌地",@"开票价",@"全包价",@"开票名称",@"邮寄地址",@"收款金额",@"收款方式",@"收款人",@"收款账号",@"备注",@"车主姓名",@"车主电话",@"提车人姓名",@"提车人电话",@"用车人姓名",@"用车人电话",@"陪同人姓名",@"陪同人电话",@"交强险到期日期",@"商业险到期日期"];
        localValueArr=@[self.omodel.C_A823VOUCHERID ?: @"",
                        self.omodel.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.omodel.C_A70600_C_NAME, self.omodel.C_A49600_C_NAME] : @"",
                        self.omodel.C_ALLOCATION ?: @"",
                        self.omodel.C_VIN ?: @"",
                        self.omodel.a801.C_A80000CJ_C_NAME ?: @"",
                        self.omodel.C_GDSPR ?: @"",
                        self.omodel.B_GUIDEPRICE ?: @"",
                        self.omodel.C_INDUSTRY_DD_NAME ?: @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        self.omodel.X_REMARK ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        @"",
                        @""];


        localPostNameArr=@[self.omodel.C_A82300_C_ID ?: @"",
                           self.omodel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.omodel.C_A70600_C_ID, self.omodel.C_A49600_C_ID] : @"",
                           self.omodel.C_ALLOCATION ?: @"",
                           self.omodel.C_VIN ?: @"",
                           self.omodel.a801.C_A80000CJ_C_ID ?: @"",
                           self.omodel.C_GDSPR ?: @"",
                           self.omodel.B_GUIDEPRICE ?: @"",
                           self.omodel.C_INDUSTRY_DD_ID ?: @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           self.omodel.X_REMARK ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           @"",
                           @""];
        localKeyArr=@[@"C_A82300_C_ID",@"C_A70600_C_ID,C_A49600_C_ID",@"C_ALLOCATION",@"C_VIN",@"C_A80000CJ_C_ID",@"C_GDSPR",@"B_GUIDEPRICE",@"C_INDUSTRY_DD_ID",@"C_SPD",@"B_KPJ",@"B_CASHDISCOUNT",@"C_BILLING",@"C_ADDRESS",@"B_AMOUNT",@"C_SKFS_DD_ID",@"C_SHR_ROLEID",@"C_A800SKZH_C_ID",@"X_REMARK",@"C_CZ",@"C_CZ_PHONE",@"C_TCR",@"C_TCR_PHONE",@"C_YCR",@"C_YCR_PHONE",@"C_PTR_NAME",@"C_PTR_PHONE",@"D_JQX_END",@"D_SYX_END"];
    } else if (self.Type == FullTypeOut) {
        localArr=@[@"绑定车源",@"品牌车型",@"具体型号",@"车架号全号",@"厂家",@"发动机全号",@"车价",@"行业",@"上牌地",@"开票价",@"开票名称",@"邮寄地址",@"车主姓名",@"车主电话",@"提车人姓名",@"提车人电话",@"用车人姓名",@"用车人电话",@"陪同人姓名",@"陪同人电话",@"保险公司",@"交强险到期日期",@"商业险到期日期",@"车主身份证",@"注册资金",@"全包价",@"收款金额",@"收款方式",@"收款人",@"收款账号",@"备注"];
        localValueArr=@[self.omodel.C_A823VOUCHERID ?: @"",
                        self.omodel.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.omodel.C_A70600_C_NAME, self.omodel.C_A49600_C_NAME] : @"",
                        self.omodel.C_ALLOCATION ?: @"",
                        self.omodel.C_VIN ?: @"",
                        self.omodel.a801.C_A80000CJ_C_NAME ?: @"",
                        self.omodel.C_GDSPR ?: @"",
                        self.omodel.B_GUIDEPRICE ?: @"",
                        self.omodel.C_INDUSTRY_DD_NAME ?: @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        self.omodel.C_BUYNAME ?: @"",
                        self.omodel.C_PHONE ?: @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        @"",
                        self.omodel.X_REMARK ?: @""];


        localPostNameArr=@[self.omodel.C_A82300_C_ID ?: @"",
                           self.omodel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.omodel.C_A70600_C_ID, self.omodel.C_A49600_C_ID] : @"",
                           self.omodel.C_ALLOCATION ?: @"",
                           self.omodel.C_VIN ?: @"",
                           self.omodel.a801.C_A80000CJ_C_ID ?: @"",
                           self.omodel.C_GDSPR ?: @"",
                           self.omodel.B_GUIDEPRICE ?: @"",
                           self.omodel.C_INDUSTRY_DD_ID ?: @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           self.omodel.C_A41500_C_ID ?: @"",
                           self.omodel.C_PHONE ?: @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           @"",
                           self.omodel.X_REMARK ?: @""];
        localKeyArr=@[@"C_A82300_C_ID",@"C_A70600_C_ID,C_A49600_C_ID",@"C_ALLOCATION",@"C_VIN",@"C_A80000CJ_C_ID",@"C_GDSPR",@"B_GUIDEPRICE",@"C_INDUSTRY_DD_ID",@"C_SPD",@"B_KPJ",@"C_BILLING",@"C_ADDRESS",@"C_CZ",@"C_CZ_PHONE",@"C_TCR",@"C_TCR_PHONE",@"C_YCR",@"C_YCR_PHONE",@"C_PTR_NAME",@"C_PTR_PHONE",@"C_A80000BX_C_ID",@"D_JQX_END",@"D_SYX_END",@"C_SFZ",@"C_ZCZJ",@"B_CASHDISCOUNT",@"B_AMOUNT",@"C_SKFS_DD_ID",@"C_SHR_ROLEID",@"C_A800SKZH_C_ID",@"X_REMARK"];
    }
    
    
   
    
        NSMutableArray*saveLocalArr=[NSMutableArray array];
        for (int i=0; i<localArr.count; i++) {
            PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
            model.locatedTitle=localArr[i];
            model.nameValue=localValueArr[i];
            model.postValue=localPostNameArr[i];
            model.keyValue=localKeyArr[i];
            
            [saveLocalArr addObject:model];
        }
    
  
        self.localDatas = [NSMutableArray arrayWithObject:saveLocalArr];
    
    
    
    
}

@end
