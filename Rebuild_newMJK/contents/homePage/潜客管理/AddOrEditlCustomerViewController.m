//
//  AddOrEditlCustomerViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/9/15.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "AddOrEditlCustomerViewController.h"
#import "MJKProductViewController.h"
#import "MJKShowAreaModel.h"

#import "AddCustomerPhotoTableViewCell.h"
#import "AddCustomerProductTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"
#import "CGCOrderDetialFooter.h"   //view
#import "MJKPhotoView.h"
#import "PickerChoiceView.h"
#import "showLikeProductView.h"     //@"匹配车型"的view
#import "KSPhotoBrowser.h"
#import "MJKFlowMeterViewController.h"

#import "PotentailCustomerEditModel.h"
#import "CodeShoppingModel.h"      //@"匹配车型"
#import "VideoAndImageModel.h"

#import "AddHelperViewController.h"

#import "MJKShowAreaViewController.h"

//#import "WLBarcodeViewController.h"
#import "MJKAddressTableViewCell.h"
#import "MJKClueListViewController.h"
#import "MJKMarketViewController.h"
#import "CGCBrokerCenterVC.h"
#import "MJKProductChooseViewController.h"
#import "MJKProductShowModel.h"

#import "MJKCustomerAddressTableViewCell.h"
#import "MJKChooseEmployeesViewController.h"
#import "MJKRecheckTableViewCell.h"

#import "MJKCarSourceViewController.h"//选择车源
#import "MJKChooseBrandViewController.h"

#define photoCell     @"AddCustomerPhotoTableViewCell"
#define productCell   @"AddCustomerProductTableViewCell"
#define inputCell     @"AddCustomerInputTableViewCell"
#define chooseCell    @"AddCustomerChooseTableViewCell"
#define RemarkCell    @"CGCNewAppointTextCell"

@interface AddOrEditlCustomerViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate> {
    NSString *_customerID;
}
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCOrderDetialFooter*footerImageView;
@property(nonatomic,strong)showLikeProductView*showProductView;  //展示喜欢的产品的view

@property(nonatomic,assign)BOOL canSave;  //能否被提交
@property(nonatomic,strong)NSString*beforePhone;  //编辑时候 一开始的电话号码
@property(nonatomic,strong)NSMutableArray*localDatas;   //2个section Array  里面是model

@property(nonatomic,strong)NSMutableArray*saveAllShoppingInfo;  //@"匹配车型"的 所有model


@property(nonatomic,strong)NSMutableArray*saveFooterUrlArray;//编辑界面  保存的底部的图片
@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
@property(nonatomic,strong)NSMutableDictionary*saveFooterImageDataDic; //保存 3张图片的data   11  22  33  key

@property (nonatomic, strong) UIButton *findCopyButton;



/** C_CLUEPROVIDER_ROLEID*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEStr;
/** C_CLUEPROVIDER_ROLEID*/
@property (nonatomic, strong) NSString *C_CLUEPROVIDER_ROLEID;
/** (MJKPhotoView *)tableFootPhoto*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** image url array*/
@property (nonatomic, strong) NSArray *imageUrlArray;
@property (nonatomic, strong) NSArray *saveImageUrlArray;
/** 产品*/
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) NSMutableArray *yx_productArray;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *btArray;



/** <#注释#>*/
@property (nonatomic, strong) NSString *productType;


@end

@implementation AddOrEditlCustomerViewController

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"productArray" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
    _customerID=[DBObjectTools getPotentailcustomerC_id];
    
    self.beforePhone=self.mainModel.C_PHONE;
    
    self.view.backgroundColor=[UIColor whiteColor];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:photoCell bundle:nil] forCellReuseIdentifier:photoCell];
    [self.tableView registerNib:[UINib nibWithNibName:productCell bundle:nil] forCellReuseIdentifier:productCell];
    //    [self.tableView registerNib:[UINib nibWithNibName:inputCell bundle:nil] forCellReuseIdentifier:inputCell];
    [self.tableView registerNib:[UINib nibWithNibName:chooseCell bundle:nil] forCellReuseIdentifier:chooseCell];
    [self.tableView registerNib:[UINib nibWithNibName:RemarkCell bundle:nil] forCellReuseIdentifier:RemarkCell];
    
    if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
        [self addCommitButton];
    }else {
        if ([self.assistStr isEqualToString:@"协助"]) {
            if ([[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                [self addCommitButton];
            } else {
                CGRect frame = self.tableView.frame;
                frame.size.height = frame.size.height + 50;
                self.tableView.frame = frame;
            }
        } else {
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {//编辑
                [self addCommitButton];
            } else {
                CGRect frame = self.tableView.frame;
                frame.size.height = frame.size.height + 50;
                self.tableView.frame = frame;
            }
        }
    }
    //
    [self getLocalDatas];
    
    if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
        self.title=@"新增潜客";
        if (self.C_A41300_C_ID.length > 0) {
        }
    }else{
        if ([self.assistStr isEqualToString:@"协助"]) {
            
            if ([[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {//编辑
                self.title=@"潜客编辑";
            } else {
                self.title = @"潜客查看";
            }
        } else {
            if ([[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {//编辑
                self.title=@"潜客编辑";
            } else {
                self.title = @"潜客查看";
            }
        }
        
        [self getPostValueAndBeforeValue];
        
    }
    
    self.btArray = [NewUserSession instance].configData.requiredCode;
    
}


#pragma mark  --UI
-(void)addCommitButton{
    UIButton*commitButton=[[UIButton alloc]initWithFrame:CGRectMake(20, KScreenHeight-50, KScreenWidth-40, 40)];
    commitButton.backgroundColor=KNaviColor;
    [commitButton setTitleNormal:@"提交"];
    [commitButton setTitleColor:[UIColor blackColor]];
    [commitButton addTarget:self action:@selector(clickCommitButton:)];
    [self.view addSubview:commitButton];
    
    
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.localDatas.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSMutableArray*array=self.localDatas[section];
    
    //    if (section == 0) {
    //        if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
    //            return array.count;
    //        } else {
    //           return array.count;
    //        }
    //
    //    } else {
    return array.count;
    //    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //        [NSMutableArray arrayWithObjects:@"基本信息",@"联系电话",@"购车类型",@"意向车型",@"客户等级",@"来源渠道",@"渠道细分", nil]
    //        @[@"性别",@"省市",@"客户微信",@"车牌",@"保有车辆",@"客户地址",@"行业",@"公司",@"职务",@"年收入",@"文化程度",@"婚姻状况",@"生日",@"爱好",@"客户备注",@"介绍人"]
    NSMutableArray*localArr=self.localDatas[indexPath.section];
    PotentailCustomerEditModel*model=localArr[indexPath.row];
    DBSelf(weakSelf);
    
    if ([model.locatedTitle isEqualToString:@"基本信息"]) {
        //头像名字
        AddCustomerPhotoTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:photoCell];
        cell.clickPortraitBlock = ^{
            weakSelf.selectedImage=0;
            [weakSelf TouchAddImage];
            
        };
        
        cell.changeTextFieldBlock = ^(NSString *currentStr) {
            MyLog(@"%@",currentStr);
            model.nameValue=currentStr;
            model.postValue=currentStr;
        };
        
        
        
        if (self.portraitAddress&&![self.portraitAddress isEqualToString:@""]) {
            cell.portraitStr=self.portraitAddress;
        }
        
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.nameStr=model.nameValue;
            
        }
        cell.mustbeLabel.hidden = NO;
        if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
        }else {
            if ([self.assistStr isEqualToString:@"协助"]) {
                if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                    cell.nameTextField.enabled = NO;
                    cell.imageButton.enabled = NO;
                }
            } else {
                if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                    cell.nameTextField.enabled = NO;
                    cell.imageButton.enabled = NO;
                }
            }
        }
        
        
        
        
        return cell;
    } else if ([model.locatedTitle isEqualToString:@"匹配车型"]){
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = model.locatedTitle;
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.textStr=model.nameValue;
        }
        if ([self.btArray containsObject:@"a415_C_A70600_C_ID"]) {
            cell.taglabel.hidden = NO;
        } else {
            cell.taglabel.hidden = YES;
        }
        cell.Type = chooseTypeNil;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
             MJKCarSourceViewController *vc = [[MJKCarSourceViewController alloc]init];
            //            if (self.yx_productArray.count > 0) {
            //                vc.productArray = [self.yx_productArray mutableCopy];
            //            }
                        
                        vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                            weakSelf.productArray = [productArray mutableCopy];
                            
                            MJKProductShowModel *model1 = productArray[0];
                            model.nameValue = model1.X_REMARK;
                            
                            model.postValue = model1.C_ID;
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            
                        };
                    
//                        [self.navigationController pushViewController:vc animated:YES];
//            weakSelf.productType = @"匹配车型";
//            MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
//            vc.rootVC = weakSelf;
//            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
//                NSInteger index = 0;
//                self.yx_productArray = [productArray mutableCopy];
//                PotentailCustomerEditModel *editModel1;
//                for (PotentailCustomerEditModel *editModel in localArr) {
//                    if ([editModel.locatedTitle isEqualToString:@"匹配车型"]) {
//                        index = [localArr indexOfObject:editModel];
//                        editModel1 = editModel;
//                    }
//                }
//                MJKProductShowModel *model = productArray[0];
//                self.C_A49600_C_ID = model.C_ID;
//                self.C_A70600_C_ID = model.C_TYPE_DD_ID;
//                editModel1.nameValue = model.C_NAME;
//                editModel1.postValue = model.C_ID;
                
//                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
        
    } else if ([model.locatedTitle isEqualToString:@"意向车型"]){
        //产品 扫码
        //初始值
        //         AddCustomerProductTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:productCell];
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = model.locatedTitle;
        if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
            cell.textStr=model.nameValue;
        }
        if ([self.btArray containsObject:@"a415_C_A70600_C_ID"]) {
            cell.taglabel.hidden = NO;
        } else {
            cell.taglabel.hidden = YES;
        }
        cell.Type = chooseTypeNil;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.productType = @"意向车型";
            MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
            vc.rootVC = weakSelf;
            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                NSInteger index = 0;
                self.yx_productArray = [productArray mutableCopy];
                PotentailCustomerEditModel *editModel1;
                for (PotentailCustomerEditModel *editModel in localArr) {
                    if ([editModel.locatedTitle isEqualToString:@"意向车型"]) {
                        index = [localArr indexOfObject:editModel];
                        editModel1 = editModel;
                    }
                }
                MJKProductShowModel *model = productArray[0];
//                self.C_YX_A49600_C_ID = model.C_ID;
//                self.C_YX_A70600_C_ID = model.C_TYPE_DD_ID;
                self.C_A49600_C_ID = model.C_ID;
                self.C_A70600_C_ID = model.C_TYPE_DD_ID;
                editModel1.nameValue = model.C_NAME;
                editModel1.postValue = model.C_ID;
                
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        };
        
        return cell;
        
    } else if ([model.locatedTitle isEqualToString:@"客户地址"]) {
        //客户地址
        if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
            MJKAddressTableViewCell *cell = [MJKAddressTableViewCell cellWithTableView:tableView];
            cell.chooseAreaLayout.constant = 25;
            cell.titleLabel.text=model.locatedTitle;
           
                cell.mustLabel.hidden = YES;
            
            
            if (model.postValue.length > 0) {
                cell.textView.alpha = 1.f;
            }
            cell.textView.text = model.postValue;
            
            
            cell.changeTextBlock = ^(NSString *textStr) {
                //                weakSelf.addressStr = textStr;
                model.nameValue=textStr;
                model.postValue=textStr;
                
                [tableView beginUpdates];
                [tableView endUpdates];
            };
            cell.selectAreaBlock = ^{
                [weakSelf addArea];
            };
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                
                if (self.mainModel.C_ADDRESS.length > 0 || self.mainModel.C_A48200_C_ID.length > 0) {
                    cell.chooseAreaButton.hidden = NO;
                    cell.chooseAreaLayout.constant = 40;
                    [cell.chooseAreaButton addTarget:self action:@selector(navAction:)];
                    
                }
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.chooseAreaButton.enabled = NO;
                        cell.textView.editable = NO;
                    }
                } else {
                    
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.chooseAreaButton.enabled = NO;
                        cell.textView.editable = NO;
                    }
                }
            }
            return cell;
        } else {
            
            MJKCustomerAddressTableViewCell *cell = [MJKCustomerAddressTableViewCell cellWithTableView:tableView];
            if (model.nameValue.length > 0) {
                cell.inputAddressTextView.text = model.nameValue;
            }
            if (self.addressStr.length > 0) {
                cell.chooseAddressLabel.text = self.addressStr;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                model.nameValue = textStr;
                model.postValue = textStr;
                //                weakSelf.addressStr = textStr;
                
                [tableView beginUpdates];
                [tableView endUpdates];
            };
            cell.selectAreaBlock = ^{
                [weakSelf addArea];
            };
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                if (self.mainModel.C_ADDRESS.length > 0 || self.mainModel.C_A48200_C_ID.length > 0) {
                    cell.navImage.hidden = NO;
                    cell.tfRightLayout.constant = 30;
                    [cell.navImage addTarget:self action:@selector(navAction:)];
                    
                }
                
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.inputAddressTextView.editable = NO;
                        cell.chooseAreaButton.enabled = NO;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.inputAddressTextView.editable = NO;
                        cell.chooseAreaButton.enabled = NO;
                    }
                }
            }
            return cell;
        }
        
        
    } else
        if ([model.locatedTitle isEqualToString:@"联系电话"]) {
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            //        UIButton*findCopyButton=[cell viewWithTag:110];
            cell.inputTextField.delegate=self;
            cell.tagLabel.hidden = NO;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.inputTextField.placeholder = @"手机和微信号必填一项";
            cell.nameTitleLabel.text=model.locatedTitle;   //标题
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                NSString *str;
                if (model.nameValue.length > 0) {
                    if ([[NewUserSession  instance].configData.IS_TELEPHONEPRIVACY isEqualToString:@"0"]) {
                        str = model.nameValue;
                    } else {
                        str = [model.nameValue stringByReplacingCharactersInRange:NSMakeRange(5, 3) withString:@"***"];
                    }
                }
                cell.textStr=str;
            }else{
                cell.textStr=nil;
            }
            cell.inputTextField.keyboardType=UIKeyboardTypePhonePad;
            cell.textFieldLength=11;
            //        cell.tagLabel.hidden=YES;
            cell.inputRightValue.constant=75;
            //        [cell addSubview:self.findCopyButton];
            cell.findCopyButton.hidden = NO;
            cell.clickButtonBlock = ^{
                [weakSelf clickFindCopy];
            };
            
            
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                
                model.nameValue=textStr;
                model.postValue=textStr;
                
            };
            cell.textEndEditBlock = ^{
                if ([model.postValue rangeOfString:@"*"].location !=NSNotFound) {
                    [JRToast showWithText:@"请输入正确的电话号码"];
                    model.postValue = model.nameValue = @"";
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            };
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.inputTextField.enabled = NO;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.inputTextField.enabled = NO;
                    }
                }
            }
            return cell;
        }
    
    
    /*
     装修进度，装修风格，面积
     
     预算，户型，物业类型，居住人口
     */
        else if ([model.locatedTitle isEqualToString:@"客户微信"]){
            
            //         AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            //        UIButton*findCopyButton=[cell viewWithTag:110];
            cell.inputTextField.delegate=self;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.nameTitleLabel.text=model.locatedTitle;   //标题
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                cell.textStr=model.nameValue;
            }else{
                cell.textStr=nil;
            }
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.inputTextField.enabled = NO;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.inputTextField.enabled = NO;
                    }
                }
            }
            
            /*
             @"匹配车型"    A47500_C_BTX_0001
             客户地址    A47500_C_BTX_0002
             客户微信    A47500_C_BTX_0004
             客户阶段    A47500_C_BTX_0006
             客户性别    A47500_C_BTX_0007
             来源渠道    A47500_C_BTX_0008
             渠道细分    A47500_C_BTX_0009
             */
            
            
                cell.tagLabel.hidden = YES;
            
            //微信号
            cell.changeTextBlock = ^(NSString *textStr) {
                model.nameValue=textStr;
                model.postValue=textStr;
            };
            
            
            
            return cell;
        } else if ([model.locatedTitle isEqualToString:@"是否添加微信"]) {
            //是否关注公众号
            MJKRecheckTableViewCell *cell = [MJKRecheckTableViewCell cellWithTableView:tableView];
            cell.titleLabel.text = model.locatedTitle;
            cell.switchButton.on = [model.postValue isEqualToString:@"1"] ? YES : NO;
            cell.titleBGView.hidden = YES;
            cell.titleLeftLayout.constant = 20;
            cell.switchButtonActionBlock = ^{
                if ([model.postValue isEqualToString:@"1"]) {
                    model.postValue = @"0";
                } else {
                    model.postValue = @"1";
                }
            };
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.switchButton.enabled = NO;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.switchButton.enabled = NO;
                    }
                }
            }
            
            return cell;
        } else if ([model.locatedTitle isEqualToString:@"车牌"]) {
                AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
                //        UIButton*findCopyButton=[cell viewWithTag:110];
                cell.inputTextField.delegate=self;
                cell.tagLabel.hidden = YES;
                cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
                cell.inputTextField.placeholder = @"请输入";
                cell.nameTitleLabel.text=model.locatedTitle;   //标题
                if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                    cell.textStr=model.nameValue;
                }else{
                    cell.textStr=nil;
                }
            
                cell.changeTextBlock = ^(NSString *textStr) {
                    MyLog(@"%@",textStr);
                    
                    model.nameValue=textStr;
                    model.postValue=textStr;
                    
                };
            
                return cell;
        } else if ([model.locatedTitle isEqualToString:@"保有车辆"]) {
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            //        UIButton*findCopyButton=[cell viewWithTag:110];
            cell.inputTextField.delegate=self;
            cell.tagLabel.hidden = YES;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.inputTextField.placeholder = @"请输入";
            cell.nameTitleLabel.text=model.locatedTitle;   //标题
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {

                cell.textStr=model.nameValue;
            }else{
                cell.textStr=nil;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                
                model.nameValue=textStr;
                model.postValue=textStr;
                
            };
            
            return cell;
        }else if ([model.locatedTitle isEqualToString:@"公司"]){
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            //        UIButton*findCopyButton=[cell viewWithTag:110];
            cell.inputTextField.delegate=self;
            cell.tagLabel.hidden = YES;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.inputTextField.placeholder = @"请输入";
            cell.nameTitleLabel.text=model.locatedTitle;   //标题
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                
                cell.textStr=model.nameValue;
            }else{
                cell.textStr=nil;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                
                model.nameValue=textStr;
                model.postValue=textStr;
                
            };
            
            return cell;
        }else if ([model.locatedTitle isEqualToString:@"职务"]){
            AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
            //        UIButton*findCopyButton=[cell viewWithTag:110];
            cell.inputTextField.delegate=self;
            cell.tagLabel.hidden = YES;
            cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
            cell.inputTextField.placeholder = @"请输入";
            cell.nameTitleLabel.text=model.locatedTitle;   //标题
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                
                cell.textStr=model.nameValue;
            }else{
                cell.textStr=nil;
            }
            cell.changeTextBlock = ^(NSString *textStr) {
                MyLog(@"%@",textStr);
                
                model.nameValue=textStr;
                model.postValue=textStr;
                
            };
            
            return cell;
        } else if ([model.locatedTitle isEqualToString:@"客户备注"]){
            //预约备注
            CGCNewAppointTextCell*cell=[tableView dequeueReusableCellWithIdentifier:RemarkCell];
            cell.topTitleLabel.text=@"备注";
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
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.textView.editable = NO;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.textView.editable = NO;
                    }
                }
            }
            
            return cell;
            
        } else{
            //选择cell
            AddCustomerChooseTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:chooseCell];
            cell.taglabel.hidden=YES;
            cell.nameTitleLabel.text=model.locatedTitle;
            if (model.nameValue&&![model.nameValue isEqualToString:@""]) {
                cell.textStr=model.nameValue;
            }else{
                cell.textStr=nil;
            }
            if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
            }else {
                if ([self.assistStr isEqualToString:@"协助"]) {
                    if (![[NewUserSession instance].appcode containsObject:@"APP016_0005"]) {
                        cell.chooseTextField.enabled = NO;
                    }
                } else {
                    if (![[NewUserSession instance].appcode containsObject:@"APP004_0003"]) {
                        cell.chooseTextField.enabled = NO;
                    }
                }
            }
            
            if ([model.locatedTitle isEqualToString:@"购车类型"]) {
                cell.taglabel.hidden=YES;
                if (model.postValue.length > 0) {
                    cell.textStr = model.nameValue;
                } else {
                    cell.textStr = @"新购";
                    model.nameValue = @"新购";
                    model.postValue = @"A41500_C_BUYTYPE_0000";
                }
                cell.Type=ChooseTableViewTypeCustomerCarType;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    
                    NSMutableArray*localArr=self.localDatas[0];
                    //                [localArr removeObjectAtIndex:2];
                    PotentailCustomerEditModel*yx_model=[[PotentailCustomerEditModel alloc]init];
                    yx_model.locatedTitle=@"意向车型";
                    yx_model.nameValue=@"";
                    yx_model.postValue=@"";
                    yx_model.keyValue=@"C_A49600_C_ID";
                    
                    
                    PotentailCustomerEditModel*pp_model=[[PotentailCustomerEditModel alloc]init];
                    pp_model.locatedTitle=@"匹配车型";
//                    pp_model.locatedTitle=@"意向车型";
                    pp_model.nameValue=@"";
                    pp_model.postValue=@"";
                    pp_model.keyValue=@"C_A71000_C_ID";
                    
                    
                    weakSelf.C_A49600_C_ID = @"";
                    weakSelf.C_A70600_C_ID = @"";
                    weakSelf.C_YX_A49600_C_ID = @"";
                    weakSelf.C_YX_A70600_C_ID = @"";
                    
                    if ([postValue isEqualToString:@"A41500_C_BUYTYPE_0000"]) {//新购
                        [localArr replaceObjectAtIndex:5 withObject:yx_model];
                    } else if ([postValue isEqualToString:@"A41500_C_BUYTYPE_0001"]) {
                        [localArr replaceObjectAtIndex:5 withObject:pp_model];
                        
                    } else {
                        [localArr replaceObjectAtIndex:5 withObject:yx_model];
                    }
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                    
                };
            } else if ([model.locatedTitle isEqualToString:@"客户等级"]) {
                //选择客户等级
                if ([self.btArray containsObject:@"a415_C_LEVEL_DD_ID"]) {
                    cell.taglabel.hidden=NO;
                } else {
                    cell.taglabel.hidden = YES;
                }
                cell.Type=ChooseTableViewTypeLevel;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                };
                
            }else if ([model.locatedTitle isEqualToString:@"性别"]){
                
               
                    cell.taglabel.hidden = YES;
                
                cell.Type=ChooseTableViewTypeGender;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"来源渠道"]){
                
                if ([self.btArray containsObject:@"a415_C_CLUESOURCE_DD_ID"]) {
                    cell.taglabel.hidden = NO;
                } else {
                    cell.taglabel.hidden = YES;
                }
                cell.Type=ChooseTableViewTypeCustomerSource;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    
                    
                    NSInteger index = 0;
                    for (PotentailCustomerEditModel *editModel in localArr) {
                        if ([editModel.locatedTitle isEqualToString:@"渠道细分"]) {
                            index = [localArr indexOfObject:editModel];
                        }
                    }
                    NSInteger index1 = 0;
                    for (PotentailCustomerEditModel *editModel in localArr) {
                        if ([editModel.locatedTitle isEqualToString:@"介绍人"]) {
                            index1 = [localArr indexOfObject:editModel];
                        }
                    }
                    PotentailCustomerEditModel*model2=localArr[index];
                    model2.nameValue=@"";
                    model2.postValue=@"";
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath,[NSIndexPath indexPathForRow:index inSection:0],[NSIndexPath indexPathForRow:index1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"渠道细分"]){
                
                if ([self.btArray containsObject:@"a415_C_CLUESOURCE_DD_ID"]) {
                    cell.taglabel.hidden = NO;
                } else {
                    cell.taglabel.hidden = YES;
                }
                cell.Type=ChooseTableViewTypeAction;
                NSInteger index = 0;
                for (PotentailCustomerEditModel *editModel in localArr) {
                    if ([editModel.locatedTitle isEqualToString:@"来源渠道"]) {
                        index = [localArr indexOfObject:editModel];
                    }
                }
                PotentailCustomerEditModel*model2=localArr[index];
                cell.SourceID=model2.postValue;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            } else if ([model.locatedTitle isEqualToString:@"设计师"]){
                cell.Type=chooseTypeNil;
                PotentailCustomerEditModel*model2=localArr[9];
                cell.SourceID=model2.postValue;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    AddHelperViewController *vc = [[AddHelperViewController alloc]init];
                    vc.vcName = @"设计师";
                    if ([[NewUserSession instance].appcode containsObject:@"APP004_0028"]) {
                        vc.isAllHepler = @"是";
                    }
                    vc.editStr = @"编辑";
                    vc.C_A41500_C_ID = weakSelf.mainModel.C_A41500_C_ID;
                    vc.userBlock = ^(NSString *nameStr, NSString *codeStr) {
                        model.nameValue=nameStr;
                        model.postValue=codeStr;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimation)UITableViewRowAnimationFade];
                        //                    [weakSelf HttpAddDesignerWithAndOrder:model.C_ID andDesigner:codeStr]
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
            } else if ([model.locatedTitle isEqualToString:@"介绍人"]) {
                //经纪人
                if ([[KUSERDEFAULT objectForKey:@"accountCheck"] isEqualToString:@"zhongma"]) {
                    PotentailCustomerEditModel *model7 = localArr[7];
                    if ([model7.postValue isEqual:@"C_CLUESOURCE_DD_0009"] || [model7.postValue isEqual:@"A41300_C_CLUESOURCE_0012"]) {
                        cell.taglabel.hidden = NO;
                    } else {
                        cell.taglabel.hidden=YES;
                    }
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
                        model.nameValue=model1.C_NAME;
                        model.postValue=model1.C_ID;
                        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                };
            } else if ([model.locatedTitle isEqualToString:@"预算"]) {
                if ([self.btArray containsObject:@"a415_C_LEVEL_DD_ID"]) {
                    cell.taglabel.hidden = NO;
                } else {
                    cell.taglabel.hidden = YES;
                }
                cell.chooseTextField.enabled = YES;
                cell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
                cell.C_TYPECODE = @"A41500_C_YS";
                cell.textStr = model.nameValue;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    model.postValue = postValue;
                    model.nameValue = str;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                return cell;
            } else if ([model.locatedTitle isEqualToString:@"购车阶段"]) {
                if ([self.btArray containsObject:@"a415_C_PAYMENT_DD_ID"]) {
                    cell.taglabel.hidden = NO;
                } else {
                    cell.taglabel.hidden = YES;
                }
                cell.chooseTextField.enabled = YES;
                cell.C_TYPECODE = @"A41500_C_PAYMENT";
                cell.textStr = model.nameValue;
                cell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    model.postValue = postValue;
                    model.nameValue = str;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                return cell;
            } else if ([model.locatedTitle isEqualToString:@"业务"]) {
                //线索提供人
                cell.Type=chooseTypeNil;
                cell.textStr = model.nameValue;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
                    if ([[NewUserSession instance].appcode containsObject:@"APP004_0028"]) {
                        vc.isAllEmployees = @"是";
                    }
                    vc.noticeStr = @"无提示";
                    vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull showModel) {
                        model.nameValue=showModel.user_name;
                        model.postValue=showModel.user_id;
                        //                    weakSelf.C_CLUEPROVIDER_ROLEID = codeStr;
                        //                    weakSelf.C_CLUEPROVIDER_ROLEStr = nameStr;
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                        
                    };
                    //                vc.vcName = @"订单";
                    //                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                    //                    model.nameValue=nameStr;
                    //                    model.postValue=codeStr;
                    //                    //                    weakSelf.C_CLUEPROVIDER_ROLEID = codeStr;
                    //                    //                    weakSelf.C_CLUEPROVIDER_ROLEStr = nameStr;
                    //                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    //                };
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                    
                    
                };
            }
            
#pragma section1
            
            else if ([model.locatedTitle isEqualToString:@"省市"]){
                if ([self.btArray containsObject:@"a415_C_PROVINCE"]) {
                    cell.taglabel.hidden = NO;
                } else {
                    cell.taglabel.hidden = YES;
                }
                cell.Type=ChooseTableViewTypeCity;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }
            //ChooseTableViewTypeHobby
            else if ([model.locatedTitle isEqualToString:@"爱好"]){
                cell.Type=ChooseTableViewTypeHobby;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"行业"]){
                cell.Type=ChooseTableViewTypeIndustry;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"年收入"]){
                cell.Type=ChooseTableViewTypeYearIn;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"文化程度"]){
                cell.Type=ChooseTableViewTypeEducation;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"婚姻状况"]){
                cell.Type=ChooseTableViewTypeMarriage;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }else if ([model.locatedTitle isEqualToString:@"生日"]){
                cell.Type=ChooseTableViewTypeBirthday;
                cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                    MyLog(@"str-- %@      post---%@",str,postValue);
                    model.nameValue=str;
                    model.postValue=postValue;
                    [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    
                    
                };
            }
            
            
            return cell;
            
        }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray*localArr=self.localDatas[indexPath.section];
    PotentailCustomerEditModel*model=localArr[indexPath.row];
    if (indexPath.section==0&&indexPath.row==0) {
        return 60;
    }else if ([model.locatedTitle isEqualToString:@"客户地址"]) {
        
        NSMutableArray*localArr=self.localDatas[indexPath.section];
        PotentailCustomerEditModel*model=localArr[indexPath.row];
        if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
            //            NSString *str = [NSString stringWithFormat:@"%@%@",model.nameValue,self.addressStr];
            
            
            NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
            CGSize size = [model.nameValue boundingRectWithSize:CGSizeMake(KScreenWidth - 115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            //        if (([NewUserSession instance].configData.IS_KHXQDZ.boolValue == YES)) {
            if (size.height + 17 > 44) {
                return size.height + 17;
            } else {
                return 44;
            }
        } else {
            NSString *str = [NSString stringWithFormat:@"%@",self.addressStr];
            
            
            NSDictionary *dic = @{NSFontAttributeName : [UIFont systemFontOfSize:14.f ]};
            CGSize size = [str boundingRectWithSize:CGSizeMake(KScreenWidth-115, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
            //        if (([NewUserSession instance].configData.IS_KHXQDZ.boolValue == YES)) {
            if (size.height + 44 + 20 > 88) {
                return size.height + 44 + 20;
            } else {
                return 88;
            }
        }
        
    } else if ([model.locatedTitle isEqualToString:@"客户备注"]){
        return 100;
    }else{
        return 44;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section==1) {
        return 160;
    }else{
        return 0.01;
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    mainView.backgroundColor=[UIColor clearColor];
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, KScreenWidth/2, 14)];
    titleLabel.textColor=[UIColor blackColor];
    [mainView addSubview:titleLabel];
    if (section==0) {
        titleLabel.text=@"基本信息";
    }else{
        titleLabel.text=@"其他信息";
    }
    
    return mainView;
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    //    DBSelf(weakSelf);
    if (section==1) {
        if (self.mainModel.fileList.count > 0) {
            NSMutableArray *tarr = [NSMutableArray array];
            for (VideoAndImageModel *vmodel in self.mainModel.fileList) {
                [tarr addObject:vmodel.url];
            }
            self.tableFootPhoto.imageURLArray = tarr;
        }
        return self.tableFootPhoto;
        
        
    }else{
        return nil;
    }
    
}
- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
        _tableFootPhoto.isEdit = YES;
        _tableFootPhoto.isCamera = NO;
        _tableFootPhoto.rootVC = self;
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
            weakSelf.imageUrlArray = arr;
            weakSelf.saveImageUrlArray = saveArr;
//            weakSelf.mainModel.urlList = arr;
        };
    }
    return _tableFootPhoto;
};


#pragma mark  --click
- (void)navAction:(UIButton *)sender {
    if (self.mainModel.C_ADDRESS.length > 0 || self.mainModel.C_A48200_C_ID.length > 0) {
        NSString *str = [NSString stringWithFormat:@"%@ %@",self.mainModel.C_A48200_C_NAME, self.mainModel.C_ADDRESS];
        
        MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        alertVC.C_ADDRESS = str;
        [self presentViewController:alertVC animated:YES completion:nil];
    } else {
        [JRToast showWithText:@"暂无客户地址"];
        return;
    }
}

-(void)clickFindCopy{
    PotentailCustomerEditModel*model=self.localDatas[0][1];
    if (model.postValue.length > 0) {
        [self httpPostRepetitioCustomerWithType:@"C_PHONE" andContent:model.postValue andNeedBlock:NO success:nil];
    } else {
        [JRToast showWithText:@"还没有该潜客"];
    }
}

-(void)clickCommitButton:(UIButton*)button{
    NSString*judgeStr= [self judgeCanSave];
    if (!_canSave) {
        [JRToast showWithText:judgeStr];
        return;
    }
    
    
    if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
        //新增潜客  1.先查重  2.后上传footer图片   3.再提交新增潜客    4.再修改他的@"匹配车型"
        //客户微信
        PotentailCustomerEditModel*model=self.localDatas[0][2];
        if (model.nameValue.length > 0) {
            //            [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
            //                NSString*X_PICURLStr=[arrayImg componentsJoinedByString:@","];
            //                [self.saveFooterUrlArray addObjectsFromArray:arrayImg];
            //新增潜客
            [self httpPostAddOrEditNewCustomerWithFooterImageStr:self.saveImageUrlArray complete:^(id data) {
                dispatch_after(0.5, dispatch_get_main_queue(), ^{
                    //修改他的@"匹配车型"
                    NSString*C_id=self.mainModel.C_ID.length > 0 ? self.mainModel.C_ID : _customerID;
                    CustomerDetailInfoModel*newModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
                    //                    [self httpPostLikeProductWith:C_id complete:^(id data) {
                    //                         if (self.phoneNumber.length > 0) {
                    //
                    //                         } else {
                    //                            [self.navigationController popViewControllerAnimated:YES];
                    //                         }
                    if (self.completeComitBlock) {
                        self.completeComitBlock(C_id,newModel);
                    }
                    
                    //新增完成之后的代理
                    if ([self.delegate respondsToSelector:@selector(DelegateForCompleteAddCustomerShowAlertVCToFollow:)]) {
                        [self.delegate DelegateForCompleteAddCustomerShowAlertVCToFollow:newModel];
                        if (self.Type == customerTypeCallTo) {
                            return ;
                        }
                    }
                    
                    for (UIViewController*vc in self.navigationController.viewControllers) {
                        if ([vc isKindOfClass:[MJKFlowMeterViewController class]]) {
                            return;
                        }
                        if ([vc isKindOfClass:[self.superVC class]]) {
                            [self.navigationController popToViewController:self.superVC animated:YES];
                            return ;
                        }
                    }
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    
                });
                
                
                
                
                
                
                //                    }];
                
            }];
            //            }];
        } else {
            
            
            //查重
                        PotentailCustomerEditModel*phoneModel=self.localDatas[0][1];
                        if (phoneModel.postValue.length > 0) {
                            [self httpPostRepetitioCustomerWithType:@"C_PHONE" andContent:model.postValue andNeedBlock:YES success:^(id data) {
            //                    NSLog(@"%@",data);
            
            //footer 上传图片 返回地址
            [self laterAddCustomer];
                                    }];
                        } else {
                            [self laterAddCustomer];
                        }
            
        }
        
        
        
    }else{
        //编辑潜客
                PotentailCustomerEditModel*phoneModel=self.localDatas[0][1];
                      if ([phoneModel.postValue isEqualToString:self.mainModel.C_PHONE]) {
        //不需要查重  直接到 footer
        [self laterCheatCopyPhone];
        
                }else{
        
                        //需要查重
                        PotentailCustomerEditModel*phoneModel=self.localDatas[0][1];
                        if (phoneModel.postValue.length > 0) {
                            [self httpPostRepetitioCustomerWithType:@"C_PHONE" andContent:phoneModel.postValue andNeedBlock:YES success:^(id data) {
                                [self laterCheatCopyPhone];
        
        
                            }];
                        } else {
                            //已有微信
                            if (self.mainModel.C_WECHAT.length > 0) {
        
                                    [self laterCheatCopyPhone];
        
        
                            } else {
                                //后来输入的
                                PotentailCustomerEditModel*wchatModel=self.localDatas[0][2];
                                if (wchatModel.postValue.length > 0) {
                                    [self laterCheatCopyPhone];
                                }
        
        
                        }
                    }
        
        
        
                }
        
        
        
    }
    
}

- (void)laterAddCustomer {
    //    [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
    //        NSString*X_PICURLStr=[arrayImg componentsJoinedByString:@","];
    //新增潜客
    [self httpPostAddOrEditNewCustomerWithFooterImageStr:self.saveImageUrlArray complete:^(id data) {
        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            //修改他的@"匹配车型"
            NSString*C_id=self.mainModel.C_ID.length > 0 ? self.mainModel.C_ID : _customerID;
            CustomerDetailInfoModel*newModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            //            [self httpPostLikeProductWith:C_id complete:^(id data) {
            //                         if (self.phoneNumber.length > 0) {
            //
            //                         } else {
            //                            [self.navigationController popViewControllerAnimated:YES];
            //                         }
            if (self.completeComitBlock) {
                self.completeComitBlock(C_id,newModel);
            }
            
            //新增完成之后的代理
            if ([self.delegate respondsToSelector:@selector(DelegateForCompleteAddCustomerShowAlertVCToFollow:)]) {
                [self.delegate DelegateForCompleteAddCustomerShowAlertVCToFollow:newModel];
                if (self.Type == customerTypeCallTo) {
                    return ;
                }
            }
            
            for (UIViewController*vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[MJKFlowMeterViewController class]]) {
                    return;
                }
                if ([vc isKindOfClass:[self.superVC class]]) {
                    [self.navigationController popToViewController:self.superVC animated:YES];
                    return ;
                }
                //                             if ([vc isKindOfClass:[MJKClueListViewController class]]) {
                //
                //                                 [self.navigationController popToViewController:vc animated:YES];
                //                                 return;
                //                             }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            
        });
        
        
        
        
        
        
        //            }];
        
    }];
    //    }];
}



-(void)laterCheatCopyPhone{
    //    [self httpPostArrayImage:self.saveFooterImageDataDic compliete:^(NSArray *arrayImg) {
    //        [self.saveFooterUrlArray removeObject:@"xxx"];
    //        [self.saveFooterUrlArray addObjectsFromArray:arrayImg];
    //         NSString*X_PICURLStr=[self.saveFooterUrlArray componentsJoinedByString:@","];
    //新增潜客
    [self httpPostAddOrEditNewCustomerWithFooterImageStr:self.saveImageUrlArray complete:^(id data) {
        dispatch_after(0.5, dispatch_get_main_queue(), ^{
            //修改他的@"匹配车型"
            NSString*C_id=self.mainModel.C_ID;
            CustomerDetailInfoModel*newModel=[CustomerDetailInfoModel yy_modelWithDictionary:data[@"data"]];
            //            [self httpPostLikeProductWith:C_id complete:^(id data) {
            
            if (self.completeComitBlock) {
                self.completeComitBlock(C_id,newModel);
            }
            
            
            
            for (UIViewController*vc in self.navigationController.viewControllers) {
                if ([vc isKindOfClass:[self.superVC class]]) {
                    [self.navigationController popToViewController:self.superVC animated:YES];
                    return ;
                }
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
        });
        //            }];
        
        
    }];
    
    
    //    }];
    
}

- (void)addArea {
    DBSelf(weakSelf);
    NSMutableArray*localArr=self.localDatas[0];
    PotentailCustomerEditModel*model=localArr[2];
    MJKShowAreaViewController *vc = [[MJKShowAreaViewController alloc]init];
    vc.selectAddressBlock = ^(MJKShowAreaModel *showModel) {
        
        if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
            model.nameValue=showModel.C_NAMEANDADDRESS;
            model.postValue=showModel.C_NAMEANDADDRESS;
            weakSelf.C_A48200_C_ID = showModel.C_ID;
            weakSelf.addressStr = @"";
            MJKAddressTableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            cell.textView.text = showModel.C_NAMEANDADDRESS;
            
            [cell.textView becomeFirstResponder];
            
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView endUpdates];
        } else {
            model.nameValue=showModel.C_ADDRESS;
            model.postValue=showModel.C_ADDRESS;
            weakSelf.C_A48200_C_ID = showModel.C_ID;
            NSString *chooseAreaStr = [showModel.C_NAMEANDADDRESS substringToIndex:showModel.C_NAMEANDADDRESS.length - showModel.C_ADDRESS.length];
            weakSelf.addressStr = chooseAreaStr;
            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            
        }
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark  -- delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    NSData*data=UIImageJPEGRepresentation(newPhoto, 0.5);
    
    //    //吊接口  照片
    //    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    UIImageView*imageView=[cell viewWithTag:111];
    //    imageView.image=newPhoto;
    
    
    if (self.selectedImage==0) {
        //头像
        AddCustomerPhotoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.imageButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
        
        
        [self HttpPostOneImageToJiekouWith:data];
        
        
    }else if (self.selectedImage==11){
        //footer 第一张图
        [self.saveFooterImageDataDic setObject:data forKey:@"11"];
        //        [self.self.footerImageView.firstPicBtn setImage:newPhoto forState:UIControlStateNormal];
        self.footerImageView.firstImg=newPhoto;
        if (self.saveFooterUrlArray.count>=1) {
            [self.saveFooterUrlArray replaceObjectAtIndex:0 withObject:@"xxx"];
        }
        
        
    }else if (self.selectedImage==22){
        //footer 第二张图
        [self.saveFooterImageDataDic setObject:data forKey:@"22"];
        //         [self.self.footerImageView.secondPicBtn setImage:newPhoto forState:UIControlStateNormal];
        self.footerImageView.secondImg=newPhoto;
        if (self.saveFooterUrlArray.count>=2) {
            [self.saveFooterUrlArray replaceObjectAtIndex:1 withObject:@"xxx"];
        }
        
        
    }else if (self.selectedImage==33){
        //footer 第三张图
        [self.saveFooterImageDataDic setObject:data forKey:@"33"];
        //         [self.self.footerImageView.thirdPicBtn setImage:newPhoto forState:UIControlStateNormal];
        self.footerImageView.thirdImg=newPhoto;
        if (self.saveFooterUrlArray.count>=3) {
            [self.saveFooterUrlArray replaceObjectAtIndex:2 withObject:@"xxx"];
        }
        
    }
    
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark  --getDatas
//设计师
- (void)HttpAddDesignerWithAndCustomer:(NSString *)customerID andDesigner:(NSString *)designer {
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"CustomerWebService-operationDesigner"];
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    //    contentDict[@"C_ID"] = [DBObjectTools getA47200C_id];
    contentDict[@"C_ID"] = customerID;
    contentDict[@"C_DESIGNER_ROLEID"] = designer;
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:data[@"message"]];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
    }];
}

-(void)httpPostRepetitioCustomerWithType:(NSString *)type andContent:(NSString *)content andNeedBlock:(BOOL)needBlock  success:(void(^)(id data))successBlock {
    
    DBSelf(weakSelf);
    NSMutableDictionary *contentDict=[NSMutableDictionary dictionary];
    contentDict[@"repetitioType"] = type;
    contentDict[type] = content;
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:HTTP_RepetitioCustomer parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            if (![data[@"data"][@"FLAG"] isEqualToString:@"true"]) {
                if ([data[@"data"][@"FLAG"] isEqualToString:@"false"]) {
                    [JRToast showWithText:data[@"data"][@"message"]];
//                    [weakSelf alertViewCreate:[data[@"message"]stringByAppendingString:@",是否请求协助此客户?"] andCustomerID:data[@"C_A41500_C_ID"] completeBlock:^{
//                        [weakSelf HTTPAddHelperCustomerID:data[@"C_A41500_C_ID"]];
//                    }];
                }  else if ([data[@"data"][@"FLAG"] isEqualToString:@"activation"]) {
                    [weakSelf alertViewCreate:data[@"data"][@"message"] andCustomerID:data[@"data"][@"C_A41500_C_ID"]  completeBlock:^{
                       
                        [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:data[@"data"][@"C_A41500_C_ID"] andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                            
                                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"refresh"];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"own"] || [data[@"data"][@"FLAG"] isEqualToString:@"pond"]) {
//                    [JRToast showWithText:data[@"message"]];
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:data[@"data"][@"C_A41500_C_ID"] andSuccessBlock:^{
                            for (UIViewController*vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[self.superVC class]]) {
                                    [weakSelf.navigationController popToViewController:self.superVC animated:YES];
                                    return ;
                                }
                            }
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                    [ac addAction:trueAction];
                    [ac addAction:cancelAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                    
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"soon"]) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        successBlock(data);
                    }];
                    [ac addAction:knowAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                    
                    
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"exceed"]){
                    //exceed
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                    [ac addAction:knowAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                }
            }  else {
                //是否需要回调
                if (needBlock) {
                    if (successBlock) {
                        successBlock(data);
                    }
                    
                }else{
                    [JRToast showWithText:data[@"data"][@"message"]];
                }
            }
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
    
    
    
    
    
}

//领用
- (void)httpCustomerToSeaWithType:(NSString *)type andCustomerId:(NSString *)customerID andSuccessBlock:(void(^)(void))completeBlock {
    DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    dict[@"C_BACKPOND_TYPE"] = type;
    
    dict[@"ids"] = @[customerID];
    
   
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/operationCustomerPond", HTTP_IP] parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([type isEqualToString:@"1"]) {
                [JRToast showWithText:@"转出成功"];
            } else if ([type isEqualToString:@"3"]) {
                [JRToast showWithText:@"领用成功"];
                
            }
            if (completeBlock) {
                completeBlock();
            }
        } else if ([data[@"code"] integerValue]==201){
            [JRToast showWithText:data[@"msg"]];
        }  else {
            [JRToast showWithText:data[@"msg"]];
        }
        
        
    }];
}



- (void)alertViewCreate:(NSString *)str andCustomerID:(NSString *)customerID  completeBlock:(void(^)(void))completeBlock{
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    //    DBSelf(weakSelf);
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //        [weakSelf HTTPAddHelperCustomerID:customerID];
        if (completeBlock) {
            completeBlock();
        }
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertV addAction:noAction];
    [alertV addAction:yesAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}
//协助
- (void)HTTPAddHelperCustomerID:(NSString *)customerID {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-insert"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = customerID;
    dic[@"C_ID"] = [DBObjectTools getA47200_C_ID] ;
    dic[@"C_ASSISTANT"] = [NewUserSession instance].user.u051Id;
    dic[@"C_TYPE_DD_ID"] = @"A47200_C_TYPE_0001";
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
            [weakSelf.navigationController popViewControllerAnimated:YES];
            //            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

//新增潜客  接口
-(void)httpPostAddOrEditNewCustomerWithFooterImageStr:(NSArray*)imageArray complete:(void(^)(id data))successBlock{
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    
    
    
    if (imageArray.count > 0) {
        NSMutableArray *tarr = [NSMutableArray array];
        for (NSString *str  in imageArray) {
            [tarr addObject:@{@"saveUrl": str}];
        }
        [contentDict setObject:tarr forKey:@"fileList"];
    }
    if (self.portraitAddress&&![self.portraitAddress isEqualToString:@""]) {
        [contentDict setObject:self.portraitAddress forKey:@"C_HEADIMGURL"];
    }
    
    
    
    
    //section 0
    NSMutableArray*FirstArray=self.localDatas[0];
    for (PotentailCustomerEditModel*model in FirstArray) {
        //        if ([model.locatedTitle isEqualToString:@"客户地址"]) {
        //            if ([NewUserSession instance].configData.IS_KHXQDZ.boolValue == NO) {
        //                if (self.addressStr.length > 0) {
        //                    model.postValue = self.addressStr;
        //                }
        //            } else {
        //                if (self.addressStr.length > 0) {
        //                    model.postValue = [model.postValue stringByAppendingString:self.addressStr];
        //                }
        //            }
        //
        //        }
        
        [contentDict setObject:model.postValue forKey:model.keyValue];
        if ([model.locatedTitle isEqualToString:@"设计师"]) {
            [contentDict removeObjectForKey:model.keyValue];
        }
    }
    
    
    //section 1
    NSMutableArray*SecondArray=self.localDatas[1];
    for (int i=0; i<SecondArray.count; i++) {
        PotentailCustomerEditModel*model=SecondArray[i];
        if (i==1) {
            
            NSArray*array=[model.postValue componentsSeparatedByString:@","];
            if (array&&array.count==2) {
                NSArray*keyArray=[model.keyValue componentsSeparatedByString:@","];
                
                [contentDict setObject:array[0] forKey:keyArray[0]];
                [contentDict setObject:array[1] forKey:keyArray[1]];
            }
            
            
        }else{
            if ([model.postValue isEqualToString:self.pubRemarketStr]) {
                NSLog(@"");
            }
            [contentDict setObject:model.postValue forKey:model.keyValue];
            if ([model.locatedTitle isEqualToString:@"开工时间"]) {
                if (model.postValue.length <=0) {
                    [contentDict removeObjectForKey:model.keyValue];
                }
            } else if ([model.keyValue isEqualToString:@"X_REMARK"]) {
                NSArray *arr = [self getURLFromStr:model.postValue];
                if (arr.count > 0) {
                    NSString *str = arr[0];
                    NSString *str1 = arr[0];
                    NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
                    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
                    NSString *encodedUrl = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
                    model.postValue = [model.postValue stringByReplacingOccurrencesOfString:str1 withString:encodedUrl];
                }
                [contentDict setObject:model.postValue forKey:model.keyValue];
            }
        }
        
        
    }
    
    
    if (self.C_A48200_C_ID.length > 0) {
        
        [contentDict setObject:self.C_A48200_C_ID forKey:@"C_A48200_C_ID"];
    }
    
    //后台   一定要去掉  不然就是 网络错误
    if (!contentDict[@"C_BIRTHDAY_TIME"]||[contentDict[@"C_BIRTHDAY_TIME"] isEqualToString:@""]) {
        [contentDict removeObjectForKey:@"C_BIRTHDAY_TIME"];
    }
    
    if (self.C_A49600_C_ID.length > 0) {
        contentDict[@"C_A49600_C_ID"] = self.C_A49600_C_ID;
    }
    if (self.C_A70600_C_ID.length > 0) {
        contentDict[@"C_A70600_C_ID"] = self.C_A70600_C_ID;
    }
    if (self.C_YX_A49600_C_ID.length > 0) {
        contentDict[@"C_YX_A49600_C_ID"] = self.C_YX_A49600_C_ID;
    }
    if (self.C_YX_A70600_C_ID.length > 0) {
        contentDict[@"C_YX_A70600_C_ID"] = self.C_YX_A70600_C_ID;
    }

    
    
    DBSelf(weakSelf);
    
    if (self.Type==customerTypeAdd||self.Type==customerTypeCallTo||self.Type==customerTypeExhibition) {
        
        if (self.Type==customerTypeCallTo&&_phoneC_A41400_C_ID) {
            [contentDict setObject:_phoneC_A41400_C_ID forKey:@"C_A41400_C_ID"];
        }
        
        
        if (self.Type==customerTypeExhibition&&_exhibitionC_A41400_C_ID) {
            [contentDict setObject:_exhibitionC_A41400_C_ID forKey:@"C_A41400_C_ID"];
        }
        if ([self.vcName isEqualToString:@"名单"]) {
            contentDict[@"C_APPSOURCE_DD_ID"] = @"A41500_C_APPSOURCE_0002";
        } else if ([self.vcName isEqualToString:@"门店"]) {
            contentDict[@"C_APPSOURCE_DD_ID"] = @"A41500_C_APPSOURCE_0000";
        } else if ([self.vcName isEqualToString:@"来电"]) {
            contentDict[@"C_APPSOURCE_DD_ID"] = @"A41500_C_APPSOURCE_0001";
        } else {
            contentDict[@"C_APPSOURCE_DD_ID"] = @"A41500_C_APPSOURCE_0003";
        }
        if (self.C_A41300_C_ID.length > 0) {
            contentDict[@"C_A41300_C_ID"] = self.C_A41300_C_ID;
        }

        
        //        NSString*cid=[DBObjectTools getPotentailcustomerC_id];
        [contentDict setObject:_customerID forKey:@"C_ID"];
        
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postNewDataFromNetworkWithUrl:[NSString  stringWithFormat:@"%@/api/crm/a415/add", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"code"] integerValue]==200) {
                
                
                [KUSERDEFAULT setObject:@"YES" forKey:@"refresh"];
                //                if (weakSelf.productArray.count > 0) {
                //                    [weakSelf addProduct:contentDict[@"C_ID"]];
                //                }
                if ([data[@"data"][@"FLAG"] isEqualToString:@"false"]) {
                    [JRToast showWithText:data[@"data"][@"message"]];
//                    [weakSelf alertViewCreate:[data[@"message"]stringByAppendingString:@",是否请求协助此客户?"] andCustomerID:data[@"C_A41500_C_ID"] completeBlock:^{
//                        [weakSelf HTTPAddHelperCustomerID:data[@"C_A41500_C_ID"]];
//                    }];
                }  else if ([data[@"data"][@"FLAG"] isEqualToString:@"activation"]) {
                    [weakSelf alertViewCreate:data[@"data"][@"message"] andCustomerID:contentDict[@"C_ID"] completeBlock:^{
                       
                        [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:data[@"data"][@"C_A41500_C_ID"] andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                            
                                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"refresh"];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"own"] || [data[@"data"][@"FLAG"] isEqualToString:@"pond"]) {
//                    [JRToast showWithText:data[@"message"]];
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:data[@"data"][@"C_A41500_C_ID"] andSuccessBlock:^{
                            for (UIViewController*vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[self.superVC class]]) {
                                    [weakSelf.navigationController popToViewController:self.superVC animated:YES];
                                    return ;
                                }
                            }
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                    [ac addAction:trueAction];
                    [ac addAction:cancelAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                    
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"soon"]) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        successBlock(data);
                    }];
                    [ac addAction:knowAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                    
                    
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"exceed"]){
                    //exceed
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                    [ac addAction:knowAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                }
                else {
                    successBlock(data);
                }
                
                //成功了 之后   吊产品接口
                //                PotentailCustomerEditModel*model=weakSelf.localDatas[0][10];
                //                [weakSelf HttpAddDesignerWithAndCustomer:_customerID andDesigner:model.postValue];
                
            }else if ([data[@"code"] integerValue] == 5202) {
                
                
                [KUSERDEFAULT setObject:@"YES" forKey:@"refresh"];
                //                if (weakSelf.productArray.count > 0) {
                //                    [weakSelf addProduct:contentDict[@"C_ID"]];
                //                }
                if ([data[@"data"][@"FLAG"] isEqualToString:@"false"]) {
                    [JRToast showWithText:data[@"data"][@"message"]];
//                    [weakSelf alertViewCreate:[data[@"message"]stringByAppendingString:@",是否请求协助此客户?"] andCustomerID:data[@"C_A41500_C_ID"] completeBlock:^{
//                        [weakSelf HTTPAddHelperCustomerID:data[@"C_A41500_C_ID"]];
//                    }];
                }  else if ([data[@"data"][@"FLAG"] isEqualToString:@"activation"]) {
                    [weakSelf alertViewCreate:data[@"data"][@"message"] andCustomerID:contentDict[@"C_ID"] completeBlock:^{
                       
                        [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:data[@"data"][@"C_A41500_C_ID"] andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                            
                                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"refresh"];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"own"] || [data[@"data"][@"FLAG"] isEqualToString:@"pond"]) {
//                    [JRToast showWithText:data[@"message"]];
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:data[@"data"][@"C_A41500_C_ID"] andSuccessBlock:^{
                            for (UIViewController*vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[self.superVC class]]) {
                                    [weakSelf.navigationController popToViewController:self.superVC animated:YES];
                                    return ;
                                }
                            }
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                    [ac addAction:trueAction];
                    [ac addAction:cancelAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                    
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"soon"]) {
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        successBlock(data);
                    }];
                    [ac addAction:knowAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                    
                    
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"exceed"]){
                    //exceed
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
                    [ac addAction:knowAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                }
                else {
                    successBlock(data);
                }
                
                //成功了 之后   吊产品接口
                //                PotentailCustomerEditModel*model=weakSelf.localDatas[0][10];
                //                [weakSelf HttpAddDesignerWithAndCustomer:_customerID andDesigner:model.postValue];
                
            }else{
                [JRToast showWithText:data[@"msg"]];
            }
        }];

        
    }else{
        [contentDict setObject:self.mainModel.C_ID forKey:@"C_ID"];
        
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postNewDataFromNetworkWithUrl:[NSString  stringWithFormat:@"%@/api/crm/a415/edit", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"code"] integerValue]==200) {
                //                if (weakSelf.productArray.count > 0) {
                //                    [weakSelf addProduct:contentDict[@"C_ID"]];
                //                }
                //成功了 之后   吊产品接口
//                PotentailCustomerEditModel*model=weakSelf.localDatas[0][11];
//                if (![weakSelf.mainModel.C_DESIGNER_ROLENAME isEqualToString:model.nameValue]) {
//                    [weakSelf HttpAddDesignerWithAndCustomer:weakSelf.mainModel.C_ID andDesigner:model.postValue];
//                }
                if ([data[@"data"][@"FLAG"] isEqualToString:@"false"]) {
                    [JRToast showWithText:data[@"data"][@"message"]];
//                    [weakSelf alertViewCreate:[data[@"message"]stringByAppendingString:@",是否请求协助此客户?"] andCustomerID:data[@"C_A41500_C_ID"] completeBlock:^{
//                        [weakSelf HTTPAddHelperCustomerID:data[@"C_A41500_C_ID"]];
//                    }];
                }  else if ([data[@"data"][@"FLAG"] isEqualToString:@"activation"]) {
                    [weakSelf alertViewCreate:data[@"data"][@"message"] andCustomerID:contentDict[@"C_ID"] completeBlock:^{
                        [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:data[@"data"][@"C_A41500_C_ID"] andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                            
                                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"refresh"];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"own"] || [data[@"data"][@"FLAG"] isEqualToString:@"pond"]) {
//                    [JRToast showWithText:data[@"message"]];
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:data[@"data"][@"C_A41500_C_ID"]  andSuccessBlock:^{
                            for (UIViewController*vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[self.superVC class]]) {
                                    [weakSelf.navigationController popToViewController:self.superVC animated:YES];
                                    return ;
                                }
                            }
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                    [ac addAction:trueAction];
                    [ac addAction:cancelAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                }
                /*else if ([data[@"FLAG"] isEqualToString:@"soon"]) {
                 UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
                 }];
                 [ac addAction:knowAction];
                 [weakSelf presentViewController:ac animated:YES completion:nil];
                 
                 
                 }*/
                else {
                    successBlock(data);
                }
                
                
                
            }  else if ([data[@"code"] integerValue] == 5202) {
                //                if (weakSelf.productArray.count > 0) {
                //                    [weakSelf addProduct:contentDict[@"C_ID"]];
                //                }
                //成功了 之后   吊产品接口
//                PotentailCustomerEditModel*model=weakSelf.localDatas[0][11];
//                if (![weakSelf.mainModel.C_DESIGNER_ROLENAME isEqualToString:model.nameValue]) {
//                    [weakSelf HttpAddDesignerWithAndCustomer:weakSelf.mainModel.C_ID andDesigner:model.postValue];
//                }
                if ([data[@"data"][@"FLAG"] isEqualToString:@"false"]) {
                    [JRToast showWithText:data[@"data"][@"message"]];
//                    [weakSelf alertViewCreate:[data[@"message"]stringByAppendingString:@",是否请求协助此客户?"] andCustomerID:data[@"C_A41500_C_ID"] completeBlock:^{
//                        [weakSelf HTTPAddHelperCustomerID:data[@"C_A41500_C_ID"]];
//                    }];
                }  else if ([data[@"data"][@"FLAG"] isEqualToString:@"activation"]) {
                    [weakSelf alertViewCreate:data[@"data"][@"message"] andCustomerID:contentDict[@"C_ID"] completeBlock:^{
                        [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:data[@"data"][@"C_A41500_C_ID"] andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                            
                                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"refresh"];
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                } else if ([data[@"data"][@"FLAG"] isEqualToString:@"own"] || [data[@"data"][@"FLAG"] isEqualToString:@"pond"]) {
//                    [JRToast showWithText:data[@"message"]];
                    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"data"][@"message"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [weakSelf httpCustomerToSeaWithType:@"3" andCustomerId:data[@"data"][@"C_A41500_C_ID"]  andSuccessBlock:^{
                            for (UIViewController*vc in self.navigationController.viewControllers) {
                                if ([vc isKindOfClass:[self.superVC class]]) {
                                    [weakSelf.navigationController popToViewController:self.superVC animated:YES];
                                    return ;
                                }
                            }
                            
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }];
                    [ac addAction:trueAction];
                    [ac addAction:cancelAction];
                    [weakSelf presentViewController:ac animated:YES completion:nil];
                }
                /*else if ([data[@"FLAG"] isEqualToString:@"soon"]) {
                 UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                 [weakSelf.navigationController popViewControllerAnimated:YES];
                 }];
                 [ac addAction:knowAction];
                 [weakSelf presentViewController:ac animated:YES completion:nil];
                 
                 
                 }*/
                else {
                    successBlock(data);
                }
                
                
                
            }
            /*else if ([data[@"code"] integerValue] == 301) {
             UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:data[@"message"] preferredStyle:UIAlertControllerStyleAlert];
             UIAlertAction *knowAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleCancel handler:nil];
             [ac addAction:knowAction];
             [weakSelf presentViewController:ac animated:YES completion:nil];
             }*/
            else{
                [JRToast showWithText:data[@"msg"]];
            }
            
            
            
        }];
                
    }
    
}



- (void)addProduct:(NSString *)C_A41500_C_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47100WebService-insertByList"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_A41500_C_ID"] = C_A41500_C_ID;
    //    dic[@"C_A42000_C_ID"] = self.orderModel.C_ID.length > 0 ? self.orderModel.C_ID : self.orderC_id;
    dic[@"C_TYPE_DD_ID"] = @"A47100_C_TYPE_0001";
    NSMutableArray *a47100Forms = [NSMutableArray array];
    for (MJKProductShowModel *model in self.productArray) {
        NSMutableDictionary *productDic = [NSMutableDictionary dictionary];
        productDic[@"C_ID"] = [DBObjectTools getA47100C_id];
        productDic[@"C_A41900_C_ID"] = model.C_ID;
        productDic[@"B_PRICE"] = model.B_HDJ;
        //        productDic[@"I_NUMBER"] = [NSString stringWithFormat:@"%ld",(long)model.number];
        productDic[@"X_REMARK"] = model.X_REMARK;
        //        productDic[@"B_MONEY"] = [NSString stringWithFormat:@"%ld",(long)(model.B_HDJ.integerValue * model.number)];
        [a47100Forms addObject:productDic];
    }
    dic[@"a47100Forms"] = a47100Forms;
    
    
    
    [dict setObject:dic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    //    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (NSArray*)getURLFromStr:(NSString *)string {
    NSError *error;
    //可以识别url的正则表达式
    NSString *regulaStr = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSArray *arrayOfAllMatches = [regex matchesInString:string
                                                options:0
                                                  range:NSMakeRange(0, [string length])];
    
    //NSString *subStr;
    NSMutableArray *arr=[[NSMutableArray alloc] init];
    
    for (NSTextCheckingResult *match in arrayOfAllMatches){
        NSString* substringForMatch;
        substringForMatch = [string substringWithRange:match.range];
        [arr addObject:substringForMatch];
    }
    return arr;
}

//上传多张照片  并完成
-(void)httpPostArrayImage:(NSMutableDictionary*)ImageDic compliete:(void(^)(NSArray*arrayImg))successBlock{
    NSMutableArray*ImageArray=[NSMutableArray array];
    [ImageDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [ImageArray addObject:obj];
    }];
    
    
    if (ImageArray.count<1) {
        successBlock(nil);
    }else{
        
        NSMutableArray*saveFooterImageAddress=[NSMutableArray array];
        
        for (NSData*imageData in ImageArray) {
            NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
            HttpManager*manager=[[HttpManager alloc]init];
            [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:imageData compliation:^(id data, NSError *error) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    
                    NSString*imageStr=data[@"show_url"];
                    [saveFooterImageAddress addObject:imageStr];
                    
                    if (saveFooterImageAddress.count==ImageArray.count) {
                        successBlock(saveFooterImageAddress);
                    }
                    
                    
                    
                }else{
                    [JRToast showWithText:data[@"message"]];
                }
                
            }];
            
        }
        
        
        
    }
}



//上传一张照片
-(void)HttpPostOneImageToJiekouWith:(NSData*)data{
    NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            self.portraitAddress=data[@"show_url"];
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
    }];
    
    
    
    
}

//@"匹配车型"  在吊用新增潜客之后     修改他的产品  isStatus   add  delete  edit  编辑的时候留意
-(void)httpPostLikeProductWith:(NSString*)customID complete:(void(^)(id data))successBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_addLikeProduct];
    
    NSMutableArray*listArray=[NSMutableArray array];
    for (CodeShoppingModel*model in self.saveAllShoppingInfo) {
        NSMutableDictionary*dict=[NSMutableDictionary new];
        NSString*randomStr;
        
        
        if ((model.C_ID&&![model.C_ID isEqualToString:@""])&&([model.isStatus isEqualToString:@"edit"]||[model.isStatus isEqualToString:@"delete"])) {
            //编辑 或者  删除
            randomStr=model.C_ID;
            
            [dict setObject:randomStr forKey:@"C_ID"];
            [dict setObject:model.I_NUMBER forKey:@"I_NUMBER"];
            [dict setObject:model.B_PRICE forKey:@"B_MONEY"];   //编辑有  新增没有
            
        }else{
            //新增
            double randInt=arc4random();
            randomStr=[NSString stringWithFormat:@"A47100_%f",randInt];
            
            [dict setObject:randomStr forKey:@"C_ID"];
            [dict setObject:@"1" forKey:@"I_NUMBER"];
            
        }
        
        
        
        [dict setObject:model.C_PRODUCTCODE forKey:@"C_PRODUCTCODE"];
        [dict setObject:model.C_A41900_C_ID forKey:@"C_A41900_C_ID"];
        [dict setObject:model.C_A41900_C_NAME forKey:@"C_A41900_C_NAME"];
        [dict setObject:model.B_PRICE forKey:@"B_PRICE"];
        [dict setObject:@"1" forKey:@"I_NUMBER"];
        [dict setObject:model.isStatus forKey:@"doAction"];
        [listArray addObject:dict];
    }
    
    if (listArray.count<1) {
        successBlock(nil);
    }else{
        
        
        
        NSDictionary*dict=@{@"TYPE":@"1",@"C_A41500_C_ID":customID,@"a47100Forms":listArray};
        
        [mainDict setObject:dict forKey:@"content"];
        NSString*paramsStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
        HttpManager*manager=[[HttpManager alloc]init];
        [manager postDataFromNetworkWithUrl:paramsStr parameters:nil compliation:^(id data, NSError *error) {
            MyLog(@"%@",data);
            if ([data[@"code"] integerValue]==200) {
                
                successBlock(data);
                //没了
                //            {
                //                code = 200;
                //                message = "\U64cd\U4f5c\U6210\U529f";
                //            }
                
                
            }else{
                [JRToast showWithText:data[@"message"]];
            }
            
            
        }];
        
    }
}



-(void)getLocalDatas{
    //    PotentailCustomerEditModel
    //头像图片和 footer的图片  这两个另算
    
    
    NSMutableArray*localArr0=[NSMutableArray arrayWithObjects:@"基本信息",@"联系电话",@"客户微信",@"是否添加微信",@"购车类型",@"意向车型",@"客户等级",@"来源渠道",@"渠道细分",@"介绍人",@"预算",@"购车阶段", nil] ;
    NSMutableArray *localValueArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    NSMutableArray *localPostNameArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"", nil];
    NSMutableArray *localKeyArr0=[NSMutableArray arrayWithObjects:@"C_NAME",@"C_PHONE",@"C_WECHAT",@"I_SORTIDX",@"C_BUYTYPE_DD_ID",@"C_A49600_C_ID",@"C_LEVEL_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"C_A47700_C_ID",@"C_YS_DD_ID",@"C_PAYMENT_DD_ID", nil];
    
    if (self.Type == customerTypeEdit) {
//        if (self.mainModel.C_YX_A49600_C_ID.length > 0 || self.mainModel.C_YX_CAR_REMARK.length > 0) {
//            localArr0=[NSMutableArray arrayWithObjects:@"基本信息",@"联系电话",@"购车类型",@"意向车型",@"客户等级",@"来源渠道",@"渠道细分", nil];
//            localPostNameArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
//            localKeyArr0=[NSMutableArray arrayWithObjects:@"C_NAME",@"C_PHONE",@"C_BUYTYPE_DD_ID",@"C_YX_A49600_C_ID",@"C_LEVEL_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID", nil];
//        } else
        if (self.mainModel.C_A71000_C_ID.length > 0) {
            localArr0=[NSMutableArray arrayWithObjects:@"基本信息",@"联系电话",@"客户微信",@"是否添加微信",@"购车类型",@"匹配车型",@"客户等级",@"来源渠道",@"渠道细分",@"介绍人",@"预算",@"购车阶段", nil] ;
            localValueArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            localPostNameArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"0",@"",@"",@"",@"",@"",@"",@"",@"", nil];
            localKeyArr0=[NSMutableArray arrayWithObjects:@"C_NAME",@"C_PHONE",@"C_WECHAT",@"I_SORTIDX",@"C_BUYTYPE_DD_ID",@"C_A71000_C_ID",@"C_LEVEL_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"C_A47700_C_ID",@"C_YS_DD_ID",@"C_PAYMENT_DD_ID", nil];
        }
        
//        if ((self.mainModel.C_YX_A49600_C_ID.length > 0 || self.mainModel.C_YX_CAR_REMARK.length > 0) && (self.mainModel.C_A49600_C_ID.length > 0 || self.mainModel.C_CAR_REMARK.length > 0)) {
//            localArr0=[NSMutableArray arrayWithObjects:@"基本信息",@"购车类型",@"意向车型",@"匹配车型",@"客户地址",@"联系电话"/*,@"联系电话2"*/,@"客户微信",@"客户等级",@"客户性别",@"来源渠道",@"渠道细分",@"介绍人",@"业务", nil] ;
//            localValueArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", @"",@"", nil];
//            localPostNameArr0=[NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"", @"", nil];
//            localKeyArr0=[NSMutableArray arrayWithObjects:@"C_NAME",@"C_BUYTYPE_DD_ID",@"C_YX_CAR_REMARK",@"C_CAR_REMARK",@"C_ADDRESS",@"C_PHONE"/*,@"C_SPAREPHONE"*/,@"C_WECHAT",@"C_LEVEL_DD_ID",@"C_SEX_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID",@"C_A47700_C_ID",@"C_CLUEPROVIDER_ROLEID", nil];
//        }
        
    }
    
    
    
    NSArray*localArr1=@[@"性别",@"省市",@"车牌",@"保有车辆",@"客户地址",@"行业",@"公司",@"职务",@"年收入",@"文化程度",@"婚姻状况",@"生日",@"爱好",@"客户备注"];
    NSArray*localValueArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localPostNameArr1=@[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    NSArray*localKeyArr1=@[@"C_SEX_DD_ID",@"C_PROVINCE,C_CITY",@"C_LICENSE_PLATE",@"C_EXISTING",@"C_ADDRESS",@"C_INDUSTRY_DD_ID",@"C_COMPANY",@"C_OCCUPATION_DD_NAME",@"C_SALARY_DD_ID",@"C_EDUCATION_DD_ID",@"C_MARITALSTATUS_DD_ID",@"C_BIRTHDAY_TIME",@"C_HOBBY_DD_ID",@"X_REMARK"];
    
    NSMutableArray*saveLocalArr0=[NSMutableArray array];
    NSMutableArray*saveLocalArr1=[NSMutableArray array];
    for (int i=0; i<localArr0.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr0[i];
        model.nameValue=localValueArr0[i];
        model.postValue=localPostNameArr0[i];
        model.keyValue=localKeyArr0[i];
        
        [saveLocalArr0 addObject:model];
    }
    
    for (int i=0; i<localArr1.count; i++) {
        PotentailCustomerEditModel*model=[[PotentailCustomerEditModel alloc]init];
        model.locatedTitle=localArr1[i];
        model.nameValue=localValueArr1[i];
        model.postValue=localPostNameArr1[i];
        model.keyValue=localKeyArr1[i];
        
        [saveLocalArr1 addObject:model];
    }
    
    
    
    
    self.localDatas=[NSMutableArray arrayWithObjects:saveLocalArr0,saveLocalArr1, nil];
    
    
    if (self.Type==customerTypeAdd) {
        //姓名
        PotentailCustomerEditModel*modelName=saveLocalArr0[0];
        modelName.nameValue=self.pubNameStr?self.pubNameStr:@"";
        modelName.postValue=self.pubNameStr?self.pubNameStr:@"";
        //@"匹配车型"
        PotentailCustomerEditModel*modelProduct=saveLocalArr0[5];
        modelProduct.nameValue=self.C_A40600_NAME?self.C_A40600_NAME:@"";
        modelProduct.postValue=self.C_A40600_NAME?self.C_A40600_NAME:@"";
        //地址
        PotentailCustomerEditModel*modelAddress=saveLocalArr1[5];
        modelAddress.nameValue=self.pubAddress?self.pubAddress:@"";
        modelAddress.postValue=self.pubAddress?self.pubAddress:@"";
        //电话
        PotentailCustomerEditModel*modelTel=saveLocalArr0[1];
        modelTel.nameValue=self.pubTelStr?self.pubTelStr:@"";
        modelTel.postValue=self.pubTelStr?self.pubTelStr:@"";
        
        PotentailCustomerEditModel*modelWeChat=saveLocalArr1[2];
        modelWeChat.nameValue=self.pubWECHAT?self.pubWECHAT:@"";
        modelWeChat.postValue=self.pubWECHAT?self.pubWECHAT:@"";
        //客户来源   渠道来源
        PotentailCustomerEditModel*SourceModel=saveLocalArr0[7];
        if (self.pubSourceStr&&self.pubSourceIDStr) {
            SourceModel.nameValue=self.pubSourceStr;
            SourceModel.postValue=self.pubSourceIDStr;
        }
        
        
        
        //市场活动
        PotentailCustomerEditModel*MarketActionModel=saveLocalArr0[8];
        if (self.pubMarketStr&&self.pubMarketID) {
            MarketActionModel.nameValue=self.pubMarketStr;
            MarketActionModel.postValue=self.pubMarketID;
        }
        
        //性别
        PotentailCustomerEditModel*sexModel=saveLocalArr1[0];
        if (self.pubSexStr&&self.pubSetID) {
            sexModel.nameValue=self.pubSexStr;
            sexModel.postValue=self.pubSetID;
        }
        
        //介绍人
        PotentailCustomerEditModel*jieshorenModel=saveLocalArr0[9];
        if (self.pubJieshorenStr&&self.pubJieshorenID) {
            jieshorenModel.nameValue=self.pubJieshorenStr;
            jieshorenModel.postValue=self.pubJieshorenID;
        }
        // 线索提供人
//        PotentailCustomerEditModel*clueRemarkModel = saveLocalArr0[10];
//        clueRemarkModel.nameValue=self.cluePeople.length > 0?self.cluePeople:[NewUserSession instance].configData.C_NAME;
//        clueRemarkModel.postValue=self.cluePeopleID.length > 0?self.cluePeopleID:[NewUserSession instance].configData.user_id;
        //备注
        PotentailCustomerEditModel*MarketRemarkModel=saveLocalArr1[13];
        if (_pubRemarketStr&&![_pubRemarketStr isEqualToString:@""]) {
            MarketRemarkModel.nameValue=self.pubRemarketStr;
            MarketRemarkModel.postValue=self.pubRemarketStr;
        }
        
    }
    
    
    
    
    
    if (self.Type==customerTypeCallTo) {
        //电话
        PotentailCustomerEditModel*model=saveLocalArr0[1];
        model.nameValue=self.phoneNumber?self.phoneNumber:@"";
        model.postValue=self.phoneNumber?self.phoneNumber:@"";
        
        
        //客户来源
        NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
        for (MJKDataDicModel*modelll in dataArray) {
            
            if ([modelll.C_NAME isEqualToString:@"来电"]) {
                PotentailCustomerEditModel*SourceModel=saveLocalArr0[6];
                SourceModel.nameValue=modelll.C_NAME;
                SourceModel.postValue=modelll.C_VOUCHERID;
                
            }
            
            
        }
        
        
        //市场活动
        PotentailCustomerEditModel*MarketActionModel=saveLocalArr0[7];
        if (self.marketActionID&&self.marketAction) {
            MarketActionModel.nameValue=self.marketAction;
            MarketActionModel.postValue=self.marketActionID;
        }
        
        //备注
        PotentailCustomerEditModel*MarketRemarkModel=saveLocalArr1[13];
        if (_phoneRemark&&![_phoneRemark isEqualToString:@""]) {
            MarketRemarkModel.nameValue=self.phoneRemark;
            MarketRemarkModel.postValue=self.phoneRemark;
        }
        
        
    }
    
    
    
    
    
    if (self.Type==customerTypeExhibition) {
        
        //来源渠道
        PotentailCustomerEditModel*SourceActionModel=saveLocalArr0[6];
        if (self.exhibitionSourceActionID&&self.exhibitionSourceAction) {
            SourceActionModel.nameValue=self.exhibitionSourceAction;
            SourceActionModel.postValue=self.exhibitionSourceActionID;
        } else {
            //客户来源
            NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"];
            for (MJKDataDicModel*modelll in dataArray) {
                if ([modelll.C_NAME isEqualToString:@"到店"]) {
                    PotentailCustomerEditModel*SourceModel=saveLocalArr0[6];
                    SourceModel.nameValue=modelll.C_NAME;
                    SourceModel.postValue=modelll.C_VOUCHERID;
                    
                }
            }
        }
        //市场活动
        PotentailCustomerEditModel*MarketActionModel=saveLocalArr0[7];
        if (self.exhibitionMarketActionID&&self.exhibitionMarketAction) {
            MarketActionModel.nameValue=self.exhibitionMarketAction;
            MarketActionModel.postValue=self.exhibitionMarketActionID;
        }
        
//        PotentailCustomerEditModel*clueRemarkModel=saveLocalArr1[1];
//        clueRemarkModel.nameValue=self.cluePeople?self.cluePeople:[NewUserSession instance].configData.C_NAME;
//        clueRemarkModel.postValue=self.cluePeopleID?self.cluePeopleID:[NewUserSession instance].configData.user_id;
        //备注
        PotentailCustomerEditModel*MarketRemarkModel=saveLocalArr1[13];
        if (_exhibitionRemark&&![_exhibitionRemark isEqualToString:@""]) {
            MarketRemarkModel.nameValue=self.exhibitionRemark;
            MarketRemarkModel.postValue=self.exhibitionRemark;
        }
        
    }
    
    
    
}



-(void)getPostValueAndBeforeValue{
    //    self.localDatas    self.mainModel
    //section  0
    if (self.mainModel.C_A48200_C_ID.length > 0) {
        self.addressStr = self.mainModel.C_A48200_C_NAME;
        self.C_A48200_C_ID = self.mainModel.C_A48200_C_ID;
    }
    
    if (self.mainModel.C_A70600_C_ID.length > 0) {
//        self.C_A49600_C_ID = self.mainModel.C_A49600_C_ID;
        self.C_A70600_C_ID = self.mainModel.C_A70600_C_ID;
    }
    
    NSArray*section0ShowNameArray =@[self.mainModel.C_NAME.length > 0 ? self
                                     .mainModel.C_NAME : @"",
                                     self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
                                     self.mainModel.C_WECHAT.length > 0 ? self
                                     .mainModel.C_WECHAT : @"",
                                     self.mainModel.I_SORTIDX_NAME.length > 0 ? self
                                     .mainModel.I_SORTIDX_NAME : @"",
                                     self.mainModel.C_BUYTYPE_DD_NAME.length > 0 ? self.mainModel.C_BUYTYPE_DD_NAME : @"",
                                     self.mainModel.C_A49600_C_NAME.length > 0 ? self.mainModel.C_A49600_C_NAME : @"",
                                     self.mainModel.C_LEVEL_DD_NAME.length > 0 ? self
                                     .mainModel.C_LEVEL_DD_NAME : @"",
                                     self.mainModel.C_CLUESOURCE_DD_NAME.length > 0 ? self
                                     .mainModel.C_CLUESOURCE_DD_NAME : @"",
                                     self.mainModel.C_A41200_C_NAME.length > 0 ? self.mainModel.C_A41200_C_NAME : @"",
                                     self.mainModel.C_A47700_C_NAME.length > 0 ? self.mainModel.C_A47700_C_NAME : @"",
                                     self.mainModel.C_YS_DD_NAME.length > 0 ? self.mainModel.C_YS_DD_NAME : @"",
                                     self.mainModel.C_PAYMENT_DD_NAME.length > 0 ? self.mainModel.C_PAYMENT_DD_NAME : @""];
    
    NSArray*section0PostNameArray =@[self.mainModel.C_NAME.length > 0 ? self
                                     .mainModel.C_NAME : @"",
                                     self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
                                     self.mainModel.C_WECHAT.length > 0 ? self
                                     .mainModel.C_WECHAT : @"",
                                     self.mainModel.I_SORTIDX.length > 0 ? self
                                     .mainModel.I_SORTIDX : @"",
                                     self.mainModel.C_BUYTYPE_DD_ID.length > 0 ? self.mainModel.C_BUYTYPE_DD_ID : @"",
                                     self.mainModel.C_A49600_C_ID.length > 0 ? self.mainModel.C_A49600_C_ID : @"",
                                     self.mainModel.C_LEVEL_DD_ID.length > 0 ? self.mainModel.C_LEVEL_DD_ID : @"",
                                     self.mainModel.C_CLUESOURCE_DD_ID.length > 0 ? self
                                     .mainModel.C_CLUESOURCE_DD_ID : @"",
                                     self.mainModel.C_A41200_C_ID.length > 0 ? self.mainModel.C_A41200_C_ID : @"",
                                     self.mainModel.C_A47700_C_ID.length > 0 ? self.mainModel.C_A47700_C_ID : @"",
                                     self.mainModel.C_YS_DD_ID.length > 0 ? self.mainModel.C_YS_DD_ID : @"",
                                     self.mainModel.C_PAYMENT_DD_ID.length > 0 ? self.mainModel.C_PAYMENT_DD_ID : @""];
    if (self.mainModel.C_A71000_C_ID.length > 0) {
        section0ShowNameArray =@[self.mainModel.C_NAME.length > 0 ? self
                                         .mainModel.C_NAME : @"",
                                         self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
                                         self.mainModel.C_WECHAT.length > 0 ? self
                                         .mainModel.C_WECHAT : @"",
                                 self.mainModel.I_SORTIDX_NAME.length > 0 ? self
                                 .mainModel.I_SORTIDX_NAME : @"",
                                         self.mainModel.C_BUYTYPE_DD_NAME.length > 0 ? self.mainModel.C_BUYTYPE_DD_NAME : @"",
                                         self.mainModel.C_A71000_C_NAME.length > 0 ? self.mainModel.C_A71000_C_NAME : @"",
                                         self.mainModel.C_LEVEL_DD_NAME.length > 0 ? self
                                         .mainModel.C_LEVEL_DD_NAME : @"",
                                         self.mainModel.C_CLUESOURCE_DD_NAME.length > 0 ? self
                                         .mainModel.C_CLUESOURCE_DD_NAME : @"",
                                         self.mainModel.C_A41200_C_NAME.length > 0 ? self.mainModel.C_A41200_C_NAME : @"",
                                 self.mainModel.C_A47700_C_NAME.length > 0 ? self.mainModel.C_A47700_C_NAME : @"",
                                 self.mainModel.C_YS_DD_NAME.length > 0 ? self.mainModel.C_YS_DD_NAME : @"",
                                 self.mainModel.C_PAYMENT_DD_NAME.length > 0 ? self.mainModel.C_PAYMENT_DD_NAME : @""];
        
        section0PostNameArray =@[self.mainModel.C_NAME.length > 0 ? self
                                         .mainModel.C_NAME : @"",
                                         self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
                                         self.mainModel.C_WECHAT.length > 0 ? self
                                         .mainModel.C_WECHAT : @"",
                                 self.mainModel.I_SORTIDX.length > 0 ? self
                                 .mainModel.I_SORTIDX : @"",
                                         self.mainModel.C_BUYTYPE_DD_ID.length > 0 ? self.mainModel.C_BUYTYPE_DD_ID : @"",
                                         self.mainModel.C_A71000_C_ID.length > 0 ? self.mainModel.C_A71000_C_ID : @"",
                                         self.mainModel.C_LEVEL_DD_ID.length > 0 ? self.mainModel.C_LEVEL_DD_ID : @"",
                                         self.mainModel.C_CLUESOURCE_DD_ID.length > 0 ? self
                                         .mainModel.C_CLUESOURCE_DD_ID : @"",
                                         self.mainModel.C_A41200_C_ID.length > 0 ? self.mainModel.C_A41200_C_ID : @"",
                                 self.mainModel.C_A47700_C_ID.length > 0 ? self.mainModel.C_A47700_C_ID : @"",
                                 self.mainModel.C_YS_DD_ID.length > 0 ? self.mainModel.C_YS_DD_ID : @"",
                                 self.mainModel.C_PAYMENT_DD_ID.length > 0 ? self.mainModel.C_PAYMENT_DD_ID : @""];
    }
    //NSMutableArray *localKeyArr0=[NSMutableArray arrayWithObjects:@"C_NAME",@"C_PHONE",@"C_BUYTYPE_DD_ID",@"C_YX_CAR_REMARK",@"C_LEVEL_DD_ID",@"C_CLUESOURCE_DD_ID",@"C_A41200_C_ID", nil];
//    if (self.mainModel.C_YX_A49600_C_ID.length > 0) {
//        section0ShowNameArray=@[self.mainModel.C_NAME.length > 0 ? self
//                                .mainModel.C_NAME : @"",
//                                self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
//                                self.mainModel.C_BUYTYPE_DD_NAME.length > 0 ? self.mainModel.C_BUYTYPE_DD_NAME : @"",
//                                self.mainModel.C_YX_A49600_C_NAME.length > 0 ? self.mainModel.C_YX_A49600_C_NAME : @"",
//                                self.mainModel.C_LEVEL_DD_NAME.length > 0 ? self
//                                .mainModel.C_LEVEL_DD_NAME : @"",
//                                self.mainModel.C_CLUESOURCE_DD_NAME.length > 0 ? self
//                                .mainModel.C_CLUESOURCE_DD_NAME : @"",
//                                self.mainModel.C_A41200_C_NAME.length > 0 ? self.mainModel.C_A41200_C_NAME : @""];
//
//        section0PostNameArray=@[self.mainModel.C_NAME.length > 0 ? self
//                                .mainModel.C_NAME : @"",
//                                self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
//                                self.mainModel.C_BUYTYPE_DD_ID.length > 0 ? self.mainModel.C_BUYTYPE_DD_ID : @"",
//                                self.mainModel.C_YX_A49600_C_ID.length > 0 ? self.mainModel.C_YX_A49600_C_ID : @"",
//                                self.mainModel.C_LEVEL_DD_ID.length > 0 ? self.mainModel.C_LEVEL_DD_ID : @"",
//                                self.mainModel.C_CLUESOURCE_DD_ID.length > 0 ? self
//                                .mainModel.C_CLUESOURCE_DD_ID : @"",
//                                self.mainModel.C_A41200_C_ID.length > 0 ? self.mainModel.C_A41200_C_ID : @""];
//    }
//    if (self.mainModel.C_A49600_C_ID.length > 0) {
//        section0ShowNameArray=@[self.mainModel.C_NAME.length > 0 ? self
//                                .mainModel.C_NAME : @"",
//                                self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
//                                self.mainModel.C_BUYTYPE_DD_NAME.length > 0 ? self.mainModel.C_BUYTYPE_DD_NAME : @"",
//                                self.mainModel.C_A49600_C_NAME.length > 0 ? self.mainModel.C_A49600_C_NAME : @"",
//                                self.mainModel.C_LEVEL_DD_NAME.length > 0 ? self
//                                .mainModel.C_LEVEL_DD_NAME : @""/*,self.mainModel.C_SPAREPHONE.length > 0? self.mainModel.C_SPAREPHONE : @""*/,
//                                self.mainModel.C_CLUESOURCE_DD_NAME.length > 0 ? self
//                                .mainModel.C_CLUESOURCE_DD_NAME : @"",
//                                self.mainModel.C_A41200_C_NAME.length > 0 ? self.mainModel.C_A41200_C_NAME : @""];
//        section0PostNameArray=@[self.mainModel.C_NAME.length > 0 ? self
//                                .mainModel.C_NAME : @"",
//                                self.mainModel.C_PHONE.length > 0 ? self.mainModel.C_PHONE : @"",
//                                self.mainModel.C_BUYTYPE_DD_ID.length > 0 ? self.mainModel.C_BUYTYPE_DD_ID : @"",
//                                self.mainModel.C_A49600_C_ID.length > 0 ? self.mainModel.C_A49600_C_ID : @"",
//                                self.mainModel.C_LEVEL_DD_ID.length > 0 ? self.mainModel.C_LEVEL_DD_ID : @"",
//                                self.mainModel.C_CLUESOURCE_DD_ID.length > 0 ? self
//                                .mainModel.C_CLUESOURCE_DD_ID : @"",
//                                self.mainModel.C_A41200_C_ID.length > 0 ? self.mainModel.C_A41200_C_ID : @""];
//    }
    
    
    NSMutableArray*MainArray0=self.localDatas[0];
    for (int i=0; i<MainArray0.count; i++) {
        PotentailCustomerEditModel*model=MainArray0[i];
        model.nameValue=section0ShowNameArray[i];
        model.postValue=section0PostNameArray[i];
    }
    
//    if (self.mainModel.C_YX_A49600_C_ID.length > 0) {
//        self.yx_productArray = [NSMutableArray array];
//        MJKProductShowModel *showModel = [[MJKProductShowModel alloc]init];
//        showModel.C_ID = self.mainModel.C_YX_A49600_C_ID;
//        showModel.X_FMPICURL = self.mainModel.C_YX_A49600_C_PICTURE;
//        showModel.C_NAME = self.mainModel.C_YX_A49600_C_NAME;
//        showModel.C_TYPE_DD_ID = self.mainModel.C_YX_A70600_C_ID;
//        showModel.C_TYPE_DD_NAME = self.mainModel.C_YX_A70600_C_NAME;
//        [self.yx_productArray addObject:showModel];
//    }
//
//    if (self.mainModel.C_A49600_C_ID.length > 0) {
//        self.productArray = [NSMutableArray array];
//        MJKProductShowModel *showModel = [[MJKProductShowModel alloc]init];
//        showModel.C_ID = self.mainModel.C_A49600_C_ID;
//        showModel.X_FMPICURL = self.mainModel.C_A49600_C_PICTURE;
//        showModel.C_NAME = self.mainModel.C_A49600_C_NAME;
//        showModel.C_TYPE_DD_ID = self.mainModel.C_A70600_C_ID;
//        showModel.C_TYPE_DD_NAME = self.mainModel.C_A70600_C_NAME;
//        [self.productArray addObject:showModel];
//    }
    
    //section   1
    NSString*provinceAndCity;
    if ((self.mainModel.C_PROVINCE&&![self.mainModel.C_PROVINCE isEqualToString:@""])&&(self.mainModel.C_CITY&&![self.mainModel.C_CITY isEqualToString:@""])) {
        provinceAndCity=[NSString stringWithFormat:@"%@,%@",self.mainModel.C_PROVINCE,self.mainModel.C_CITY];
    }else{
        provinceAndCity=@"";
    } //@[@"C_COMPANY",@"C_OCCUPATION_DD_NAME",@"C_SALARY_DD_ID",@"C_EDUCATION_DD_ID",@"C_INDUSTRY_DD_ID",@"C_VIN",@"C_MARITALSTATUS_DD_ID",@"C_PROVINCE,C_CITY",@"C_BIRTHDAY_TIME",@"C_HOBBY_DD_ID",@"X_REMARK"]
    NSArray*section1ShowNameArray=@[self.mainModel.C_SEX_DD_NAME.length > 0 ? self
                                    .mainModel.C_SEX_DD_NAME : @"",
                                    provinceAndCity.length > 0 ? provinceAndCity
                                    : @"",
                                    self.mainModel.C_LICENSE_PLATE.length > 0 ? self
                                    .mainModel.C_LICENSE_PLATE : @"",
                                    self.mainModel.C_EXISTING.length > 0 ? self.mainModel.C_EXISTING : @"",
                                    self.mainModel.C_ADDRESS.length > 0 ? self
                                    .mainModel.C_ADDRESS : @"",
                                    self.mainModel.C_INDUSTRY_DD_NAME.length > 0 ? self
                                    .mainModel.C_INDUSTRY_DD_NAME : @"",
                                    self.mainModel.C_COMPANY.length > 0 ? self
                                    .mainModel.C_COMPANY : @"",
                                    self.mainModel.C_OCCUPATION_DD_NAME.length > 0 ? self
                                    .mainModel.C_OCCUPATION_DD_NAME
                                    : @"",self.mainModel.C_SALARY_DD_NAME.length > 0 ? self
                                    .mainModel.C_SALARY_DD_NAME : @"",
                                    self.mainModel.C_EDUCATION_DD_NAME.length > 0 ? self
                                    .mainModel.C_EDUCATION_DD_NAME : @"",
                                    self.mainModel.C_MARITALSTATUS_DD_NAME.length > 0 ? self
                                    .mainModel.C_MARITALSTATUS_DD_NAME : @"",
                                    self.mainModel.C_BIRTHDAY_TIME.length > 0 ? self
                                    .mainModel.C_BIRTHDAY_TIME : @"",
                                    self.mainModel.C_HOBBY_DD_NAME.length > 0 ? self
                                    .mainModel.C_HOBBY_DD_NAME : @"",
                                    self.mainModel.X_REMARK.length > 0 ? self
                                    .mainModel.X_REMARK : @"",
                                    self.mainModel.C_A47700_C_NAME.length > 0 ? self
                                    .mainModel.C_A47700_C_NAME : @"",
//                                    
                                    ];
    NSArray*section1PostNameArray=@[self.mainModel.C_SEX_DD_ID.length > 0 ? self
                                    .mainModel.C_SEX_DD_ID : @"",
                                    provinceAndCity.length > 0 ? provinceAndCity
                                    : @"",
                                    self.mainModel.C_LICENSE_PLATE.length > 0 ? self
                                    .mainModel.C_LICENSE_PLATE : @"",
                                    self.mainModel.C_EXISTING.length > 0 ? self.mainModel.C_EXISTING : @"",
                                    self.mainModel.C_ADDRESS.length > 0 ? self
                                    .mainModel.C_ADDRESS : @"",
                                    self.mainModel.C_INDUSTRY_DD_ID.length > 0 ? self
                                    .mainModel.C_INDUSTRY_DD_ID : @"",
                                    self.mainModel.C_COMPANY.length > 0 ? self
                                    .mainModel.C_COMPANY : @"",
                                    self.mainModel.C_OCCUPATION_DD_NAME.length > 0 ? self
                                    .mainModel.C_OCCUPATION_DD_NAME
                                    : @"",self.mainModel.C_SALARY_DD_ID.length > 0 ? self
                                    .mainModel.C_SALARY_DD_ID : @"",
                                    self.mainModel.C_EDUCATION_DD_ID.length > 0 ? self
                                    .mainModel.C_EDUCATION_DD_ID : @"",
                                    self.mainModel.C_MARITALSTATUS_DD_ID.length > 0 ? self
                                    .mainModel.C_MARITALSTATUS_DD_ID : @"",
                                    self.mainModel.C_BIRTHDAY_TIME.length > 0 ? self
                                    .mainModel.C_BIRTHDAY_TIME : @"",
                                    self.mainModel.C_HOBBY_DD_ID.length > 0 ? self
                                    .mainModel.C_HOBBY_DD_ID : @"",
                                    self.mainModel.X_REMARK.length > 0 ? self
                                    .mainModel.X_REMARK : @"",
                                    self.mainModel.C_A47700_C_ID.length > 0 ? self
                                    .mainModel.C_A47700_C_ID : @"",
                                    //
                                    ];
    NSMutableArray*MainArray1=self.localDatas[1];
    for (int i=0; i<MainArray1.count; i++) {
        PotentailCustomerEditModel*model=MainArray1[i];
        model.nameValue=section1ShowNameArray[i];
        model.postValue=section1PostNameArray[i];
    }
    
    
    //头像
    self.portraitAddress=self.mainModel.C_HEADIMGURL_SHOW;
    //初始的底部图片
    if (self.mainModel.fileList.count > 0) {
        [self.saveFooterUrlArray addObjectsFromArray:self.mainModel.fileList];
    }
    
    
    
    
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark  --set
//- (UIButton *)findCopyButton {
//    if (!_findCopyButton) {
//        _findCopyButton.tag = 110;
//        _findCopyButton=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-70, 7, 60, 30)];
//        _findCopyButton.backgroundColor=KNaviColor;
//        [_findCopyButton setTitleNormal:@"查重"];
//        _findCopyButton.titleLabel.font=[UIFont systemFontOfSize:12.f];
//        [_findCopyButton setTitleColor:[UIColor blackColor]];
//        [_findCopyButton addTarget:self action:@selector(clickFindCopy:)];
//        _findCopyButton.layer.cornerRadius = 3.f;
//        _findCopyButton.layer.masksToBounds = YES;
//    }
//    return _findCopyButton;
//}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight-NavStatusHeight-60 - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    
    return _tableView;
}


-(NSMutableDictionary *)saveFooterImageDataDic{
    if (!_saveFooterImageDataDic) {
        _saveFooterImageDataDic=[NSMutableDictionary dictionary];
    }
    return _saveFooterImageDataDic;
}





-(showLikeProductView *)showProductView{
    DBSelf(weakSelf);
    if (!_showProductView) {
        _showProductView=[[showLikeProductView alloc]initWithFrame:self.view.frame];
        _showProductView.completeBlock = ^(NSMutableArray *array) {
            NSMutableArray*newArray=[NSMutableArray array];
            
            for (int i=0; i<array.count; i++) {
                
                CodeShoppingModel*model=array[i];
                if (![model.isStatus isEqualToString:@"delete"]) {
                    NSString*str=[NSString stringWithFormat:@"%@,%@,%@",model.C_PRODUCTCODE,model.C_A41900_C_NAME,model.B_PRICE];
                    [newArray addObject:str];
                }
                
            }
            
            NSString*newStr=[newArray componentsJoinedByString:@",\n"];
            
            AddCustomerProductTableViewCell*cell=[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
            cell.textViewStr=newStr;
            
            
            
        };
        
        
        
        _showProductView.continueSanfBlock = ^{
            
            //            [weakSelf clickSure];
            [weakSelf clickAlert];
        };
        
        
        
        [self.view addSubview:_showProductView];
        _showProductView.hidden=YES;
    }
    
    return _showProductView;
}


-(NSMutableArray *)saveAllShoppingInfo{
    if (!_saveAllShoppingInfo) {
        _saveAllShoppingInfo=[NSMutableArray array];
    }
    
    return _saveAllShoppingInfo;
}


-(NSMutableArray *)saveFooterUrlArray{
    if (!_saveFooterUrlArray) {
        _saveFooterUrlArray=[NSMutableArray array];
    }
    return _saveFooterUrlArray;
}


#pragma mark  --funcation
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
}

-(void)keyBoardWillHidden:(NSNotification*)notif{
    
    
}
//开始编辑时 视图上移 如果输入框不被键盘遮挡则不上移。

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.25 animations:^{
        
        CGRect frame = self.tableView.frame;
        
        frame.origin.y = NavStatusHeight;
        
        self.tableView.frame = frame;
        
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect=[textField convertRect:textField.bounds toView:self.view];
    
    CGFloat aa = KScreenHeight - (rect.origin.y + rect.size.height + 216 +50+30+50);
    //    +self.view.frame.origin.y
    CGFloat rects=aa;
    
    NSLog(@"aa%f",rects);
    
    if (rects <= 0) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGRect frame = self.tableView.frame;
            //frame.origin.y+
            frame.origin.y = rects;
            
            self.tableView.frame = frame;
            
        }];
        
    }
    
    return YES;
    
}



-(NSString*)judgeCanSave{
    _canSave=YES;
    
    for (NSArray *arr in self.localDatas) {
        for (int i = 0; i < arr.count; i++) {
            PotentailCustomerEditModel *model = arr[i];
            if (model.postValue.length <=0) {
                if ([model.locatedTitle isEqualToString:@"基本信息"])  {
                    _canSave = NO;
                    return @"客户姓名不能为空";
                }
                if ([model.locatedTitle isEqualToString:@"联系电话"]) {
                    PotentailCustomerEditModel *wmodel = arr[i + 1];
                    if (wmodel.postValue.length <= 0) {
                        _canSave = NO;
                        return @"手机和微信号必填一项";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"客户微信"]) {
                    PotentailCustomerEditModel *pmodel = arr[i - 1];
                    if (pmodel.postValue.length <= 0) {
                        _canSave = NO;
                        return @"手机和微信号必填一项";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"意向车型"]) {
                    if ([self.btArray containsObject:@"a415_C_A70600_C_ID"]) {
                        _canSave = NO;
                        return @"请选择意向车型";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"匹配车型"]) {
                    if ([self.btArray containsObject:@"a415_C_A70600_C_ID"]) {
                        _canSave = NO;
                        return @"请选择匹配车型";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"客户等级"]) {
                    if ([self.btArray containsObject:@"a415_C_LEVEL_DD_ID"]) {
                        _canSave = NO;
                        return @"请选择客户等级";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"来源渠道"]) {
                    if ([self.btArray containsObject:@"a415_C_CLUESOURCE_DD_ID"]) {
                        _canSave = NO;
                        return @"请选择来源渠道";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"渠道细分"]) {
                    if ([self.btArray containsObject:@"a415_C_CLUESOURCE_DD_ID"]) {
                        _canSave = NO;
                        return @"请选择渠道细分";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"预算"]) {
                    if ([self.btArray containsObject:@"a415_C_YS_DD_ID"]) {
                        _canSave = NO;
                        return @"请选择预算";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"购车阶段"]) {
                    if ([self.btArray containsObject:@"a415_C_PAYMENT_DD_ID"]) {
                        _canSave = NO;
                        return @"请选择购车阶段";
                    }
                }
                if ([model.locatedTitle isEqualToString:@"省市"]) {
                    if ([self.btArray containsObject:@"a415_C_PROVINCE"]) {
                        _canSave = NO;
                        return @"请选择省市";
                    }
                }
            }
        
        }
    }
    
    return @"";
}





#pragma mark -- 扫码的功能
- (void)clickAlert {
    DBSelf(weakSelf);
    
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*sanfdal=[UIAlertAction actionWithTitle:@"扫码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [weakSelf clickScanf];
    }];
    UIAlertAction*manual=[UIAlertAction actionWithTitle:@"手动输入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf clickManual];
    }];
    [alertVC addAction:sanfdal];
    [alertVC addAction:manual];
    [alertVC addAction:cancel];
    [self presentViewController:alertVC animated:YES completion:nil];
}

-(void)clickSure:(PotentailCustomerEditModel *)model{
        DBSelf(weakSelf);
    NSMutableArray*localArr=self.localDatas[0];
        if ([model.locatedTitle isEqualToString:@"意向车型"]) {
            MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
            vc.rootVC = self;
            //    if (self.productArray.count > 0) {
            //        vc.productArray = [self.productArray mutableCopy];
            //    }
            
//            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
//                NSInteger index = 0;
//                    weakSelf.yx_productArray = [productArray mutableCopy];
//                    for (PotentailCustomerEditModel *editModel in localArr) {
//                        if ([editModel.locatedTitle isEqualToString:model.locatedTitle]) {
//                            index = [localArr indexOfObject:editModel];
//                        }
//                    }
//                    [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                    MJKProductShowModel *model = productArray[0];
//                    weakSelf.C_YX_A49600_C_ID = model.C_ID;
//                    weakSelf.C_YX_A70600_C_ID = model.C_TYPE_DD_ID;
//            };
            [self.navigationController pushViewController:vc animated:YES];
        
        } else {
    
            MJKCarSourceViewController *vc = [[MJKCarSourceViewController alloc]init];
//            if (self.yx_productArray.count > 0) {
//                vc.productArray = [self.yx_productArray mutableCopy];
//            }
            
            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                NSInteger index = 0;
                weakSelf.productArray = [productArray mutableCopy];
                for (PotentailCustomerEditModel *editModel in localArr) {
                    if ([editModel.locatedTitle isEqualToString:model.locatedTitle]) {
                        index = [localArr indexOfObject:editModel];
                    }
                }
                [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                MJKProductShowModel *model = productArray[0];
                weakSelf.C_A49600_C_ID = model.C_ID;
                weakSelf.C_A70600_C_ID = model.C_TYPE_DD_ID;
            };
        
            [self.navigationController pushViewController:vc animated:YES];
    //        MJKProductChooseViewController *vc = [[MJKProductChooseViewController alloc]initWithNibName:@"MJKProductChooseViewController" bundle:nil];
    //        [self.navigationController pushViewController:vc animated:YES];
        }
    
    
}
- (void)getNotificationAction:(NSNotification *)notification{
    NSMutableArray*localArr=self.localDatas[0];
    NSDictionary * infoDic = [notification userInfo];
    NSArray *productArray = infoDic[@"productArray"];
    if ([self.productType isEqualToString:@"意向车型"]) {
        NSInteger index = 0;
        self.yx_productArray = [productArray mutableCopy];
        PotentailCustomerEditModel *editModel1;
        for (PotentailCustomerEditModel *editModel in localArr) {
            if ([editModel.locatedTitle isEqualToString:@"意向车型"]) {
                index = [localArr indexOfObject:editModel];
                editModel1 = editModel;
            }
        }
        MJKProductShowModel *model = productArray[0];
//        self.C_YX_A49600_C_ID = model.C_ID;
//        self.C_YX_A70600_C_ID = model.C_TYPE_DD_ID;
        self.C_A49600_C_ID = model.C_ID;
        self.C_A70600_C_ID = model.C_TYPE_DD_ID;
        editModel1.nameValue = model.C_NAME;
        editModel1.postValue = model.C_ID;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        NSInteger index = 0;
        self.yx_productArray = [productArray mutableCopy];
        PotentailCustomerEditModel *editModel1;
        for (PotentailCustomerEditModel *editModel in localArr) {
            if ([editModel.locatedTitle isEqualToString:@"匹配车型"]) {
                index = [localArr indexOfObject:editModel];
                editModel1 = editModel;
            }
        }
        MJKProductShowModel *model = productArray[0];
        self.C_A49600_C_ID = model.C_ID;
        self.C_A70600_C_ID = model.C_TYPE_DD_ID;
        editModel1.nameValue = model.C_NAME;
        editModel1.postValue = model.C_ID;
        
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"productArray" object:nil];
}


//-(void)clickScanf{
//    WLBarcodeViewController*QRCode=[[WLBarcodeViewController alloc]initWithBlock:^(NSString *str, BOOL isSuccess) {
//
//        if (isSuccess) {
//            //成功
//            MyLog(@"%@",str);
//
//            [self addDataswithStr:str andAlertVC:nil];
//
//
//
//        }else{
//            UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"扫描结果" message:@"无法识别" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction*action=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//
//            }];
//            [alertVC addAction:action];
//
//
//
//            [self presentViewController:alertVC animated:YES completion:nil];
//
//
//        }
//
//
//    }];
//
//    [self presentViewController:QRCode animated:YES completion:nil];
//
//
//}



-(void)clickManual{
    MyLog(@"手动输入");
    DBSelf(weakSelf);
    UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"请输入匹配车型编号码" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField*textField=alertVC.textFields.firstObject;
        if (textField.text.length<1) {
            [JRToast showWithText:@"请输入产品码"];
            [weakSelf presentViewController:alertVC animated:YES completion:nil];
            return ;
        }
        
        [weakSelf addDataswithStr:textField.text andAlertVC:alertVC];
        
        
    }];
    
    [alertVC addAction:cancel];
    [alertVC addAction:sure];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
    
    
    
}



//产品编码 获取产品
-(void)addDataswithStr:(NSString*)textStr andAlertVC:(UIAlertController*)alertVC{
    DBSelf(weakSelf);
    
    //    NSString*urlStr=[NSString stringWithFormat:@"%@",newHttp_address];
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_AddProduct];
    
    NSDictionary*dict=@{@"C_VOUCHERID":textStr};
    [mainDict setObject:dict forKey:@"content"];
    
    NSString*paramStr= [DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:paramStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            CodeShoppingModel*model=[CodeShoppingModel yy_modelWithDictionary:data];
            model.isStatus=@"add";
            [self.saveAllShoppingInfo addObject:model];
            
            
            self.showProductView.hidden=NO;
            [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
            
            [self.showProductView getShowValue:self.saveAllShoppingInfo];
            
            
            
        }else if ([data[@"message"] isEqualToString:@"产品编码对应的产品不存在"]){
            [JRToast showWithText:data[@"message"]];
            if (alertVC) {
                [weakSelf presentViewController:alertVC animated:YES completion:nil];
            }
            
        }
        
        else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
        
        
    }];
    
    
}





@end
