//
//  MJKAddOrEditCarSourceViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/18.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAddOrEditCarSourceViewController.h"
#import "MJKChooseEmployeesViewController.h"

#import "AddCustomerChooseTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerPhotoTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"
#import "AddCustomerProductTableViewCell.h"

#import "MJKPhotoView.h"

#import "MJKCarSourceSubModel.h"
#import "MJKProductShowModel.h"
#import "CustomerDetailInfoModel.h"
#import "MJKClueListSubModel.h"

#import "MJKChooseBrandViewController.h"

@interface MJKAddOrEditCarSourceViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong)  UITableView*tableView;
/** cell array*/
@property (nonatomic, strong) NSMutableArray *cellArray;
/** bottom view*/
@property (nonatomic, strong) UIView *bottomView;
/** 产品*/
@property (nonatomic, strong) NSMutableArray *productArray;
@property (nonatomic, strong) NSMutableArray *productNewArray;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveDataCodeDic;
@property (nonatomic, strong) NSMutableDictionary *saveDataNameDic;
/** 选择的车型*/
@property (nonatomic, strong) NSString *C_YX_A49600_C_ID;
@property (nonatomic, strong) NSString *C_YX_A70600_C_ID;
@property (nonatomic, strong) NSString *C_YX_A49600_C_NAME;
@property (nonatomic, strong) NSString *C_YX_A70600_C_NAME;

@property (nonatomic, strong) NSString *C_BY_A70600_C_ID;
@property (nonatomic, strong) NSString *C_BY_A49600_C_ID;
@property (nonatomic, strong) NSString *C_BY_A70600_C_NAME;
@property (nonatomic, strong) NSString *C_BY_A49600_C_NAME;
/** 输入的车型*/
@property (nonatomic, strong) NSString *C_YX_CAR;
@property (nonatomic, strong) NSString *C_BY_CAR;
/** <#注释#>*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *imageUrlArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *portraitAddress;
/** 纯卖*/
@property (nonatomic, strong) NSString *carSaleType;
/** <#注释#>*/
@property (nonatomic, strong) MJKCarSourceSubModel *detailInfoModel;
@end

@implementation MJKAddOrEditCarSourceViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationAction:) name:@"productArray" object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.type == CarSourceAdd) {
        self.title = @"新增车源";
        if ([self.vcName isEqualToString:@"客户新增二手车"]) {
            self.detailInfoModel = [[MJKCarSourceSubModel alloc]init];
            self.detailInfoModel.C_NAME = self.customerModel.C_NAME.length > 0 ? self.customerModel.C_NAME : @"";
            self.detailInfoModel.C_PHONE = self.customerModel.C_PHONE.length > 0 ? self.customerModel.C_PHONE : @"";
            self.detailInfoModel.C_SEX_DD_NAME = self.customerModel.C_SEX_DD_NAME.length > 0 ? self.customerModel.C_SEX_DD_NAME : @"";
            if (self.detailInfoModel.C_SEX_DD_NAME.length > 0) {
                self.detailInfoModel.C_SEX_DD_ID = [self.customerModel.C_SEX_DD_NAME isEqualToString:@"男"] ? @"A71000_C_SEX_0000" : @"A71000_C_SEX_0001";
            } else {
                self.detailInfoModel.C_SEX_DD_ID = @"";
            }
            self.detailInfoModel.C_ADDRESS = self.customerModel.C_ADDRESS.length > 0 ? self.customerModel.C_ADDRESS : @"";
            self.detailInfoModel.C_TYPE_DD_NAME = self.customerModel.C_BUYTYPE_DD_NAME.length > 0 ? self.customerModel.C_BUYTYPE_DD_NAME : @"";
            self.detailInfoModel.C_TYPE_DD_ID = self.customerModel.C_BUYTYPE_DD_ID.length > 0 ? self.customerModel.C_BUYTYPE_DD_ID : @"";
            self.C_YX_A49600_C_ID = self.detailInfoModel.C_YX_A49600_C_ID = self.customerModel.C_YX_A49600_C_ID.length > 0 ? self.customerModel.C_YX_A49600_C_ID : @"";
            self.detailInfoModel.C_YX_A49600_C_NAME = self.customerModel.C_YX_A49600_C_NAME.length > 0 ? self.customerModel.C_YX_A49600_C_NAME : @"";
            self.C_YX_A70600_C_ID = self.detailInfoModel.C_YX_A70600_C_ID = self.customerModel.C_YX_A70600_C_ID.length > 0 ? self.customerModel.C_YX_A70600_C_ID : @"";
            self.detailInfoModel.C_YX_A70600_C_NAME = self.customerModel.C_YX_A70600_C_NAME.length > 0 ? self.customerModel.C_YX_A70600_C_NAME : @"";
            self.detailInfoModel.C_YX_CAR = self.customerModel.C_YX_CAR_REMARK.length > 0 ? self.customerModel.C_YX_CAR_REMARK : @"";
            self.detailInfoModel.C_YX_A49600_C_PICTURE = self.customerModel.C_YX_A49600_C_PICTURE.length > 0 ? self.customerModel.C_YX_A49600_C_PICTURE : @"";
            
            
            [self.saveDataNameDic setObject:self.detailInfoModel.C_NAME forKey:@"C_NAME"];
            [self.saveDataCodeDic setObject:self.detailInfoModel.C_NAME forKey:@"C_NAME"];
            
            [self.saveDataNameDic setObject:self.detailInfoModel.C_PHONE forKey:@"C_PHONE"];
            [self.saveDataCodeDic setObject:self.detailInfoModel.C_PHONE forKey:@"C_PHONE"];
            
            [self.saveDataNameDic setObject:self.detailInfoModel.C_SEX_DD_NAME forKey:@"C_SEX_DD_NAME"];
            [self.saveDataCodeDic setObject:self.detailInfoModel.C_SEX_DD_ID forKey:@"C_SEX_DD_ID"];
            
            [self.saveDataNameDic setObject:self.detailInfoModel.C_ADDRESS forKey:@"C_ADDRESS"];
            [self.saveDataCodeDic setObject:self.detailInfoModel.C_ADDRESS forKey:@"C_ADDRESS"];
            
            [self.saveDataNameDic setObject:self.detailInfoModel.C_TYPE_DD_NAME forKey:@"C_TYPE_DD_NAME"];
            [self.saveDataCodeDic setObject:self.detailInfoModel.C_TYPE_DD_ID forKey:@"C_TYPE_DD_ID"];
            
            
                self.C_YX_CAR = self.detailInfoModel.C_YX_CAR;
                NSMutableArray *section1Arr = self.cellArray[1][@"content"];
                NSMutableArray *section1NameArr = self.cellArray[1][@"name"];
                NSMutableArray *section1CodeArr = self.cellArray[1][@"code"];
                [section1Arr insertObject:@"新购车型" atIndex:6];
                [section1NameArr insertObject:self.C_YX_CAR atIndex:6];
                [section1CodeArr insertObject:self.C_YX_CAR atIndex:6];
               
        
                MJKProductShowModel *model = [[MJKProductShowModel alloc]init];
                model.C_ID = self.detailInfoModel.C_YX_A49600_C_ID;
                model.C_TYPE_DD_ID = self.detailInfoModel.C_YX_A70600_C_ID;
                model.X_FMPICURL = self.detailInfoModel.C_YX_A49600_C_PICTURE;
                model.C_NAME = [NSString stringWithFormat:@"%@ %@",self.detailInfoModel.C_YX_A70600_C_NAME, self.detailInfoModel.C_YX_A49600_C_NAME];
                self.productNewArray = [NSMutableArray array];
                [self.productNewArray addObject:model];
            
        }
    } else {
        self.title = @"编辑车源";
        [self httpPostGetCustomerDetailInfo];
    }
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.cellArray[section][@"content"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSString *cellStr = self.cellArray[indexPath.section][@"content"][indexPath.row];
    NSString *nameStr = self.cellArray[indexPath.section][@"name"][indexPath.row];
    NSString *codeStr = self.cellArray[indexPath.section][@"code"][indexPath.row];
    AddCustomerInputTableViewCell *inputCell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    AddCustomerChooseTableViewCell *chooseCell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    if ([cellStr isEqualToString:@"姓名"]) {
        //头像名字
        AddCustomerPhotoTableViewCell*cell=[AddCustomerPhotoTableViewCell cellWithTableView:tableView];
        cell.mustbeLabel.hidden = NO;
        cell.clickPortraitBlock = ^{
            [weakSelf TouchAddImage];
            
        };
        if (self.saveDataNameDic != nil && self.saveDataNameDic.allKeys.count > 0) {
            cell.nameTextField.text = self.saveDataNameDic[nameStr];
        }
    
        cell.changeTextFieldBlock = ^(NSString *currentStr) {
            MyLog(@"%@",currentStr);
            [weakSelf.saveDataNameDic setObject:currentStr forKey:nameStr];
            [weakSelf.saveDataCodeDic setObject:currentStr forKey:codeStr];
        };
        return cell;
    } else if ([cellStr isEqualToString:@"联系电话"] || [cellStr isEqualToString:@"居住地址"] || [cellStr isEqualToString:@"车牌号"] || [cellStr isEqualToString:@"里程"] || [cellStr isEqualToString:@"客户心理价"] || [cellStr isEqualToString:@"系统评估价"] || [cellStr isEqualToString:@"内部评估价"] || [cellStr isEqualToString:@"线索提供人"]) {
        inputCell.nameTitleLabel.text = cellStr;
        if (self.saveDataNameDic != nil && self.saveDataNameDic.allKeys.count > 0) {
            inputCell.inputTextField.text = self.saveDataNameDic[nameStr];
        }
        if ([cellStr isEqualToString:@"联系电话"]) {
            inputCell.tagLabel.hidden = NO;
            inputCell.textFieldLength = 11;
            inputCell.inputTextField.keyboardType = UIKeyboardTypePhonePad;
        }
        if ([cellStr isEqualToString:@"里程"] || [cellStr isEqualToString:@"客户心理价"] || [cellStr isEqualToString:@"系统评估价"] || [cellStr isEqualToString:@"内部评估价"]) {
            inputCell.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
        }
        inputCell.changeTextBlock = ^(NSString *textStr) {
            [weakSelf.saveDataNameDic setObject:textStr forKey:nameStr];
            [weakSelf.saveDataCodeDic setObject:textStr forKey:codeStr];
        };
        return inputCell;
    } else if ([cellStr isEqualToString:@"备注"]) {
        MJKClueMemoInDetailTableViewCell *cell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
        cell.titleLabel.text = cellStr;
        if (self.saveDataNameDic != nil && self.saveDataNameDic.allKeys.count > 0) {
            cell.memoTextView.text = self.saveDataNameDic[nameStr];
        }
        [cell setBackTextViewBlock:^(NSString *str){
            [weakSelf.saveDataNameDic setObject:str forKey:nameStr];
            [weakSelf.saveDataCodeDic setObject:str forKey:codeStr];
        }];
        return cell;
    } else if ([cellStr isEqualToString:@"出售车型"]) {
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = @"出售车型";
        cell.taglabel.hidden = NO;
        cell.titleLeftLayout.constant = 20;
        if (self.C_BY_A49600_C_NAME.length > 0) {
           cell.textStr=self.C_BY_A49600_C_NAME;
        }

        cell.Type = chooseTypeNil;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
           MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
           vc.rootVC = weakSelf;
            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                self.productArray = [productArray mutableCopy];
                MJKProductShowModel *model = productArray[0];
                self.C_BY_A49600_C_ID = model.C_ID;
                self.C_BY_A70600_C_ID = model.C_TYPE_DD_ID;
                self.C_BY_A49600_C_NAME = model.C_NAME;
                self.C_BY_A70600_C_NAME = model.C_TYPE_DD_NAME;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
            };
           [weakSelf.navigationController pushViewController:vc animated:YES];
        };

        return cell;
    } else if ([cellStr isEqualToString:@"新购车型"]) {
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = @"新购车型";
        cell.taglabel.hidden = NO;
        cell.titleLeftLayout.constant = 20;
        if (self.C_YX_A49600_C_NAME.length > 0) {
           cell.textStr=self.C_YX_A49600_C_NAME;
        }

        cell.Type = chooseTypeNil;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
           MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
           vc.rootVC = weakSelf;
            vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
                self.productNewArray = [productArray mutableCopy];
                MJKProductShowModel *model = productArray[0];
                self.C_YX_A49600_C_ID = model.C_ID;
                self.C_YX_A70600_C_ID = model.C_TYPE_DD_ID;
                self.C_YX_A49600_C_NAME = model.C_NAME;
                self.C_YX_A70600_C_NAME = model.C_TYPE_DD_NAME;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
           [weakSelf.navigationController pushViewController:vc animated:YES];
        };

        return cell;
    } else {
        chooseCell.nameTitleLabel.text = cellStr;
        chooseCell.isTitle = YES;
    
        if (self.saveDataNameDic != nil && self.saveDataNameDic.allKeys.count > 0) {
            chooseCell.chooseTextField.text = self.saveDataNameDic[nameStr];
        }
        if ([cellStr isEqualToString:@"性别"]) {
            chooseCell.Type = ChooseTableViewTypeGender;
        } else if ([cellStr isEqualToString:@"追踪等级"]) {
            chooseCell.taglabel.hidden = NO;
            chooseCell.Type = ChooseTableViewTypeCarLevel;
        } else if ([cellStr isEqualToString:@"类型"]) {
            chooseCell.taglabel.hidden = NO;
            chooseCell.Type = ChooseTableViewTypeCarType;
        } else if ([cellStr isEqualToString:@"车源种类"]) {
            chooseCell.taglabel.hidden = NO;
            chooseCell.Type = ChooseTableViewTypeCarSpecies;
        }else if ([cellStr isEqualToString:@"车源渠道"]) {
            chooseCell.taglabel.hidden = NO;
            chooseCell.Type = ChooseTableViewTypeCarSource;
        } else if ([cellStr isEqualToString:@"车牌所在地"]) {
            chooseCell.Type = ChooseTableViewTypeCarCity;
        } else if ([cellStr isEqualToString:@"变速箱"]) {
            chooseCell.Type = ChooseTableViewTypeCarBSX;
        } else if ([cellStr isEqualToString:@"排量"]) {
            chooseCell.Type = ChooseTableViewTypeCarPL;
        } else if ([cellStr isEqualToString:@"燃油类型"]) {
            chooseCell.Type = ChooseTableViewTypeCarRYTYPE;
        } else if ([cellStr isEqualToString:@"排放标准"]) {
            chooseCell.Type = ChooseTableViewTypeCarPFBZ;
        } else if ([cellStr isEqualToString:@"重大事故"]) {
            chooseCell.Type = ChooseTableViewTypeCarZDSG;
        } else if ([cellStr isEqualToString:@"火烧事故"]) {
            chooseCell.Type = ChooseTableViewTypeCarHSSG;
        } else if ([cellStr isEqualToString:@"泡水事故"]) {
            chooseCell.Type = ChooseTableViewTypeCarPSSG;
        } else {
            chooseCell.Type = ChooseTableViewTypeBirthday;
        }
        chooseCell.chooseBlock = ^(NSString *str, NSString *postValue) {
            
            if ([cellStr isEqualToString:@"类型"]) {
                NSMutableArray *section1Arr = weakSelf.cellArray[1][@"content"];
                NSMutableArray *section1NameArr = weakSelf.cellArray[1][@"name"];
                NSMutableArray *section1CodeArr = weakSelf.cellArray[1][@"code"];
                if ([str isEqualToString:@"置换"]) {
                    if ([section1Arr containsObject:@"新购车型"]) {
                        [section1Arr removeObjectAtIndex:6];
                        [section1NameArr removeObjectAtIndex:6];
                        [section1CodeArr removeObjectAtIndex:6];
                    }
                    [section1Arr insertObject:@"新购车型" atIndex:6];
                    [section1NameArr insertObject:@"" atIndex:6];
                    [section1CodeArr insertObject:@"" atIndex:6];
                } else {
                    NSString *str = section1Arr[5];
                    if ([str isEqualToString:@"新购车型"]) {
                        [section1Arr removeObjectAtIndex:6];
                        [section1NameArr removeObjectAtIndex:6];
                        [section1CodeArr removeObjectAtIndex:6];
                    }
                }
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
            [weakSelf.saveDataCodeDic setObject:postValue forKey:codeStr];
            [weakSelf.saveDataNameDic setObject:str forKey:nameStr];
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        };
        return chooseCell;
    }
    
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.section][@"content"][indexPath.row];
    if ([cellStr isEqualToString:@"姓名"]) {
        return 60;
    } else if ([cellStr isEqualToString:@"备注"]) {
        return 120;
    }
    else {
        return 44;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 180;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
    label.textColor = [UIColor darkGrayColor];
    label.text = self.cellArray[section][@"headerTitle"];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return self.tableFootPhoto;
    }
    return nil;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    NSData*data=UIImageJPEGRepresentation(newPhoto, 0.5);
    
        //头像
        AddCustomerPhotoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.imageButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
        
        
        [self HttpPostOneImageToJiekouWith:data];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
    
-(void)clickSure{
    DBSelf(weakSelf);
    MJKChooseBrandViewController *vc = [[MJKChooseBrandViewController alloc]init];
//    if (self.productArray.count > 0) {
//        vc.productArray = [self.productArray mutableCopy];
//    }
    vc.rootVC = self;
//    vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
//
//        if ([weakSelf.carSaleType isEqualToString:@"出售车型"]) {
//            weakSelf.productArray = [productArray mutableCopy];
//            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            MJKProductShowModel *model = productArray[0];
//            weakSelf.C_BY_A49600_C_ID = model.C_ID;
//            weakSelf.C_BY_A70600_C_ID = model.C_TYPE_DD_ID;
//        } else {
//            weakSelf.productNewArray = [productArray mutableCopy];
//            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
//            MJKProductShowModel *model = productArray[0];
//            weakSelf.C_YX_A49600_C_ID = model.C_ID;
//            weakSelf.C_YX_A70600_C_ID = model.C_TYPE_DD_ID;
//        }
//    };
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

- (void)getNotificationAction:(NSNotification *)notification{
//    NSMutableArray*localArr=self.localDatas[0];
    NSDictionary * infoDic = [notification userInfo];
    NSArray *productArray = infoDic[@"productArray"];
    
    if ([self.carSaleType isEqualToString:@"出售车型"]) {
        self.productArray = [productArray mutableCopy];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:5 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        MJKProductShowModel *model = productArray[0];
        self.C_BY_A49600_C_ID = model.C_ID;
        self.C_BY_A70600_C_ID = model.C_TYPE_DD_ID;
        self.C_BY_A49600_C_NAME = model.C_NAME;
        self.C_BY_A70600_C_NAME = model.C_TYPE_DD_NAME;
    } else {
        self.productNewArray = [productArray mutableCopy];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
        MJKProductShowModel *model = productArray[0];
        self.C_YX_A49600_C_ID = model.C_ID;
        self.C_YX_A70600_C_ID = model.C_TYPE_DD_ID;
        self.C_YX_A49600_C_NAME = model.C_NAME;
        self.C_YX_A70600_C_NAME = model.C_TYPE_DD_NAME;
    }

    //chooseCarModels
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"productArray" object:nil];
}

#pragma mark - http
- (void)httpCommitSaveCarSource {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:self.type == CarSourceAdd ? @"A71000WebService-insert" : @"A71000WebService-update"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.type == CarSourceAdd ? [DBObjectTools getA71000C_id] : self.detailInfoModel.C_ID;
    if (self.portraitAddress.length > 0) {
        contentDic[@"X_PICTURE"] = self.portraitAddress;
    }
    [self.saveDataCodeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDic setObject:obj forKey:key];
    }];
    if (self.C_BY_CAR.length > 0) {
        contentDic[@"C_BY_CAR"] = self.C_BY_CAR;
    }
    if (self.C_YX_CAR.length > 0) {
        contentDic[@"C_YX_CAR"] = self.C_YX_CAR;
    }
    
    if (self.C_BY_A70600_C_ID.length > 0) {
        contentDic[@"C_BY_A70600_C_ID"] = self.C_BY_A70600_C_ID;
    }
    if (self.C_BY_A49600_C_ID.length > 0) {
        contentDic[@"C_BY_A49600_C_ID"] = self.C_BY_A49600_C_ID;
    }
    
    if (self.C_YX_A70600_C_ID.length > 0) {
        contentDic[@"C_YX_A70600_C_ID"] = self.C_YX_A70600_C_ID;
    }
    if (self.C_YX_A49600_C_ID.length > 0) {
        contentDic[@"C_YX_A49600_C_ID"] = self.C_YX_A49600_C_ID;
    }
    if (self.imageUrlArray.count > 0) {
        contentDic[@"urlList"] = self.imageUrlArray;
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"refresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
           
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
//上传头像
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

-(void)httpPostGetCustomerDetailInfo{
    DBSelf(weakSelf);
    NSMutableDictionary*maDict=[DBObjectTools getAddressDicWithAction:@"A71000WebService-getBeanById"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    if (self.C_ID.length > 0) {
        contentDict[@"C_ID"] = self.C_ID;
    }
    [maDict setObject:contentDict forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:maDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            weakSelf.detailInfoModel=[MJKCarSourceSubModel mj_objectWithKeyValues:data];
            
            if (weakSelf.detailInfoModel.X_PICTURE.length > 0) {
                weakSelf.portraitAddress = weakSelf.detailInfoModel.X_PICTURE;
            }
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_NAME.length > 0 ? self.detailInfoModel.C_NAME : @"" forKey:@"C_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_NAME.length > 0 ? self.detailInfoModel.C_NAME : @"" forKey:@"C_NAME"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_PHONE.length > 0 ? self.detailInfoModel.C_PHONE : @"" forKey:@"C_PHONE"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_PHONE.length > 0 ? self.detailInfoModel.C_PHONE : @"" forKey:@"C_PHONE"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_SEX_DD_NAME.length > 0 ? self.detailInfoModel.C_SEX_DD_NAME : @"" forKey:@"C_SEX_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_SEX_DD_ID.length > 0 ? self.detailInfoModel.C_SEX_DD_ID : @"" forKey:@"C_SEX_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_ADDRESS.length > 0 ? self.detailInfoModel.C_ADDRESS : @"" forKey:@"C_ADDRESS"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_ADDRESS.length > 0 ? self.detailInfoModel.C_ADDRESS : @"" forKey:@"C_ADDRESS"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_LEVEL_DD_NAME.length > 0 ? self.detailInfoModel.C_LEVEL_DD_NAME : @"" forKey:@"C_LEVEL_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_LEVEL_DD_ID.length > 0 ? self.detailInfoModel.C_LEVEL_DD_ID : @"" forKey:@"C_LEVEL_DD_ID"];
            
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_TYPE_DD_NAME.length > 0 ? weakSelf.detailInfoModel.C_TYPE_DD_NAME : @"" forKey:@"C_TYPE_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_TYPE_DD_ID.length > 0 ? weakSelf.detailInfoModel.C_TYPE_DD_ID : @"" forKey:@"C_TYPE_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_ESC_TYPE_DD_NAME.length > 0 ? weakSelf.detailInfoModel.C_ESC_TYPE_DD_NAME : @"" forKey:@"C_ESC_TYPE_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_ESC_TYPE_DD_ID.length > 0 ? weakSelf.detailInfoModel.C_ESC_TYPE_DD_ID : @"" forKey:@"C_ESC_TYPE_DD_ID"];
            //C_CHANNEL_DD_NAME
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_CHANNEL_DD_NAME.length > 0 ? weakSelf.detailInfoModel.C_CHANNEL_DD_NAME : @"" forKey:@"C_CHANNEL_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_CHANNEL_DD_ID.length > 0 ? weakSelf.detailInfoModel.C_CHANNEL_DD_ID : @"" forKey:@"C_CHANNEL_DD_ID"];
            
            if (weakSelf.detailInfoModel.D_YJMC_TIME.length > 0) {
                [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.D_YJMC_TIME forKey:@"D_YJMC_TIME"];
                [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.D_YJMC_TIME forKey:@"D_YJMC_TIME"];
            }
            
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_CLUEUSER_ID.length > 0 ? weakSelf.detailInfoModel.C_CLUEUSER_ID : @"" forKey:@"C_CLUEUSER_ID"];
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_CLUEUSER_ID.length > 0 ? weakSelf.detailInfoModel.C_CLUEUSER_ID : @"" forKey:@"C_CLUEUSER_ID"];
            
            weakSelf.C_BY_CAR = weakSelf.detailInfoModel.C_BY_CAR.length > 0 ? weakSelf.detailInfoModel.C_BY_CAR : @"";
            if (weakSelf.C_YX_CAR.length > 0) {
                weakSelf.C_YX_CAR = weakSelf.detailInfoModel.C_YX_CAR;
                NSMutableArray *section1Arr = weakSelf.cellArray[1][@"content"];
                NSMutableArray *section1NameArr = weakSelf.cellArray[1][@"name"];
                NSMutableArray *section1CodeArr = weakSelf.cellArray[1][@"code"];
                if ([weakSelf.saveDataNameDic[@"C_TYPE_DD_NAME"] isEqualToString:weakSelf.detailInfoModel.C_TYPE_DD_NAME]) {
                    [section1Arr insertObject:@"新购车型" atIndex:6];
                    [section1NameArr insertObject:@"" atIndex:6];
                    [section1CodeArr insertObject:@"" atIndex:6];
                } else {
                    NSString *str = section1Arr[6];
                    if ([str isEqualToString:@"新购车型"]) {
                        [section1Arr removeObjectAtIndex:6];
                        [section1NameArr removeObjectAtIndex:6];
                        [section1CodeArr removeObjectAtIndex:6];
                    }
                }
               
            }
            
            if (weakSelf.detailInfoModel.C_BY_A70600_C_ID.length > 0) {
                MJKProductShowModel *model = [[MJKProductShowModel alloc]init];
                model.C_ID = weakSelf.C_BY_A49600_C_ID = weakSelf.detailInfoModel.C_BY_A49600_C_ID;
                model.C_TYPE_DD_ID = weakSelf.C_BY_A70600_C_ID = weakSelf.detailInfoModel.C_BY_A70600_C_ID;
                model.X_FMPICURL = weakSelf.detailInfoModel.C_BY_A49600_C_PICTURE;
                model.C_NAME = [NSString stringWithFormat:@"%@ %@",weakSelf.detailInfoModel.C_BY_A70600_C_NAME, weakSelf.detailInfoModel.C_BY_A49600_C_NAME];
                weakSelf.productArray = [NSMutableArray array];
                [weakSelf.productArray addObject:model];
            }
            if (weakSelf.detailInfoModel.C_YX_A70600_C_ID.length > 0) {
                MJKProductShowModel *model = [[MJKProductShowModel alloc]init];
                model.C_ID = weakSelf.C_YX_A49600_C_ID = weakSelf.detailInfoModel.C_YX_A49600_C_ID;
                model.C_TYPE_DD_ID = weakSelf.C_YX_A70600_C_ID = weakSelf.detailInfoModel.C_YX_A70600_C_ID;
                model.X_FMPICURL = weakSelf.detailInfoModel.C_YX_A49600_C_PICTURE;
                model.C_NAME = [NSString stringWithFormat:@"%@ %@",weakSelf.detailInfoModel.C_YX_A70600_C_NAME, weakSelf.detailInfoModel.C_YX_A49600_C_NAME];
                weakSelf.productNewArray = [NSMutableArray array];
                [weakSelf.productNewArray addObject:model];
            }
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_CPSZD_DD_NAME.length > 0 ? self.detailInfoModel.C_CPSZD_DD_NAME : @"" forKey:@"C_CPSZD_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_CPSZD_DD_ID.length > 0 ? self.detailInfoModel.C_CPSZD_DD_ID : @"" forKey:@"C_CPSZD_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_CPH.length > 0 ? self.detailInfoModel.C_CPH : @"" forKey:@"C_CPH"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_CPH.length > 0 ? self.detailInfoModel.C_CPH : @"" forKey:@"C_CPH"];
            
            if (weakSelf.detailInfoModel.D_SP_TIME.length > 0) {
                [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.D_SP_TIME forKey:@"D_SP_TIME"];
                [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.D_SP_TIME forKey:@"D_SP_TIME"];
            }
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_LC.length > 0 ? self.detailInfoModel.C_LC : @"" forKey:@"C_LC"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_LC.length > 0 ? self.detailInfoModel.C_LC : @"" forKey:@"C_LC"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_KHXLJ.length > 0 ? self.detailInfoModel.C_KHXLJ : @"" forKey:@"C_KHXLJ"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_KHXLJ.length > 0 ? self.detailInfoModel.C_KHXLJ : @"" forKey:@"C_KHXLJ"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_XTPGJ.length > 0 ? self.detailInfoModel.C_XTPGJ : @"" forKey:@"C_XTPGJ"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_XTPGJ.length > 0 ? self.detailInfoModel.C_XTPGJ : @"" forKey:@"C_XTPGJ"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_NBPGJ.length > 0 ? self.detailInfoModel.C_NBPGJ : @"" forKey:@"C_NBPGJ"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_NBPGJ.length > 0 ? self.detailInfoModel.C_NBPGJ : @"" forKey:@"C_NBPGJ"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_BSX_DD_NAME.length > 0 ? self.detailInfoModel.C_BSX_DD_NAME : @"" forKey:@"C_BSX_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_BSX_DD_ID.length > 0 ? self.detailInfoModel.C_BSX_DD_ID : @"" forKey:@"C_BSX_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_PL_DD_NAME.length > 0 ? self.detailInfoModel.C_PL_DD_NAME : @"" forKey:@"C_PL_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_PL_DD_ID.length > 0 ? self.detailInfoModel.C_PL_DD_ID : @"" forKey:@"C_PL_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_RYTYPE_DD_NAME.length > 0 ? self.detailInfoModel.C_RYTYPE_DD_NAME : @"" forKey:@"C_RYTYPE_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_RYTYPE_DD_ID.length > 0 ? self.detailInfoModel.C_RYTYPE_DD_ID : @"" forKey:@"C_RYTYPE_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_PFBZ_DD_NAME.length > 0 ? self.detailInfoModel.C_PFBZ_DD_NAME : @"" forKey:@"C_PFBZ_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_PFBZ_DD_ID.length > 0 ? self.detailInfoModel.C_PFBZ_DD_ID : @"" forKey:@"C_PFBZ_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_NJDQ.length > 0 ? self.detailInfoModel.C_NJDQ : @"" forKey:@"C_NJDQ"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_NJDQ.length > 0 ? self.detailInfoModel.C_NJDQ : @"" forKey:@"C_NJDQ"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_JQX.length > 0 ? self.detailInfoModel.C_JQX : @"" forKey:@"C_JQX"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_JQX.length > 0 ? self.detailInfoModel.C_JQX : @"" forKey:@"C_JQX"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_SYXDQ.length > 0 ? self.detailInfoModel.C_SYXDQ : @"" forKey:@"C_SYXDQ"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_SYXDQ.length > 0 ? self.detailInfoModel.C_SYXDQ : @"" forKey:@"C_SYXDQ"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_ZDSG_DD_NAME.length > 0 ? self.detailInfoModel.C_ZDSG_DD_NAME : @"" forKey:@"C_ZDSG_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_ZDSG_DD_ID.length > 0 ? self.detailInfoModel.C_ZDSG_DD_ID : @"" forKey:@"C_ZDSG_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_HSSG_DD_NAME.length > 0 ? self.detailInfoModel.C_HSSG_DD_NAME : @"" forKey:@"C_HSSG_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_HSSG_DD_ID.length > 0 ? self.detailInfoModel.C_HSSG_DD_ID : @"" forKey:@"C_HSSG_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.C_PSSG_DD_NAME.length > 0 ? self.detailInfoModel.C_PSSG_DD_NAME : @"" forKey:@"C_PSSG_DD_NAME"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.C_PSSG_DD_ID.length > 0 ? self.detailInfoModel.C_PSSG_DD_ID : @"" forKey:@"C_PSSG_DD_ID"];
            
            [weakSelf.saveDataNameDic setObject:weakSelf.detailInfoModel.X_REMARK.length > 0 ? self.detailInfoModel.X_REMARK : @"" forKey:@"X_REMARK"];
            [weakSelf.saveDataCodeDic setObject:weakSelf.detailInfoModel.X_REMARK.length > 0 ? self.detailInfoModel.X_REMARK : @"" forKey:@"X_REMARK"];
            
            weakSelf.imageUrlArray = weakSelf.detailInfoModel.urlList;
            if (weakSelf.imageUrlArray.count > 0) {
                weakSelf.tableFootPhoto.imageURLArray = weakSelf.imageUrlArray;
            }
            
            [weakSelf.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - click
- (void)submitAction:(UIButton *)sender {
    NSUInteger index;
    NSString *code;
    NSString *saveData;
    
    NSArray *sectionArr0 = self.cellArray[0][@"content"];
    NSArray *sectionCodeArr0 = self.cellArray[0][@"code"];
    index = [sectionArr0 indexOfObject:@"姓名"];
    code = [sectionCodeArr0 objectAtIndex:index];
    saveData = self.saveDataCodeDic[code];
    if (saveData.length <= 0) {
        [JRToast showWithText:@"请输入姓名"];
        return;
    }
    index = [sectionArr0 indexOfObject:@"联系电话"];
    code = [sectionCodeArr0 objectAtIndex:index];
    saveData = self.saveDataCodeDic[code];
    if (saveData.length <= 0) {
        [JRToast showWithText:@"请输入联系电话"];
        return;
    }
    
    index = [sectionArr0 indexOfObject:@"追踪等级"];
    code = [sectionCodeArr0 objectAtIndex:index];
    saveData = self.saveDataCodeDic[code];
    if (saveData.length <= 0) {
        [JRToast showWithText:@"请选择追踪等级"];
        return;
    }
    
    
    NSArray *sectionArr1 = self.cellArray[1][@"content"];
    NSArray *sectionCodeArr1 = self.cellArray[1][@"code"];
    index = [sectionArr1 indexOfObject:@"类型"];
    code = [sectionCodeArr1 objectAtIndex:index];
    saveData = self.saveDataCodeDic[code];
    if (saveData.length <= 0) {
        [JRToast showWithText:@"请选择类型"];
        return;
    }
    
    index = [sectionArr1 indexOfObject:@"车源种类"];
    code = [sectionCodeArr1 objectAtIndex:index];
    saveData = self.saveDataCodeDic[code];
    if (saveData.length <= 0) {
        [JRToast showWithText:@"请选择车源种类"];
        return;
    }
    
    index = [sectionArr1 indexOfObject:@"线索提供人"];
    code = [sectionCodeArr1 objectAtIndex:index];
    saveData = self.saveDataCodeDic[code];
    if (saveData.length <= 0) {
        [JRToast showWithText:@"请选择线索提供人"];
        return;
    }
    
    if (self.C_BY_CAR.length <= 0 && self.C_BY_A49600_C_ID.length <= 0) {
        [JRToast showWithText:@"请输入或选择出售车型"];
        return;
    }
    
    NSString *newStr = sectionArr1[6];
    if ([newStr isEqualToString:@"新购车型"]) {
        if (self.C_YX_CAR.length <= 0 && self.C_YX_A49600_C_ID.length <= 0) {
            [JRToast showWithText:@"请输入或选择新购车型"];
            return;
        }
    }
        
//        index = [sectionArr1 indexOfObject:@"车牌所在地"];
//        code = [sectionCodeArr1 objectAtIndex:index];
//        saveData = self.saveDataCodeDic[code];
//        if (saveData.length <= 0) {
//            [JRToast showWithText:@"请选择车牌所在地"];
//            return;
//        }
//
//        index = [sectionArr1 indexOfObject:@"车牌号"];
//        code = [sectionCodeArr1 objectAtIndex:index];
//        saveData = self.saveDataCodeDic[code];
//        if (saveData.length <= 0) {
//            [JRToast showWithText:@"请输入车牌号"];
//            return;
//        }
    
    
    
    

    
//    NSArray *sectionArr2 = self.cellArray[2][@"content"];
//    NSArray *sectionCodeArr2 = self.cellArray[2][@"code"];
    
    [self httpCommitSaveCarSource];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.bottomView.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)cellArray {
    if (!_cellArray) {
        _cellArray = [NSMutableArray array];
        NSArray *sectionArray0 = @[@"姓名",@"联系电话",@"性别",@"居住地址",@"追踪等级"];
        NSArray *sectionNameArray0 = @[@"C_NAME",@"C_PHONE",@"C_SEX_DD_NAME",@"C_ADDRESS",@"C_LEVEL_DD_NAME"];
        NSArray *sectionCodeArray0 = @[@"C_NAME",@"C_PHONE",@"C_SEX_DD_ID",@"C_ADDRESS",@"C_LEVEL_DD_ID"];
        [_cellArray addObject:@{@"headerTitle" : @"基本信息", @"content" : sectionArray0, @"name" : sectionNameArray0, @"code" : sectionCodeArray0}];
        
        NSMutableArray *sectionArray1 = [@[@"类型",@"车源种类",@"车源渠道",@"预计卖车时间",@"线索提供人",@"出售车型",@"车牌所在地",@"车牌号",@"上牌时间",@"里程",@"客户心理价",@"系统评估价",@"内部评估价"] mutableCopy];
        NSMutableArray *sectionNameArray1 = [@[@"C_TYPE_DD_NAME",@"C_ESC_TYPE_DD_NAME",@"C_CHANNEL_DD_NAME",@"D_YJMC_TIME",@"C_CLUEUSER_ID",@"",@"C_CPSZD_DD_NAME",@"C_CPH",@"D_SP_TIME",@"C_LC",@"C_KHXLJ",@"C_XTPGJ",@"C_NBPGJ"]mutableCopy];
        NSMutableArray *sectionCodeArray1 = [@[@"C_TYPE_DD_ID",@"C_ESC_TYPE_DD_ID",@"C_CHANNEL_DD_ID",@"D_YJMC_TIME",@"C_CLUEUSER_ID",@"",@"C_CPSZD_DD_ID",@"C_CPH",@"D_SP_TIME",@"C_LC",@"C_KHXLJ",@"C_XTPGJ",@"C_NBPGJ"]mutableCopy];
        [_cellArray addObject:@{@"headerTitle" : @"车源信息", @"content" : sectionArray1, @"name" : sectionNameArray1, @"code" : sectionCodeArray1}];
        
        NSArray *sectionArray2 = @[@"变速箱",@"排量",@"燃油类型",@"排放标准",@"年检到期",@"交强险",@"商业险到期",@"重大事故",@"火烧事故",@"泡水事故",@"备注"];
        NSArray *sectionNameArray2 = @[@"C_BSX_DD_NAME",@"C_PL_DD_NAME",@"C_RYTYPE_DD_NAME",@"C_PFBZ_DD_NAME",@"C_NJDQ",@"C_JQX",@"C_SYXDQ",@"C_ZDSG_DD_NAME",@"C_HSSG_DD_NAME",@"C_PSSG_DD_NAME",@"X_REMARK"];
        NSArray *sectionCodeArray2 = @[@"C_BSX_DD_ID",@"C_PL_DD_ID",@"C_RYTYPE_DD_ID",@"C_PFBZ_DD_ID",@"C_NJDQ",@"C_JQX",@"C_SYXDQ",@"C_ZDSG_DD_ID",@"C_HSSG_DD_ID",@"C_PSSG_DD_ID",@"X_REMARK"];
        [_cellArray addObject:@{@"headerTitle" : @"其他信息", @"content" : sectionArray2, @"name" : sectionNameArray2, @"code" : sectionCodeArray2}];
        
    }
    return _cellArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        [button setBackgroundColor:KNaviColor];
        [button setTitleNormal:@"提交"];
        [button setTitleColor:[UIColor blackColor]];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(submitAction:)];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

- (NSMutableDictionary *)saveDataCodeDic {
    if (!_saveDataCodeDic) {
        _saveDataCodeDic = [NSMutableDictionary dictionary];
    }
    return _saveDataCodeDic;
}

- (NSMutableDictionary *)saveDataNameDic {
    if (!_saveDataNameDic) {
        _saveDataNameDic = [NSMutableDictionary dictionary];
    }
    return _saveDataNameDic;
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
        };
    }
    return _tableFootPhoto;
};


@end
