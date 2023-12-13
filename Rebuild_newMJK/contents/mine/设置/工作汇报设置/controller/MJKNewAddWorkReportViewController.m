//
//  MJKPKAddAndDetailViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKNewAddWorkReportViewController.h"
#import "MJKConfigWorkReportViewController.h"

#import "MJKPKGroupPeopleModel.h"
#import "MJKPKModel.h"
#import "MJKDataDicModel.h"

#import "MJKGroupPeopleTableViewCell.h"
#import "MJKPKAddOrEditTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"

#import "HooDatePicker.h"

@interface MJKNewAddWorkReportViewController ()<UITableViewDataSource, UITableViewDelegate,HooDatePickerDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImage *groupImage;
//@property (nonatomic, strong) NSString *bathDayStr;
@property (nonatomic, strong) NSString *groupNameStr;
@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, strong) MJKPKModel *PKModel;
@property (nonatomic, strong) HooDatePicker *datePicker;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *workArray;
@end

@implementation MJKNewAddWorkReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    if (self.C_ID.length > 0) {
        self.title = @"编辑汇报模板";
    } else {
        self.title = @"新增汇报模板";
    }
    
//    [self initRightNavigationItem];
    [self.view addSubview:self.bottomView];
    [self getGroupPeopleListDatas];
    [self.view addSubview:self.tableview];
}

- (void)initRightNavigationItem {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    button.tag = 100;
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count + 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 ) {
    
            MJKPKAddOrEditTableViewCell *cell = [MJKPKAddOrEditTableViewCell cellWithTableView:tableView];
        cell.nameLabel.text = @[@"汇报模板名称", @"汇报内容", @"选择对应员工:"][indexPath.row];
        
            if (indexPath.row == 0) {
                cell.statusLabel.hidden = NO;
                cell.contentTextField.text = self.groupNameStr.length > 0 ? self.groupNameStr : self.PKModel.C_NAME;
                cell.backTextFieldTextBlock = ^(NSString *str) {
                    weakSelf.groupNameStr = str;
                };
            } else if (indexPath.row == 1) {
                cell.rightImage.hidden = NO;
                cell.tfRightLayout.constant = 35;
                cell.contentTextField.enabled = NO;
                cell.contentTextField.placeholder = @"请选择开启项";
                NSMutableArray *arr = [NSMutableArray array];
                if (self.workArray.count > 0) {
                    for (MJKDataDicModel *model in self.workArray) {
                        [arr addObject:model.C_NAME];
                    }
                }
                NSString *str = [arr componentsJoinedByString:@","];
                cell.contentTextField.text = str;
            }
                
            if (indexPath.row == 2) {
                
                cell.contentTextField.hidden = YES;
            }
            cell.groupImageView.hidden = cell.addGroupImageButton.hidden = YES;
        
            
            return cell;
            
        
    } else {
        MJKPKGroupPeopleModel *model = self.dataArray[indexPath.row - 3];
        MJKGroupPeopleTableViewCell *cell = [MJKGroupPeopleTableViewCell cellWithTableView:tableView];
        if (self.C_ID.length > 0) {
            cell.isDetail = YES;
            cell.PKModel = self.PKModel;
        }
        cell.workModel = model;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:self.tableview.tableHeaderView.frame];
    footView.backgroundColor = kBackgroundColor;
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 2) {
        return 40;
    } else {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.row == 1) {
        MJKConfigWorkReportViewController *vc = [[MJKConfigWorkReportViewController alloc]init];
        vc.workArray = self.workArray;
        vc.backSelectArrayBlock = ^(NSArray * _Nonnull arr) {
            weakSelf.workArray = arr;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - http request
-(void)getGroupPeopleListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *arr = data[@"data"];
            for (NSDictionary *dic in arr) {
                MJKPKGroupPeopleModel *model = [MJKPKGroupPeopleModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
            }
            if (self.C_ID.length > 0) {
                [self getDetailListDatas];
            } else {
                [weakSelf.tableview reloadData];
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


-(void)insertGroup{
    // self.PKModel.C_NAME
    if (self.groupNameStr.length <= 0 && self.PKModel.C_NAME.length <= 0) {
        [JRToast showWithText:@"请输入名称"];
        return;
    }
    
    
    
    
    DBSelf(weakSelf);
    //获取组员
    NSMutableArray *groupArray = [NSMutableArray array];
    for (MJKPKGroupPeopleModel *model in self.dataArray) {
        if (model.isSelected == YES) {
            [groupArray addObject:model.u051Id];
        }
    }
    NSString *groupStr = [groupArray componentsJoinedByString:@","];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (MJKDataDicModel *model in self.workArray) {
        [arr addObject:model.C_VOUCHERID];
    }
    NSString *str = [arr componentsJoinedByString:@","];
    
    if (arr.count <= 0) {
        [JRToast showWithText:@"请选择汇报内容"];
        return;
    }
    
    if (groupArray.count <= 0) {
        [JRToast showWithText:@"请选择员工"];
        return;
    }
    
    
    
    NSString *action;
    if (self.C_ID.length > 0) {
        action = @"A48100WebService-update";
    } else {
        action = @"A48100WebService-insert";
    }
    
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:action];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    if (self.C_ID.length > 0) {
        contentDict[@"C_ID"] = self.C_ID;
    } else {
        contentDict[@"C_ID"] = [DBObjectTools getA48100C_id];
    }
    
    contentDict[@"C_NAME"] = self.groupNameStr;
    contentDict[@"C_TYPE_DD_ID"] = @"A48100_C_TYPE_0001";
    contentDict[@"X_OWNERROLEIDS"] = groupStr;
    contentDict[@"X_REMARK"] = str;
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

-(void)getDetailListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48100WebService-getBeanById"];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = self.C_ID;
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.PKModel = [MJKPKModel yy_modelWithDictionary:data];
            NSArray *codeArr = [weakSelf.PKModel.X_REMARK componentsSeparatedByString:@","];
            NSArray *nameArray = [weakSelf.PKModel.X_REMARKNAME componentsSeparatedByString:@","];
            NSMutableArray *arr = [NSMutableArray array];
            for (int i = 0; i < codeArr.count > 0; i++) {
                MJKDataDicModel *model = [[MJKDataDicModel alloc]init];
                model.C_NAME = nameArray[i];
                model.C_VOUCHERID = codeArr[i];
                [arr addObject:model];
            }
            weakSelf.workArray = arr;
            
            NSArray *X_OWNERROLEIDS = [weakSelf.PKModel.X_OWNERROLEIDS componentsSeparatedByString:@","];
            for (NSString *idStr in X_OWNERROLEIDS) {
                for (MJKPKGroupPeopleModel *model in weakSelf.dataArray) {
                    if ([model.u051Id isEqualToString:idStr]) {
                        model.selected = YES;
                    }
                }
            }
            
            [weakSelf.tableview reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
}

-(void)uppicAction:(NSData *)data{
    DBSelf(weakSelf);
    NSString *urlStr = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"ipImage"]];
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postDataUpDataPhotoWithUrl:urlStr parameters:nil photo:data compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.imgUrl = [data objectForKey:@"url"];//回传
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

- (NSString *)nowYearMonth {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy-MM";
    return [dateFormatter stringFromDate:date];
}

#pragma mark - button click
- (void)saveAction {
    [self insertGroup];
}
//选择照片
- (void)selectedImage {
//    [self TouchAddImage];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *newPhoto = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    if (!newPhoto) {
        newPhoto=[info objectForKey:@"UIImagePickerControllerOriginalImage"];
    }
    self.groupImage = newPhoto;
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    NSData*data=UIImageJPEGRepresentation(newPhoto, 0.5);
    
    [self uppicAction:data];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - self.bottomView.frame.size.height)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [[UIView alloc]init];
    }
    return _tableview;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(UIView *)bottomView {
    if (!_bottomView) {
       _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        button.backgroundColor = KNaviColor;
        button.layer.cornerRadius = 5.f;
        [button setTitle:@"保存" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}


@end
