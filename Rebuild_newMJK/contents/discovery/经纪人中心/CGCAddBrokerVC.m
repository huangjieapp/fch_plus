//
//  CGCAddBrokerVC.m
//  Rebuild_newMJK
//
//  Created by FishYu on 2018/7/18.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "CGCAddBrokerVC.h"
#import "AddBrokerCell.h"
#import "DBPickerView.h"
#import "ASBirthSelectSheet.h"
#import "DBPickerView.h"
#import "AddCustomerPhotoTableViewCell.h"
#import "MJKMembersDetailModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface CGCAddBrokerVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIView *footView;

@property(nonatomic,assign)NSInteger selectedImage;  //点击的是哪个 图片按钮    11 22 33 还有其他   0
/** <#注释#>*/
@property (nonatomic, strong) MJKMembersDetailModel *detailModel;
/** bottom view*/
@property (nonatomic, strong) UIView *bottomView;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *cellArray;

@end

@implementation CGCAddBrokerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    if (self.type == CGCAddBrokerAdd) {
        self.title=@"新增粉丝";
        self.detailModel = [[MJKMembersDetailModel alloc]init];
        if (self.model.C_FSLX_DD_ID.length > 0) {
            self.detailModel.C_FSLX_DD_ID = self.model.C_FSLX_DD_ID;
        }
        if (self.model.name.length > 0) {
            self.detailModel.C_NAME = self.model.name;
        }
        if (self.model.tel.length > 0) {
            self.detailModel.C_PHONE = self.model.tel;
        }
        if (self.model.sexID.length > 0) {
            self.detailModel.C_SEX_DD_ID = self.model.sexID;
            self.detailModel.C_SEX_DD_NAME = self.model.sex;
        }
        if (self.model.adress.length > 0) {
            self.detailModel.C_ENGLISHNAME = self.model.adress;
        }
        if (self.model.lxID.length > 0) {
            self.detailModel.C_TYPE_DD_ID = self.model.lxID;
            self.detailModel.C_TYPE_DD_NAME = self.model.leixing;
        }
    } else {
        if ([[NewUserSession instance].appcode containsObject:@"APP015_0004"]) {
            self.title=@"编辑粉丝";
        } else {
            self.title = @"粉丝详情";
        }
        [self httpMemberDetail];
    }
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.cellArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DBSelf(weakSelf);
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"客户姓名"]) {
        //头像名字
        AddCustomerPhotoTableViewCell*cell=[AddCustomerPhotoTableViewCell cellWithTableView:tableView];
        cell.clickPortraitBlock = ^{
            weakSelf.selectedImage=0;
            [weakSelf TouchAddImage];
            
        };
        
        cell.changeTextFieldBlock = ^(NSString *currentStr) {
            MyLog(@"%@",currentStr);
            weakSelf.detailModel.C_NAME=currentStr;
        };
        
        
        
        if (self.portraitAddress&&![self.portraitAddress isEqualToString:@""]) {
            cell.portraitStr=self.portraitAddress;
        }
        
        if ( self.detailModel.C_NAME.length > 0) {
            cell.nameStr=self.detailModel.C_NAME;
            
        }
        if (self.type != CGCAddBrokerAdd) {
            if (![[NewUserSession instance].appcode containsObject:@"APP015_0004"]) {
                cell.nameTextField.enabled = NO;
                cell.imageButton.enabled = NO;
            }
        }
        
        return cell;
    } else if ([cellStr isEqualToString:@"手机号码"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.delegate=self;
        cell.tagLabel.hidden = NO;
        cell.inputTextField.placeholder = @"请输入手机号";
        cell.nameTitleLabel.text=cellStr;   //标题
        cell.inputTextField.keyboardType=UIKeyboardTypePhonePad;
        cell.textFieldLength=11;
        if (self.detailModel.C_PHONE.length > 0) {
            cell.textStr = self.detailModel.C_PHONE;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.C_PHONE = textStr;
        };
        
        
        return cell;
    } else if ([cellStr isEqualToString:@"微信号"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        
        if (self.detailModel.C_WECHAT.length > 0) {
            cell.textStr = self.detailModel.C_WECHAT;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.C_WECHAT = textStr;
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"粉丝类型"]){
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = cellStr;
        cell.taglabel.hidden = NO;
        if (self.detailModel.C_TYPE_DD_ID.length > 0) {
            cell.textStr = self.detailModel.C_TYPE_DD_NAME;
        }
        if ([self.detailModel.C_FSLX_DD_ID isEqualToString:@"1"]) {
            cell.chooseTextField.enabled = NO;
        } else {
            cell.chooseTextField.enabled = YES;
        }
        cell.C_TYPECODE = @"A47700_C_TYPE";
        cell.Type = ChooseTableViewTypeA81500_WXRYTYPE;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.detailModel.C_TYPE_DD_NAME = str;
            weakSelf.detailModel.C_TYPE_DD_ID = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else if ([cellStr isEqualToString:@"粉丝等级"]){
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = cellStr;
        cell.taglabel.hidden = NO;
        if (self.detailModel.C_LEVEL_DD_ID.length > 0) {
            cell.textStr = self.detailModel.C_LEVEL_DD_NAME;
        }
        cell.Type = ChooseTableViewTypeFansLevel;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.detailModel.C_LEVEL_DD_NAME = str;
            weakSelf.detailModel.C_LEVEL_DD_ID = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else if ([cellStr isEqualToString:@"公司名称"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        cell.tagLabel.hidden = NO;
        if (self.detailModel.C_COMPANY.length > 0) {
            cell.textStr = self.detailModel.C_COMPANY;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.C_COMPANY = textStr;
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"行业"]) {
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = cellStr;
        cell.taglabel.hidden = NO;
        if (self.detailModel.C_INDUSTRY_DD_ID.length > 0) {
            cell.textStr = self.detailModel.C_INDUSTRY_DD_NAME;
        }
        cell.Type = ChooseTableViewTypeFansHY;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.detailModel.C_INDUSTRY_DD_NAME = str;
            weakSelf.detailModel.C_INDUSTRY_DD_ID = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else if ([cellStr isEqualToString:@"职位"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        cell.tagLabel.hidden = NO;
        if (self.detailModel.C_INDUSTRY.length > 0) {
            cell.textStr = self.detailModel.C_INDUSTRY;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.C_INDUSTRY = textStr;
        };
        cell.tfBeginEditBlock = ^(NSString *text) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                //frame.origin.y+
                frame.origin.y = -180;
                
                self.view.frame = frame;
                
            }];
        };
        cell.tfEndEditBlock = ^(NSString *text) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                
                frame.origin.y = 0.0;
                
                self.view.frame = frame;
                
            }];
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"介绍客户数"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        cell.inputTextField.enabled = NO;
        cell.inputTextField.placeholder = @"";
        if (self.detailModel.C_JSKHS.length > 0) {
            cell.textStr = self.detailModel.C_JSKHS;
        }
        
        return cell;
    } else if ([cellStr isEqualToString:@"性别"]){
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = cellStr;
        if (self.detailModel.C_SEX_DD_ID.length > 0) {
            cell.textStr = self.detailModel.C_SEX_DD_NAME;
        }
        cell.Type = ChooseTableViewTypeGender;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.detailModel.C_SEX_DD_NAME = str;
            weakSelf.detailModel.C_SEX_DD_ID = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"纪念日"]){
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = cellStr;
        if (self.detailModel.D_ANNIVERSARY_TIME.length > 0) {
            cell.textStr = self.detailModel.D_ANNIVERSARY_TIME;
        }
        cell.Type = ChooseTableViewTypeBirthday;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.detailModel.D_ANNIVERSARY_TIME = str;
            weakSelf.detailModel.D_ANNIVERSARY_TIME = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"生日"]){
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = cellStr;
        if (self.detailModel.D_BIRTHDAY_TIME.length > 0) {
            cell.textStr = self.detailModel.D_BIRTHDAY_TIME;
        }
        cell.Type = ChooseTableViewTypeBirthday;
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.detailModel.D_BIRTHDAY_TIME = str;
            weakSelf.detailModel.D_BIRTHDAY_TIME = postValue;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else if ([cellStr isEqualToString:@"地址"]) {
        
        //         AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        //        UIButton*findCopyButton=[cell viewWithTag:110];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        
        if (self.detailModel.C_ENGLISHNAME.length > 0) {
            cell.textStr = self.detailModel.C_ENGLISHNAME;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.C_ENGLISHNAME = textStr;
        };
        cell.tfBeginEditBlock = ^(NSString *text) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                self.view.frame = frame;
                
            }];
        };
        cell.tfEndEditBlock = ^(NSString *text) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                
                frame.origin.y = 0.0;
                
                self.view.frame = frame;
                
            }];
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"爱好"]) {
        
        //         AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        //        UIButton*findCopyButton=[cell viewWithTag:110];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        
        if (self.detailModel.C_HOBBY.length > 0) {
            cell.textStr = self.detailModel.C_HOBBY;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.C_HOBBY = textStr;
        };
        cell.tfBeginEditBlock = ^(NSString *text) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                //frame.origin.y+
                frame.origin.y = -260;
                
                self.view.frame = frame;
                
            }];
        };
        cell.tfEndEditBlock = ^(NSString *text) {
            [UIView animateWithDuration:0.25 animations:^{
                
                CGRect frame = self.view.frame;
                
                frame.origin.y = 0.0;
                
                self.view.frame = frame;
                
            }];
        };
        
        return cell;
    } else if ([cellStr isEqualToString:@"小程序开通状态"]) {
        
        //         AddCustomerInputTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:inputCell];
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        //        UIButton*findCopyButton=[cell viewWithTag:110];
        cell.inputTextField.delegate=self;
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=cellStr;   //标题
        cell.inputTextField.enabled = NO;
        cell.inputTextField.placeholder = @"";
        if (self.detailModel.C_STATUS_DD_NAME.length > 0) {
            cell.textStr = self.detailModel.C_STATUS_DD_NAME;
        }
        
        return cell;
    } else if ([cellStr isEqualToString:@"备注"]) {
        //预约备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=cellStr;
        if (self.detailModel.X_REMARK.length > 0) {
            cell.textView.text = self.detailModel.X_REMARK;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.detailModel.X_REMARK = textStr;
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
        
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"客户姓名"]) {
        return 80;
    } else if ([cellStr isEqualToString:@"备注"]) {
        return 120;
    }
    return 44;
}

- (void)navAction:(UIButton *)sender {
    if (self.detailModel.C_ENGLISHNAME.length <= 0) {
        [JRToast showWithText:@"暂无客户地址"];
        return;
    }
    MJKMapNavigationViewController *alertVC = [MJKMapNavigationViewController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    alertVC.C_ADDRESS = self.detailModel.C_ENGLISHNAME;
    [self presentViewController:alertVC animated:YES completion:nil];
}


- (void)httpSubmitData{
    
    
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    NSString *actionStr;
    if (self.type == CGCAddBrokerAdd) {
        actionStr = [NSString stringWithFormat:@"%@/api/crm/a477/add",HTTP_IP];
    } else {
        actionStr = [NSString stringWithFormat:@"%@/api/crm/a477/edit",HTTP_IP];
        [dic setObject:self.detailModel.C_ID forKey:@"C_ID"];
    }
    
    if (self.C_A41500_C_IDStr.length > 0) {

        [dic setObject:self.C_A41500_C_IDStr forKey:@"C_A41500_C_ID"];
    }

    if (self.portraitAddress.length > 0) {
        //C_HEADIMGURL
        [dic setObject:self.portraitAddress forKey:@"C_HEADIMGURL"];
    }

    if (self.detailModel.C_NAME.length <= 0) {
        [JRToast showWithText:@"请输入粉丝姓名"];
        return;;
    }
    if (self.detailModel.C_PHONE.length <= 0) {
        [JRToast showWithText:@"请选输入手机号码"];
        return;;
    }
    if (self.detailModel.C_FSLX_DD_ID.length <= 0) {
        [JRToast showWithText:@"请选择粉丝类型"];
        return;;
    }
    if (self.detailModel.C_LEVEL_DD_ID.length <= 0) {
        [JRToast showWithText:@"请选择粉丝等级"];
        return;;
    }
    if (self.detailModel.C_COMPANY.length <= 0) {
        [JRToast showWithText:@"请输入公司名称"];
        return;;
    }
    if (self.detailModel.C_INDUSTRY_DD_ID.length <= 0) {
        [JRToast showWithText:@"请输入行业"];
        return;;
    }
    if (self.detailModel.C_INDUSTRY.length <= 0) {
        [JRToast showWithText:@"请输入职位"];
        return;;
    }
    NSMutableDictionary *contentDic = [self.detailModel mj_keyValues];
    [contentDic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *   _Nonnull obj, BOOL * _Nonnull stop) {
        if (![key isEqualToString:@"labelsList"]) {
            if (obj.length > 0) {
//                if ([[key substringWithRange:NSMakeRange(key.length - 4, 4)] isEqualToString:@"TIME"]) {
//                    dic[key] = [obj stringByAppendingString:@" 00:00:00"];
//                } else {
                    dic[key] = obj;
//                }
            }
        }
        
    }];
    
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager postNewDataFromNetworkNoHudWithUrl:actionStr parameters:dic compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            
          
            if (self.addBlock) {
                self.addBlock();
            }
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [JRToast showWithText:data[@"msg"]];
            
        }
        
        
       
        
    }];
    
    
    
}

- (void)httpMemberDetail {
    DBSelf(weakSelf);
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    
    if (self.c_id.length > 0) {
        [dic setObject:self.c_id forKey:@"C_ID"];
    }
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a477/info", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        
        if ([data[@"code"] integerValue]==200) {
            weakSelf.detailModel = [MJKMembersDetailModel mj_objectWithKeyValues:data[@"data"]];
            if (weakSelf.detailModel.C_ACCOUNTHOLDER.length > 0) {
                weakSelf.portraitAddress = self.detailModel.C_ACCOUNTHOLDER;
            }
            [weakSelf.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
            
        }
    }];
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
        
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - 55) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor=[UIColor whiteColor];
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton * btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(10, 5, KScreenWidth - 20, 45);
        [btn setTitleNormal:@"提交"];
        btn.layer.cornerRadius = 5.f;
        [btn addTarget:self action:@selector(httpSubmitData)];
        [btn setBackgroundColor:KNaviColor];
        [btn setTitleColor:[UIColor blackColor]];
        if (self.type == CGCAddBrokerAdd) {
            [_bottomView addSubview:btn];
        } else {
            if ([[NewUserSession instance].appcode containsObject:@"APP015_0004"]) {
                [_bottomView addSubview:btn];
            }
        }
    }
    return _bottomView;
}

- (NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"客户姓名",@"手机号码",@"微信号",@"粉丝类型",@"粉丝等级",@"公司名称",@"行业",@"职位",@"介绍客户数",@"性别",@"纪念日",@"生日",@"地址",@"爱好",@"小程序开通状态",@"备注"];
    }
    return _cellArray;
}

@end
