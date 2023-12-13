//
//  MJKCarSourceNewAddOrEditViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCarSourceNewAddOrEditViewController.h"
#import "MJKChooseNewBrandViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKProductShowModel.h"
#import "VideoAndImageModel.h"
#import "MJKCarSourceHomeModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"

@interface MJKCarSourceNewAddOrEditViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#> */
@property (nonatomic, strong) CustomerPhotoView *ysPhotoView;
@property (nonatomic, strong) CustomerPhotoView *clPhotoView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fileListYsImage;
@property (nonatomic, strong) NSMutableArray *fileListClImage;
/** <#注释#> */
@property (nonatomic, strong) MJKCarSourceHomeSubModel *model;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fileListYsImageList;
@property (nonatomic, strong) NSMutableArray *fileListClImageList;

@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@property (nonatomic, strong) NSMutableArray *clImageUrlArray;
@end

@implementation MJKCarSourceNewAddOrEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MyLog(@"%@", NSHomeDirectory());
    [self getLocalDatas];
    
    self.title = @"新增车源";
    
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
//    [_tableView registerClass:[SetManagementSwitchTableViewCell class] forCellReuseIdentifier:@"SetManagementSwitchTableViewCell"];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    @weakify(self);
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    _bottomView.backgroundColor = [UIColor whiteColor];
    UIButton *button = [UIButton new];
    [_bottomView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(5);
        make.right.bottom.mas_equalTo(-5);
    }];
    button.backgroundColor = KNaviColor;
    [button setTitle:@"提交" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self submit];
    }];
    
    
    if (self.C_ID.length > 0) {
        self.title = @"编辑车源";
        [self getCarSourceData];
    }
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
    NSArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
    AddCustomerInputTableViewCell *iCell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    AddCustomerChooseTableViewCell *cCell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    if ([model.locatedTitle isEqualToString:@"门店"]) {
        cCell.Type = ChooseTableViewTypeShopL;
        cCell.taglabel.hidden = YES;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"到货日期"]) {
        cCell.taglabel.hidden = NO;
        cCell.Type = ChooseTableViewTypeBirthday;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"车辆状态"]) {
        cCell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        cCell.C_TYPECODE = @"A82300_C_STATUS";
        cCell.taglabel.hidden = NO;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"品牌车型"]) {
        cCell.taglabel.hidden = NO;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.Type = chooseTypeNil;
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
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
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"车辆所在地"]) {
        cCell.Type = ChooseTableViewTypeA80000_C_TYPE;
        cCell.C_TYPECODE = @"A80000_C_TYPE_0010";
        cCell.taglabel.hidden = NO;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"底盘日期"]) {
        cCell.taglabel.hidden = NO;
        cCell.Type = ChooseTableViewTypeBirthday;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"厂家"]) {
        cCell.Type = ChooseTableViewTypeA80000_C_TYPE;
        cCell.C_TYPECODE = @"A80000_C_TYPE_0006";
        cCell.taglabel.hidden = NO;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"车辆类型"]) {
        cCell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        cCell.C_TYPECODE = @"A82300_C_TYPE";
        cCell.taglabel.hidden = NO;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"改装日期"]) {
        cCell.Type = ChooseTableViewTypeBirthday;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"备注"]) {
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
    } else {
        if ([model.locatedTitle isEqualToString:@"具体型号"] ||
            [model.locatedTitle isEqualToString:@"外观颜色"] ||
            [model.locatedTitle isEqualToString:@"内饰颜色"] ||
            [model.locatedTitle isEqualToString:@"环保"] ||
            [model.locatedTitle isEqualToString:@"座位"] ||
            [model.locatedTitle isEqualToString:@"钥匙"] ||
            [model.locatedTitle isEqualToString:@"车架号全号"] ||
            [model.locatedTitle isEqualToString:@"公里数"] ||
            [model.locatedTitle isEqualToString:@"车源编号"]) {
            iCell.tagLabel.hidden = NO;
        } else {
            iCell.tagLabel.hidden = YES;
        }
        iCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.postValue = textStr;
            model.nameValue = textStr;
        };
        return iCell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
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
    return 360;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 360)];
    bgView.backgroundColor = [UIColor whiteColor];
    _ysPhotoView = [CustomerPhotoView new];
    [bgView addSubview:_ysPhotoView];
    [_ysPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.height.equalTo(@180);
    }];
    _ysPhotoView.titleLabel.text = @"钥匙";
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
    
    _clPhotoView = [CustomerPhotoView new];
    [bgView addSubview:_clPhotoView];
    [_clPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bgView);
        make.top.equalTo(self.ysPhotoView.mas_bottom);
    }];
    _clPhotoView.titleLabel.text = @"车辆图片";
    _clPhotoView.tableView = tableView;
    _clPhotoView.imageUrlArray = self.clImageUrlArray;
    [[self.clPhotoView.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        HXPhotoManager *manager = [HXPhotoManager new];
        manager.configuration.singleJumpEdit = NO;
        manager.configuration.singleSelected = YES;
        [self openPhotoLibraryWith:manager success:^(VideoAndImageModel * _Nonnull model) {
            @strongify(self);
            [self.clImageUrlArray addObject:model];
            [self.tableView reloadData];
            
            
        }];
    }];
    return bgView;
}

- (void)submit {
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length <= 0) {
                if ([model.locatedTitle isEqualToString:@"车源编号"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"到货日期"] ||
                    [model.locatedTitle isEqualToString:@"车辆状态"] ||
                    [model.locatedTitle isEqualToString:@"品牌车型"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                if ([model.locatedTitle isEqualToString:@"具体型号"] ||
                    [model.locatedTitle isEqualToString:@"外观颜色"] ||
                    [model.locatedTitle isEqualToString:@"内饰颜色"] ||
                    [model.locatedTitle isEqualToString:@"环保"] ||
                    [model.locatedTitle isEqualToString:@"座位"] ||
                    [model.locatedTitle isEqualToString:@"钥匙"] ||
                    [model.locatedTitle isEqualToString:@"车架号全号"] ||
                    [model.locatedTitle isEqualToString:@"公里数"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"车辆所在地"] ||
                    [model.locatedTitle isEqualToString:@"底盘日期"] ||
                    [model.locatedTitle isEqualToString:@"厂家"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
            }
        }
    }
    
    [self submitData];
}

- (void)submitData {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length > 0) {
                if ([model.locatedTitle isEqualToString:@"品牌车型"]) {
                    NSArray *cxArr = [model.postValue componentsSeparatedByString:@","];
                    contentDic[@"C_A70600_C_ID"] = cxArr[0];
                    contentDic[@"C_A49600_C_ID"] = cxArr[1];
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
        contentDic[@"fileListYs"] = arr;
//        contentDic[@"fileListYs"] = self.fileListYsImage;
    } else {
        contentDic[@"fileListYs"] = @[];
    }
    
    if (self.clImageUrlArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in self.clImageUrlArray) {
            [arr addObject:@{@"saveUrl": model.saveUrl}];
        }
        contentDic[@"fileListFp"] = arr;
//        contentDic[@"fileListFp"] = self.fileListClImage;
    } else {
        contentDic[@"fileListFp"] = @[];
    }
    NSString *path = [NSString stringWithFormat:@"%@/api/crm/a823/add", HTTP_IP];
    if (self.C_ID.length > 0) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a823:force_update"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a823:edit"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        
        path = [NSString stringWithFormat:@"%@/api/crm/a823/edit", HTTP_IP];
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:path parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getCarSourceData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/info", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            [self.imageUrlArray removeAllObjects];
            [self.clImageUrlArray removeAllObjects];
            self.model = [MJKCarSourceHomeSubModel mj_objectWithKeyValues:data[@"data"]];
            [self.imageUrlArray addObjectsFromArray:self.model.fileListYs];
            [self.clImageUrlArray addObjectsFromArray:self.model.fileListFp];
            [self getPostValueAndBeforeValue];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getLocalDatas {
        NSArray*localArr=@[@"门店",@"车源编号",@"到货日期",@"车辆状态",@"品牌车型",@"具体型号",@"外观颜色",@"内饰颜色",@"环保",@"座位",@"钥匙",@"车辆所在地",@"详细地址",@"告知单",@"备注",@"车架号全号",@"公里数",@"底盘日期",@"厂家",@"车辆类型",@"附加精品",@"过户车底盘渠道",@"提档上牌城市",@"最低过户周期",@"改装日期",@"手续原件所在地"];
        NSArray*localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localKeyArr=@[@"C_LOCCODE",@"C_VOUCHERID",@"D_ARRIVAL_TIME",@"C_STATUS_DD_ID",@"C_A70600_C_ID,C_A49600_C_ID",@"C_CAR_TYPE",@"C_W_COLOR",@"C_N_COLOR",@"C_ENVIRONMENTAL_PROTECTION",@"I_SEAT",@"C_YS",@"C_A80000SZD_C_ID",@"C_ADDRESS",@"C_INFORM_THE_SINGLE",@"X_REMARK",@"C_VIN",@"B_GLS",@"D_CHASSIS_TIME",@"C_A80000CJ_C_ID",@"C_TYPE_DD_ID",@"C_ADDITIONAL_PRODUCTS",@"C_GHCDPQD",@"C_FILE_CITY",@"C_MINI_TRANSFER",@"D_MODIFIED_TIME",@"C_ORIGINAL_LOCATION"];
    
    
   
    
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

-(void)getPostValueAndBeforeValue{
    NSArray*section0ShowNameArray =@[self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_VOUCHERID.length > 0 ? self.model.C_VOUCHERID : @"",
                                     self.model.D_ARRIVAL_TIME.length > 0 ? self.model.D_ARRIVAL_TIME : @"",
                                     self.model.C_STATUS_DD_NAME.length > 0 ? self.model.C_STATUS_DD_NAME : @"",
                                     self.model.C_A70600_C_NAME.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.model.C_A70600_C_NAME, self.model.C_A49600_C_NAME] : @"",
                                     self.model.C_CAR_TYPE.length > 0 ? self.model.C_CAR_TYPE : @"",
                                     self.model.C_W_COLOR.length > 0 ? self.model.C_W_COLOR : @"",
                                     self.model.C_N_COLOR.length > 0 ? self.model.C_N_COLOR : @"",
                                     self.model.C_ENVIRONMENTAL_PROTECTION.length > 0 ? self.model.C_ENVIRONMENTAL_PROTECTION : @"",
                                     self.model.I_SEAT.length > 0 ? self.model.I_SEAT: @"",
                                     self.model.C_YS.length > 0 ? self.model.C_YS : @"",
                                     self.model.C_A80000SZD_C_NAME.length > 0 ? self.model.C_A80000SZD_C_NAME : @"",
                                     self.model.C_ADDRESS.length > 0 ? self.model.C_ADDRESS : @"",
                                     self.model.C_INFORM_THE_SINGLE.length > 0 ? self.model.C_INFORM_THE_SINGLE : @"",
                                     self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"",
                                     self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                     self.model.B_GLS.length > 0 ? self.model.B_GLS : @"",
                                     self.model.D_CHASSIS_TIME.length > 0 ? self.model.D_CHASSIS_TIME : @"",
                                     self.model.C_A80000CJ_C_NAME.length > 0 ? self.model.C_A80000CJ_C_NAME : @"",
                                     self.model.C_TYPE_DD_NAME.length > 0 ? self.model.C_TYPE_DD_NAME : @"",
                                     self.model.C_ADDITIONAL_PRODUCTS.length > 0 ? self.model.C_ADDITIONAL_PRODUCTS : @"",
                                     self.model.C_GHCDPQD.length > 0 ? self.model.C_GHCDPQD : @"",
                                     self.model.C_FILE_CITY.length > 0 ? self.model.C_FILE_CITY : @"",
                                     self.model.C_MINI_TRANSFER.length > 0 ? self.model.C_MINI_TRANSFER : @"",
                                     self.model.D_MODIFIED_TIME.length > 0 ? self.model.D_MODIFIED_TIME : @"",
                                     self.model.C_ORIGINAL_LOCATION.length > 0 ? self.model.C_ORIGINAL_LOCATION : @""];
    
    NSArray*section0PostNameArray = @[self.model.C_LOCCODE.length > 0 ? self.model.C_LOCCODE : @"",
                                      self.model.C_VOUCHERID.length > 0 ? self.model.C_VOUCHERID : @"",
                                      self.model.D_ARRIVAL_TIME.length > 0 ? self.model.D_ARRIVAL_TIME : @"",
                                      self.model.C_STATUS_DD_ID.length > 0 ? self.model.C_STATUS_DD_ID : @"",
                                      self.model.C_A70600_C_ID.length > 0 ? [NSString stringWithFormat:@"%@,%@", self.model.C_A70600_C_ID, self.model.C_A49600_C_ID] : @"",
                                      self.model.C_CAR_TYPE.length > 0 ? self.model.C_CAR_TYPE : @"",
                                      self.model.C_W_COLOR.length > 0 ? self.model.C_W_COLOR : @"",
                                      self.model.C_N_COLOR.length > 0 ? self.model.C_N_COLOR : @"",
                                      self.model.C_ENVIRONMENTAL_PROTECTION.length > 0 ? self.model.C_ENVIRONMENTAL_PROTECTION : @"",
                                      self.model.I_SEAT.length > 0 ? self.model.I_SEAT: @"",
                                      self.model.C_YS.length > 0 ? self.model.C_YS : @"",
                                      self.model.C_A80000SZD_C_ID.length > 0 ? self.model.C_A80000SZD_C_ID : @"",
                                      self.model.C_ADDRESS.length > 0 ? self.model.C_ADDRESS : @"",
                                      self.model.C_INFORM_THE_SINGLE.length > 0 ? self.model.C_INFORM_THE_SINGLE : @"",
                                      self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"",
                                      self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                      self.model.B_GLS.length > 0 ? self.model.B_GLS : @"",
                                      self.model.D_CHASSIS_TIME.length > 0 ? self.model.D_CHASSIS_TIME : @"",
                                      self.model.C_A80000CJ_C_ID.length > 0 ? self.model.C_A80000CJ_C_ID : @"",
                                      self.model.C_TYPE_DD_ID.length > 0 ? self.model.C_TYPE_DD_ID : @"",
                                      self.model.C_ADDITIONAL_PRODUCTS.length > 0 ? self.model.C_ADDITIONAL_PRODUCTS : @"",
                                      self.model.C_GHCDPQD.length > 0 ? self.model.C_GHCDPQD : @"",
                                      self.model.C_FILE_CITY.length > 0 ? self.model.C_FILE_CITY : @"",
                                      self.model.C_MINI_TRANSFER.length > 0 ? self.model.C_MINI_TRANSFER : @"",
                                      self.model.D_MODIFIED_TIME.length > 0 ? self.model.D_MODIFIED_TIME : @"",
                                      self.model.C_ORIGINAL_LOCATION.length > 0 ? self.model.C_ORIGINAL_LOCATION : @""];
    
    
   
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    
    for (VideoAndImageModel *model in self.model.fileListYs) {
        [self.fileListYsImageList addObject:model.url];
        [self.fileListYsImage addObject:@{@"saveUrl":  model.saveUrl}];
    }
    
    for (VideoAndImageModel *model in self.model.fileListFp) {
        [self.fileListClImageList addObject:model.url];
        [self.fileListClImage addObject:@{@"saveUrl":  model.saveUrl}];
    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)fileListYsImage {
    if (!_fileListYsImage) {
        _fileListYsImage = [NSMutableArray array];
    }
    return _fileListYsImage;
}

- (NSMutableArray *)fileListClImage {
    if (!_fileListClImage) {
        _fileListClImage = [NSMutableArray array];
    }
    return _fileListClImage;
}

- (NSMutableArray *)fileListYsImageList {
    if (!_fileListYsImageList) {
        _fileListYsImageList = [NSMutableArray array];
    }
    return _fileListYsImageList;
}

- (NSMutableArray *)fileListClImageList {
    if (!_fileListClImageList) {
        _fileListClImageList = [NSMutableArray array];
    }
    return _fileListClImageList;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

- (NSMutableArray *)clImageUrlArray {
    if (!_clImageUrlArray) {
        _clImageUrlArray = [NSMutableArray array];
    }
    return _clImageUrlArray;
}


@end
