//
//  MJKQuestionnaireViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/10/8.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKQuestionnaireViewController.h"
#import "MJKA807MainModel.h"
#import "MJKA808PojoListModel.h"
#import "MJKA809PojoListModel.h"
#import "MJKA810PojoListModel.h"

#import "CGCOrderDetailModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKTYPE0000TableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKChooseNewBrandViewController.h"
#import "MJKChooseNewCarModelsViewController.h"

#import "MJKProductShowModel.h"

@interface MJKQuestionnaireViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) MJKA807MainModel *A807DetailModel;
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *sectionArr;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *a808PojoArray;
@end

@implementation MJKQuestionnaireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = self.vcName;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self getAnswer811Data];
}
    

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.A807DetailModel.a810PojoList.count > 0) {
        return self.A807DetailModel.a810PojoList.count + 1;
    } else {
    return self.A807DetailModel.a808PojoList.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.sectionArr.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.section == 0) {
        AddCustomerInputTableViewCell *iCell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        AddCustomerChooseTableViewCell *cCell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        if (self.A807DetailModel.a810PojoList.count > 0) {
            iCell.inputTextField.enabled = NO;
            cCell.chooseTextField.enabled = NO;
        } else {
            iCell.inputTextField.enabled = YES;
            cCell.chooseTextField.enabled = YES;
        }
        NSString *cellStr = self.sectionArr[indexPath.row];
        iCell.nameTitleLabel.text = cellStr;
        cCell.nameTitleLabel.text = cellStr;
        if ([cellStr isEqualToString:@"门店"]) {
            iCell.inputTextField.enabled = NO;
            if (self.A807DetailModel.C_LOCCODE.length > 0) {
                iCell.textStr = self.A807DetailModel.C_LOCNAME;
            }
            return iCell;
        } else if ([cellStr isEqualToString:@"销售顾问"]) {
            iCell.inputTextField.enabled = NO;
            if (self.A807DetailModel.C_OWNER_ROLEID.length > 0) {
                iCell.textStr = self.A807DetailModel.C_OWNER_ROLENAME;
            }
            return iCell;
        } else if ([cellStr isEqualToString:@"面访日期"] || [cellStr isEqualToString:@"回访日期"]) {
            cCell.Type = ChooseTableViewTypeBirthday;
            if (self.A807DetailModel.D_HFRQ.length > 0) {
                cCell.textStr = self.A807DetailModel.D_HFRQ;
            }
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.A807DetailModel.D_HFRQ = postValue;
                [tableView reloadData];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"派单时间"]) {
            cCell.Type = ChooseTableViewTypeBirthday;
            if (self.A807DetailModel.D_BXSJ.length > 0) {
                cCell.textStr = self.A807DetailModel.D_BXSJ;
            }
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.A807DetailModel.D_BXSJ = postValue;
                [tableView reloadData];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"成交时间"]) {
            cCell.Type = ChooseTableViewTypeBirthday;
            if (self.A807DetailModel.D_SENDCAR_TIME.length > 0) {
                cCell.textStr = self.A807DetailModel.D_SENDCAR_TIME;
            }
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.A807DetailModel.D_SENDCAR_TIME = postValue;
                [tableView reloadData];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"面访人"] || [cellStr isEqualToString:@"回访人"]) {
            iCell.inputTextField.enabled = YES;
            if (self.A807DetailModel.C_HFR.length > 0) {
                iCell.textStr = self.A807DetailModel.C_HFR;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_HFR = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"客户姓名"] || [cellStr isEqualToString:@"提车人姓名"]) {
            if (self.A807DetailModel.C_KH_NAME.length > 0) {
                iCell.textStr = self.A807DetailModel.C_KH_NAME;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_KH_NAME = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"客户电话"] || [cellStr isEqualToString:@"提车人电话"]) {
            if (self.A807DetailModel.C_KH_PHONE.length > 0) {
                iCell.textStr = self.A807DetailModel.C_KH_PHONE;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_KH_NAME = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"客户生日"]) {
            cCell.Type = ChooseTableViewTypeBirthday;
            if (self.A807DetailModel.C_BIRTHDAY_TIME.length > 0) {
                cCell.textStr = self.A807DetailModel.C_BIRTHDAY_TIME;
            }
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.A807DetailModel.C_BIRTHDAY_TIME = postValue;
                [tableView reloadData];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"交车日期"]) {
            cCell.Type = ChooseTableViewTypeBirthday;
            if (self.A807DetailModel.D_JCRQ.length > 0) {
                cCell.textStr = self.A807DetailModel.D_JCRQ;
            }
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.A807DetailModel.D_JCRQ = postValue;
                [tableView reloadData];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"品牌"]) {
            if (self.A807DetailModel.C_A70600_C_ID.length > 0) {
                cCell.textStr = self.A807DetailModel.C_A70600_C_NAME;
            }
            cCell.Type = chooseTypeNil;
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
               MJKChooseNewBrandViewController *vc = [[MJKChooseNewBrandViewController alloc]init];
               vc.rootVC = weakSelf;
                vc.rootName = @"品牌";
                vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                    MJKProductShowModel *productModel = productArray[0];
                    weakSelf.A807DetailModel.C_A70600_C_ID = productModel.C_TYPE_DD_ID;
                    weakSelf.A807DetailModel.C_A70600_C_NAME = productModel.C_TYPE_DD_NAME;
                        
                        
                    [tableView reloadData];
                };
               [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"车型"]) {
            if (self.A807DetailModel.C_A49600_C_ID.length > 0) {
                cCell.textStr = self.A807DetailModel.C_A49600_C_NAME;
            }
            cCell.Type = chooseTypeNil;
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MJKChooseNewCarModelsViewController *vc = [[MJKChooseNewCarModelsViewController alloc]init];
                vc.C_TYPE_DD_ID = weakSelf.A807DetailModel.C_A70600_C_ID;
                vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                    MJKProductShowModel *productModel = productArray[0];
                    weakSelf.A807DetailModel.C_A49600_C_ID = productModel.C_ID;
                    weakSelf.A807DetailModel.C_A49600_C_NAME = productModel.C_NAME;
                    [tableView reloadData];
                };
                if (weakSelf.A807DetailModel.C_A70600_C_ID.length > 0) {
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                } else {
                    [JRToast showWithText:@"请先选择品牌"];
                }
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"品牌车型"]) {
            if (weakSelf.A807DetailModel.C_A49600_C_ID.length > 0) {
                cCell.textStr = weakSelf.A807DetailModel.C_A49600_C_NAME;
            }
            cCell.Type = chooseTypeNil;
            cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MJKChooseNewBrandViewController *vc = [[MJKChooseNewBrandViewController alloc]init];
               vc.rootVC = weakSelf;
                vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                    MJKProductShowModel *productModel = productArray[0];
                    weakSelf.A807DetailModel.C_A70600_C_ID = productModel.C_TYPE_DD_ID;
                    weakSelf.A807DetailModel.C_A70600_C_NAME = productModel.C_TYPE_DD_NAME;
                    weakSelf.A807DetailModel.C_A49600_C_ID = productModel.C_ID;
                    weakSelf.A807DetailModel.C_A49600_C_NAME = productModel.C_NAME;
                        
                        
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
               [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return cCell;
        } else if ([cellStr isEqualToString:@"车架号"]) {
            if (self.A807DetailModel.C_VIN.length > 0) {
                iCell.textStr = self.A807DetailModel.C_VIN;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_VIN = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"开票名称"]) {
            if (self.A807DetailModel.C_BILLING.length > 0) {
                iCell.textStr = self.A807DetailModel.C_BILLING;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_BILLING = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"具体型号"]) {
            if (self.A807DetailModel.C_JTXH.length > 0) {
                iCell.textStr = self.A807DetailModel.C_JTXH;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_JTXH = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"厂家"]) {
            if (self.A807DetailModel.C_A80000CJ_C_NAME.length > 0) {
                iCell.textStr = self.A807DetailModel.C_A80000CJ_C_NAME;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_A80000CJ_C_NAME = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"售后专员"]) {
            if (self.A807DetailModel.C_SHZY.length > 0) {
                iCell.textStr = self.A807DetailModel.C_SHZY;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_SHZY = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"客户星级"]) {
            if (self.A807DetailModel.C_LEVEL_DD_NAME.length > 0) {
                iCell.textStr = self.A807DetailModel.C_LEVEL_DD_NAME;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_LEVEL_DD_NAME = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"状态"]) {
            if (self.A807DetailModel.C_STATUS_DD_NAME.length > 0) {
                iCell.textStr = self.A807DetailModel.C_STATUS_DD_NAME;
            }
            iCell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_STATUS_DD_NAME = textStr;
            };
            return iCell;
        } else if ([cellStr isEqualToString:@"备注"]) {//备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
            cell.topTitleLabel.font  = [UIFont systemFontOfSize:14.f];
            cell.titleLeftLayout.constant = 20;
            cell.topTitleLabel.text=cellStr;
            if (self.A807DetailModel.a810PojoList.count > 0) {
                cell.textView.editable = NO;
            } else {
                cell.textView.editable = YES;
            }
            if (self.A807DetailModel.X_REMARK.length > 0) {
                cell.textView.text = self.A807DetailModel.X_REMARK;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.X_REMARK = textStr;
            };
            return  cell;
        } else if ([cellStr isEqualToString:@"客户问题"]) {//备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
            cell.topTitleLabel.font  = [UIFont systemFontOfSize:14.f];
            cell.titleLeftLayout.constant = 20;
            cell.topTitleLabel.text=cellStr;
            if (self.A807DetailModel.a810PojoList.count > 0) {
                cell.textView.editable = NO;
            } else {
                cell.textView.editable = YES;
            }
            if (self.A807DetailModel.C_KHWT.length > 0) {
                cell.textView.text = self.A807DetailModel.C_KHWT;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_KHWT = textStr;
            };
            return  cell;
        } else if ([cellStr isEqualToString:@"客户意见"]) {//备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
            cell.topTitleLabel.font  = [UIFont systemFontOfSize:14.f];
            cell.titleLeftLayout.constant = 20;
            cell.topTitleLabel.text=cellStr;
            
            if (self.A807DetailModel.a810PojoList.count > 0) {
                cell.textView.editable = NO;
            } else {
                cell.textView.editable = YES;
            }
            if (self.A807DetailModel.C_KHYJ.length > 0) {
                cell.textView.text = self.A807DetailModel.C_KHYJ;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.A807DetailModel.C_KHYJ = textStr;
            };
            return  cell;
        }
        return [UITableViewCell new];
    } else {
        MJKTYPE0000TableViewCell *cell = [MJKTYPE0000TableViewCell cellWithTableView:tableView];
        if (self.A807DetailModel.a810PojoList.count > 0) {
            MJKA810PojoListModel *a810Model = self.A807DetailModel.a810PojoList[indexPath.section - 1];
            cell.a810Model = a810Model;
        } else {
            MJKA808PojoListModel *a808Model = self.A807DetailModel.a808PojoList[indexPath.section - 1];
            if (self.a808PojoArray.count > 0) {
                cell.a808Arr = self.a808PojoArray;
            }
            cell.a808Model = a808Model;
            cell.radioButtonBlock = ^(MJKA809PojoListModel * _Nonnull a809Model, NSArray * _Nonnull list, NSString * _Nonnull X_REMARK, NSString * _Nonnull I_TYPE) {
                MJKA808PojoListModel *a808AddModel = [[MJKA808PojoListModel alloc]init];
                a808AddModel.C_ID = a808Model.C_ID;
                a808AddModel.C_NAME = a808Model.C_NAME;
                a808AddModel.C_A80700_C_ID = a808Model.C_A80700_C_ID;
                a808AddModel.C_A80700_C_NAME = a808Model.C_A80700_C_NAME;
                a808AddModel.C_TYPE_DD_ID = a808Model.C_TYPE_DD_ID;
                a808AddModel.C_TYPE_DD_NAME = a808Model.C_TYPE_DD_NAME;
                NSArray *tempArr = [weakSelf.a808PojoArray copy];
                for (MJKA808PojoListModel *subModel in tempArr) {
                    if ([a808AddModel.C_ID isEqualToString:subModel.C_ID]) {
                        [weakSelf.a808PojoArray removeObject:subModel];
                    }
                }
                
                if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0000"]) {
                    a808AddModel.C_A80900CHECK_C_ID = a809Model.C_ID;
                    [tableView reloadData];
                } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0003"]) {
                    a808AddModel.C_A80900CHECK_C_ID_LIST = list;
                } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0001"]) {
                    a808AddModel.X_REMARK = X_REMARK;
                } else if ([a808Model.C_TYPE_DD_ID isEqualToString:@"A80800_C_TYPE_0002"]) {
                    a808AddModel.I_TYPE = I_TYPE;
                }
                
                
                [weakSelf.a808PojoArray addObject:a808AddModel];
                MyLog(@"");
                
            };
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSString *cellStr = self.sectionArr[indexPath.row];
        if ([cellStr isEqualToString:@"备注"] || [cellStr isEqualToString:@"客户意见"] || [cellStr isEqualToString:@"客户问题"]) {
            return 120;
        }
        return 44;
    } else {
       
        if (self.A807DetailModel.a810PojoList.count > 0) {
            MJKA810PojoListModel *a810Model = self.A807DetailModel.a810PojoList[indexPath.section - 1];
            return [MJKTYPE0000TableViewCell heightForA810Model:a810Model];
        } else {
            MJKA808PojoListModel *a808Model = self.A807DetailModel.a808PojoList[indexPath.section - 1];
            return [MJKTYPE0000TableViewCell heightForModel:a808Model];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return .1f;
    }
    return 20;
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

- (void)getAnswer811Data {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    NSString *actionStr = @"";
    if ([self.vcName isEqualToString:@"面访问卷"]) {
        actionStr = HTTP_SYSTEMD811INFO;
        contentDic[@"C_A42000_C_ID"] = self.detailModel.C_ID;
    } else if ([self.vcName isEqualToString:@"销售满意度"]) {
        actionStr = HTTP_SYSTEMD812INFO;
        contentDic[@"C_A42000_C_ID"] = self.detailModel.C_ID;
    } else if ([self.vcName isEqualToString:@"售后满意度"]) {
        actionStr = [NSString stringWithFormat:@"%@/api/crm/a813/info", HTTP_IP];
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:actionStr parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.A807DetailModel = [MJKA807MainModel mj_objectWithKeyValues:data[@"data"]];
            if (weakSelf.A807DetailModel.a810PojoList.count > 0) {
                CGRect frame = weakSelf.tableView.frame;
                frame.size.height += 55;
                weakSelf.tableView.frame = frame;
            }
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitAction {
    DBSelf(weakSelf);
    NSString *actionStr = @"";
    if ([self.vcName isEqualToString:@"面访问卷"]) {
        actionStr = HTTP_SYSTEMD811ADD;
    } else if ([self.vcName isEqualToString:@"销售满意度"]) {
        actionStr = HTTP_SYSTEMD812ADD;
    }
    if (self.a808PojoArray.count != self.A807DetailModel.a808PojoList.count) {
        [JRToast showWithText:@"请完成所有问卷题目"];
        return;
    }
    
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A42000_C_ID"] = self.A807DetailModel.C_A42000_C_ID;
    contentDic[@"C_A70600_C_NAME"] = self.A807DetailModel.C_A70600_C_NAME;
    contentDic[@"C_A49600_C_NAME"] = self.A807DetailModel.C_A49600_C_NAME;
    contentDic[@"C_KH_NAME"] = self.A807DetailModel.C_KH_NAME;
    contentDic[@"C_KH_PHONE"] = self.A807DetailModel.C_KH_PHONE;
    contentDic[@"C_VIN"] = self.A807DetailModel.C_VIN;
    contentDic[@"C_A70600_C_ID"] = self.A807DetailModel.C_A70600_C_ID;
    contentDic[@"C_A49600_C_ID"] = self.A807DetailModel.C_A49600_C_ID;
    contentDic[@"C_BIRTHDAY_TIME"] = self.A807DetailModel.C_BIRTHDAY_TIME;
    contentDic[@"D_HFRQ"] = self.A807DetailModel.D_HFRQ;
    contentDic[@"C_HFR"] = self.A807DetailModel.C_HFR;
    if (self.A807DetailModel.D_JCRQ.length > 0) {
        contentDic[@"D_JCRQ"] = self.A807DetailModel.D_JCRQ;
    }
    if (self.A807DetailModel.C_BILLING.length > 0) {
        contentDic[@"C_BILLING"] = self.A807DetailModel.C_BILLING;
    }
    if (self.A807DetailModel.C_JTXH.length > 0) {
        contentDic[@"C_JTXH"] = self.A807DetailModel.C_JTXH;
    }
    if (self.A807DetailModel.X_REMARK.length > 0) {
        contentDic[@"X_REMARK"] = self.A807DetailModel.X_REMARK;
    }
    if (self.A807DetailModel.C_KHYJ.length > 0) {
        contentDic[@"C_KHYJ"] = self.A807DetailModel.C_KHYJ;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MJKA808PojoListModel *model in self.a808PojoArray) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"C_ID"] =  model.C_ID;
        dic[@"C_NAME"] =  model.C_NAME;
        dic[@"C_A80700_C_ID"] =  model.C_A80700_C_ID;
        dic[@"C_A80700_C_NAME"] =  model.C_A80700_C_NAME;
        dic[@"C_TYPE_DD_ID"] =  model.C_TYPE_DD_ID;
        dic[@"C_TYPE_DD_NAME"] =  model.C_TYPE_DD_NAME;
        dic[@"C_A80900CHECK_C_ID"] =  model.C_A80900CHECK_C_ID;
        dic[@"C_A80900CHECK_C_ID_LIST"] =  model.C_A80900CHECK_C_ID_LIST;
        dic[@"X_REMARK"] =  model.X_REMARK;
        dic[@"I_TYPE"] =  model.I_TYPE;
        [arr addObject:dic];
    }
    contentDic[@"a808PojoList"] = arr;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:actionStr parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
           
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, KScreenWidth, KScreenHeight - NAVIHEIGHT - SafeAreaBottomHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSArray *)sectionArr {
    if (!_sectionArr) {
        if ([self.vcName isEqualToString:@"面访问卷"]) {
            _sectionArr = @[@"面访日期",@"门店",@"销售顾问",@"面访人",@"客户姓名",@"客户电话",@"客户生日",@"品牌车型",@"车架号"];
        } else if ([self.vcName isEqualToString:@"销售满意度"]) {
            _sectionArr = @[@"回访日期",@"门店",@"销售顾问",@"回访人",@"提车人姓名",@"提车人电话",@"交车日期",@"品牌车型",@"车架号",@"开票名称",@"具体型号",@"备注", @"客户意见"];
        } else if ([self.vcName isEqualToString:@"售后满意度"]) {
            _sectionArr = @[@"回访日期",@"门店",@"销售顾问",@"回访人",@"客户姓名",@"客户电话",@"厂家",@"车架号",@"品牌车型",@"具体型号",@"售后专员",@"派单时间",@"成交时间",@"客户星级",@"客户问题",@"备注", @"状态"];
        }
    }
    return _sectionArr;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - AdaptTabHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 45)];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:KNaviColor];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

- (NSMutableArray *)a808PojoArray {
    if (!_a808PojoArray) {
        _a808PojoArray = [NSMutableArray array];
    }
    return _a808PojoArray;
}

@end
