//
//  MJKMortgageViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/9/29.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKHighQualityViewController.h"

#import "MJKChooseNewBrandViewController.h"
#import "MJKChooseMoreEmployeesViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKHighQualityModel.h"
#import "MJKProductShowModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKSalesCommentTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKMessageDetailModel.h"
#import "MJKApprovalHistoryModel.h"
#import "MJKCcApprovalTableViewCell.h"

#import "MJKCommentsListModel.h"
#import "MJKPhotoView.h"
#import "VideoAndImageModel.h"

#import "CommentBottomView.h"
#import "CommentView.h"


@interface MJKHighQualityViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#>*/
@property (nonatomic, strong) MJKHighQualityModel *model;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) MJKProductShowModel *productModel;

@property (nonatomic, strong) UITextView *commentText;
@property (nonatomic, strong) UIView *commentNewView;
@property (nonatomic, strong) UIButton *noticeButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) MJKCommentsListModel *addModel;
@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UIButton *proButton;
/** <#注释#> */
@property (nonatomic,strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic,strong) UIButton *submitButton;
/** <#注释#> */
@property (nonatomic, strong) CustomerPhotoView *tableFoot1Photo;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *fileListDjzs;
@property (nonatomic, strong) NSMutableArray *showFileListDjzs;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@property (nonatomic, strong) CommentBottomView *commentBottomView;
/** <#注释#> */
@property (nonatomic, strong) CommentView *cv;


@end

@implementation MJKHighQualityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"精品信息";
    self.view.backgroundColor = [UIColor whiteColor];
    @weakify(self);
    [self getLocalDatas];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.bottomView];
//    [self commentNewView];
    [self getHighQualityInfo];
//    if (self.C_ID.length > 0) {
//        [self httpGetCommentsList];
//        self.addModel = [[MJKCommentsListModel  alloc]init];
//        self.addModel.C_OBJECTID = self.C_ID;
//        self.addModel.type = @"A47500_C_TSPAGE_0032";
//    }
    
    UIView *bottomView = [UIView new];
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(55);
    }];
    
    if (self.C_ID.length > 0) {
        [self httpGetCommentsList];
        self.addModel = [[MJKCommentsListModel  alloc]init];
        self.addModel.C_OBJECTID = self.C_ID;
        _commentBottomView = [CommentBottomView new];
        [bottomView addSubview:_commentBottomView];
        [_commentBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(@0);
        }];
        
        [[_commentBottomView.commentButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            CommentView *cv = [CommentView new];
            self.cv = cv;
            [self.view addSubview:cv];
            [cv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.bottom.top.equalTo(@0);
            }];
            cv.rootVC = self;
            
            [cv.commentTV becomeFirstResponder];
            [[cv.commentTV rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
                self.addModel.X_REMARK = x;
            }];
            cv.chooseImageArrrayBlock = ^(NSArray * _Nonnull imageArray) {
                @strongify(self);
                NSMutableArray *tempImageArray = [NSMutableArray array];
                for (VideoAndImageModel *model in imageArray) {
                    [tempImageArray addObject:[model mj_keyValues]];
                }
                self.addModel.fileList = tempImageArray;
            };
            __weak UIButton *wNotictButton = cv.noticeButton;
            [[cv.noticeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                MJKChooseMoreEmployeesViewController *vc = [[MJKChooseMoreEmployeesViewController alloc]init];
                vc.isAllEmployees = @"是";
                vc.noticeStr = @"无提示";
                if (self.addModel.X_REMINDING.length  > 0) {
                    vc.codeStr = self.addModel.X_REMINDING;
                }
                vc.chooseEmployeesBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull u051CodeStr) {
                    
                    self.addModel.X_REMINDING = u051CodeStr;
                    self.addModel.X_REMINDINGNAME = nameStr;
                    [wNotictButton setTitleNormal:[NSString stringWithFormat:@"@%@", nameStr]];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }];
            [[cv.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                self.addModel.C_OBJECTID = self.model.C_ID;
                
                if (self.addModel.X_REMARK.length <= 0) {
                    [JRToast showWithText:@"请输入评论"];
                    return;
                }
                [self httpCommentsAdd];
            }];
        }];
        if (![[NewUserSession instance].appcode containsObject:@"crm:a806:force_update"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a806:edit"]) {
                _commentBottomView.operationButton.hidden = YES;
            }
        }
        [[_commentBottomView.operationButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            [self submitButtonAction];
        }];
        
    } else {
        UIButton *button = [UIButton new];
        [bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(5);
            make.bottom.right.mas_equalTo(-5);
        }];
        button.layer.cornerRadius = 5.f;
        button.backgroundColor = KNaviColor;
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
           [self submitButtonAction];
            
        }];
    }
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.C_ID.length > 0) {
        return self.localDatas.count + 1;
    }
    return self.localDatas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == self.localDatas.count) {
        return self.dataArray.count;
    } else {
    NSArray *arr = self.localDatas[section];
    return arr.count;
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    @weakify(self);
    if (indexPath.section == self.localDatas.count) {
        if (self.proButton.tag == 100 || self.proButton == nil) {
            MJKCommentsListModel *model = self.dataArray[indexPath.row];
            MJKSalesCommentTableViewCell *cell = [MJKSalesCommentTableViewCell cellWithTableView:tableView];
            cell.rootVC = self;
            cell.model = model;
            cell.reCommentActionBlock = ^{
                weakSelf.addModel.C_FATHERID = model.C_ID;
                
                
                
                    @strongify(self);
                    CommentView *cv = [CommentView new];
                    self.cv = cv;
                    [self.view addSubview:cv];
                    [cv mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.right.bottom.top.equalTo(@0);
                    }];
                    cv.rootVC = self;
                    
                    [cv.commentTV becomeFirstResponder];
                    [[cv.commentTV rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
                        self.addModel.X_REMARK = x;
                    }];
                    cv.chooseImageArrrayBlock = ^(NSArray * _Nonnull imageArray) {
                        @strongify(self);
                        NSMutableArray *tempImageArray = [NSMutableArray array];
                        for (VideoAndImageModel *model in imageArray) {
                            [tempImageArray addObject:[model mj_keyValues]];
                        }
                        self.addModel.fileList = tempImageArray;
                    };
                    __weak UIButton *wNotictButton = cv.noticeButton;
                    [[cv.noticeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                        @strongify(self);
                        MJKChooseMoreEmployeesViewController *vc = [[MJKChooseMoreEmployeesViewController alloc]init];
                        vc.isAllEmployees = @"是";
                        vc.noticeStr = @"无提示";
                        if (self.addModel.X_REMINDING.length  > 0) {
                            vc.codeStr = self.addModel.X_REMINDING;
                        }
                        vc.chooseEmployeesBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull u051CodeStr) {
                            
                            self.addModel.X_REMINDING = u051CodeStr;
                            self.addModel.X_REMINDINGNAME = nameStr;
                            [wNotictButton setTitleNormal:[NSString stringWithFormat:@"@%@", nameStr]];
                        };
                        [self.navigationController pushViewController:vc animated:YES];
                    }];
                    [[cv.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                        @strongify(self);
                        if (self.addModel.X_REMARK.length <= 0) {
                            [JRToast showWithText:@"请输入评论"];
                            return;
                        }
                        self.addModel.C_OBJECTID = self.model.C_ID;
                        [self httpCommentsAdd];
                    }];
                
            };
            return cell;
        } else if (self.proButton.tag == 101) {//审批
            MJKApprovalHistoryModel *model = self.dataArray[indexPath.row];
            MJKCcApprovalTableViewCell *cell = [MJKCcApprovalTableViewCell cellWithTableView:tableView];
            cell.ahModel = model;
            return cell;
        } else if (self.proButton.tag == 102) {//抄送
            MJKMessageDetailModel *model = self.dataArray[indexPath.row];
            MJKCcApprovalTableViewCell *cell = [MJKCcApprovalTableViewCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        }
        
    } else {
    NSMutableArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
    AddCustomerInputTableViewCell *iCell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    iCell.nameTitleLabel.text = model.locatedTitle;
    ccell.nameTitleLabel.text = model.locatedTitle;
    if ([model.locatedTitle isEqualToString:@"精品类型"]) {
        ccell.taglabel.hidden = NO;
        ccell.C_TYPECODE = @"A80600_C_TYPE";
        ccell.Type = ChooseTableViewTypeA80200_C_CPTYPEHIGH;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_TYPE_DD_ID = postValue;
            weakSelf.model.C_TYPE_DD_NAME = str;
            model.postValue = postValue;
            model.nameValue = str;
            weakSelf.model.C_A800JPMC_C_ID = @"";
            weakSelf.model.C_A800JPMC_C_NAME = @"";
            [weakSelf getLocalDatas];
            [tableView reloadData];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"申请日期"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.D_SQRQ = postValue;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"门店"]) {
        ccell.chooseTextField.enabled = NO;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"销售顾问"]) {
        ccell.chooseTextField.enabled = NO;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"是否老客户"])  {
        ccell.Type = chooseTypeIsOutType;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.I_SFLKH = postValue;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"客户姓名"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_KH_NAME = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"客户手机"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.textFieldLength = 11;
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_KH_PHONE = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"品牌车型"])  {
        ccell.taglabel.hidden = NO;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.Type = chooseTypeNil;
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
           MJKChooseNewBrandViewController *vc = [[MJKChooseNewBrandViewController alloc]init];
           vc.rootVC = weakSelf;
            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                MJKProductShowModel *productModel = productArray[0];
                weakSelf.model.C_A70600_C_ID = productModel.C_TYPE_DD_ID;
                weakSelf.model.C_A70600_C_NAME = productModel.C_TYPE_DD_NAME;
                weakSelf.model.C_A49600_C_ID = productModel.C_ID;
                weakSelf.model.C_A49600_C_NAME = productModel.C_NAME;
                model.postValue = productModel.C_ID;
                model.nameValue = productModel.C_NAME;
                    
                    
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
           [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"车架号"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_VIN = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"精品名称"])  {
        ccell.taglabel.hidden = NO;
        ccell.Type = CustomerChooseTypeWithMainDataForA806;
        for (NSArray *tarr in self.localDatas) {
            for (PotentailCustomerEditModel *tmodel in tarr) {
                if ([tmodel.locatedTitle isEqualToString:@"精品类型"]) {
                    if (tmodel.postValue.length > 0) {
                        ccell.C_TYPECODE = [tmodel.postValue isEqualToString:@"A80600_C_TYPE_0000"] ? @"A80000_C_TYPE_0011" : @"A80000_C_TYPE_0012";
                    }
                    
                }
            }
        }
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_A800JPMC_C_ID = postValue;
            weakSelf.model.C_A800JPMC_C_NAME = str;
            model.postValue = postValue;
            model.nameValue = str;
            
            NSMutableArray *starr = self.localDatas[indexPath.section];
            PotentailCustomerEditModel *ssModel = starr[indexPath.row + 1];
            if ([postValue isEqualToString:@"A800-JPMC-094"] ||
                [postValue isEqualToString:@"A800-JPMC-098"]) {//手动填写
                
                if (![ssModel.locatedTitle isEqualToString:@"精品名称(手输)"]) {
                    PotentailCustomerEditModel*smodel=[[PotentailCustomerEditModel alloc]init];
                    smodel.locatedTitle=@"精品名称(手输)";
                    smodel.nameValue=@"";
                    smodel.postValue=@"";
                    smodel.keyValue=@"C_JPMC";
                    [starr insertObject:smodel atIndex:(indexPath.row + 1)];
                }
                
            } else {
                if ([ssModel.locatedTitle isEqualToString:@"精品名称(手输)"]) {
                    [starr removeObjectAtIndex:(indexPath.row + 1)];
                }
            }
            [tableView reloadData];
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"精品名称(手输)"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_JPMC = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"是否赠送"])  {
        ccell.taglabel.hidden = NO;
        ccell.Type = chooseTypeIsOutType;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.I_SFZS = postValue;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"销售价格"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.B_SXJG = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"收款账户"])  {
        ccell.Type = ChooseTableViewTypeA800YJSHZH;
        
            ccell.C_TYPECODE = @"A80000_C_TYPE_0004";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_A800SKZH_C_ID = postValue;
            weakSelf.model.C_A800SKZH_C_NAME = str;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"收款时间"])  {
        ccell.Type = ChooseTableViewTypeBirthday;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.D_SKSJ = postValue;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"未收金额"]) {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.B_WSJE = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"未收款原因"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_WSKYY = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"预计收款时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.D_YJSKSJ = postValue;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"是否开票"])  {
        ccell.Type = chooseTypeIsOutType;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.I_SFKP = postValue;
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"开票单位"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_BILLING = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"施工方"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_SGF = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"施工所需日期"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_SGSXRQ = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"特殊要求说明"]){
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=model.locatedTitle;
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.beforeText=model.nameValue;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_TSYQSM = textStr;
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
        
    } else if ([model.locatedTitle isEqualToString:@"安装技师"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.C_AZJS = textStr;
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"状态"])  {
        iCell.inputTextField.enabled = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        return iCell;
    }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.localDatas.count) {
        if (self.proButton.tag == 100  || self.proButton == nil) {
            CGFloat rowHeight = 10;
            MJKCommentsListModel *model = self.dataArray[indexPath.row];
            NSString *desStr = model.X_REMARK;
            if (model.X_REMINDING.length > 0) {
                desStr = [NSString stringWithFormat:@"%@\n@%@",model.X_REMARK,model.X_REMINDINGNAME];
            }
            CGFloat desHeight = [desStr boundingRectWithSize:CGSizeMake(KScreenWidth - 80, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
            
            
            
            if (desHeight + 55 > 80) {
                rowHeight = desHeight + 55 + 10;
            } else {
                rowHeight = 80;
            }
            if (model.fileList.count > 0) {
                rowHeight += 130;
            }
            
            if (model.replyList.count > 0) {
                for (MJKCommentsListModel *hfModel in model.replyList) {
                    NSString *subDesStr = hfModel.X_REMARK;
                    if (hfModel.X_REMINDING.length > 0) {
                        subDesStr = [NSString stringWithFormat:@"%@\n@%@",hfModel.X_REMARK,hfModel.X_REMINDINGNAME];
                    }
                    CGFloat hfHeight = [subDesStr boundingRectWithSize:CGSizeMake(KScreenWidth - 100, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height;
                    if (hfHeight + 55 > 70) {
                        rowHeight += hfHeight + 55;
                    } else {
                        rowHeight += 70;
                    }
                    if (hfModel.fileList.count > 0) {
                        rowHeight += 130;
                    }
                }
            }
            return rowHeight;
        } else if (self.proButton.tag == 101) {//审批
            return 150;
        } else if (self.proButton.tag == 102) {//抄送
            return 150;
        }
        
    } else {
    NSArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
    if ([model.locatedTitle isEqualToString:@"特殊要求说明"]) {
        return 120;
    }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.localDatas.count) {
        return 44;
    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 180;
    }
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == self.localDatas.count) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        bgView.backgroundColor = kBackgroundColor;
        
        for (int i = 0; i < 3; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth /  3) * i, 0, KScreenWidth / 3, 43)];
            [button setTitle:@[@"评论", @"审批", @"抄送"][i] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [button setTitleColor:[UIColor colorWithHex:@"333333"] forState:UIControlStateNormal];
            button.tag = 100 + i;
            [button addTarget:self action:@selector(sectionButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [bgView addSubview:button];
            if (self.proButton == nil) {
                if (i == 0) {
                    button.backgroundColor = [UIColor  whiteColor];
                    [button setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
                    self.proButton = button;
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, bgView.frame.size.height - 1, button.frame.size.width, 1)];
                    self.sepView = view;
                    view.backgroundColor = KNaviColor;
                    [bgView insertSubview:view atIndex:999];
                }
            } else  {
                if (button.tag == self.proButton.tag) {
                    button.backgroundColor = [UIColor  whiteColor];
                    [button setTitleColor:[UIColor colorWithHex:@"000000"] forState:UIControlStateNormal];
                    self.proButton = button;
                    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, bgView.frame.size.height - 1, button.frame.size.width, 1)];
                    self.sepView = view;
                    view.backgroundColor = KNaviColor;
                    [bgView insertSubview:view atIndex:999];
                }
            }
            
        }
        
        return bgView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
        _tableFoot1Photo = [CustomerPhotoView new];
        [bgView addSubview:_tableFoot1Photo];
        [_tableFoot1Photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(bgView);
            make.height.equalTo(@180);
        }];
        _tableFoot1Photo.tableView = tableView;
        _tableFoot1Photo.imageUrlArray = self.imageUrlArray;
        
        @weakify(self);
        [[self.tableFoot1Photo.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
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

- (void)sectionButtonAction:(UIButton *)sender {
    if (sender.tag == 100) {//评论
        [self httpGetCommentsList];
    } else if (sender.tag == 101) {//审批
        [self httpGetApprovalHistory];
    } else if (sender.tag == 102) {//抄送
        [self httpGetMessageDetailList];
    }
    if (self.proButton.tag != sender.tag) {
        sender.backgroundColor = [UIColor whiteColor];
        [sender setTitleColor:[UIColor colorWithHex:@"#000000"] forState:UIControlStateNormal];
        self.proButton.backgroundColor = kBackgroundColor;
        [self.proButton setTitleColor:[UIColor colorWithHex:@"#333333"] forState:UIControlStateNormal];
        
        self.sepView.centerX = sender.centerX;
        self.proButton = sender;
    }
   
}

- (void)getHighQualityInfo {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A42000_C_ID.length > 0) {
        contentDic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
    }
    if (self.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD806INFO parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
                [weakSelf.showFileListDjzs removeAllObjects];
            weakSelf.model = [MJKHighQualityModel mj_objectWithKeyValues:data[@"data"]];
            
            
            if (![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80600_C_STATUS_0000"]) {
                weakSelf.commentBottomView.operationButton.hidden = YES;
            }
                if ([weakSelf.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0000"] || [weakSelf.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0002"]) {
                    weakSelf.commentBottomView.operationButton.hidden = YES;
                }
            
            if ([weakSelf.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0002"] && [weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80600_C_STATUS_0000"]) {
                weakSelf.commentBottomView.operationButton.hidden = NO;
                [weakSelf.commentBottomView.operationButton setTitle:@"完成" forState:UIControlStateNormal];
            }
            
            [weakSelf.imageUrlArray removeAllObjects];
            [weakSelf.imageUrlArray addObjectsFromArray:weakSelf.model.fileListImage];
            
            [weakSelf getLocalDatas];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)highQualityComplete {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.model.C_ID;
   
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a806/complete", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0012" andSuccessBlock:^{
            [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)highQualityAdd {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.model.C_ID;
    if (self.model.C_A70600_C_ID.length > 0) {
        contentDic[@"C_A70600_C_ID"] = self.model.C_A70600_C_ID;
    }
    if (self.model.C_A70600_C_NAME.length > 0) {
        contentDic[@"C_A70600_C_NAME"] = self.model.C_A70600_C_NAME;
    }
    if (self.model.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.model.C_ID;
    }else {
        if (self.C_A42000_C_ID.length > 0) {
            contentDic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
        }
    }
    
    NSArray *arr = self.localDatas[0];
    for (PotentailCustomerEditModel *model in arr) {
        if ([model.keyValue isEqualToString:@"D_BXRQ"]) {
            if (model.postValue.length > 0 && model.keyValue.length > 0) {
            contentDic[model.keyValue] = [model.postValue stringByAppendingString:@" 00:00:00"];
            }
        } else {
            if (model.postValue.length > 0 && model.keyValue.length > 0) {
                contentDic[model.keyValue] = model.postValue;
            }
        }
    }
    
    if (self.imageUrlArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in self.imageUrlArray) {
            [arr addObject:@{@"saveUrl": model.saveUrl}];
        }
        contentDic[@"fileListImage"] = arr;
    } else {
        contentDic[@"fileListImage"] = @[];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD806ADD parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            if ([self.model.C_TYPE_DD_ID isEqualToString:@"A80600_C_TYPE_0001"]) {//精品售后
//
//                [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0014" andSuccessBlock:^{
                [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }];
//            } else {
//                [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0012" andSuccessBlock:^{
//                    [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }];
//            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)highQualityEdit {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.model.C_ID;
    if (self.model.C_A70600_C_ID.length > 0) {
        contentDic[@"C_A70600_C_ID"] = self.model.C_A70600_C_ID;
    }
    if (self.model.C_A70600_C_NAME.length > 0) {
        contentDic[@"C_A70600_C_NAME"] = self.model.C_A70600_C_NAME;
    }
    if (self.model.C_A42000_C_ID.length > 0) {
        contentDic[@"C_A42000_C_ID"] = self.model.C_A42000_C_ID;
    }else {
        if (self.C_A42000_C_ID.length > 0) {
            contentDic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
        }
    }
    
    NSArray *arr = self.localDatas[0];
    for (PotentailCustomerEditModel *model in arr) {
        if ([model.keyValue isEqualToString:@"D_SQRQ"]) {
            if (model.postValue.length > 0 && model.keyValue.length > 0) {
            contentDic[model.keyValue] = [model.postValue stringByAppendingString:@" 00:00:00"];
            }
        } else {
            if (model.postValue.length > 0 && model.keyValue.length > 0) {
                contentDic[model.keyValue] = model.postValue;
            }
        }
    }
    
    
    if (self.imageUrlArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in self.imageUrlArray) {
            [arr addObject:@{@"saveUrl": model.saveUrl}];
        }
        contentDic[@"fileListImage"] = arr;
    } else {
        contentDic[@"fileListImage"] = @[];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD806EDIT parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            if ([self.model.C_TYPE_DD_ID isEqualToString:@"A80600_C_TYPE_0001"]) {//精品售后
//
//                [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0014" andSuccessBlock:^{
                [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }];
//            } else {
//                [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0012" andSuccessBlock:^{
//                    [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
//                    [weakSelf.navigationController popViewControllerAnimated:YES];
//                }];
//            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submithighQualityInfo {
    if ([self.rootVC isEqualToString:@"新增"]) {
        [self highQualityAdd];
    } else {
        
        if (![[NewUserSession instance].appcode containsObject:@"crm:a806:force_update"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a806:edit"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        [self highQualityEdit];
    }
}


- (void)submitButtonAction {
    if ([self.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0002"]) {
        [self highQualityComplete];
    } else {
        
        for (NSArray *arr in self.localDatas) {
            for (PotentailCustomerEditModel *model in arr) {
                if (model.postValue.length <= 0) {
                    if ([model.locatedTitle isEqualToString:@"精品类型"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请选择%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"精品名称"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请选择%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"精品名称(手输)"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"客户姓名"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"品牌车型"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请选择%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"车架号"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"销售价格"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    if ([model.locatedTitle isEqualToString:@"施工所需日期"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                }
            }
        }
        [self submithighQualityInfo];
    }
}

- (void)httpCommentsAdd {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [self.addModel mj_keyValues];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString  *  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]){
            if (obj.length  >  0) {
                contentDic[key] = obj;
            }
        }
    } ];
    if (self.addModel.fileList.count > 0) {
        contentDic[@"fileList"] = self.addModel.fileList;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMDA465Add parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.addModel = [[MJKCommentsListModel  alloc]init];
            weakSelf.addModel.C_OBJECTID = self.C_ID;
            [weakSelf httpGetCommentsList];
            [weakSelf.cv removeFromSuperview];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}



- (void)httpGetCommentsList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_ID.length > 0) {
        contentDic[@"C_OBJECTID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMDA465List parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.dataArray = [MJKCommentsListModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetMessageDetailList {
    DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"C_OBJECTID"] = self.model.C_ID;
    dict[@"C_TYPE_DD_ID"] = @"A61700_C_TYPE_0011";
//    dict[@"C_OBJECTID"] = self.C_OBJECTID;
    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_A617List parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKMessageDetailModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetApprovalHistory{
    DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"C_OBJECT_ID"] = self.model.C_ID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_ApprovalHistory parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKApprovalHistoryModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}




#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)fileListDjzs {
    if (!_fileListDjzs) {
        _fileListDjzs = [NSMutableArray  array];
    }
    return _fileListDjzs;
}

- (NSMutableArray *)showFileListDjzs {
    if (!_showFileListDjzs) {
        _showFileListDjzs = [NSMutableArray  array];
    }
    return _showFileListDjzs;
}

- (void)getLocalDatas {
        NSArray*localArr=@[@"申请日期",@"门店",@"销售顾问",@"精品类型",@"精品名称",@"客户姓名",@"客户手机",@"是否老客户",@"品牌车型",@"车架号",@"销售价格",@"收款账户",@"收款时间",@"未收金额",@"未收款原因",@"预计收款时间",@"是否赠送",@"是否开票",@"开票单位",@"施工方",@"施工所需日期",@"特殊要求说明",@"安装技师",@"状态"];
        NSArray*localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"",@"0",@"0",@"",@"",@"",@"",@"",@""];
        NSArray*localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"",@"0",@"0",@"",@"",@"",@"",@"",@""];
        NSArray*localKeyArr=@[@"D_SQRQ",@"C_LOCNAME",@"C_OWNER_ROLENAME",@"C_TYPE_DD_ID",@"C_A800JPMC_C_ID",@"C_KH_NAME",@"C_KH_PHONE",@"I_SFLKH",@"C_A49600_C_ID",@"C_VIN",@"B_SXJG",@"C_A800SKZH_C_ID",@"D_SKSJ",@"B_WSJE",@"C_WSKYY",@"D_YJSKSJ",@"I_SFZS",@"I_SFKP",@"C_BILLING",@"C_SGF",@"C_SGSXRQ",@"C_TSYQSM",@"C_AZJS",@"C_STATUS_DD_ID"];
    
    
    if ([self.model.C_TYPE_DD_ID isEqualToString:@"A80600_C_TYPE_0001"]) {
        localArr=@[@"申请日期",@"门店",@"销售顾问",@"精品类型",@"精品名称",@"客户姓名",@"客户手机",@"是否老客户",@"品牌车型",@"车架号",@"施工方",@"施工所需日期",@"特殊要求说明",@"安装技师",@"状态"];
        localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localKeyArr=@[@"D_SQRQ",@"C_LOCNAME",@"C_OWNER_ROLENAME",@"C_TYPE_DD_ID",@"C_A800JPMC_C_ID",@"C_KH_NAME",@"C_KH_PHONE",@"I_SFLKH",@"C_A49600_C_ID",@"C_VIN",@"C_SGF",@"C_SGSXRQ",@"C_TSYQSM",@"C_AZJS",@"C_STATUS_DD_ID"];
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
    
//    if ([self.model.C_TYPE_DD_ID isEqualToString:@"A80600_C_TYPE_0001"]) {
        [self getPostValueAndBeforeValue];
//    }
}

-(void)getPostValueAndBeforeValue{
    
    NSArray*section0ShowNameArray =@[self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                     self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                     self.model.C_TYPE_DD_NAME.length > 0 ? self.model.C_TYPE_DD_NAME : @"",
                                     self.model.C_A800JPMC_C_NAME.length > 0 ? self.model.C_A800JPMC_C_NAME : @"",
                                     self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                     self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                     self.model.I_SFLKH.length > 0 ? ([self.model.I_SFLKH isEqualToString:@"0"] ? @"否" : @"是") : @"",
                                     self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                     self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                     self.model.B_SXJG.length > 0 ? self.model.B_SXJG : @"",
                                     self.model.C_A800SKZH_C_NAME.length > 0 ? self.model.C_A800SKZH_C_NAME : @"",
                                     self.model.D_SKSJ.length > 0 ? self.model.D_SKSJ : @"",
                                     self.model.B_WSJE.length > 0 ? self.model.B_WSJE : @"",
                                     self.model.C_WSKYY.length > 0 ? self.model.C_WSKYY : @"",
                                     self.model.D_YJSKSJ.length > 0 ? self.model.D_YJSKSJ : @"",
                                     self.model.I_SFZS.length > 0 ? ([self.model.I_SFZS isEqualToString:@"0"] ? @"否" : @"是") : @"",
                                     self.model.I_SFKP.length > 0 ? ([self.model.I_SFKP isEqualToString:@"0"] ? @"否" : @"是") : @"",
                                     self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                     self.model.C_SGF.length > 0 ? self.model.C_SGF : @"",
                                     self.model.C_SGSXRQ.length > 0 ? self.model.C_SGSXRQ : @"",
                                     self.model.C_TSYQSM.length > 0 ? self.model.C_TSYQSM : @"",
                                     self.model.C_AZJS.length > 0 ? self.model.C_AZJS : @"",
                                     self.model.C_STATUS_DD_NAME.length > 0 ? self.model.C_STATUS_DD_NAME : @""
                                     ];
    
    NSArray*section0PostNameArray =@[self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                     self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                     self.model.C_TYPE_DD_ID.length > 0 ? self.model.C_TYPE_DD_ID : @"",
                                     self.model.C_A800JPMC_C_ID.length > 0 ? self.model.C_A800JPMC_C_ID : @"",
                                     self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                     self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                     self.model.I_SFLKH.length > 0 ? self.model.I_SFLKH : @"",
                                     self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                     self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                     self.model.B_SXJG.length > 0 ? self.model.B_SXJG : @"",
                                     self.model.C_A800SKZH_C_ID.length > 0 ? self.model.C_A800SKZH_C_ID : @"",
                                     self.model.D_SKSJ.length > 0 ? self.model.D_SKSJ : @"",
                                     self.model.B_WSJE.length > 0 ? self.model.B_WSJE : @"",
                                     self.model.C_WSKYY.length > 0 ? self.model.C_WSKYY : @"",
                                     self.model.D_YJSKSJ.length > 0 ? self.model.D_YJSKSJ : @"",
                                     self.model.I_SFZS.length > 0 ? self.model.I_SFZS : @"",
                                     self.model.I_SFKP.length > 0 ? self.model.I_SFKP : @"",
                                     self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                     self.model.C_SGF.length > 0 ? self.model.C_SGF : @"",
                                     self.model.C_SGSXRQ.length > 0 ? self.model.C_SGSXRQ : @"",
                                     self.model.C_TSYQSM.length > 0 ? self.model.C_TSYQSM : @"",
                                     self.model.C_AZJS.length > 0 ? self.model.C_AZJS : @"",
                                     self.model.C_STATUS_DD_ID.length > 0 ? self.model.C_STATUS_DD_ID : @""
                                     ];
    
    
    if ([self.model.C_TYPE_DD_ID isEqualToString:@"A80600_C_TYPE_0001"]) {
       section0ShowNameArray =@[self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                self.model.C_TYPE_DD_NAME.length > 0 ? self.model.C_TYPE_DD_NAME : @"",
                                self.model.C_A800JPMC_C_NAME.length > 0 ? self.model.C_A800JPMC_C_NAME : @"",
                                self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                self.model.I_SFLKH.length > 0 ? ([self.model.I_SFLKH isEqualToString:@"0"] ? @"否" : @"是") : @"",
                                self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                self.model.C_SGF.length > 0 ? self.model.C_SGF : @"",
                                self.model.C_SGSXRQ.length > 0 ? self.model.C_SGSXRQ : @"",
                                self.model.C_TSYQSM.length > 0 ? self.model.C_TSYQSM : @"",
                                self.model.C_AZJS.length > 0 ? self.model.C_AZJS : @"",
                                self.model.C_STATUS_DD_NAME.length > 0 ? self.model.C_STATUS_DD_NAME : @""
                                ];
        
       section0PostNameArray =@[self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                self.model.C_TYPE_DD_ID.length > 0 ? self.model.C_TYPE_DD_ID : @"",
                                self.model.C_A800JPMC_C_ID.length > 0 ? self.model.C_A800JPMC_C_ID : @"",
                                self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                self.model.I_SFLKH.length > 0 ? self.model.I_SFLKH : @"",
                                self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                self.model.C_SGF.length > 0 ? self.model.C_SGF : @"",
                                self.model.C_SGSXRQ.length > 0 ? self.model.C_SGSXRQ : @"",
                                self.model.C_TSYQSM.length > 0 ? self.model.C_TSYQSM : @"",
                                self.model.C_AZJS.length > 0 ? self.model.C_AZJS : @"",
                                self.model.C_STATUS_DD_ID.length > 0 ? self.model.C_STATUS_DD_ID : @""
                                ];
    }
    
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    
    if ([self.model.C_A800JPMC_C_ID isEqualToString:@"A800-JPMC-094"] ||
        [self.model.C_A800JPMC_C_ID isEqualToString:@"A800-JPMC-098"]) {//手动填写
        for (int i = 0; i < MainArray0.count; i++) {
            PotentailCustomerEditModel *tmodel = MainArray0[i];
            if ([tmodel.locatedTitle isEqualToString:@"精品名称"]) {
                PotentailCustomerEditModel*smodel=[[PotentailCustomerEditModel alloc]init];
                smodel.locatedTitle=@"精品名称(手输)";
                smodel.nameValue=self.model.C_JPMC ? self.model.C_JPMC : @"";
                smodel.postValue=self.model.C_JPMC ? self.model.C_JPMC : @"";
                smodel.keyValue=@"C_JPMC";
                
                [MainArray0 insertObject:smodel atIndex:(i + 1)];
            }
        }
        
    }
    
//    if ([self.model.C_A800JPMC_C_ID isEqualToString:@"A800-JPMC-094"] ||
//        [self.model.C_A800JPMC_C_ID isEqualToString:@"A800-JPMC-098"]) {//手动填写
//        for (int j = 0; j < self.localDatas.count; j++) {
//            NSMutableArray *ttttArr = self.localDatas[j];
//            for (int i = 0; i < ttttArr.count; i++) {
//                PotentailCustomerEditModel *tmodel = ttttArr[i];
//                if ([tmodel.locatedTitle isEqualToString:@"精品名称"]) {
//                    PotentailCustomerEditModel*smodel=[[PotentailCustomerEditModel alloc]init];
//                    smodel.locatedTitle=@"精品名称(手输)";
//                    smodel.nameValue=self.model.C_JPMC ? self.model.C_JPMC : @"";
//                    smodel.postValue=self.model.C_JPMC ? self.model.C_JPMC : @"";
//                    smodel.keyValue=@"C_JPMC";
//
//                    [ttttArr insertObject:smodel atIndex:(i + 1)];
//                }
//            }
//        }
//
//
//    }
    
    [self.tableView reloadData];
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}
@end
