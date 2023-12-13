//
//  MJKChangeOrderStatusView.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/23.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKChangeOrderStatusView.h"
#import "MJKMessagePushNotiViewController.h"

#import "CGCOrderDetialFooter.h"
#import "KSPhotoItem.h"
#import "KSPhotoBrowser.h"

#import "CGCOrderDetailModel.h"

#import "CGCOrderDetailNormalCell.h"
#import "MJKMarketViewController.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKPhotoView.h"
#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"

@interface MJKChangeOrderStatusView ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UIView *changeView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) CGCOrderDetialFooter *tableFoot;
@property (nonatomic, strong) NSString *timeStr;
@property (nonatomic, strong) NSString *startStr;
@property (nonatomic, strong) NSString *finshStr;
@property (nonatomic, strong) UIButton *pickerBtn;
@property (nonatomic, assign) NSInteger indexBtn;
@property (nonatomic, strong) NSString *patchUrl;//图片路径
@property (nonatomic, strong) NSString *imgUrl1;
@property (nonatomic, strong) NSString *imgUrl2;
@property (nonatomic, strong) NSString *imgUrl3;
@property (nonatomic, strong) NSString *imgStr;
@property (nonatomic, strong) NSString *row0Str;
@property (nonatomic, strong) NSString *row1Str;
@property (nonatomic, strong) NSString *saleStr;
@property (nonatomic, strong) NSMutableArray *categroyArray;
@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryID;
@property (nonatomic, strong) NSString *orderMoney;
/**收据编号 C_MERCHANT_ORDER_NO*/
@property (nonatomic, strong) NSString *C_MERCHANT_ORDER_NO;
/**收款方式 C_PAYCHANNEL*/
@property (nonatomic, strong) NSString *C_PAYCHANNEL;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_PAYCHANNELNAME;
/** date picker*/
@property (nonatomic, strong) UIDatePicker *datePicker;
/** commit*/
@property (nonatomic, strong) UIButton *commitButton;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** bottom view*/
@property (nonatomic, strong) UIView *bottomView;
/** 负责人*/
@property (nonatomic, strong) NSString *principalStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *principalID;

@property (nonatomic, strong) NSString *yjAddress;

@property (nonatomic, strong) NSString *fdjqh;
@property (nonatomic, strong) NSString *cksj;
@end

@implementation MJKChangeOrderStatusView

- (instancetype)initWithFrame:(CGRect)frame andTitleNameArr:(NSArray *)titleArr andRootVC:(UIViewController *)rootVC {
    if (self = [super initWithFrame:frame]) {
        NSDate *Date = [NSDate date];
        NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
        birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.timeStr = [birthformatter stringFromDate:Date];
        self.rootVC = rootVC;
        self.titleArray = titleArr;
        [self initUIWithTitleNameArr:titleArr];
    }
    return self;
}

- (void)initUIWithTitleNameArr:(NSArray *)titleArr {
    UIView *bgView = [[UIView alloc]initWithFrame:self.frame];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .5f;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [bgView addGestureRecognizer:tapGR];
    [self addSubview:bgView];
    
//    CGFloat height = titleArr.count * 52 + 170 + 40 + SafeAreaBottomHeight;
    UIView *changeView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight , KScreenWidth, KScreenHeight)];
    changeView.backgroundColor = [UIColor whiteColor];
    changeView.tag = 100;
    [self addSubview:changeView];
    self.changeView = changeView;
//    [self addSubview:self.commitButton];
//    [self addSubview:self.bottomView];
    [changeView addSubview:self.tableview];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (void)setDetailModel:(CGCOrderDetailModel *)detailModel {
    _detailModel = detailModel;
    if ([self.VCName isEqualToString:@"全款"]) {
        self.C_MERCHANT_ORDER_NO = detailModel.C_VIN;
        self.C_PAYCHANNEL = detailModel.C_BILLING;
        self.row0Str = detailModel.C_SPD;
        self.orderMoney = detailModel.B_LICENCEFEE;
        self.startStr = detailModel.B_INSURANCEFEE;
        self.categoryID = detailModel.B_FINANCIALFEE;
        self.projectManagerID = detailModel.B_WARRANTYFEE;
        self.finshStr = detailModel.B_DECORATEFEE;
        self.principalID = detailModel.X_REMARK;
        self.fdjqh = detailModel.C_GDSPR;
        self.yjAddress = detailModel.C_ADDRESS;
        self.cksj = detailModel.D_SHSJ_TIME;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSArray *btArray = [NewUserSession instance].configData.btListDd;
    CGCOrderDetailNormalCell * cell=[CGCOrderDetailNormalCell cellWithTableView:tableView withType:CGCOrderDetailNormalCellEidt];
    cell.textfield.delegate = self;
    cell.textfield.tag = indexPath.row;
    cell.titleLab.text = self.titleArray[indexPath.row];
    if ([self.VCName isEqualToString:@"方案"]) {
        NSString *str = self.titleArray[indexPath.row];
        if ([str isEqualToString:@"设计师"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=NO;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([NewUserSession instance].configData.C_DESIGNER_ROLEID.length > 0) {
                cell.chooseTextField.enabled = NO;
            }
            if (self.row1Str.length > 0) {
                /*
                 weakSelf.row1Str = model.user_name;
                 weakSelf.saleStr = model.user_id;
                 */
                cell.textStr=self.row1Str;
            }else{
                
                cell.textStr=nil;
            }
            cell.Type=chooseTypeNil;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                    
                    
                    weakSelf.row1Str = showModel.user_name;
                    weakSelf.saleStr = showModel.user_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
//                    [weakSelf HttpAddDesignerWithAndOrder:weakSelf.orderID andDesigner:showModel.user_id andType:@"设计师" andSuccessBlock:nil];
                    
                };
                [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                
                
            };
            return cell;
        } else if ([str isEqualToString:@"首次沟通时间"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if (self.timeStr.length > 0) {
                cell.textStr=self.timeStr;
            }else{
                cell.textStr=nil;
            }
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                    weakSelf.timeStr=postValue;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            return cell;
        }
    } else if ([self.VCName isEqualToString:@"全款"]){
        NSString *str = self.titleArray[indexPath.row];
        if (indexPath.row == 0) {
            //收货人
            cell.selBtn.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.textfield.placeholder = @"请选择";
            cell.textFieldLayout.constant = 30;
            cell.textfield.enabled = NO;
            [cell.selBtn addTarget:self action:@selector(selectOrderManager:) forControlEvents:UIControlEventTouchUpInside];
            if (self.row1Str.length > 0) {
                cell.textfield.text = self.row1Str;
            } else {
                if ([self.stateName isEqualToString:@"安装"]) {
                    cell.mustLabel.hidden = NO;
                } else {
                    cell.textfield.text = [NewUserSession instance].user.nickName;
                    self.saleStr = [NewUserSession instance].user.u051Id;
                }
            }
        } else if (indexPath.row == 1) {
            //到货时间
//            cell.textfield.userInteractionEnabled=NO;
//            cell.selBtn.hidden=NO;
//            cell.rightImage.hidden = NO;
//            cell.textFieldLayout.constant = 30;
//
//            NSDate *Date = [NSDate date];
//            NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
//            birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//            cell.textfield.text= self.timeStr.length > 0 ? self.timeStr : [birthformatter stringFromDate:Date];
//            [cell.selBtn addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.isTitle = YES;
            cell.chooseTextField.textColor = [UIColor blackColor];
            if ([btArray containsObject:@"A47500_C_DDBTX_0016"]) {
                cell.taglabel.hidden = NO;
            }
            cell.nameTitleLabel.text=str;
            if (self.timeStr.length > 0) {
                cell.textStr = self.timeStr;
            }
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.timeStr = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
            
        } else if ([str isEqualToString:@"出库时间"]) {
            
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.isTitle = YES;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([self.cksj length] > 0) {
                cell.textStr = self.cksj;
            }
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.cksj = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
        } else if ([str isEqualToString:@"安装负责人"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([NewUserSession instance].configData.C_AZRY_ROLEID.length > 0) {
                cell.chooseTextField.enabled = NO;
            }
            if (self.principalStr.length > 0) {
                cell.textStr=self.principalStr;
            }else{
                cell.textStr=nil;
            }
            cell.Type=chooseTypeNil;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                    weakSelf.principalStr=showModel.user_name;
                    weakSelf.principalID=showModel.user_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                
                
            };
            return cell;
        } else if ([str isEqualToString:@"上牌地"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([NewUserSession instance].configData.C_AZRY_ROLEID.length > 0) {
                cell.chooseTextField.enabled = NO;
            }
            if (self.row0Str.length > 0) {
                cell.textStr=self.row0Str;
            }else{
                cell.textStr=nil;
            }
            cell.Type=ChooseTableViewTypeCity;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.row0Str = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            };
            return cell;
        } else {
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        
            cell.nameTitleLabel.text = str;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            if ([str isEqualToString:@"车架号全号"] || [str isEqualToString:@"开票名称"] || [str isEqualToString:@"备注"] || [str isEqualToString:@"邮寄地址"] || [str isEqualToString:@"发动机全号"]) {
                cell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            } else {
                cell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
            }
            if ([str isEqualToString:@"购买车型"]) {
                cell.inputTextField.text = self.detailModel.C_A49600_C_NAME;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.enabled = NO;
            } else if ([str isEqualToString:@"车架号全号"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.tag = 10086;
                cell.textFieldLength = 17;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.C_MERCHANT_ORDER_NO;
            } else if ([str isEqualToString:@"开票名称"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.C_PAYCHANNEL;
            } else if ([str isEqualToString:@"上牌费"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.orderMoney;
            } else if ([str isEqualToString:@"保险费"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.startStr;
            } else if ([str isEqualToString:@"按揭费"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.categoryID;
            } else if ([str isEqualToString:@"质保费"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.projectManagerID;
            } else if ([str isEqualToString:@"精品费"]) {
                cell.tagLabel.hidden = YES;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.finshStr;
            } else if ([str isEqualToString:@"其他费用"]) {
                cell.inputTextField.enabled = NO;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = [NSString stringWithFormat:@"%.2f",self.orderMoney.floatValue + self.startStr.floatValue + self.categoryID.floatValue + self.projectManagerID.floatValue + self.finshStr.floatValue];
            } else if ([str isEqualToString:@"邮寄地址"]) {
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.yjAddress;
            } else if ([str isEqualToString:@"发动机全号"]) {
                cell.inputTextField.tag = 10087;
                cell.textFieldLength = 14;
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.fdjqh;
            } else if ([str isEqualToString:@"备注"]) {
                cell.inputTextField.textColor = [UIColor blackColor];
                cell.inputTextField.text = self.principalID;
                cell.textBeginEditBlock = ^{
                    CGRect frame = weakSelf.tableview.frame;
                    frame.origin.y = -300;
                    weakSelf.tableview.frame = frame;
                };
                cell.textEndEditBlock = ^{
                    
                    CGRect frame = weakSelf.tableview.frame;
                    frame.origin.y = 0;
                    weakSelf.tableview.frame = frame;
                };
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                if ([str isEqualToString:@"车架号全号"]) {
                    weakSelf.C_MERCHANT_ORDER_NO = textStr;
                } else if ([str isEqualToString:@"开票名称"]) {
                    weakSelf.C_PAYCHANNEL = textStr;
                } else if ([str isEqualToString:@"上牌费"]) {
                    weakSelf.orderMoney = textStr;
                } else if ([str isEqualToString:@"保险费"]) {
                    weakSelf.startStr = textStr;
                } else if ([str isEqualToString:@"按揭费"]) {
                    weakSelf.categoryID = textStr;
                } else if ([str isEqualToString:@"质保费"]) {
                    weakSelf.projectManagerID = textStr;
                } else if ([str isEqualToString:@"精品费"]) {
                    weakSelf.finshStr = textStr;
                }  else if ([str isEqualToString:@"邮寄地址"]) {
                    weakSelf.yjAddress = textStr;
                }  else if ([str isEqualToString:@"发动机全号"]) {
                    weakSelf.fdjqh = textStr;
                } else if ([str isEqualToString:@"备注"]) {
                    weakSelf.principalID = textStr;
                }
                [tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:11 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            };
            return cell;
        }
    } else if ([self.VCName isEqualToString:@"交付"]) {
        
            NSString *str = self.titleArray[indexPath.row];
        if ([str isEqualToString:@"出库时间"]) {
                
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.isTitle = YES;
            cell.chooseTextField.textColor = [UIColor blackColor];
                cell.taglabel.hidden = NO;
            cell.nameTitleLabel.text=str;
            if (self.timeStr.length > 0) {
                cell.textStr = self.timeStr;
            }
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.timeStr = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
        } else if ([str isEqualToString:@"邮寄地址"]) {
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            cell.titleBGView.hidden = NO;
            cell.inputTextField.tag = indexPath.row;
            cell.titleLeftLayout.constant = 10;
            cell.inputTextField.delegate=self;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
                cell.tagLabel.hidden = NO;
            cell.nameTitleLabel.text=str;   //标题
            cell.inputTextField.textColor = [UIColor blackColor];
            if (self.yjAddress.length > 0) {
                
                cell.textStr= self.yjAddress;
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.yjAddress = textStr;
            };
            return cell;
        } else if ([str isEqualToString:@"开票名称"]) {
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            cell.titleBGView.hidden = NO;
            cell.inputTextField.tag = indexPath.row;
            cell.titleLeftLayout.constant = 10;
            cell.inputTextField.delegate=self;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
                cell.tagLabel.hidden = NO;
            cell.nameTitleLabel.text=str;   //标题
            cell.inputTextField.textColor = [UIColor blackColor];
            if (self.C_MERCHANT_ORDER_NO.length > 0) {
                
                cell.textStr= self.C_MERCHANT_ORDER_NO;
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.C_MERCHANT_ORDER_NO = textStr;
            };
            return cell;
        }
    }
    else if ([self.VCName isEqualToString:@"安装"]) {
        NSString *str = self.titleArray[indexPath.row];
        if (indexPath.row == 0) {
            //收货人
            cell.selBtn.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.textfield.placeholder = @"请选择";
            cell.textFieldLayout.constant = 30;
            cell.textfield.enabled = NO;
            [cell.selBtn addTarget:self action:@selector(selectOrderManager:) forControlEvents:UIControlEventTouchUpInside];
            if (self.row1Str.length > 0) {
                cell.textfield.text = self.row1Str;
            } else {
                if ([self.stateName isEqualToString:@"安装"]) {
                    cell.mustLabel.hidden = NO;
                } else {
                cell.textfield.text = [NewUserSession instance].user.nickName;
                self.saleStr = [NewUserSession instance].user.u051Id;
                }
            }
        } else if (indexPath.row == 1) {
            //到货时间
            cell.textfield.userInteractionEnabled=NO;
            cell.selBtn.hidden=NO;
            cell.rightImage.hidden = NO;
            cell.textFieldLayout.constant = 30;
            
            NSDate *Date = [NSDate date];
            NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
            birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            cell.textfield.text= self.timeStr.length > 0 ? self.timeStr : [birthformatter stringFromDate:Date];
            [cell.selBtn addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
            
            
        } else if ([str isEqualToString:@"安装负责人"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([NewUserSession instance].configData.C_AZRY_ROLEID.length > 0) {
                cell.chooseTextField.enabled = NO;
            }
            if (self.principalStr.length > 0) {
                cell.textStr=self.principalStr;
            }else{
                cell.textStr=nil;
            }
            cell.Type=chooseTypeNil;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                    weakSelf.principalStr=showModel.user_name;
                    weakSelf.principalID=showModel.user_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                
                
            };
            return cell;
        }
    } else
    if ([self.VCName isEqualToString:@"下单"]) {
        NSString *str = self.titleArray[indexPath.row];
        if ([str isEqualToString:@"下单员"]) {
            //下单员
            cell.selBtn.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.textfield.placeholder = @"请选择";
            cell.textFieldLayout.constant = 30;
            cell.textfield.enabled = NO;
            [cell.selBtn addTarget:self action:@selector(selectOrderManager:) forControlEvents:UIControlEventTouchUpInside];
            if (self.row1Str.length > 0) {
                cell.textfield.text = self.row1Str;
            } else {
                cell.textfield.text = [NewUserSession instance].user.nickName;
                self.saleStr = [NewUserSession instance].user.u051Id;
            }
            
            
        } else if ([str isEqualToString:@"下单金额"]) {
            cell.textfield.keyboardType = UIKeyboardTypeDecimalPad;
        } else if ([str isEqualToString:@"下单时间"]) {
            cell.textfield.userInteractionEnabled=NO;
            cell.selBtn.hidden=NO;
            cell.rightImage.hidden = NO;
            cell.textFieldLayout.constant = 30;
            NSDate *Date = [NSDate date];
            NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
            birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            cell.textfield.text= self.timeStr.length > 0 ? self.timeStr : [birthformatter stringFromDate:Date];
            [cell.selBtn addTarget:self action:@selector(dateSelect:) forControlEvents:UIControlEventTouchUpInside];
        } else if ([str isEqualToString:@"工厂单号"]) {
            cell.textfield.keyboardType = UIKeyboardTypeDefault;
        } else if ([str isEqualToString:@"仓储物流负责人"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([NewUserSession instance].configData.C_WLCCRY_ROLEID.length > 0) {
                cell.chooseTextField.enabled = NO;
            }
            if (self.principalStr.length > 0) {
                cell.textStr=self.principalStr;
            }else{
                cell.textStr=nil;
            }
            cell.Type=chooseTypeNil;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                    weakSelf.principalStr=showModel.user_name;
                    weakSelf.principalID=showModel.user_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                
                
            };
            return cell;
        }
            
    } else {
        NSString *str = self.titleArray[indexPath.row];
        if ([str isEqualToString:@"收款金额"]) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"收款金额*"];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(4, 1)];
            cell.titleLab.attributedText = attStr;
            if (self.row0Str.length > 0) {
                cell.textfield.text = self.row0Str;
            }
            cell.textfield.keyboardType = UIKeyboardTypeDecimalPad;
        } else if ([str isEqualToString:@"收款日期"]) {
            
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            cell.isTitle = YES;
            cell.textStr = self.timeStr.length > 0 ? self.timeStr : [DBTools getTimeFomatFromCurrentTimeStamp];
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.timeStr = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
        } else if ([str isEqualToString:@"预计交付时间"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.isTitle = YES;
            cell.chooseTextField.textColor = [UIColor blackColor];
            if ([btArray containsObject:@"A47500_C_DDBTX_0016"]) {
                cell.taglabel.hidden = NO;
            }
            cell.nameTitleLabel.text=str;
            if (self.finshStr.length > 0) {
                cell.textStr = self.finshStr;
            }
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.finshStr = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
        } else if ([str isEqualToString:@"预计下单时间"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.isTitle = YES;
            cell.chooseTextField.textColor = [UIColor blackColor];
            
            if (self.startStr.length > 0) {
                cell.textStr = self.startStr;
            }
            cell.nameTitleLabel.text=str;
            cell.Type=ChooseTableViewTypeAllTime;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.startStr = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            
            return cell;
        } else if ([str isEqualToString:@"项目经理"]) {
            cell.selBtn.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.textfield.placeholder = @"请选择";
            cell.textFieldLayout.constant = 30;
            cell.textfield.enabled = NO;
            if ([btArray containsObject:@"A47500_C_DDBTX_0017"]) {
                cell.mustLabel.hidden = NO;
            }
            [cell.selBtn addTarget:self action:@selector(selectProjectManager:) forControlEvents:UIControlEventTouchUpInside];
            if (self.projectManager.length > 0) {
                cell.textfield.text = self.projectManager;
            }
        }
        else if ([str isEqualToString:@"收款人"]) {
            cell.selBtn.hidden = NO;
            cell.rightImage.hidden = NO;
            cell.textfield.placeholder = @"请选择";
            cell.textFieldLayout.constant = 30;
            cell.textfield.enabled = NO;
            [cell.selBtn addTarget:self action:@selector(selectOrderManager:) forControlEvents:UIControlEventTouchUpInside];
            if (self.row1Str.length > 0) {
                cell.textfield.text = self.row1Str;
            } else {
                cell.textfield.text = [NewUserSession instance].user.nickName;
                self.saleStr = [NewUserSession instance].user.u051Id;
            }
        } else if ([str isEqualToString:@"类型"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.titleLeftLayout.constant = 10;
            cell.titleBGView.hidden = NO;
            cell.taglabel.hidden=YES;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if (self.categoryName.length > 0) {
                cell.textStr = self.categoryName;
            } else {
                cell.textStr = @"合同款";
                self.categoryID = @"A04200_C_TYPE_0001";
            }
            cell.Type=ChooseTableViewTypePaymentType;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.categoryID = postValue;
                weakSelf.categoryName = str;
                [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            };
            return cell;
        } else if ([str isEqualToString:@"产品总价"]) {
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:@"产品总价*"];
            [attStr addAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(4, 1)];
            cell.titleLab.attributedText = attStr;
            cell.textfield.keyboardType = UIKeyboardTypeDecimalPad;
            if ([self.qianyueDic[@"B_MONEY"] floatValue] == 0) {
                cell.textfield.placeholder = @"请输入";
            } else {
                cell.textfield.text = self.qianyueDic[@"B_MONEY"];
            }
        } else if ([str isEqualToString:@"优惠金额"]) {
            cell.textfield.keyboardType = UIKeyboardTypeDecimalPad;
            if ([self.qianyueDic[@"B_GUIDEPRICE"] floatValue] == 0) {
                cell.textfield.placeholder = @"请输入";
            } else {
                cell.textfield.text = self.qianyueDic[@"B_CASHDISCOUNT"];
            }
        } else if ([str isEqualToString:@"总金额"]) {
            NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@(不可修改)",str]];
            [titleStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.f] range:NSMakeRange(str.length, 5)];
            cell.titleLab.attributedText = titleStr;
            cell.textfield.enabled = NO;
            cell.textfield.text = self.qianyueDic[@"B_GUIDEPRICE"];
        } else if ([str isEqualToString:@"下单负责人"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.taglabel.hidden=YES;
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([NewUserSession instance].configData.C_BILLINGID.length > 0) {
                cell.chooseTextField.enabled = NO;
            }
            if (self.principalStr.length > 0) {
                cell.textStr=self.principalStr;
            }else{
                cell.textStr=nil;
            }
            cell.Type=chooseTypeNil;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
                    vc.isAllEmployees = @"是";
                }
                vc.noticeStr = @"无提示";
                vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                    weakSelf.principalStr=showModel.user_name;
                    weakSelf.principalID=showModel.user_id;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                //                vc.vcName = @"订单";
                //                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                //                    model.nameValue=nameStr;
                //                    model.postValue=codeStr;
                //                    //                    weakSelf.C_CLUEPROVIDER_ROLEID = codeStr;
                //                    //                    weakSelf.C_CLUEPROVIDER_ROLEStr = nameStr;
                //                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                //                };
                [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                
                
            };
            return cell;
        } else if ([str isEqualToString:@"收款方式"]) {
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            
            cell.titleBGView.hidden = NO;
            cell.titleLeftLayout.constant = 10;
            cell.chooseTextField.textColor = [UIColor blackColor];
            cell.nameTitleLabel.text=str;
            if ([btArray containsObject:@"A47500_C_DDBTX_0009"]) {
                cell.taglabel.hidden = NO;
            } else {
                cell.taglabel.hidden=YES;
            }
            if (self.C_PAYCHANNELNAME.length > 0) {
                cell.textStr=self.C_PAYCHANNELNAME;
            }else{
                cell.textStr=nil;
            }
            cell.Type=ChooseTableViewTypePaymentMethods;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                MyLog(@"str-- %@      post---%@",str,postValue);
                weakSelf.C_PAYCHANNEL = postValue;
                weakSelf.C_PAYCHANNELNAME = str;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            };
            return cell;
        } else if ([str isEqualToString:@"收据编号"]) {
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            cell.titleBGView.hidden = NO;
            cell.inputTextField.tag = indexPath.row;
            cell.titleLeftLayout.constant = 10;
            cell.inputTextField.delegate=self;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            if ([btArray containsObject:@"A47500_C_DDBTX_0010"]) {
                cell.tagLabel.hidden = NO;
            }
            cell.nameTitleLabel.text=@"收据编号";   //标题
            cell.inputTextField.textColor = [UIColor blackColor];
            if (self.C_MERCHANT_ORDER_NO.length > 0) {
                
                cell.textStr= self.C_MERCHANT_ORDER_NO;
            }
            
            cell.changeTextBlock = ^(NSString *textStr) {
                weakSelf.C_MERCHANT_ORDER_NO = textStr;
            };
            return cell;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52;
}

//selectProjectManager
- (void)selectProjectManager:(UIButton *)sender {
    DBSelf(weakSelf);
    [self endEditing:YES];
    if (self.backViewBlock) {
        self.backViewBlock(@"返回");
    }
    MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
        vc.isAllEmployees = @"是";
    }
//    vc.vcName = @"订单";
    if ([weakSelf.VCName isEqualToString:@"安装"]) {
        vc.alertName = self.stateName;
    } else {
        vc.noticeStr = @"无提示";
    }
    vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
        weakSelf.projectManager = model.user_name;
        weakSelf.projectManagerID = model.user_id;
//        weakSelf.row1Str = nameStr;
//        weakSelf.saleStr = codeStr;
//        if ([weakSelf.VCName isEqualToString:@"安装"]) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        } else
//            if ([weakSelf.VCName isEqualToString:@"下单"]) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            } else {
        NSInteger index = [self.titleArray indexOfObject:@"项目经理"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        if ([[NewUserSession instance].configData.khtsList containsObject:@"A47500_C_DDTSDW_0006"]) {
            [weakSelf HttpAddDesignerWithAndOrder:weakSelf.orderID andDesigner:weakSelf.projectManagerID andType:@"项目经理" andSuccessBlock:^{
                [MJKPushMsgHttp pushInfoWithC_A41500_C_ID:weakSelf.C_A41500_C_ID andC_ID:weakSelf.orderID andC_TYPE_DD_ID:@"A47500_C_DDTSDW_0006" andVC:weakSelf.rootVC andYesBlock:^(NSDictionary * _Nonnull data) {
                    MJKMessagePushNotiViewController *vc = [[MJKMessagePushNotiViewController alloc]init];
                    NSMutableDictionary *contentDic = [data[@"content"] mutableCopy];
                    //                NSMutableArray *arr = [contentDic[@"params"] mutableCopy];
                    vc.titleNameXCX = @"服务管家消息";
                    //                [arr replaceObjectAtIndex:arr.count - 1 withObject:weakSelf.orderModel.C_MANAGER_ROLENAME];
                    //                contentDic[@"params"] = arr;
                    vc.dataDic = contentDic;
                    vc.C_A41500_C_ID = weakSelf.C_A41500_C_ID;
                    vc.C_TYPE_DD_ID = @"A47500_C_DDTSDW_0006";
                    vc.rootVC = weakSelf.rootVC;
                    vc.C_ID = weakSelf.orderID;
                    vc.backActionBlock = ^{
                        
                        [weakSelf.rootVC.navigationController popViewControllerAnimated:YES];
                        
                        
                    };
                    [weakSelf.rootVC.navigationController pushViewController:vc animated:YES];
                } andNoBlock:^{
                    
                }];

            }];
            
        }
//            }
//            [weakSelf HTTPAddHelper:codeStr];
    };
    [self.rootVC.navigationController pushViewController:vc animated:YES];
}

//设计师
- (void)HttpAddDesignerWithAndOrder:(NSString *)orderID andDesigner:(NSString *)designer andType:(NSString *)typeStr andSuccessBlock:(void(^)(void))completeBlock {
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A42000WebService-operationDesigner"];
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    if (orderID.length > 0) {
        contentDict[@"C_ID"] = orderID;
    }
    if ([typeStr isEqualToString:@"设计师"]) {
        if (designer.length > 0) {
            contentDict[@"C_DESIGNER_ROLEID"] = designer;
        }
    } else if ([typeStr isEqualToString:@"项目经理"]) {
        if (designer.length > 0) {
            contentDict[@"C_MANAGER_ROLEID"] = designer;
        }
    }
    
    
    //C_MANAGER_ROLEID//项目经理
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
            //            [JRToast showWithText:data[@"message"]];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
}

- (void)HTTPAddHelper:(NSString *)user_id {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-insert"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = self.orderID;
    dic[@"C_ID"] = [DBObjectTools getA47200C_id];
    dic[@"C_ASSISTANT"] = user_id;
    //    dic[@"C_TYPE_DD_ID"] = @"A47200_C_TYPE_0001";
//    if (self.isDesign == YES) {
//        if (self.C_DESIGNER_ROLEID.length > 0) {
//            dic[@"isDesign"] = @"ture";
//        }
//    }
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
//            if (self.isDesign == YES) {
//                [weakSelf HttpAddDesignerWithAndCustomer:weakSelf.C_ID andDesigner:user_id];
//            } else {
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)selectOrderManager:(UIButton *)sender {
    DBSelf(weakSelf);
    [self endEditing:YES];
    if (self.backViewBlock) {
        self.backViewBlock(@"返回");
    }
    MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
    if ([[NewUserSession instance].appcode containsObject:@"APP005_0036"]) {
        vc.isAllEmployees = @"是";
    }
    if ([weakSelf.VCName isEqualToString:@"安装"] && ![weakSelf.stateName isEqualToString:@"安装"]) {
        vc.alertName = self.stateName;
    } else {
        vc.noticeStr = @"无提示";
    }
    vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
        weakSelf.row1Str = model.user_name;
        weakSelf.saleStr = model.user_id;
        if ([weakSelf.VCName isEqualToString:@"安装"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else
        if ([weakSelf.VCName isEqualToString:@"下单"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if ([weakSelf.VCName isEqualToString:@"收款"]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:5 inSection:0];
        [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    };
    [self.rootVC.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}


#pragma mark - view
- (UIView *)pickerView {
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 150, KScreenWidth, 150)];
    view.tag = 1000;
    UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [view addSubview:pickerView];
    return view;
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.categroyArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.categroyArray[row][@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.categoryName = self.categroyArray[row][@"name"];
    self.categoryID = self.categroyArray[row][@"categoryID"];
    if (![self.VCName isEqualToString:@"下单"]) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
//        [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        CGCOrderDetailNormalCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
        cell.textfield.text = self.categoryName;

    }
}

- (UIView *)buttomView {
    if (!_buttomView) {
        _buttomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 40 - SafeAreaBottomHeight, KScreenWidth, 40)];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 40)];
            [button setTitleNormal:@[@"取消", @"确定"][i]];
            [button addTarget:self action:@selector(buttonClick:)];
            [_buttomView addSubview:button];
            button.backgroundColor = kBackgroundColor;
            if (i == 1) {
                [button setTitleColor:DBColor(255,195,0)];
            } else {
                [button setTitleColor:[UIColor lightGrayColor]];
            }
        }
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake((KScreenWidth / 2), 0, 1, 40)];
        sepView.backgroundColor = [UIColor grayColor];
        [_buttomView addSubview:sepView];
    }
    return _buttomView;
}

- (void)setVCName:(NSString *)VCName {
    _VCName = VCName;
    [self addSubview:self.bottomView];
    if ([self.VCName isEqualToString:@"方案"]) {
        self.timeStr = [DBTools getTimeFomatFromCurrentTimeStamp];
        if ([NewUserSession instance].configData.C_DESIGNER_ROLEID.length > 0) {
            self.row1Str = [NewUserSession instance].configData.C_DESIGNER_ROLENAME;
            self.saleStr = [NewUserSession instance].configData.C_DESIGNER_ROLEID;
        } else {
            self.row1Str = self.C_DESIGNER_ROLENAME;
            self.saleStr = self.C_DESIGNER_ROLEID;
        }
    } else if ([self.VCName isEqualToString:@"下单"]) {
        self.principalID = [NewUserSession instance].configData.C_WLCCRY_ROLEID;
        self.principalStr = [NewUserSession instance].configData.C_WLCCRY_ROLENAME;
    } else if ([self.VCName isEqualToString:@"收款"]) {
        self.principalID = [NewUserSession instance].configData.C_BILLINGID;
        self.principalStr = [NewUserSession instance].configData.C_BILLINGNAME;
        NSArray *btArray = [NewUserSession instance].configData.btListDd;
        if ([btArray containsObject:@"A47500_C_DDBTX_0015"]) {
            self.tableFootPhoto.mustStr = @"*";
        }
    } else if ([self.VCName isEqualToString:@"安装"]) {
        if ([self.stateName isEqualToString:@"安装"]) {
        } else {
            self.principalID = [NewUserSession instance].configData.C_AZRY_ROLEID;
            self.principalStr = [NewUserSession instance].configData.C_AZRY_ROLENAME;
        }
        
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 44, KScreenWidth, 44)];
        _bottomView.backgroundColor = kBackgroundColor;
        if ([self.VCName isEqualToString:@"收款"]) {
            for (int i = 0; i < 2; i++) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 2), 0, KScreenWidth / 2, 44)];
                if (i == 1) {
                    [button setBackgroundColor:KNaviColor];
                }
                [button setTitleColor:[UIColor blackColor]];
                [button setTitleNormal:@[@"收入确认",@"待支付"][i]];
                button.titleLabel.font = [UIFont systemFontOfSize:14.f];
                [button addTarget:self action:@selector(payStatusAction:)];
                [_bottomView addSubview:button];
            }
        } else {
            [_bottomView addSubview:self.commitButton];
        }
        
    }
    return _bottomView;
}
- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
        [_commitButton setTitleNormal:@"确定"];
        [_commitButton addTarget:self action:@selector(buttonClick:)];
        _commitButton.backgroundColor = KNaviColor;
        [_commitButton setTintColor:[UIColor blackColor]];
    }
    return _commitButton;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, self.changeView.frame.size.height - SafeAreaBottomHeight - SafeAreaTopHeight - self.buttomView.frame.size.height)];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        _tableview.tableFooterView = self.tableFootPhoto;
        _tableview.bounces = NO;
        if (@available(iOS 15.0, *)) {
            _tableview.sectionHeaderTopPadding = 0;
        } else {
            // Fallback on earlier versions
        }
    }
    return _tableview;
}

- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 170)];
        _tableFootPhoto.isEdit = YES;
        _tableFootPhoto.rootVC = self.rootVC;
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            weakSelf.imgStr=[arr componentsJoinedByString:@","];
        };
    }
    return _tableFootPhoto;
}

- (CGCOrderDetialFooter *)tableFoot{
    
    if (_tableFoot==nil) {
        
        _tableFoot=[[[NSBundle mainBundle] loadNibNamed:@"CGCOrderDetialFooter" owner:self options:0] lastObject];
        
        DBSelf(weakSelf);
        _tableFoot.clickFirstBlock = ^(UIImage *image) {
            if (image) {
                
                [weakSelf showBigImage:image withBtn:weakSelf.tableFoot.firstPicBtn];
                return ;
            }
            [weakSelf picBtnClick:weakSelf.tableFoot.firstPicBtn];
            
        };
        _tableFoot.clickSecondBlock = ^(UIImage *image) {
            if (image) {
                
                [weakSelf showBigImage:image withBtn:weakSelf.tableFoot.secondPicBtn];
                return ;
            }
            [weakSelf picBtnClick:weakSelf.tableFoot.secondPicBtn];
        };
        _tableFoot.clickThirdBlock = ^(UIImage *image) {
            if (image) {
                
                [weakSelf showBigImage:image withBtn:weakSelf.tableFoot.thirdPicBtn];
                return ;
            }
            [weakSelf picBtnClick:weakSelf.tableFoot.thirdPicBtn];
        };
        
        _tableFoot.deleteFirstBlock = ^{
            
            weakSelf.imgUrl1=@"";
            [weakSelf getAllImagePic];
        };
        _tableFoot.deleteSecondBlock = ^{
            weakSelf.imgUrl2=@"";
            [weakSelf getAllImagePic];
        };
        _tableFoot.deleteThirdBlock = ^{
            weakSelf.imgUrl3=@"";
            [weakSelf getAllImagePic];
        };
        
        
    }
    return _tableFoot;
}

- (void)showBigImage:(UIImage *)image withBtn:(UIButton *)btn{
    
    KSPhotoItem * item=[KSPhotoItem itemWithSourceView:btn.imageView image:image];
    KSPhotoBrowser * browser=[KSPhotoBrowser browserWithPhotoItems:@[item] selectedIndex:0];
    
    
    [browser showFromViewController:self.rootVC];
}

- (void)closeView {
    [self removeFromSuperview];
}

- (void)buttonClick:(UIButton *)sender {
    if (self.backViewBlock) {
        self.backViewBlock(@"");
    }
    if ([sender.titleLabel.text isEqualToString:@"取消"]) {
        [self closeView];
    } else if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if ([self.VCName isEqualToString:@"方案"]) {
            if (self.saleStr.length <= 0) {
                [JRToast showWithText:@"请选择设计师"];
                return;
            }
            if (self.timeStr.length <= 0) {
                [JRToast showWithText:@"请选择首次沟通时间"];
                return;
            }
            
            

        }
        
        if ([self.VCName isEqualToString:@"收款"]) {
            if (self.row0Str.length <= 0) {
                [JRToast showWithText:@"请输入收款金额"];
                return;
            }
            
            
            if ([self.qianyueDic[@"B_MONEY"] floatValue] == 0) {
                [JRToast showWithText:@"请输入产品总价"];
                return;
            }
            NSArray *btArray = [NewUserSession instance].configData.btListDd;
            if ([btArray containsObject:@"A47500_C_DDBTX_0009"]) {
                if (self.C_PAYCHANNEL.length <= 0) {
                    [JRToast showWithText:@"请选择收款方式"];
                    return;
                }
            }
            if ([btArray containsObject:@"A47500_C_DDBTX_0010"]) {
                if (self.C_MERCHANT_ORDER_NO.length <= 0) {
                    [JRToast showWithText:@"请输入收据编号"];
                    return;
                }
            }
            
            if ([btArray containsObject:@"A47500_C_DDBTX_0016"]) {
                if (self.finshStr.length <= 0) {
                    [JRToast showWithText:@"请选择预计交付时间"];
                    return;
                }
            }
            
            if ([btArray containsObject:@"A47500_C_DDBTX_0017"]) {
                if (self.projectManagerID.length <= 0) {
                    [JRToast showWithText:@"请选择项目经理"];
                    return;
                }
            }
            
            
//            if (self.imgStr.length <= 0) {c
//                [JRToast showWithText:@"请上传凭证"];
//                return;
//            }
            
            
        }
        
        if ([self.VCName isEqualToString:@"交付"]) {
            if (self.timeStr.length <= 0) {
                [JRToast showWithText:@"请选择出库时间"];
                return;
            }
            
            
            
            if (self.yjAddress.length <= 0) {
                [JRToast showWithText:@"请输入邮寄地址"];
                return;
            }
            
            if (self.C_MERCHANT_ORDER_NO.length <= 0) {
                [JRToast showWithText:@"请输入开票名称"];
                return;
            }
            
            
        }
        
        
        
        if ([self.VCName isEqualToString:@"全款"]) {
            if (self.C_MERCHANT_ORDER_NO.length <= 0) {
                [JRToast showWithText:@"请输入车架号全号"];
                return;
            }
            if (self.C_MERCHANT_ORDER_NO.length != 17) {
                [JRToast showWithText:@"请确认车架号全号"];
                return;
            }
            if (self.row0Str.length <= 0) {
                [JRToast showWithText:@"请输入上牌地"];
                return;
            }
            
            if ([self.typeStr isEqualToString:@"出库"]) {
                if (self.cksj.length <= 0) {
                    [JRToast showWithText:@"请选择出库时间"];
                    return;
                }
                
                
                
                if (self.yjAddress.length <= 0) {
                    [JRToast showWithText:@"请输入邮寄地址"];
                    return;
                }
                
                if (self.C_MERCHANT_ORDER_NO.length <= 0) {
                    [JRToast showWithText:@"请输入开票名称"];
                    return;
                }
            }
//
            if (self.fdjqh.length <= 0) {
                [JRToast showWithText:@"请输入发动机全号"];
                return;
            }
            
            if (self.fdjqh.length < 7 || self.fdjqh.length > 14) {
                [JRToast showWithText:@"请确认发动机全号"];
                return;
            }
            
            
//
//            if (self.orderMoney.length <= 0) {
//                [JRToast showWithText:@"请输入上牌费"];
//                return;
//            }
//
//            if (self.startStr.length <= 0) {
//                [JRToast showWithText:@"请输入保险费"];
//                return;
//            }
//
//            if (self.categoryID.length <= 0) {
//                [JRToast showWithText:@"请输入按揭费"];
//                return;
//            }
//
//            if (self.projectManagerID.length <= 0) {
//                [JRToast showWithText:@"请输入质保费"];
//                return;
//            }
//
//            if (self.finshStr.length <= 0) {
//                [JRToast showWithText:@"请输入精品费"];
//                return;
//            }
            
        }
//        if ([self.VCName isEqualToString:@"下单"]) {
//            if (self.row0Str.length <= 0) {
//                [JRToast showWithText:@"请输入单号"];
//                return;
//            }
//            if (self.row1Str.length <= 0) {
//                [JRToast showWithText:@"请选择下单员"];
//                return;
//            }
//        }
        
        if ([self.VCName isEqualToString:@"安装"]) {
            if ([self.stateName isEqualToString:@"安装"]) {
                if (self.row1Str.length <= 0) {
                    [JRToast showWithText:@"请选择安装技师"];
                    return;
                }

            }
        }
        
        if ([self.VCName isEqualToString:@"方案"]) {
            if (self.saleStr.length > 0) {
                [self HttpAddDesignerWithAndOrder:self.orderID andDesigner:self.saleStr andType:@"设计师" andSuccessBlock:^{
                    if (self.doneButtonBlock) {
                        self.doneButtonBlock(self.row0Str, self.saleStr, self.timeStr, self.imgStr, self.categoryID,self.finshStr,self.orderMoney,self.projectManagerID,self.qianyueDic[@"B_MONEY"],self.qianyueDic[@"B_CASHDISCOUNT"],self.qianyueDic[@"B_GUIDEPRICE"],@"",self.principalID, self.C_PAYCHANNEL, self.C_MERCHANT_ORDER_NO, self.row1Str.length > 0 ? self.row1Str : self.principalStr,self.startStr,@"",@"",@"");
                    }
                }];
            } else {
                if (self.doneButtonBlock) {
                    self.doneButtonBlock(self.row0Str, self.saleStr, self.timeStr, self.imgStr, self.categoryID,self.finshStr,self.orderMoney,self.projectManagerID,self.qianyueDic[@"B_MONEY"],self.qianyueDic[@"B_CASHDISCOUNT"],self.qianyueDic[@"B_GUIDEPRICE"],@"",self.principalID, self.C_PAYCHANNEL, self.C_MERCHANT_ORDER_NO, self.row1Str.length > 0 ? self.row1Str : self.principalStr,self.startStr,@"",@"",@"");
                }
            }
        } else if ([self.VCName isEqualToString:@"方案"]) {
            if (self.doneButtonBlock) {
                self.doneButtonBlock(self.row0Str, self.saleStr, self.timeStr, self.imgStr, self.categoryID,self.finshStr,self.orderMoney,self.projectManagerID,self.qianyueDic[@"B_MONEY"],self.qianyueDic[@"B_CASHDISCOUNT"],self.qianyueDic[@"B_GUIDEPRICE"],@"",self.principalID, self.C_PAYCHANNEL, self.C_MERCHANT_ORDER_NO, self.row1Str,self.startStr,@"",@"",@"");
            }
        } else {
            if (self.doneButtonBlock) {
                self.doneButtonBlock(self.row0Str, self.saleStr, self.timeStr, self.imgStr, self.categoryID,self.finshStr,self.orderMoney,self.projectManagerID,self.qianyueDic[@"B_MONEY"],self.qianyueDic[@"B_CASHDISCOUNT"],self.qianyueDic[@"B_GUIDEPRICE"],@"",self.principalID, self.C_PAYCHANNEL, self.C_MERCHANT_ORDER_NO, self.row1Str.length > 0 ? self.row1Str : self.principalStr,self.startStr,self.yjAddress,  self.fdjqh,self.cksj);
            }
        }
    }
}

- (void)payStatusAction:(UIButton *)button {
    if ([self.VCName isEqualToString:@"收款"]) {
        if (self.row0Str.length <= 0) {
            [JRToast showWithText:@"请输入收款金额"];
            return;
        }
        
        
        if ([self.qianyueDic[@"B_MONEY"] floatValue] == 0) {
            [JRToast showWithText:@"请输入产品总价"];
            return;
        }
        NSArray *btArray = [NewUserSession instance].configData.btListDd;
        if ([btArray containsObject:@"A47500_C_DDBTX_0009"]) {
            if (self.C_PAYCHANNEL.length <= 0) {
                [JRToast showWithText:@"请选择收款方式"];
                return;
            }
        }
        if ([btArray containsObject:@"A47500_C_DDBTX_0010"]) {
            if (self.C_MERCHANT_ORDER_NO.length <= 0) {
                [JRToast showWithText:@"请输入收据编号"];
                return;
            }
        }
        
        if ([btArray containsObject:@"A47500_C_DDBTX_0016"]) {
            if (self.finshStr.length <= 0) {
                [JRToast showWithText:@"请选择预计交付时间"];
                return;
            }
        }
        
        if ([btArray containsObject:@"A47500_C_DDBTX_0017"]) {
            if (self.projectManagerID.length <= 0) {
                [JRToast showWithText:@"请选择项目经理"];
                return;
            }
        }
        
        if ([btArray containsObject:@"A47500_C_DDBTX_0015"]) {
            if (self.imgStr.length <= 0) {
                [JRToast showWithText:@"请上传凭证"];
                return;
            }
        }
    }
    if (self.doneButtonBlock) {
        self.doneButtonBlock(self.row0Str, self.saleStr, self.timeStr, self.imgStr, self.categoryID,self.finshStr,self.orderMoney,self.projectManagerID,self.qianyueDic[@"B_MONEY"],self.qianyueDic[@"B_CASHDISCOUNT"],self.qianyueDic[@"B_GUIDEPRICE"],[button.titleLabel.text isEqualToString:@"收入确认"] ? @"A04200_C_STATUS_0001": @"A04200_C_STATUS_0000",self.principalID, self.C_PAYCHANNEL, self.C_MERCHANT_ORDER_NO,self.row1Str.length > 0 ? self.row1Str : self.principalStr,self.startStr,@"",@"",@"");
    }
}
#pragma mark - 图片选择
- (void)picBtnClick:(UIButton *)btn{//图片上传选择
    if (self.backViewBlock) {
        self.backViewBlock(@"返回");
    }
    self.indexBtn=btn.tag;
    UIAlertController * alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    
    
    UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.rootVC presentViewController:imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction*manual=[UIAlertAction actionWithTitle:@"拍照上传" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = NO;
            picker.sourceType = sourceType;
            [self.rootVC presentViewController:picker animated:YES completion:nil];
            
        }else
        {
            NSLog(@"模拟其中无法打开照相机,请在真机中使用");
        }
        
        
    }];
    
    [alertVC addAction:sanfdal];
    [alertVC addAction:manual];
    [alertVC addAction:cancel];
    [self.rootVC presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
}
#pragma mark - 图片代理
//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (!image) {
            image=[info objectForKey:UIImagePickerControllerEditedImage];
        }
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        image= [UIImage imageWithData:imageData];
        
        
        [self saveimg:image];
        [self uppicAction:imageData];
        
    }else{
        UIImage * image=[info objectForKey:UIImagePickerControllerEditedImage];
        if (!image) {
            image=[info objectForKey:UIImagePickerControllerOriginalImage];
        }
        NSData *imageData = UIImageJPEGRepresentation(image,0.5);
        image= [UIImage imageWithData:imageData];
        
        
        
        [self saveimg:image];
        [self uppicAction:imageData];
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//储存图像到本地
- (void)saveimg:(UIImage *) img
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    
    NSString *imgname =  [NSString stringWithFormat:@"/image%@.png",date];
    imgname = [imgname stringByReplacingOccurrencesOfString:@" " withString:@""];
    imgname = [imgname stringByReplacingOccurrencesOfString:@":" withString:@""];
    
    //这里将图片放在沙盒的documents文件夹中
    NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSData *dataObj = UIImageJPEGRepresentation(img, 1.0);
    [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:imgname] contents:dataObj attributes:nil];
    //得到选择后沙盒中图片的完整路径
    self.patchUrl = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,imgname];
    
    
    
}

-(void)uppicAction:(NSData *)data{
    
    
    
    //    NSData *data=[NSData dataWithContentsOfFile:self.patchUrl];
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            NSString * imgUrl = [data objectForKey:@"url"];//回传
            [self setPicBtn:imgUrl];
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (void)setPicBtn:(NSString *)imgUrl{
    
    
    if (self.indexBtn==111) {
        [self.tableFoot.firstPicBtn setImage:[[UIImage imageWithContentsOfFile:self.patchUrl]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.imgUrl1=imgUrl;
        self.tableFoot.firstImg=self.tableFoot.firstPicBtn.imageView.image;
        
    }
    
    if (self.indexBtn==222) {
        [self.tableFoot.secondPicBtn setImage:[[UIImage imageWithContentsOfFile:self.patchUrl]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.imgUrl2=imgUrl;
        self.tableFoot.secondImg=self.tableFoot.secondPicBtn.imageView.image;
    }
    
    if (self.indexBtn==333) {
        
        [self.tableFoot.thirdPicBtn setImage:[[UIImage imageWithContentsOfFile:self.patchUrl] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.imgUrl3=imgUrl;
        self.tableFoot.thirdImg=self.tableFoot.thirdPicBtn.imageView.image;
        
    }
    
    
    [self getAllImagePic];
    
    
}

-(void)getAllImagePic{
    
    NSMutableArray * imgURLArr=[NSMutableArray array];
    if (self.imgUrl1.length>0) {
        [imgURLArr addObject:self.imgUrl1];
    }
    if (self.imgUrl2.length>0) {
        [imgURLArr addObject:self.imgUrl2];
    }
    if (self.imgUrl3.length>0) {
        [imgURLArr addObject:self.imgUrl3];
    }
    
    self.imgStr=[imgURLArr componentsJoinedByString:@","];
}


#pragma mark - 时间选择
- (void)dateSelect:(UIButton *)btn{//预计交付时间选择
    [self.rootVC.view endEditing:YES];
    [self datePickerAndMethodButtonTag:btn.tag];
}

//时间控件
- (void)datePickerAndMethodButtonTag:(NSInteger)buttonTag;
{
    UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame=self.bounds;
    [btn addTarget:self action:@selector(dissmissPicker:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor=CGCBGCOLOR;
    self.pickerBtn=btn;
    UIView * view=[[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-200, KScreenWidth, 200)];
    view.backgroundColor=[UIColor whiteColor];
    
    UIButton * doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame=CGRectMake(KScreenWidth-60, 0, 60, 40);
    [doneBtn addTarget:self action:@selector(dissmissPicker:) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setTitleNormal:@"完成"];
    [doneBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:doneBtn];
    
    UIButton * canelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    canelBtn.frame=CGRectMake(0, 0, 60, 40);
    [canelBtn addTarget:self action:@selector(dissmissPicker:) forControlEvents:UIControlEventTouchUpInside];
    [canelBtn setTitleNormal:@"取消"];
    [canelBtn setTitleColor:[UIColor blackColor]];
    [view addSubview:canelBtn];
    
    UIDatePicker *Picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, KScreenWidth, 160)];
    self.datePicker = Picker;
    Picker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_Hans_cn"];
    if (@available(iOS 13.4, *)) {
        Picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    Picker.datePickerMode = UIDatePickerModeDateAndTime;
    Picker.tag=100 + buttonTag;
    
    NSDate *Date = [NSDate date];
//    NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
//    birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//    self.timeStr = [birthformatter stringFromDate:Date];
    
//    self.orderModel.D_START_TIME=[birthformatter stringFromDate:Date];
    [Picker setDate:Date animated:YES];
    [Picker addTarget:self action:@selector(showDate:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:Picker];
    [btn addSubview:view];
    [self addSubview:btn];
}
- (void)showDate:(UIDatePicker *)datePicker
{
//    if (datePicker.tag==100) {
    
        NSDate *date = datePicker.date;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *outputString = [formatter stringFromDate:date];
    
//        self.orderModel.D_START_TIME=outputString;
        NSIndexPath * index;
    if ([self.VCName isEqualToString:@"安装"]) {
        index=[NSIndexPath indexPathForRow:1 inSection:0];
        self.timeStr = outputString;
    } else if ([self.VCName isEqualToString:@"下单"]) {
            index=[NSIndexPath indexPathForRow:2 inSection:0];
        self.timeStr = outputString;
    } else {
            if (datePicker.tag == 100 + 200) {
                NSInteger indexP = [self.titleArray indexOfObject:@"预计完成时间"];
                index=[NSIndexPath indexPathForRow:indexP inSection:0];
                self.finshStr = outputString;
            } else if (datePicker.tag == 100 + 300)  {
                NSInteger indexP = [self.titleArray indexOfObject:@"收款日期"];
                index=[NSIndexPath indexPathForRow:indexP inSection:0];
                self.timeStr = outputString;
            }
            
        
    }
        [self.tableview reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    

    
}

- (void)dissmissPicker:(UIButton *)sender{
    if ([sender.titleLabel.text isEqualToString:@"完成"]) {
        if ([self.VCName isEqualToString:@"收款"] && self.finshStr.length <= 0) {
            if (self.datePicker.tag == 100 + 200) {
            NSDate *Date = [NSDate date];
            NSDateFormatter *birthformatter = [[NSDateFormatter alloc] init];
                birthformatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            birthformatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
            self.finshStr = [birthformatter stringFromDate:Date];
            [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
    [self.pickerBtn removeFromSuperview];
}

#pragma mark --- textFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
//    if (textField.tag==0) {
//        [UIView animateWithDuration:0.5 animations:^{
//            //        self.tableview.y=0;
//
//            UIView *changeView  = [self viewWithTag:100];
//            changeView.y = changeView.y+120;
//        }];
//    }
    
    if ([self.VCName isEqualToString:@"收款"]) {
        NSString *str = self.titleArray[textField.tag];
        if ([str isEqualToString:@"收款金额"]) {
            self.row0Str = textField.text;
        } else if ([str isEqualToString:@"类型"]) {
            if (self.categoryID.length <=0 ) {
                self.categoryID = self.categroyArray[0][@"categoryID"];
                self.categoryName = self.categroyArray[0][@"name"];
                
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];
            [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else if ([str isEqualToString:@"产品总价"]) {
            self.qianyueDic[@"B_MONEY"] = textField.text;
            NSString *str = [NSString stringWithFormat:@"%.1f",[self.qianyueDic[@"B_MONEY"] floatValue] - [self.qianyueDic[@"B_CASHDISCOUNT"] floatValue]];
            self.qianyueDic[@"B_GUIDEPRICE"] = [NSString stringWithFormat:@"%ld",(long)[str integerValue]] ;
            if ([self.titleArray containsObject:@"总金额"]) {
                
                NSInteger index = [self.titleArray indexOfObject:@"总金额"];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } else if ([str isEqualToString:@"优惠金额"]) {
            self.qianyueDic[@"B_CASHDISCOUNT"] = textField.text;
            if ([self.titleArray containsObject:@"总金额"]) {
                if ([self.qianyueDic[@"B_MONEY"] length] > 0) {
                    NSString *str = [NSString stringWithFormat:@"%.1f",[self.qianyueDic[@"B_MONEY"] floatValue] - [self.qianyueDic[@"B_CASHDISCOUNT"] floatValue]];
                    self.qianyueDic[@"B_GUIDEPRICE"] = [NSString stringWithFormat:@"%ld",(long)[str integerValue]] ;
                    NSInteger index = [self.titleArray indexOfObject:@"总金额"];
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                }
                
            }
        } else if ([str isEqualToString:@"收据编号"]) {
            self.C_MERCHANT_ORDER_NO = textField.text;
        }
    }
    if ([self.VCName isEqualToString:@"下单"]) {
        NSString *str = self.titleArray[textField.tag];
        if ([str isEqualToString:@"工厂单号"]) {
            self.row0Str = textField.text;
        } else if ([str isEqualToString:@"下单员"]) {
            self.row1Str = textField.text;
        } else if ([str isEqualToString:@"下单金额"]) {
            self.orderMoney = textField.text;
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.tableview.y=0;
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    int b = 0;
    CGPoint a =  [textField convertPoint:textField.frame.origin fromView:self];
    int y = abs((int)a.y);
    
    if (y > (KScreenHeight - 360)) {
        b = y - (KScreenHeight - 360);
    }
    NSLog(@"");
    //    if (textField.tag>=10) {
    [UIView animateWithDuration:0.5 animations:^{
        self.tableview.y=-b;
    }];
    //    }
//    if (textField.tag==0) {
//        [UIView animateWithDuration:0.5 animations:^{
////            self.tableview.y=-120;
//            UIView *changeView  = [self viewWithTag:100];
//            changeView.y = changeView.y-120;
//        }];
//    }
//
//    NSIndexPath * index=[NSIndexPath indexPathForRow:textField.tag inSection:0];
//    [self.tableview scrollToRowAtIndexPath:index atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    
    return YES;
}


- (NSMutableArray *)categroyArray {
    if (!_categroyArray) {
        _categroyArray = [NSMutableArray array];
        NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"A04200_C_TYPE_0001", @"categoryID", @"合同款", @"name", nil];
        NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys: @"A04200_C_TYPE_0000", @"categoryID", @"订金", @"name", nil];
        NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"A04200_C_TYPE_0002", @"categoryID", @"退款", @"name", nil];
        [_categroyArray addObject:dic1];
        [_categroyArray addObject:dic2];
        [_categroyArray addObject:dic3];
    }
    return _categroyArray;
}

@end
