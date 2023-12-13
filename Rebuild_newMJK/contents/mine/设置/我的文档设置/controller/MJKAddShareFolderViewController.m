//
//  MJKAddShareFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAddShareFolderViewController.h"
#import "MJKChooseMoreEmployeesViewController.h"

#import "MJKTypeFolderModel.h"

#import "AddCustomerChooseTableViewCell.h"

@interface MJKAddShareFolderViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** tf*/
@property (nonatomic, strong) UITextField *folderTF;
/** cellArray*/
@property (nonatomic, strong) NSArray *cellArray;
/** bottomview*/
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation MJKAddShareFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"新增共享文件";
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.folderTF];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSString *cellStr = self.cellArray[indexPath.row];
    AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
    cell.titleLeftLayout.constant = 10;
    cell.taglabel.hidden=NO;
    cell.titleBGView.hidden = YES;
    cell.chooseTextField.textColor = [UIColor blackColor];
    cell.nameTitleLabel.text=cellStr;
    if ([cellStr isEqualToString:@"文件类型"]) {
        cell.Type = ChooseTableViewTypeFolderType;
        cell.chooseTextField.text = self.model.C_WJGSNAME;
    } else {
        cell.Type = chooseTypeNil;
        if ([cellStr isEqualToString:@"查看权限员工"]) {
            cell.chooseTextField.text = self.model.X_CKQX_NAME;
        } else if ([cellStr isEqualToString:@"修改权限员工"]) {
            cell.chooseTextField.text = self.model.X_XGQX_NAME;
        }
    }
    cell.chooseBlock = ^(NSString *str, NSString *postValue) {
        if ([cellStr isEqualToString:@"文件类型"]) {
            self.model.C_WJGS = postValue;
            self.model.C_WJGSNAME = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        } else {
            MJKChooseMoreEmployeesViewController *vc = [[MJKChooseMoreEmployeesViewController alloc]init];
            if ([cellStr isEqualToString:@"查看权限员工"]) {
                vc.codeStr = weakSelf.model.X_CKQX;
            } else if ([cellStr isEqualToString:@"修改权限员工"]) {
                vc.codeStr = weakSelf.model.X_XGQX;
            }
            vc.noticeStr = @"无提示";
            vc.chooseEmployeesBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull u051CodeStr) {
                    
                if ([cellStr isEqualToString:@"查看权限员工"]) {
                    weakSelf.model.X_CKQX = codeStr;
                    weakSelf.model.X_CKQX_NAME = nameStr;
                } else if ([cellStr isEqualToString:@"修改权限员工"]) {
                    weakSelf.model.X_XGQX = codeStr;
                    weakSelf.model.X_XGQX_NAME = nameStr;
                }
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - http data
- (void)httpInsertOrEditData {
    NSString *actionStr;
    NSString *C_ID;
    if (self.type == ShareFolderAdd) {
        actionStr = @"A70800WebService-insert";
        C_ID = [DBObjectTools getA70800C_id];
    } else {
        actionStr = @"A70800WebService-update";
        C_ID = self.model.C_ID;
    }
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    tempDic[@"C_ID"] =  C_ID;
    if (self.model.C_NAME.length > 0) {
        tempDic[@"C_NAME"] = self.model.C_NAME;
    }
    if (self.model.C_A70600_C_ID.length > 0) {
        tempDic[@"C_A70600_C_ID"] = self.model.C_A70600_C_ID;
    }
    if (self.model.C_A70600_C_NAME.length > 0) {
        tempDic[@"C_A70600_C_NAME"] = self.model.C_A70600_C_NAME;
    }
    if (self.model.X_CKQX.length > 0) {
        tempDic[@"X_CKQX"] = self.model.X_CKQX;
    }
    if (self.model.X_XGQX.length > 0) {
        tempDic[@"X_XGQX"] = self.model.X_XGQX;
    }
    if (self.model.C_WJGS.length > 0) {
        tempDic[@"C_WJGS"] = self.model.C_WJGS;
    }
    if ([self.vcName isEqualToString:@"个人文档"]) {
        tempDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0003";
    } else {
        tempDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0001";
    }
    [dict setObject:tempDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - button click
- (void)buttonAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"确定"]) {
        if (self.model.C_NAME.length <= 0) {
            [JRToast showWithText:@"请输入文件名称"];
            return;
        }
        if (self.model.C_WJGS.length <= 0) {
            [JRToast showWithText:@"请选择文件类型"];
            return;
        }
        if (self.model.X_CKQX.length <= 0) {
            [JRToast showWithText:@"请选择查看权限员工"];
            return;
        }
        if (self.model.X_XGQX.length <= 0) {
            [JRToast showWithText:@"请选择修改权限员工"];
            return;
        }
        [self httpInsertOrEditData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)changeYText:(UITextField *)sender {
    self.model.C_NAME = sender.text;
}

#pragma mark - set
- (UITextField *)folderTF {
    if (!_folderTF) {
        UILabel *usernameLeftView = [[UILabel alloc] initWithFrame:CGRectMake(0.f, 0.f, 10.f, 0.f)];
        usernameLeftView.backgroundColor = [UIColor clearColor];
        
        _folderTF = [[UITextField alloc]initWithFrame:CGRectMake(10, SafeAreaTopHeight + 10, KScreenWidth - 20, 50)];
        _folderTF.layer.cornerRadius = 5.f;
        _folderTF.font = [UIFont systemFontOfSize:14.f];
        _folderTF.leftView = usernameLeftView;
        _folderTF.leftViewMode = UITextFieldViewModeAlways;
        _folderTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _folderTF.placeholder = @"请输入共享文件名称";
        _folderTF.backgroundColor = kBackgroundColor;
        [_folderTF addTarget:self action:@selector(changeYText:) forControlEvents:UIControlEventEditingChanged];
        if (self.type == ShareFolderEdit) {
            if (self.model.C_NAME.length > 0) {
                _folderTF.text = self.model.C_NAME;
            }
        }
    }
    return _folderTF;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.folderTF.frame) + 10, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - 20 - self.folderTF.frame.size.height - 55 - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(5, KScreenHeight - 50, KScreenWidth - 10, 45)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        for (int i = 0; i < 2; i++) {
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((_bottomView.frame.size.width / 2) * i  , 0, _bottomView.frame.size.width / 2, 45)];
            [button setTitleNormal:@[@"取消",@"确定"][i]];
            [button setBackgroundColor:@[kBackgroundColor, KNaviColor][i]];
            [button setTitleColor:[UIColor blackColor]];
            [button addTarget:self action:@selector(buttonAction:)];
            [_bottomView addSubview:button];
        }
        _bottomView.layer.cornerRadius = 5.f;
        _bottomView.layer.masksToBounds = YES;
    }
    return _bottomView;
}

- (NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"文件类型", @"查看权限员工", @"修改权限员工"];
    }
    return _cellArray;
}

@end
