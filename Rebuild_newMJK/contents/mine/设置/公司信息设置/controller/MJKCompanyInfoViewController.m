//
//  MJKCompanyInfoViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCompanyInfoViewController.h"

#import "MJKCompanyAddressTableViewCell.h"
#import "AddCustomerInputTableViewCell.h"
#import "MJKCompanyInfoTableViewCell.h"
#import "MJKPhotoView.h"

#import "MJKCompanyInfoModel.h"
@interface MJKCompanyInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong)  MJKCompanyAddressTableViewCell *addressCell;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *imageUrlArray;
/** <#注释#>*/
@property (nonatomic, strong) MJKCompanyInfoModel *infoModel;

@end

@implementation MJKCompanyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"公司信息设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self getCompanyData];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.row == 0) {
        if (self.infoModel != nil) {
            self.addressCell.model = self.infoModel;
        }
        self.addressCell.textChangeBlock = ^(NSString * _Nonnull str) {
            weakSelf.infoModel.C_ADDRESS = str;
        };
        return self.addressCell;
    } else if (indexPath.row == 1){
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.titleLeftLayout.constant = 10;
        cell.tagLabel.hidden = YES;
        cell.inputTextField.keyboardType=UIKeyboardTypePhonePad;
        cell.inputTextField.placeholder = @"请输入";
        cell.nameTitleLabel.text=@"公司电话";   //标题
        cell.textStr = self.infoModel.X_PHONE;
        cell.changeTextBlock = ^(NSString *textStr) {
            MyLog(@"%@",textStr);
            weakSelf.infoModel.X_PHONE = textStr;
        };
        return cell;
    } else {
        MJKCompanyInfoTableViewCell *cell = [MJKCompanyInfoTableViewCell cellWithTableView:tableView];
        cell.infoTextView.text = self.infoModel.X_REMARK;
        cell.textChangeBlock = ^(NSString * _Nonnull str) {
            weakSelf.infoModel.X_REMARK = str;
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 44;
    } else {
        return 250;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.infoModel.urlList.count > 0) {
        self.tableFootPhoto.imageURLArray = self.infoModel.urlList;
    }
    return self.tableFootPhoto;
}

- (void)commitButtonAction {
    if (self.infoModel.C_ADDRESS.length <= 0) {
        [JRToast showWithText:@"请输入地址"];
        return;
    }
    if (self.infoModel.X_PHONE.length <= 0) {
        [JRToast showWithText:@"请输入电话"];
        return;
    }
    if (self.infoModel.X_REMARK.length <= 0) {
        [JRToast showWithText:@"请输入简介"];
        return;
    }
    [self updateCompanyData];
}

- (void)getCompanyData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A40300WebService-getBeanById"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.infoModel = [MJKCompanyInfoModel mj_objectWithKeyValues:data];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (void)updateCompanyData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A40300WebService-updateBeanById"];
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    dic[@"C_ID"] = self.infoModel.C_ID;
    if (self.infoModel.C_ADDRESS.length > 0) {
        dic[@"C_ADDRESS"] = self.infoModel.C_ADDRESS;
    }
    if (self.infoModel.X_REMARK.length > 0) {
        dic[@"X_REMARK"] = self.infoModel.X_REMARK;
    }
    if (self.infoModel.B_GSDZ_LAT.length > 0) {
        dic[@"B_GSDZ_LAT"] = self.infoModel.B_GSDZ_LAT;
    }
    if (self.infoModel.B_GSDZ_LON.length > 0) {
        dic[@"B_GSDZ_LON"] = self.infoModel.B_GSDZ_LON;
    }
    if (self.infoModel.urlList.count > 0) {
        dic[@"urlList"] = self.infoModel.urlList;
    }
    if (self.infoModel.X_PHONE.length > 0) {
        dic[@"X_PHONE"] = self.infoModel.X_PHONE;
    }
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
//31.301945,121.526602

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}


- (MJKCompanyAddressTableViewCell *)addressCell {
    if (!_addressCell) {
        _addressCell = [[NSBundle mainBundle]loadNibNamed:@"MJKCompanyAddressTableViewCell" owner:nil options:nil].firstObject;
    }
    return _addressCell;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        [button setBackgroundColor:KNaviColor];
        [button setTitleColor:[UIColor blackColor]];
        [button setTitleNormal:@"提交"];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(commitButtonAction)];
        button.layer.cornerRadius = 5.f;
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
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
