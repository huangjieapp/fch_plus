//
//  MJKMortgageViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/9/29.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKMortgageViewController.h"

#import "MJKChooseNewBrandViewController.h"
#import "MJKChooseMoreEmployeesViewController.h"

#import "PotentailCustomerEditModel.h"
#import "MJKMortgageModel.h"
#import "MJKProductShowModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "MJKSalesCommentTableViewCell.h"

#import "MJKPhotoView.h"
#import "MJKCommentsListModel.h"


#import "MJKMessageDetailModel.h"
#import "MJKApprovalHistoryModel.h"
#import "MJKCcApprovalTableViewCell.h"

@interface MJKMortgageViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *localDatas;
/** <#注释#>*/
@property (nonatomic, strong) MJKMortgageModel *model;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) MJKProductShowModel *productModel;


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

/** <#注释#> */
@property (nonatomic,strong) UIButton *submitButton;
@end

@implementation MJKMortgageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"按揭信息";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self commentNewView];
    [self getMortgageInfo];
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
        if (self.proButton.tag == 100 || self.proButton == nil) {
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
    if ([model.locatedTitle isEqualToString:@"类型"]) {
        ccell.Type = ChooseTableViewTypeA802_C_TYPE;
        ccell.C_TYPECODE = @"A802_C_TYPE";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_TYPE_DD_ID = postValue;
            weakSelf.model.C_TYPE_DD_NAME = str;
            model.postValue = postValue;
            model.nameValue = str;
            [weakSelf getLocalDatas];
//            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"日期"]|| [model.locatedTitle isEqualToString:@"放款日期"] || [model.locatedTitle isEqualToString:@"结算日期"]) {
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
    } else if ([model.locatedTitle isEqualToString:@"过户时间"]) {
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
    } else if ([model.locatedTitle isEqualToString:@"过户次数"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
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
    } else if ([model.locatedTitle isEqualToString:@"开票单位"])  {
        iCell.tagLabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"车架号"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"车辆类型"])  {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80200_C_CPTYPE;
        ccell.C_TYPECODE = @"A80200_C_CARTYPE";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"联系人"])  {
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
    } else if ([model.locatedTitle isEqualToString:@"车牌类型"])  {
        ccell.Type = ChooseTableViewTypeA80200_C_CARTYPE;
        ccell.C_TYPECODE = @"A80200_C_CPTYPE";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"上牌地"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"交车时间"]) {
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
    } else if ([model.locatedTitle isEqualToString:@"贷款额"])  {
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
    }  else if ([model.locatedTitle isEqualToString:@"收款账户"])  {
        ccell.taglabel.hidden = NO;
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
    } else if ([model.locatedTitle isEqualToString:@"贷款年限"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80200_C_DKNX;
        ccell.C_TYPECODE = @"A80200_C_DKNX";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"按揭利息点数"])  {
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
    } else if ([model.locatedTitle isEqualToString:@"按揭手续费"])  {
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
    } else if ([model.locatedTitle isEqualToString:@"公证抵押费"])  {
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
    } else if ([model.locatedTitle isEqualToString:@"押金"])  {
//        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"返点(%)"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"押金收款账号"] || [model.locatedTitle isEqualToString:@"结算账号"] || [model.locatedTitle isEqualToString:@"手续费收款账号"] || [model.locatedTitle isEqualToString:@"公证费收款账号"])  {
        ccell.Type = ChooseTableViewTypeA800YJSHZH;
//        if ([model.locatedTitle isEqualToString:@"押金收款账号"]) {
//            ccell.C_TYPECODE = @"A80000_C_TYPE_0004";
//        } else if ([model.locatedTitle isEqualToString:@"结算账号"]) {
            ccell.C_TYPECODE = @"A80000_C_TYPE_0004";
//        }
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"自收手续费用"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
    } /*else if ([model.locatedTitle isEqualToString:@"手续费收款账号"])  {
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0004"
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            
        };
        return ccell;
    }*/ else if ([model.locatedTitle isEqualToString:@"按揭公司"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80000_C_TYPE;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0001";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"放款银行"]) {
        ccell.taglabel.hidden = NO;
        ccell.Type = ChooseTableViewTypeA80000_C_TYPE;
        ccell.C_TYPECODE = @"A80000_C_TYPE_0002";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
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
        
    } else if ([model.locatedTitle isEqualToString:@"附加备注"]){
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
    } else if ([model.locatedTitle isEqualToString:@"跟进星级"]) {
        ccell.Type = ChooseTableViewTypeA475List;
        ccell.C_TYPECODE = @"51";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
    } else if ([model.locatedTitle isEqualToString:@"按揭利息返利"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 3 inSection:indexPath.section], [NSIndexPath indexPathForRow:indexPath.row + 5 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"手续费利润"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section], [NSIndexPath indexPathForRow:indexPath.row + 4 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"手续费"])  {
        iCell.tagLabel.hidden = NO;
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section], [NSIndexPath indexPathForRow:indexPath.row + 3 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"按揭总利润"])  {
        CGFloat amount = 0;
        NSArray *arr = self.localDatas[indexPath.section];
        PotentailCustomerEditModel *model = arr[indexPath.row - 1];//手续费
        amount += model.postValue.floatValue;
        model = arr[indexPath.row - 2];//手续费利润
        amount += model.postValue.floatValue;
        model = arr[indexPath.row - 3];//按揭利息返利
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
    } else if ([model.locatedTitle isEqualToString:@"自收费用"])  {
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
            [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        };
        return iCell;
    } else if ([model.locatedTitle isEqualToString:@"未结算费用"])  {
        CGFloat amount = 0;
        NSArray *arr = self.localDatas[indexPath.section];
        PotentailCustomerEditModel *model4 = arr[indexPath.row - 3];//手续费
        PotentailCustomerEditModel *model5 = arr[indexPath.row - 4];//手续费
        PotentailCustomerEditModel *model6 = arr[indexPath.row - 5];//手续费
        PotentailCustomerEditModel *model1 = arr[indexPath.row - 1];//手续费
        amount = model4.postValue.floatValue + model5.postValue.floatValue +  model6.postValue.floatValue  - model1.postValue.floatValue;
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
    } else if ([model.locatedTitle isEqualToString:@"结算状态"]) {
        ccell.Type = ChooseTableViewTypeJSSTATUS;
        ccell.C_TYPECODE = @"A802_C_JSSTATUS";
        if (model.postValue.length > 0) {
            ccell.textStr = model.nameValue;
        }
        
        ccell.chooseBlock = ^(NSString *str, NSString *postValue) {
            model.postValue = postValue;
            model.nameValue = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return ccell;
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
        if (model.postValue.length > 0) {
            iCell.textStr = model.nameValue;
        }
        iCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        iCell.changeTextBlock = ^(NSString *textStr) {
            model.nameValue = textStr;
            model.postValue = textStr;
        };
        return iCell;
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
    if ([model.locatedTitle isEqualToString:@"备注"] || [model.locatedTitle isEqualToString:@"附加备注"]) {
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
    label.text = @[@"基础信息", @"利润相关信息"][section];
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

- (void)getMortgageInfo {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A42000_C_ID.length > 0) {
        contentDic[@"C_A42000_C_ID"] = self.C_A42000_C_ID;
    }
    if (self.C_ID.length > 0) {
        contentDic[@"C_ID"] = self.C_ID;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEM802INFO parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.model = [MJKMortgageModel mj_objectWithKeyValues:data[@"data"]];
            if (![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80200_C_STATUS_0000"] && ![weakSelf.model.C_STATUS_DD_ID isEqualToString:@"A80200_C_STATUS_0003"]) {
                weakSelf.submitButton.hidden = YES;
                if (weakSelf.C_ID.length <= 0) {
                    CGRect frame = weakSelf.tableView.frame;
                    frame.size.height += 50;
                    weakSelf.tableView.frame = frame;
                }
//                weakSelf.bottomView.hidden = YES;
//                CGRect frame = weakSelf.tableView.frame;
//                frame.size.height += weakSelf.bottomView.frame.size.height;
//                weakSelf.tableView.frame = frame;
            }
            
            [weakSelf getLocalDatas];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitMortgageInfo {
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
    } else {
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
    
//    NSArray *arr = self.localDatas[0];
//    for (PotentailCustomerEditModel *model in arr) {
////        if ([model.keyValue isEqualToString:@"D_AJRQ"] || [model.keyValue isEqualToString:@"D_SEND_TIME"]) {
////
////            contentDic[model.keyValue] = [model.postValue stringByAppendingString:@" 00:00:00"];
////        } else {
//            if (model.postValue.length > 0 && model.keyValue.length > 0) {
//                contentDic[model.keyValue] = model.postValue;
//            }
////        }
//    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_SYSTEMD802EDIT parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
//            [MJKApprovalRequest HttpApprovalRequestWithC_OBJECT_ID:self.model.C_ID andC_TYPE_DD_ID:@"A42500_C_TYPE_0009" andSuccessBlock:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)submitButtonAction {

    if (![[NewUserSession instance].appcode containsObject:@"crm:a802:force_update"]) {
        if (![[NewUserSession instance].appcode containsObject:@"crm:a802:edit"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
    }
    
    for (NSArray *arr in self.localDatas) {
        for (PotentailCustomerEditModel *model in arr) {
            if ([model.locatedTitle isEqualToString:@"开票单位"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入开票单位"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"开票价"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入开票价"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"车辆类型"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请选择车辆类型"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"交车时间"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请选择交车时间"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"贷款额"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入贷款额"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"收款账户"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入收款账户"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"贷款年限"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请选择贷款年限"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"按揭利息点数"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入按揭利息点数"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"按揭手续费"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入按揭手续费"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"公证抵押费"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入公证抵押费"];
                    return;
                }
            }
            
//            if ([model.locatedTitle isEqualToString:@"押金"]) {
//                if (model.postValue.length <= 0) {
//                    [JRToast showWithText:@"请输入押金"];
//                    return;
//                }
//            }
            
            if ([model.locatedTitle isEqualToString:@"按揭公司"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请选择按揭公司"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"放款银行"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请选择放款银行"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"按揭利息返利"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入按揭利息返利"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"手续费利润"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入手续费利润"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"手续费"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入手续费"];
                    return;
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"销售顾问提成"]) {
                if (model.postValue.length <= 0) {
                    [JRToast showWithText:@"请输入销售顾问提成"];
                    return;
                }
            }
        }
    }
    
    [self submitMortgageInfo];
}

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
            [submitButton setTitleNormal:@"提交"];
            [submitButton setTitleColor:[UIColor blackColor]];
            [submitButton setBackgroundColor:KNaviColor];
            [submitButton addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:submitButton];
        } else {
            UIButton *submitButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 5, _bottomView.frame.size.width - 10, 45)];
            self.submitButton = submitButton;
            submitButton.layer.cornerRadius = 5.f;
            [submitButton setTitleNormal:@"提交"];
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
        NSArray*localArr=@[@"类型",@"门店",@"销售顾问",@"开票单位",@"开票价",@"上牌地",@"品牌车型",@"联系人",@"电话",@"车辆类型"];
        NSArray*localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
        NSArray*localKeyArr=@[@"C_TYPE_DD_ID",@"C_LOCNAME",@"C_OWNER_ROLENAME",@"C_BILLING",@"B_KPJ",@"C_SPD",@"C_A49600_C_ID",@"C_LXR",@"C_PHONE",@"C_CARTYPE_DD_ID",@"D_GHSJ",@"I_GHCS"];
    if ([self.model.C_TYPE_DD_ID  isEqualToString:@"A802_C_TYPE_0000"]) {//已形成订单
        localArr=@[@"类型",@"门店",@"销售顾问",@"开票单位",@"开票价",@"上牌地",@"品牌车型",@"联系人",@"电话",@"车辆类型", @"车架号", @"交车时间", @"贷款额",@"收款账户", @"贷款年限", @"按揭利息点数", @"按揭手续费",@"手续费收款账号", @"公证抵押费",@"公证费收款账号", @"备注"];
        localValueArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
        localPostNameArr=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
        localKeyArr=@[@"C_TYPE_DD_ID",@"C_LOCNAME",@"C_OWNER_ROLENAME",@"C_BILLING",@"B_KPJ",@"C_SPD",@"C_A49600_C_ID",@"C_LXR",@"C_PHONE",@"C_CARTYPE_DD_ID", @"C_VIN", @"D_SEND_TIME", @"B_DKE",@"C_A800SKZH_C_ID", @"C_DKNX_DD_ID", @"B_AJLXDS", @"B_AJSXF",@"C_A800SXFSHZHFJ_C_ID", @"B_GZDYF",@"C_A800SXFSHZH_C_ID", @"X_REMARK"];
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
    
    
    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    if ([self.model.C_TYPE_DD_ID  isEqualToString:@"A802_C_TYPE_0000"]) {//已形成订单
        NSArray*localArr1=@[ @"跟进星级", @"押金",@"返点(%)", @"押金收款账号", @"按揭公司", @"放款银行", @"按揭利息返利", @"手续费利润", @"手续费", @"按揭总利润", @"自收费用", @"未结算费用", @"放款日期", @"结算状态", @"结算日期", @"结算金额", @"结算账号", @"销售顾问提成", @"经理/副店提成", @"店总提成", @"附加备注"];
        NSArray*localValueArr1=@[ @"", @"",@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
        NSArray*localPostNameArr1=@[@"", @"",@"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @""];
        NSArray*localKeyArr1=@[@"C_LEVEL_DD_ID", @"B_YJ",@"B_FD", @"C_A800YJSHZH_C_ID", @"C_A80000AJ_C_ID", @"C_A80000YH_C_ID", @"B_AJLXFL", @"B_ZFLR", @"B_ZSSXF", @"", @"B_ZSFY", @"", @"D_AJRQ", @"C_JSSTATUS_DD_ID", @"D_JSRQ", @"B_JSJE", @"C_A800JSZH_C_ID", @"B_SXGWTC", @"B_JLTC", @"B_DZTC", @"X_FJCZREMARK"];
        for (int i=0; i<localArr1.count; i++) {
            PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
            model.locatedTitle=localArr1[i];
            model.nameValue=localValueArr1[i];
            model.postValue=localPostNameArr1[i];
            model.keyValue=localKeyArr1[i];
            
            [saveLocalArr1 addObject:model];
        }
    }
    if ([[NewUserSession instance].appcode containsObject:@"crm:a802:show_profit"]) {
        if ([self.model.C_TYPE_DD_ID  isEqualToString:@"A802_C_TYPE_0000"]) {
            self.localDatas = [NSMutableArray arrayWithObjects:saveLocalArr,saveLocalArr1,nil];
        } else {
            self.localDatas = [NSMutableArray arrayWithObject:saveLocalArr];
        }
    } else {
        self.localDatas = [NSMutableArray arrayWithObject:saveLocalArr];
    }
    
    
    [self getPostValueAndBeforeValue];
}

-(void)getPostValueAndBeforeValue{
    
    NSArray*section0ShowNameArray =@[self.model.C_TYPE_DD_NAME.length > 0 ? self.model.C_TYPE_DD_NAME : @"",
                                     self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                     self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                     self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                     self.model.C_SPD.length > 0 ? self.model.C_SPD : @"",
                                     self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                     self.model.C_LXR.length > 0 ? self.model.C_LXR : @"",
                                     self.model.C_PHONE.length > 0 ? self.model.C_PHONE : @"",
                                     self.model.C_CARTYPE_DD_NAME.length > 0 ? self.model.C_CARTYPE_DD_NAME : @""];

    NSArray*section0PostNameArray =@[self.model.C_TYPE_DD_ID.length > 0 ? self.model.C_TYPE_DD_ID : @"",
                                     self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                     self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                     self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                     self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                     self.model.C_SPD.length > 0 ? self.model.C_SPD : @"",
                                     self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                     self.model.C_LXR.length > 0 ? self.model.C_LXR : @"",
                                     self.model.C_PHONE.length > 0 ? self.model.C_PHONE : @"",
                                     self.model.C_CARTYPE_DD_ID.length > 0 ? self.model.C_CARTYPE_DD_ID : @""];

    if ([self.model.C_TYPE_DD_ID  isEqualToString:@"A802_C_TYPE_0000"]) {
        section0ShowNameArray =@[self.model.C_TYPE_DD_NAME.length > 0 ? self.model.C_TYPE_DD_NAME : @"",
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                         self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                         self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                         self.model.C_SPD.length > 0 ? self.model.C_SPD : @"",
                                         self.model.C_A49600_C_NAME.length > 0 ? self.model.C_A49600_C_NAME : @"",
                                         self.model.C_LXR.length > 0 ? self.model.C_LXR : @"",
                                         self.model.C_PHONE.length > 0 ? self.model.C_PHONE : @"",
                                         self.model.C_CARTYPE_DD_NAME.length > 0 ? self.model.C_CARTYPE_DD_NAME : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.D_SEND_TIME.length > 0 ? self.model.D_SEND_TIME : @"",
                                         self.model.B_DKE.length > 0 ? self.model.B_DKE : @"",
                                 self.model.C_A800SKZH_C_NAME.length > 0 ? self.model.C_A800SKZH_C_NAME : @"",
                                         self.model.C_DKNX_DD_NAME.length > 0 ? self.model.C_DKNX_DD_NAME : @"",
                                         self.model.B_AJLXDS.length > 0 ? self.model.B_AJLXDS : @"",
                                         self.model.B_AJSXF.length > 0 ? self.model.B_AJSXF : @"",
                                 self.model.C_A800SXFSHZHFJ_C_NAME.length > 0 ? self.model.C_A800SXFSHZHFJ_C_NAME : @"",
                                         self.model.B_GZDYF.length > 0 ? self.model.B_GZDYF : @"",
                                 self.model.C_A800SXFSHZH_C_NAME.length > 0 ? self.model.C_A800SXFSHZH_C_NAME : @"",
                                         self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @""];
        
        section0PostNameArray =@[self.model.C_TYPE_DD_ID.length > 0 ? self.model.C_TYPE_DD_ID : @"",
                                         self.model.C_LOCNAME.length > 0 ? self.model.C_LOCNAME : @"",
                                         self.model.C_OWNER_ROLENAME.length > 0 ? self.model.C_OWNER_ROLENAME : @"",
                                         self.model.C_BILLING.length > 0 ? self.model.C_BILLING : @"",
                                         self.model.B_KPJ.length > 0 ? self.model.B_KPJ : @"",
                                         self.model.C_SPD.length > 0 ? self.model.C_SPD : @"",
                                         self.model.C_A49600_C_ID.length > 0 ? self.model.C_A49600_C_ID : @"",
                                         self.model.C_LXR.length > 0 ? self.model.C_LXR : @"",
                                         self.model.C_PHONE.length > 0 ? self.model.C_PHONE : @"",
                                         self.model.C_CARTYPE_DD_ID.length > 0 ? self.model.C_CARTYPE_DD_ID : @"",
                                         self.model.C_VIN.length > 0 ? self.model.C_VIN : @"",
                                         self.model.D_SEND_TIME.length > 0 ? self.model.D_SEND_TIME : @"",
                                         self.model.B_DKE.length > 0 ? self.model.B_DKE : @"",
                                 self.model.C_A800SKZH_C_ID.length > 0 ? self.model.C_A800SKZH_C_ID : @"",
                                         self.model.C_DKNX_DD_ID.length > 0 ? self.model.C_DKNX_DD_ID : @"",
                                         self.model.B_AJLXDS.length > 0 ? self.model.B_AJLXDS : @"",
                                         self.model.B_AJSXF.length > 0 ? self.model.B_AJSXF : @"",
                                 self.model.C_A800SXFSHZHFJ_C_ID.length > 0 ? self.model.C_A800SXFSHZHFJ_C_ID : @"",
                                         self.model.B_GZDYF.length > 0 ? self.model.B_GZDYF : @"",
                                 self.model.C_A800SXFSHZH_C_ID.length > 0 ? self.model.C_A800SXFSHZH_C_ID : @"",
                                         self.model.X_REMARK.length > 0 ? self.model.X_REMARK : @""];
    }
    
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    
    if ([[NewUserSession instance].appcode containsObject:@"crm:a802:show_profit"]) {
        if ([self.model.C_TYPE_DD_ID  isEqualToString:@"A802_C_TYPE_0000"]) {
            
            NSArray* section1ShowNameArray =@[self.model.C_LEVEL_DD_NAME.length > 0 ? self.model.C_LEVEL_DD_NAME : @"",
                                     self.model.B_YJ.length > 0 ? self.model.B_YJ : @"",
                                              self.model.B_FD.length > 0 ? self.model.B_FD : @"",
                                     self.model.C_A800YJSHZH_C_NAME.length > 0 ? self.model.C_A800YJSHZH_C_NAME : @"",
                                     self.model.C_A80000AJ_C_NAME.length > 0 ? self.model.C_A80000AJ_C_NAME : @"",
                                     self.model.C_A80000YH_C_NAME.length > 0 ? self.model.C_A80000YH_C_NAME : @"",
                                     self.model.B_AJLXFL.length > 0 ? self.model.B_AJLXFL : @"",
                                    self.model.B_ZFLR.length > 0 ? self.model.B_ZFLR : @"",
                                     self.model.B_ZSSXF.length > 0 ? self.model.B_ZSSXF : @"",
                                    @"",
                                     self.model.B_ZSFY.length > 0 ? self.model.B_ZSFY : @"",
                                    @"",
                                     self.model.D_AJRQ.length > 0 ? self.model.D_AJRQ : @"",
                                     self.model.C_JSSTATUS_DD_NAME.length > 0 ? self.model.C_JSSTATUS_DD_NAME : @"",
                                     self.model.D_JSRQ.length > 0 ? self.model.D_JSRQ : @"",
                             self.model.B_JSJE.length > 0 ? self.model.B_JSJE : @"",
                             self.model.C_A800JSZH_C_NAME.length > 0 ? self.model.C_A800JSZH_C_NAME : @"",
                             self.model.B_SXGWTC.length > 0 ? self.model.B_SXGWTC : @"",
                             self.model.B_JLTC.length > 0 ? self.model.B_JLTC : @"",
                             self.model.B_DZTC.length > 0 ? self.model.B_DZTC : @"",
                             self.model.X_FJCZREMARK.length > 0 ? self.model.X_FJCZREMARK : @""];
            
            NSArray* section1PostNameArray =@[self.model.C_LEVEL_DD_ID.length > 0 ? self.model.C_LEVEL_DD_ID : @"",
                                             self.model.B_YJ.length > 0 ? self.model.B_YJ : @"",
                                              self.model.B_FD.length > 0 ? self.model.B_FD : @"",
                                             self.model.C_A800YJSHZH_C_ID.length > 0 ? self.model.C_A800YJSHZH_C_ID : @"",
                                             self.model.C_A80000AJ_C_ID.length > 0 ? self.model.C_A80000AJ_C_ID : @"",
                                             self.model.C_A80000YH_C_ID.length > 0 ? self.model.C_A80000YH_C_ID : @"",
                                             self.model.B_AJLXFL.length > 0 ? self.model.B_AJLXFL : @"",
                                             self.model.B_ZFLR.length > 0 ? self.model.B_ZFLR : @"",
                                             self.model.B_ZSSXF.length > 0 ? self.model.B_ZSSXF : @"",
                                              @"",
                                             self.model.B_ZSFY.length > 0 ? self.model.B_ZSFY : @"",
                                              @"",
                                             self.model.D_AJRQ.length > 0 ? self.model.D_AJRQ : @"",
                                             self.model.C_JSSTATUS_DD_ID.length > 0 ? self.model.C_JSSTATUS_DD_ID : @"",
                                             self.model.D_JSRQ.length > 0 ? self.model.D_JSRQ : @"",
                                     self.model.B_JSJE.length > 0 ? self.model.B_JSJE : @"",
                                     self.model.C_A800JSZH_C_ID.length > 0 ? self.model.C_A800JSZH_C_ID : @"",
                                     self.model.B_SXGWTC.length > 0 ? self.model.B_SXGWTC : @"",
                                     self.model.B_JLTC.length > 0 ? self.model.B_JLTC : @"",
                                     self.model.B_DZTC.length > 0 ? self.model.B_DZTC : @"",
                                     self.model.X_FJCZREMARK.length > 0 ? self.model.X_FJCZREMARK : @""];
            NSMutableArray*MainArray1=self.localDatas[1];
            for (int i=0; i<MainArray1.count; i++) {
                PotentailCustomerEditModel*model=MainArray1[i];
                model.nameValue=section1ShowNameArray[i];
                model.postValue=section1PostNameArray[i];
            }
        }
    }
    
    

    
//
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
//        [button addTarget:self action:@selector(submitButtonAction) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView addSubview:button];
//    }
//    return _bottomView;
//}
@end
