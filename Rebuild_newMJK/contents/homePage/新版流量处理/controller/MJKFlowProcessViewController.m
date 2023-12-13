//
//  MJKFlowProcessViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/12/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKFlowProcessViewController.h"
#import "MJKFlowMeterViewController.h"
#import "MJKFlowListViewController.h"
#import "MJKShopArriveViewController.h"
#import "CustomerDetailViewController.h"
#import "AddOrEditlCustomerViewController.h"
#import "CustomerFollowAddEditViewController.h"
#import "MJKOrderAddOrEditViewController.h"
#import "CGCCustomModel.h"

#import "CGCAlertDateView.h"

#import "MJKFlowProcessModel.h"
#import "MJKFlowMeterDetailModel.h"
#import "MJKFlowMeterSubSecondModel.h"
#import "CustomerLvevelNextFollowModel.h"
#import "MJKFunnelChooseModel.h"
#import "MJKShopArriveContentModel.h"
#import "PotentailCustomerListDetailModel.h"
#import "CustomerDetailInfoModel.h"
#import "CGCNewAppointTextCell.h"
#import "MJKFlowProcessCustomerInfoCell.h"
#import "DBPickerView.h"
#import "MJKYESOrNOTableViewCell.h"

#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "MJKHistoryFlowViewController.h"

#import "MJKShowSendView.h"
#import "MJKMessagePushNotiViewController.h"
#import "MJKClueTabViewController.h"

#import "MJKClueListSubModel.h"
#import "MJKChooseEmployeesViewController.h"
#import "CGCBrokerCenterVC.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKChooseBrandViewController.h"
#import "MJKProductShowModel.h"
#import "CGCAppointmentModel.h"

@interface MJKFlowProcessViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
/** tableView*/
@property(nonatomic,strong) UITableView *tableView;
/** complete*/
@property(nonatomic,strong) UIButton *comoleteButton;
/** customer info array*/
@property(nonatomic,strong) NSMutableArray *customerInfoArray;
/** flow info array*/
@property(nonatomic,strong) NSMutableArray *flowInfoArray;
/** 接待信息*/
@property (nonatomic, strong) NSMutableArray *receptionInfoArray;
@property (nonatomic, strong) MJKFlowMeterDetailModel *detailModel;
/** 类型type*/
@property (nonatomic, strong) NSString *commitType;
/** customerID*/
@property (nonatomic, strong) NSString *customerID;
/** <#注释#>*/
@property (nonatomic, strong) NSString *isYuyue;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *buttonViewArray;
@property (nonatomic, strong) NSMutableArray *typeViewArray;
@property (nonatomic, strong) NSMutableArray *labelViewArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *yuyueID;

/** <#注释#>*/
@property (nonatomic, strong) NSString *flowID;

/** <#注释#>*/
@property (nonatomic, strong) NSDictionary *postDic;
@property (nonatomic, strong) NSDictionary *conectCusPostDic;

/** */
@property (nonatomic, strong) NSDictionary *dataDic;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *paramArr;

/** <#注释#>*/
@property (nonatomic, strong) UIButton *clearButton;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *a46000Forms;
@property (nonatomic, strong) NSMutableArray *a46000NameForms;
@property (nonatomic, strong) UIButton *preJSButton;
@property (nonatomic, strong) NSMutableArray *btArray;

@property (nonatomic, strong) NSString *C_YX_A49600_C_ID;
@property (nonatomic, strong) NSString *C_YX_A70600_C_ID;
@property (nonatomic, strong) NSString *C_YX_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_YX_A70600_C_NAME;

/** <#注释#>*/
@property (nonatomic, strong) NSString *C_PROVINCE;
@property (nonatomic, strong) NSString *C_CITY;
@property (nonatomic, strong) NSString *C_PROVINCEandC_CITY;

/** <#注释#> */
@property (nonatomic, strong) CGCAppointmentModel *amodel;


/** */
@end

@implementation MJKFlowProcessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    self.buttonViewArray = [NSMutableArray array];
    self.typeViewArray = [NSMutableArray array];
    self.labelViewArray = [NSMutableArray array];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitleNormal:@"流量指派"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(assButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.flowID = [DBObjectTools flowAboutC_id];
    [self initUI];
    self.btArray = [NSMutableArray array];
    NSArray *normalBtArr = [NewUserSession instance].configData.btListMapKh;
    for (NSDictionary *dic in normalBtArr) {
        [self.btArray addObject:dic[@"CODE"]];
    }
    
    //RAC监听回调
    //@"关联预约客户"
    @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"DJTESTNOTI" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self);
            NSDictionary *dic = (NSDictionary *)x.object;
            CGCAppointmentModel *model = [CGCAppointmentModel mj_objectWithKeyValues:dic];
            self.amodel = model;
            self.yuyueID = model.C_ID;
            self.commitType = @"关联预约客户";
            [self.comoleteButton setTitleNormal:@"预约客户到店"];
            self.isYuyue = @"yes";
            NSArray *arr = [NSArray arrayWithArray:self.customerInfoArray];
            NSMutableArray *numArr = [NSMutableArray array];
            for (int i = 0; i < arr.count; i++) {
                MJKFlowProcessModel *customerModel = arr[i];
                if ([customerModel.title isEqualToString:@"客户姓名"]) {
//                    if (customerModel.C_ID.length <= 0) {
//                        [self.customerInfoArray removeObjectAtIndex:2];
//                        [self.customerInfoArray removeObjectAtIndex:2];
//                        [self.customerInfoArray removeObjectAtIndex:2];
//                        [self.customerInfoArray removeObjectAtIndex:2];
//                        [self.customerInfoArray removeObjectAtIndex:2];
//                    }
                    customerModel.C_ID = model.C_A41500_C_ID;
                    customerModel.content = model.C_A41500_C_NAME;
                }
                if ([customerModel.title isEqualToString:@"手机号"] ||
                    [customerModel.title isEqualToString:@"微信号"] ||
                    [customerModel.title isEqualToString:@"意向车型"] ||
                    [customerModel.title isEqualToString:@"跟进等级"] ||
                    [customerModel.title isEqualToString:@"省市"]) {
                    [numArr addObject:@(i)];
                }
            }
            for (MJKFlowProcessModel *fmodel in self.flowInfoArray) {
                if ([fmodel.title isEqualToString:@"来源渠道"]) {
                    fmodel.C_ID = model.C_CLUESOURCE_DD_ID;
                    fmodel.content = model.C_CLUESOURCE_DD_NAME;
                }
                if ([fmodel.title isEqualToString:@"渠道细分"]) {
                    fmodel.C_ID = model.C_A41200_C_ID;
                    fmodel.content = model.C_A41200_C_NAME;
                }
                
                if ([fmodel.title isEqualToString:@"逗留时长"]) {
                    fmodel.C_ID = model.C_STAYTIME_DD_ID;
                    fmodel.content = model.C_STAYTIME_DD_NAME;
                }
            }
            
            NSMutableArray *tempArray =self.customerInfoArray;
            [numArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [tempArray removeObjectAtIndex:2];
            }];
            [self.tableView reloadData];
        }];
    
}

- (void)assButtonAction {
    DBSelf(weakSelf);
    if ([self.vcName isEqualToString:@"人脸"]) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a460:plzp"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    } else if ([self.vcName isEqualToString:@"到店"]) {
        
        if (![[NewUserSession instance].appcode containsObject:@"crm:a414:zp"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    }
    NSMutableArray *idArray = [NSMutableArray array];
    NSString *idStr;
    if ([self.clueName isEqualToString:@"新增"]) {
        idStr = self.flowID;
    } else {
        if (self.idStr.length > 0) {
            idStr = self.idStr;
        } else {
            [idArray addObject:self.detailModel.C_ID];
            
            idStr = [idArray componentsJoinedByString:@","];
        }
    }
    

    
    MJKFlowProcessModel *flowInfoModel = self.flowInfoArray[3];
    MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    //APP010_0015
    if ([[NewUserSession instance].appcode containsObject:@"APP010_0015"]) {
        vc.isAllEmployees = @"是";
    }
    vc.noticeStr = @"无提示";
    vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull saleModel) {
        
        if ([weakSelf.vcName isEqualToString:@"到店"]) {
            if (weakSelf.model.C_ID.length > 0) {
                [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andUserID:saleModel.user_id andSuccessBlock:^{
                    [KUSERDEFAULT setObject:@"yes" forKey:@"isBack"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            } else {
                [weakSelf HTTPInsertFlowDatasWithFlowid:idStr Complete:^(id data) {
                    [weakSelf HTTPCustomConnect:data[@"data"] andUserID:saleModel.user_id andSuccessBlock:^{
                        [KUSERDEFAULT setObject:@"yes" forKey:@"isBack"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }];
            }
        } else {
            [weakSelf HTTPInsertFlowDatasWithFlowid:idStr Complete:^(id data) {
                [weakSelf HTTPCustomConnect:data[@"data"] andUserID:saleModel.user_id andSuccessBlock:^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
            }];
        }
        
    };
    [weakSelf.navigationController pushViewController:vc animated:YES];
}

- (void)HTTPInsertFlowDatasWithFlowid:(NSString *)idStr Complete:(void(^)(id data))successBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_flowInsert];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    
    for (MJKFlowProcessModel *customerModel in self.customerInfoArray) {
        //        if ([customerModel.title isEqualToString:@"性别"]) {
        //            contentDict[@"C_SEX"] = customerModel.C_ID;
        //        } else if ([customerModel.title isEqualToString:@"年龄"]) {
        //            contentDict[@"C_AGE"] = customerModel.C_ID;
        //        }
        if ([self.commitType isEqualToString:@"关联预约客户"]) {
            if ([customerModel.code isEqualToString:@"C_A41500_C_ID"]) {
                if (customerModel.C_ID.length > 0) {
                    contentDict[@"C_A41600_C_ID"] = customerModel.C_ID;
                }
            }
        } else {
            if (customerModel.C_ID.length > 0) {
                contentDict[customerModel.code] = customerModel.C_ID;
            }
        }
        
        
    }
    for (MJKFlowProcessModel *model in self.flowInfoArray) {
        //        if ([model.title isEqualToString:@"进店人数"]) {
        //            contentDict[@"I_PEPOLE_NUMBER"] = model.C_ID;
        //        } else
        //        if ([model.title isEqualToString:@"进店时间"]) {
        //            contentDict[@"D_ARRIVAL_TIME"] = model.C_ID;
        //        }
        //            else if ([model.title isEqualToString:@"来源渠道"]) {
        //            contentDict[@"C_SOURCE_DD_ID"] = model.C_ID;
        //        } else if ([model.title isEqualToString:@"随行人员"]) {
        //            contentDict[@"C_ATTENDANT"] = model.C_ID;
        //        } else if ([model.title isEqualToString:@"逗留时长"]) {
        //            contentDict[@"C_STAYTIME_DD_ID"] = model.C_ID;
        //        } else if ([model.title isEqualToString:@"渠道细分"]) {
        //            contentDict[@"C_A41200_C_ID"] = model.C_ID;
        //        }
        if ([model.code isEqualToString:@"I_ARRIVAL"]) {
            if (model.C_ID != nil) {
                NSString *str = [NSString stringWithFormat:@"%@",model.C_ID];
                //                    contentDict[model.code] = str;
                //I_PEPOLE_NUMBER
                contentDict[@"I_PEPOLE_NUMBER"] = str;
            }
            
        } else {
            
            model.C_ID = [model.C_ID isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@",model.C_ID] : model.C_ID;
            if (model.C_ID.length > 0) {
                contentDict[model.code] = model.C_ID;
            }
        }
    }
    [contentDict setObject:[NewUserSession instance].user.u051Id forKey:@"USER_ID"];
    [contentDict setObject:idStr forKey:@"C_ID"];
    if (![self.clueName isEqualToString:@"新增"]&& ![self.typeName isEqualToString:@"有效流量"]) {
        [contentDict setObject:self.idStr.length > 0 ? self.idStr : self.detailModel.C_ID forKey:@"C_A46000_C_ID"];
    }
    if (self.a46000Forms.count > 0) {
        contentDict[@"a46000Forms"] = self.a46000Forms;
    }
    [dict setObject:contentDict forKey:@"content"];
    //    [dict setObject:@{@"C_ID" :  self.detailModel.C_ID, } forKey:@"content"];
    
    if (self.postDic == contentDict) {
        return;
    }
    self.postDic = contentDict;
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/add", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            successBlock(data);
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)HTTPCustomConnect:(NSString *)C_ID andUserID:(NSString *)userID andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = C_ID;
    contentDic[@"type"] = @"4";
    contentDic[@"USER_ID"] = userID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    if (![self.vcName isEqualToString:@"详情"]) {
        self.title = @"流量处理";
        [self.view addSubview:self.comoleteButton];
    }
    
    if (self.type == MJKFlowProcessOneImage) {
        if (![self.clueName isEqualToString:@"新增"]) {
            self.title = @"流量处理";
            [self HTTPGetFlowMeterDetailDatas];
        } else {
            self.title = @"流量新增";
            self.clearButton.hidden = NO;
//            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        }
    }
    if ([self.clueName isEqualToString:@"已处理流量详情"]) {
        self.title = @"流量详情";
        UIButton *rightItemButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [rightItemButton addTarget:self action:@selector(clickHistory)];
        [rightItemButton setImage:@"23-顶右button"];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemButton];
//        if ([self.model.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0002"]) {
//            self.comoleteButton.hidden = YES;
//            CGRect rect = self.tableView.frame;
//            rect.size.height = rect.size.height + 50;
//            self.tableView.frame = rect;
//        }
    }

}

- (void)clickHistory {
    MJKHistoryFlowViewController *vc = [[MJKHistoryFlowViewController alloc]init];
    vc.VCName = @"流量";
    vc.C_A41500_C_ID = self.detailModel.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.detailModel.LEVEL isEqualToString:@"HEART"] || [self.detailModel.LEVEL isEqualToString:@"VIP"] || [self.clueName isEqualToString:@"已处理流量详情"]) {
        return 3;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.customerInfoArray.count;
    } else if (section == 0) {
        return self.flowInfoArray.count;
    } else {
        return self.receptionInfoArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKFlowProcessCustomerInfoCell *cell = [MJKFlowProcessCustomerInfoCell cellWithTableView:tableView];
    if (indexPath.section == 1) {
        if ([self.vcName isEqualToString:@"详情"]) {
            MJKFlowProcessModel *model = self.customerInfoArray[indexPath.row];
            cell.titleLabel.text = model.title;
            cell.contentTF.textColor = [UIColor lightGrayColor];
            cell.contentTF.hidden = NO;
            if ([model.title isEqualToString:@"预约客户"]) {
                if ([self.detailModel.C_STATUS_DD_ID isEqualToString:@"A41400_C_STATUS_0007"]) {
                    cell.contentTF.text = @"是";
                } else {
                    cell.contentTF.text = @"否";
                }
            } else {
                
                cell.contentTF.text = model.content;
            }
            if ([self.title isEqualToString:@"流量详情"]) {
                if ([model.title isEqualToString:@"客户姓名"]) {
                    if (self.detailModel.C_A41500_C_ID.length > 0) {
                        cell.toCustomDetailButton.hidden = NO;
                        cell.selectCustomerButton.hidden = YES;
                        cell.contentTFRightLayout.constant = 50;
                        [cell.toCustomDetailButton addTarget:self action:@selector(toCusromerDetail)];
                    }
                }
            } else {
                cell.toCustomDetailButton.hidden = YES;
                cell.selectCustomerButton.hidden = YES;
                cell.contentTFRightLayout.constant = 20;
            }
            
            cell.contentTF.enabled = NO;
        } else {
            DBSelf(weakSelf);
            MJKFlowProcessModel *model = self.customerInfoArray[indexPath.row];
            if ([model.title isEqualToString:@"预约客户"]) {
                MJKYESOrNOTableViewCell *cell = [MJKYESOrNOTableViewCell cellWithTableView:tableView];
                cell.titleLabel.text = model.title;
                if ([self.isYuyue isEqualToString:@"yes"]) {
                    [cell.yesButton setBackgroundColor:KNaviColor];
                    [cell.noBUtton setBackgroundColor:kBackgroundColor];
                } else {
                    [cell.yesButton setBackgroundColor:kBackgroundColor];
                    [cell.noBUtton setBackgroundColor:KNaviColor];
                }
                cell.yesButtonActionBlock = ^{
                    MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
                    arrVC.type = ShopArriveTypeChoose;
                    arrVC.backCustomerInfoBlock = ^(MJKShopArriveContentModel *model) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                        weakSelf.yuyueID = model.C_ID;
                        weakSelf.commitType = @"关联预约客户";
                        [weakSelf.comoleteButton setTitleNormal:@"预约客户到店"];
                        weakSelf.isYuyue = @"yes";
                        NSArray *arr = [NSArray arrayWithArray:weakSelf.customerInfoArray];
                        
                        NSMutableArray *numArr = [NSMutableArray array];
                        for (int i = 0; i < arr.count; i++) {
                            MJKFlowProcessModel *customerModel = arr[i];
                            if ([customerModel.title isEqualToString:@"客户姓名"]) {
//                                if (customerModel.C_ID.length <= 0) {
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                }
                                customerModel.C_ID = model.C_ID;
                                customerModel.content = model.C_A41500_C_NAME;
                                
                            }
                            if ([customerModel.title isEqualToString:@"手机号"] ||
                                [customerModel.title isEqualToString:@"微信号"] ||
                                [customerModel.title isEqualToString:@"意向车型"] ||
                                [customerModel.title isEqualToString:@"跟进等级"] ||
                                [customerModel.title isEqualToString:@"省市"]) {
                                [numArr addObject:@(i)];
                            }
                        }
                        NSMutableArray *tempArray =self.customerInfoArray;
                        [numArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [tempArray removeObjectAtIndex:2];
                        }];
                        
                        MJKFlowProcessModel *cluesProcessModel = self.flowInfoArray[6];
                        cluesProcessModel.content = model.C_CLUESOURCE_DD_NAME_CUSTOMER;
                        cluesProcessModel.C_ID = model.C_CLUESOURCE_DD_ID_CUSTOMER;
                        
                        MJKFlowProcessModel *A41200ProcessModel = self.flowInfoArray[7];
                        A41200ProcessModel.content = model.C_A41200_C_NAME_CUSTOMER;
                        A41200ProcessModel.C_ID = model.C_A41200_C_ID_CUSTOMER;
                        
                        NSInteger index = [self.customerInfoArray indexOfObject:@"客户姓名"];
//                        [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];;
                        [tableView reloadData];
                        //            [weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
                        //                [weakSelf HTTPCustomConnect:[NSString stringWithFormat:@"A41400-%@",self.random] andType:@"6" andC_A41500_C_ID:C_ID];
                        //            }];
                        
                    };
                    [self.navigationController pushViewController:arrVC animated:YES];
                };
                
                cell.noButtonActionBlock = ^{
                    weakSelf.commitType = @"";
                    weakSelf.isYuyue = @"no";
                };
                return cell;
            }  else if ([model.title isEqualToString:@"介绍人"]) {
                    //经纪人
                AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
                cell.nameTitleLabel.text = model.title;
                cell.taglabel.hidden = YES;
                cell.titleLeftLayout.constant = 20;
                if (model.C_ID.length > 0) {
                   cell.textStr=model.content;
                }
                
                    cell.Type=chooseTypeNil;
                    cell.BottomLineView.hidden=YES;
                    cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                        MyLog(@"str-- %@      post---%@",str,postValue);
                        MyLog(@"%@,%@",str,postValue);
                        CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
                        vc.type = BrokerCenterMembers;
                        vc.typeName = @"名单经纪人";
                        if ([NewUserSession instance].configData.IS_JSRSFKFXZ.boolValue == YES) {
                            vc.SEARCH_TYPE = @"1";
                        }
                        vc.backSelectFansBlock = ^(CGCCustomModel *model1) {
                            model.C_ID = model1.C_ID;
                            model.content = model1.C_NAME;
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    };
                
                return cell;
            } else if ([model.title isEqualToString:@"意向车型"]) {
               AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
               cell.nameTitleLabel.text = @"意向车型";
               cell.taglabel.hidden = NO;
               cell.titleLeftLayout.constant = 20;
               if (self.C_YX_A49600_C_NAME.length > 0) {
                  cell.textStr=self.C_YX_A49600_C_NAME;
               }

               cell.Type = chooseTypeNil;
               cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                  MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
                  vc.rootVC = weakSelf;
                   vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                       MJKProductShowModel *productModel = productArray[0];
                       weakSelf.C_YX_A49600_C_ID = productModel.C_ID;
                       weakSelf.C_YX_A70600_C_ID = productModel.C_TYPE_DD_ID;
                       weakSelf.C_YX_A49600_C_NAME = productModel.C_NAME;
                       weakSelf.C_YX_A70600_C_NAME = productModel.C_TYPE_DD_NAME;
                       model.content = productModel.C_NAME;
                       [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                   };
                  [weakSelf.navigationController pushViewController:vc animated:YES];
               };

               return cell;
            } else if ([model.title isEqualToString:@"省市"]) {
                AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
                    cell.nameTitleLabel.text = @"省市";
                if ([self.btArray containsObject:@"A47500_C_BTX_0014"]) {
                    cell.taglabel.hidden = NO;
                } else {
                    
                    cell.taglabel.hidden = YES;
                }
                    cell.titleLeftLayout.constant = 20;
                    if (self.C_PROVINCEandC_CITY.length > 0) {
                       cell.textStr=self.C_PROVINCEandC_CITY;
                    }

                    cell.Type = ChooseTableViewTypeCity;
                    cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                        weakSelf.C_PROVINCEandC_CITY = postValue;
                        NSArray *arr = [postValue componentsSeparatedByString:@","];
                        if (arr.count > 1) {
                            weakSelf.C_PROVINCE = arr[0];
                            weakSelf.C_CITY = arr[1];
                        }
                        model.content = postValue;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                    };

                    return cell;
                }
            
            
            if ([model.title isEqualToString:@"手机号"]) {
                cell.contentTF.keyboardType = UIKeyboardTypePhonePad;
            }
            if ([model.title isEqualToString:@"手机号"] || [model.title isEqualToString:@"客户姓名"] || [model.title isEqualToString:@"微信号"]) {
                [cell.contentTF addTarget:self action:@selector(textChangeBegin:) forControlEvents:UIControlEventEditingDidBegin];
                [cell.contentTF addTarget:self action:@selector(textChangeEnd:) forControlEvents:UIControlEventEditingDidEnd];
            }
            cell.titleLabel.text = model.title;
            cell.contentTF.textColor = [UIColor lightGrayColor];
            cell.contentTF.hidden = NO;
            cell.contentTF.tag = indexPath.row;
            cell.contentTF.text = model.content;
            if (model.isGo == YES) {
                cell.contentTFRightLayout.constant = 30;
                cell.arrowImageView.hidden = NO;
                cell.contentTF.enabled = NO;
                cell.contentTF.placeholder = @"请选择";
                if ([model.title isEqualToString:@"跟进等级"]) {
                    cell.mustbeLabel.hidden = NO;
                }
            } else if (model.isSelect == YES) {
                if ([self.detailModel.LEVEL isEqualToString:@"VIP"]) {
                    cell.toCustomDetailButton.hidden = NO;
                    cell.selectCustomerButton.hidden = YES;
                    cell.contentTFRightLayout.constant = 50;
                } else {
                    cell.toCustomDetailButton.hidden = YES;
                    cell.selectCustomerButton.hidden = NO;
                    cell.contentTFRightLayout.constant = 80;
                }
                
                if ([model.title isEqualToString:@"手机号"]) {
                    cell.contentTF.placeholder = @"手机号和微信必填一项";
                    cell.mustbeLabel.hidden = NO;
                } else {
                    cell.contentTF.placeholder = @"请输入";
                }
                if ([model.title isEqualToString:@"跟进等级"]) {
                    cell.mustbeLabel.hidden = NO;
                }
                if ([model.title isEqualToString:@"客户姓名"]) {
                    cell.contentTF.placeholder = @"请输入姓名或选择已有客户";
                }
                [cell.selectCustomerButton addTarget:self action:@selector(selectCustomer:)];
                cell.selectCustomerButton.tag = indexPath.row;
                [cell.toCustomDetailButton addTarget:self action:@selector(toCusromerDetail)];
                cell.toCustomDetailButton.tag = indexPath.row;
                [cell.contentTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
            } else if (model.isData == YES) {
                cell.contentTF.enabled = NO;
            }
            else {
                if ([model.title isEqualToString:@"手机号"]) {
                    cell.contentTF.placeholder = @"手机号和微信必填一项";
                    cell.mustbeLabel.hidden = NO;
                    cell.contentTF.delegate = self;
                } else {
                    cell.contentTF.placeholder = @"请输入";
                }
                if ([model.title isEqualToString:@"跟进等级"]) {
                    cell.mustbeLabel.hidden = NO;
                }
                [cell.contentTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
            }
        }
        return cell;
    } else if (indexPath.section == 0) {
        if ([self.vcName isEqualToString:@"详情"]) {
            MJKFlowProcessModel *model = self.flowInfoArray[indexPath.row];
            
            if (indexPath.row == self.flowInfoArray.count - 1) {
                //预约备注
                CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
                cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
                cell.titleLeftLayout.constant = 20;
                cell.topTitleLabel.text=@"备注";
                //            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                cell.beforeText=model.content;
                //            }
                
//                cell.changeTextBlock = ^(NSString *textStr) {
//                    model.C_ID=textStr;
//                    model.content=textStr;
//                };
                
                cell.textView.editable = NO;
                
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
                
            }
            
            cell.titleLabel.text = model.title;
            cell.contentTF.textColor = [UIColor lightGrayColor];
            cell.contentTF.hidden = NO;
            cell.contentTF.text = model.content;
            cell.contentTF.enabled = NO;
        } else {
            MJKFlowProcessModel *model = self.flowInfoArray[indexPath.row];
            if (indexPath.row == self.flowInfoArray.count - 1) {
                //预约备注
                CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
                cell.topTitleLabel.font = [UIFont systemFontOfSize:14.f];
                cell.titleLeftLayout.constant = 20;
                cell.topTitleLabel.text=@"备注";
                cell.beforeText=model.content;
                
                cell.changeTextBlock = ^(NSString *textStr) {
                    model.C_ID=textStr;
                    model.content=textStr;
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
                
            }
            
            cell.titleLabel.text = model.title;
            cell.contentTF.textColor = [UIColor lightGrayColor];
            cell.contentTF.hidden = NO;
            cell.contentTF.tag = indexPath.row + 100;
            cell.contentTF.text = model.content;
//            if ([model.title isEqualToString:@"微信号"]) {
//                [cell.contentTF addTarget:self action:@selector(textChangeBegin:) forControlEvents:UIControlEventEditingDidBegin];
//
//                [cell.contentTF addTarget:self action:@selector(textChangeEnd:) forControlEvents:UIControlEventEditingDidEnd];
//            }
            if (model.isAdd == YES) {
                cell.contentTF.hidden = YES;
                cell.peopleCountTF.textColor = [UIColor lightGrayColor];
                cell.peopleCountTF.text = model.content;
                cell.addButton.hidden = cell.peopleCountTF.hidden = cell.subButton.hidden = NO;
                [cell.addButton addTarget:self action:@selector(addPeople:)];
                [cell.subButton addTarget:self action:@selector(subPeople:)];
                if ([model.title isEqualToString:@"进店人数"]) {
                    cell.peopleCountTF.enabled = NO;
                }
                cell.addButton.tag = 1000 + indexPath.row;
                cell.subButton.tag = 2000 + indexPath.row;
                cell.peopleCountTF.tag = 3000 + indexPath.row;
                cell.peopleCountTF.delegate = self;
                [cell.peopleCountTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
            } else if (model.isGo == YES) {
                cell.contentTFRightLayout.constant = 30;
                cell.arrowImageView.hidden = NO;
                cell.contentTF.enabled = NO;
                cell.contentTF.placeholder = @"请选择";
                if ([model.title isEqualToString:@"来源渠道"]) {
                    if ([self.btArray containsObject:@"A47500_C_BTX_0008"]) {
                        cell.mustbeLabel.hidden = NO;
                    }
                } else if ([model.title isEqualToString:@"渠道细分"]) {
                    if ([self.btArray containsObject:@"A47500_C_BTX_0009"]) {
                        cell.mustbeLabel.hidden = NO;
                    }
                }
            } else if (model.isData == YES) {
                cell.contentTF.enabled = NO;
            } else {
                cell.contentTF.placeholder = @"请输入";
                [cell.contentTF addTarget:self action:@selector(changeText:) forControlEvents:UIControlEventEditingChanged];
            }
        }
        return cell;
    } else {
        MJKFlowProcessModel *model = self.receptionInfoArray[indexPath.row];
        cell.titleLabel.text = model.title;
        cell.contentTF.textColor = [UIColor lightGrayColor];
        cell.contentTF.hidden = NO;
        cell.contentTF.tag = indexPath.row + 100;
        cell.contentTF.text = model.content;
        cell.contentTF.enabled = NO;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DBSelf(weakSelf);
    [self.view endEditing:YES];
    if ([self.title isEqualToString:@"流量详情"]) {
    } else {
        if (indexPath.section == 1) {
            MJKFlowProcessModel *model = self.customerInfoArray[indexPath.row];
            if ([model.title isEqualToString:@"预约客户"]) {
               
                
            }
            if ([model.title isEqualToString:@"跟进等级"]) {
                [self getDayLevel:^(NSArray *array) {
                    NSMutableArray*mtArray=[NSMutableArray array];
                    NSMutableArray*postArray=[NSMutableArray array];
                    for (CustomerLvevelNextFollowModel*model in array) {
                        [mtArray addObject:model.C_DAYNAME];
                        [postArray addObject:model.C_VOUCHERID];
                    }
                    
                    DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
                        MyLog(@"%@    %@",title,indexStr);
                        NSInteger number=[indexStr integerValue];
                        NSString*postStr=postArray[number];
                        model.content = title;
                        model.C_ID = postStr;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        
                    }];
                    [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                }];
            }
        } else {
            MJKFlowProcessModel *model = self.flowInfoArray[indexPath.row];
            if ([model.title isEqualToString:@"逗留时长"]) {
                NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41400_C_STAYTIME"];
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKDataDicModel*model in dataArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_VOUCHERID];
                }
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeMimute andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    model.content = title;
                    model.C_ID = postStr;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            } else if ([model.title isEqualToString:@"来源渠道"]) {
                NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
                NSMutableArray*mtArray=[NSMutableArray array];
                NSMutableArray*postArray=[NSMutableArray array];
                for (MJKDataDicModel*model in dataArray) {
                    [mtArray addObject:model.C_NAME];
                    [postArray addObject:model.C_VOUCHERID];
                }
                
                DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:@"来源渠道" andBlock:^(NSString *title, NSString *indexStr) {
                    MyLog(@"%@    %@",title,indexStr);
                    NSInteger number=[indexStr integerValue];
                    NSString*postStr=postArray[number];
                    MJKFlowProcessModel*model2=self.flowInfoArray[indexPath.row+1];
                    model2.content=@"";
                    model2.C_ID=@"";
                    model.content = title;
                    model.C_ID = postStr;
                    [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                    
                    
                }];
                [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
            } else if ([model.title isEqualToString:@"渠道细分"]) {
                MJKFlowProcessModel*model2=self.flowInfoArray[indexPath.row-1];
                [HttpWebObject HttpObjectGetMarketActionWithSourceID:model2.C_ID Success:^(id data) {
                    MyLog(@"%@",data);
                    if ([data[@"code"] integerValue]==200) {
                        NSMutableArray*mtArray=[NSMutableArray array];    //单单要的title
                        NSMutableArray*saveMarketArray=[NSMutableArray array];  //保存model
                        NSArray*array=data[@"data"][@"list"];
                        for (NSDictionary*dict in array) {
                            MJKFunnelChooseModel*model1=[[MJKFunnelChooseModel alloc]init];
                            model1.name=dict[@"C_NAME"];
                            model1.c_id=dict[@"C_ID"];
                            
                            [saveMarketArray addObject:model1];
                            [mtArray addObject:model1.name];
                        }
                        if (mtArray.count <= 0) {
                            [JRToast showWithText:@"暂无渠道细分请先添加"];
                            return;
                        }
                        DBPickerView*pickerV=[[DBPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight) andCurrentType:PickViewTypeArray andmtArrayDatas:mtArray andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
                            MyLog(@"%@    %@",title,indexStr);
                            NSInteger number=[indexStr integerValue];
                            MJKFunnelChooseModel*model1=saveMarketArray[number];
                            NSString*postStr=model1.c_id;
                            model.content = title;
                            model.C_ID = postStr;
                            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            
                            
                        }];
                        [[UIApplication sharedApplication].keyWindow addSubview:pickerV];
                        
                    }else{
                        [JRToast showWithText:data[@"msg"]];
                    }
                    
                }];
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.flowInfoArray.count - 1) {
            return 100;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (self.headImageArray.count > 0)  {
            CGFloat height = self.headImageArray.count % 4 == 0 ? (self.headImageArray.count / 4) * 60  + 40: ((self.headImageArray.count / 4) + 1) * 60 + 40;
//            if (self.headImageArray.count > 1) {
                height += self.headImageArray.count % 4 == 0 ? (self.headImageArray.count / 4) * 20 : ((self.headImageArray.count / 4) + 1) * 20;
                height += self.headImageArray.count % 4 == 0 ? (self.headImageArray.count / 4) * 20 : ((self.headImageArray.count / 4) + 1) * 20;
//            }
            if ([self.clueName isEqualToString:@"已处理流量详情"]) {
                return height + 20;
            }
            return height + 20 + 60;
        }
        if (self.detailModel.C_HEADPIC.length > 0) {
            if ([self.vcName isEqualToString:@"详情"]) {
                return 110 + 20;
            }
            return 110 + 20 + 60;
        }
    }
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    self.imageViewArray = [NSMutableArray array];
    NSMutableArray *imageViewArray = [NSMutableArray array];
    NSMutableArray *buttonViewArray = [NSMutableArray array];
    NSMutableArray *labelViewArray = [NSMutableArray array];
    NSMutableArray *chooseViewArray = [NSMutableArray array];
    NSMutableArray *a46000Forms = [NSMutableArray array];
    NSMutableArray *a46000NameForms = [NSMutableArray array];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectZero];
    bgView.backgroundColor = kBackgroundColor;
    UIView *buttonView = [[UIView alloc]initWithFrame:CGRectZero];//一张照片时照片下方有按钮
    buttonView.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        UIView *imageBGView = [[UIView alloc]initWithFrame:CGRectZero];
        imageBGView.backgroundColor = [UIColor whiteColor];
        CGFloat height = 0;
        if (self.headImageArray.count > 0) {
            CGFloat marginX = self.headImageArray.count >= 4 ? (KScreenWidth - (50 * 4)) / 5 : ((KScreenWidth - (50 * self.headImageArray.count)) / (self.headImageArray.count + 1));
            for (int i = 0; i < self.headImageArray.count; i++) {
                
                NSString *C_ID;
                NSString *C_A41500_C_ID;
                NSString *C_A41500_C_NAME;
                if (self.idArr.count > 0) {
                    C_ID = self.idArr[i];
                    C_A41500_C_ID = self.C_A41500_C_IDArray[i];
                    C_A41500_C_NAME = self.C_A41500_C_NAMEArray[i];
                }
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(marginX + ((i % 4) * (50 + marginX)), (i / 4) * 120 + 10, 50, 20)];
                
                if (self.detailModel != nil) {
                    button.enabled = NO;
                    NSDictionary *dic = self.detailModel.headpic_content[i];
                    [button setTitleNormal:[NSString stringWithFormat:@"%@v",dic[@"C_JSTYPE_DD_NAME"]]];
                } else {
                    if (self.a46000Forms.count > 0) {
                        [a46000Forms addObjectsFromArray:self.a46000Forms];
                        [a46000NameForms addObjectsFromArray:self.a46000NameForms];
                        NSMutableDictionary *dic = self.a46000NameForms[i];
                        [button setTitleNormal:[NSString stringWithFormat:@"%@v",dic[@"C_JSTYPE_DD_NAME"]]];
                    } else {
                        if (i == 0) {
                            [button setTitleNormal:@"决策人v"];
                            if (![self.clueName isEqualToString:@"已处理流量详情"]) {
                                [a46000Forms addObject:[@{@"C_ID" : C_ID,@"C_JSTYPE_DD_ID" : @"A46000_C_JSTYPE_0000",@"C_A47700_C_ID":@""} mutableCopy]];
                                [a46000NameForms addObject:[@{@"C_ID" : C_ID,@"C_JSTYPE_DD_NAME" : @"决策人",@"C_A47700_C_NAME":@""} mutableCopy]];
                            }
                        } else {
                            [button setTitleNormal:@"随访人v"];
                            if (![self.clueName isEqualToString:@"已处理流量详情"]) {
                                [a46000Forms addObject:[@{@"C_ID" : C_ID,@"C_JSTYPE_DD_ID" : @"A46000_C_JSTYPE_0001",@"C_A47700_C_ID":@""} mutableCopy]];
                                [a46000NameForms addObject:[@{@"C_ID" : C_ID,@"C_JSTYPE_DD_NAME" : @"随访人",@"C_A47700_C_NAME":@""} mutableCopy]];
                            }
                        }
                    }
                }
                [button setTitleColor:[UIColor blackColor]];
                button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
                button.tag = 10 + i;
                [button addTarget:self action:@selector(chooseJSTypeAction:)];
//                if (self.headImageArray.count > 1) {
                    [imageBGView addSubview:button];
//                }
                [buttonViewArray addObject:button];
                
                
                
                
                
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame), 50, 20)];
                label.textColor = [UIColor blackColor];
                label.textAlignment = NSTextAlignmentCenter;
                label.hidden = YES;
                label.font = [UIFont systemFontOfSize:10.f];
                label.tag = 100 + i;
//                if (self.headImageArray.count > 1) {
                    [imageBGView addSubview:label];
//                }
                
                if (self.detailModel != nil) {
                    button.enabled = NO;
                    NSDictionary *dic = self.detailModel.headpic_content[i];
                    label.text = dic[@"C_A47700_C_NAME"];
                    label.hidden = NO;
                } else {
                    if (self.a46000Forms.count > 0) {
                        NSMutableDictionary *dic = self.a46000NameForms[i];
                        label.text = dic[@"C_A47700_C_NAME"];
                        label.hidden = NO;
                    } else {
                        if (i==0) {
                            if (C_A41500_C_ID.length > 0) {
                                label.hidden = NO;
                                label.text = C_A41500_C_NAME;
                            }
                        }
                    }
                }
                
                [labelViewArray addObject:label];
                
                
                UIImageView *imageView;
//                if (self.headImageArray.count > 1) {
                    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(label.frame), CGRectGetMaxY(label.frame) + 10, 50, 60)];
//                } else {
//                    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(marginX + ((i % 4) * (50 + marginX)), (i / 4) * 70 + 10, 50, 60)];
//                }
                imageView.layer.cornerRadius = 5.f;
                imageView.layer.masksToBounds = YES;
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.headImageArray[i]]];
                [imageBGView addSubview:imageView];
                imageView.userInteractionEnabled = YES;
                imageView.tag = 500 + i;
                UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
                [imageView addGestureRecognizer:tapGR];
                [imageViewArray addObject:imageView];
                
                UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(button.frame), CGRectGetMaxY(button.frame), 50, 60)];
                chooseView.backgroundColor = [UIColor whiteColor];
                chooseView.layer.cornerRadius = 5.f;
                chooseView.layer.borderColor = [UIColor colorWithHexString:@"#efeff4"].CGColor;
                chooseView.layer.borderWidth = 1;
                chooseView.hidden = YES;
                chooseView.tag = 1000 + i;
                
//                if (self.headImageArray.count > 1) {
                    [imageBGView addSubview:chooseView];
//                }
                for (int j = 0; j < 3; j++) {
                    UIButton *typeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, j * 20, chooseView.frame.size.width, 20)];
                    [typeButton setTitleNormal:@[@"决策人",@"随访人",@"带单人"][j]];
                    [typeButton setTitleColor:[UIColor blackColor]];
                    typeButton.tag = 10000 + j;
                    [typeButton addTarget:self action:@selector(typeButtonAction:)];
                    typeButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
                    [chooseView addSubview:typeButton];
                }
                [chooseViewArray addObject:chooseView];
                
            }
            self.imageViewArray = [NSMutableArray arrayWithArray:imageViewArray];
            self.buttonViewArray = [NSMutableArray arrayWithArray:buttonViewArray];
            self.labelViewArray = [NSMutableArray arrayWithArray:labelViewArray];
            self.typeViewArray = [NSMutableArray arrayWithArray:chooseViewArray];
            if (self.a46000Forms.count <= 0) {
                self.a46000Forms = [NSMutableArray arrayWithArray:a46000Forms];
                self.a46000NameForms = [NSMutableArray arrayWithArray:a46000NameForms];
            }
            height = self.headImageArray.count % 4 == 0 ? (self.headImageArray.count / 4) * 60  + 40: ((self.headImageArray.count / 4) + 1) * 60 + 40;
//            if (self.headImageArray.count > 1) {
                height += self.headImageArray.count % 4 == 0 ? (self.headImageArray.count / 4) * 20 : ((self.headImageArray.count / 4) + 1) * 20;
                height += self.headImageArray.count % 4 == 0 ? (self.headImageArray.count / 4) * 20 : ((self.headImageArray.count / 4) + 1) * 20;
//            }
            //是否预约
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 90) / 2, 10, 90, 60)];
            [button setTitleNormal:@"预约客户"];
            [button setImage:@"流量处理-预约"];
            [button initTopImageBottomTitle];
            [button setTitleColor:[UIColor blackColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button addTarget:self action:@selector(operationBeanAction:)];
            [buttonView addSubview:button];
            
            buttonView.frame = CGRectMake(0, height, KScreenWidth, 60);
        }
        
        if (self.detailModel.C_HEADPIC.length > 0) {
            
            UIButton *typeButton = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 50) / 2, 10, 50, 20)];
            if (self.a46000Forms.count > 0) {
                [a46000Forms addObjectsFromArray:self.a46000Forms];
                [a46000NameForms addObjectsFromArray:self.a46000NameForms];
                NSMutableDictionary *dic = self.a46000NameForms[0];
                [typeButton setTitleNormal:[NSString stringWithFormat:@"%@v",dic[@"C_JSTYPE_DD_NAME"]]];
            } else {
               
                [typeButton setTitleNormal:@"决策人v"];
                if (![self.clueName isEqualToString:@"已处理流量详情"]) {
                    [a46000Forms addObject:[@{@"C_ID" : self.detailModel.C_ID,@"C_JSTYPE_DD_ID" : @"A46000_C_JSTYPE_0000",@"C_A47700_C_ID":@""} mutableCopy]];
                    [a46000NameForms addObject:[@{@"C_ID" : self.detailModel.C_ID,@"C_JSTYPE_DD_NAME" : @"决策人",@"C_A47700_C_NAME":@""} mutableCopy]];
                }
                
            }
            if (self.detailModel != nil) {
                if (self.detailModel.headpic_content.count > 0) {
                    typeButton.enabled = NO;
                    NSDictionary *dic = self.detailModel.headpic_content[0];
                    [typeButton setTitleNormal:[NSString stringWithFormat:@"%@v",dic[@"C_JSTYPE_DD_NAME"]]];
                }
            }
            [typeButton setTitleColor:[UIColor blackColor]];
            typeButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:10];
            typeButton.tag = 10;
            [typeButton addTarget:self action:@selector(chooseJSTypeAction:)];
            //                if (self.headImageArray.count > 1) {
            [imageBGView addSubview:typeButton];
            //                }
            [buttonViewArray addObject:typeButton];
            
            
            
            
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(typeButton.frame), CGRectGetMaxY(typeButton.frame), 50, 20)];
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.hidden = YES;
            label.font = [UIFont systemFontOfSize:10.f];
            label.tag = 100;
            //                if (self.headImageArray.count > 1) {
            [imageBGView addSubview:label];
            //                }
            if (self.a46000Forms.count > 0) {
                NSMutableDictionary *dic = self.a46000NameForms[0];
                label.text = dic[@"C_A47700_C_NAME"];
                label.hidden = NO;
            } else {
                if (self.detailModel.C_A41500_C_ID.length > 0) {
                    label.hidden = NO;
                    label.text = self.detailModel.C_A41500_C_NAME;
                }
            }
            if (self.detailModel != nil) {
                if (self.detailModel.headpic_content.count > 0) {
                    typeButton.enabled = NO;
                    NSDictionary *dic = self.detailModel.headpic_content[0];
                    label.text = dic[@"C_A47700_C_NAME"];
                    label.hidden = NO;
                }
            }
            
            [labelViewArray addObject:label];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((KScreenWidth - 50) / 2, CGRectGetMaxY(label.frame), 50, 60)];
            imageView.layer.cornerRadius = 5.f;
            imageView.layer.masksToBounds = YES;
            [imageView sd_setImageWithURL:[NSURL URLWithString:self.detailModel.C_HEADPIC]];
            [imageBGView addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            imageView.tag = 500;
            UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigImage:)];
            [imageView addGestureRecognizer:tapGR];
//            [self.imageViewArray addObject:imageView];
            [imageViewArray addObject:imageView];
            
           
            
            
            self.imageViewArray = [NSMutableArray arrayWithArray:imageViewArray];
            self.buttonViewArray = [NSMutableArray arrayWithArray:buttonViewArray];
            self.labelViewArray = [NSMutableArray arrayWithArray:labelViewArray];
            if (self.a46000Forms.count <= 0) {
                self.a46000Forms = [NSMutableArray arrayWithArray:a46000Forms];
                self.a46000NameForms = [NSMutableArray arrayWithArray:a46000NameForms];
            }
            
            height = 110 ;
            
            UIImageView *stateImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) - 10, CGRectGetMinY(imageView.frame), 10, 10)];
            if (self.detailModel.LEVEL.length > 0) {
                [imageBGView addSubview:stateImageView];
                if ([self.detailModel.LEVEL isEqualToString:@"HEART"]) {
                    stateImageView.image = [UIImage imageNamed:@"flow_love.png"];
                } else if ([self.detailModel.LEVEL isEqualToString:@"VIP"]) {
                    stateImageView.image = [UIImage imageNamed:@"flow_vip.png"];
                }
            }
            if ([self.detailModel.LEVEL isEqualToString:@"VIP"]) {
//                CGFloat margin = (KScreenWidth - (90 * 2)) / 3;
                
                CGFloat margin = (KScreenWidth - (60 * 2)) / 2;
                for (int i = 0; i < 2; i++) {
//                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(margin + (i * (90 + margin)), 10, 90, 60)];
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(margin + (i * 60), 0, 60, 60)];
                    [button setTitleNormal:@[@"预约客户",@"纠正识别"][i]];
                    [button setImage:@[@"流量处理-预约",@"流量处理-纠正识别"][i]];
                    [button setTitleColor:[UIColor blackColor]];
                    [button initTopImageBottomTitle];
                    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
                    [button addTarget:self action:@selector(operationBeanAction:)];
                    [buttonView addSubview:button];
                }
            } else {
//                CGFloat margin = (KScreenWidth - (90 * 3)) / 4;
                CGFloat margin = (KScreenWidth - (60 * 3)) / 2;
                for (int i = 0; i < 3; i++) {
//                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(margin + (i * (90 + margin)), 0, 90, 60)];
                    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(margin + (i * 60), 0, 60, 60)];
                    [button setTitleNormal:@[@"员工",@"无效",@"预约客户"][i]];
                    [button setImage:@[@"流量处理-员工",@"流量处理-无效",@"流量处理-预约"][i]];
                    [button initTopImageBottomTitle];
                    
                    [button setTitleColor:[UIColor blackColor]];
//                    button.backgroundColor = kBackgroundColor;
                    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
                    [button addTarget:self action:@selector(operationBeanAction:)];
                    [buttonView addSubview:button];
                }
            }
            
            UIView *chooseView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMinX(typeButton.frame), CGRectGetMaxY(typeButton.frame), 50, 60)];
            chooseView.backgroundColor = [UIColor whiteColor];
            chooseView.layer.cornerRadius = 5.f;
            chooseView.layer.borderColor = [UIColor colorWithHexString:@"#efeff4"].CGColor;
            chooseView.layer.borderWidth = 1;
            chooseView.hidden = YES;
            chooseView.tag = 1000;
            
            //                if (self.headImageArray.count > 1) {
            [imageBGView addSubview:chooseView];
            for (int j = 0; j < 3; j++) {
                UIButton *typeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, j * 20, chooseView.frame.size.width, 20)];
                [typeButton setTitleNormal:@[@"决策人",@"随访人",@"带单人"][j]];
                [typeButton setTitleColor:[UIColor blackColor]];
                typeButton.tag = 10000 + j;
                [typeButton addTarget:self action:@selector(typeButtonAction:)];
                typeButton.titleLabel.font = [UIFont systemFontOfSize:10.f];
                [chooseView addSubview:typeButton];
            }
            
            [chooseViewArray addObject:chooseView];
            self.typeViewArray = [NSMutableArray arrayWithArray:chooseViewArray];
            buttonView.frame = CGRectMake(0, height, KScreenWidth, 60);
        }
        
        imageBGView.frame = CGRectMake(0, 0, KScreenWidth, height);
        [bgView addSubview:imageBGView];
        if ([self.vcName isEqualToString:@"详情"]) {
            buttonView.frame = CGRectMake(0, height, KScreenWidth, 0);
        } else {
            [bgView addSubview:buttonView];
        }
        
        
            
            
        
        
    } else if (section == 1) {
        
        [bgView addSubview:self.clearButton];
    }
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(buttonView.frame), KScreenWidth - 40, 20)];
    label.text = @[@"流量信息", @"客户信息",@"接待信息"][section];
    label.textColor = [UIColor lightGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    
    bgView.frame = CGRectMake(0, 0, KScreenWidth, label.frame.origin.y + label.frame.size.height);
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 选择人员类型
- (void)chooseJSTypeAction:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    if (sender.tag != self.preJSButton.tag) {
        if (self.preJSButton != nil) {
            self.preJSButton.selected = NO;
            UIView *preChooseView = self.typeViewArray[self.preJSButton.tag - 10];
            preChooseView.hidden = YES;
        }
    }
    
    
    UIView *chooseView = self.typeViewArray[sender.tag - 10];
    if (sender.isSelected == YES) {
        chooseView.hidden = NO;
    } else {
        chooseView.hidden = YES;
    }
    
    self.preJSButton = sender;
}

- (void)typeButtonAction:(UIButton *)sender {
    [self.preJSButton setTitleNormal:[NSString stringWithFormat:@"%@v",sender.titleLabel.text]];
    self.preJSButton.selected = NO;
    UIView *preChooseView = self.typeViewArray[self.preJSButton.tag - 10];
    preChooseView.hidden = YES;
    NSMutableDictionary *dic = self.a46000Forms[self.preJSButton.tag - 10];
    NSMutableDictionary *nameDic = self.a46000NameForms[self.preJSButton.tag - 10];
    if (sender.tag == 10000) {
        dic[@"C_JSTYPE_DD_ID"] = @"A46000_C_JSTYPE_0000";
        nameDic[@"C_JSTYPE_DD_NAME"] = @"决策人";
        dic[@"C_A47700_C_ID"] = @"";
        UILabel *label = self.labelViewArray[self.preJSButton.tag - 10];
        label.hidden = YES;
        label.text = @"";
    } else if (sender.tag == 10001) {
        dic[@"C_JSTYPE_DD_ID"] = @"A46000_C_JSTYPE_0001";
        nameDic[@"C_JSTYPE_DD_NAME"] = @"随访人";
        dic[@"C_A47700_C_ID"] = @"";
        UILabel *label = self.labelViewArray[self.preJSButton.tag - 10];
        label.hidden = YES;
        label.text = @"";
    } else {
        DBSelf(weakSelf);
        CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
        vc.type = BrokerCenterMembers;
        vc.typeName = @"名单经纪人";
        if ([NewUserSession instance].configData.IS_JSRSFKFXZ.boolValue == YES) {
            vc.SEARCH_TYPE = @"1";
        }
        vc.backSelectFansBlock = ^(CGCCustomModel *model) {
            dic[@"C_JSTYPE_DD_ID"] = @"A46000_C_JSTYPE_0002";
            nameDic[@"C_JSTYPE_DD_NAME"] = @"带单人";
            dic[@"C_A47700_C_ID"] = model.C_ID;
            nameDic[@"C_A47700_C_NAME"] = model.C_NAME;
            UILabel *label = weakSelf.labelViewArray[weakSelf.preJSButton.tag - 10];
            label.hidden = NO;
            label.text = model.C_NAME;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showBigImage:(UITapGestureRecognizer *)tapGR {
    UITapGestureRecognizer *tap = (UITapGestureRecognizer*)tapGR;
    
    UIImageView *views = (UIImageView*) tap.view;
    NSMutableArray *arr = [NSMutableArray array];
    for (UIImageView *imageView in self.imageViewArray) {
        KSPhotoItem * item=[KSPhotoItem itemWithSourceView:imageView image:imageView.image];
        if (self.X_REMARK.length > 0) {
            //X_A41300_REMARK
            item.textStr = self.X_REMARK;
        }
        [arr addObject:item];
        
    }
    KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:arr selectedIndex:views.tag - 500];
    
    
    [browser showFromViewController:self];
}

#pragma mark - UITextFieldDelegate
- (void)textChangeBegin:(UITextField *)sender {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 365, 0);
}

- (void)textChangeEnd:(UITextField *)sender {
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    MJKFlowProcessModel *model = self.customerInfoArray[sender.tag];
    if ([model.title isEqualToString:@"客户姓名"]) {
        if (sender.text.length > 0) {
            if ([self.commitType isEqualToString:@"新增客户"]) {
                [self.comoleteButton setTitleNormal:@"自然到店留档"];
            }
        } else {
            if ([self.commitType isEqualToString:@"未留档"]) {
                [self.comoleteButton setTitleNormal:@"自然到店未留档"];
            }
        }
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length == 11) {
        return NO;
    }
    return YES;
}

- (void)toCusromerDetail {
    if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
    PotentailCustomerListDetailModel *model = [[PotentailCustomerListDetailModel alloc]init];
    model.C_ID = self.detailModel.C_A41500_C_ID;
    model.C_A41500_C_ID = self.detailModel.C_A41500_C_ID;
    vc.mainModel = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 选择客户
- (void)selectCustomer:(UIButton *)sender {
    DBSelf(weakSelf);
//    if ([self.detailModel.LEVEL isEqualToString:@"VIP"]) {
//        CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
//        PotentailCustomerListDetailModel *model = [[PotentailCustomerListDetailModel alloc]init];
//        model.C_ID = self.detailModel.C_A41500_C_ID;
//        model.C_A41500_C_ID = self.detailModel.C_A41500_C_ID;
//        vc.mainModel = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    } else {
    
    if ([self.vcName isEqualToString:@"人脸"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP010_0016"] &&
            ![[NewUserSession instance].appcode containsObject:@"APP010_0017"] &&
            ![[NewUserSession instance].appcode containsObject:@"APP010_0018"]) {
            [JRToast showWithText:@"暂无权限选择客户"];
            return;
        }
    }
    if ([self.vcName isEqualToString:@"到店"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP002_0015"] &&
            ![[NewUserSession instance].appcode containsObject:@"APP002_0016"] &&
            ![[NewUserSession instance].appcode containsObject:@"APP002_0017"]) {
            [JRToast showWithText:@"暂无权限选择客户"];
            return;
        }
    }
    
    
        MJKFlowProcessModel *processModel = self.customerInfoArray[sender.tag];
    MJKCustomerChooseViewController *customListVC = [[MJKCustomerChooseViewController alloc]init];
    customListVC.rootVC = self;
        customListVC.chooseCustomerBlock = ^(CGCCustomModel *model) {
            
            weakSelf.isYuyue = @"no";
            weakSelf.commitType = @"关联现有客户";
            [weakSelf.comoleteButton setTitleNormal:@"未预约客户到店"];
            
//            if (processModel.C_ID.length <= 0) {
                if ([self.clueName isEqualToString:@"新增"] || [self.typeName isEqualToString:@"有效流量"]) {
                    
//                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
                    NSArray *arr = [NSArray arrayWithArray:weakSelf.customerInfoArray];
                    
                    NSMutableArray *numArr = [NSMutableArray array];
                    for (int i = 0; i < arr.count; i++) {
                        MJKFlowProcessModel *customerModel = arr[i];
//                        if ([customerModel.title isEqualToString:@"客户姓名"]) {
//                                if (customerModel.C_ID.length <= 0) {
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                }
                            if ([customerModel.title isEqualToString:@"手机号"] ||
                                [customerModel.title isEqualToString:@"微信号"] ||
                                [customerModel.title isEqualToString:@"意向车型"] ||
                                [customerModel.title isEqualToString:@"跟进等级"] ||
                                [customerModel.title isEqualToString:@"省市"]) {
                                [numArr addObject:@(i)];
                            }
//                        }
                    }
                    NSMutableArray *tempArray =self.customerInfoArray;
                    [numArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [tempArray removeObjectAtIndex:2];
                    }];
                } else {
//                    [weakSelf.customerInfoArray removeObjectAtIndex:1];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:1];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:1];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:1];
//                    [weakSelf.customerInfoArray removeObjectAtIndex:1];
                    NSArray *arr = [NSArray arrayWithArray:weakSelf.customerInfoArray];
                    
                    NSMutableArray *numArr = [NSMutableArray array];
                    for (int i = 0; i < arr.count; i++) {
                        MJKFlowProcessModel *customerModel = arr[i];
//                        if ([customerModel.title isEqualToString:@"客户姓名"]) {
//                                if (customerModel.C_ID.length <= 0) {
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                    [weakSelf.customerInfoArray removeObjectAtIndex:2];
//                                }
                            if ([customerModel.title isEqualToString:@"手机号"] ||
                                [customerModel.title isEqualToString:@"微信号"] ||
                                [customerModel.title isEqualToString:@"意向车型"] ||
                                [customerModel.title isEqualToString:@"跟进等级"] ||
                                [customerModel.title isEqualToString:@"省市"]) {
                                [numArr addObject:@(i)];
                            }
//                        }
                    }
                    NSMutableArray *tempArray =self.customerInfoArray;
                    [numArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [tempArray removeObjectAtIndex:1];
                    }];
                }
//            }
            processModel.content = model.C_NAME;
            processModel.C_ID = model.C_ID;
            self.C_YX_A70600_C_ID = model.C_YX_A70600_C_ID;
            self.C_YX_A70600_C_NAME = model.C_YX_A70600_C_NAME;
            self.C_YX_A49600_C_ID = model.C_YX_A49600_C_ID;
            self.C_YX_A49600_C_NAME = model.C_YX_A49600_C_NAME;
            MJKFlowProcessModel *cluesProcessModel = self.flowInfoArray[6];
            cluesProcessModel.content = model.C_CLUESOURCE_DD_NAME;
            cluesProcessModel.C_ID = model.C_CLUESOURCE_DD_ID;
            
            MJKFlowProcessModel *A41200ProcessModel = self.flowInfoArray[7];
            A41200ProcessModel.content = model.C_A41200_C_NAME;
            A41200ProcessModel.C_ID = model.C_A41200_C_ID;
            
            
//            NSInteger index = [self.customerInfoArray indexOfObject:@"客户姓名"];
//            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView reloadData];
            //        for (int i = 0; i < weakSelf.customerInfoArray.count; i++) {
            //            MJKFlowProcessModel *flowProcessModel = weakSelf.customerInfoArray[i];
            //            if ([flowProcessModel.title isEqualToString:@"手机号"]) {
            //                flowProcessModel.C_ID = model.C_PHONE;
            //                flowProcessModel.content = model.C_PHONE;
            //                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //            }
            //            if ([flowProcessModel.title isEqualToString:@"微信号"]) {
            //                flowProcessModel.C_ID = model.C_WECHAT;
            //                flowProcessModel.content = model.C_WECHAT;
            //                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //            }
            //            if ([flowProcessModel.title isEqualToString:@"跟进等级"]) {
            //                flowProcessModel.C_ID = model.C_LEVEL_DD_ID;
            //                flowProcessModel.content = model.C_LEVEL_DD_NAME;
            //                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            //            }
            //        }
        };
        [self.navigationController pushViewController:customListVC animated:YES];
//    }
    
}

#pragma mark 增加减少人数
- (void)addPeople:(UIButton *)sender {
    for (int i = 0; i < self.flowInfoArray.count; i++) {
        MJKFlowProcessModel *flowInfoModel = self.flowInfoArray[i];
        if ([flowInfoModel.title isEqualToString:@"进店人数"]) {
            flowInfoModel.content = [NSString stringWithFormat:@"%d",flowInfoModel.content.intValue + 1];
            flowInfoModel.C_ID = [NSString stringWithFormat:@"%d",flowInfoModel.C_ID.intValue + 1];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag - 1000 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)subPeople:(UIButton *)sender {
    for (int i = 0; i < self.flowInfoArray.count; i++) {
        MJKFlowProcessModel *flowInfoModel = self.flowInfoArray[i];
        
        if ([flowInfoModel.title isEqualToString:@"进店人数"]) {
            if ([flowInfoModel.content isEqualToString:@"1"]) {
            return;
        }
            flowInfoModel.content = [NSString stringWithFormat:@"%d",flowInfoModel.content.intValue - 1];
            flowInfoModel.C_ID = [NSString stringWithFormat:@"%d",flowInfoModel.content.intValue - 1];
        }
    }
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag - 2000 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)changeText:(UITextField *)sender {
    if (sender.tag - 100 >= 0 ) {
        MJKFlowProcessModel *flowInfoModel = self.flowInfoArray[sender.tag - 100];
        if ([flowInfoModel.title isEqualToString:@"随行人员"]) {
            flowInfoModel.content = sender.text;
            flowInfoModel.C_ID = sender.text;
        }
        
    } else if (sender.tag - 3000 >= 0) {
        MJKFlowProcessModel *flowInfoModel1 = self.flowInfoArray[sender.tag - 3000];
        if ([flowInfoModel1.title isEqualToString:@"进店人数"]) {
            flowInfoModel1.content = sender.text;
            flowInfoModel1.C_ID = sender.text;
        }
    } else {
        MJKFlowProcessModel *customerInfoModel = self.customerInfoArray[sender.tag];
        if ([customerInfoModel.title isEqualToString:@"客户姓名"] || [customerInfoModel.title isEqualToString:@"手机号"] || [customerInfoModel.title isEqualToString:@"微信号"]) {
            if ([customerInfoModel.title isEqualToString:@"客户姓名"]) {
                if (sender.text.length > 0) {
                    self.commitType = @"新增客户";
                } else {
                    self.commitType = @"未留档";
                }
            }
            customerInfoModel.content = sender.text;
            customerInfoModel.C_ID = sender.text;
        }
    }
    
    
   
}

- (void)clearButtonAction {
    self.detailModel.LEVEL = @"";
    self.customerInfoArray = nil;
    [self.comoleteButton setTitleNormal:@"自然到店未留档"];
    self.commitType = @"";
    for (MJKFlowProcessModel *customerModel in self.customerInfoArray) {
        if ([customerModel.title isEqualToString:@"性别"]) {
            customerModel.content = self.detailModel.C_SEX;
            if ([self.detailModel.C_SEX isEqualToString:@"男"]) {
                customerModel.C_ID = @"A41300_C_SEX_0000";
            } else if ([self.detailModel.C_SEX isEqualToString:@"女"]) {
                customerModel.C_ID = @"A41300_C_SEX_0001";
            }
        } else if ([customerModel.title isEqualToString:@"年龄"]) {
            customerModel.content = self.detailModel.C_AGE;
            customerModel.C_ID = self.detailModel.C_AGE;
        }
    }
    [self.tableView reloadData];
}

#pragma mark 流量操作按钮
- (void)operationBeanAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"无效"]) {
        if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a460:plwx"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        [self HTTPUpdataFlowMeterData:@"0"];
    } else if ([sender.titleLabel.text isEqualToString:@"员工"]) {
        if ([self.superVC isKindOfClass:[MJKFlowMeterViewController class]]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a460:plyg"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        [self HTTPUpdataFlowMeterData:@"1"];
    } else if ([sender.titleLabel.text isEqualToString:@"预约客户"]) {
        MJKShopArriveViewController *arrVC = [[MJKShopArriveViewController alloc]initWithNibName:@"MJKShopArriveViewController" bundle:nil];
        DBSelf(weakSelf);
        arrVC.backCustomerInfoBlock = ^(MJKShopArriveContentModel *model) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            weakSelf.yuyueID = model.C_ID;
            [weakSelf.comoleteButton setTitleNormal:@"预约客户到店"];
            weakSelf.commitType = @"关联预约客户";
            NSArray *arr = [NSArray arrayWithArray:weakSelf.customerInfoArray];
            for (MJKFlowProcessModel *customerModel in arr) {
                if ([customerModel.title isEqualToString:@"客户姓名"]) {
                    if (customerModel.C_ID.length <= 0) {
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                    }
                    customerModel.C_ID = model.C_ID;
                    customerModel.content = model.C_A41500_C_NAME;
                }
            }
            
            [weakSelf.tableView reloadData];
//            [weakSelf HTTPInsertFlowDatas:[NewUserSession instance].user.u051Id complete:^(id data) {
//                [weakSelf HTTPCustomConnect:[NSString stringWithFormat:@"A41400-%@",self.random] andType:@"6" andC_A41500_C_ID:C_ID];
//            }];
            
        };
        [self.navigationController pushViewController:arrVC animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"纠正识别"]) {
        self.clearButton.hidden = NO;
        self.detailModel.LEVEL = @"";
        self.customerInfoArray = nil;
        self.commitType = @"";
        [self.comoleteButton setTitleNormal:@"自然到店未留档"];
        for (MJKFlowProcessModel *customerModel in self.customerInfoArray) {
            if ([customerModel.title isEqualToString:@"性别"]) {
                customerModel.content = self.detailModel.C_SEX;
                if ([self.detailModel.C_SEX isEqualToString:@"男"]) {
                    customerModel.C_ID = @"A41300_C_SEX_0000";
                } else if ([self.detailModel.C_SEX isEqualToString:@"女"]) {
                    customerModel.C_ID = @"A41300_C_SEX_0001";
                }
            } else if ([customerModel.title isEqualToString:@"年龄"]) {
                customerModel.content = self.detailModel.C_AGE;
                customerModel.C_ID = self.detailModel.C_AGE;
            }
        }
        [self.tableView reloadData];
    }
}

#pragma mark 完成
- (void)completeButtonAction:(UIButton *)sender {
    if ([self.vcName isEqualToString:@"人脸"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP010_0011"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    }
    if ([self.vcName isEqualToString:@"到店"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP002_0013"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    }
    self.paramArr = [NSMutableArray array];
    DBSelf(weakSelf);
    
    
    
    if ([self.commitType isEqualToString:@"关联预约客户"]) {
        if ([self.vcName isEqualToString:@"到店"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a414:yydd"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        MJKFlowProcessModel *flowInfoModelName;
        MJKFlowProcessModel *flowInfoModelName1;
        if (self.type == MJKFlowProcessOneImage) {
            flowInfoModelName = weakSelf.flowInfoArray[6];
            flowInfoModelName1 = weakSelf.flowInfoArray[7];
        } else {
            flowInfoModelName = weakSelf.flowInfoArray[4];
            flowInfoModelName1 = weakSelf.flowInfoArray[5];
        }
//        if ([self.btArray containsObject:@"A47500_C_BTX_0008"]) {
            if (flowInfoModelName.C_ID.length <= 0) {
                [JRToast showWithText:@"请选择来源渠道"];
                return;
            }
//        }
//        if ([self.btArray containsObject:@"A47500_C_BTX_0009"]) {
            if (flowInfoModelName1.C_ID.length <= 0) {
                [JRToast showWithText:@"请选择渠道细分"];
                return;
            }
//        }
//        if (![self.commitType isEqualToString:@"关联现有客户"] && ![self.commitType isEqualToString:@"关联预约客户"]) {
//            if (self.C_YX_A49600_C_ID.length <= 0) {
//                [JRToast showWithText:@"请选择意向车型"];
//                return;
//            }
//        }
        
       
        
        NSString *nameStr = @"";
        for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
            if ([customerModel.title isEqualToString:@"客户姓名"]) {
                nameStr = [NSString stringWithFormat:@"预约客户%@到店,请再次确认",customerModel.content];
                [weakSelf.paramArr addObject:customerModel.content];
                [weakSelf.paramArr addObject:@""];
                [weakSelf.paramArr addObject:[NewUserSession instance].C_ABBREVATION];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.nickName];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.phonenumber];
            }
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:nameStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [KVNProgress show];
            if ([weakSelf.typeName isEqualToString:@"有效流量"]) {
                
                [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"6" andC_A41500_C_ID:weakSelf.yuyueID andRemark:nil andRemarkID:nil andSuccessBlock:^{
                    [KVNProgress dismiss];
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0000"]) {
                        [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.yuyueID andC_ID:weakSelf.model.C_ID andC_TYPE_DD_ID:@"A47500_C_LLTSDW_0000"];
                    } else {
                        [KUSERDEFAULT setValue:@"yes" forKey:@"isBack"];
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            } else {
                [weakSelf HTTPInsertFlowDatasWithComplete:^(id data) {
                    
                    [weakSelf HTTPCustomConnect:data[@"data"] andType:@"6" andC_A41500_C_ID:weakSelf.yuyueID andRemark:nil andRemarkID:nil andSuccessBlock:^{
                        [KVNProgress dismiss];
                        if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0000"]) {
                            [weakSelf pushInfoWithC_A41500_C_ID:weakSelf.yuyueID andC_ID:weakSelf.model.C_ID andC_TYPE_DD_ID:@"A47500_C_LLTSDW_0000"];
                        } else {
                            [KUSERDEFAULT setValue:@"yes" forKey:@"isBack"];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }
                    }];
                    
                }];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertC addAction:cancelAction];
        [alertC addAction:trueAction];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        
        
    } else if ([weakSelf.commitType isEqualToString:@"关联现有客户"]) {
        if ([self.vcName isEqualToString:@"到店"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a414:wyydd"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        MJKFlowProcessModel *flowInfoModelName;
        MJKFlowProcessModel *flowInfoModelName1;
        if (self.type == MJKFlowProcessOneImage) {
            flowInfoModelName = weakSelf.flowInfoArray[6];
            flowInfoModelName1 = weakSelf.flowInfoArray[7];
        } else {
            flowInfoModelName = weakSelf.flowInfoArray[4];
            flowInfoModelName1 = weakSelf.flowInfoArray[5];
        }
//        if ([self.btArray containsObject:@"A47500_C_BTX_0008"]) {
            if (flowInfoModelName.C_ID.length <= 0) {
                [JRToast showWithText:@"请选择来源渠道"];
                return;
            }
//        }
//        if ([self.btArray containsObject:@"A47500_C_BTX_0009"]) {
            if (flowInfoModelName1.C_ID.length <= 0) {
                [JRToast showWithText:@"请选择渠道细分"];
                return;
            }
//        }
//        if (self.C_YX_A49600_C_ID.length <= 0) {
//            [JRToast showWithText:@"请选择意向车型"];
//            return;
//        }
        NSString *nameStr = @"";
        for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
            if ([customerModel.title isEqualToString:@"客户姓名"]) {
                nameStr = [NSString stringWithFormat:@"客户%@到店,请再次确认",customerModel.content];
                [weakSelf.paramArr addObject:customerModel.content];
                [weakSelf.paramArr addObject:@""];
                [weakSelf.paramArr addObject:[NewUserSession instance].C_ABBREVATION];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.nickName];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.phonenumber];
            }
        }
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:nameStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [KVNProgress show];
            if ([self.typeName isEqualToString:@"有效流量"]) {
                for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                    if ([customerModel.title isEqualToString:@"客户姓名"]) {
                        [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"2" andC_A41500_C_ID:customerModel.C_ID andRemark:nil andRemarkID:nil andSuccessBlock:^{
                            [KVNProgress dismiss];
                            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0000"]) {
                                [weakSelf pushInfoWithC_A41500_C_ID:customerModel.C_ID andC_ID:weakSelf.model.C_ID andC_TYPE_DD_ID:@"A47500_C_LLTSDW_0000"];
                            } else {
                                [KUSERDEFAULT setValue:@"yes" forKey:@"isBack"];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            }
                            
                        }];
                    }
                }
            } else {
                [weakSelf HTTPInsertFlowDatasWithComplete:^(id data) {
                    for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                        if ([customerModel.title isEqualToString:@"客户姓名"]) {
                            [weakSelf HTTPCustomConnect:data[@"data"] andType:@"2" andC_A41500_C_ID:customerModel.C_ID andRemark:nil andRemarkID:nil andSuccessBlock:^{
                                [KVNProgress dismiss];
                                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0000"]) {
                                    [weakSelf pushInfoWithC_A41500_C_ID:customerModel.C_ID andC_ID:weakSelf.flowID andC_TYPE_DD_ID:@"A47500_C_LLTSDW_0000"];
                                } else {
                                    [KUSERDEFAULT setValue:@"yes" forKey:@"isBack"];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                                
                            }];
                        }
                    }
                }];
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertC addAction:cancelAction];
        [alertC addAction:trueAction];
        
        [self presentViewController:alertC animated:YES completion:nil];
        
        
    } else if ([self.commitType isEqualToString:@"新增客户"]) {
        if ([self.vcName isEqualToString:@"到店"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a414:ld"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        [self checkCustomerCountWithCompleteBlock:^{
            if ([weakSelf.clueName isEqualToString:@"新增"]) {
                MJKFlowProcessModel *customerModelName = weakSelf.customerInfoArray[1];
                MJKFlowProcessModel *customerModel = weakSelf.customerInfoArray[2];
                MJKFlowProcessModel *customerModel1 = weakSelf.customerInfoArray[3];
                MJKFlowProcessModel *customerModel2 = weakSelf.customerInfoArray[5];
                
                [weakSelf.paramArr addObject:customerModelName.content];
                [weakSelf.paramArr addObject:@""];
                [weakSelf.paramArr addObject:[NewUserSession instance].C_ABBREVATION];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.nickName];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.phonenumber];
                if (customerModelName.C_ID.length > 0) {
                    if (customerModel.C_ID.length <= 0 && customerModel1.C_ID.length <= 0) {
                        [JRToast showWithText:@"手机号或微信号必填一项"];
                        return;
                    }
                    if (customerModel.C_ID.length > 0 ) {
                        if (customerModel.C_ID.length != 11 ) {
                            [JRToast showWithText:@"手机号码不正确"];
                            return;
                        }
                    }
                    if (customerModel2.C_ID.length <= 0) {
                        [JRToast showWithText:@"请选择跟进等级"];
                        return;
                    }
                }
            } else {
                
                MJKFlowProcessModel *customerModel0;
                MJKFlowProcessModel *customerModelName;
                MJKFlowProcessModel *customerModel;
                MJKFlowProcessModel *customerModel1;
                MJKFlowProcessModel *customerModel2;
                MJKFlowProcessModel *customerModel3;
                if (self.type == MJKFlowProcessOneImage) {
                    customerModel0 = weakSelf.customerInfoArray[0];
                    customerModelName = weakSelf.customerInfoArray[1];
                    customerModel = weakSelf.customerInfoArray[2];
                    customerModel1 = weakSelf.customerInfoArray[3];
                    customerModel2 = weakSelf.customerInfoArray[4];
                        customerModel3 = weakSelf.customerInfoArray[5];
                    
                } else {
                    customerModelName = weakSelf.customerInfoArray[0];
                    customerModel = weakSelf.customerInfoArray[1];
                    customerModel1 = weakSelf.customerInfoArray[2];
                    customerModel2 = weakSelf.customerInfoArray[3];
                        customerModel2 = weakSelf.customerInfoArray[4];
                        
                }
                
                @try {
                    [weakSelf.paramArr addObject:customerModelName.content];
                } @catch (NSException *exception) {
                } @finally {
                }
                
                [weakSelf.paramArr addObject:@""];
                [weakSelf.paramArr addObject:[NewUserSession instance].C_ABBREVATION];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.nickName];
                [weakSelf.paramArr addObject:[NewUserSession instance].user.phonenumber];
                
                if (customerModelName.C_ID.length > 0) {
                    if (customerModel.C_ID.length <= 0 && customerModel1.C_ID.length <= 0) {
                        [JRToast showWithText:@"手机号或微信号必填一项"];
                        return;
                    }
                    if (customerModel.C_ID.length > 0 ) {
                       if (customerModel.C_ID.length != 11 ) {
                           [JRToast showWithText:@"手机号码不正确"];
                           return;
                       }
                    }
                        if (customerModel3.C_ID.length <= 0) {
                            [JRToast showWithText:@"请选择跟进等级"];
                            return;
                        }
                }
            }
            MJKFlowProcessModel *flowInfoModelName;
            MJKFlowProcessModel *flowInfoModelName1;
            if (self.type == MJKFlowProcessOneImage) {
                flowInfoModelName = weakSelf.flowInfoArray[6];
                flowInfoModelName1 = weakSelf.flowInfoArray[7];
            } else {
                flowInfoModelName = weakSelf.flowInfoArray[4];
                flowInfoModelName1 = weakSelf.flowInfoArray[5];
            }
//            if ([self.btArray containsObject:@"A47500_C_BTX_0008"]) {
                if (flowInfoModelName.C_ID.length <= 0) {
                    [JRToast showWithText:@"请选择来源渠道"];
                    return;
                }
//            }
//            if ([self.btArray containsObject:@"A47500_C_BTX_0009"]) {
                if (flowInfoModelName1.C_ID.length <= 0) {
                    [JRToast showWithText:@"请选择渠道细分"];
                    return;
                }
//            }
            if (self.C_YX_A49600_C_ID.length <= 0) {
                [JRToast showWithText:@"请选择意向车型"];
                return;
            }
            if ([self.btArray containsObject:@"A47500_C_BTX_0014"]) {
                if (self.C_PROVINCEandC_CITY.length <= 0) {
                    [JRToast showWithText:@"请选择省市"];
                    return;
                }
            }
            
            
            NSString *nameStr = @"";
            for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                if ([customerModel.title isEqualToString:@"客户姓名"]) {
                    nameStr = [NSString stringWithFormat:@"%@自然到店已留档,是否完善客户信息或跟进客户?",customerModel.content];
                }
            }
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:nameStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *followAction = [UIAlertAction actionWithTitle:@"跟进客户" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf HttpAddCustomerWithCompleteBlock:^(CustomerDetailInfoModel *model) {
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"]) {
                        [weakSelf pushInfoWithC_A41500_C_ID:model.C_A41500_C_ID andC_ID:weakSelf.flowID andC_TYPE_DD_ID:@"A47500_C_LLTSDW_0001"];
                    }
                    
                    if ([weakSelf.typeName isEqualToString:@"有效流量"]) {
                        [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"1" andC_A41500_C_ID:model.C_A41500_C_ID  andRemark:nil andRemarkID:nil andSuccessBlock:nil];
                        
                        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                        //                        vc.Type=CustomerFollowUpEdit;
                        for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                            if ([customerModel.title isEqualToString:@"客户姓名"]) {
                                model.C_NAME = customerModel.content;
                            } else if ([customerModel.title isEqualToString:@"跟进等级"]) {
                                model.C_LEVEL_DD_NAME = customerModel.content;
                                model.C_LEVEL_DD_ID = customerModel.C_ID;
                            }
                            
                        }
                        model.C_ID = model.C_A41500_C_ID;
                        vc.infoModel=model;
                        vc.Type = CustomerFollowUpAdd;
                        vc.completeBlock = ^{
                            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"])  {
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            } else {
                                if (weakSelf.superVC != nil) {
                                    [weakSelf.navigationController popToViewController:weakSelf.superVC animated:YES];
                                }
                            }
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } else {
                        [weakSelf HTTPInsertFlowDatasWithComplete:^(id data) {
                            [weakSelf HTTPCustomConnect:data[@"data"] andType:@"1" andC_A41500_C_ID:model.C_A41500_C_ID andRemark:nil andRemarkID:nil andSuccessBlock:nil];
                            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                            //                            vc.Type=CustomerFollowUpEdit;
                            for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                                if ([customerModel.title isEqualToString:@"客户姓名"]) {
                                    model.C_NAME = customerModel.content;
                                } else if ([customerModel.title isEqualToString:@"跟进等级"]) {
                                    model.C_LEVEL_DD_NAME = customerModel.content;
                                    model.C_LEVEL_DD_ID = customerModel.C_ID;
                                }
                                
                            }
                            model.C_ID = model.C_A41500_C_ID;
                            vc.infoModel=model;
                            vc.Type = CustomerFollowUpAdd;
                            vc.completeBlock = ^{
                                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"])  {
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                } else {
                                    if (weakSelf.superVC != nil) {
                                        [weakSelf.navigationController popToViewController:weakSelf.superVC animated:YES];
                                    }
                                }
                            };
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
                    }
                    
                }];
            }];
            UIAlertAction *perfectAction = [UIAlertAction actionWithTitle:@"完善客户信息" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakSelf HttpAddCustomerWithCompleteBlock:^(CustomerDetailInfoModel *model) {
                    if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"]) {
                        [weakSelf pushInfoWithC_A41500_C_ID:model.C_A41500_C_ID andC_ID:weakSelf.flowID andC_TYPE_DD_ID:@"A47500_C_LLTSDW_0001"];
                    }
                    if ([weakSelf.typeName isEqualToString:@"有效流量"]) {
                        [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"1" andC_A41500_C_ID:model.C_A41500_C_ID andRemark:nil andRemarkID:nil andSuccessBlock:nil];
                        
                        CustomerDetailInfoModel *cmodel = [[CustomerDetailInfoModel alloc]init];
                        
                        AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
                        vc.Type=customerTypeEdit;
                        cmodel.C_ID = cmodel.C_A41500_C_ID = model.C_A41500_C_ID;
                        for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                            if (customerModel.content.length > 0) {
                                if ([customerModel.title isEqualToString:@"客户姓名"]) {
                                    cmodel.C_NAME = customerModel.content;
                                }
                                if ([customerModel.title isEqualToString:@"手机号"]) {
                                    cmodel.C_PHONE = customerModel.content;
                                } else if ([customerModel.title isEqualToString:@"微信号"]) {
                                    cmodel.C_WECHAT = customerModel.content;
                                } else if ([customerModel.title isEqualToString:@"跟进等级"]){
                                    cmodel.C_LEVEL_DD_ID = customerModel.C_ID;
                                    cmodel.C_LEVEL_DD_NAME = customerModel.content;
                                } else if ([customerModel.title isEqualToString:@"介绍人"]){
                                    cmodel.C_A47700_C_ID = customerModel.C_ID;
                                    cmodel.C_A47700_C_NAME = customerModel.content;
                                }else if ([customerModel.title isEqualToString:@"性别"]) {
                                    if ([customerModel.content isEqualToString:@"男"]) {
                                        cmodel.C_SEX_DD_ID = @"A41300_C_SEX_0000";
                                    } else {
                                        cmodel.C_SEX_DD_ID = @"A41300_C_SEX_0001";
                                    }
                                    cmodel.C_SEX_DD_NAME = customerModel.content;
                                }  else if ([customerModel.title isEqualToString:@"意向车型"]) {
                                    cmodel.C_A49600_C_ID = self.C_YX_A49600_C_ID;
                                    cmodel.C_A70600_C_ID = self.C_YX_A70600_C_ID;
                                    vc.C_A70600_C_ID = self.C_YX_A70600_C_ID;
                                    vc.C_A49600_C_ID = self.C_YX_A49600_C_ID;
                                    cmodel.C_A49600_C_NAME = self.C_YX_A49600_C_NAME;
                                    cmodel.C_A70600_C_NAME = self.C_YX_A70600_C_NAME;
                               }  else if ([customerModel.title isEqualToString:@"省市"]) {
                                     cmodel.C_PROVINCE = self.C_PROVINCE;
                                     cmodel.C_CITY = self.C_CITY;
                                }
                            }
                        }
                        for (MJKFlowProcessModel *flowModel in weakSelf.flowInfoArray) {
                            if (flowModel.content.length > 0) {
                                if ([flowModel.title isEqualToString:@"来源渠道"]) {
                                    cmodel.C_CLUESOURCE_DD_ID = flowModel.C_ID;
                                    cmodel.C_CLUESOURCE_DD_NAME = flowModel.content;
                                }
                                if ([flowModel.title isEqualToString:@"渠道细分"]) {
                                    cmodel.C_A41200_C_ID = flowModel.C_ID;
                                    cmodel.C_A41200_C_NAME = flowModel.content;
                                }
                            }
                        }
                        vc.mainModel = cmodel;
                        vc.completeComitBlock = ^(NSString *C_ID, CustomerDetailInfoModel *newModel) {
                            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"])  {
                                //                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            } else {
                                if (weakSelf.superVC != nil) {
                                    [weakSelf.navigationController popToViewController:weakSelf.superVC animated:YES];
                                }
                            }
                            
                        };
                        [weakSelf.navigationController pushViewController:vc animated:YES];
                    } else {
                        [weakSelf HTTPInsertFlowDatasWithComplete:^(id data) {
                            [weakSelf HTTPCustomConnect:data[@"data"] andType:@"1" andC_A41500_C_ID:model.C_A41500_C_ID andRemark:nil andRemarkID:nil andSuccessBlock:nil];
                            
                            CustomerDetailInfoModel *cmodel = [[CustomerDetailInfoModel alloc]init];
                            
                            AddOrEditlCustomerViewController*vc=[[AddOrEditlCustomerViewController alloc]init];
                            vc.Type=customerTypeEdit;
                            cmodel.C_ID = cmodel.C_A41500_C_ID = model.C_A41500_C_ID;
                            for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                                if (customerModel.content.length > 0) {
                                    if ([customerModel.title isEqualToString:@"客户姓名"]) {
                                        cmodel.C_NAME = customerModel.content;
                                    }
                                    if ([customerModel.title isEqualToString:@"手机号"]) {
                                        cmodel.C_PHONE = customerModel.content;
                                    } else if ([customerModel.title isEqualToString:@"微信号"]) {
                                        cmodel.C_WECHAT = customerModel.content;
                                    } else if ([customerModel.title isEqualToString:@"跟进等级"]){
                                        cmodel.C_LEVEL_DD_ID = customerModel.C_ID;
                                        cmodel.C_LEVEL_DD_NAME = customerModel.content;
                                    } else if ([customerModel.title isEqualToString:@"介绍人"]){
                                        cmodel.C_A47700_C_ID = customerModel.C_ID;
                                        cmodel.C_A47700_C_NAME = customerModel.content;
                                    }else if ([customerModel.title isEqualToString:@"性别"]) {
                                        if ([customerModel.content isEqualToString:@"男"]) {
                                            cmodel.C_SEX_DD_ID = @"A41300_C_SEX_0000";
                                        } else {
                                            cmodel.C_SEX_DD_ID = @"A41300_C_SEX_0001";
                                        }
                                        cmodel.C_SEX_DD_NAME = customerModel.content;
                                    }  else if ([customerModel.title isEqualToString:@"意向车型"]) {
                                          cmodel.C_A49600_C_ID = self.C_YX_A49600_C_ID;
                                          cmodel.C_A70600_C_ID = self.C_YX_A70600_C_ID;
                                        vc.C_A70600_C_ID = self.C_YX_A70600_C_ID;
                                        vc.C_A49600_C_ID = self.C_YX_A49600_C_ID;
                                          cmodel.C_A49600_C_NAME = self.C_YX_A49600_C_NAME;
                                          cmodel.C_A70600_C_NAME = self.C_YX_A70600_C_NAME;
                                     }  else if ([customerModel.title isEqualToString:@"省市"]) {
                                            cmodel.C_PROVINCE = self.C_PROVINCE;
                                            cmodel.C_CITY = self.C_CITY;
                                       }
                                }
                            }
                            for (MJKFlowProcessModel *flowModel in weakSelf.flowInfoArray) {
                                if (flowModel.content.length > 0) {
                                    if ([flowModel.title isEqualToString:@"来源渠道"]) {
                                        cmodel.C_CLUESOURCE_DD_ID = flowModel.C_ID;
                                        cmodel.C_CLUESOURCE_DD_NAME = flowModel.content;
                                    }
                                    if ([flowModel.title isEqualToString:@"渠道细分"]) {
                                        cmodel.C_A41200_C_ID = flowModel.C_ID;
                                        cmodel.C_A41200_C_NAME = flowModel.content;
                                    }
                                }
                            }
                            if (weakSelf.headImageArray.count > 0) {
                                vc.portraitAddress = weakSelf.headImageArray[0];
                                cmodel.C_HEADIMGURL = weakSelf.headImageArray[0];
                            } else {
                                if (weakSelf.detailModel.C_HEADPIC.length > 0) {
                                    vc.portraitAddress = weakSelf.detailModel.C_HEADPIC;
                                    cmodel.C_HEADIMGURL = weakSelf.detailModel.C_HEADPIC;
                                }
                                
                            }
                            vc.mainModel = cmodel;
                            vc.completeComitBlock = ^(NSString *C_ID, CustomerDetailInfoModel *newModel) {
                                if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"])  {
                                    //                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                } else {
                                    if (weakSelf.superVC != nil) {
                                        [weakSelf.navigationController popToViewController:weakSelf.superVC animated:YES];
                                    }
                                    
                                }
                            };
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }];
                    }
                    
                    
                }];
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"新增订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                if ([weakSelf.typeName isEqualToString:@"有效流量"]) {
                    [weakSelf HttpAddCustomerWithCompleteBlock:^(CustomerDetailInfoModel *model) {
                        [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"1" andC_A41500_C_ID:model.C_A41500_C_ID andRemark:nil andRemarkID:nil andSuccessBlock:^{
                            //新增订单
                            MJKOrderAddOrEditViewController *vc = [[MJKOrderAddOrEditViewController alloc]init];
                            vc.Type = orderTypeAdd;
                            CGCCustomModel *tempModel = [[CGCCustomModel alloc]init];
                            tempModel.C_ID=model.C_A41500_C_ID;
                            for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                                if (customerModel.content.length > 0) {
                                    if ([customerModel.title isEqualToString:@"客户姓名"]) {
                                        tempModel.C_NAME = customerModel.content;
                                    }
                                    if ([customerModel.title isEqualToString:@"手机号"]) {
                                        tempModel.C_PHONE = customerModel.content;
                                    }
                                    else if ([customerModel.title isEqualToString:@"性别"]) {
                                        tempModel.C_SEX_DD_ID = customerModel.content;
                                    } else if ([customerModel.title isEqualToString:@"意向车型"]) {
                                        tempModel.C_A49600_C_ID = self.C_YX_A49600_C_ID;
//                                        evc.C_A40600_C_ID = self.C_YX_A70600_C_ID;
                                        tempModel.C_A49600_C_NAME = self.C_YX_A49600_C_NAME;
//                                        evc.C_A40600_C_NAME = self.C_YX_A70600_C_NAME;
                                        tempModel.C_A70600_C_ID = self.C_YX_A70600_C_ID;
                                        tempModel.C_A70600_C_NAME = self.C_YX_A70600_C_NAME;
                                    }
                                }
                            }
                            
                            for (MJKFlowProcessModel *model in self.flowInfoArray) {
                                
                                if (model.C_ID.length > 0) {
                                    if ([model.title isEqualToString:@"来源渠道"]) {
                                        tempModel.C_CLUESOURCE_DD_ID = model.C_ID;
                                        tempModel.C_CLUESOURCE_DD_NAME = model.content;
                                    } else if ([model.title isEqualToString:@"渠道细分"]) {
                                        tempModel.C_A41200_C_ID = model.C_ID;
                                        tempModel.C_A41200_C_NAME = model.content;
                                    }
                                }
                            }
                            
                            vc.customerModel = tempModel;
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                        
                    }];
                } else {
                    [weakSelf HttpAddCustomerWithCompleteBlock:^(CustomerDetailInfoModel *model) {
                        for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                            if ([customerModel.code isEqualToString:@"C_A41500_C_ID"]) {
                                customerModel.C_ID = model.C_A41500_C_ID;
                            }
                        }
                        [weakSelf HTTPInsertFlowDatasWithComplete:^(id data) {
                            [weakSelf HTTPCustomConnect:data[@"data"] andType:@"1" andC_A41500_C_ID:model.C_A41500_C_ID andRemark:nil andRemarkID:nil andSuccessBlock:^{
                                //新增订单
                                MJKOrderAddOrEditViewController *vc = [[MJKOrderAddOrEditViewController alloc]init];
                                vc.Type = orderTypeAdd;
                                CGCCustomModel *tempModel = [[CGCCustomModel alloc]init];
                                tempModel.C_ID=model.C_A41500_C_ID;
                                for (MJKFlowProcessModel *customerModel in weakSelf.customerInfoArray) {
                                    if (customerModel.content.length > 0) {
                                        if ([customerModel.title isEqualToString:@"客户姓名"]) {
                                            tempModel.C_NAME = customerModel.content;
                                        }
                                        if ([customerModel.title isEqualToString:@"手机号"]) {
                                            tempModel.C_PHONE = customerModel.content;
                                        }
                                        else if ([customerModel.title isEqualToString:@"性别"]) {
                                            tempModel.C_SEX_DD_ID = customerModel.content;
                                        } else if ([customerModel.title isEqualToString:@"意向车型"]) {
                                            tempModel.C_A49600_C_ID = self.C_YX_A49600_C_ID;
   //                                        evc.C_A40600_C_ID = self.C_YX_A70600_C_ID;
                                            tempModel.C_A49600_C_NAME = self.C_YX_A49600_C_NAME;
   //                                        evc.C_A40600_C_NAME = self.C_YX_A70600_C_NAME;
                                            tempModel.C_A70600_C_ID = self.C_YX_A70600_C_ID;
                                            tempModel.C_A70600_C_NAME = self.C_YX_A70600_C_NAME;
                                       }
                                    }
                                }
                                
                                for (MJKFlowProcessModel *model in self.flowInfoArray) {
                                    
                                    if (model.C_ID.length > 0) {
                                        if ([model.title isEqualToString:@"来源渠道"]) {
                                            tempModel.C_CLUESOURCE_DD_ID = model.C_ID;
                                            tempModel.C_CLUESOURCE_DD_NAME = model.content;
                                        } else if ([model.title isEqualToString:@"渠道细分"]) {
                                            tempModel.C_A41200_C_ID = model.C_ID;
                                            tempModel.C_A41200_C_NAME = model.content;
                                        }
                                    }
                                    
                                    
                                }
                                vc.customerModel = tempModel;
                                [self.navigationController pushViewController:vc animated:YES];
                            }];
                        }];
                    }];
                }
                
                
            }];
            
            [alertC addAction:followAction];
            [alertC addAction:perfectAction];
            [alertC addAction:cancelAction];
            
            [weakSelf presentViewController:alertC animated:YES completion:nil];
        }];
    } else {
        if ([self.vcName isEqualToString:@"到店"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a414:wld"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        
        
        MJKFlowProcessModel *flowInfoModelName;
        MJKFlowProcessModel *flowInfoModelName1;
        if (self.type == MJKFlowProcessOneImage) {
            flowInfoModelName = weakSelf.flowInfoArray[6];
            flowInfoModelName1 = weakSelf.flowInfoArray[7];
        } else {
            flowInfoModelName = weakSelf.flowInfoArray[4];
            flowInfoModelName1 = weakSelf.flowInfoArray[5];
        }
//        if ([self.btArray containsObject:@"A47500_C_BTX_0008"]) {
//            if (flowInfoModelName.C_ID.length <= 0) {
//                [JRToast showWithText:@"请选择来源渠道"];
//                return;
//            }
//        }
//        if ([self.btArray containsObject:@"A47500_C_BTX_0009"]) {
//            if (flowInfoModelName1.C_ID.length <= 0) {
//                [JRToast showWithText:@"请选择渠道细分"];
//                return;
//            }
//        }
        NSMutableArray*failChooseArray=[NSMutableArray array];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42600_C_REXMARK_TYPE"] ) {
            [failChooseArray addObject:model.C_NAME];
            [dic setObject:model.C_VOUCHERID forKey:model.C_NAME];
        }
        CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:self.view.frame withSelClick:^{
            //弹出选择就默认第一个
        } withSureClick:^(NSString *title, NSString *dateStr) {
            NSLog(@"%@",title);
            if ([weakSelf.typeName isEqualToString:@"有效流量"]) {
               
                    [weakSelf HTTPCustomConnect:weakSelf.model.C_ID andType:@"0" andC_A41500_C_ID:@"" andRemark:dateStr.length > 0 ? [dateStr substringFromIndex:title.length + 1] : @"" andRemarkID:title.length > 0 ? dic[title] : @"" andSuccessBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                
                        //新增订单
            } else {
               
                [weakSelf HTTPInsertFlowDatasWithComplete:^(id data) {
                    [weakSelf HTTPCustomConnect:data[@"data"] andType:@"0" andC_A41500_C_ID:@"" andRemark:dateStr.length > 0 ? [dateStr substringFromIndex:title.length + 1] : @"" andRemarkID:title.length > 0 ? dic[title] : @"" andSuccessBlock:^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }];
                }];
                
            }
        } withHight:195.0 withText:@"请填写未留档原因" withDatas:failChooseArray];
        alertDateView.textfield.placeholder = @"选择原因类型";
        alertDateView.remarkText.placeholder = @"请输入备注";
        [self.view addSubview:alertDateView];
    }
    
    
}

- (void)checkCustomerCountWithCompleteBlock:(void(^)(void))successBlock {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"CustomerWebService-validateMaxCustomer"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([data[@"FLAG"] isEqualToString:@"soon"]) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (successBlock) {
                        successBlock();
                    }
                }];
                [ac addAction:knowAction];
                [weakSelf presentViewController:ac animated:YES completion:nil];
            }else if ([data[@"FLAG"] isEqualToString:@"exceed"]){
                //exceed
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                [ac addAction:knowAction];
                [weakSelf presentViewController:ac animated:YES completion:nil];
            } else {
                if (successBlock) {
                    successBlock();
                }
            }
            
            
        }
        else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
}

#pragma mark - HTTP request
- (void)HTTPGetFlowMeterDetailDatas {
    DBSelf(weakSelf);
    if ([self.typeName isEqualToString:@"有效流量"]) {
      
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        if (self.model.C_ID.length > 0) {
            contentDic[@"C_ID"] = self.model.C_ID;
        }
        
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/info",HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"code"] integerValue]==200) {
                weakSelf.headImageArray = [NSMutableArray array];;
                weakSelf.customerInfoArray = nil;
                weakSelf.flowInfoArray = nil;
                weakSelf.receptionInfoArray = nil;
                weakSelf.detailModel = [MJKFlowMeterDetailModel yy_modelWithDictionary:data[@"data"]];
                if (weakSelf.detailModel.headpic_content.count > 0) {
                    for (NSDictionary *dic in weakSelf.detailModel.headpic_content) {
                        [weakSelf.headImageArray addObject:dic[@"C_HEADIMGURL"]];
                    }
                }
                
                if (![weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                    self.clearButton.hidden = NO;
                }
                
                if ([weakSelf.detailModel.LEVEL isEqualToString:@"VIP"] || [weakSelf.clueName isEqualToString:@"已处理流量详情"] || [weakSelf.vcName isEqualToString:@"详情"]) {
                    if ([weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                        [weakSelf getTodayAllYuyue:self.detailModel.C_A41500_C_ID andYuyueIDBlock:^(NSString *yuyueId) {
                            if (yuyueId.length > 0) {
                                [weakSelf.comoleteButton setTitleNormal:@"预约客户到店"];
                                weakSelf.commitType = @"关联预约客户";
                                weakSelf.yuyueID = yuyueId;
                            } else {
                                [weakSelf.comoleteButton setTitleNormal:@"未预约客户到店"];
                                weakSelf.commitType = @"关联现有客户";
                                
                            }
                        }];
                    }
                    if ([self.typeName isEqualToString:@"有效流量"]) {
                        
                        [weakSelf.customerInfoArray removeObjectAtIndex:2];
                        [weakSelf.customerInfoArray removeObjectAtIndex:2];
                        [weakSelf.customerInfoArray removeObjectAtIndex:2];
                    } else {
                        
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                    }
                    
                }
                
                for (int i = 0; i < weakSelf.customerInfoArray.count; i++) {
                    MJKFlowProcessModel *flowProcessModel = weakSelf.customerInfoArray[i];
                    
                    MJKFlowProcessModel *flowProcessModel0 = weakSelf.customerInfoArray[0];
                    if (![weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                        flowProcessModel0.content = @"";
                        flowProcessModel0.C_ID = @"";
                    } else {
                        flowProcessModel0.content = self.model.C_A41500_C_NAME;
                        flowProcessModel0.C_ID = self.model.C_A41500_C_ID;
                    }
                    
                    NSDictionary *customerDic = [data[@"data"] copy];
                    [customerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        //                    if ([customerModel.title isEqualToString:@"性别"]) {
                        //                        customerModel.content = self.detailModel.C_SEX;
                        //                        if ([self.detailModel.C_SEX isEqualToString:@"男"]) {
                        //                            customerModel.C_ID = @"A41300_C_SEX_0000";
                        //                        } else if ([self.detailModel.C_SEX isEqualToString:@"女"]) {
                        //                            customerModel.C_ID = @"A41300_C_SEX_0001";
                        //                        }
                        if ([key isEqualToString:flowProcessModel.code]) {
                            if (![obj isKindOfClass:[NSNull class]]) {
                                flowProcessModel.content = obj;
                                flowProcessModel.C_ID = obj;
                            }
                            
                        }
                        
                        //                    if ([key isEqualToString:@"C_SEX"]) {
                        //                        if ([obj isEqualToString:@"男"]) {
                        //                            flowProcessModel.C_ID = @"A41300_C_SEX_0000";
                        //                        } else if ([obj isEqualToString:@"女"]) {
                        //                            flowProcessModel.C_ID = @"A41300_C_SEX_0001";
                        //                        }
                        //                    }
                    }];
                    [customerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        if ([key isEqualToString:flowProcessModel.nameCode]) {
                            if (![obj isKindOfClass:[NSNull class]]) {
                                flowProcessModel.content = obj;
                                flowProcessModel.C_ID = obj;
                            }
                            
                        }
                    }];
                    
                    [customerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:flowProcessModel.detailCode]) {
                            if ([flowProcessModel.detailCode isEqualToString:@"C_A41500_C_SEX_DD_NAME"]) {
                                if (![obj isKindOfClass:[NSNull class]]) {
                                    flowProcessModel.content = obj;
                                    flowProcessModel.C_ID = obj;
                                }
                            }
                            
                        }
                    }];
                    
                    
                    
                    //                if ([weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                    //                    if ([flowProcessModel.title isEqualToString:@"客户姓名"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.C_A41500_C_NAME;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                }
                    //                if ([weakSelf.vcName isEqualToString:@"详情"]) {
                    
                    if ([flowProcessModel.title isEqualToString:@"客户姓名"]) {
                        flowProcessModel.content = weakSelf.detailModel.C_A41500_C_NAME;
                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    }
                    //                    if ([flowProcessModel.title isEqualToString:@"手机号"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                    if ([flowProcessModel.title isEqualToString:@"微信号"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.C_A41500_C_NAME;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                    if ([flowProcessModel.title isEqualToString:@"客户等级"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                }
                    
                    
                    //                if ([flowProcessModel.title isEqualToString:@"性别"]) {
                    //                    flowProcessModel.content = weakSelf.detailModel.C_SEX;
                    //                    if ([weakSelf.detailModel.C_SEX isEqualToString:@"男"]) {
                    //                        flowProcessModel.C_ID = @"A41300_C_SEX_0000";
                    //                    } else if ([weakSelf.detailModel.C_SEX isEqualToString:@"女"]) {
                    //                        flowProcessModel.C_ID = @"A41300_C_SEX_0001";
                    //                    }
                    //
                    //                }
                    //                if ([flowProcessModel.title isEqualToString:@"年龄"]) {
                    //                    if (weakSelf.detailModel.C_AGE.length > 0) {
                    //                        flowProcessModel.content = weakSelf.detailModel.C_AGE;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_AGE;
                    //                    }
                    //                }
                }
                for (int i = 0; i < weakSelf.flowInfoArray.count; i++) {
                    MJKFlowProcessModel *flowModel = weakSelf.flowInfoArray[i];
                    //                if ([flowModel.title isEqualToString:@"进店次数"]) {
                    //                    flowModel.content =weakSelf.detailModel.I_ARRIVAL;
                    //                    flowModel.C_ID =weakSelf.detailModel.I_ARRIVAL;
                    //                }
                    //                if ([flowModel.title isEqualToString:@"进店位置"]) {
                    //                    flowModel.content =weakSelf.detailModel.C_POSITION;
                    //                    flowModel.C_ID =weakSelf.detailModel.C_POSITION;
                    //                }
                    //                if ([flowModel.title isEqualToString:@"进店时间"]) {
                    //                    flowModel.content =weakSelf.detailModel.D_ARRIVAL_TIME;
                    //                    flowModel.C_ID =weakSelf.detailModel.D_ARRIVAL_TIME;
                    //                }
                    NSDictionary *flowDic = [data[@"data"] copy];
                    [flowDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:flowModel.code]) {
                            
                            if (![obj isKindOfClass:[NSNull class]]) {
                                if ([key isEqualToString:@"I_ARRIVAL"]) {
                                    flowModel.content = [NSString stringWithFormat:@"%@次到店",obj];
                                    flowModel.C_ID = obj;
                                } else if ([key isEqualToString:@"I_PEPOLE_NUMBER"]) {
                                    flowModel.content = [NSString stringWithFormat:@"%@",obj];
                                    flowModel.C_ID = obj;
                                } else if ([key isEqualToString:@"D_ARRIVAL_TIME"]) {
                                    flowModel.content = obj;
                                    flowModel.C_ID = obj;
                                }
                                else {
                                    flowModel.content = obj;
                                    flowModel.C_ID = obj;
                                }
                            }
                        }
                    }];
                    [flowDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:flowModel.nameCode]) {
                            if (![obj isKindOfClass:[NSNull class]]) {
                                if ([key isEqualToString:@"I_ARRIVAL"]) {
                                    flowModel.content = [NSString stringWithFormat:@"%@次到店",obj];
                                } else if ([key isEqualToString:@"I_PEPOLE_NUMBER"]) {
                                    flowModel.content = [NSString stringWithFormat:@"%@",obj];
                                } else {
                                    flowModel.content = obj;
                                }
                            }
                        }
                    }];
                    
                }
                
                for (int i = 0; i < weakSelf.receptionInfoArray.count; i++) {
                    //                if ([self.clueName isEqualToString:@"已处理流量详情"]) {
                    //                    MJKFlowProcessModel *receptionModel = weakSelf.receptionInfoArray[i];
                    //                    if ([receptionModel.title isEqualToString:@"本次接待员工"]) {
                    //                        receptionModel.content = weakSelf.detailModel.USERNAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.USERID;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"本次接待时间"]) {
                    //                        receptionModel.content = weakSelf.detailModel.D_OPERATION_TIME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.D_OPERATION_TIME;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"本次处理结果"]) {
                    //                        receptionModel.content = weakSelf.detailModel.C_RESULT_DD_NAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.C_RESULT_DD_ID;
                    //                    }
                    //                } else {
                    //                    MJKFlowProcessModel *receptionModel = weakSelf.receptionInfoArray[i];
                    //                    if ([receptionModel.title isEqualToString:@"上次接待员工"]) {
                    //                        receptionModel.content = weakSelf.detailModel.C_SALENAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.C_SALEID;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"上次接待时间"]) {
                    //                        receptionModel.content = weakSelf.detailModel.D_BEFORE_TIME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.D_BEFORE_TIME;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"上次处理结果"]) {
                    //                        receptionModel.content = weakSelf.detailModel.C_RESULT_DD_NAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.C_RESULT_DD_ID;
                    //                    }
                    //                }
                    
                    MJKFlowProcessModel *receptionModel = weakSelf.receptionInfoArray[i];
                    NSDictionary *receptionDic = [data[@"data"] copy];
                    [receptionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:receptionModel.code]) {
                            if (![obj isKindOfClass:[NSNull class]]) {
                                receptionModel.content = obj;
                                receptionModel.C_ID = obj;
                            }
                            
                        }
                    }];
                    
                    [receptionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:receptionModel.nameCode]) {
                            if (![obj isKindOfClass:[NSNull class]]) {
                                receptionModel.content = obj;
                                receptionModel.C_ID = obj;
                            }
                        }
                    }];
                }
                [weakSelf.tableView reloadData];
            }else{
                [JRToast showWithText:data[@"msg"]];
            }
        }];
    } else {
        NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:[self.typeName isEqualToString:@"有效流量"] ? HTTP_flowGetBeanById : HTTP_GetFlowMeterDetail];
        NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        if (self.model.C_ID.length > 0) {
            contentDic[@"C_ID"] = self.model.C_ID;
        }
        [dict setObject:contentDic forKey:@"content"];
        NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"code"] integerValue]==200) {
                weakSelf.headImageArray = [NSMutableArray array];;
                weakSelf.customerInfoArray = nil;
                weakSelf.flowInfoArray = nil;
                weakSelf.receptionInfoArray = nil;
                weakSelf.detailModel = [MJKFlowMeterDetailModel yy_modelWithDictionary:data];
                if (weakSelf.detailModel.headpic_content.count > 0) {
                    for (NSDictionary *dic in weakSelf.detailModel.headpic_content) {
                        [weakSelf.headImageArray addObject:dic[@"C_HEADPIC"]];
                    }
                }
                
                if (![weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                    self.clearButton.hidden = NO;
                }
                
                if ([weakSelf.detailModel.LEVEL isEqualToString:@"VIP"] || [weakSelf.clueName isEqualToString:@"已处理流量详情"] || [weakSelf.vcName isEqualToString:@"详情"]) {
                    if ([weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                        [weakSelf getTodayAllYuyue:self.detailModel.C_A41500_C_ID andYuyueIDBlock:^(NSString *yuyueId) {
                            if (yuyueId.length > 0) {
                                [weakSelf.comoleteButton setTitleNormal:@"预约客户到店"];
                                weakSelf.commitType = @"关联预约客户";
                                weakSelf.yuyueID = yuyueId;
                            } else {
                                [weakSelf.comoleteButton setTitleNormal:@"未预约客户到店"];
                                weakSelf.commitType = @"关联现有客户";
                                
                            }
                        }];
                    }
                    if ([self.typeName isEqualToString:@"有效流量"]) {
                        
                        [weakSelf.customerInfoArray removeObjectAtIndex:2];
                        [weakSelf.customerInfoArray removeObjectAtIndex:2];
                        [weakSelf.customerInfoArray removeObjectAtIndex:2];
                    } else {
                        
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                        [weakSelf.customerInfoArray removeObjectAtIndex:1];
                    }
                    
                }
                
                for (int i = 0; i < weakSelf.customerInfoArray.count; i++) {
                    MJKFlowProcessModel *flowProcessModel = weakSelf.customerInfoArray[i];
                    
                    MJKFlowProcessModel *flowProcessModel0 = weakSelf.customerInfoArray[0];
                    if (![weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                        flowProcessModel0.content = @"";
                        flowProcessModel0.C_ID = @"";
                    } else {
                        flowProcessModel0.content = self.model.C_A41500_C_NAME;
                        flowProcessModel0.C_ID = self.model.C_A41500_C_ID;
                    }
                    
                    NSDictionary *customerDic = [data copy];
                    [customerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        //                    if ([customerModel.title isEqualToString:@"性别"]) {
                        //                        customerModel.content = self.detailModel.C_SEX;
                        //                        if ([self.detailModel.C_SEX isEqualToString:@"男"]) {
                        //                            customerModel.C_ID = @"A41300_C_SEX_0000";
                        //                        } else if ([self.detailModel.C_SEX isEqualToString:@"女"]) {
                        //                            customerModel.C_ID = @"A41300_C_SEX_0001";
                        //                        }
                        if ([key isEqualToString:flowProcessModel.code]) {
                            flowProcessModel.content = obj;
                            flowProcessModel.C_ID = obj;
                            
                        }
                        
                        //                    if ([key isEqualToString:@"C_SEX"]) {
                        //                        if ([obj isEqualToString:@"男"]) {
                        //                            flowProcessModel.C_ID = @"A41300_C_SEX_0000";
                        //                        } else if ([obj isEqualToString:@"女"]) {
                        //                            flowProcessModel.C_ID = @"A41300_C_SEX_0001";
                        //                        }
                        //                    }
                    }];
                    [customerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        
                        if ([key isEqualToString:flowProcessModel.nameCode]) {
                            flowProcessModel.content = obj;
                            flowProcessModel.C_ID = obj;
                            
                        }
                    }];
                    
                    [customerDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:flowProcessModel.detailCode]) {
                            if ([flowProcessModel.detailCode isEqualToString:@"C_A41500_C_SEX_DD_NAME"]) {
                                flowProcessModel.content = obj;
                                flowProcessModel.C_ID = obj;
                            }
                            
                        }
                    }];
                    
                    
                    
                    //                if ([weakSelf.detailModel.LEVEL isEqualToString:@"VIP"]) {
                    //                    if ([flowProcessModel.title isEqualToString:@"客户姓名"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.C_A41500_C_NAME;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                }
                    //                if ([weakSelf.vcName isEqualToString:@"详情"]) {
                    
                    if ([flowProcessModel.title isEqualToString:@"客户姓名"]) {
                        flowProcessModel.content = weakSelf.detailModel.C_A41500_C_NAME;
                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    }
                    //                    if ([flowProcessModel.title isEqualToString:@"手机号"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                    if ([flowProcessModel.title isEqualToString:@"微信号"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.C_A41500_C_NAME;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                    if ([flowProcessModel.title isEqualToString:@"客户等级"]) {
                    //                        flowProcessModel.content = weakSelf.detailModel.;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_A41500_C_ID;
                    //                    }
                    //                }
                    
                    
                    //                if ([flowProcessModel.title isEqualToString:@"性别"]) {
                    //                    flowProcessModel.content = weakSelf.detailModel.C_SEX;
                    //                    if ([weakSelf.detailModel.C_SEX isEqualToString:@"男"]) {
                    //                        flowProcessModel.C_ID = @"A41300_C_SEX_0000";
                    //                    } else if ([weakSelf.detailModel.C_SEX isEqualToString:@"女"]) {
                    //                        flowProcessModel.C_ID = @"A41300_C_SEX_0001";
                    //                    }
                    //
                    //                }
                    //                if ([flowProcessModel.title isEqualToString:@"年龄"]) {
                    //                    if (weakSelf.detailModel.C_AGE.length > 0) {
                    //                        flowProcessModel.content = weakSelf.detailModel.C_AGE;
                    //                        flowProcessModel.C_ID = weakSelf.detailModel.C_AGE;
                    //                    }
                    //                }
                }
                for (int i = 0; i < weakSelf.flowInfoArray.count; i++) {
                    MJKFlowProcessModel *flowModel = weakSelf.flowInfoArray[i];
                    //                if ([flowModel.title isEqualToString:@"进店次数"]) {
                    //                    flowModel.content =weakSelf.detailModel.I_ARRIVAL;
                    //                    flowModel.C_ID =weakSelf.detailModel.I_ARRIVAL;
                    //                }
                    //                if ([flowModel.title isEqualToString:@"进店位置"]) {
                    //                    flowModel.content =weakSelf.detailModel.C_POSITION;
                    //                    flowModel.C_ID =weakSelf.detailModel.C_POSITION;
                    //                }
                    //                if ([flowModel.title isEqualToString:@"进店时间"]) {
                    //                    flowModel.content =weakSelf.detailModel.D_ARRIVAL_TIME;
                    //                    flowModel.C_ID =weakSelf.detailModel.D_ARRIVAL_TIME;
                    //                }
                    NSDictionary *flowDic = [data copy];
                    [flowDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:flowModel.code]) {
                            if ([key isEqualToString:@"I_ARRIVAL"]) {
                                flowModel.content = [NSString stringWithFormat:@"%@次到店",obj];
                                flowModel.C_ID = obj;
                            } else if ([key isEqualToString:@"I_PEPOLE_NUMBER"]) {
                                flowModel.content = [NSString stringWithFormat:@"%@",obj];
                                flowModel.C_ID = obj;
                            } else if ([key isEqualToString:@"D_ARRIVAL_TIME"]) {
                                flowModel.content = obj;
                                flowModel.C_ID = [[obj substringToIndex:16] stringByAppendingString:@":00"];
                            }
                            else {
                                flowModel.content = obj;
                                flowModel.C_ID = obj;
                            }
                        }
                    }];
                    [flowDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:flowModel.nameCode]) {
                            if ([key isEqualToString:@"I_ARRIVAL"]) {
                                flowModel.content = [NSString stringWithFormat:@"%@次到店",obj];
                            } else if ([key isEqualToString:@"I_PEPOLE_NUMBER"]) {
                                flowModel.content = [NSString stringWithFormat:@"%@",obj];
                            } else {
                                flowModel.content = obj;
                            }
                        }
                    }];
                    
                }
                
                for (int i = 0; i < weakSelf.receptionInfoArray.count; i++) {
                    //                if ([self.clueName isEqualToString:@"已处理流量详情"]) {
                    //                    MJKFlowProcessModel *receptionModel = weakSelf.receptionInfoArray[i];
                    //                    if ([receptionModel.title isEqualToString:@"本次接待员工"]) {
                    //                        receptionModel.content = weakSelf.detailModel.USERNAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.USERID;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"本次接待时间"]) {
                    //                        receptionModel.content = weakSelf.detailModel.D_OPERATION_TIME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.D_OPERATION_TIME;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"本次处理结果"]) {
                    //                        receptionModel.content = weakSelf.detailModel.C_RESULT_DD_NAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.C_RESULT_DD_ID;
                    //                    }
                    //                } else {
                    //                    MJKFlowProcessModel *receptionModel = weakSelf.receptionInfoArray[i];
                    //                    if ([receptionModel.title isEqualToString:@"上次接待员工"]) {
                    //                        receptionModel.content = weakSelf.detailModel.C_SALENAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.C_SALEID;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"上次接待时间"]) {
                    //                        receptionModel.content = weakSelf.detailModel.D_BEFORE_TIME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.D_BEFORE_TIME;
                    //                    }
                    //                    if ([receptionModel.title isEqualToString:@"上次处理结果"]) {
                    //                        receptionModel.content = weakSelf.detailModel.C_RESULT_DD_NAME;
                    //                        receptionModel.C_ID = weakSelf.detailModel.C_RESULT_DD_ID;
                    //                    }
                    //                }
                    
                    MJKFlowProcessModel *receptionModel = weakSelf.receptionInfoArray[i];
                    NSDictionary *receptionDic = [data copy];
                    [receptionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:receptionModel.code]) {
                            receptionModel.content = obj;
                            receptionModel.C_ID = obj;
                            
                        }
                    }];
                    
                    [receptionDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
                        if ([key isEqualToString:receptionModel.nameCode]) {
                            receptionModel.content = obj;
                            receptionModel.C_ID = obj;
                        }
                    }];
                }
                [weakSelf.tableView reloadData];
            }else{
                [JRToast showWithText:data[@"message"]];
            }
        }];
    }
}

- (void)getDayLevel:(void(^)(NSArray *array))successBlock {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSMutableArray *saveTimeNumberArray=[NSMutableArray array];
            for (NSDictionary*dict in data[@"data"][@"list"]) {
                CustomerLvevelNextFollowModel*model=[CustomerLvevelNextFollowModel yy_modelWithDictionary:dict];
                [saveTimeNumberArray addObject:model];
            }
            
            if (successBlock) {
                successBlock(saveTimeNumberArray);
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
    }];
    
}
#pragma mark - 流量处理操作
- (void)HTTPUpdataFlowMeterData:(NSString *)type {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_UpdataFlowMeter];
    [dict setObject:@{@"C_ID" : self.detailModel.C_ID, @"ARRIVAL_TYPE" : type} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark 获取当天所有预约
- (void)getTodayAllYuyue:(NSString *)customerID andYuyueIDBlock:(void(^)(NSString *yuyueId))completeBlock {
//    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"ReservationWebService-getReservationByA415"];
    [dict setObject:@{@"C_A41500_C_ID" : customerID} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock(data[@"content"]);
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark 新增流量
- (void)HTTPInsertFlowDatasWithComplete:(void(^)(id data))successBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_flowInsert];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    
    for (MJKFlowProcessModel *customerModel in self.customerInfoArray) {
//        if ([customerModel.title isEqualToString:@"性别"]) {
//            contentDict[@"C_SEX"] = customerModel.C_ID;
//        } else if ([customerModel.title isEqualToString:@"年龄"]) {
//            contentDict[@"C_AGE"] = customerModel.C_ID;
//        }
        if ([self.commitType isEqualToString:@"关联预约客户"]) {
            if ([customerModel.code isEqualToString:@"C_A41500_C_ID"]) {
                if (customerModel.C_ID.length > 0) {
                    contentDict[@"C_A41600_C_ID"] = customerModel.C_ID;
                }
            }
        } else {
            if (customerModel.C_ID.length > 0) {
                contentDict[customerModel.code] = customerModel.C_ID;
            }
        }
        
        
    }
    for (MJKFlowProcessModel *model in self.flowInfoArray) {
//        if ([model.title isEqualToString:@"进店人数"]) {
//            contentDict[@"I_PEPOLE_NUMBER"] = model.C_ID;
//        } else
//        if ([model.title isEqualToString:@"进店时间"]) {
//            contentDict[@"D_ARRIVAL_TIME"] = model.C_ID;
//        }
//            else if ([model.title isEqualToString:@"来源渠道"]) {
//            contentDict[@"C_SOURCE_DD_ID"] = model.C_ID;
//        } else if ([model.title isEqualToString:@"随行人员"]) {
//            contentDict[@"C_ATTENDANT"] = model.C_ID;
//        } else if ([model.title isEqualToString:@"逗留时长"]) {
//            contentDict[@"C_STAYTIME_DD_ID"] = model.C_ID;
//        } else if ([model.title isEqualToString:@"渠道细分"]) {
//            contentDict[@"C_A41200_C_ID"] = model.C_ID;
//        }
        if ([model.code isEqualToString:@"I_ARRIVAL"]) {
            if (model.C_ID != nil) {
                NSString *str = [NSString stringWithFormat:@"%@",model.C_ID];
//                    contentDict[model.code] = str;
                //I_PEPOLE_NUMBER
                contentDict[@"I_PEPOLE_NUMBER"] = str;
            }
            
        } else {
            
            model.C_ID = [model.C_ID isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@",model.C_ID] : model.C_ID;
            if (model.C_ID.length > 0) {
                contentDict[model.code] = model.C_ID;
            }
        }
    }
    [contentDict setObject:[NewUserSession instance].user.u051Id forKey:@"USER_ID"];
    [contentDict setObject:self.flowID forKey:@"C_ID"];
    if (![self.clueName isEqualToString:@"新增"]&& ![self.typeName isEqualToString:@"有效流量"]) {
        [contentDict setObject:self.idStr.length > 0 ? self.idStr : self.detailModel.C_ID forKey:@"C_A46000_C_ID"];
    }
    
    if (self.a46000Forms.count > 0) {
        contentDict[@"a46000Forms"] = self.a46000Forms;
    }
    [dict setObject:contentDict forKey:@"content"];
    //    [dict setObject:@{@"C_ID" :  self.detailModel.C_ID, } forKey:@"content"];
    
    if (self.postDic == contentDict) {
        return;
    }
    self.postDic = contentDict;
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/add",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
            if ([data[@"code"] integerValue]==200) {
                successBlock(data);
            }else{
                [JRToast showWithText:data[@"msg"]];
            }
    }];
//    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        //        "C_ID" = "A46000-1604903D22EDVRS8DQKGM47G201QRY968";
//        //        DBSelf(weakSelf);
//        if ([data[@"code"] integerValue]==200) {
//            successBlock(data);
//        }else{
//            [JRToast showWithText:data[@"message"]];
//        }
//    }];
}

- (void)HTTPCustomConnect:(NSString *)C_ID andType:(NSString *)type andC_A41500_C_ID:(NSString *)C_A41500_C_ID andRemark:(NSString *)remarkStr andRemarkID:(NSString *)remarkID andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = C_ID;
    contentDic[@"type"] = type;
    
    if ([type isEqualToString:@"0"]) {
        contentDic[@"C_REMARK_TYPE_DD_ID"] = remarkID;
        contentDic[@"X_REMARK"] = remarkStr;
    } else if ([type isEqualToString:@"6"]) {
        contentDic[@"C_A41600_C_ID"] = C_A41500_C_ID;
        if (self.amodel.X_REMARK.length > 0) {
            contentDic[@"X_REMARK"] = self.amodel.X_REMARK;
        }
        if (self.amodel.C_LEVEL_DD_ID.length > 0) {
            contentDic[@"C_LEVEL_DD_ID"] = self.amodel.C_LEVEL_DD_ID;
        }
        if (self.amodel.C_YS_DD_ID.length > 0) {
            contentDic[@"C_YS_DD_ID"] = self.amodel.C_YS_DD_ID;
        }
        if (self.amodel.C_PAYMENT_DD_ID.length > 0) {
            contentDic[@"C_PAYMENT_DD_ID"] = self.amodel.C_PAYMENT_DD_ID;
        }
    } else {
        contentDic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    }
    if (self.conectCusPostDic == contentDic) {
        return;
    }
    self.conectCusPostDic = contentDic;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a414/operation", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        /*
         {
         "C_A41500_C_ID" = "A4150000000721-1559553455";
         "C_ID" = "A4140000000002-1525920649792225e1-9";
         TYPE = 2;
         }
         */
//        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        /*
//         {
//         "C_A41500_C_ID" = "A4150000000721-1559553455";
//         "C_ID" = "A4140000000002-1525920649792225e1-9";
//         TYPE = 2;
//         }
//         */
////        DBSelf(weakSelf);
//        MyLog(@"%@",data);
//        if ([data[@"code"] integerValue]==200) {
//            if (completeBlock) {
//                completeBlock();
//            }
//
//        }else{
//            [JRToast showWithText:data[@"message"]];
//        }
//    }];
}

#pragma mark 新增客户
- (void)HttpAddCustomerWithCompleteBlock:(void(^)(CustomerDetailInfoModel *model))completeBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    for (MJKFlowProcessModel *model in self.customerInfoArray) {
        if (model.C_ID.length > 0) {
            if ([model.title isEqualToString:@"客户姓名"]) {
                contentDic[@"C_NAME"] = model.C_ID;
            } else if ([model.title isEqualToString:@"手机号"]) {
                contentDic[@"C_PHONE"] = model.C_ID;
            } else if ([model.title isEqualToString:@"微信号"]) {
                contentDic[@"C_WECHAT"] = model.C_ID;
            } else if ([model.title isEqualToString:@"跟进等级"]) {
                contentDic[@"C_LEVEL_DD_ID"] = model.C_ID;
            }else if ([model.title isEqualToString:@"介绍人"]) {
                contentDic[@"C_A47700_C_ID"] = model.C_ID;
            } else if ([model.title isEqualToString:@"性别"]) {
                if ([model.C_ID isEqualToString:@"男"]) {
                    contentDic[@"C_SEX_DD_ID"] = @"A41300_C_SEX_0000";
                } else if ([model.C_ID isEqualToString:@"女"]) {
                    contentDic[@"C_SEX_DD_ID"] = @"A41300_C_SEX_0001";
                }
            }
        }
    }
    for (MJKFlowProcessModel *model in self.flowInfoArray) {
        if (![model.title isEqualToString:@"进店次数"]) {
            model.C_ID = [model.C_ID isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%@",model.C_ID] : model.C_ID;
            if (model.C_ID.length > 0) {
                if ([model.title isEqualToString:@"来源渠道"]) {
                    contentDic[@"C_CLUESOURCE_DD_ID"] = model.C_ID;
                } else if ([model.title isEqualToString:@"渠道细分"]) {
                    contentDic[@"C_A41200_C_ID"] = model.C_ID;
                }
            }
        }
        
    }
    //C_HEADIMGURL头像
    if (self.detailModel.C_HEADPIC.length > 0) {
        contentDic[@"C_HEADIMGURL"] = self.detailModel.C_HEADPIC;
    } else if (self.headImageArray.count > 0) {
        contentDic[@"C_HEADIMGURL"] = self.headImageArray[0];
    }
    
    contentDic[@"C_A49600_C_ID"] = self.C_YX_A49600_C_ID.length > 0 ? self.C_YX_A49600_C_ID : @"";
    contentDic[@"C_A70600_C_ID"] = self.C_YX_A70600_C_ID.length > 0 ? self.C_YX_A70600_C_ID : @"";
    if (self.C_PROVINCE.length > 0) {
        contentDic[@"C_PROVINCE"] = self.C_PROVINCE;
    }
    if (self.C_CITY.length > 0) {
        contentDic[@"C_CITY"] = self.C_CITY;
    }
    
    self.customerID = [DBObjectTools getPotentailcustomerC_id];
//    contentDic[@"C_ID"] = self.customerID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/add", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
//        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([data[@"data"][@"FLAG"] isEqualToString:@"own"] || [data[@"data"][@"FLAG"] isEqualToString:@"false"]) {
//                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@,是否要协助",data[@"message"]] preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf HTTPAddHelper:data[@"C_A41500_C_ID"]];
//                }];
//                UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }];
//                [ac addAction:yesAction];
//                [ac addAction:noAction];
//                ac.modalPresentationStyle = UIModalPresentationFullScreen;
//                [weakSelf presentViewController:ac animated:yesAction completion:nil];
                
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
//                UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }];
                [ac addAction:yesAction];
//                [ac addAction:noAction];
                ac.modalPresentationStyle = UIModalPresentationFullScreen;
                [weakSelf presentViewController:ac animated:YES completion:nil];
                return ;
            }
            CustomerDetailInfoModel *model = [CustomerDetailInfoModel mj_objectWithKeyValues:data[@"data"]];
            if (completeBlock) {
                completeBlock(model);
            }
//
//            }];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)pushInfoWithC_A41500_C_ID:(NSString *)C_A41500_C_ID andC_ID:(NSString *)C_ID andC_TYPE_DD_ID:(NSString *)C_TYPE_DD_ID {
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPushMsg"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    dic[@"C_OBJECTID"] = C_ID;
    dic[@"C_TYPE_DD_ID"] = C_TYPE_DD_ID;
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
//            weakSelf.dataDic = data[@"content"];
             MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:@[@"否",@"是"] andTitle:@"" andMessage:@"是否给客户发送通知消息?"];
            showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                if ([str isEqualToString:@"否"]) {
                    if ([self.commitType isEqualToString:@"新增客户"]) {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    } else {
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:data[@"content"]];
                    dic[@"params"] = weakSelf.paramArr;
                    vc.titleNameXCX = @"离店消息";
                    vc.C_A41500_C_ID = C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = C_TYPE_DD_ID;
                    vc.C_ID = C_ID;
                    vc.dataDic = dic;
                    vc.backActionBlock = ^{
                        for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                            if ([vc isKindOfClass:[MJKClueTabViewController class]]) {
                                [weakSelf.navigationController popToViewController:vc animated:YES];
                            }
                        }
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
//            if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0000"]) {
                [weakSelf.view addSubview:showView];
//            } else if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_LLTSDW_0001"]) {
//                [weakSelf.view addSubview:showView];
//            } else {
//                if ([self.commitType isEqualToString:@"新增客户"]) {
////                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                } else {
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }
//            }
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}


#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        if ([self.vcName isEqualToString:@"详情"]) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight ) style:UITableViewStyleGrouped];
        } else {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 70, 0, 60, 20)];
        [_clearButton setTitleNormal:@"清空"];
        [_clearButton setTitleColor:[UIColor lightGrayColor]];
        _clearButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_clearButton addTarget:self action:@selector(clearButtonAction)];
        _clearButton.hidden = YES;
    }
    return _clearButton;
}

- (UIButton *)comoleteButton {
    if (!_comoleteButton) {
        _comoleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight- SafeAreaBottomHeight - 45, KScreenWidth, 50)];
        _comoleteButton.backgroundColor = KNaviColor;
        [_comoleteButton setTitleNormal:@"自然到店未留档"];
        [_comoleteButton setTitleColor:[UIColor blackColor]];
        [_comoleteButton addTarget:self action:@selector(completeButtonAction:)];
    }
    return _comoleteButton;
}

- (NSMutableArray *)customerInfoArray {
    if (!_customerInfoArray) {
        _customerInfoArray = [NSMutableArray array];
        if ([self.clueName isEqualToString:@"新增"] || [self.typeName isEqualToString:@"有效流量"]) {
            for (int i = 0; i < 10; i++) {
                MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
                model.title = @[@"预约客户",@"客户姓名",@"手机号",@"微信号",@"意向车型",@"跟进等级",@"省市",@"介绍人",@"性别",@"年龄"][i];
                model.code = @[@"",@"C_A41500_C_ID",@"C_PHONE",@"C_WECHAT",@"",@"C_LEVEL_DD_ID",@"",@"C_A47700_C_ID",@"C_SEX",@"C_AGE"][i];
                
                model.detailCode = @[@"",@"C_A41500_C_ID",@"C_A41500_C_PHONE",@"C_A41500_C_WECHAT",@"",@"C_LEVEL_DD_ID",@"",@"C_A47700_C_ID",@"C_A41500_C_SEX_DD_NAME",@"C_AGE"][i];
                model.nameCode = @[@"",@"C_A41500_C_NAME",@"C_PHONE",@"C_WECHAT",@"",@"C_LEVEL_DD_NAME",@"",@"C_A47700_C_NAME",@"C_SEX",@"C_AGE"][i];
                if (i == 1) {
                    model.isSelect = YES;
                } else if (i == 2 || i == 3) {
                    model.isEdit = YES;
                } else if (i == 0 || i == 4 || i == 5) {
                    model.isGo = YES;
                } else {
                    model.isData = YES;
                }
                
                [_customerInfoArray addObject:model];
            }
        } else {
            if (self.type == MJKFlowProcessOneImage) {
                for (int i = 0; i < 9; i++) {
                    MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
                    model.title = @[@"客户姓名",@"手机号",@"微信号",@"意向车型",@"跟进等级",@"省市",@"介绍人",@"性别",@"年龄"][i];
                    model.code = @[@"C_A41500_C_ID",@"C_PHONE",@"C_WECHAT",@"",@"C_LEVEL_DD_ID",@"",@"C_A47700_C_ID",@"C_SEX",@"C_AGE"][i];
                    model.detailCode = @[@"C_A41500_C_ID",@"C_A41500_C_PHONE",@"C_A41500_C_WECHAT",@"",@"C_LEVEL_DD_ID",@"",@"C_A47700_C_ID",@"C_A41500_C_SEX_DD_ID",@"C_AGE"][i];
                    model.nameCode = @[@"C_A41500_C_NAME",@"C_PHONE",@"C_WECHAT",@"",@"C_LEVEL_DD_NAME",@"",@"C_A47700_C_NAME",@"C_SEX",@"C_AGE"][i];
                    if (i == 0) {
                        model.isSelect = YES;
                    } else if (i == 1 || i == 2) {
                        model.isEdit = YES;
                    } else if (i == 3 || i== 4) {
                        model.isGo = YES;
                    } else {
                        model.isData = YES;
                    }
                    
                    [_customerInfoArray addObject:model];
                }
            } else if (self.type == MJKFlowProcessMoreImage) {
                for (int i = 0; i < 5; i++) {
                    MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
                    model.title = @[@"客户姓名",@"手机号",@"微信号",@"意向车型",@"跟进等级",@"省市",@"介绍人"][i];
                    model.code = @[@"C_A41500_C_ID",@"C_PHONE",@"C_WECHAT",@"",@"C_LEVEL_DD_ID",@"",@"C_A47700_C_ID"][i];
                    model.detailCode = @[@"C_A41500_C_ID",@"C_A41500_C_PHONE",@"C_A41500_C_WECHAT",@"",@"C_LEVEL_DD_ID",@"",@"C_A47700_C_ID"][i];
                    model.nameCode = @[@"C_A41500_C_NAME",@"C_PHONE",@"C_WECHAT",@"",@"C_LEVEL_DD_NAME",@"",@"C_A47700_C_NAME"][i];
                    if (i == 0) {
                        model.isSelect = YES;
                    } else if (i == 1 || i == 2) {
                        model.isEdit = YES;
                    } else {
                        model.isGo = YES;
                    }
                    [_customerInfoArray addObject:model];
                }
            }
        }
        
    }
    return _customerInfoArray;
}

- (NSMutableArray *)flowInfoArray {
    if (!_flowInfoArray) {
        _flowInfoArray = [NSMutableArray array];
        if (self.type == MJKFlowProcessOneImage) {
            for (int i = 0; i < 9; i++) {
                MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
                model.title = @[@"进店次数",@"进店位置",@"进店时间",@"进店人数",@"随行人员",@"逗留时长",@"来源渠道",@"渠道细分",@"备注"][i];
                model.code = @[@"I_ARRIVAL",@"C_POSITION",@"D_ARRIVAL_TIME",@"I_PEPOLE_NUMBER",@"C_ATTENDANT",@"C_STAYTIME_DD_ID",@"C_SOURCE_DD_ID",@"C_A41200_C_ID",@"X_REMARK"][i];
                model.nameCode = @[@"I_ARRIVAL",@"C_POSITION",@"D_ARRIVAL_TIME",@"I_PEPOLE_NUMBER",@"C_ATTENDANT",@"C_STAYTIME_DD_NAME",@"C_SOURCE_DD_NAME",@"C_A41200_C_NAME",@"X_REMARK"][i];
                //[self.typeName isEqualToString:@"有效流量"] ? @"X_REMARK" : @"X_A41300_REMARK"
                if (i == 0 || i == 1 || i == 2) {
                    if (i == 2) {
                        if ([self.clueName isEqualToString:@"新增"]) {
                            model.content = [DBTools getTimeFomatFromCurrentTimeStamp];
                            model.C_ID = [DBTools getTimeFomatFromCurrentTimeStamp];
                        }
                    }
                    model.isData = YES;
                } else if (i == 4 || i == 8) {
                    model.isEdit = YES;
                } else if (i == 5 || i == 6 || i == 7) {
                    model.isGo = YES;
                }  else {
                    model.isAdd = YES;
                    model.content = @"1";
                    model.C_ID = @"1";
                }
                [_flowInfoArray addObject:model];
            }
        } else if (self.type == MJKFlowProcessMoreImage) {
            for (int i = 0; i < 7; i++) {
                MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
                model.title = @[@"进店时间",@"进店人数",@"随行人员",@"逗留时长",@"来源渠道",@"渠道细分",@"备注"][i];
                model.code = @[@"D_ARRIVAL_TIME",@"I_ARRIVAL",@"C_ATTENDANT",@"C_STAYTIME_DD_ID",@"C_SOURCE_DD_ID",@"C_A41200_C_ID",[self.typeName isEqualToString:@"有效流量"] ? @"X_REMARK" : @"X_A41300_REMARK"][i];
                model.nameCode = @[@"D_ARRIVAL_TIME",@"I_ARRIVAL",@"C_ATTENDANT",@"C_STAYTIME_DD_NAME",@"C_SOURCE_DD_NAME",@"C_A41200_C_NAME",[self.typeName isEqualToString:@"有效流量"] ? @"X_REMARK" : @"X_A41300_REMARK"][i];
                if (i == 0) {
                    model.isData = YES;
                    model.content = self.model.D_ARRIVAL_TIME;
                    model.C_ID = self.model.D_ARRIVAL_TIME;
                } else if (i == 2 || i == 6) {
                    model.isEdit = YES;
                } else if (i == 3 || i == 4 || i == 5) {
                    model.isGo = YES;
                }  else {
                    model.isAdd = YES;
                    model.content = [NSString stringWithFormat:@"%ld",self.headImageArray.count];
                    model.C_ID = [NSString stringWithFormat:@"%ld",self.headImageArray.count];
                }
                [_flowInfoArray addObject:model];
            }
        }
        
    }
    return _flowInfoArray;
}

- (NSMutableArray *)receptionInfoArray {
    if (!_receptionInfoArray) {
        _receptionInfoArray = [NSMutableArray array];
        for (int i = 0; i < 3; i++) {
            MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
            if ([self.clueName isEqualToString:@"已处理流量详情"]) {
                model.title = @[@"本次接待员工",@"本次接待时间",@"本次处理结果"][i];
                if (self.detailModel.C_OWNER_ROLENAME.length > 0) {
                    model.code = @[@"C_OWNER_ROLEID",@"D_ARRIVAL_TIME",@"C_STATUS_DD_ID"][i];
                    model.nameCode = @[@"C_OWNER_ROLENAME",@"D_ARRIVAL_TIME",@"C_STATUS_DD_NAME"][i];
                } else {
                    model.code = @[@"USERID",@"D_OPERATION_TIME",@"C_RESULT_DD_ID"][i];
                    model.nameCode = @[@"USERNAME",@"D_OPERATION_TIME",@"C_RESULT_DD_NAME"][i];
                }
            } else {
                model.title = @[@"上次接待员工",@"上次接待时间",@"上次处理结果"][i];
                model.code = @[@"C_SALEID",@"D_BEFORE_TIME",@"C_RESULT_DD_ID"][i];
                model.nameCode = @[@"C_SALENAME",@"D_BEFORE_TIME",@"C_RESULT_DD_NAME"][i];
            }
            
            [_receptionInfoArray addObject:model];
        }
    }
    return _receptionInfoArray;
}

@end
