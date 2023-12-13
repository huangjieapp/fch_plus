//
//  MJKMortgageViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/9/29.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKInsuranceViewController.h"

#import "MJKChooseMoreEmployeesViewController.h"
#import "MJKChooseNewBrandViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKInsuranceModel.h"
#import "MJKProductShowModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "MJKSalesCommentTableViewCell.h"

#import "MJKPhotoView.h"

#import "VideoAndImageModel.h"
#import "MJKCommentsListModel.h"


#import "MJKMessageDetailModel.h"
#import "MJKApprovalHistoryModel.h"
#import "MJKCcApprovalTableViewCell.h"

#import "CommentBottomView.h"
#import "CommentView.h"


@interface MJKInsuranceViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#>*/
@property (nonatomic, strong) MJKInsuranceModel *model;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) MJKProductShowModel *productModel;
/** <#注释#> */
@property (nonatomic,strong) CustomerPhotoView *tableFootPhoto;

@property (nonatomic,strong) NSMutableArray *fileListDjzs;
@property (nonatomic,strong) NSMutableArray *showFileListDjzs;


@property (nonatomic, strong) UITextView *commentText;
@property (nonatomic, strong) UIView *commentNewView;
@property (nonatomic,strong) MJKPhotoView *tableCommentPhoto;
@property (nonatomic, strong) UIButton *noticeButton;
@property (nonatomic,strong) NSMutableArray *commentLileList;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) MJKCommentsListModel *addModel;
@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UIButton *proButton;
/** <#注释#> */
@property (nonatomic,strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic,strong) UIButton *submitButton;

/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
/** <#注释#> */
@property (nonatomic, strong) CommentView *cv;
/** <#注释#> */
@property (nonatomic, strong) CommentBottomView *commentBottomView;
@end

@implementation MJKInsuranceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"保险信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self getLocalDatas];
    [self.view addSubview:self.tableView];
//    [self.view addSubview:self.bottomView];
//    [self commentNewView];
    [self getInsuranceInfo];
//    if (self.C_ID.length > 0) {
//        [self httpGetCommentsList];
//        self.addModel = [[MJKCommentsListModel  alloc]init];
//        self.addModel.C_OBJECTID = self.C_ID;
//        self.addModel.type = @"A47500_C_TSPAGE_0032";
//    }
    @weakify(self);
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
        if (![[NewUserSession instance].appcode containsObject:@"crm:a803:force_update"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a803:edit"]) {
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
    NSArray *arr = self.localDatas[indexPath.section];
    PotentailCustomerEditModel *model = arr[indexPath.row];
    AddCustomerInputTableViewCell *iCell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    iCell.nameTitleLabel.text = model.locatedTitle;
    ccell.nameTitleLabel.text = model.locatedTitle;
    if ([model.locatedTitle isEqualToString:@"是否做进"]) {
        ccell.Type = ChooseTableViewTypeSFZJ;
        ccell.C_TYPECODE = @"A803_C_SFZJ";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_SFZJ_DD_ID = postValue;
            weakSelf.model.C_SFZJ_DD_NAME = str;
            model.postValue = postValue;
            model.nameValue = str;
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf getLocalDatas];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"销量"]) {
        ccell.Type = ChooseTableViewTypeXL;
        ccell.C_TYPECODE = @"A80300_C_XL";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"车牌类型"]) {
        ccell.Type = ChooseTableViewTypeXL;
        ccell.C_TYPECODE = @"A80300_C_CPXZ";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"第三者/万"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeXL;
        ccell.C_TYPECODE = @"A80300_C_DSZ";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"保险公司"]) {
        ccell.taglabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"结算状态"]) {
        ccell.Type = ChooseTableViewTypeA800YJSHZH;
        ccell.C_TYPECODE = @"A803_C_JSSTATUS";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"是否除税"]) {
        ccell.Type = chooseTypeIsOutType;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue.integerValue == 0 ? @"否" : @"是";
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"结算账户"]) {
        ccell.Type = ChooseTableViewTypeA800YJSHZH;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0004";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"座位/万"]) {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }  else if ([model.locatedTitle isEqualToString:@"日期"] || [model.locatedTitle isEqualToString:@"保险日期"] || [model.locatedTitle isEqualToString:@"结算日期"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
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
    } else if ([model.locatedTitle isEqualToString:@"客户名称"]) {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"客户电话"]) {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.textFieldLength = 11;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }  else if ([model.locatedTitle isEqualToString:@"车架号"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"是否质保"])  {
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.C_TYPECODE = @"A803_C_SFZB";
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            
            model.nameValue = str;
            model.postValue = postValue;
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"品牌车型"])  {
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
                model.postValue = productModel.C_ID;
                model.nameValue = productModel.C_NAME;
                    
                    
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
           [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"车价"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"开票价"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"交强险"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            
            NSInteger section = 0;
            NSInteger index = 0;
            for (int i = 0; i < self.localDatas.count; i++) {
                NSArray *arr = self.localDatas[i];
                for (int j = 0; j < arr.count; j++) {
                    PotentailCustomerEditModel *model1 = arr[j];
                    if ([model1.locatedTitle isEqualToString:@"合计保费"]) {
                        section   = i;
                        index = j;
                    }
                }
            }
//            PotentailCustomerEditModel *tModel = self.localDatas[section][index];
//            CGFloat mount = tModel.postValue.floatValue;
//            mount += model.postValue.floatValue;
//            tModel.postValue = [NSString stringWithFormat:@"%.2f", mount];
//            tModel.nameValue = tModel.postValue;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"车损保额"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            
            NSInteger section = 0;
            NSInteger index = 0;
            for (int i = 0; i < self.localDatas.count; i++) {
                NSArray *arr = self.localDatas[i];
                for (int j = 0; j < arr.count; j++) {
                    PotentailCustomerEditModel *model1 = arr[j];
                    if ([model1.locatedTitle isEqualToString:@"合计保费"]) {
                        section   = i;
                        index = j;
                    }
                }
            }
//            PotentailCustomerEditModel *tModel = self.localDatas[section][index];
//            CGFloat mount = tModel.postValue.floatValue;
//            mount += model.postValue.floatValue;
//            tModel.postValue = [NSString stringWithFormat:@"%.2f", mount];
//            tModel.nameValue = tModel.postValue;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"新增保额"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            
            NSInteger section = 0;
            NSInteger index = 0;
            for (int i = 0; i < self.localDatas.count; i++) {
                NSArray *arr = self.localDatas[i];
                for (int j = 0; j < arr.count; j++) {
                    PotentailCustomerEditModel *model1 = arr[j];
                    if ([model1.locatedTitle isEqualToString:@"合计保费"]) {
                        section   = i;
                        index = j;
                    }
                }
            }
//            PotentailCustomerEditModel *tModel = self.localDatas[section][index];
//            CGFloat mount = tModel.postValue.floatValue;
//            mount += model.postValue.floatValue;
//            tModel.postValue = [NSString stringWithFormat:@"%.2f", mount];
//            tModel.nameValue = tModel.postValue;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"车船税"]) {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            NSInteger section = 0;
            NSInteger index = 0;
            for (int i = 0; i < self.localDatas.count; i++) {
                NSArray *arr = self.localDatas[i];
                for (int j = 0; j < arr.count; j++) {
                    PotentailCustomerEditModel *model1 = arr[j];
                    if ([model1.locatedTitle isEqualToString:@"合计保费"]) {
                        section   = i;
                        index = j;
                    }
                }
            }
//            PotentailCustomerEditModel *tModel = self.localDatas[section][index];
//            CGFloat mount = tModel.postValue.floatValue;
//            mount += model.postValue.floatValue;
//            tModel.postValue = [NSString stringWithFormat:@"%.2f", mount];
//            tModel.nameValue = tModel.postValue;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"商业险"]) {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            
            NSInteger section = 0;
            NSInteger index = 0;
            for (int i = 0; i < self.localDatas.count; i++) {
                NSArray *arr = self.localDatas[i];
                for (int j = 0; j < arr.count; j++) {
                    PotentailCustomerEditModel *model1 = arr[j];
                    if ([model1.locatedTitle isEqualToString:@"合计保费"]) {
                        section   = i;
                        index = j;
                    }
                }
            }
//            PotentailCustomerEditModel *tModel = self.localDatas[section][index];
//            CGFloat mount = tModel.postValue.floatValue;
//            mount += model.postValue.floatValue;
//            tModel.postValue = [NSString stringWithFormat:@"%.2f", mount];
//            tModel.nameValue = tModel.postValue;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"商业险开始时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"商业险结束时间"]) {
        ccell.Type = ChooseTableViewTypeBirthday;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"状态"])  {
        iCell.inputTextField.enabled = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"附加备注"] || [model.locatedTitle isEqualToString:@"备注"] ||[model.locatedTitle isEqualToString:@"保险内容"] || [model.locatedTitle isEqualToString:@"原因"]){
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        if ([model.locatedTitle isEqualToString:@"原因"]) {
            cell.placeholderStr = @"报告内容要求:\n一是描述签到和沟通的过程,了解实际未做进原因\n二是反思过程中自己是否有工作未做到位的地方,哪些环节错误的沟通机会\n三是今后遇到类似客户应如何改进和处理,需要提前做哪些准本工作,抓住可利用的时机去促使成交";
        }
        cell.topTitleLabel.text=model.locatedTitle;
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.beforeText=model.nameValue;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue=textStr;
            model.postValue=textStr;
        };
        
        
        if (![model.locatedTitle isEqualToString:@"保险内容"]) {
            
            
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
        }
        return cell;
        
    } else if ([model.locatedTitle isEqualToString:@"开票名称"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"划痕险"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 4 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"新增设备险"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 3 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"意外综合险"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            
            NSInteger section = 0;
            NSInteger index = 0;
            for (int i = 0; i < self.localDatas.count; i++) {
                NSArray *arr = self.localDatas[i];
                for (int j = 0; j < arr.count; j++) {
                    PotentailCustomerEditModel *model1 = arr[j];
                    if ([model1.locatedTitle isEqualToString:@"合计保费"]) {
                        section   = i;
                        index = j;
                    }
                }
            }
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"保险出单员"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"商业险返利"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 3 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"交强险返利"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    }  else if ([model.locatedTitle isEqualToString:@"合计保费"])  {
        CGFloat amount = 0;
        for (int i = 0; i < self.localDatas.count; i++) {
            NSArray *arr = self.localDatas[i];
            for (int j = 0; j < arr.count; j++) {
                PotentailCustomerEditModel *model1 = arr[j];
                PotentailCustomerEditModel *tempModel = [[PotentailCustomerEditModel alloc] init];
                if ([model1.locatedTitle isEqualToString:@"商业险"]) {
                    tempModel = weakSelf.localDatas[i][j];
                    amount += tempModel.postValue.floatValue;
                }
                if ([model1.locatedTitle isEqualToString:@"交强险"]) {
                    tempModel = weakSelf.localDatas[i][j];
                    amount += tempModel.postValue.floatValue;
                }
                if ([model1.locatedTitle isEqualToString:@"意外综合险"]) {
                    tempModel = weakSelf.localDatas[i][j];
                    amount += tempModel.postValue.floatValue;
                }
                if ([model1.locatedTitle isEqualToString:@"车损保额"]) {
                    tempModel = weakSelf.localDatas[i][j];
                    amount += tempModel.postValue.floatValue;
                }
                if ([model1.locatedTitle isEqualToString:@"新增保额"]) {
                    tempModel = weakSelf.localDatas[i][j];
                    amount += tempModel.postValue.floatValue;
                }
            }
        }
        iCell.inputTextField.enabled = NO;
        iCell.textStr = [NSString stringWithFormat:@"%.2f", amount];
//        if (model.postValue.length > 0) {
//            iCell.textStr = model.nameValue;
//        }
//        iCell.changeTextBlock = ^(NSString *textStr) {
//            model.nameValue = textStr;
//            model.postValue = textStr;
//        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"附加险合计"])  {
        CGFloat amount = 0;
        NSArray *arr = self.localDatas[indexPath.section];
        PotentailCustomerEditModel *model = arr[indexPath.row - 3];//手续费
        amount += model.postValue.floatValue;
        model = arr[indexPath.row - 4];//手续费
        amount += model.postValue.floatValue;
        iCell.inputTextField.enabled = NO;
        iCell.textStr = [NSString stringWithFormat:@"%.2f", amount];
//        if (model.postValue.length > 0) {
//            iCell.textStr = model.nameValue;
//        }
//        iCell.changeTextBlock = ^(NSString *textStr) {
//            model.nameValue = textStr;
//            model.postValue = textStr;
//        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"保险利润"])  {
        CGFloat amount = 0;
        NSArray *arr = self.localDatas[indexPath.section];
        PotentailCustomerEditModel *model = arr[indexPath.row - 2];//手续费
        amount += model.postValue.floatValue;
        model = arr[indexPath.row - 3];//手续费
        amount += model.postValue.floatValue;
        iCell.inputTextField.enabled = NO;
        iCell.textStr = [NSString stringWithFormat:@"%.2f", amount];
//        if (model.postValue.length > 0) {
//            iCell.textStr = model.nameValue;
//        }
//        iCell.changeTextBlock = ^(NSString *textStr) {
//            model.nameValue = textStr;
//            model.postValue = textStr;
//        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"附加险提成"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"结算金额"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"销售顾问提成"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"经理/副店提成"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"店总提成"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"店助提成"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"保单附件"])  {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        if (self.tableFootPhoto != nil) {
            [self.tableFootPhoto removeFromSuperview];
        }
        
        _tableFootPhoto = [CustomerPhotoView new];
            [cell.contentView addSubview:_tableFootPhoto];
            [_tableFootPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.equalTo(@0);
                make.height.equalTo(@180);
            }];
        _tableFootPhoto.tableView = tableView;
        _tableFootPhoto.imageUrlArray = self.imageUrlArray;
        _tableFootPhoto.titleLabel.text = model.locatedTitle;
            
            @weakify(self);
            [[self.tableFootPhoto.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
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
        
        
        return cell;
    }
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.localDatas.count) {
        if (self.proButton.tag == 100 || self.proButton == nil) {
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
    if ([model.locatedTitle isEqualToString:@"备注"] || [model.locatedTitle isEqualToString:@"保险内容"] ||  [model.locatedTitle isEqualToString:@"附加备注"]) {
        return 120;
    }
        if ([model.locatedTitle isEqualToString:@"原因"]) {
            return 200;
        }
    if ([model.locatedTitle isEqualToString:@"保单附件"]) {
        return 150;
    }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == self.localDatas.count) {
        return 44;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
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
    } else {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    label.text = @[@"基础信息", @"保险信息", @"利润相关"][section];
    [bgView addSubview:label];
    return bgView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
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

- (void)getInsuranceInfo {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A42000_C_ID.length > 0) {
        contentDic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
    }
    if (self.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD803INFO parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            
            [weakSelf.showFileListDjzs removeAllObjects];
            weakSelf.model = [MJKInsuranceModel mj_objectWithKeyValues:data[@"data"]];
            if (![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80300_C_STATUS_0000"]  && ![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80300_C_STATUS_0003"]) {
                weakSelf.commentBottomView.operationButton.hidden = YES;
            }
            [weakSelf.imageUrlArray removeAllObjects];
            [weakSelf.imageUrlArray addObjectsFromArray: weakSelf.model.fileList];
            [weakSelf getLocalDatas];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)insuranceAdd {
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
    
    
    
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
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
        contentDic[@"fileList"] = arr;
    } else {
        contentDic[@"fileList"] = @[];
    }
    
//    NSArray *arr = self.localDatas[0];
//    for (PotentailCustomerEditModel *model in arr) {
//        if ([model.keyValue isEqualToString:@"D_BXRQ"]) {
//            if (model.postValue.length > 0 && model.keyValue.length > 0) {
//            contentDic[model.keyValue] = [model.postValue stringByAppendingString:@" 00:00:00"];
//            }
//        } else {
//            if (model.postValue.length > 0 && model.keyValue.length > 0) {
//                contentDic[model.keyValue] = model.postValue;
//            }
//        }
//    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD803ADD parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0010" andSuccessBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)insuranceEdit {
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
    
    
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
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
        contentDic[@"fileList"] = arr;
    } else {
        contentDic[@"fileList"] = @[];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD803EDIT parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0010" andSuccessBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitInsuranceInfo {
    if ([self.rootVC isEqualToString:@"新增"]) {
        [self insuranceAdd];
    } else {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a803:force_update"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a803:edit"]) {
                [JRToast showWithText:@"账号无权限"];
                return;
            }
        }
        [self insuranceEdit];
    }
}

- (void)submitButtonAction {
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if (model.postValue.length <= 0) {
                if ([model.locatedTitle isEqualToString:@"开票名称"] || [model.locatedTitle isEqualToString:@"开票价"] || [model.locatedTitle isEqualToString:@"车船税"] || [model.locatedTitle isEqualToString:@"商业险"] || [model.locatedTitle isEqualToString:@"交强险"] || [model.locatedTitle isEqualToString:@"车损保额"] || [model.locatedTitle isEqualToString:@"新增保额"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"第三者/万"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                if ([model.locatedTitle isEqualToString:@"划痕险"] || [model.locatedTitle isEqualToString:@"新增设备险"] || [model.locatedTitle isEqualToString:@"意外综合险"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"座位/万"] || [model.locatedTitle isEqualToString:@"保险公司"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请选择%@", model.locatedTitle]];
                    return;
                }
                
                if ([model.locatedTitle isEqualToString:@"保险出单员"] ||[model.locatedTitle isEqualToString:@"商业险返利"] || [model.locatedTitle isEqualToString:@"交强险返利"] || [model.locatedTitle isEqualToString:@"附加险提成"] || [model.locatedTitle isEqualToString:@"销售顾问提成"] || [model.locatedTitle isEqualToString:@"经理/副店提成"] || [model.locatedTitle isEqualToString:@"店总提成"]) {
                    [JRToast showWithText:[NSString stringWithFormat:@"请输入%@", model.locatedTitle]];
                    return;
                }
            }
            
        }
    }
    [self submitInsuranceInfo];
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
            [weakSelf.cv removeFromSuperview];
            [weakSelf httpGetCommentsList];
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
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableView;
}

- (void)getLocalDatas {
    if ([self.model.C_SFZJ_DD_ID isEqualToString:@"A803_C_SFZJ_0001"]) {
        NSArray*localArr=@[@"是否做进",@"门店",@"销售顾问",@"开票名称",@"客户名称",@"客户电话",@"开票价",@"品牌车型",@"车架号",@"是否质保",@"原因"];
        NSArray*localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localKeyArr=@[@"C_SFZJ_DD_ID",@"C_LOCNAME",@"C_OWNER_ROLENAME",@"C_BILLING",@"C_KH_NAME",@"C_KH_PHONE",@"B_KPJ",@"C_A49600_C_ID",@"C_VIN",@"C_SFZB_DD_ID",@"X_SFZJYY"];
        
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
    } else {
        NSArray*localArr=@[@"是否做进",@"销量",@"保险日期",@"保险内容",@"门店",@"销售顾问",@"开票名称",@"客户名称",@"客户电话",@"开票价",@"品牌车型",@"车架号",@"是否质保"];
        NSArray*localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localKeyArr=@[@"C_SFZJ_DD_ID",@"C_XL_DD_ID",@"D_BXRQ",@"X_BXNR",@"C_LOCNAME",@"C_OWNER_ROLENAME",@"C_BILLING",@"C_KH_NAME",@"C_KH_PHONE",@"B_KPJ",@"C_A49600_C_ID",@"C_VIN",@"C_SFZB_DD_ID"];
        
        NSMutableArray*saveLocalArr=[NSMutableArray array];
        for (int i=0; i<localArr.count; i++) {
            PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
            model.locatedTitle=localArr[i];
            model.nameValue=localValueArr[i];
            model.postValue=localPostNameArr[i];
            model.keyValue=localKeyArr[i];
            
            [saveLocalArr addObject:model];
        }
    
    NSArray*localArr1=@[@"车牌类型",@"车船税",@"商业险",@"交强险",@"意外综合险",@"车损保额",@"新增保额",@"合计保费",@"第三者/万",@"划痕险",@"新增设备险",@"座位/万",@"附加险合计",@"保险公司",@"保险出单员",@"保单附件",@"备注"];
    NSArray*localValueArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localPostNameArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localKeyArr1=@[@"C_CPXZ_DD_ID",@"B_CCS",@"B_SYX",@"B_JQX",@"B_YWZHX",@"B_CSBE",@"B_XZBE",@"",@"C_DSZ_DD_ID",@"B_HHX",@"B_XZSBX",@"B_ZWX",@"",@"C_A80000BX_C_ID",@"C_BXCDY",@"",@"X_REMARK"];
    
    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }
    
    NSArray*localArr2=@[@"商业险返利",@"交强险返利",@"附加险提成",@"保险利润",@"结算状态",@"是否除税",@"结算日期",@"结算金额",@"结算账户",@"附加备注"];
    NSArray*localValueArr2=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localPostNameArr2=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localKeyArr2=@[@"B_SYXFL",@"B_JQXFL",@"B_FJXTC",@"",@"C_JSSTATUS_DD_ID",@"I_SFCS",@"D_JSRQ",@"B_JSJE",@"C_A800JSZH_C_ID",@"X_FJCZREMARK"];
    
    NSMutableArray*saveLocalArr2=[NSMutableArray array];
    for (int i=0; i<localArr2.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr2[i];
        model.nameValue=localValueArr2[i];
        model.postValue=localPostNameArr2[i];
        model.keyValue=localKeyArr2[i];
        
        [saveLocalArr2 addObject:model];
    }
    
        if ([[NewUserSession instance].appcode containsObject:@"crm:a803:show_profit"]) {
            self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArr, saveLocalArr1, saveLocalArr2, nil];
        } else {
            
        self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArr, saveLocalArr1, nil];
        }
    }
    [self getPostValueAndBeforeValue];
}

-(void)getPostValueAndBeforeValue{
    if ([self.model.C_SFZJ_DD_ID isEqualToString:@"A803_C_SFZJ_0001"]) {
        NSArray*section0ShowNameArray =@[self.model.C_SFZJ_DD_NAME.length > 0 ? self.model.C_SFZJ_DD_NAME : @"",
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                         self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                         self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                         self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                         self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                         self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.C_SFZB_DD_NAME.length > 0 ? self.model.C_SFZB_DD_NAME : @"",
                                         self.model.X_SFZJYY.length > 0 ? self.model.X_SFZJYY : @""];
        
        NSArray*section0PostNameArray =@[self.model.C_SFZJ_DD_ID.length > 0 ? self.model.C_SFZJ_DD_ID : @"",
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                         self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                         self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                         self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                         self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                         self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.C_SFZB_DD_ID.length > 0 ? self.model.C_SFZB_DD_ID : @"",
                                         self.model.X_SFZJYY.length > 0 ? self.model.X_SFZJYY : @""];
        
        
        
        NSMutableArray*MainArray0=self.localDatas[0];
        for (int i=0; i<MainArray0.count; i++) {
            PotentailCustomerEditModel*model=MainArray0[i];
            model.nameValue=section0ShowNameArray[i];
            model.postValue=section0PostNameArray[i];
        }
    } else {
    NSArray*section0ShowNameArray =@[self.model.C_SFZJ_DD_NAME.length > 0 ? self.model.C_SFZJ_DD_NAME : @"",
                                     self.model.C_XL_DD_NAME.length > 0 ? self.model.C_XL_DD_NAME : @"",
                                     self.model.D_BXRQ.length > 0 ? self.model.D_BXRQ : @"",
                                     self.model.X_BXNR.length > 0 ? self.model.X_BXNR : @"",
                                     self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                     self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                     self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                     self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                     self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                     self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                     self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                     self.model.C_SFZB_DD_NAME.length > 0 ? self.model.C_SFZB_DD_NAME : @""];
    
    NSArray*section0PostNameArray =@[self.model.C_SFZJ_DD_ID.length > 0 ? self.model.C_SFZJ_DD_ID : @"",
                                     self.model.C_XL_DD_ID.length > 0 ? self.model.C_XL_DD_ID : @"",
                                     self.model.D_BXRQ.length > 0 ? self.model.D_BXRQ : @"",
                                     self.model.X_BXNR.length > 0 ? self.model.X_BXNR : @"",
                                     self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                     self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                     self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                     self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                     self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                     self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                     self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                     self.model.C_SFZB_DD_ID.length > 0 ? self.model.C_SFZB_DD_ID : @""];
    
    
    
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    
    
    NSArray*section1ShowNameArray =@[self.model.C_CPXZ_DD_NAME.length > 0 ? self.model.C_CPXZ_DD_NAME : @"",
                                     self.model.B_CCS.length > 0 ? self.model.B_CCS : @"",
                                     self.model.B_SYX.length > 0 ? self.model.B_SYX : @"",
                                     self.model.B_JQX.length > 0 ? self.model.B_JQX : @"",
                                     self.model.B_YWZHX.length > 0 ? self.model.B_YWZHX : @"",
                                     self.model.B_CSBE.length > 0 ? self.model.B_CSBE : @"",
                                     self.model.B_XZBE.length > 0 ? self.model.B_XZBE : @"",
                                     @"",
                                     self.model.C_DSZ_DD_NAME.length > 0 ? self.model.C_DSZ_DD_NAME : @"",
                                     self.model.B_HHX.length > 0 ? self.model.B_HHX : @"",
                                     self.model.B_XZSBX.length > 0 ? self.model.B_XZSBX : @"",
                                     self.model.B_ZWX.length > 0 ? self.model.B_ZWX : @"",
                                     @"",
                                     self.model.C_A80000BX_C_NAME.length > 0 ? self.model.C_A80000BX_C_NAME : @"",
                                     self.model.C_BXCDY.length > 0 ? self.model.C_BXCDY : @"",
                                     @"",
                                     self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @""];
    
    NSArray*section1PostNameArray =@[self.model.C_CPXZ_DD_ID.length > 0 ? self.model.C_CPXZ_DD_ID : @"",
                                     self.model.B_CCS.length > 0 ? self.model.B_CCS : @"",
                                     self.model.B_SYX.length > 0 ? self.model.B_SYX : @"",
                                     self.model.B_JQX.length > 0 ? self.model.B_JQX : @"",
                                     self.model.B_YWZHX.length > 0 ? self.model.B_YWZHX : @"",
                                     self.model.B_CSBE.length > 0 ? self.model.B_CSBE : @"",
                                     self.model.B_XZBE.length > 0 ? self.model.B_XZBE : @"",
                                     @"",
                                     self.model.C_DSZ_DD_ID.length > 0 ? self.model.C_DSZ_DD_ID : @"",
                                     self.model.B_HHX.length > 0 ? self.model.B_HHX : @"",
                                     self.model.B_XZSBX.length > 0 ? self.model.B_XZSBX : @"",
                                     self.model.B_ZWX.length > 0 ? self.model.B_ZWX : @"",
                                     @"",
                                     self.model.C_A80000BX_C_ID.length > 0 ? self.model.C_A80000BX_C_ID : @"",
                                     self.model.C_BXCDY.length > 0 ? self.model.C_BXCDY : @"",
                                     @"",
                                     self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @""];
    
    
    
    NSMutableArray*MainArray1=self.localDatas[1];
    for (int i=0; i<MainArray1.count; i++) {
        PotentailCustomerEditModel*model=MainArray1[i];
        model.nameValue=section1ShowNameArray[i];
        model.postValue=section1PostNameArray[i];
    }
        if ([[NewUserSession instance].appcode containsObject:@"crm:a803:show_profit"]) {
    NSArray*section2ShowNameArray =@[self.model.B_SYXFL.length > 0 ? self.model.B_SYXFL : @"",
                                     self.model.B_JQXFL.length > 0 ? self.model.B_JQXFL : @"",
                                     self.model.B_FJXTC.length > 0 ? self.model.B_FJXTC : @"",
                                     @"",
                                     self.model.C_JSSTATUS_DD_NAME.length > 0 ? self.model.C_JSSTATUS_DD_NAME : @"",
                                     self.model.I_SFCS.length > 0 ? self.model.I_SFCS : @"",
                                     self.model.D_JSRQ.length > 0 ? self.model.D_JSRQ : @"",
                                     self.model.B_JSJE.length > 0 ? self.model.B_JSJE : @"",
                                     self.model.C_A800JSZH_C_NAME.length > 0 ? self.model.C_A800JSZH_C_NAME : @"",
                                     self.model.X_FJCZREMARK.length > 0 ? self.model.X_FJCZREMARK : @""];
    
    NSArray*section2PostNameArray =@[self.model.B_SYXFL.length > 0 ? self.model.B_SYXFL : @"",
                                     self.model.B_JQXFL.length > 0 ? self.model.B_JQXFL : @"",
                                     self.model.B_FJXTC.length > 0 ? self.model.B_FJXTC : @"",
                                     @"",
                                     self.model.C_JSSTATUS_DD_ID.length > 0 ? self.model.C_JSSTATUS_DD_ID : @"",
                                     self.model.I_SFCS.length > 0 ? self.model.I_SFCS : @"",
                                     self.model.D_JSRQ.length > 0 ? self.model.D_JSRQ : @"",
                                     self.model.B_JSJE.length > 0 ? self.model.B_JSJE : @"",
                                     self.model.C_A800JSZH_C_ID.length > 0 ? self.model.C_A800JSZH_C_ID : @"",
                                     self.model.X_FJCZREMARK.length > 0 ? self.model.X_FJCZREMARK : @""];
    
    
    
    NSMutableArray*MainArray2=self.localDatas[2];
    for (int i=0; i<MainArray2.count; i++) {
        PotentailCustomerEditModel*model=MainArray2[i];
        model.nameValue=section2ShowNameArray[i];
        model.postValue=section2PostNameArray[i];
    }
        }
    }
    
    [self.tableView reloadData];
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

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}
@end
