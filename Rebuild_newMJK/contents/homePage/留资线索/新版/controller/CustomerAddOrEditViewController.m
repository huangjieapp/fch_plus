//
//  CustomerAddOrEditViewController.m
//  match
//
//  Created by huangjie on 2022/7/31.
//

#import "CustomerAddOrEditViewController.h"
#import "MJKChooseBrandViewController.h"
#import "CustomerFollowAddEditViewController.h"
#import "MJKClueTabViewController.h"
#import "CGCBrokerCenterVC.h"
#import "MJKClueListViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKProductShowModel.h"
#import "VideoAndImageModel.h"
#import "CustomerListModel.h"

#import "CustomerHeaderTableViewCell.h"
#import "CustomerInputTableViewCell.h"
#import "CustomerChooseTableViewCell.h"
#import "CustomerRemarkTableViewCell.h"
#import "SetSwitchTableViewCell.h"

#import "CustomerPhotoView.h"


@interface CustomerAddOrEditViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *saveUrl;
/** <#注释#> */
@property (nonatomic, strong) UIButton *submitButton;
/** <#注释#> */
@property (nonatomic, strong) CustomerPhotoView *photoView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *btxArray;
/** <#注释#> */
@property (nonatomic, strong) NSString *typeStr;

@end

@implementation CustomerAddOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.title = @"新增潜客";
    
    
    @weakify(self);
    [self getLocalData];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-55-AdaptSafeBottomHeight);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[CustomerHeaderTableViewCell class] forCellReuseIdentifier:@"CustomerHeaderTableViewCell"];
    [_tableView registerClass:[CustomerInputTableViewCell class] forCellReuseIdentifier:@"CustomerInputTableViewCell"];
    [_tableView registerClass:[CustomerChooseTableViewCell class] forCellReuseIdentifier:@"CustomerChooseTableViewCell"];
    [_tableView registerClass:[CustomerRemarkTableViewCell class] forCellReuseIdentifier:@"CustomerRemarkTableViewCell"];
    [_tableView registerClass:[SetSwitchTableViewCell class] forCellReuseIdentifier:@"SetSwitchTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    _submitButton = [UIButton new];
    [self.view addSubview:_submitButton];
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.bottom.mas_equalTo(-5 -AdaptSafeBottomHeight);
        make.height.mas_equalTo(45);
    }];
    [_submitButton setBackgroundColor:KNaviColor];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _submitButton.titleLabel.font = [UIFont systemFontOfSize:16.f];
    _submitButton.layer.cornerRadius = 5.f;
    
    
    [[_submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        for (NSArray *arr in self.localDatas) {
            for (PotentailCustomerEditModel *model in arr) {
                if ([model.locatedTitle isEqualToString:@"联系电话"]) {
                    if (model.postValue.length > 0) {
                        [self checkRepeatWithType:@"C_PHONE" content:model.postValue andCheckOnly:NO];
                    }
                }
            }
        }
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
    @weakify(self);
    NSArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
    if ([model.locatedTitle isEqualToString:@"基本信息"]) {
        CustomerHeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerHeaderTableViewCell"];
       
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.headUrl] placeholderImage:[UIImage imageNamed:@"icon_add"]];
        cell.nameTextField.text = model.nameValue;
        cell.choosePhotoBlock = ^{
            @strongify(self);
            self.typeStr = @"头像";
            [self TouchAddImage];
//            HXPhotoManager *manager = [HXPhotoManager new];
//            manager.configuration.singleJumpEdit = YES;
//            manager.configuration.singleSelected = YES;
//            [self openPhotoLibraryWith:manager success:^(VideoAndImageModel * _Nonnull model) {
//                self.saveUrl = model.saveUrl;
//                self.headUrl = model.url;
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            }];
        };
        [[[cell.nameTextField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
            model.postValue =  cell.nameTextField.text;
            model.nameValue =  cell.nameTextField.text;
        }];
        return cell;
    } else  {
        if ([model.locatedTitle isEqualToString:@"联系电话"] ||
            [model.locatedTitle isEqualToString:@"微信"] ||
            [model.locatedTitle isEqualToString:@"车牌"] ||
            [model.locatedTitle isEqualToString:@"保有车辆"] ||
            [model.locatedTitle isEqualToString:@"客户地址"] ||
            [model.locatedTitle isEqualToString:@"公司"] ||
            [model.locatedTitle isEqualToString:@"职务"]) {
            CustomerInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerInputTableViewCell"];
            if ([model.locatedTitle isEqualToString:@"联系电话"]) {
                cell.mustLabel.hidden = NO;
            } else {
                cell.mustLabel.hidden = YES;
            }
            cell.titleLabel.text = model.locatedTitle;
            cell.inputTextField.text = model.nameValue;
            if ([model.locatedTitle isEqualToString:@"联系电话"]) {
                cell.inputTextField.placeholder = @"手机和微信至少有一项必填";
                cell.isPhoneNumber = YES;
                cell.number = 11;
                cell.checkButton.hidden = NO;
                cell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
                [cell.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(50, 30));
                }];
                [[[cell.checkButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                    @strongify(self);
                    [self checkRepeatWithType:@"C_PHONE" content:model.postValue andCheckOnly:YES];
                }];
            } else {
                if ([model.locatedTitle isEqualToString:@"微信"]) {
                    cell.inputTextField.placeholder = @"手机和微信至少有一项必填";
                } else {
                    cell.inputTextField.placeholder = @"请输入";
                }
                cell.isPhoneNumber = NO;
                cell.checkButton.hidden = YES;
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
                [cell.checkButton mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(0, 0));
                }];
            }
            [[[cell.inputTextField rac_signalForControlEvents:UIControlEventEditingChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                model.postValue =  cell.inputTextField.text;
                model.nameValue =  cell.inputTextField.text;
            }];
            
            
            return cell;
        }  else if ([model.locatedTitle isEqualToString:@"是否添加微信"]) {
            SetSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetSwitchTableViewCell"];
            cell.titleLabel.text = model.locatedTitle;
            cell.switchButton.on  = [model.postValue isEqualToString:@"0"] ? NO : YES;
            [[[cell.switchButton rac_signalForControlEvents:UIControlEventValueChanged] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UISwitch * _Nullable x) {
                if (x.isOn) {
                    model.postValue = @"1";
                    model.nameValue = @"1";

                } else {
                    model.postValue = @"0";
                    model.nameValue = @"0";

                }
                
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }];
            return cell;
        } else if ([model.locatedTitle isEqualToString:@"备注"]) {
            CustomerRemarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerRemarkTableViewCell"];
            cell.titleLabel.text = model.locatedTitle;
            cell.textView.text = model.nameValue;
            cell.textView.shouldIgnoreScrollingAdjustment = YES;
            cell.textView.shouldRestoreScrollViewContentOffset = YES;
            [[[cell.textView rac_textSignal] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(NSString * _Nullable x) {
                model.postValue = x;
                model.nameValue = x;
            }];
            return cell;
        } else {
            CustomerChooseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerChooseTableViewCell"];
            cell.titleLabel.text = model.locatedTitle;
            cell.chooseTextField.text = model.nameValue;
            cell.titleStr = model.locatedTitle;
            cell.chooseStr = model.postValue;
            if ([model.locatedTitle isEqualToString:@"匹配车型"] ||
                [model.locatedTitle isEqualToString:@"意向车型"] ||
                [model.locatedTitle isEqualToString:@"等级"] ||
                [model.locatedTitle isEqualToString:@"来源"] ||
                [model.locatedTitle isEqualToString:@"渠道"]) {
                cell.mustLabel.hidden = NO;
            } else {
                cell.mustLabel.hidden = YES;
            }
            if ([model.locatedTitle isEqualToString:@"购车类型"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_BUYTYPE";
            } else if ([model.locatedTitle isEqualToString:@"匹配车型"] ||
                       [model.locatedTitle isEqualToString:@"意向车型"]) {
                cell.type = CustomerChooseTypeNil;
            } else if ([model.locatedTitle isEqualToString:@"等级"]) {
                cell.type = CustomerChooseTypeLevel;
            } else if ([model.locatedTitle isEqualToString:@"来源"]) {
                cell.type = CustomerChooseTypeSource;
            } else if ([model.locatedTitle isEqualToString:@"渠道"]) {
                cell.type = CustomerChooseTypeChannel;
                PotentailCustomerEditModel *newModel = self.localDatas[indexPath.section][indexPath.row - 1];
                cell.sourceStr = newModel.postValue;
                cell.typeStr = @"A41200_C_TYPE_0000";
            } else if ([model.locatedTitle isEqualToString:@"性别"]) {
                cell.type = CustomerChooseTypeGender;
            } else if ([model.locatedTitle isEqualToString:@"省市"]) {
                cell.type = CustomerChooseTypePC;
            } else if ([model.locatedTitle isEqualToString:@"预算"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_YS";
            } else if ([model.locatedTitle isEqualToString:@"购车阶段"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_PAYMENT";
            } else if ([model.locatedTitle isEqualToString:@"行业"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_INDUSTRY";
            } else if ([model.locatedTitle isEqualToString:@"年收入"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_SALARY";
            } else if ([model.locatedTitle isEqualToString:@"文化程度"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_EDUCATION";
            } else if ([model.locatedTitle isEqualToString:@"婚姻状况"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_MARITALSTATUS";
            } else if ([model.locatedTitle isEqualToString:@"生日"]) {
                cell.type = CustomerChooseTypeBirth;
            } else if ([model.locatedTitle isEqualToString:@"爱好"]) {
                cell.type = CustomerChooseTypeWithTYPECODE;
                cell.typeStr = @"A41500_C_HOBBY";
            } else if ([model.locatedTitle isEqualToString:@"介绍人"]) {
                cell.type = CustomerChooseTypeNil;
            }
                
            cell.chooseBlock = ^(NSString * _Nonnull str, NSString * _Nonnull postValue) {
                @strongify(self);
                if ([model.locatedTitle isEqualToString:@"来源"]) {
                    model.postValue = postValue;
                    model.nameValue = str;
                    PotentailCustomerEditModel *qdModel = self.localDatas[indexPath.section][indexPath.row + 1];
                    qdModel.nameValue = @"";
                    qdModel.postValue = @"";
                    [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                } else if ([model.locatedTitle isEqualToString:@"购车类型"]) {
                    model.postValue = postValue;
                    model.nameValue = str;
                    if ([postValue isEqualToString:@"A41500_C_BUYTYPE_0001"]) {//二手车
                        PotentailCustomerEditModel *cxModel = self.localDatas[indexPath.section][indexPath.row + 1];
                        cxModel.locatedTitle = @"匹配车型";
                        cxModel.nameValue = @"";
                        cxModel.postValue = @"";
                    } else {
                        PotentailCustomerEditModel *cxModel = self.localDatas[indexPath.section][indexPath.row + 1];
                        cxModel.locatedTitle = @"意向车型";
                        cxModel.nameValue = @"";
                        cxModel.postValue = @"";
                    }
                    [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
                } else if ([model.locatedTitle isEqualToString:@"匹配车型"] || [model.locatedTitle isEqualToString:@"意向车型"]) {
                    MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
                    vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                        MJKProductShowModel *chooseModel = productArray[0];
                        model.nameValue = [NSString stringWithFormat:@"%@,%@", chooseModel.C_TYPE_DD_NAME, chooseModel.C_NAME];
                        model.postValue =[NSString stringWithFormat:@"%@,%@", chooseModel.C_TYPE_DD_ID, chooseModel.C_ID];
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                } else if ([model.locatedTitle isEqualToString:@"介绍人"]) {
                    CGCBrokerCenterVC *vc = [[CGCBrokerCenterVC alloc]init];
                    vc.type = BrokerCenterMembers;
                    vc.typeName = @"名单经纪人";
                    if ([NewUserSession instance].configData.IS_JSRSFKFXZ.boolValue == YES) {
                        vc.SEARCH_TYPE = @"1";
                    }
                    vc.backSelectFansBlock = ^(CGCCustomModel *model1) {
                        model.nameValue=model1.C_NAME;
                        model.postValue=model1.C_ID;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [self.navigationController pushViewController:vc animated:YES];
                } else {
                    model.postValue = postValue;
                    model.nameValue = str;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            return cell;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [UILabel  new];
    [bgView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.mas_equalTo(17);
    }];
    label.text = @[@"基本信息"][section];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor darkGrayColor];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section != self.localDatas.count - 1) {
        return  .1f;
    }
    return 150;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section != self.localDatas.count - 1) {
        return  nil;
    }
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    bgView.backgroundColor = [UIColor whiteColor];
    _photoView = [CustomerPhotoView new];
    [bgView addSubview:_photoView];
    [_photoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(bgView);
    }];
    _photoView.tableView = tableView;
    _photoView.imageUrlArray = self.imageUrlArray;
    @weakify(self);
    [[self.photoView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.typeStr = @"图片";
        [self TouchAddImage];
    }];
    return bgView;
}

- (void)getLocalData {
    NSMutableArray*localArr0=[NSMutableArray arrayWithObjects:@"基本信息",@"联系电话",@"微信",@"是否添加微信",@"购车类型",@"意向车型",@"等级",@"来源",@"渠道",@"性别",@"省市",@"预算",@"购车阶段",@"车牌",@"保有车辆",@"客户地址",@"行业",@"公司",@"职务",@"年收入",@"文化程度",@"婚姻状况",@"生日",@"爱好",@"介绍人",@"备注", nil] ;
    NSMutableArray *localValueArr0=[NSMutableArray arrayWithObjects:self.tempCustomerModel.C_NAME ?:@"",
                                    self.tempCustomerModel.C_PHONE ?:@"",
                                    self.tempCustomerModel.C_WECHAT ?:@"",
                                    @"否",
                                    @"新车",
                                    self.tempCustomerModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.tempCustomerModel.C_A70600_C_NAME, self.tempCustomerModel.C_A49600_C_NAME] :@"",
                                    self.tempCustomerModel.C_LEVEL_DD_NAME ?:@"",
                                    self.tempCustomerModel.C_CLUESOURCE_DD_NAME ?:@"",
                                    self.tempCustomerModel.C_A41200_C_NAME ?:@"",
                                    self.tempCustomerModel.C_SEX_DD_NAME ?:@"",
                                    self.tempCustomerModel.C_PROVINCE.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.tempCustomerModel.C_PROVINCE, self.tempCustomerModel.C_CITY] :@"",
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
                                    @"",
                                    @"",
                                    @"",
                                    @"",
                                    @"",
                                    nil];
    NSMutableArray *localPostNameArr0=[NSMutableArray arrayWithObjects:self.tempCustomerModel.C_NAME ?:@"",
                                       self.tempCustomerModel.C_PHONE ?:@"",
                                       self.tempCustomerModel.C_WECHAT ?:@"",
                                       @"0",
                                       @"A41500_C_BUYTYPE_0000",
                                       self.tempCustomerModel.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.tempCustomerModel.C_A70600_C_ID, self.tempCustomerModel.C_A49600_C_ID] :@"",
                                       self.tempCustomerModel.C_LEVEL_DD_ID ?:@"",
                                       self.tempCustomerModel.C_CLUESOURCE_DD_ID ?:@"",
                                       self.tempCustomerModel.C_A41200_C_ID ?:@"",
                                       self.tempCustomerModel.C_SEX_DD_ID ?:@"",
                                       self.tempCustomerModel.C_PROVINCE.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.tempCustomerModel.C_PROVINCE, self.tempCustomerModel.C_CITY] :@"",
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
                                       @"",
                                       @"",
                                       @"",
                                       @"",
                                       @"",
                                       nil];
    
    
    NSMutableArray *localKeyArr0=[NSMutableArray arrayWithObjects:@"C_NAME",@"C_PHONE",@"C_WECHAT",@"I_SORTIDX",@"C_BUYTYPE_DD_ID",@"C_A70600_C_ID,C_A49600_C_ID",@"C_LEVEL_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"C_SEX_DD_ID",@"C_PROVINCE,C_CITY",@"C_YS_DD_ID",@"C_PAYMENT_DD_ID",@"C_LICENSE_PLATE",@"C_EXISTING",@"C_ADDRESS",@"C_INDUSTRY_DD_ID",@"C_COMPANY",@"C_OCCUPATION_DD_NAME",@"C_SALARY_DD_ID",@"C_EDUCATION_DD_ID",@"C_MARITALSTATUS_DD_ID",@"C_BIRTHDAY_TIME",@"C_HOBBY_DD_ID",@"C_A47700_C_ID",@"X_REMARK", nil];

    
    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
    
    
    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0, nil];
    
}

- (void)checkRepeatWithType:(NSString *)type content:(NSString *)content andCheckOnly:(BOOL)isCheckOnly {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"repetitioType"] = type;
    contentDic[@"C_PHONE"] = content;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/repetitioCustomer", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            @strongify(self);
            if (isCheckOnly) {
                if ([data[@"data"][@"FLAG"] boolValue] == true) {
                    [JRToast showWithText:@"还没有该潜客"];
                } else{
                    [JRToast showWithText:data[@"data"][@"message"]];
                }
    //            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    //            UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleCancel handler:nil];
    //            [falseAction setValue:KYellowColor forKey:@"_titleTextColor"];
    //            [ac addAction:falseAction];
    //            [self presentViewController:ac animated:YES completion:nil];
            } else {
                if ([data[@"data"][@"FLAG"] boolValue] == true) {
                    [self submitData];
                } else{
                    [JRToast showWithText:data[@"data"][@"message"]];
                }
    //            if ([obj[@"data"][@"FLAG"] boolValue] == false) {
    //                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:obj[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
    //                UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    //                [falseAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    //                [ac addAction:falseAction];
    //
    //                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                        [self submitData];
    //                    }];
    //                    [trueAction setValue:KYellowColor forKey:@"_titleTextColor"];
    //
    //                    [ac addAction:trueAction];
    //                [self presentViewController:ac animated:YES completion:nil];
                    
    //                    [JRToast showWithText:obj[@"data"][@"message"]];
    //            } else {
    //                [self submitData];
    //            }
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
}


- (void)submitData {
    for (NSArray *arr in self.localDatas) {
        for (int i = 0; i < arr.count; i++) {
            PotentailCustomerEditModel *model = arr[i];
            
            if (model.postValue.length <= 0) {
                if ([model.locatedTitle isEqualToString:@"联系电话"]) {
                    for (PotentailCustomerEditModel *wxModel in arr) {
                        if ([wxModel.locatedTitle isEqualToString:@"微信"]) {
                            if (wxModel.postValue.length <= 0) {
                                [JRToast showWithText:@"手机和微信至少有一项必填"];
                                return;
                            }
                        }
                    }
                }
                if ([model.locatedTitle isEqualToString:@"微信"]) {
                    for (PotentailCustomerEditModel *wxModel in arr) {
                        if ([wxModel.locatedTitle isEqualToString:@"联系电话"]) {
                            if (wxModel.postValue.length <= 0) {
                                [JRToast showWithText:@"手机和微信至少有一项必填"];
                                return;
                            }
                        }
                    }
                }
                
                if ([model.locatedTitle isEqualToString:@"匹配车型"] ||
                    [model.locatedTitle isEqualToString:@"意向车型"] ||
                    [model.locatedTitle isEqualToString:@"等级"] ||
                    [model.locatedTitle isEqualToString:@"来源"] ||
                    [model.locatedTitle isEqualToString:@"渠道"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"%@必填", model.locatedTitle]];
                    return;
                }
                
            } else {
                if ([model.locatedTitle isEqualToString:@"联系电话"]) {
                    if (model.postValue.length != 11) {
                        [JRToast showWithText:@"联系电话格式有误!"];
                        return;
                    }
                }
            }
            
        }
    }
    
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            
            if (model.postValue.length > 0) {
                if ([model.locatedTitle isEqualToString:@"省市"]) {
                    NSArray *codeArr = [model.keyValue componentsSeparatedByString:@","];
                    NSArray*postArray = [model.postValue componentsSeparatedByString:@","];
                    for (int i = 0; i < codeArr.count; i++) {
                        contentDic[codeArr[i]] = postArray[i];
                    }
                    
                } else if ([model.locatedTitle isEqualToString:@"匹配车型"] ||
                           [model.locatedTitle isEqualToString:@"意向车型"]) {
                    NSArray *codeArr = [model.keyValue componentsSeparatedByString:@","];
                    NSArray*postArray = [model.postValue componentsSeparatedByString:@","];
                    for (int i = 0; i < codeArr.count; i++) {
                        contentDic[codeArr[i]] = postArray[i];
                    }

                } else {
                    contentDic[model.keyValue] = model.postValue;
                }
            }
        }
    }

    contentDic[@"C_HEADIMGURL"] = self.saveUrl;
    if (self.C_A41300_C_ID.length > 0) {
        contentDic[@"C_A41300_C_ID"] = self.C_A41300_C_ID;
    }

    NSString *urlPath = @"/api/crm/a415/add";
    if (self.imageUrlArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in self.imageUrlArray) {
            [arr addObject:[model mj_keyValues]];
        }
        [contentDic setObject:arr forKey:@"fileList"];
    } else {
        [contentDic setObject:@[] forKey:@"fileList"];
    }
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/add", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            @strongify(self);
            MyLog(@"%@", data);
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"listRefresh"];
           
                if (self.rootVC != nil) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否新增跟进?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [DBObjectTools httpPostGetCustomerDetailInfoWithC_ID:data[@"data"][@"C_A41500_C_ID"] andCompleteBlock:^(CustomerDetailInfoModel *customerDetailModel) {
                        
                            CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                            vc.Type=CustomerFollowUpAdd;
                            customerDetailModel.C_A41500_C_ID=customerDetailModel.C_ID;
                            vc.infoModel=customerDetailModel;
                            vc.vcSuper=self;
                            vc.followText=nil;
                            vc.completeBlock = ^{
                                for (UIViewController *vc  in self.navigationController.viewControllers) {
                                    if ([vc isKindOfClass:[MJKClueTabViewController class]] ||
                                        [vc isKindOfClass:[MJKClueListViewController class]]) {
                                        [self.navigationController popToViewController:vc animated:YES];
                                    }
                                }
                            };
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                        
                    }];
                    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popToViewController:self.rootVC animated:YES];
                    }];
                    [ac addAction:trueAction];
                    [ac addAction:falseAction];
                    [self presentViewController:ac animated:YES completion:nil];
                } else {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            
                
            

        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (!image) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];
        }
        NSData *imageData = UIImageJPEGRepresentation(image,0.1);
        image= [UIImage imageWithData:imageData];
        
     
                [self httpUpdateQiniuWithUrl:imageData];
        
        
    }else{
        UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            image=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        //设置image的尺寸
        //        CGSize imagesize = image.size;
        //        imagesize.height =626;
        //        imagesize.width =413;
        //        //对图片大小进行压缩--
        //        image = [self imageWithImage:image scaledToSize:imagesize];
        NSData *imageData = UIImageJPEGRepresentation(image,0.1);
        image= [UIImage imageWithData:imageData];
        
      
                [self httpUpdateQiniuWithUrl:imageData];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

- (void)httpUpdateQiniuWithUrl:(NSData *)imageData {
    @weakify(self);
  
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataQiNiuUpDataFileWithUrl:HTTP_UploadByQiNiu parameters:nil file:imageData andFileName:@"headimage.png" andMimeType:@".png" compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] integerValue] == 200) {
            VideoAndImageModel *model = [VideoAndImageModel mj_objectWithKeyValues:data];
            if ([self.typeStr isEqualToString:@"头像"]) {
                self.saveUrl = model.saveUrl;
                self.headUrl = model.url;
            }
            if ([self.typeStr isEqualToString:@"图片"]) {
                [self.imageUrlArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

- (NSMutableArray *)btxArray {
    if (!_btxArray) {
        _btxArray = [NSMutableArray array];
    }
    return _btxArray;
}

- (void)dealloc {
    MyLog(@"%s", __func__);
}

@end
