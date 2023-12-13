//
//  MJKCarSourceNewAddOrEditViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCarSourceHomeWLViewController.h"
#import "MJKChooseNewBrandViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKProductShowModel.h"
#import "VideoAndImageModel.h"
#import "MJKCarSourceHomeModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"

@interface MJKCarSourceHomeWLViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#> */
@property (nonatomic, strong) CustomerPhotoView *ysPhotoView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fileListYsImage;
@property (nonatomic, strong) NSMutableArray *fileListClImage;
/** <#注释#> */
@property (nonatomic, strong) MJKCarSourceHomeSubModel *model;
/** <#注释#> */
@property (nonatomic, strong) MJKCarSourceWLModel *wlModel;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fileListYsImageList;
@property (nonatomic, strong) NSMutableArray *fileListClImageList;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@end

@implementation MJKCarSourceHomeWLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    MyLog(@"%@", NSHomeDirectory());
    if (self.C_TYPE_DD_ID.length <= 0) {
        self.C_TYPE_DD_ID = @"A82900_C_TYPE_0002";//调拨
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
    
    if (self.C_ID > 0) {
        _bottomView.hidden = YES;
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(-AdaptSafeBottomHeight );
        }];
        self.title = @"车源物流";
        [self getCarDetail];
    } else {
        
        self.title = @"新增物流";
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
   if ([model.locatedTitle isEqualToString:@"物流类型"]) {
       if (self.C_ID.length > 0) {
           cCell.chooseTextField.enabled = NO;
       } else {
           cCell.chooseTextField.enabled = YES;
       }
        cCell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        cCell.C_TYPECODE = @"A82900_C_TYPE";
        cCell.taglabel.hidden = NO;
        cCell.nameTitleLabel.text = model.locatedTitle;
        if (model.postValue.length > 0) {
            cCell.textStr = model.nameValue;
        }
        cCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            weakSelf.C_TYPE_DD_ID = postValue;
            
            [weakSelf getLocalDatas];
            [tableView reloadData];
        };
        return cCell;
    } else if ([model.locatedTitle isEqualToString:@"调出方"]) {
        if (self.C_ID.length > 0) {
            cCell.chooseTextField.enabled = NO;
        } else {
            cCell.chooseTextField.enabled = YES;
        }
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
    } else if ([model.locatedTitle isEqualToString:@"调入方"]) {
        if (self.C_ID.length > 0) {
            cCell.chooseTextField.enabled = NO;
        } else {
            cCell.chooseTextField.enabled = YES;
        }
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
    } else if ([model.locatedTitle isEqualToString:@"原因"]) {
        if (self.C_ID.length > 0) {
            cCell.chooseTextField.enabled = NO;
        } else {
            cCell.chooseTextField.enabled = YES;
        }
        cCell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        cCell.C_TYPECODE = @"A82900_C_YY";
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
    } else if ([model.locatedTitle isEqualToString:@"是否托运"]) {
        if (self.C_ID.length > 0) {
            cCell.chooseTextField.enabled = NO;
        } else {
            cCell.chooseTextField.enabled = YES;
        }
        cCell.Type = chooseTypeIsOutType;
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
    } else if ([model.locatedTitle isEqualToString:@"是否承担双倍运费"]) {
        if (self.C_ID.length > 0) {
            cCell.chooseTextField.enabled = NO;
        } else {
            cCell.chooseTextField.enabled = YES;
        }
        cCell.Type = chooseTypeIsOutType;
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
        if (self.C_ID.length > 0) {
            cell.textView.editable = NO;
        } else {
            cell.textView.editable = YES;
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
        if (self.C_ID.length > 0) {
            iCell.inputTextField.enabled = NO;
        } else {
            iCell.inputTextField.enabled = YES;
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
    return 180;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    _ysPhotoView = [CustomerPhotoView new];
    [bgView addSubview:_ysPhotoView];
    [_ysPhotoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.height.equalTo(@180);
    }];
    if (self.C_ID.length > 0) {
        _ysPhotoView.isNoEdit = YES;
    } else {
        _ysPhotoView.isNoEdit = NO;
    }
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

- (void)submit {
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length <= 0) {
                
                if ([model.locatedTitle isEqualToString:@"物流类型"] ||
                    [model.locatedTitle isEqualToString:@"调出方"] ||
                    [model.locatedTitle isEqualToString:@"调入方"] ||
                    [model.locatedTitle isEqualToString:@"原因"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
               
            }
        }
    }
    
    [self submitData];
}

- (void)getCarDetail {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a829/info", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            @strongify(self);
            self.wlModel = [MJKCarSourceWLModel mj_objectWithKeyValues:data[@"data"]];
            
            [self getPostValueAndBeforeValue];
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)getPostValueAndBeforeValue{
    NSArray*section0ShowNameArray =@[];
    
    NSArray*section0PostNameArray = @[];
    
    
    if ([self.C_TYPE_DD_ID isEqualToString:@"A82900_C_TYPE_0000"]) {//出库
        section0ShowNameArray =@[self.wlModel.C_TYPE_DD_NAME.length > 0 ? self.wlModel.C_TYPE_DD_NAME : @"出库",
                                         self.wlModel.C_A80000DCF_C_NAME.length > 0 ? self.wlModel.C_A80000DCF_C_NAME : self.C_A80000_DD_NAME,
                                         self.wlModel.C_YY_DD_NAME.length > 0 ? self.wlModel.C_YY_DD_NAME : @"",
                                         self.wlModel.C_ADDRESS.length > 0 ? self.wlModel.C_ADDRESS : @"",
                                         self.wlModel.I_SFTY.length > 0 ? self.wlModel.I_SFTY : @"",
                                         self.wlModel.I_SFCDSBYF.length > 0 ? self.wlModel.I_SFCDSBYF : @"",
                                         self.wlModel.C_WLGS.length > 0 ? self.wlModel.C_WLGS: @"",
                                         self.wlModel.B_YF.length > 0 ? self.wlModel.B_YF : @"",
                                         self.wlModel.C_BCSJ.length > 0 ? self.wlModel.C_BCSJ : @"",
                                         self.wlModel.C_PHONE.length > 0 ? self.wlModel.C_PHONE : @"",
                                         self.wlModel.X_REMARK.length > 0 ? self.wlModel.X_REMARK : @""];
        
        section0PostNameArray = @[self.wlModel.C_TYPE_DD_ID.length > 0 ? self.wlModel.C_TYPE_DD_ID : @"A82900_C_TYPE_0000",
                                          self.wlModel.C_A80000DCF_C_ID.length > 0 ? self.wlModel.C_A80000DCF_C_ID : self.C_A80000_DD_ID,
                                          self.wlModel.C_YY_DD_ID.length > 0 ? self.wlModel.C_YY_DD_ID : @"",
                                          self.wlModel.C_ADDRESS.length > 0 ? self.wlModel.C_ADDRESS : @"",
                                          self.wlModel.I_SFTY.length > 0 ? self.wlModel.I_SFTY : @"",
                                          self.wlModel.I_SFCDSBYF.length > 0 ? self.wlModel.I_SFCDSBYF : @"",
                                          self.wlModel.C_WLGS.length > 0 ? self.wlModel.C_WLGS: @"",
                                          self.wlModel.B_YF.length > 0 ? self.wlModel.B_YF : @"",
                                          self.wlModel.C_BCSJ.length > 0 ? self.wlModel.C_BCSJ : @"",
                                          self.wlModel.C_PHONE.length > 0 ? self.wlModel.C_PHONE : @"",
                                          self.wlModel.X_REMARK.length > 0 ? self.wlModel.X_REMARK : @""];
    } else if ([self.C_TYPE_DD_ID isEqualToString:@"A82900_C_TYPE_0001"]) {//入库
        section0ShowNameArray =@[self.wlModel.C_TYPE_DD_NAME.length > 0 ? self.wlModel.C_TYPE_DD_NAME : @"入库",
                                         self.wlModel.C_A80000DRF_C_NAME.length > 0 ? self.wlModel.C_A80000DRF_C_NAME : self.C_A80000_DD_NAME,
                                         self.wlModel.C_YY_DD_NAME.length > 0 ? self.wlModel.C_YY_DD_NAME : @"",
                                         self.wlModel.C_ADDRESS.length > 0 ? self.wlModel.C_ADDRESS : @"",
                                         self.wlModel.I_SFTY.length > 0 ? self.wlModel.I_SFTY : @"",
                                         self.wlModel.I_SFCDSBYF.length > 0 ? self.wlModel.I_SFCDSBYF : @"",
                                         self.wlModel.C_WLGS.length > 0 ? self.wlModel.C_WLGS: @"",
                                         self.wlModel.B_YF.length > 0 ? self.wlModel.B_YF : @"",
                                         self.wlModel.C_BCSJ.length > 0 ? self.wlModel.C_BCSJ : @"",
                                         self.wlModel.C_PHONE.length > 0 ? self.wlModel.C_PHONE : @"",
                                         self.wlModel.X_REMARK.length > 0 ? self.wlModel.X_REMARK : @""];
        
        section0PostNameArray = @[self.wlModel.C_TYPE_DD_ID.length > 0 ? self.wlModel.C_TYPE_DD_ID : @"A82900_C_TYPE_0001",
                                          self.wlModel.C_A80000DRF_C_ID.length > 0 ? self.wlModel.C_A80000DRF_C_ID : self.C_A80000_DD_ID,
                                          self.wlModel.C_YY_DD_ID.length > 0 ? self.wlModel.C_YY_DD_ID : @"",
                                          self.wlModel.C_ADDRESS.length > 0 ? self.wlModel.C_ADDRESS : @"",
                                          self.wlModel.I_SFTY.length > 0 ? self.wlModel.I_SFTY : @"",
                                          self.wlModel.I_SFCDSBYF.length > 0 ? self.wlModel.I_SFCDSBYF : @"",
                                          self.wlModel.C_WLGS.length > 0 ? self.wlModel.C_WLGS: @"",
                                          self.wlModel.B_YF.length > 0 ? self.wlModel.B_YF : @"",
                                          self.wlModel.C_BCSJ.length > 0 ? self.wlModel.C_BCSJ : @"",
                                          self.wlModel.C_PHONE.length > 0 ? self.wlModel.C_PHONE : @"",
                                          self.wlModel.X_REMARK.length > 0 ? self.wlModel.X_REMARK : @""];
    } else if ([self.C_TYPE_DD_ID isEqualToString:@"A82900_C_TYPE_0002"]) {
        section0ShowNameArray =@[self.wlModel.C_TYPE_DD_NAME.length > 0 ? self.wlModel.C_TYPE_DD_NAME : @"调拨",
                                         self.wlModel.C_A80000DCF_C_NAME.length > 0 ? self.wlModel.C_A80000DCF_C_NAME : self.C_A80000_DD_NAME,
                                         self.wlModel.C_A80000DRF_C_NAME.length > 0 ? self.wlModel.C_A80000DRF_C_NAME : @"",
                                         self.wlModel.C_YY_DD_NAME.length > 0 ? self.wlModel.C_YY_DD_NAME : @"",
                                         self.wlModel.C_ADDRESS.length > 0 ? self.wlModel.C_ADDRESS : @"",
                                         self.wlModel.I_SFTY.length > 0 ? self.wlModel.I_SFTY : @"",
                                         self.wlModel.I_SFCDSBYF.length > 0 ? self.wlModel.I_SFCDSBYF : @"",
                                         self.wlModel.C_WLGS.length > 0 ? self.wlModel.C_WLGS: @"",
                                         self.wlModel.B_YF.length > 0 ? self.wlModel.B_YF : @"",
                                         self.wlModel.C_BCSJ.length > 0 ? self.wlModel.C_BCSJ : @"",
                                         self.wlModel.C_PHONE.length > 0 ? self.wlModel.C_PHONE : @"",
                                         self.wlModel.X_REMARK.length > 0 ? self.wlModel.X_REMARK : @""];
        
        section0PostNameArray = @[self.wlModel.C_TYPE_DD_ID.length > 0 ? self.wlModel.C_TYPE_DD_ID : @"A82900_C_TYPE_0002",
                                          self.wlModel.C_A80000DCF_C_ID.length > 0 ? self.wlModel.C_A80000DCF_C_ID : self.C_A80000_DD_ID,
                                          self.wlModel.C_A80000DRF_C_ID.length > 0 ? self.wlModel.C_A80000DRF_C_ID : @"",
                                          self.wlModel.C_YY_DD_ID.length > 0 ? self.wlModel.C_YY_DD_ID : @"",
                                          self.wlModel.C_ADDRESS.length > 0 ? self.wlModel.C_ADDRESS : @"",
                                          self.wlModel.I_SFTY.length > 0 ? self.wlModel.I_SFTY : @"",
                                          self.wlModel.I_SFCDSBYF.length > 0 ? self.wlModel.I_SFCDSBYF : @"",
                                          self.wlModel.C_WLGS.length > 0 ? self.wlModel.C_WLGS: @"",
                                          self.wlModel.B_YF.length > 0 ? self.wlModel.B_YF : @"",
                                          self.wlModel.C_BCSJ.length > 0 ? self.wlModel.C_BCSJ : @"",
                                          self.wlModel.C_PHONE.length > 0 ? self.wlModel.C_PHONE : @"",
                                          self.wlModel.X_REMARK.length > 0 ? self.wlModel.X_REMARK : @""];
    }
    
    
   
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    [self.imageUrlArray removeAllObjects];
    [self.imageUrlArray addObjectsFromArray:self.wlModel.fileList];
    
    
    [self.tableView reloadData];
}

- (void)submitData {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length > 0) {
                contentDic[model.keyValue] = model.postValue;
                
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
    contentDic[@"C_A82300_C_ID"] = self.C_A82300_C_ID;

    NSString *path = [NSString stringWithFormat:@"%@/api/crm/a823/cywl", HTTP_IP];
    
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:path parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] intValue] == 200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


- (void)getLocalDatas {
    //调拨
    NSArray*localArr=@[];
    NSArray*localValueArr=@[];
    NSArray*localPostNameArr=@[];
    NSArray*localKeyArr=@[];
    
    if ([self.C_TYPE_DD_ID isEqualToString:@"A82900_C_TYPE_0000"]) {//出库
        localArr=@[@"物流类型",@"调出方",@"原因",@"详细地址",@"是否托运",@"是否承担双倍运费",@"物流公司",@"运费",@"板车司机",@"联系方式",@"备注"];
        localValueArr=@[@"出库",self.C_A80000_DD_NAME ?: @"",@"",@"",@"否",@"否",@"",@"",@"",@"",@""];
        localPostNameArr=@[@"A82900_C_TYPE_0000",self.C_A80000_DD_ID ?: @"",@"",@"",@"0",@"0",@"",@"",@"",@"",@""];
        localKeyArr=@[@"C_TYPE_DD_ID",@"C_A80000DCF_C_ID",@"C_YY_DD_ID",@"C_ADDRESS",@"I_SFTY",@"I_SFCDSBYF",@"C_WLGS",@"B_YF",@"C_BCSJ",@"C_PHONE",@"X_REMARK"];
    } else if ([self.C_TYPE_DD_ID isEqualToString:@"A82900_C_TYPE_0001"]) {//入库
        localArr=@[@"物流类型",@"调入方",@"原因",@"详细地址",@"是否托运",@"是否承担双倍运费",@"物流公司",@"运费",@"板车司机",@"联系方式",@"备注"];
        localValueArr=@[@"入库",self.C_A80000_DD_NAME ?: @"",@"",@"",@"否",@"否",@"",@"",@"",@"",@""];
        localPostNameArr=@[@"A82900_C_TYPE_0001",self.C_A80000_DD_ID ?: @"",@"",@"",@"0",@"0",@"",@"",@"",@"",@""];
        localKeyArr=@[@"C_TYPE_DD_ID",@"C_A80000DRF_C_ID",@"C_YY_DD_ID",@"C_ADDRESS",@"I_SFTY",@"I_SFCDSBYF",@"C_WLGS",@"B_YF",@"C_BCSJ",@"C_PHONE",@"X_REMARK"];
    } else if ([self.C_TYPE_DD_ID isEqualToString:@"A82900_C_TYPE_0002"]) {
        localArr=@[@"物流类型",@"调出方",@"调入方",@"原因",@"详细地址",@"是否托运",@"是否承担双倍运费",@"物流公司",@"运费",@"板车司机",@"联系方式",@"备注"];
        localValueArr=@[@"调拨",self.C_A80000_DD_NAME ?: @"",@"",@"",@"",@"否",@"否",@"",@"",@"",@"",@""];
                        localPostNameArr=@[@"A82900_C_TYPE_0002",self.C_A80000_DD_ID ?: @"",@"",@"",@"",@"0",@"0",@"",@"",@"",@"",@""];
        localKeyArr=@[@"C_TYPE_DD_ID",@"C_A80000DCF_C_ID",@"C_A80000DRF_C_ID",@"C_YY_DD_ID",@"C_ADDRESS",@"I_SFTY",@"I_SFCDSBYF",@"C_WLGS",@"B_YF",@"C_BCSJ",@"C_PHONE",@"X_REMARK"];
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
