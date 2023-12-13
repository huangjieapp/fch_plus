//
//  MJKOldCustomerSalesViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/11/4.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKOldCustomerSalesViewController.h"
#import "MJKChooseNewBrandViewController.h"
#import "MJKChooseMoreEmployeesViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKPhotoView.h"
#import "MJKCustomerFeedbackCompleteViewController.h"
#import "MJKCustomerFeedbackOperationViewController.h"
#import "BrokerOldCustomerVC.h"
#import "MJKAllOrderViewController.h"

#import "MJKOldCustomerSalesModel.h"
#import "MJKProductShowModel.h"
#import "MJKCommentsListModel.h"
#import "VideoAndImageModel.h"
#import "MJKClueListSubModel.h"
#import "PotentailCustomerListDetailModel.h"
#import "CGCOrderDetailModel.h"

#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "MJKSalesCommentTableViewCell.h"
#import "GSPSVideoCell.h"
#import "MJKAfterServerProblemTableViewCell.h"


#import "MJKMessageDetailModel.h"
#import "MJKApprovalHistoryModel.h"
#import "MJKCcApprovalTableViewCell.h"
#import "CommentBottomView.h"
#import "CommentView.h"

#import "MJKAdditionalInfoModel.h"


#import "MJKPhotoView.h"

@interface MJKOldCustomerSalesViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *cellArray;
/** <#注释#>*/
@property (nonatomic, strong) MJKOldCustomerSalesModel *model;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *commentButton;

@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto1;
@property (nonatomic, strong) MJKPhotoView *tableFoot1Photo;
/** u*/
@property (nonatomic, strong) UIView *commentNewView;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *noticeButton;

@property (nonatomic, strong) NSString *IDStr;
@property (nonatomic, strong) UIView *commentsView;
@property (nonatomic, strong) UITextView *commentText;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic,strong) NSMutableArray *fileListGzVideo;

@property (nonatomic,strong) NSMutableArray *fileListGzImage;
@property (nonatomic,strong) NSMutableArray *showFileListGzImage;
@property (nonatomic,strong) NSMutableArray *commentLileList;

/** <#注释#>*/
@property (nonatomic, strong) MJKCommentsListModel *addModel;

/** <#注释#> */
@property (nonatomic,strong) MJKPhotoView *tableCommentPhoto;
@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UIButton *proButton;

@property (nonatomic, strong) NSMutableArray *glArray;
@property (nonatomic, strong) NSMutableArray *glNameArray;
@property (nonatomic, strong) NSMutableArray *mtArray;
@property (nonatomic, strong) NSMutableArray *postArray;
@property (nonatomic, strong) NSArray *typeAllArray;

@property (nonatomic,strong) NSMutableArray *fileListGlsImage;
@property (nonatomic,strong) NSMutableArray *fileListXszImage;
@property (nonatomic,strong) NSMutableArray *showFileListGlsImage;
@property (nonatomic,strong) NSMutableArray *showFileListXszImage;
/** <#注释#> */
@property (nonatomic, strong) CommentBottomView *commentBottomView;
/** <#注释#> */
@property (nonatomic, strong) CommentView *cv;
@end

@implementation MJKOldCustomerSalesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"售后信息";
//    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
//    [self commentNewView];
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
        if (![[NewUserSession instance].appcode containsObject:@"crm:a815:force_update"]) {
                _commentBottomView.operationButton.hidden = YES;
            
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
    
    
    [self getDictDataListDatasWithDictType];
}


- (void)textViewDidBeginEditing:(UITextView *)textView  {
    CGRect commentViewFrame = self.commentNewView.frame;
    commentViewFrame.origin.y = KScreenHeight - 350 - commentViewFrame.size.height - 30;
    self.commentNewView.frame = commentViewFrame;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    CGRect commentViewFrame = self.commentNewView.frame;
    commentViewFrame.origin.y = KScreenHeight;
    self.commentNewView.frame = commentViewFrame;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.C_ID.length > 0) {
        return 4;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        if (section == 3) {
            return self.dataArray.count;
        } else if (section == 2) {
            return 1;
        } else {
            NSArray  *arr = self.cellArray[section];
        return arr.count;
        }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    @weakify(self);
    if (indexPath.section == 3) {
        if (self.proButton.tag == 100  || self.proButton == nil) {
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
        
    } else if(indexPath.section == 2) {
        GSPSVideoCell *cell = [GSPSVideoCell cellWithTableView:tableView];
        cell.indexPath = indexPath;
        cell.rootVC = self;
        cell.oldModel = self.model;
        cell.urlBackBlock = ^(VideoAndImageModel * _Nonnull model) {
            [weakSelf.fileListGzVideo addObject:model];
            weakSelf.model.fileListGzVideo = weakSelf.fileListGzVideo;
        };
        return cell;
    } else {
        NSString *cellStr = self.cellArray[indexPath.section][indexPath.row];
        AddCustomerChooseTableViewCell *ccell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        ccell.nameTitleLabel.text = cellStr;
        AddCustomerInputTableViewCell *icell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        icell.nameTitleLabel.text = cellStr;
        if ([cellStr isEqualToString:@"客户"]) {
            if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
                if (self.model.C_KH_NAME_TEM.length > 0) {
                    icell.textStr = self.model.C_KH_NAME_TEM;
                }
                icell.inputTextField.enabled = NO;
            } else {
                if (self.C_ID > 0) {
                    if (self.model.C_KH_NAME.length > 0) {
                        icell.textStr = self.model.C_KH_NAME;
                    }
                    icell.changeTextBlock = ^(NSString *textStr) {
                        weakSelf.model.C_KH_NAME = textStr;
                    };
                } else {
                    if (self.model.C_KH_NAME_TEM.length > 0) {
                        icell.textStr = self.model.C_KH_NAME_TEM;
                    }
                    icell.inputTextField.enabled = NO;
                }
            }
            icell.inputRightValue.constant = 60;
            icell.followImage.hidden = NO;
            icell.navButton.hidden = NO;
            [[[icell.navButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:icell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
                BrokerOldCustomerVC *vc = [BrokerOldCustomerVC new];
                PotentailCustomerListDetailModel *model = [PotentailCustomerListDetailModel new];
                model.C_ID = weakSelf.model.C_A47700_C_ID;
                vc.mainModel = model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }];
            return icell;
        } else if ([cellStr isEqualToString:@"客户电话"]) {
            if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
                if (self.model.C_KH_PHONE_TEM.length > 0) {
                    icell.textStr = self.model.C_KH_PHONE_TEM;
                }
                
                icell.inputTextField.enabled = NO;
            } else {
                if (self.C_ID > 0) {
                    if (self.model.C_KH_PHONE.length > 0) {
                        icell.textStr = self.model.C_KH_PHONE;
                    }
                    icell.changeTextBlock = ^(NSString *textStr) {
                        weakSelf.model.C_KH_PHONE = textStr;
                    };
                } else {
                    if (self.model.C_KH_PHONE_TEM.length > 0) {
                        icell.textStr = self.model.C_KH_PHONE_TEM;
                    }
                    icell.inputTextField.enabled = NO;
                }
            }
           
            icell.textFieldLength = 11;
            icell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            return icell;
        } else if ([cellStr isEqualToString:@"售后对接人"]) {
            icell.tagLabel.hidden = NO;
            if (self.model.C_KH_NAME.length > 0) {
                icell.textStr = self.model.C_KH_NAME;
            }
            icell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_KH_NAME = textStr;
            };
            return icell;
        } else if ([cellStr isEqualToString:@"对接人电话"]) {
            icell.tagLabel.hidden = NO;
            if (self.model.C_KH_PHONE.length > 0) {
                icell.textStr = self.model.C_KH_PHONE;
            }
            icell.textFieldLength = 11;
            icell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
            icell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_KH_PHONE = textStr;
            };
            return icell;
        }  else if ([cellStr isEqualToString:@"售后类型"]) {
            ccell.taglabel.hidden = NO;
            if (self.model.C_TYPE_DD_ID.length > 0) {
                ccell.textStr = self.model.C_TYPE_DD_NAME;
            }
            ccell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
            ccell.C_TYPECODE = @"A81500_C_TYPE";
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.C_TYPE_DD_NAME = str;
                weakSelf.model.C_TYPE_DD_ID = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"订单"]) {
            ccell.taglabel.hidden = NO;
            if (self.model.C_A42000_C_ID.length > 0) {
                ccell.textStr = self.model.C_A42000_C_NAME;
            }
            ccell.Type = chooseTypeNil;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MJKAllOrderViewController *vc = [MJKAllOrderViewController new];
                vc.C_A41500_C_ID = self.C_A41500_C_ID;
                vc.chooseOrderBlock = ^(CGCOrderDetailModel * _Nonnull orderModel) {
                    weakSelf.model.C_A42000_C_NAME = orderModel.C_BUYNAME;
                    weakSelf.model.C_A42000_C_ID = orderModel.C_ID;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"紧急程度"]) {
            ccell.taglabel.hidden = NO;
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
        } else if ([cellStr isEqualToString:@"维修人员类型"]) {
            if (self.model.C_WXRYTYPE_DD_ID.length > 0) {
                ccell.textStr = self.model.C_WXRYTYPE_DD_NAME;
            }
            ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
            ccell.C_TYPECODE = @"A81500_C_WXRYTYPE";
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.C_WXRYTYPE_DD_NAME = str;
                weakSelf.model.C_WXRYTYPE_DD_ID = postValue;
                weakSelf.model.C_WXRY_ROLEID = [NewUserSession instance].user.u051Id;
                weakSelf.model.C_WXRY_ROLENAME = [NewUserSession instance].user.nickName;
                NSInteger section = 0;
                NSInteger index = 0;
                for (int i = 0; i < weakSelf.cellArray.count; i++) {
                    NSArray *arr = weakSelf.cellArray[i];
                    for (int j = 0; j < arr.count; j++) {
                        NSString *str = arr[j];
                        if ([str isEqualToString:@"维修人员"]) {
                            section = i;
                            index = j;
                        }
                    }
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath, [NSIndexPath indexPathForRow:index inSection:section]] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"厂家"]) {
            ccell.taglabel.hidden = NO;
            ccell.Type = ChooseTableViewTypeA80000_C_TYPE;
            ccell.C_TYPECODE = @"A80000_C_TYPE_0006";
            ccell.nameTitleLabel.text = cellStr;
            if (self.model.C_A80000CJ_C_ID.length > 0) {
                ccell.textStr = self.model.C_A80000CJ_C_NAME;
            }
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.C_A80000CJ_C_ID = postValue;
                weakSelf.model.C_A80000CJ_C_NAME = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"品牌车型"]) {
            ccell.taglabel.hidden = YES;
            if (self.model.C_A49600_C_ID.length > 0) {
                ccell.textStr = self.model.C_A49600_C_NAME;
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
                        
                        
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
               [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"具体型号"]) {
//            if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) { //展厅售后
//                icell.tagLabel.hidden = YES;
//            } else {
//                icell.tagLabel.hidden = NO;
//            }
            if (self.model.C_JTXH.length > 0) {
                icell.textStr = self.model.C_JTXH;
            }
            icell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_JTXH = textStr;
            };
            return icell;
        } else if ([cellStr isEqualToString:@"车架号"]) {
            if (self.model.C_VIN.length > 0) {
                icell.textStr = self.model.C_VIN;
            }
            icell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_VIN = textStr;
            };
            return icell;
        } else if ([cellStr isEqualToString:@"报修日期"]) {
            if (self.C_ID.length > 0) {
                ccell.chooseTextField.enabled = NO;
            } else {
                ccell.chooseTextField.enabled = YES;
            }
            if (self.model.D_BXRQ.length > 0) {
                ccell.textStr = self.model.D_BXRQ;
            }
            ccell.Type = ChooseTableViewTypeAllTime;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.D_BXRQ = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"责任人"]) {
            ccell.taglabel.hidden = YES;
            ccell.Type = chooseTypeNil;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                vc.isAllEmployees = @"是";
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                    weakSelf.model.C_OWNER_ROLENAME=model.nickName;
                    weakSelf.model.C_OWNER_ROLEID=model.u051Id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            if (self.model.C_OWNER_ROLENAME.length > 0) {
                ccell.textStr = self.model.C_OWNER_ROLENAME;
            }
            return ccell;
        } else if ([cellStr isEqualToString:@"销售顾问"]) {
            ccell.taglabel.hidden = NO;
            ccell.Type = chooseTypeNil;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
        //        vc.isAllEmployees = @"是";
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                    weakSelf.model.C_XSGW_ROLENAME=model.nickName;
                    weakSelf.model.C_XSGW_ROLEID=model.u051Id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:vc animated:YES];
            };
            
            if (self.model.C_XSGW_ROLENAME.length > 0) {
                ccell.textStr = self.model.C_XSGW_ROLENAME;
            }
            return ccell;
        } else if ([cellStr isEqualToString:@"销售日期"]) {
            if (self.model.D_JCRQ.length > 0) {
                ccell.textStr = self.model.D_JCRQ;
            }
            ccell.Type = ChooseTableViewTypeBirthday;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.D_JCRQ = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"是否过保"]) {
            if (self.model.I_SFGB.length > 0) {
                ccell.textStr = [self.model.I_SFGB isEqualToString:@"1"] ? @"是" : @"否";
            }
            ccell.Type = chooseTypeIsOutType;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.I_SFGB = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"车辆所在地"]) {
            if (self.model.C_CLSZD.length > 0) {
                icell.textStr = self.model.C_CLSZD;
            }
            icell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_CLSZD = textStr;
            };
            return icell;
        } else if ([cellStr isEqualToString:@"售后问题点"]) {
            MJKAfterServerProblemTableViewCell *pcell = [MJKAfterServerProblemTableViewCell cellWithTableView:tableView];
            pcell.nameTitleLabel.text = cellStr;
            pcell.mustLabel.hidden = NO;
                
//                        weakSelf.cdxfmtArray = mtArray;

            pcell.glNameArray = weakSelf.glNameArray;
            pcell.typeArr = self.mtArray;

            pcell.buttonActionBlock = ^(NSString * _Nonnull tagStr, NSInteger tag) {
                    if ([tagStr isEqualToString:@"selected"]) {
                        [weakSelf.glArray addObject:self.postArray[tag]];
                        [weakSelf.glNameArray addObject:self.mtArray[tag]];
                    } else {
                        [weakSelf.glArray removeObject:self.postArray[tag]];
                        [weakSelf.glNameArray removeObject:self.mtArray[tag]];
                    }
                weakSelf.model.shwtdArray = weakSelf.glArray;
//                    model.postValue = [weakSelf.glArray componentsJoinedByString:@","];
//                    model.nameValue = [weakSelf.glNameArray componentsJoinedByString:@","];
//                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
            

            return pcell;
//            icell.tagLabel.hidden = NO;
//            if (self.model.C_SHWTD.length > 0) {
//                icell.textStr = self.model.C_SHWTD;
//            }
//            icell.changeTextBlock = ^(NSString *textStr) {
//                weakSelf.model.C_SHWTD = textStr;
//            };
//            return icell;
        } else if ([cellStr isEqualToString:@"报修问题描述"]) {
            //预约备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
            cell.mustLabel.hidden = NO;
            cell.topTitleLabel.text=cellStr;
            if (self.model.C_BXWTMS.length > 0) {
                cell.beforeText=self.model.C_BXWTMS;
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_BXWTMS=textStr;
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
            
        } else if ([cellStr isEqualToString:@"报修时间"]) {
            if (self.model.D_BXRQ.length > 0) {
                ccell.textStr = self.model.D_BXRQ;
            }
            ccell.chooseTextField.enabled = NO;
            ccell.Type = ChooseTableViewTypeBirthday;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.D_BXRQ = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"维修人员"]) {
            if (self.model.C_WXRY_ROLENAME.length > 0) {
                ccell.textStr = self.model.C_WXRY_ROLENAME;
            } else {
                ccell.textStr = @" ";
            }
            ccell.chooseTextField.enabled = NO;
            ccell.Type = CHooseTableViewTypeServicer;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.C_WXRY_ROLEID = postValue;
                weakSelf.model.C_WXRY_ROLENAME = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"是否产生费用"]) {
            if (self.model.I_SFCSFY.length > 0) {
                ccell.textStr = [self.model.I_SFCSFY isEqualToString:@"0"] ? @"否" : @"是";
            }
            ccell.chooseTextField.enabled = NO;
            ccell.Type = chooseTypeIsOutType;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.I_SFCSFY = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"维修方案"]) {
            //预约备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//            cell.mustLabel.hidden = NO;
            cell.topTitleLabel.text=cellStr;
            if (self.model.C_WXFA.length > 0) {
                cell.beforeText=self.model.C_WXFA;
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.C_WXFA=textStr;
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
            
        } else if ([cellStr isEqualToString:@"客户意见"]) {
            //预约备注
            CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
//            cell.mustLabel.hidden = NO;
            cell.topTitleLabel.text=cellStr;
            if (self.model.X_KHYJ.length > 0) {
                cell.beforeText=self.model.X_KHYJ;
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.model.X_KHYJ=textStr;
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
            
        } else if ([cellStr isEqualToString:@"未维修好原因"]) {
            if (self.model.C_WWXYY_DD_NAME.length > 0) {
                ccell.textStr = self.model.C_WWXYY_DD_NAME;
            }
            ccell.Type = ChooseTableViewTypeWWXYY;
            ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
                weakSelf.model.C_WWXYY_DD_ID = postValue;
                weakSelf.model.C_WWXYY_DD_NAME = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            return ccell;
        } else if ([cellStr isEqualToString:@"维修完成时间"]) {
            if (self.model.D_WXSJ.length > 0) {
                ccell.textStr = self.model.D_WXSJ;
            } else {
                ccell.textStr = @" ";
            }
            ccell.chooseTextField.enabled = NO;
            return ccell;
        } else if ([cellStr isEqualToString:@"售后完成时间"]) {
            if (self.model.D_FINISH_TIME.length > 0) {
                ccell.textStr = self.model.D_FINISH_TIME;
            } else {
                ccell.textStr = @" ";
            }
            
            ccell.chooseTextField.enabled = NO;
            return ccell;
        }
    }
    
    return [UITableViewCell new];
}

- (void)getDictDataListDatasWithDictType {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
        contentDic[@"dictType"] = @"A81500_C_SHWTD";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMDICDATALIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mtArray = [NSMutableArray array];
            weakSelf.postArray = [NSMutableArray array];
            NSArray *typeArray = [MJKAdditionalInfoModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            weakSelf.typeAllArray = typeArray;
            for (MJKAdditionalInfoModel *model in typeArray) {
                
                [weakSelf.mtArray addObject:model.dictLabel];
                [weakSelf.postArray addObject:model.dictValue];
            }
            
            [weakSelf httpGetAfterSales];
//            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 3) {
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
        
    } else if (indexPath.section == 2) {
        return 150;
    } else {
        NSString *cellStr = self.cellArray[indexPath.section][indexPath.row];
        if ([cellStr isEqualToString:@"报修问题描述"] ||  [cellStr isEqualToString:@"维修方案"] || [cellStr isEqualToString:@"客户意见"]) {
            return 120;
        } else if ([cellStr isEqualToString:@"售后问题点"]) {
            CGFloat x = 10;
            CGFloat y = 40;
            for (int i = 0; i < self.mtArray.count; i++) {
                CGFloat width = [self.mtArray[i] boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.width;
                x += width + 15;
                if (x + width + 10 + 15 > KScreenWidth) {
                    x = 10;
                    y += 40;
                }
            }
            if (y + 40 > 100) {
                return y + 40;
            }
        }
    }
    
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 44;
    }else if (section == 2) {
        return .1f;
    }
    if (self.C_ID.length > 0) {
        return 30;
    } else {
        if (section == 0) {
            return 30;
        }
        return .1f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 380;
    }
    if (section  == 2) {
        return 180;
    }
    if (section == 3) {
        return 55;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 3) {
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
    } else
    if (section == 2) {
        return nil;
    } else {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        bgView.backgroundColor = kBackgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        if (self.C_ID.length > 0) {
            label.text = @[@"基础信息", @"售后专员信息"][section];
        } else {
            label.text = @[@"基础信息", @""][section];
        }
        [bgView addSubview:label];
        return bgView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 380)];
        bgView.backgroundColor = [UIColor  whiteColor];
        [bgView addSubview:self.tableFootPhoto1];
        [bgView addSubview:self.tableFoot1Photo];
        return bgView;
    }
    if (section  == 2) {
//        if (self.fileListGzImage.count > 0) {
//            NSMutableArray *arr = [NSMutableArray array];
//            for (VideoAndImageModel *model in self.fileListGzImage) {
//                [arr addObject:model.url];
//            }
//            self.tableFootPhoto.imageURLArray = arr;
//        }
        return self.tableFootPhoto;
    }
    if (section == 3) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
        CGFloat width = (KScreenWidth - 15) / 2;
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, width, 45)];
        if ([self.model.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0004"] || [self.model.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0003"] || [self.model.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0002"]) {//完成
            if (![[NewUserSession instance].appcode containsObject:@"crm:a815:tuihui"]) {
                button.hidden = YES;
            }
            [button setTitleNormal:@"退回"];
        } else if ([self.model.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0001"]) {
            if (![[NewUserSession instance].appcode containsObject:@"crm:a815:wancheng"]) {
                button.hidden = YES;
            }
            [button setTitleNormal:@"维修完成"];
        } else if ([self.model.C_STATUS_DD_ID isEqualToString:@"A81500_C_STATUS_0000"]) {//受理
            
            if (![[NewUserSession instance].appcode containsObject:@"crm:a815:shouli"]) {
                button.hidden = YES;
            }
            [button setTitleNormal:@"受理"];
        }
        [button setTitleColor:[UIColor blackColor]];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(submitAction:)];
        [button setBackgroundColor:KNaviColor];
        [bgView addSubview:button];
        
        
        UIButton *rbutton = [[UIButton alloc]initWithFrame:CGRectMake(10 + width, 5, width, 45)];
        [rbutton setTitleNormal:@"转交"];
        [rbutton setTitleColor:[UIColor blackColor]];
        rbutton.layer.cornerRadius = 5.f;
        [rbutton addTarget:self action:@selector(rsubmitAction:)];
        [rbutton setBackgroundColor:KNaviColor];
        [bgView addSubview:rbutton];
        
            if (![[NewUserSession instance].appcode containsObject:@"crm:a815:zhipai"]) {
                rbutton.hidden = YES;
            }
        return bgView;
        
    }
    return nil;
}

- (void)submitAction:(UIButton *)sender {
    @weakify(self);
    if ([sender.titleLabel.text isEqualToString:@"退回"]) {
        UIAlertController *ac = [UIAlertController  alertControllerWithTitle:@"提示" message:@"是否确认退回到未受理状态?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @strongify(self);
            [self httpGetRetreat];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [ac addAction:trueAction];
        [ac addAction:cancelAction];
        
        [self presentViewController:ac animated:YES completion:nil];
    } else if ([sender.titleLabel.text isEqualToString:@"受理"]) {
        MJKCustomerFeedbackOperationViewController  *vc = [[MJKCustomerFeedbackOperationViewController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([sender.titleLabel.text isEqualToString:@"维修完成"]) {
        MJKCustomerFeedbackCompleteViewController  *vc = [[MJKCustomerFeedbackCompleteViewController alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)rsubmitAction:(UIButton *)sender {
    @weakify(self);
    if ([sender.titleLabel.text isEqualToString:@"转交"]) {
        MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
//        vc.isAllEmployees = @"是";
        vc.allUser = @"1";
        vc.noticeStr = @"无提示";
        vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
            @strongify(self);
            [self httpGetAssign:model.u051Id];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
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

- (void)httpGetRetreat {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.model.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.model.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a815/retreat", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpGetAssign:(NSString *)C_OWNER_ROLEID {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.model.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.model.C_ID;
    }
    contentDic[@"C_OWNER_ROLEID"] = C_OWNER_ROLEID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a815/assign", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
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

- (void)httpGetAfterSales {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A47700_C_ID.length > 0) {
        contentDic[@"C_A47700_C_ID"] = self.C_A47700_C_ID;
    }
    
    if (self.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.C_ID;
    }
    
    if (self.C_TYPE_DD_ID.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMDA815Info parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [weakSelf.showFileListGlsImage removeAllObjects];
            [weakSelf.showFileListXszImage removeAllObjects];
            weakSelf.model = [MJKOldCustomerSalesModel mj_objectWithKeyValues:data[@"data"]];
            if (weakSelf.model.fileListGlsImage.count > 0) {
                for (VideoAndImageModel *vmodel in weakSelf.model.fileListGlsImage) {
                    [weakSelf.showFileListGlsImage addObject:vmodel.url];
                    
                }
                if (weakSelf.fileListGlsImage.count <= 0) {
                    for (VideoAndImageModel *vmodel in weakSelf.model.fileListGlsImage) {
                        [weakSelf.fileListGlsImage addObject:@{@"saveUrl" : vmodel.saveUrl}];
                        
                    }
                }
            }
            
            if (weakSelf.model.fileListXszImage.count > 0) {
                for (VideoAndImageModel *vmodel in weakSelf.model.fileListXszImage) {
                    [weakSelf.showFileListXszImage addObject:vmodel.url];
                    
                }
                if (weakSelf.fileListXszImage.count <= 0) {
                    for (VideoAndImageModel *vmodel in weakSelf.model.fileListXszImage) {
                        [weakSelf.fileListXszImage addObject:@{@"saveUrl" : vmodel.saveUrl}];
                        
                    }
                }
            }
            
            if (weakSelf.model.fileListGzImage.count > 0) {
                for (VideoAndImageModel *vmodel in weakSelf.model.fileListGzImage) {
                    [weakSelf.showFileListGzImage addObject:vmodel.url];
                    
                }
                if (weakSelf.fileListGzImage.count <= 0) {
                    for (VideoAndImageModel *vmodel in weakSelf.model.fileListGzImage) {
                        [weakSelf.fileListGzImage addObject:@{@"saveUrl" : vmodel.saveUrl}];
                        
                    }
                }
            }
            
            for (MJKAdditionalInfoModel *model in weakSelf.typeAllArray) {
                for (NSString *str  in weakSelf.model.shwtdArray) {
                    if ([str isEqualToString:model.dictValue]) {
                        [weakSelf.glNameArray addObject:model.dictLabel];
                        [weakSelf.glArray addObject:model.dictValue];
                    }
                }
            }
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpAddAfterSales {
    DBSelf(weakSelf);
    NSMutableArray *videoArr = [NSMutableArray array];
    for (VideoAndImageModel *model in self.fileListGzVideo) {
        [videoArr addObject:[model mj_keyValues]];
    }
    NSMutableArray *imageArr = [NSMutableArray array];
    for (VideoAndImageModel *model in self.fileListGzImage) {
        [imageArr addObject:[model mj_keyValues]];
    }
    if (videoArr.count > 0) {
        self.model.fileListGzVideo = videoArr;
    }
    if (imageArr.count > 0) {
        self.model.fileListGzImage = imageArr;
    }
    
    
    
    NSDictionary *tempDic = [self.model mj_keyValues];
    NSMutableDictionary *contentDic= [NSMutableDictionary dictionary];
    
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *s = (NSString *)obj;
            if (s.length > 0) {
                contentDic[key] = s;
            }
        } else {
            contentDic[key] = obj;
        }
    }];
    if (self.C_TYPE_DD_ID.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    }
    if (self.fileListGlsImage.count > 0) {
        contentDic[@"fileListGlsImage"] = self.fileListGlsImage;
    } else {
        contentDic[@"fileListGlsImage"] = @[];
    }
    
    
    if (self.fileListXszImage.count > 0) {
        contentDic[@"fileListXszImage"] = self.fileListXszImage;
    } else {
        contentDic[@"fileListXszImage"] = @[];
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMDA815Add parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpEditAfterSales {
    DBSelf(weakSelf);
    NSMutableArray *videoArr = [NSMutableArray array];
    for (VideoAndImageModel *model in self.fileListGzVideo) {
        [videoArr addObject:[model mj_keyValues]];
    }
    NSMutableArray *imageArr = [NSMutableArray array];
    for (VideoAndImageModel *model in self.fileListGzImage) {
        [imageArr addObject:[model mj_keyValues]];
    }
    NSMutableArray *xszArr = [NSMutableArray array];
    for (NSDictionary *dic in self.fileListXszImage) {
        [xszArr addObject:dic];
    }
    NSMutableArray *glsArr = [NSMutableArray array];
    for (NSDictionary *dic in self.fileListGlsImage) {
        [glsArr addObject:dic];
    }
    if (videoArr.count > 0) {
        self.model.fileListGzVideo = videoArr;
    } else {
        self.model.fileListGzVideo = @[];
    }
    if (imageArr.count > 0) {
        self.model.fileListGzImage = imageArr;
    } else {
        self.model.fileListGzImage = @[];
    }
    if (xszArr.count > 0) {
        self.model.fileListXszImage = xszArr;
    } else {
        self.model.fileListXszImage = @[];
    }
    if (glsArr.count > 0) {
        self.model.fileListGlsImage = glsArr;
    } else {
        self.model.fileListGlsImage = @[];
    }
    NSDictionary *tempDic = [self.model mj_keyValues];
    NSMutableDictionary *contentDic= [NSMutableDictionary dictionary];
    
    [tempDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *s = (NSString *)obj;
            if (s.length > 0) {
                contentDic[key] = s;
            }
        } else {
            contentDic[key] = obj;
        }
    }];
   
    HttpManager*manager=[[HttpManager alloc]init];
    
    if (self.C_TYPE_DD_ID.length > 0) {
        contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    }
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMDA815Edit parameters:contentDic compliation:^(id data, NSError *error) {
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
//    if (self.model.C_TYPE_DD_ID.length <= 0) {
//        [JRToast showWithText:@"请选择售后类型"];
//        return;;
//    }
//
    
    if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
        
    } else {
        if (self.C_ID.length > 0) {
            
        } else {
            if (self.model.C_KH_NAME.length <= 0) {
                [JRToast showWithText:@"请输入售后对接人"];
                return;;
            }
            
            if (self.model.C_KH_PHONE.length <= 0) {
                [JRToast showWithText:@"请输入对接人电话"];
                return;;
            }
        }
    }
    
    if (self.model.C_JJCD_DD_ID.length <= 0) {
        [JRToast showWithText:@"请选择紧急程度"];
        return;;
    }
    
    if (self.model.C_A80000CJ_C_ID.length <= 0) {
        [JRToast showWithText:@"请选择厂家"];
        return;;
    }
    
    
    if (self.model.C_A49600_C_ID.length <= 0) {
        [JRToast showWithText:@"请选择品牌车型"];
        return;;
    }
    
//    if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {//展厅售后
//
//    } else {
//        if (self.model.C_JTXH.length <= 0) {
//            [JRToast showWithText:@"请输入具体型号"];
//            return;;
//        }
//    }
    
    
    if (self.model.C_XSGW_ROLEID.length <= 0) {
        [JRToast showWithText:@"请选择销售顾问"];
        return;;
    }
    
    
    if (self.model.shwtdArray.count <= 0) {
        [JRToast showWithText:@"请选择售后问题点"];
        return;;
    }
    
    
    if (self.model.C_BXWTMS.length <= 0) {
        [JRToast showWithText:@"请输入报修问题"];
        return;;
    }
    
    if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
        
    } else {
        if (self.fileListXszImage.count <= 0) {
            [JRToast showWithText:@"请上传行驶证照片"];
            return;
        }
        
        if (self.fileListGlsImage.count <= 0) {
            [JRToast showWithText:@"请上传公里数照片"];
            return;
        }
    }
    
    
    
//    if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
//
//    } else {
//        if (self.fileListGzImage.count < 2) {
//            [JRToast showWithText:@"请上传两张故障照片"];
//            return;
//        }
//    }
    
    if (self.C_ID.length > 0) {
        [self httpEditAfterSales];
    } else {
    [self httpAddAfterSales];
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



- (NSArray *)cellArray {
    if (!_cellArray) {
        if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
            if (self.C_ID > 0) {
                _cellArray =@[ @[@"紧急程度",@"维修人员类型",@"厂家",@"品牌车型",@"具体型号",@"车架号",@"报修日期",@"责任人",@"销售顾问",@"销售日期",@"是否过保",@"车辆所在地",@"售后问题点",@"报修问题描述"],
                               @[@"报修时间",@"维修人员",@"是否产生费用",@"维修方案",@"客户意见",@"未维修好原因",@"维修完成时间",@"售后完成时间"]];
            } else {
                _cellArray =@[ @[@"紧急程度",@"维修人员类型",@"厂家",@"品牌车型",@"具体型号",@"车架号",@"报修日期",@"责任人",@"销售顾问",@"销售日期",@"是否过保",@"车辆所在地",@"售后问题点",@"报修问题描述"],
                @[]];
            }
        } else {
            if ([self.C_FSLX_DD_ID isEqualToString:@"A47700_C_FSLX_0001"]) {
                if (self.C_ID > 0) {
                    
                    _cellArray =@[ @[@"订单",@"客户",@"客户电话",@"紧急程度",@"维修人员类型",@"厂家",@"品牌车型",@"具体型号",@"车架号",@"报修日期",@"责任人",@"销售顾问",@"销售日期",@"是否过保",@"车辆所在地",@"售后问题点",@"报修问题描述"],
                                   @[@"报修时间",@"维修人员",@"是否产生费用",@"维修方案",@"客户意见",@"未维修好原因",@"维修完成时间",@"售后完成时间"]];
                } else {
                    _cellArray =@[ @[@"订单",@"客户",@"客户电话",@"售后对接人",@"对接人电话",@"紧急程度",@"维修人员类型",@"厂家",@"品牌车型",@"具体型号",@"车架号",@"报修日期",@"责任人",@"销售顾问",@"销售日期",@"是否过保",@"车辆所在地",@"售后问题点",@"报修问题描述"],
                    @[]];
                }
            } else {
                if (self.C_ID > 0) {
                    
                    _cellArray =@[ @[@"客户",@"客户电话",@"紧急程度",@"维修人员类型",@"厂家",@"品牌车型",@"具体型号",@"车架号",@"报修日期",@"责任人",@"销售顾问",@"销售日期",@"是否过保",@"车辆所在地",@"售后问题点",@"报修问题描述"],
                                   @[@"报修时间",@"维修人员",@"是否产生费用",@"维修方案",@"客户意见",@"未维修好原因",@"维修完成时间",@"售后完成时间"]];
                } else {
                    _cellArray =@[ @[@"客户",@"客户电话",@"售后对接人",@"对接人电话",@"紧急程度",@"维修人员类型",@"厂家",@"品牌车型",@"具体型号",@"车架号",@"报修日期",@"责任人",@"销售顾问",@"销售日期",@"是否过保",@"车辆所在地",@"售后问题点",@"报修问题描述"],
                                   @[]];
                }
            }
        }
    }
    return _cellArray;
}


- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
        
//        if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
//        } else {
//            _tableFootPhoto.mustStr = @"*";
//        }
        _tableFootPhoto.isEdit = YES;
        _tableFootPhoto.isCamera = NO;
        _tableFootPhoto.rootVC = self;
        _tableFootPhoto.imageURLArray = self.showFileListGzImage;
        _tableFootPhoto.titleNameStr = @"故障照片";
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.fileListGzImage removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                VideoAndImageModel *model = [[VideoAndImageModel alloc]init];
                model.url = arr[i];
                model.saveUrl = saveArr[i];
                [weakSelf.fileListGzImage addObject:model];
            }
//            weakSelf.mainModel.urlList = arr;
        };
    }
    return _tableFootPhoto;
};

- (NSMutableArray *)fileListGzImage {
    if (!_fileListGzImage) {
        _fileListGzImage = [NSMutableArray array];
    }
    return _fileListGzImage;
}

- (NSMutableArray *)fileListGlsImage {
    if (!_fileListGlsImage) {
        _fileListGlsImage = [NSMutableArray array];
    }
    return _fileListGlsImage;
}


- (NSMutableArray *)showFileListGlsImage {
    if (!_showFileListGlsImage) {
        _showFileListGlsImage = [NSMutableArray array];
    }
    return _showFileListGlsImage;
}


- (NSMutableArray *)fileListXszImage {
    if (!_fileListXszImage) {
        _fileListXszImage = [NSMutableArray array];
    }
    return _fileListXszImage;
}


- (NSMutableArray *)showFileListXszImage {
    if (!_showFileListXszImage) {
        _showFileListXszImage = [NSMutableArray array];
    }
    return _showFileListXszImage;
}

- (NSMutableArray *)showFileListGzImage {
    if (!_showFileListGzImage) {
        _showFileListGzImage = [NSMutableArray array];
    }
    return _showFileListGzImage;
}

- (NSMutableArray *)fileListGzVideo {
    if (!_fileListGzVideo) {
        _fileListGzVideo = [NSMutableArray array];
    }
    return _fileListGzVideo;
}



- (NSMutableArray *)glArray {
    if (!_glArray) {
        _glArray = [NSMutableArray array];
    }
    return _glArray;
}

- (NSMutableArray *)glNameArray {
    if (!_glNameArray) {
        _glNameArray = [NSMutableArray array];
    }
    return _glNameArray;
}

- (MJKPhotoView *)tableFootPhoto1 {
    DBSelf(weakSelf);
    if (!_tableFootPhoto1) {
        _tableFootPhoto1 = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
        if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
            
    //        _tableFootPhoto1.mustStr = @"*";
        } else {
            
            _tableFootPhoto1.mustStr = @"*";
        }
        _tableFootPhoto1.isEdit = YES;
        _tableFootPhoto1.isCamera = NO;
        _tableFootPhoto1.rootVC = self;
        _tableFootPhoto1.imageURLArray = self.showFileListXszImage;
        _tableFootPhoto1.titleNameStr = @"行驶证";
        _tableFootPhoto1.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.fileListXszImage removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                [weakSelf.fileListXszImage addObject:@{@"saveUrl" : saveArr[i]}];
            }
//            weakSelf.mainModel.urlList = arr;
        };
    }
    return _tableFootPhoto1;
};

- (MJKPhotoView *)tableFoot1Photo {
    DBSelf(weakSelf);
    if (!_tableFoot1Photo) {
        _tableFoot1Photo = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableFootPhoto.frame), KScreenWidth, 180)];
        if ([self.C_TYPE_DD_ID isEqualToString:@"A81500_C_TYPE_0000"]) {
            
    //        _tableFoot1Photo.mustStr = @"*";
        } else {
            
            _tableFoot1Photo.mustStr = @"*";
        }
        _tableFoot1Photo.isEdit = YES;
        _tableFoot1Photo.isCamera = NO;
        _tableFoot1Photo.rootVC = self;
        _tableFoot1Photo.imageURLArray = self.showFileListGlsImage;
        _tableFoot1Photo.titleNameStr = @"公里数";
        _tableFoot1Photo.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.fileListGlsImage removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                [weakSelf.fileListGlsImage addObject:@{@"saveUrl" : saveArr[i]}];
            }
//            weakSelf.mainModel.urlList = arr;
        };
    }
    return _tableFoot1Photo;
};

@end
