//
//  MJKOrderAddOrEditViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/27.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKOrderAddOrEditViewController.h"
#import "MJKChooseNewBrandViewController.h"
#import "CGCOrderListVC.h"
#import "CustomerDetailViewController.h"
#import "MJKCarSourceHomeViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKFlowListViewController.h"
#import "MJKClueTabViewController.h"
#import "MJKFlowMeterViewController.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "OrderHeaderTableViewCell.h"

#import "MJKPhotoView.h"

#import "PotentailCustomerEditModel.h"
#import "CGCOrderDetailModel.h"
#import "MJKProductShowModel.h"
#import "CGCCustomModel.h"
#import "VideoAndImageModel.h"
#import "MJKClueListSubModel.h"
#import "MJKCarSourceHomeModel.h"
#import <WebKit/WebKit.h>

@interface MJKOrderAddOrEditViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) CGCOrderDetailModel *detailModel;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#> */
@property (nonatomic, strong) UILabel *totalLabel;
/** <#注释#> */
@property (nonatomic, strong) CustomerPhotoView *ysPhotoView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fileListYsImageList;
@property (nonatomic, strong) NSMutableArray *fileListYsImage;
/** <#注释#> */
@property (nonatomic, strong) NSArray *btArray;
@end

@implementation MJKOrderAddOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.Type == orderTypeAdd) {
        self.title = @"新增订单";
    } else {
        self.title = @"编辑订单";
    }
    self.btArray = [NewUserSession instance].configData.requiredCode;
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
    [_tableView registerClass:[OrderHeaderTableViewCell class] forCellReuseIdentifier:@"OrderHeaderTableViewCell"];
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
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80);
    }];
    [submitButton setBackgroundColor:KNaviColor];
    [submitButton setTitle:@"提交" forState:UIControlStateNormal];
    @weakify(self);
    [[submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self submitOrder];
    }];
    
    UILabel *titleLabel = [UILabel new];
    [_bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(submitButton.mas_right).offset(20);
        make.centerY.equalTo(self.bottomView);
    }];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.text = @"车价";
    
    _totalLabel = [UILabel new];
    [_bottomView addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.bottomView);
    }];
    _totalLabel.textColor = [UIColor blackColor];
    _totalLabel.text = @"0";
    
    UILabel *tagLabel = [UILabel new];
    [_bottomView addSubview:tagLabel];
    [tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalLabel.mas_left).offset(-5);
        make.centerY.equalTo(self.bottomView);
    }];
    tagLabel.textColor = [UIColor blackColor];
    tagLabel.text = @"¥";
    
    
    if ([self.vcName isEqualToString:@"订单"]) {
        UIButton *backButton = [UIButton new];
        [backButton setImage:[UIImage imageNamed:@"btn-返回"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        [[backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            [self.navigationController popToViewController:self.rootVC animated:YES];
        }];
    }
    
    [self getLocalDatas];
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
    @weakify(self);
    AddCustomerInputTableViewCell *icell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        if ([model.locatedTitle isEqualToString:@"客户"]) {
            OrderHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderHeaderTableViewCell"];
            if (self.detailModel.C_HEADIMGURL.length > 0) {
                cell.headImageView.hidden = NO;
                cell.headLabel.hidden = YES;
                [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.C_HEADIMGURL]];
            } else {
                cell.headImageView.hidden = YES;
                cell.headLabel.hidden = NO;
                if (model.nameValue.length >= 1) {
                    cell.headLabel.text = [model.nameValue substringToIndex:1];
                }
            }
            cell.nameTextField.text = model.nameValue;
            cell.nameTextField.enabled = NO;
            [[[cell.phoneButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                NSArray *arr = self.localDatas[indexPath.section];
                PotentailCustomerEditModel *tempModel = nil;
                for (PotentailCustomerEditModel *subModel in arr) {
                    if ([subModel.locatedTitle isEqualToString:@"潜客电话"]) {
                        tempModel = subModel;
                    }
                }
                NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",tempModel.postValue];
                WKWebView * callWebview = [[WKWebView alloc] init];
                [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
                [self.view addSubview:callWebview];
            }];
            return cell;
        } else if ([model.locatedTitle isEqualToString:@"下单时间"] ||
                   [model.locatedTitle isEqualToString:@"合同交车时间"]) {
            ccell.Type = ChooseTableViewTypeBirthday;
            ccell.textStr = model.nameValue;
            ccell.taglabel.hidden = YES;
            if ([model.locatedTitle isEqualToString:@"合同交车时间"]) {
                if ([self.btArray containsObject:@"a420_D_START_TIME"]) {
                    ccell.taglabel.hidden = NO;
                }
            }
            ccell.nameTitleLabel.text = model.locatedTitle;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                model.postValue = postValue;
                model.nameValue = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([model.locatedTitle isEqualToString:@"来源渠道"]){
            //来源
            //A41300_C_CLUESOURCE_0021
            //转介绍
            
            ccell.nameTitleLabel.text=@"来源渠道";
            ccell.BottomLineView.hidden=YES;
            ccell.textStr=model.nameValue;
            ccell.Type=ChooseTableViewTypeCustomerSource;
            ccell.taglabel.hidden=NO;

            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                model.nameValue=str;
                model.postValue=postValue;
                //渠道细分
                PotentailCustomerEditModel *model1 = weakSelf.localDatas[indexPath.section][indexPath.row + 1];
              
                model1.nameValue=@"";
                model1.postValue=@"";
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationFade];
                
            };
            
            return ccell;
            
        }else if ([model.locatedTitle isEqualToString:@"渠道细分"]){
            //渠道细分
            PotentailCustomerEditModel *model1 = self.localDatas[indexPath.section][indexPath.row - 1];
            ccell.nameTitleLabel.text=@"渠道细分";
            ccell.textStr=model.nameValue;
            ccell.SourceID=model1.postValue;
            ccell.Type=ChooseTableViewTypeAction;
            ccell.taglabel.hidden=NO;
            ccell.BottomLineView.hidden=YES;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                model.nameValue=str;
                model.postValue=postValue;
               [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                
            };
            return ccell;
        } else if ([model.locatedTitle isEqualToString:@"绑定车源"]) {
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
        } else if ([model.locatedTitle isEqualToString:@"订单类型"]) {
            ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
            ccell.C_TYPECODE = @"A42000_C_TYPE";
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a420_C_TYPE_DD_ID"]) {
                ccell.taglabel.hidden = NO;
            }
            ccell.textStr = model.nameValue;
            ccell.nameTitleLabel.text = model.locatedTitle;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                model.postValue = postValue;
                model.nameValue = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([model.locatedTitle isEqualToString:@"购车类型"]) {
            ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
            ccell.C_TYPECODE = @"A42000_C_PURCHASEWAY";
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a420_C_PURCHASEWAY_DD_ID"]) {
                ccell.taglabel.hidden = NO;
            }
            ccell.textStr = model.nameValue;
            ccell.nameTitleLabel.text = model.locatedTitle;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                model.postValue = postValue;
                model.nameValue = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([model.locatedTitle isEqualToString:@"品牌车型"]) {
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a420_C_A70600_C_ID"]) {
                ccell.taglabel.hidden = NO;
            }
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
        } else if ([model.locatedTitle isEqualToString:@"保有车型"]) {
            ccell.taglabel.hidden = YES;
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
        } else if ([model.locatedTitle isEqualToString:@"收款人"]) {
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a420_C_SHR_ROLEID"]) {
                ccell.taglabel.hidden = NO;
            }
            ccell.Type = chooseTypeNil;
            ccell.nameTitleLabel.text = model.locatedTitle;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                vc.isAllEmployees = @"是";
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model1) {
                    model.nameValue=model1.nickName;
                    model.postValue=model1.u051Id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            
                ccell.textStr = model.nameValue;
            
            return ccell;
        } else if ([model.locatedTitle isEqualToString:@"厂家"]) {
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a801_C_A80000CJ_C_ID"]) {
                ccell.taglabel.hidden = NO;
            }
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
            ccell.Type = ChooseTableViewTypeCity;
            ccell.taglabel.hidden = YES;
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
        }  else if ([model.locatedTitle isEqualToString:@"收款方式"]) {
            ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
            ccell.C_TYPECODE = @"A42000_C_SKFS";
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a420_C_SKFS_DD_ID"]) {
                ccell.taglabel.hidden = NO;
            }
            ccell.textStr = model.nameValue;
            ccell.nameTitleLabel.text = model.locatedTitle;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                model.postValue = postValue;
                model.nameValue = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([model.locatedTitle isEqualToString:@"定金状态"]) {
            ccell.taglabel.hidden = YES;
            if ([self.btArray containsObject:@"a420_C_XDSPR"]) {
                ccell.taglabel.hidden = NO;
            }
            ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
            ccell.C_TYPECODE = @"A42000_C_DJTYPE";
            ccell.textStr = model.nameValue;
            ccell.nameTitleLabel.text = model.locatedTitle;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                model.postValue = postValue;
                model.nameValue = str;
                NSMutableArray *sectionArr = self.localDatas[indexPath.section];
                for (int i = 0; i < sectionArr.count; i++) {
                    PotentailCustomerEditModel *tempModel = sectionArr[i];
                    if ([tempModel.locatedTitle isEqualToString:@"绑定车源"]) {
                        [sectionArr removeObjectAtIndex:i];
                    }
                }
                if ([postValue isEqualToString:@"A42000_C_DJTYPE_0001"] ||
                    [postValue isEqualToString:@"A42000_C_DJTYPE_0002"]) {
                    PotentailCustomerEditModel *cyModel= [PotentailCustomerEditModel new];
                    cyModel.locatedTitle = @"绑定车源";
                    cyModel.postValue = @"";
                    cyModel.nameValue = @"";
                    cyModel.keyValue = @"C_A82300_C_ID";
                    [sectionArr insertObject:cyModel atIndex:indexPath.row + 1];
                }
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView reloadData];
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
        } else if ([model.locatedTitle isEqualToString:@"潜客电话"]) {
            icell.textStr = model.nameValue;
            icell.textFieldLength = 11;
            icell.tagLabel.hidden = NO;
            icell.nameTitleLabel.text = model.locatedTitle;
            icell.changeTextBlock = ^(NSString *textStr) {
                model.postValue = textStr;
                model.nameValue = textStr;
            };
            return icell;
        } else {
            
                icell.inputTextField.enabled = YES;
            icell.tagLabel.hidden = YES;
            if ([model.locatedTitle isEqualToString:@"定金金额"]) {
                if ([self.btArray containsObject:@"a420_B_DEPOSIT"]) {
                    icell.tagLabel.hidden = NO;
                }
            }
            if ([model.locatedTitle isEqualToString:@"车价"]) {
                if ([self.btArray containsObject:@"a420_B_GUIDEPRICE"]) {
                    icell.tagLabel.hidden = NO;
                }
            }
            if ([model.locatedTitle isEqualToString:@"开票价"]) {
                icell.allNumber = @"是";
            }
            icell.nameTitleLabel.text = model.locatedTitle;
            icell.changeTextBlock = ^(NSString *textStr) {
                model.postValue = textStr;
                model.nameValue = textStr;
                if ([model.locatedTitle isEqualToString:@"车价"]) {
                    weakSelf.totalLabel.text = textStr;
                }
                if ([model.locatedTitle isEqualToString:@"保险费"] ||
                    [model.locatedTitle isEqualToString:@"金融服务费"] ||
                    [model.locatedTitle isEqualToString:@"上牌费"] ||
                    [model.locatedTitle isEqualToString:@"精品费"] ||
                    [model.locatedTitle isEqualToString:@"服务费"]) {
                    NSArray *tarr = self.localDatas[0];
                    for (int i =0; i <tarr.count; i++ ) {
                        PotentailCustomerEditModel *modelt = tarr[i];
                        if ([modelt.locatedTitle isEqualToString:@"其他费用"]) {
                            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                }
            };
            if ([model.locatedTitle isEqualToString:@"具体型号"] ||
                [model.locatedTitle isEqualToString:@"客户画像"]) {
                if ([model.locatedTitle isEqualToString:@"具体型号"]) {
                    icell.tagLabel.hidden = YES;
                    if ([self.btArray containsObject:@"a420_C_ALLOCATION"]) {
                        icell.tagLabel.hidden = NO;
                    }
                } else {
                    icell.tagLabel.hidden = YES;
                }
                icell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            } else {
                icell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
            }
            if ([model.locatedTitle isEqualToString:@"其他费用"]) {
                icell.inputTextField.enabled = NO;
                float total = 0;
                NSArray *tarr = self.localDatas[0];
                for (int i =0; i <tarr.count; i++ ) {
                    PotentailCustomerEditModel *modelt = tarr[i];
                    if ([modelt.locatedTitle isEqualToString:@"保险费"] ||
                        [modelt.locatedTitle isEqualToString:@"金融服务费"] ||
                        [modelt.locatedTitle isEqualToString:@"上牌费"] ||
                        [modelt.locatedTitle isEqualToString:@"精品费"] ||
                        [modelt.locatedTitle isEqualToString:@"服务费"]) {
                        total += modelt.postValue.floatValue;
                    }
                }
                model.postValue = [NSString stringWithFormat:@"%.2f",total];
                model.nameValue = [NSString stringWithFormat:@"%.2f",total];
            }
            
                icell.textStr = model.nameValue;
            icell.textBeginEditBlock = ^{
                if (indexPath.section == 0) {
                    NSArray *arr = self.localDatas[indexPath.section];
                    NSInteger index = 0;
                    for (int i = 0; i < arr.count; i++) {
                        PotentailCustomerEditModel *subModel = arr[i];
                        if ([subModel.locatedTitle isEqualToString:@"金融服务费"]) {
                            index = i;
                        }
                    }
                    if (indexPath.row > index) {
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            CGRect frame = self.view.frame;
                            //frame.origin.y+
                            frame.origin.y = -260;
                            
                            self.view.frame = frame;
                            
                        }];
                    }
                }
            };
            icell.textEndEditBlock = ^{
                if (indexPath.section == 0) {
                    NSArray *arr = self.localDatas[indexPath.section];
                    NSInteger index = 0;
                    for (int i = 0; i < arr.count; i++) {
                        PotentailCustomerEditModel *subModel = arr[i];
                        if ([subModel.locatedTitle isEqualToString:@"金融服务费"]) {
                            index = i;
                        }
                    }
                    if (indexPath.row > index) {
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            CGRect frame = self.view.frame;
                            
                            frame.origin.y = 0.0;
                            
                            self.view.frame = frame;
                            
                        }];
                    }
                }
            };
            return icell;
        }
    } else {
        if ([model.locatedTitle isEqualToString:@"备注"]) {
            //预约备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
            cell.topTitleLabel.text=model.locatedTitle;
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                cell.beforeText=model.nameValue;
            }
            cell.textView.editable = NO;
            cell.changeTextBlock = ^(NSString *textStr) {
                model.nameValue = textStr;
                model.postValue = textStr;
            };
            return cell;
            
        } else if ([model.locatedTitle isEqualToString:@"全款时间"] ||
                   [model.locatedTitle isEqualToString:@"出库时间"]) {
            icell.nameTitleLabel.text = model.locatedTitle;
            icell.inputTextField.enabled = NO;
            if (model.nameValue.length > 0) {
                icell.textStr = model.nameValue;
            } else {
                icell.inputTextField.placeholder = @"";
            }
            return icell;
        } else if ([model.locatedTitle isEqualToString:@"行业"]) {
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
        } else {
            icell.textStr = model.nameValue;
            icell.nameTitleLabel.text = model.locatedTitle;
            icell.changeTextBlock = ^(NSString *textStr) {
                model.nameValue = textStr;
                model.postValue = textStr;
            };
            icell.textBeginEditBlock = ^{
               
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            CGRect frame = self.view.frame;
                            //frame.origin.y+
                            frame.origin.y = -260;
                            
                            self.view.frame = frame;
                            
                        }];
            };
            icell.textEndEditBlock = ^{
                
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            CGRect frame = self.view.frame;
                            
                            frame.origin.y = 0.0;
                            
                            self.view.frame = frame;
                            
                        }];
            };
            return icell;
        }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PotentailCustomerEditModel *model = self.localDatas[indexPath.section][indexPath.row];
    if ([model.locatedTitle isEqualToString:@"备注"]) {
        return 120;
    } else if ([model.locatedTitle isEqualToString:@"客户"]) {
        return 70;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return .1f;
    }
    return 30;
        
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [UILabel new];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bgView);
        make.left.mas_equalTo(10);
    }];
    label.textColor = [UIColor colorWithHex:@"#333333"];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = @[@"",@"交付信息"][section];
    if (section == 0) {
        return nil;
    }
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.localDatas.count - 1) {
        return 180;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == self.localDatas.count - 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
        _ysPhotoView = [CustomerPhotoView new];
        [bgView addSubview:_ysPhotoView];
        [_ysPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(bgView);
            make.height.equalTo(@180);
        }];
        _ysPhotoView.tableView = tableView;
        _ysPhotoView.imageUrlArray = self.imageUrlArray;
        
        @weakify(self);
        [[self.ysPhotoView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            HXPhotoManager *manager = [HXPhotoManager new];
            manager.configuration.singleJumpEdit = NO;
            manager.configuration.singleSelected = YES;
            [self openPhotoLibraryWith:manager success:^(VideoAndImageModel * _Nonnull model) {
                @strongify(self);
                [self.imageUrlArray addObject:model];
                [self.tableView reloadData];
                
                
            }];
        }];
        return bgView;
    }
    return nil;
}

- (void)getLocalDatas {
    NSArray*localArr=@[@"客户",@"潜客电话",@"来源渠道",@"渠道细分",@"下单时间",@"订单类型",@"购车类型",@"定金金额",@"收款方式",@"收款人",@"收款账号",@"定金状态",@"车架号全号",@"发动机全号",@"品牌车型",@"具体型号",@"厂家",@"合同交车时间",@"保有车型",@"上牌地",@"车价",@"开票价",@"全包价",@"保险费",@"金融服务费",@"上牌费",@"精品费",@"服务费",@"其他费用",@"购置税"];
    NSArray*localValueArr=@[self.customerModel.C_NAME ?: @"",
                                        self.customerModel.C_PHONE ?: @"",
                                        self.customerModel.C_CLUESOURCE_DD_NAME.length > 0 ? self.customerModel.C_CLUESOURCE_DD_NAME : @"",
                                        self.customerModel.C_A41200_C_NAME.length > 0 ? self.customerModel.C_A41200_C_NAME : @"",
                                        [DBTools getYearMonthDayTime],
                                        @"新车",
                            @"个人购车",
                                        @"",
                                        @"",
                                        [NewUserSession instance].user.nickName,
                                        @"",
                                        @"",
                                        @"",
                                        @"",
                                        self.customerModel.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@",self.customerModel.C_A70600_C_NAME, self.customerModel.C_A49600_C_NAME] : @"",
                                        @"",
                                        @"",
                                        @"",
                                        @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        
        
    NSArray*localPostNameArr=@[self.customerModel.C_NAME ?: @"",
                                           self.customerModel.C_PHONE ?: @"",
                                           self.customerModel.C_CLUESOURCE_DD_ID.length > 0 ? self.customerModel.C_CLUESOURCE_DD_ID : @"",
                                           self.customerModel.C_A41200_C_ID.length > 0 ? self.customerModel.C_A41200_C_ID : @"",
                                           [DBTools getYearMonthDayTime],
                                           @"A42000_C_TYPE_0000",
                               @"A42000_C_PURCHASEWAY_0001",
                                           @"",
                                           @"",
                                           [NewUserSession instance].user.u051Id,
                                           @"",
                                           @"",
                                           @"",
                                           @"",
                                           self.customerModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@",self.customerModel.C_A70600_C_ID, self.customerModel.C_A49600_C_ID] : @"",
                                           @"",
                                           @"",
                                           @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localKeyArr=@[@"C_BUYNAME",@"C_PHONE",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"D_ORDER_TIME",@"C_TYPE_DD_ID",@"C_PURCHASEWAY_DD_ID",@"B_DEPOSIT",@"C_SKFS_DD_ID",@"C_SHR_ROLEID",@"C_A800SKZH_C_ID",@"C_XDSPR",@"C_VIN",@"C_GDSPR",@"C_A70600_C_ID,C_A49600_C_ID",@"C_ALLOCATION",@"C_A80000CJ_C_ID",@"D_START_TIME",@"C_A40500_C_ID,C_A40600_C_ID",@"C_SPD",@"B_GUIDEPRICE",@"B_KPJ",@"B_CASHDISCOUNT",@"B_INSURANCEFEE",@"B_FINANCIALFEE",@"B_LICENCEFEE",@"B_DECORATEFEE",@"B_SERVICEFEE",@"B_OTHER",@"B_PURCHASETAX"];
    
    
   
    
        NSMutableArray*saveLocalArr=[NSMutableArray array];
        for (int i=0; i<localArr.count; i++) {
            PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
            model.locatedTitle=localArr[i];
            model.nameValue=localValueArr[i];
            model.postValue=localPostNameArr[i];
            model.keyValue=localKeyArr[i];
            
            [saveLocalArr addObject:model];
        }
    
    
    NSArray*localArrt=@[@"客户",@"潜客电话",@"来源渠道",@"渠道细分",@"下单时间",@"订单类型",@"购车类型",@"车架号全号",@"发动机全号",@"品牌车型",@"具体型号",@"厂家",@"合同交车时间",@"保有车型",@"上牌地",@"车价",@"开票价",@"全包价",@"保险费",@"金融服务费",@"上牌费",@"精品费",@"服务费",@"其他费用",@"购置税"];
    NSArray*localValueArrt=@[self.customerModel.C_NAME ?: @"",
                                        self.customerModel.C_PHONE ?: @"",
                                        self.customerModel.C_CLUESOURCE_DD_NAME.length > 0 ? self.customerModel.C_CLUESOURCE_DD_NAME : @"",
                                        self.customerModel.C_A41200_C_NAME.length > 0 ? self.customerModel.C_A41200_C_NAME : @"",
                                        [DBTools getYearMonthDayTime],
                                        @"新车",
                             @"个人购车",
                                        @"",
                                        @"",
                                        self.customerModel.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@",self.customerModel.C_A70600_C_NAME, self.customerModel.C_A49600_C_NAME] : @"",
                                        @"",
                                        @"",
                                        @"",
                                        @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        
        
    NSArray*localPostNameArrt=@[self.customerModel.C_NAME ?: @"",
                                           self.customerModel.C_PHONE ?: @"",
                                           self.customerModel.C_CLUESOURCE_DD_ID.length > 0 ? self.customerModel.C_CLUESOURCE_DD_ID : @"",
                                           self.customerModel.C_A41200_C_ID.length > 0 ? self.customerModel.C_A41200_C_ID : @"",
                                           [DBTools getYearMonthDayTime],
                                           @"A42000_C_TYPE_0000",
                                @"A42000_C_PURCHASEWAY_0001",
                                           @"",
                                           @"",
                                           self.customerModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@",self.customerModel.C_A70600_C_ID, self.customerModel.C_A49600_C_ID] : @"",
                                           @"",
                                           @"",
                                           @"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localKeyArrt=@[@"C_BUYNAME",@"C_PHONE",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"D_ORDER_TIME",@"C_TYPE_DD_ID",@"C_PURCHASEWAY_DD_ID",@"C_VIN",@"C_GDSPR",@"C_A70600_C_ID,C_A49600_C_ID",@"C_ALLOCATION",@"C_A80000CJ_C_ID",@"D_START_TIME",@"C_A40500_C_ID,C_A40600_C_ID",@"C_SPD",@"B_GUIDEPRICE",@"B_KPJ",@"B_CASHDISCOUNT",@"B_INSURANCEFEE",@"B_FINANCIALFEE",@"B_LICENCEFEE",@"B_DECORATEFEE",@"B_SERVICEFEE",@"B_OTHER",@"B_PURCHASETAX"];
    
    
   
    
        NSMutableArray*saveLocalArrt=[NSMutableArray array];
        for (int i=0; i<localArrt.count; i++) {
            PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
            model.locatedTitle=localArrt[i];
            model.nameValue=localValueArrt[i];
            model.postValue=localPostNameArrt[i];
            model.keyValue=localKeyArrt[i];
            
            [saveLocalArrt addObject:model];
        }
    
    
    NSArray*localArr1=@[@"开票名称",@"行业",@"邮寄地址",@"全款时间",@"出库时间",@"备注"];
    NSArray*localValueArr1=@[@"",@"",@"",@"",@"",@"",@""];
    NSArray*localPostNameArr1=@[@"",@"",@"",@"",@"",@"",@""];
    NSArray*localKeyArr1=@[@"C_BILLING",@"C_INDUSTRY_DD_ID",@"C_ADDRESS",@"D_SEND_TIME",@"D_SHSJ_TIME",@"X_REMARK"];




    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }
    
    
    NSArray*localArr1t=@[@"开票名称",@"行业",@"邮寄地址"];
    NSArray*localValueArr1t=@[@"",@"",@""];
    NSArray*localPostNameArr1t=@[@"",@"",@""];
    NSArray*localKeyArr1t=@[@"C_BILLING",@"C_INDUSTRY_DD_ID",@"C_ADDRESS"];




    NSMutableArray*saveLocalArr1t=[NSMutableArray array];
    for (int i=0; i<localArr1t.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1t[i];
        model.nameValue=localValueArr1t[i];
        model.postValue=localPostNameArr1t[i];
        model.keyValue=localKeyArr1t[i];
        
        [saveLocalArr1t addObject:model];
    }
    if (self.Type == orderTypeEdit) {
        self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArrt, saveLocalArr1, nil];
    } else {
        self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArr, saveLocalArr1t, nil];
    }
    
    if (self.Type == orderTypeEdit) {
        [self getOrderInfo];
    }
    
}

- (void)getOrderInfo {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/info", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            weakSelf.detailModel=[CGCOrderDetailModel mj_objectWithKeyValues:data[@"data"]];
            NSArray*section0ShowNameArray =@[];
            
            
            NSArray*section0PostNameArray =@[];
//            if (self.detailModel.C_A82300_C_ID.length > 0) {
//                for (int i = 0; i < self.localDatas.count; i++) {
//                    NSMutableArray *section0 = self.localDatas[i];
//                    for (int j = 0; j < section0.count; j++) {
//                        PotentailCustomerEditModel *tempModel = section0[j];
//                        if ([tempModel.locatedTitle isEqualToString:@"定金状态"]) {
//                            PotentailCustomerEditModel *cyModel= [PotentailCustomerEditModel new];
//                            cyModel.locatedTitle = @"绑定车源";
//                            cyModel.postValue = @"";
//                            cyModel.nameValue = @"";
//                            cyModel.keyValue = @"C_A82300_C_ID";
//                            [section0 insertObject:cyModel atIndex:j + 1];
//                        }
//                    }
//                }
//
//                section0ShowNameArray =@[self.detailModel.C_BUYNAME.length > 0 ? self.detailModel.C_BUYNAME : @"",
//                                                 self.detailModel.C_PHONE.length > 0 ? self.detailModel.C_PHONE : @"",
//                                                 self.detailModel.C_CLUESOURCE_DD_NAME.length > 0 ? self.detailModel.C_CLUESOURCE_DD_NAME : @"",
//                                                 self.detailModel.C_A41200_C_NAME.length > 0 ? self.detailModel.C_A41200_C_NAME : @"",
//                                                 self.detailModel.D_ORDER_TIME.length >= 10 ? [self.detailModel.D_ORDER_TIME substringToIndex:10] : @"",
//                                                 self.detailModel.C_TYPE_DD_NAME.length > 0 ? self.detailModel.C_TYPE_DD_NAME : @"",
//                                         self.detailModel.C_PURCHASEWAY_DD_NAME.length > 0 ? self.detailModel.C_PURCHASEWAY_DD_NAME : @"",
//                                                 self.detailModel.C_A823VOUCHERID.length > 0 ? self.detailModel.C_A823VOUCHERID : @"",
//                                                 self.detailModel.C_VIN.length > 0 ? self.detailModel.C_VIN : @"",
//                                                 self.detailModel.C_GDSPR.length > 0 ? self.detailModel.C_GDSPR : @"",
//                                                 self.detailModel.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A70600_C_NAME,self.detailModel.C_A49600_C_NAME ] : @"",
//                                                 self.detailModel.C_ALLOCATION.length > 0 ? self.detailModel.C_ALLOCATION : @"",
//                                                 self.detailModel.a801.C_A80000CJ_C_NAME.length > 0 ? self.detailModel.a801.C_A80000CJ_C_NAME : @"",
//                                                 self.detailModel.D_START_TIME.length > 0 ? self.detailModel.D_START_TIME : @"",
//                                                 self.detailModel.C_A40500_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A40500_C_NAME,self.detailModel.C_A40600_C_NAME ] : @"",
//                                                 self.detailModel.C_SPD.length > 0 ? self.detailModel.C_SPD : @"",
//                                                 self.detailModel.B_GUIDEPRICE.length > 0 ? self.detailModel.B_GUIDEPRICE : @"",
//                                                 self.detailModel.a801.B_KPJ.length > 0 ? self.detailModel.a801.B_KPJ : @"",
//                                                 self.detailModel.B_CASHDISCOUNT.length > 0 ? self.detailModel.B_CASHDISCOUNT : @"",
//                                                 self.detailModel.B_INSURANCEFEE.length > 0 ? self.detailModel.B_INSURANCEFEE: @"",
//                                                 self.detailModel.B_FINANCIALFEE.length > 0 ? self.detailModel.B_FINANCIALFEE : @"",
//                                                 self.detailModel.B_LICENCEFEE.length > 0 ? self.detailModel.B_LICENCEFEE : @"",
//                                                 self.detailModel.B_DECORATEFEE.length > 0 ? self.detailModel.B_DECORATEFEE : @"",
//                                                 self.detailModel.B_SERVICEFEE.length > 0 ? self.detailModel.B_SERVICEFEE : @"",
//                                                 self.detailModel.B_OTHER.length > 0 ? self.detailModel.B_OTHER : @"",
//                                                 self.detailModel.B_PURCHASETAX.length > 0 ? self.detailModel.B_PURCHASETAX : @""];
//
//
//                section0PostNameArray =@[self.detailModel.C_BUYNAME.length > 0 ? self.detailModel.C_BUYNAME : @"",
//                                                 self.detailModel.C_PHONE.length > 0 ? self.detailModel.C_PHONE : @"",
//                                                 self.detailModel.C_CLUESOURCE_DD_ID.length > 0 ? self.detailModel.C_CLUESOURCE_DD_ID : @"",
//                                                 self.detailModel.C_A41200_C_ID.length > 0 ? self.detailModel.C_A41200_C_ID : @"",
//                                                 self.detailModel.D_ORDER_TIME.length >= 10 ? [self.detailModel.D_ORDER_TIME substringToIndex:10]  : @"",
//                                                 self.detailModel.C_TYPE_DD_ID.length > 0 ? self.detailModel.C_TYPE_DD_ID : @"",
//                                         self.detailModel.C_PURCHASEWAY_DD_ID.length > 0 ? self.detailModel.C_PURCHASEWAY_DD_ID : @"",
//                                                 self.detailModel.C_A82300_C_ID.length > 0 ? self.detailModel.C_A82300_C_ID : @"",
//                                                 self.detailModel.C_VIN.length > 0 ? self.detailModel.C_VIN : @"",
//                                                 self.detailModel.C_GDSPR.length > 0 ? self.detailModel.C_GDSPR : @"",
//                                                 self.detailModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A70600_C_ID,self.detailModel.C_A49600_C_ID ] : @"",
//                                                 self.detailModel.C_ALLOCATION.length > 0 ? self.detailModel.C_ALLOCATION : @"",
//                                                 self.detailModel.a801.C_A80000CJ_C_ID.length > 0 ? self.detailModel.a801.C_A80000CJ_C_ID : @"",
//                                                 self.detailModel.D_START_TIME.length > 0 ? self.detailModel.D_START_TIME : @"",
//                                                 self.detailModel.C_A40500_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A40500_C_ID,self.detailModel.C_A40600_C_ID ] : @"",
//                                                 self.detailModel.C_SPD.length > 0 ? self.detailModel.C_SPD : @"",
//                                                 self.detailModel.B_GUIDEPRICE.length > 0 ? self.detailModel.B_GUIDEPRICE : @"",
//                                                 self.detailModel.a801.B_KPJ.length > 0 ? self.detailModel.a801.B_KPJ : @"",
//                                                 self.detailModel.B_CASHDISCOUNT.length > 0 ? self.detailModel.B_CASHDISCOUNT : @"",
//                                                 self.detailModel.B_INSURANCEFEE.length > 0 ? self.detailModel.B_INSURANCEFEE: @"",
//                                                 self.detailModel.B_FINANCIALFEE.length > 0 ? self.detailModel.B_FINANCIALFEE : @"",
//                                                 self.detailModel.B_LICENCEFEE.length > 0 ? self.detailModel.B_LICENCEFEE : @"",
//                                                 self.detailModel.B_DECORATEFEE.length > 0 ? self.detailModel.B_DECORATEFEE : @"",
//                                                 self.detailModel.B_SERVICEFEE.length > 0 ? self.detailModel.B_SERVICEFEE : @"",
//                                                 self.detailModel.B_OTHER.length > 0 ? self.detailModel.B_OTHER : @"",
//                                                 self.detailModel.B_PURCHASETAX.length > 0 ? self.detailModel.B_PURCHASETAX : @""];
//            } else {
                section0ShowNameArray =@[self.detailModel.C_BUYNAME.length > 0 ? self.detailModel.C_BUYNAME : @"",
                                                 self.detailModel.C_PHONE.length > 0 ? self.detailModel.C_PHONE : @"",
                                                 self.detailModel.C_CLUESOURCE_DD_NAME.length > 0 ? self.detailModel.C_CLUESOURCE_DD_NAME : @"",
                                                 self.detailModel.C_A41200_C_NAME.length > 0 ? self.detailModel.C_A41200_C_NAME : @"",
                                                 self.detailModel.D_ORDER_TIME.length >= 10 ? [self.detailModel.D_ORDER_TIME substringToIndex:10] : @"",
                                                 self.detailModel.C_TYPE_DD_NAME.length > 0 ? self.detailModel.C_TYPE_DD_NAME : @"",
                                         self.detailModel.C_PURCHASEWAY_DD_NAME.length > 0 ? self.detailModel.C_PURCHASEWAY_DD_NAME : @"",
                                                 self.detailModel.C_VIN.length > 0 ? self.detailModel.C_VIN : @"",
                                                 self.detailModel.C_GDSPR.length > 0 ? self.detailModel.C_GDSPR : @"",
                                                 self.detailModel.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A70600_C_NAME,self.detailModel.C_A49600_C_NAME ] : @"",
                                                 self.detailModel.C_ALLOCATION.length > 0 ? self.detailModel.C_ALLOCATION : @"",
                                                 self.detailModel.a801.C_A80000CJ_C_NAME.length > 0 ? self.detailModel.a801.C_A80000CJ_C_NAME : @"",
                                                 self.detailModel.D_START_TIME.length > 0 ? self.detailModel.D_START_TIME : @"",
                                                 self.detailModel.C_A40500_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A40500_C_NAME,self.detailModel.C_A40600_C_NAME ] : @"",
                                                 self.detailModel.C_SPD.length > 0 ? self.detailModel.C_SPD : @"",
                                                 self.detailModel.B_GUIDEPRICE.length > 0 ? self.detailModel.B_GUIDEPRICE : @"",
                                                 self.detailModel.a801.B_KPJ.length > 0 ? self.detailModel.a801.B_KPJ : @"",
                                                 self.detailModel.B_CASHDISCOUNT.length > 0 ? self.detailModel.B_CASHDISCOUNT : @"",
                                                 self.detailModel.B_INSURANCEFEE.length > 0 ? self.detailModel.B_INSURANCEFEE: @"",
                                                 self.detailModel.B_FINANCIALFEE.length > 0 ? self.detailModel.B_FINANCIALFEE : @"",
                                                 self.detailModel.B_LICENCEFEE.length > 0 ? self.detailModel.B_LICENCEFEE : @"",
                                                 self.detailModel.B_DECORATEFEE.length > 0 ? self.detailModel.B_DECORATEFEE : @"",
                                                 self.detailModel.B_SERVICEFEE.length > 0 ? self.detailModel.B_SERVICEFEE : @"",
                                                 self.detailModel.B_OTHER.length > 0 ? self.detailModel.B_OTHER : @"",
                                                 self.detailModel.B_PURCHASETAX.length > 0 ? self.detailModel.B_PURCHASETAX : @""];
                
                
                section0PostNameArray =@[self.detailModel.C_BUYNAME.length > 0 ? self.detailModel.C_BUYNAME : @"",
                                                 self.detailModel.C_PHONE.length > 0 ? self.detailModel.C_PHONE : @"",
                                                 self.detailModel.C_CLUESOURCE_DD_ID.length > 0 ? self.detailModel.C_CLUESOURCE_DD_ID : @"",
                                                 self.detailModel.C_A41200_C_ID.length > 0 ? self.detailModel.C_A41200_C_ID : @"",
                                                 self.detailModel.D_ORDER_TIME.length >= 10 ? [self.detailModel.D_ORDER_TIME substringToIndex:10]  : @"",
                                                 self.detailModel.C_TYPE_DD_ID.length > 0 ? self.detailModel.C_TYPE_DD_ID : @"",
                                         self.detailModel.C_PURCHASEWAY_DD_ID.length > 0 ? self.detailModel.C_PURCHASEWAY_DD_ID : @"",
                                                 self.detailModel.C_VIN.length > 0 ? self.detailModel.C_VIN : @"",
                                                 self.detailModel.C_GDSPR.length > 0 ? self.detailModel.C_GDSPR : @"",
                                                 self.detailModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A70600_C_ID,self.detailModel.C_A49600_C_ID ] : @"",
                                                 self.detailModel.C_ALLOCATION.length > 0 ? self.detailModel.C_ALLOCATION : @"",
                                                 self.detailModel.a801.C_A80000CJ_C_ID.length > 0 ? self.detailModel.a801.C_A80000CJ_C_ID : @"",
                                                 self.detailModel.D_START_TIME.length > 0 ? self.detailModel.D_START_TIME : @"",
                                                 self.detailModel.C_A40500_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.detailModel.C_A40500_C_ID,self.detailModel.C_A40600_C_ID ] : @"",
                                                 self.detailModel.C_SPD.length > 0 ? self.detailModel.C_SPD : @"",
                                                 self.detailModel.B_GUIDEPRICE.length > 0 ? self.detailModel.B_GUIDEPRICE : @"",
                                                 self.detailModel.a801.B_KPJ.length > 0 ? self.detailModel.a801.B_KPJ : @"",
                                                 self.detailModel.B_CASHDISCOUNT.length > 0 ? self.detailModel.B_CASHDISCOUNT : @"",
                                                 self.detailModel.B_INSURANCEFEE.length > 0 ? self.detailModel.B_INSURANCEFEE: @"",
                                                 self.detailModel.B_FINANCIALFEE.length > 0 ? self.detailModel.B_FINANCIALFEE : @"",
                                                 self.detailModel.B_LICENCEFEE.length > 0 ? self.detailModel.B_LICENCEFEE : @"",
                                                 self.detailModel.B_DECORATEFEE.length > 0 ? self.detailModel.B_DECORATEFEE : @"",
                                                 self.detailModel.B_SERVICEFEE.length > 0 ? self.detailModel.B_SERVICEFEE : @"",
                                                 self.detailModel.B_OTHER.length > 0 ? self.detailModel.B_OTHER : @"",
                                                 self.detailModel.B_PURCHASETAX.length > 0 ? self.detailModel.B_PURCHASETAX : @""];
//            }
           
            NSMutableArray*MainArray0=self.localDatas[0];
            for (int i=0; i<MainArray0.count; i++) {
                PotentailCustomerEditModel*model=MainArray0[i];
                model.nameValue=section0ShowNameArray[i];
                model.postValue=section0PostNameArray[i];
            }
            
            
            
            NSArray*section1ShowNameArray =@[self.detailModel.C_BILLING.length > 0 ? self.detailModel.C_BILLING : @"",
                                             self.detailModel.C_INDUSTRY_DD_NAME.length > 0 ? self.detailModel.C_INDUSTRY_DD_NAME : @"",
                                             
                                             self.detailModel.C_ADDRESS.length > 0 ? self.detailModel.C_ADDRESS : @"",
                                             
                                             self.detailModel.D_SEND_TIME.length > 0 ? self.detailModel.D_SEND_TIME : @"",
                                             self.detailModel.D_SHSJ_TIME.length > 0 ? self.detailModel.D_SHSJ_TIME : @"",
                                             self.detailModel.X_REMARK.length > 0 ? self.detailModel.X_REMARK : @""];
            
            
            NSArray*section1PostNameArray =@[self.detailModel.C_BILLING.length > 0 ? self.detailModel.C_BILLING : @"",
                                             self.detailModel.C_INDUSTRY_DD_ID.length > 0 ? self.detailModel.C_INDUSTRY_DD_ID : @"",
                                             
                                             self.detailModel.C_ADDRESS.length > 0 ? self.detailModel.C_ADDRESS : @"",
                                             
                                             self.detailModel.D_SEND_TIME.length > 0 ? self.detailModel.D_SEND_TIME : @"",
                                             self.detailModel.D_SHSJ_TIME.length > 0 ? self.detailModel.D_SHSJ_TIME : @"",
                                             self.detailModel.X_REMARK.length > 0 ? self.detailModel.X_REMARK : @""];
            
           
            NSMutableArray*MainArray1=self.localDatas[1];
            for (int i=0; i<MainArray1.count; i++) {
                PotentailCustomerEditModel*model=MainArray1[i];
                model.nameValue=section1ShowNameArray[i];
                model.postValue=section1PostNameArray[i];
            }
            
            weakSelf.totalLabel.text = weakSelf.detailModel.B_GUIDEPRICE;
            
            [self.imageUrlArray removeAllObjects];
            
            [self.imageUrlArray addObjectsFromArray:self.detailModel.fileList];
            
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)saveCarSourceSdData:(NSString *)orderId andC_A82300_C_ID:(NSString *)C_A82300_C_ID andC_CYSTATUS_DD_ID:(NSString *)C_CYSTATUS_DD_ID {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A42000_C_ID"] = orderId;
    contentDic[@"C_A82300_C_ID"] = C_A82300_C_ID;
    contentDic[@"C_CYSTATUS_DD_ID"] = C_CYSTATUS_DD_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/cysd", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            for (UIViewController *rootVC in self.navigationController.viewControllers) {
                if ([rootVC isKindOfClass:[CGCOrderListVC class]]) {
                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                }
                if ([rootVC isKindOfClass:[CustomerDetailViewController class]]) {
                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                }
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitOrder {
    DBSelf(weakSelf);
    if ([self.detailModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0001"] ||
        [self.detailModel.C_STATUS_DD_ID isEqualToString:@"A42000_C_STATUS_0013"]) {//全款和出库不可编辑
        [JRToast showWithText:[NSString stringWithFormat:@"%@状态订单,不可编辑", self.detailModel.C_STATUS_DD_NAME]];
        return;
    }
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length <= 0) {
                if ([model.locatedTitle isEqualToString:@"潜客电话"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"来源渠道"] ||
                    [model.locatedTitle isEqualToString:@"渠道细分"]
                    ) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"订单类型"] ||
                    [model.locatedTitle isEqualToString:@"购车类型"]
                    ) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                if ([model.locatedTitle isEqualToString:@"定金金额"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                if ([model.locatedTitle isEqualToString:@"收款方式"] ||
                    [model.locatedTitle isEqualToString:@"收款人"] ||
                    [model.locatedTitle isEqualToString:@"定金状态"]||
                    [model.locatedTitle isEqualToString:@"品牌车型"]
                    ) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"具体型号"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"厂家"] ||
                    [model.locatedTitle isEqualToString:@"合同交车时间"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"车价"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
            }
        }
    }
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSMutableDictionary *a801 = [NSMutableDictionary dictionary];
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length > 0) {
                if ([model.locatedTitle isEqualToString:@"品牌车型"]) {
                    NSArray *keyArr = [model.keyValue componentsSeparatedByString:@","];
                    NSArray *postArr = [model.postValue componentsSeparatedByString:@","];
                    for (int i = 0; i < keyArr.count; i++) {
                        contentDic[keyArr[i]] = postArr[i];
                    }
                } else if ([model.locatedTitle isEqualToString:@"保有车型"]) {
                    NSArray *keyArr = [model.keyValue componentsSeparatedByString:@","];
                    NSArray *postArr = [model.postValue componentsSeparatedByString:@","];
                    for (int i = 0; i < keyArr.count; i++) {
                        contentDic[keyArr[i]] = postArr[i];
                    }
                } else if ([model.locatedTitle isEqualToString:@"厂家"]) {
                    a801[model.keyValue] = model.postValue;
                } else if ([model.locatedTitle isEqualToString:@"开票价"]) {
                    a801[model.keyValue] = model.postValue;
                } else if ([model.locatedTitle isEqualToString:@"下单时间"]) {
                    contentDic[model.keyValue] = [model.postValue stringByAppendingString:@" 00:00"];
                    
                } else {
                    contentDic[model.keyValue] = model.postValue;
                }
            }
        }
    }
    
    
    if (self.imageUrlArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in self.imageUrlArray) {
            [arr addObject:@{@"saveUrl": model.saveUrl}];
        }
        contentDic[@"fileList"] = arr;
    } else {
        contentDic[@"fileList"] = @[];
    }
    
    if (self.Type == orderTypeEdit) {
        a801[@"C_ID"] = self.detailModel.a801.C_ID;
    }
    if (a801.allKeys.count > 0) {
        contentDic[@"a801"] = a801;
    }
    NSString *path = [NSString stringWithFormat:@"%@/api/crm/a420/add", HTTP_IP];
    contentDic[@"C_A41500_C_ID"] = self.customerModel.C_ID;
    if (self.Type == orderTypeEdit) {
        path = [NSString stringWithFormat:@"%@/api/crm/a420/edit", HTTP_IP];
        contentDic[@"C_ID"] = self.detailModel.C_ID;
    }
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:path parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            if ([contentDic[@"C_XDSPR"] isEqualToString:@"A42000_C_DJTYPE_0001"] ||
                [contentDic[@"C_XDSPR"] isEqualToString:@"A42000_C_DJTYPE_0002"]) {
                if ([contentDic[@"C_A82300_C_ID"] length] > 0) {
                    if (![contentDic[@"C_A82300_C_ID"] isEqualToString:weakSelf.detailModel.C_A82300_C_ID]) {
                        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否绑定车源?" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [weakSelf saveCarSourceSdData:data[@"data"] andC_A82300_C_ID:contentDic[@"C_A82300_C_ID"] andC_CYSTATUS_DD_ID:[contentDic[@"C_XDSPR"] isEqualToString:@"A42000_C_DJTYPE_0001"] ? @"A82300_C_STATUS_0002" : @"A82300_C_STATUS_0003"];
                        }];
                        UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                            for (UIViewController *rootVC in self.navigationController.viewControllers) {
                                if ([rootVC isKindOfClass:[CGCOrderListVC class]]) {
                                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                                }
                                if ([rootVC isKindOfClass:[CustomerDetailViewController class]]) {
                                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                                }
                                if ([rootVC isKindOfClass:[MJKClueTabViewController class]]) {
                                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                                }
                                if ([rootVC isKindOfClass:[MJKFlowListViewController class]]) {
                                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                                }
                                if ([rootVC isKindOfClass:[MJKFlowMeterViewController class]]) {
                                    [weakSelf.navigationController popToViewController:rootVC animated:YES];
                                }
                            }
                        }];
                        [ac addAction:yesAction];
                        [ac addAction:noAction];
                        [weakSelf presentViewController:ac animated:yesAction completion:nil];
                    } else {
                        for (UIViewController *rootVC in self.navigationController.viewControllers) {
                            if ([rootVC isKindOfClass:[CGCOrderListVC class]]) {
                                [weakSelf.navigationController popToViewController:rootVC animated:YES];
                            }
                            if ([rootVC isKindOfClass:[CustomerDetailViewController class]]) {
                                [weakSelf.navigationController popToViewController:rootVC animated:YES];
                            }
                            if ([rootVC isKindOfClass:[MJKClueTabViewController class]]) {
                                [weakSelf.navigationController popToViewController:rootVC animated:YES];
                            }
                            if ([rootVC isKindOfClass:[MJKFlowListViewController class]]) {
                                [weakSelf.navigationController popToViewController:rootVC animated:YES];
                            }
                            if ([rootVC isKindOfClass:[MJKFlowMeterViewController class]]) {
                                [weakSelf.navigationController popToViewController:rootVC animated:YES];
                            }
                        }
                    }
                } else {
                    for (UIViewController *rootVC in self.navigationController.viewControllers) {
                        if ([rootVC isKindOfClass:[CGCOrderListVC class]]) {
                            [weakSelf.navigationController popToViewController:rootVC animated:YES];
                        }
                        if ([rootVC isKindOfClass:[CustomerDetailViewController class]]) {
                            [weakSelf.navigationController popToViewController:rootVC animated:YES];
                        }
                        if ([rootVC isKindOfClass:[MJKClueTabViewController class]]) {
                            [weakSelf.navigationController popToViewController:rootVC animated:YES];
                        }
                        if ([rootVC isKindOfClass:[MJKFlowListViewController class]]) {
                            [weakSelf.navigationController popToViewController:rootVC animated:YES];
                        }
                        if ([rootVC isKindOfClass:[MJKFlowMeterViewController class]]) {
                            [weakSelf.navigationController popToViewController:rootVC animated:YES];
                        }
                    }
                }
            } else {
                
                for (UIViewController *rootVC in self.navigationController.viewControllers) {
                    if ([rootVC isKindOfClass:[CGCOrderListVC class]]) {
                        [weakSelf.navigationController popToViewController:rootVC animated:YES];
                    }
                    if ([rootVC isKindOfClass:[CustomerDetailViewController class]]) {
                        [weakSelf.navigationController popToViewController:rootVC animated:YES];
                    }
                    if ([rootVC isKindOfClass:[MJKClueTabViewController class]]) {
                        [weakSelf.navigationController popToViewController:rootVC animated:YES];
                    }
                    if ([rootVC isKindOfClass:[MJKFlowListViewController class]]) {
                        [weakSelf.navigationController popToViewController:rootVC animated:YES];
                    }
                    if ([rootVC isKindOfClass:[MJKFlowMeterViewController class]]) {
                        [weakSelf.navigationController popToViewController:rootVC animated:YES];
                    }
                }
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


- (NSMutableArray *)fileListYsImage {
    if (!_fileListYsImage) {
        _fileListYsImage = [NSMutableArray array];
    }
    return _fileListYsImage;
}

- (NSMutableArray *)fileListYsImageList {
    if (!_fileListYsImageList) {
        _fileListYsImageList = [NSMutableArray array];
    }
    return _fileListYsImageList;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

@end
