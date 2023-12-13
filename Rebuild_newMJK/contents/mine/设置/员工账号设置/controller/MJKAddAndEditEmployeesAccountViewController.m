//
//  MJKAddAndEditEmployeesAccountViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddAndEditEmployeesAccountViewController.h"
#import "MJKOrganizationalViewController.h"
#import "MJKMarketViewController.h"

#import "MJKFlowProcessModel.h"
#import "MJKOrganizationalModel.h"
#import "MJKEmployeesAccountModel.h"

#import "MJKFlowProcessCustomerInfoCell.h"
#import "AddCustomerPhotoTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "DBPickerView.h"

@interface MJKAddAndEditEmployeesAccountViewController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** cellArray*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
/** 照片url*/
@property (nonatomic, strong) NSString *portraitAddress;
/** 岗位id array*/
@property (nonatomic, strong) NSMutableArray *jobIDArray;
/** 岗位name array*/
@property (nonatomic, strong) NSMutableArray *jobNameArray;
/** 组织架构id array*/
@property (nonatomic, strong) NSMutableArray *groupIDArray;
/** 组织架构name array*/
@property (nonatomic, strong) NSMutableArray *groupNameArray;
/** commit button*/
@property (nonatomic, strong) UIButton *commitButton;
/** detail model*/
@property (nonatomic, strong) MJKEmployeesAccountModel *detailModel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *detailC_ID;
@end

@implementation MJKAddAndEditEmployeesAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self initUI];
}

- (void)initUI {
    if (self.type == EmployeesAccountAdd) {
        self.title = @"新增员工账号";
    } else {
        self.title = @"编辑员工账号";
        [self HTTPAccountDetailData];
    }
    [self HTTPJobData];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.commitButton];
    
}

- (BOOL) deptIdInputShouldAlphaNum:(NSString *)str {
    NSString *regex =@"[a-zA-Z0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:str])
    {
        return YES;
        
    }
    return NO;
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.type == EmployeesAccountAdd) {
        return 1;
    } else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.dataArray[section];
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKFlowProcessModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"姓名"]) {
        //头像名字
        AddCustomerPhotoTableViewCell*cell=[AddCustomerPhotoTableViewCell cellWithTableView:tableView];
        cell.mustbeLabel.hidden = NO;
        cell.clickPortraitBlock = ^{
            weakSelf.selectedImage=0;
            [weakSelf TouchAddImage];
            
        };
        
        cell.changeTextFieldBlock = ^(NSString *currentStr) {
            MyLog(@"%@",currentStr);
            model.content=currentStr;
            model.C_ID=currentStr;
        };
        cell.nameTextField.delegate = self;
        
        if (self.portraitAddress&&![self.portraitAddress isEqualToString:@""]) {
            cell.portraitStr=self.portraitAddress;
        }
        
        if (model.content&&![model.content isEqualToString:@""]) {
            cell.nameStr=model.content;
            
        }
        
        return cell;
    } else if ([model.title isEqualToString:@"备注"]) {
        //备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=model.title;
        if (model.content&&![model.content isEqualToString:@""]) {
            cell.beforeText=model.content;
        }
        
        cell.changeTextBlock = ^(NSString *textStr) {
            model.content=textStr;
            model.C_ID=textStr;
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
    } else {
        MJKFlowProcessCustomerInfoCell *cell = [MJKFlowProcessCustomerInfoCell cellWithTableView:tableView];
        cell.titleLabel.text = model.title;
        cell.contentTF.text = model.content;
        if (self.type != EmployeesAccountAdd) {
            if ([model.title isEqualToString:@"账号"] || [model.title isEqualToString:@"创建者"] || [model.title isEqualToString:@"创建时间"] || [model.title isEqualToString:@"更新人"] || [model.title isEqualToString:@"最后修改时间"]) {
                cell.contentTF.enabled = NO;
            }
        }
        cell.contentTF.textColor = [UIColor darkGrayColor];
        if (indexPath.section == 0) {
            
            if ([model.title isEqualToString:@"账号"] || [model.title isEqualToString:@"密保手机号"] || [model.title isEqualToString:@"岗位"] || [model.title isEqualToString:@"组织架构"] ) {
                cell.mustbeLabel.hidden = NO;
            }
            if ([model.title isEqualToString:@"账号"] || [model.title isEqualToString:@"密保手机号"] || [model.title isEqualToString:@"职位"] || [model.title isEqualToString:@"微信号"] || [model.title isEqualToString:@"身份证号"] || [model.title isEqualToString:@"地址"]  || [model.title isEqualToString:@"教育程度"]) {
                cell.contentTF.hidden = NO;
                cell.contentTF.placeholder = @"请输入";
                cell.contentTF.tag = indexPath.row;
                cell.contentTF.delegate = self;
                [cell.contentTF addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
                if ([model.title isEqualToString:@"密保手机号"]) {
                    cell.contentTF.keyboardType = UIKeyboardTypePhonePad;
                }
                
                if ([model.title isEqualToString:@"教育程度"] || [model.title isEqualToString:@"地址"]) {
                    cell.textBeginEditBlock = ^{
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            CGRect frame = weakSelf.view.frame;
                            //frame.origin.y+
                            frame.origin.y = -260;
                            
                            weakSelf.view.frame = frame;
                            
                        }];
                    };
                    cell.textEndEditBlock = ^{
                        [UIView animateWithDuration:0.25 animations:^{
                            
                            CGRect frame = weakSelf.view.frame;
                            
                            frame.origin.y = 0.0;
                            
                            weakSelf.view.frame = frame;
                            
                        }];
                    };
                }
            } else {
                cell.contentTF.enabled = NO;
                cell.contentTF.hidden = NO;
                cell.contentTFRightLayout.constant = 30;
                cell.arrowImageView.hidden = NO;
                cell.contentTF.placeholder = @"请选择";
            }
        } else {
             cell.contentTF.hidden = NO;
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    [self.view endEditing:YES];
    MJKFlowProcessModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"生日"] || [model.title isEqualToString:@"入职时间"]) {
        [self selectPickerData:model andPickViewType:PickViewTypeBirthday andiIndexPath:indexPath andDataArray:nil andBackBlock:nil];
    } else if ([model.title isEqualToString:@"籍贯"]) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"02cities" ofType:@"plist"]];
        [self selectPickerData:model andPickViewType:PickViewTypeAddress andiIndexPath:indexPath andDataArray:array andBackBlock:nil];
    } else if ([model.title isEqualToString:@"岗位"]) {
        [self selectPickerData:model andPickViewType:PickViewTypeArray andiIndexPath:indexPath andDataArray:self.jobNameArray andBackBlock:^(NSString *index) {
            model.C_ID = weakSelf.jobIDArray[index.intValue];
        }];
    } else if ([model.title isEqualToString:@"组织架构"]) {
        MJKOrganizationalViewController *vc = [[MJKOrganizationalViewController alloc]init];
        vc.selectOrganizationalModelBlock = ^(MJKOrganizationalModel * _Nonnull model1) {
            model.C_ID = model1.C_U00100_C_ID;
            model.content = model1.C_U00100_C_NAME;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.title isEqualToString:@"性别"]) {
        NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SEX"];
        NSMutableArray*mtArray=[NSMutableArray array];
        NSMutableArray*postArray=[NSMutableArray array];
        for (MJKDataDicModel*model in dataArray) {
            [mtArray addObject:model.C_NAME];
            [postArray addObject:model.C_VOUCHERID];
        }
        [self selectPickerData:model andPickViewType:PickViewTypeArray andiIndexPath:indexPath andDataArray:mtArray andBackBlock:^(NSString *index) {
            model.C_ID = postArray[index.intValue];
        }];
        
    } else if ([model.title isEqualToString:@"汇报上级"]) {
        MJKMarketViewController *vc = [[MJKMarketViewController alloc]init];
        vc.vcName = @"订单";
        vc.backSelectParameterBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr) {
            model.C_ID = codeStr;
            model.content = nameStr;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKFlowProcessModel *model = self.dataArray[indexPath.section][indexPath.row];
    if ([model.title isEqualToString:@"姓名"]) {
        return 70;
    }
    if ([model.title isEqualToString:@"备注"]) {
        return 120;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 20)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.f];
    if (section == 0) {
        label.text = @"基础信息";
    } else {
        label.text = @"操作信息";
    }
    [bgView addSubview:label];
    
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 提交
- (void)commitButtonAction:(UIButton *)sender {
//    if (self.portraitAddress.length <= 0) {
//        [JRToast showWithText:@"请选择头像"];
//        return;
//    }
    for (MJKFlowProcessModel *model in self.dataArray[0]) {
        if (model.C_ID.length <= 0) {
            if ([model.title isEqualToString:@"姓名"]) {
                [JRToast showWithText:@"请输入姓名"];
                return;
            }
            if ([model.title isEqualToString:@"账号"]) {
                [JRToast showWithText:@"请输入账号"];
                return;
            }
            if ([model.title isEqualToString:@"密保手机号"]) {
                [JRToast showWithText:@"请输入密保手机号"];
                return;
            }
            if ([model.title isEqualToString:@"岗位"]) {
                [JRToast showWithText:@"请选择岗位"];
                return;
            }
            if ([model.title isEqualToString:@"组织架构"]) {
                [JRToast showWithText:@"请选择组织架构"];
                return;
            }
        }
    }
    [self HTTPAddJobData];
    
}

#pragma mark - UITextFieldDelegete
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.tag == 1 || textField.tag == 8) {
        if ([self deptIdInputShouldAlphaNum:string]) {
            return NO;
        }
    }
    
    MJKFlowProcessModel *model = self.dataArray[0][textField.tag];
    if ([model.title isEqualToString:@"密保手机号"]) {
        if (textField.text.length >= 11) {
            return NO;
        }
    }
    return YES;
}

- (void)textChange:(UITextView *)tf {
    MJKFlowProcessModel *model = self.dataArray[0][tf.tag];
    model.content = tf.text;
    model.C_ID = tf.text;
}

#pragma mark  -- delegate
//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //    定义一个newPhoto，用来存放我们选择的图片。
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    NSData*data=UIImageJPEGRepresentation(newPhoto, 0.1);
    
    //    //吊接口  照片
    //    UITableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    //    UIImageView*imageView=[cell viewWithTag:111];
    //    imageView.image=newPhoto;
    
    
    if (self.selectedImage==0) {
        //头像
        AddCustomerPhotoTableViewCell*cell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.imageButton setBackgroundImage:newPhoto forState:UIControlStateNormal];
        
        
        [self HttpPostOneImageToJiekouWith:data];
        
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//上传一张照片
-(void)HttpPostOneImageToJiekouWith:(NSData*)data{
    DBSelf(weakSelf);
    NSString*urlStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            weakSelf.portraitAddress=data[@"show_url"];
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - select data
- (void)selectPickerData:(MJKFlowProcessModel *)model andPickViewType:(PickViewType)type andiIndexPath:(NSIndexPath *)indexPath andDataArray:(NSArray *)array andBackBlock:(void(^)(NSString *index))backBlock {
    DBSelf(weakSelf);
    DBPickerView *pickerView = [[DBPickerView alloc]initWithFrame:self.view.frame andCurrentType:type andmtArrayDatas:[array mutableCopy] andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
        model.content = title;
        if (type == PickViewTypeArray) {
            if (backBlock) {
                backBlock(indexStr);
            }
        } else {
            model.C_ID = title;
        }
        [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    [self.view addSubview:pickerView];
}

#pragma mark - http
- (void)HTTPAccountDetailData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getBeanById"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = self.userid;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.detailModel = [MJKEmployeesAccountModel mj_objectWithKeyValues:data];
            NSDictionary *dic = [data copy];
            weakSelf.detailC_ID = dic[@"C_ID"];
            for (MJKFlowProcessModel *model in self.dataArray[0]) {
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([model.nameCode isEqualToString:key]) {
//                        model.C_ID = obj;
                        model.content = obj;
                        
                    }
                    if ([model.code isEqualToString:key]) {
                        model.C_ID = obj;
//                        model.content = obj;
                        
                    }
                }];
            }
            for (MJKFlowProcessModel *model in self.dataArray[1]) {
                [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if ([model.nameCode isEqualToString:key]) {
                        //                        model.C_ID = obj;
                        model.content = obj;
                        
                    }
                    if ([model.code isEqualToString:key]) {
                        model.C_ID = obj;
                        //                        model.content = obj;
                        
                    }
                }];
            }
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)HTTPJobData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"UserWebService-getPositionList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray *arr = data[@"content"];
            for (int i = 0; i < [arr count]; i++) {
                NSDictionary *dic = arr[i];
                [weakSelf.jobIDArray addObject:dic[@"C_U00300_C_ID"]];
                [weakSelf.jobNameArray addObject:dic[@"C_U00300_C_NAME"]];
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)HTTPAddJobData {
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:self.type == EmployeesAccountAdd ? @"UserWebService-insertAccount" : @"UserWebService-updateAccount"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if (self.type == EmployeesAccountEdit) {
        dic[@"C_ID"] = weakSelf.detailC_ID;
    }
    if (self.portraitAddress.length > 0) {
        [dic setObject:self.portraitAddress forKey:@"C_HEADIMGURL"];
    }
    for (MJKFlowProcessModel *model in self.dataArray[0]) {
        if (model.C_ID.length > 0) {
            if ([model.code isEqualToString:@"D_BIRTHDAY"] || [model.code isEqualToString:@"D_WORKTIME"]) {
                [dic setObject:[NSString stringWithFormat:@"%@ 00:00:00",model.C_ID] forKey:model.code];
            } else {
                [dic setObject:model.C_ID forKey:model.code];
            }
        }
    }
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [[NSUserDefaults standardUserDefaults]setObject:@"yes" forKey:@"refresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.commitButton.frame.size.height) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *section0Array = [NSMutableArray array];
        for (int i = 0; i < 16; i++) {
            MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
            model.title = @[@"姓名",@"账号",@"密保手机号",@"岗位",@"组织架构",@"汇报上级",@"职位",@"微信号",@"身份证号",@"性别",@"生日",@"籍贯",@"地址",@"教育程度",@"入职时间",@"备注"][i];
            model.code = @[@"C_NAME",@"C_ACCOUNTNAME",@"C_MOBILENUMBER",@"C_U00300_C_ID",@"C_U00100_C_ID",@"C_U03100_C_ID",@"C_POSITION",@"C_WECHAT",@"C_IDENTITYCODE",@"C_GENDER_DD_ID",@"D_BIRTHDAY",@"C_NATIVEPLACE",@"C_ADDRESS",@"C_EDUCATION",@"D_WORKTIME",@"X_REMARK"][i];
            model.nameCode = @[@"C_NAME",@"C_ACCOUNTNAME",@"C_MOBILENUMBER",@"C_U00300_C_NAME",@"C_U00100_C_NAME",@"C_U03100_C_NAME",@"C_POSITION",@"C_WECHAT",@"C_IDENTITYCODE",@"C_GENDER_DD_NAME",@"D_BIRTHDAY",@"C_NATIVEPLACE",@"C_ADDRESS",@"C_EDUCATION",@"D_WORKTIME",@"X_REMARK"][i];
            if ([model.title isEqualToString:@"姓名"] || [model.title isEqualToString:@"账号"] || [model.title isEqualToString:@"密保手机号"] || [model.title isEqualToString:@"职位"] || [model.title isEqualToString:@"微信号"] || [model.title isEqualToString:@"身份证号"] || [model.title isEqualToString:@"地址"] || [model.title isEqualToString:@"教育程度"]) {
                model.isEdit = YES;
            } else {
                model.isGo = YES;
            }
            [section0Array addObject:model];
        }
        
        NSMutableArray *section1Array = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            MJKFlowProcessModel *model = [[MJKFlowProcessModel alloc]init];
            model.title = @[@"创建者",@"创建时间",@"更新人",@"最后修改时间"][i];
            model.nameCode = @[@"C_CREATOR_ROLENAME",@"D_CREATE_TIME",@"C_MENDER_ROLENAME",@"D_LASTUPDATE_TIME"][i];
            model.isData = YES;
            [section1Array addObject:model];
        }
        [_dataArray addObject:section0Array];
        [_dataArray addObject:section1Array];
    }
    return _dataArray;
}

- (NSMutableArray *)jobIDArray {
    if (!_jobIDArray) {
        _jobIDArray = [NSMutableArray array];
    }
    return _jobIDArray;
}

- (NSMutableArray *)jobNameArray {
    if (!_jobNameArray) {
        _jobNameArray = [NSMutableArray array];
    }
    return _jobNameArray;
}

- (NSMutableArray *)groupIDArray {
    if (!_groupIDArray) {
        _groupIDArray = [NSMutableArray array];
    }
    return _groupIDArray;
}

- (NSMutableArray *)groupNameArray {
    if (!_groupNameArray) {
        _groupNameArray = [NSMutableArray array];
    }
    return _groupNameArray;
}

- (UIButton *)commitButton {
    if (!_commitButton) {
        _commitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - 50, KScreenWidth, 50)];
        [_commitButton setTitleNormal:@"提交"];
        [_commitButton setTitleColor:[UIColor blackColor]];
        _commitButton.backgroundColor = KNaviColor;
        [_commitButton addTarget:self action:@selector(commitButtonAction:)];
    }
    return _commitButton;
}

@end
