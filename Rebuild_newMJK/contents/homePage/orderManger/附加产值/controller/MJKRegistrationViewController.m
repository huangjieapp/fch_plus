//
//  MJKMortgageViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/9/29.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKRegistrationViewController.h"

#import "MJKApprolViewRemark.h"

#import "MJKChooseNewBrandViewController.h"
#import "MJKChooseMoreEmployeesViewController.h"
#import "MJKChooseEmployeesViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKRegistrationModel.h"
#import "MJKProductShowModel.h"
#import "VideoAndImageModel.h"
#import "MJKCommentsListModel.h"
#import "MJKClueListSubModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "MJKSalesCommentTableViewCell.h"

#import "MJKPhotoView.h"


#import "MJKMessageDetailModel.h"
#import "MJKApprovalHistoryModel.h"
#import "MJKCcApprovalTableViewCell.h"


@interface MJKRegistrationViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#>*/
@property (nonatomic, strong) MJKRegistrationModel *model;
@property (nonatomic, strong) MJKApprolViewRemark *approlRemark;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) MJKProductShowModel *productModel;
/** <#注释#> */
@property (nonatomic,strong) MJKPhotoView *tableFootPhoto;
@property (nonatomic,strong) MJKPhotoView *tableFoot1Photo;

/** <#注释#> */
@property (nonatomic,strong) NSMutableArray *fileListDjzs;
@property (nonatomic,strong) NSMutableArray *fileListXsz;
@property (nonatomic,strong) NSMutableArray *showFileListDjzs;
@property (nonatomic,strong) NSMutableArray *showFileListXsz;


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

@property (nonatomic,strong) UIButton *submitButton;
@end

@implementation MJKRegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"上牌信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getLocalDatas];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
    [self commentNewView];
    [self getRegistrationInfo];
    if (self.C_ID.length > 0) {
        [self httpGetCommentsList];
        self.addModel = [[MJKCommentsListModel  alloc]init];
        self.addModel.C_OBJECTID = self.C_ID;
        self.addModel.type = @"A47500_C_TSPAGE_0032";
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
    if (indexPath.section == self.localDatas.count) {
        if (self.proButton.tag == 100  || self.proButton == nil) {
            MJKCommentsListModel *model = self.dataArray[indexPath.row];
            MJKSalesCommentTableViewCell *cell = [MJKSalesCommentTableViewCell cellWithTableView:tableView];
            cell.rootVC = self;
            cell.model = model;
            cell.reCommentActionBlock = ^{
    //            weakSelf.noticeButton.hidden = YES;
                weakSelf.addModel.C_FATHERID = model.C_ID;
    //            weakSelf.IDStr = model.C_ID;
                [weakSelf.commentText becomeFirstResponder];
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
        
        if ([model.locatedTitle containsString:@"费"]) {
            iCell.allNumber = @"是";
        }
    if ([model.locatedTitle isEqualToString:@"申请日期"]) {
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
    } else if ([model.locatedTitle isEqualToString:@"具体型号"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"车架号"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"厂家"])  {
        ccell.Type = ChooseTableViewTypeA80000_C_TYPE;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0006";
        ccell.taglabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"台次"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"交车日期"])  {
        ccell.taglabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"收上牌费日期"])  {
        ccell.taglabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"收上牌费金额"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            weakSelf.model.B_SSPFJE = textStr;
        };
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"预计上牌时间"])  {
        ccell.taglabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"上牌省"])  {
        PotentailCustomerEditModel *cityModel = arr[indexPath.row + 1];
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeProvince;
        ccell.C_TYPECODE = @"1";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            cityModel.postValue = @"";
            cityModel.nameValue = @"";
            [tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"上牌市"]) {
        PotentailCustomerEditModel *provinceModel = arr[indexPath.row - 1];
        ccell.taglabel.hidden = NO;
        ccell.provinceValue = provinceModel.postValue;
        ccell.Type = ChooseTableViewTypeNewCity;
        ccell.C_TYPECODE = @"2";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"开票名称"])  {
//        iCell.tagLabel.hidden = NO;
        
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"上牌车类型"])  {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        ccell.C_TYPECODE = @"A80500_C_SPCLX";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"车辆状态"])  {
        
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        ccell.C_TYPECODE = @"A80500_C_CLZT";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"上牌落户员姓名"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = chooseTypeNil;
//        ccell.Type = ChooseTableViewTypeA80000_C_TYPE;
//        ccell.C_TYPECODE = @"A80000_C_TYPE_0008";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
//            model.postValue = postValue;
//            model.nameValue = str;
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
            if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                vc.isAllEmployees = @"是";
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model1) {
                model.postValue = model1.u051Id;
                model.nameValue = model1.nickName;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"提档人姓名"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"客户姓名"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"电话"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"财务核实上牌费金额"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"备注"]){
        //预约备注
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
        
    } else if ([model.locatedTitle isEqualToString:@"状态"])  {
        iCell.inputTextField.enabled = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"上牌日期"])  {
        ccell.Type = ChooseTableViewTypeBirthday;
        ccell.taglabel.hidden = NO;
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"上牌代办员费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"上牌工本费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"差旅费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"包围拆装费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"物流费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"车辆托运费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"私车公用油费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"其他费用"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        iCell.textEndEditBlock = ^{
            [weakSelf reloadTableWithTableView:tableView];
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"费用合计"])  {
        iCell.inputTextField.enabled = NO;
        iCell.tagLabel.hidden = NO;
        model.postValue = @"";
        model.nameValue = model.postValue;
        NSArray *totalArr = @[@"上牌代办员费",@"上牌工本费",@"差旅费",@"包围拆装费",@"物流费",@"车辆托运费",@"私车公用油费",@"其他费用"];
        for (int i = 0; i < self.localDatas.count; i++) {
            NSArray *sectionArr = self.localDatas[i];
            for (int j = 0; j < sectionArr.count; j++) {
                for (NSString *titleStr in totalArr) {
                    PotentailCustomerEditModel *tempModel = sectionArr[j];
                    if ([tempModel.locatedTitle isEqualToString:titleStr]) {
                        model.postValue = [NSString stringWithFormat:@"%.2f",model.postValue.floatValue + tempModel.postValue.floatValue];
                        model.nameValue = model.postValue;
                    }
                }
                
            }
        }
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"剩余利润"])  {
        iCell.tagLabel.hidden = NO;
        iCell.inputTextField.enabled = NO;
        model.postValue = @"";
        model.nameValue = model.postValue;
        for (int i = 0; i < self.localDatas.count; i++) {
            NSArray *sectionArr = self.localDatas[i];
            for (int j = 0; j < sectionArr.count; j++) {
                PotentailCustomerEditModel *tempModel = sectionArr[j];
                if ([tempModel.locatedTitle isEqualToString:@"费用合计"]) {
                    model.postValue = [NSString stringWithFormat:@"%.2f",self.model.B_SSPFJE.floatValue - tempModel.postValue.floatValue];
                    model.nameValue = model.postValue;
                }
            }
        }
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"上牌代办员姓名"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"上牌代办员电话"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"上牌员提成"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"剩余利润"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }else if ([model.locatedTitle isEqualToString:@"销售顾问提成"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
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
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
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
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    }
    }
    return [UITableViewCell new];
    
}
    
- (void)reloadTableWithTableView:(UITableView *)tableView {
    for (int i = 0; i < self.localDatas.count; i++) {
        NSArray *sectionArr = self.localDatas[i];
        for (int j = 0; j < sectionArr.count; j++) {
            PotentailCustomerEditModel *tempModel = sectionArr[j];
            if ([tempModel.locatedTitle isEqualToString:@"费用合计"] ||
                [tempModel.locatedTitle isEqualToString:@"剩余利润"]) {
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:j inSection:i]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
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
    if ([model.locatedTitle isEqualToString:@"备注"]) {
        return 120;
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
    if (section == 0) {
        return 360;
    } else if (section == self.localDatas.count) {
        return 55;
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
    } else {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        bgView.backgroundColor = kBackgroundColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        label.text = @[@"基础信息", @"利润相关"][section];
        [bgView addSubview:label];
        return bgView;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 300)];
        bgView.backgroundColor = [UIColor  whiteColor];
        [bgView addSubview:self.tableFootPhoto];
        [bgView addSubview:self.tableFoot1Photo];
        return bgView;
    } else if (section == self.localDatas.count) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 55)];
        CGFloat width = (KScreenWidth - 15) / 2;
       
        
        
        UIButton *rbutton = [[UIButton alloc]initWithFrame:CGRectMake(10 + width, 5, width, 45)];
        [rbutton setTitleNormal:@"转交"];
        [rbutton setTitleColor:[UIColor blackColor]];
        rbutton.layer.cornerRadius = 5.f;
        [rbutton addTarget:self action:@selector(rsubmitAction:)];
        [rbutton setBackgroundColor:KNaviColor];
        [bgView addSubview:rbutton];
        
            if (![[NewUserSession instance].appcode containsObject:@"crm:a805:zhipai"]) {
                rbutton.hidden = YES;
            }
        return bgView;
        
    }
    return nil;
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

- (void)httpGetAssign:(NSString *)C_OWNER_ROLEID {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.model.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.model.C_ID;
    }
    contentDic[@"C_SPLHYXM_ROLEID"] = C_OWNER_ROLEID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a805/assign", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [weakSelf getRegistrationInfo];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
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

- (void)getRegistrationInfo {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A42000_C_ID.length > 0) {
        contentDic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
    }
    if (self.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD805INFO parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            [weakSelf.showFileListXsz removeAllObjects];
            [weakSelf.showFileListDjzs removeAllObjects];
            weakSelf.model = [MJKRegistrationModel mj_objectWithKeyValues:data[@"data"]];
            if (weakSelf.model.fileListXsz.count > 0) {
                for (VideoAndImageModel *vmodel in weakSelf.model.fileListXsz) {
                    [weakSelf.showFileListXsz addObject:vmodel.url];
                    
                }
                if (weakSelf.fileListXsz.count <= 0) {
                    for (VideoAndImageModel *vmodel in weakSelf.model.fileListXsz) {
                        [weakSelf.fileListXsz addObject:@{@"saveUrl" : vmodel.saveUrl}];
                        
                    }
                }
            }
            
            if (weakSelf.model.fileListDjzs.count > 0) {
                for (VideoAndImageModel *vmodel in weakSelf.model.fileListDjzs) {
                    [weakSelf.showFileListDjzs addObject:vmodel.url];
                    
                }
                if (weakSelf.fileListDjzs.count <= 0) {
                    for (VideoAndImageModel *vmodel in weakSelf.model.fileListDjzs) {
                        [weakSelf.fileListDjzs addObject:@{@"saveUrl" : vmodel.saveUrl}];
                        
                    }
                }
            }
            
            
            if (![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80500_C_STATUS_0001"] && ![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80500_C_STATUS_0000"]) {
                weakSelf.submitButton.hidden = YES;
                if (self.C_ID.length <= 0) {
                    CGRect frame = weakSelf.tableView.frame;
                    frame.size.height += 50;
                    weakSelf.tableView.frame = frame;
                }
            }
                if ([weakSelf.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0000"] || [weakSelf.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0002"]) {
                    weakSelf.submitButton.hidden = YES;
                    if (self.C_ID.length <= 0) {
                        CGRect frame = weakSelf.tableView.frame;
                        frame.size.height += 50;
                        weakSelf.tableView.frame = frame;
                    }
                }
            
            if ([weakSelf.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0002"] && [weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80500_C_STATUS_0000"]) {
                weakSelf.submitButton.hidden = NO;
                [weakSelf.submitButton setTitle:@"完成" forState:UIControlStateNormal];
            }
            
            [weakSelf getPostValueAndBeforeValue];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitRegistrationInfo {
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
    
    if (self.fileListDjzs.count > 0) {
        contentDic[@"fileListDjzs"] = self.fileListDjzs;
    }
    
    if (self.fileListXsz.count > 0) {
        contentDic[@"fileListXsz"] = self.fileListXsz;
    }
    
    
    NSMutableDictionary *spDict = [NSMutableDictionary dictionary];
    NSArray *spArr = @[@"D_SPRQ",@"B_SPHNF",@"B_SPGBF",@"B_CLF",@"B_BWCZF",@"B_WLF",@"B_CLTYF",@"B_SCGYYF",@"B_QTFY",@"C_HN_NAME",@"C_HN_PHONE"];
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            
            for (NSString *str in spArr) {
                if ([model.keyValue isEqualToString:str]) {
                    if (model.postValue.length > 0 && model.keyValue.length > 0) {
                        spDict[model.keyValue] = model.postValue;
                    }
                }
            }
    //        if ([model.keyValue isEqualToString:@"D_SQRQ"] || [model.keyValue isEqualToString:@"D_SEND_TIME"] || [model.keyValue isEqualToString:@"D_SSPFRQ"] || [model.keyValue isEqualToString:@"D_YJSPSJ"]) {
    //
    //            contentDic[model.keyValue] = [model.postValue stringByAppendingString:@" 00:00:00"];
    //        } else {
                if (model.postValue.length > 0 && model.keyValue.length > 0) {
                    contentDic[model.keyValue] = model.postValue;
                }
    //        }
        }
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD805EDIT parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            if ([self.model.C_SPZT_DD_ID isEqualToString:@"A42500_C_STATUS_0002"]) {
                self.approlRemark = [[NSBundle mainBundle]loadNibNamed:@"MJKApprolViewRemark" owner:nil options:nil].firstObject;
                [[UIApplication sharedApplication].windows[0] addSubview:self.approlRemark];
                self.approlRemark.changeTextBlock = ^(NSString * _Nonnull text) {
                    [weakSelf HttpApprovalRequestWithRemark:text withType:@"A42500_C_TYPE_0020" withSpDic:spDict SuccessBlock:^{
                        [weakSelf.approlRemark removeFromSuperview];
                        [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        
                    }];
                };
            } else {
                //            [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0013" andSuccessBlock:^{
                [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                //            }];
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)HttpApprovalRequestWithRemark:(NSString *)remark withType:(NSString *)type withSpDic:(NSDictionary *)spDic SuccessBlock:(void(^)(void))completeBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
        contentDic[@"C_OBJECT_ID"] = self.model.C_ID;
   
        contentDic[@"C_TYPE_DD_ID"] = type;
    if (remark.length > 0) {
        contentDic[@"X_REMARK"] = remark;
    }
    if (spDic.allKeys.count > 0) {
        contentDic[@"a805"] = spDic;
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

- (void)submitButtonAction {
    DBSelf(weakSelf);
    if (![[NewUserSession instance].appcode containsObject:@"crm:a805:force_update"]) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a805:edit"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    }
        for (NSArray *arr in self.localDatas) {
            for (PotentailCustomerEditModel *model in arr) {
                if (model.postValue.length <= 0) {
                    if ([model.locatedTitle isEqualToString:@"厂家"] ||
                        [model.locatedTitle isEqualToString:@"具体型号"] ||
                        [model.locatedTitle isEqualToString:@"台次"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"交车日期"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"上牌车类型"] ||
                        [model.locatedTitle isEqualToString:@"上牌车落户员姓名"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请选择%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"提档人姓名"] ||
                        [model.locatedTitle isEqualToString:@"财务核实商品费金额"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"预计上牌时间"]  ||
                        [model.locatedTitle isEqualToString:@"上牌省"] ||
                        [model.locatedTitle isEqualToString:@"上牌市"] ||
                        [model.locatedTitle isEqualToString:@"上牌车类型"] ||
                        [model.locatedTitle isEqualToString:@"车辆状态"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请选择%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"上牌落户员姓名"] ||
                        [model.locatedTitle isEqualToString:@"提档人姓名"] ||
                        [model.locatedTitle isEqualToString:@"财务核实上牌费金额"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"上牌日期"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请选择%@",model.locatedTitle]];
                        return;
                    }
                    
                    if ([model.locatedTitle isEqualToString:@"上牌代办员费"] ||
                        [model.locatedTitle isEqualToString:@"上牌工本费"] ||
                        [model.locatedTitle isEqualToString:@"差旅费"] ||
                        [model.locatedTitle isEqualToString:@"包围拆装费"] ||
                        [model.locatedTitle isEqualToString:@"物流费"] ||
                        [model.locatedTitle isEqualToString:@"车辆托运费"] ||
                        [model.locatedTitle isEqualToString:@"私车公用油费"] ||
                        [model.locatedTitle isEqualToString:@"其他费用"] ||
                        [model.locatedTitle isEqualToString:@"上牌代办员姓名"] ||
                        [model.locatedTitle isEqualToString:@"上牌代办员电话"] ||
                        [model.locatedTitle isEqualToString:@"上牌员提成"] ||
                        [model.locatedTitle isEqualToString:@"剩余利润"] ||
                        [model.locatedTitle isEqualToString:@"销售顾问提成"] ||
                        [model.locatedTitle isEqualToString:@"经理/副店提成"] ||
                        [model.locatedTitle isEqualToString:@"店总提成"]) {
                        [JRToast showWithText:[NSString stringWithFormat:@"请输入%@",model.locatedTitle]];
                        return;
                    }
                }
            }
        }
        [self submitRegistrationInfo];
    
}

- (void)registrationComplete {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.model.C_ID;
   
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a805/complete", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
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


#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NAVIHEIGHT, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.bottomView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (void)getLocalDatas {
    NSArray*localArr=@[];
    NSArray*localValueArr=@[];
    NSArray*localPostNameArr=@[];
    NSArray*localKeyArr=@[];
    
    if ([self.type isEqualToString:@"车源"]) {
        localArr=@[@"门店",@"申请日期",@"品牌车型",@"车架号",@"厂家",@"具体型号",@"台次",@"预计上牌时间",@"上牌省",@"上牌市",@"上牌车类型",@"车辆状态",@"上牌落户员姓名",@"提档人姓名"];
        
        localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localKeyArr=@[@"C_LOCNAME",@"D_SQRQ",@"C_A49600_C_ID",@"C_VIN",@"C_A80000CJ_C_ID",@"C_JTXH",@"C_TC",@"D_YJSPSJ",@"C_PROVINCE_ID",@"C_CITY_ID",@"C_SPCLX_DD_ID",@"C_CLZT_DD_ID",@"C_SPLHYXM_ROLEID",@"C_TDRXM"];
    } else {
        localArr=@[@"门店",@"销售顾问",@"申请日期",@"客户姓名",@"电话",@"品牌车型",@"车架号",@"厂家",@"具体型号",@"台次",@"交车日期",@"收上牌费日期",@"收上牌费金额",@"预计上牌时间",@"上牌省",@"上牌市",@"开票名称",@"上牌车类型",@"车辆状态",@"上牌落户员姓名",@"提档人姓名",@"备注",@"状态"];

        localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localKeyArr=@[@"C_LOCNAME",@"C_OWNER_ROLENAME",@"D_SQRQ",@"C_KH_NAME",@"C_KH_PHONE",@"C_A49600_C_ID",@"C_VIN",@"C_A80000CJ_C_ID",@"C_JTXH",@"C_TC",@"D_SEND_TIME",@"D_SSPFRQ",@"B_SSPFJE",@"D_YJSPSJ",@"C_PROVINCE_ID",@"C_CITY_ID",@"C_BILLING",@"C_SPCLX_DD_ID",@"C_CLZT_DD_ID",@"C_SPLHYXM_ROLEID",@"C_TDRXM",@"X_REMARK",@"C_STATUS_DD_ID"];
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
    
    NSArray*localArr1=@[];
    NSArray*localValueArr1=@[];
    NSArray*localPostNameArr1=@[];
    NSArray*localKeyArr1=@[];
//    if ([self.type isEqualToString:@"车源"]) {
        localArr1=@[@"上牌日期",@"上牌代办员费",@"上牌工本费",@"差旅费",@"包围拆装费",@"物流费",@"车辆托运费",@"私车公用油费",@"其他费用",@"费用合计",@"剩余利润",@"上牌代办员姓名",@"上牌代办员电话"];//,@"上牌员提成",@"剩余利润",@"销售顾问提成",@"经理/副店提成",@"店总提成"];
        localValueArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localPostNameArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        localKeyArr1=@[@"D_SPRQ",@"B_SPHNF",@"B_SPGBF",@"B_CLF",@"B_BWCZF",@"B_WLF",@"B_CLTYF",@"B_SCGYYF",@"B_QTFY",@"B_FYHJ",@"B_SYLR",@"C_HN_NAME",@"C_HN_PHONE"];
//    } else {
//
//        localArr1=@[@"上牌日期",@"上牌代办员费",@"上牌工本费",@"差旅费",@"包围拆装费",@"物流费",@"其他费用",@"上牌代办员姓名",@"上牌代办员电话"];//,@"上牌员提成",@"剩余利润",@"销售顾问提成",@"经理/副店提成",@"店总提成"];
//        localValueArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@""];//,@"",@"",@"",@"",@""];
//        localPostNameArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@""];//,@"",@"",@"",@"",@""];
//        localKeyArr1=@[@"D_SPRQ",@"B_SPHNF",@"B_SPGBF",@"B_CLF",@"B_BWCZF",@"B_WLF",@"B_QTFY",@"C_HN_NAME",@"C_HN_PHONE"];//,@"",@"B_SYLR",@"B_SXGWTC",@"B_JLTC",@"B_DZTC"];
//    }
    
    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }
    if ([[NewUserSession instance].appcode containsObject:@"crm:a805:show_profit"]) {
        self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArr, saveLocalArr1,  nil];
    } else {
        
        self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArr,  nil];
    }
}

-(void)getPostValueAndBeforeValue{
    NSArray*section0ShowNameArray =@[];
    NSArray*section0PostNameArray =@[];
    if ([self.type isEqualToString:@"车源"]) {
        section0ShowNameArray =@[
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                         self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.C_A80000CJ_C_NAME.length > 0 ? self.model.C_A80000CJ_C_NAME : @"",
                                         self.model.C_JTXH.length > 0 ? self.model.C_JTXH : @"",
                                         
                                         self.model.C_TC.length > 0 ? self.model.C_TC : @"",
                                         self.model.D_YJSPSJ.length > 0 ? self.model.D_YJSPSJ : @"",
                                         self.model.C_PROVINCE_NAME.length > 0 ? self.model.C_PROVINCE_NAME : @"",
                                         self.model.C_CITY_NAME.length > 0 ? self.model.C_CITY_NAME : @"",
                                         self.model.C_SPCLX_DD_NAME.length > 0 ? self.model.C_SPCLX_DD_NAME : @"",
                                         self.model.C_CLZT_DD_NAME.length > 0 ? self.model.C_CLZT_DD_NAME : @"",
                                         self.model.C_SPLHYXM_ROLENAME.length > 0 ? self.model.C_SPLHYXM_ROLENAME : @"",
                                         self.model.C_TDRXM.length > 0 ? self.model.C_TDRXM : @"",];
        
        section0PostNameArray =@[
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                         self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.C_A80000CJ_C_ID.length > 0 ? self.model.C_A80000CJ_C_ID : @"",
                                         self.model.C_JTXH.length > 0 ? self.model.C_JTXH : @"",
                                         self.model.C_TC.length > 0 ? self.model.C_TC : @"",
                                         self.model.D_YJSPSJ.length > 0 ? self.model.D_YJSPSJ : @"",
                                         self.model.C_PROVINCE_ID.length > 0 ? self.model.C_PROVINCE_ID : @"",
                                         self.model.C_CITY_ID.length > 0 ? self.model.C_CITY_ID : @"",
                                         self.model.C_SPCLX_DD_ID.length > 0 ? self.model.C_SPCLX_DD_ID : @"",
                                         self.model.C_CLZT_DD_ID.length > 0 ? self.model.C_CLZT_DD_ID : @"",
                                         self.model.C_SPLHYXM_ROLEID.length > 0 ? self.model.C_SPLHYXM_ROLEID : @"",
                                         self.model.C_TDRXM.length > 0 ? self.model.C_TDRXM : @"",];
    } else {
        
        section0ShowNameArray =@[
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                         self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                         self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                         self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                         self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.C_A80000CJ_C_NAME.length > 0 ? self.model.C_A80000CJ_C_NAME : @"",
                                         self.model.C_JTXH.length > 0 ? self.model.C_JTXH : @"",
    
                                         self.model.C_TC.length > 0 ? self.model.C_TC : @"",
                                         self.model.D_SEND_TIME.length > 0 ? self.model.D_SEND_TIME : @"",
                                         self.model.D_SSPFRQ.length > 0 ? self.model.D_SSPFRQ : @"",
                                         self.model.B_SSPFJE.length > 0 ? self.model.B_SSPFJE : @"",
                                         self.model.D_YJSPSJ.length > 0 ? self.model.D_YJSPSJ : @"",
                                         self.model.C_PROVINCE_NAME.length > 0 ? self.model.C_PROVINCE_NAME : @"",
                                         self.model.C_CITY_NAME.length > 0 ? self.model.C_CITY_NAME : @"",
                                         self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                         self.model.C_SPCLX_DD_NAME.length > 0 ? self.model.C_SPCLX_DD_NAME : @"",
                                         self.model.C_CLZT_DD_NAME.length > 0 ? self.model.C_CLZT_DD_NAME : @"",
                                         self.model.C_SPLHYXM_ROLENAME.length > 0 ? self.model.C_SPLHYXM_ROLENAME : @"",
                                         self.model.C_TDRXM.length > 0 ? self.model.C_TDRXM : @"",
                                         self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"",
                                         self.model.C_STATUS_DD_NAME.length > 0 ? self.model.C_STATUS_DD_NAME : @""];
    
        section0PostNameArray =@[
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                         self.model.D_SQRQ.length > 0 ? self.model.D_SQRQ : @"",
                                         self.model.C_KH_NAME.length > 0 ? self.model.C_KH_NAME : @"",
                                         self.model.C_KH_PHONE.length > 0 ? self.model.C_KH_PHONE : @"",
                                         self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.C_A80000CJ_C_ID.length > 0 ? self.model.C_A80000CJ_C_ID : @"",
                                         self.model.C_JTXH.length > 0 ? self.model.C_JTXH : @"",
                                         self.model.C_TC.length > 0 ? self.model.C_TC : @"",
                                         self.model.D_SEND_TIME.length > 0 ? self.model.D_SEND_TIME : @"",
                                         self.model.D_SSPFRQ.length > 0 ? self.model.D_SSPFRQ : @"",
                                         self.model.B_SSPFJE.length > 0 ? self.model.B_SSPFJE : @"",
    
                                         self.model.D_YJSPSJ.length > 0 ? self.model.D_YJSPSJ : @"",
                                         self.model.C_PROVINCE_ID.length > 0 ? self.model.C_PROVINCE_ID : @"",
                                         self.model.C_CITY_ID.length > 0 ? self.model.C_CITY_ID : @"",
                                         self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                         self.model.C_SPCLX_DD_ID.length > 0 ? self.model.C_SPCLX_DD_ID : @"",
                                         self.model.C_CLZT_DD_ID.length > 0 ? self.model.C_CLZT_DD_ID : @"",
                                         self.model.C_SPLHYXM_ROLEID.length > 0 ? self.model.C_SPLHYXM_ROLEID : @"",
                                         self.model.C_TDRXM.length > 0 ? self.model.C_TDRXM : @"",
                                         self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @"",
                                         self.model.C_STATUS_DD_ID.length > 0 ? self.model.C_STATUS_DD_ID : @""];
                
    }
    
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    if ([[NewUserSession instance].appcode containsObject:@"crm:a805:show_profit"]) {
        NSArray*section1ShowNameArray =@[];
        
        NSArray*section1PostNameArray =@[];
        
//        if ([self.type isEqualToString:@"车源"]) {
            section1ShowNameArray =@[self.model.D_SPRQ.length > 0 ? self.model.D_SPRQ : @"",
                                             self.model.B_SPHNF.length > 0 ? self.model.B_SPHNF : @"",
                                             self.model.B_SPGBF.length > 0 ? self.model.B_SPGBF : @"",
                                             self.model.B_CLF.length > 0 ? self.model.B_CLF : @"",
                                             self.model.B_BWCZF.length > 0 ? self.model.B_BWCZF : @"",
                                             self.model.B_WLF.length > 0 ? self.model.B_WLF : @"",
                                             self.model.B_CLTYF.length > 0 ? self.model.B_CLTYF : @"",
                                             self.model.B_SCGYYF.length > 0 ? self.model.B_SCGYYF : @"",
                                             self.model.B_QTFY.length > 0 ? self.model.B_QTFY : @"",
                                             self.model.B_FYHJ.length > 0 ? self.model.B_FYHJ : @"",
                                             self.model.B_SYLR.length > 0 ? self.model.B_SYLR : @"",
                                             self.model.C_HN_NAME.length > 0 ? self.model.C_HN_NAME : @"",
                                             self.model.C_HN_PHONE.length > 0 ? self.model.C_HN_PHONE : @"",];
            
            section1PostNameArray =@[self.model.D_SPRQ.length > 0 ? self.model.D_SPRQ : @"",
                                             self.model.B_SPHNF.length > 0 ? self.model.B_SPHNF : @"",
                                             self.model.B_SPGBF.length > 0 ? self.model.B_SPGBF : @"",
                                             self.model.B_CLF.length > 0 ? self.model.B_CLF : @"",
                                             self.model.B_BWCZF.length > 0 ? self.model.B_BWCZF : @"",
                                             self.model.B_WLF.length > 0 ? self.model.B_WLF : @"",
                                             self.model.B_CLTYF.length > 0 ? self.model.B_CLTYF : @"",
                                             self.model.B_SCGYYF.length > 0 ? self.model.B_SCGYYF : @"",
                                             self.model.B_QTFY.length > 0 ? self.model.B_QTFY : @"",
                                             self.model.B_FYHJ.length > 0 ? self.model.B_FYHJ : @"",
                                             self.model.B_SYLR.length > 0 ? self.model.B_SYLR : @"",
                                             self.model.C_HN_NAME.length > 0 ? self.model.C_HN_NAME : @"",
                                             self.model.C_HN_PHONE.length > 0 ? self.model.C_HN_PHONE : @"",];
            
//        }
        
//    NSArray*section1ShowNameArray =@[self.model.D_SPRQ.length > 0 ? self.model.D_SPRQ : @"",
//                                     self.model.B_SPHNF.length > 0 ? self.model.B_SPHNF : @"",
//                                     self.model.B_SPGBF.length > 0 ? self.model.B_SPGBF : @"",
//                                     self.model.B_CLF.length > 0 ? self.model.B_CLF : @"",
//                                     self.model.B_BWCZF.length > 0 ? self.model.B_BWCZF : @"",
//                                     self.model.B_WLF.length > 0 ? self.model.B_WLF : @"",
//                                     self.model.B_QTFY.length > 0 ? self.model.B_QTFY : @"",
//                                     self.model.C_HN_NAME.length > 0 ? self.model.C_HN_NAME : @"",
//                                     self.model.C_HN_PHONE.length > 0 ? self.model.C_HN_PHONE : @"",];
////                                     @"",
////                                     self.model.B_SYLR.length > 0 ? self.model.B_SYLR : @"",
////                                     self.model.B_SXGWTC.length > 0 ? self.model.B_SXGWTC : @"",
////                                     self.model.B_JLTC.length > 0 ? self.model.B_JLTC : @"",
////                                     self.model.B_DZTC.length > 0 ? self.model.B_DZTC : @"",
////                                     ];
//
//    NSArray*section1PostNameArray =@[self.model.D_SPRQ.length > 0 ? self.model.D_SPRQ : @"",
//                                     self.model.B_SPHNF.length > 0 ? self.model.B_SPHNF : @"",
//                                     self.model.B_SPGBF.length > 0 ? self.model.B_SPGBF : @"",
//                                     self.model.B_CLF.length > 0 ? self.model.B_CLF : @"",
//                                     self.model.B_BWCZF.length > 0 ? self.model.B_BWCZF : @"",
//                                     self.model.B_WLF.length > 0 ? self.model.B_WLF : @"",
//                                     self.model.B_QTFY.length > 0 ? self.model.B_QTFY : @"",
//                                     self.model.C_HN_NAME.length > 0 ? self.model.C_HN_NAME : @"",
//                                     self.model.C_HN_PHONE.length > 0 ? self.model.C_HN_PHONE : @"",];
////                                     @"",
////                                     self.model.B_SYLR.length > 0 ? self.model.B_SYLR : @"",
////                                     self.model.B_SXGWTC.length > 0 ? self.model.B_SXGWTC : @"",
////                                     self.model.B_JLTC.length > 0 ? self.model.B_JLTC : @"",
////                                     self.model.B_DZTC.length > 0 ? self.model.B_DZTC : @"",
////                                     ];
    
    
    
    NSMutableArray*MainArray1=self.localDatas[1];
    for (int i=0; i<MainArray1.count; i++) {
        PotentailCustomerEditModel*model=MainArray1[i];
        model.nameValue=section1ShowNameArray[i];
        model.postValue=section1PostNameArray[i];
    }
    }
    
    [self.tableView reloadData];
}

//- (UIView *)bottomView {
//    if (!_bottomView) {
//        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - NAVIHEIGHT, KScreenWidth, 55)];
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, KScreenWidth - 10, 45)];
//        [button setTitle:@"提交" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        button.backgroundColor = KNaviColor;
//        button.layer.cornerRadius = 5.f;
//        [button addTarget:self action:@selector(commitButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:button];
//    }
//    return _bottomView;
//}

- (void)httpCommentsAdd {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [self.addModel mj_keyValues];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString  *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length  >  0) {
            contentDic[key] = obj;
        }
    } ];
    if (self.commentLileList.count > 0) {
        contentDic[@"fileList"] = self.commentLileList;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMDA465Add parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.addModel = [[MJKCommentsListModel  alloc]init];
            weakSelf.addModel.C_OBJECTID = self.C_ID;
            weakSelf.addModel.type = @"A47500_C_TSPAGE_0032";
            weakSelf.commentText.text = @"";
            [weakSelf.commentText resignFirstResponder];
            weakSelf.commentNewView = nil;
            weakSelf.tableCommentPhoto = nil;
            [weakSelf commentNewView];
            [weakSelf httpGetCommentsList];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)noticeButtonAction {
    DBSelf(weakSelf);
    MJKChooseMoreEmployeesViewController *vc = [[MJKChooseMoreEmployeesViewController alloc]init];
    vc.isAllEmployees = @"是";
    vc.noticeStr = @"无提示";
    if (self.addModel.X_REMINDING.length  > 0) {
        vc.codeStr = self.addModel.X_REMINDING;
    }
//    vc.codeStr = self.saleStr;
//    vc.vcName = @"@提醒";
    vc.chooseEmployeesBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull u051CodeStr) {
        
        //        weakSelf.saleStr = codeStr;
        //        weakSelf.saleNameStr = nameStr;
                weakSelf.addModel.X_REMINDING = u051CodeStr;
        weakSelf.addModel.X_REMINDINGNAME = nameStr;
        [weakSelf.noticeButton setTitleNormal:[NSString stringWithFormat:@"@%@", nameStr]];
        [weakSelf.commentText becomeFirstResponder];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendCommentAction {
    if (self.addModel.X_REMARK.length <= 0) {
        [JRToast showWithText:@"请输入评论"];
        return;
    }
    [self httpCommentsAdd];
}

- (void)textViewDidChange:(UITextView *)textView{
    self.addModel.X_REMARK = textView.text;
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

- (void)commentButtonAction:(UIButton *)sender {
    self.noticeButton.hidden = NO;
//    self.IDStr = @"";
    self.addModel.C_FATHERID  = @"";
    [self.commentText becomeFirstResponder];
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight-55-AdaptTabHeight, KScreenWidth, 55)];
        if (self.C_ID.length > 0) {
            UIButton *commentButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 80, 45)];
            [commentButton setImage:@"跟进"];
            commentButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            [commentButton setTitleNormal:@"发表评论"];
            commentButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [commentButton setTitleColor:[UIColor darkGrayColor]];
            commentButton.layer.cornerRadius = 5.f;
            commentButton.backgroundColor = kBackgroundColor;
            [commentButton addTarget:self action:@selector(commentButtonAction:)];
            self.commentButton = commentButton;
            [_bottomView addSubview:commentButton];
            
            UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(commentButton.frame) + 10, 5, 50, 45)];
            self.submitButton = submitButton;
            submitButton.layer.cornerRadius = 5.f;
            [submitButton setTitleNormal:@"修改"];
            [submitButton setTitleColor:[UIColor blackColor]];
            [submitButton setBackgroundColor:KNaviColor];
            [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:submitButton];
        } else {
            UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, _bottomView.frame.size.width - 10, 45)];
            self.submitButton = submitButton;
            submitButton.layer.cornerRadius = 5.f;
            [submitButton setTitleNormal:@"修改"];//@"提交"
            [submitButton setTitleColor:[UIColor blackColor]];
            [submitButton setBackgroundColor:KNaviColor];
            [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:submitButton];
        }
    }
    return _bottomView;
}

- (UIView *)commentNewView {
    if (!_commentNewView) {
        _commentNewView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight, KScreenWidth, 250)];
        _commentNewView.backgroundColor = [UIColor whiteColor];
        
        self.commentText = [[UITextView alloc] initWithFrame:CGRectInset(CGRectMake(0.0, 0, KScreenWidth, 60.0), 5.0, 5.0)];
        self.commentText.layer.borderColor   =  [DBColor(212.0, 212.0, 212.0) CGColor];
        self.commentText.layer.borderWidth   = 1.0;
        self.commentText.layer.cornerRadius  = 2.0;
        self.commentText.layer.masksToBounds = YES;
        
        self.commentText.backgroundColor     = [UIColor clearColor];
        self.commentText.returnKeyType       = UIReturnKeySend;
        self.commentText.delegate            = self;
        self.commentText.font                = [UIFont systemFontOfSize:15.0];
        
        // _placeholderLabel
        UILabel *placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.text = @"请输入您的评论";
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.textColor = [UIColor lightGrayColor];
        [placeHolderLabel sizeToFit];
        placeHolderLabel.font = [UIFont systemFontOfSize:13.f];
        [self.commentText addSubview:placeHolderLabel];
        [self.commentText setValue:placeHolderLabel forKey:@"_placeholderLabel"];
        [_commentNewView addSubview:self.commentText];
        
        [_commentNewView addSubview:self.tableCommentPhoto];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(self.tableCommentPhoto.frame) + 5, KScreenWidth - 120, 45)];
        self.noticeButton = button;
        [button setTitleColor:KNaviColor];
        [button setTitleNormal:@"@提醒谁看"];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(noticeButtonAction)];
            [_commentNewView addSubview:button];
        
        UIButton *sendButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 100, CGRectGetMinY(button.frame), 90, 45)];
        [sendButton setTitleColor:[UIColor blackColor]];
        [sendButton setTitleNormal:@"发表"];
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        sendButton.backgroundColor = KNaviColor;
        sendButton.layer.cornerRadius = 5.f;
        [sendButton addTarget:self action:@selector(sendCommentAction)];
        [_commentNewView addSubview:sendButton];
        
        [self.view addSubview:_commentNewView];
        
    }
    return _commentNewView;
}

- (NSMutableArray *)commentLileList {
    if (!_commentLileList) {
        _commentLileList = [NSMutableArray array];
    }
    return _commentLileList;
}

- (MJKPhotoView *)tableCommentPhoto {
    DBSelf(weakSelf);
    if (!_tableCommentPhoto) {
        _tableCommentPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.commentText.frame) + 5, KScreenWidth, 130)];
        _tableCommentPhoto.isEdit = YES;
        _tableCommentPhoto.isCamera = NO;
        _tableCommentPhoto.rootVC = self;
        _tableCommentPhoto.titleNameStr = @"评论";
        _tableCommentPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.commentLileList removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                [weakSelf.commentLileList addObject:@{@"saveUrl" : saveArr[i]}];
            }
        };
    }
    return _tableCommentPhoto;
};



- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
        _tableFootPhoto.isEdit = YES;
        _tableFootPhoto.isCamera = NO;
        _tableFootPhoto.rootVC = self;
        _tableFootPhoto.imageURLArray = self.showFileListDjzs;
        _tableFootPhoto.titleNameStr = @"登记证书";
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.fileListDjzs removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                [weakSelf.fileListDjzs addObject:@{@"saveUrl" : saveArr[i]}];
            }
//            weakSelf.mainModel.urlList = arr;
        };
    }
    return _tableFootPhoto;
};

- (MJKPhotoView *)tableFoot1Photo {
    DBSelf(weakSelf);
    if (!_tableFoot1Photo) {
        _tableFoot1Photo = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableFootPhoto.frame), KScreenWidth, 180)];
        _tableFoot1Photo.isEdit = YES;
        _tableFoot1Photo.isCamera = NO;
        _tableFoot1Photo.rootVC = self;
        _tableFoot1Photo.imageURLArray = self.showFileListXsz;
        _tableFoot1Photo.titleNameStr = @"行驶证";
        _tableFoot1Photo.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            [weakSelf.fileListXsz removeAllObjects];
            for (int i = 0; i < arr.count; i++) {
                [weakSelf.fileListXsz addObject:@{@"saveUrl" : saveArr[i]}];
            }
//            weakSelf.mainModel.urlList = arr;
        };
    }
    return _tableFoot1Photo;
};

- (NSMutableArray *)fileListDjzs {
    if (!_fileListDjzs) {
        _fileListDjzs = [NSMutableArray  array];
    }
    return _fileListDjzs;
}

- (NSMutableArray *)fileListXsz {
    if (!_fileListXsz) {
        _fileListXsz = [NSMutableArray  array];
    }
    return _fileListXsz;
}

- (NSMutableArray *)showFileListDjzs {
    if (!_showFileListDjzs) {
        _showFileListDjzs = [NSMutableArray  array];
    }
    return _showFileListDjzs;
}

- (NSMutableArray *)showFileListXsz {
    if (!_showFileListXsz) {
        _showFileListXsz = [NSMutableArray  array];
    }
    return _showFileListXsz;
}
@end
