//
//  MJKPKAddAndDetailViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKPKAddAndDetailViewController.h"

#import "MJKPKGroupPeopleModel.h"
#import "MJKPKModel.h"
#import "MJKChooseEmployeesModel.h"

#import "MJKGroupPeopleTableViewCell.h"
#import "MJKPKAddOrEditTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKChoosePKEmployeesTableViewCell.h"

#import "HooDatePicker.h"

@interface MJKPKAddAndDetailViewController ()<UITableViewDataSource, UITableViewDelegate,HooDatePickerDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImage *groupImage;
//@property (nonatomic, strong) NSString *bathDayStr;
@property (nonatomic, strong) NSString *groupNameStr;
@property (nonatomic, strong) NSString * imgUrl;
@property (nonatomic, strong) MJKPKModel *PKModel;
@property (nonatomic, strong) HooDatePicker *datePicker;
@end

@implementation MJKPKAddAndDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (@available(iOS 11.0, *)) {
		self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
    if (self.C_ID.length > 0) {
        self.title = @"组队详情";
    } else {
        self.title = @"新增组队";
    }
    
    [self initRightNavigationItem];
    
    [self getGroupPeopleListDatas];
    [self.view addSubview:self.tableview];
    [self showHooDatePicker];
//    if (self.C_ID.length > 0) {
//        [self getDetailListDatas];
//    }
}

- (void)showHooDatePicker {
    self.datePicker = [[HooDatePicker alloc] initWithSuperView:self.view];
    self.datePicker.delegate = self;
    self.datePicker.datePickerMode = HooDatePickerModeYearAndMonth;
    NSDateFormatter *dateFormatter = [NSDate shareDateFormatter];
    [dateFormatter setDateFormat:kDateFormatYYYYMMDD];
    NSDate *maxDate = [dateFormatter dateFromString:@"2050-01-01"];
    NSDate *minDate = [dateFormatter dateFromString:@"2016-01-01"];
    
    [self.datePicker setDate:[NSDate date] animated:YES];
    self.datePicker.minimumDate = minDate;
    self.datePicker.maximumDate = maxDate;
}

- (void)datePicker:(HooDatePicker *)datePicker didSelectedDate:(NSDate*)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    
    if (datePicker.datePickerMode == HooDatePickerModeDate) {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    } else if (datePicker.datePickerMode == HooDatePickerModeTime) {
        [dateFormatter setDateFormat:@"HH:mm:ss"];
    } else if (datePicker.datePickerMode == HooDatePickerModeYearAndMonth){
        [dateFormatter setDateFormat:@"yyyy-MM"];
    } else {
        [dateFormatter setDateFormat:@"dd MMMM yyyy HH:mm:ss"];
    }
    
    NSString *value = [dateFormatter stringFromDate:date];
    
    self.dateStr = value;
    
    [self.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    return self.dataArray.count + 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3) {
        if (indexPath.row == 2) {
            
            AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
            cell.nameTitleLabel.text = @"年月";
            cell.Type = chooseTypeNil;
            cell.chooseBlock = ^(NSString *str, NSString *postValue) {
                
                [weakSelf.datePicker show];
//                weakSelf.dateStr = [str substringToIndex:7];
//                [weakSelf.tableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            };
//            if (self.dateStr.length > 0) {
            cell.chooseTextField.text = self.dateStr.length > 0 ? self.dateStr : self.PKModel.C_YEARMONTH;
//            } else {
//                cell.chooseTextField.text = [self nowYearMonth];
//            }
            
            return cell;
        } else {
            MJKPKAddOrEditTableViewCell *cell = [MJKPKAddOrEditTableViewCell cellWithTableView:tableView];
            cell.nameLabel.text = @[@"组队名称", @"组队队徽", @"月份", @"选择对应队员"][indexPath.row];
            if (indexPath.row == 1) {
                cell.statusLabel.hidden = NO;
                cell.contentTextField.hidden = YES;
                cell.groupImageView.hidden = cell.addGroupImageButton.hidden = NO;
                [cell.addGroupImageButton addTarget:self action:@selector(selectedImage) forControlEvents:UIControlEventTouchUpInside];
                if (self.groupImage != nil) {
                    cell.groupImageView.image = self.groupImage;
                } else {
                    [cell.groupImageView sd_setImageWithURL:[NSURL URLWithString:self.PKModel.C_HEADIMGURL_SHOW] placeholderImage:[UIImage imageNamed:@"icon_add"]];
                }
                
            } else {
                if (indexPath.row == 0) {
                    cell.statusLabel.hidden = NO;
                    cell.contentTextField.text = self.groupNameStr.length > 0 ? self.groupNameStr : self.PKModel.C_NAME;
                    cell.backTextFieldTextBlock = ^(NSString *str) {
                        weakSelf.groupNameStr = str;
                    };
                }
                if (indexPath.row == 3) {
                    cell.contentTextField.hidden = YES;
                }
                cell.groupImageView.hidden = cell.addGroupImageButton.hidden = YES;
            }
            
            return cell;
        }
    } else {
//        MJKPKGroupPeopleModel *model = self.dataArray[indexPath.row - 4];
//        MJKGroupPeopleTableViewCell *cell = [MJKGroupPeopleTableViewCell cellWithTableView:tableView];
//        if (self.C_ID.length > 0) {
//            cell.isDetail = YES;
//            cell.PKModel = self.PKModel;
//        }
//        cell.model = model;
//        return cell;
        MJKChooseEmployeesModel *model = self.self.dataArray[indexPath.row - 4];
        MJKChoosePKEmployeesTableViewCell *cell = [MJKChoosePKEmployeesTableViewCell cellWithTableView:tableView];
//        cell.C_ID = self.C_ID;

        cell.model = model;
        
//        cell.PKModel = self.PKModel;
        
        
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:self.tableview.tableHeaderView.frame];
    footView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
    label.text = @"组队信息";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:16.f];
    [footView addSubview:label];
    return footView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row > 3) {
//        return 40;
        MJKChooseEmployeesModel *model = self.dataArray[indexPath.row - 4];
        return [MJKChoosePKEmployeesTableViewCell cellForHeight:model];
    } else {
        return 44;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 4) {
        MJKChooseEmployeesModel *model = self.dataArray[indexPath.row - 4];
        model.selected = !model.isSelected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - http request
-(void)getGroupPeopleListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"isAll"] = @"1";
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserStoreList parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            weakSelf.dataArray = [MJKChooseEmployeesModel mj_objectArrayWithKeyValuesArray:data[@"data"]];

            if (weakSelf.C_ID.length > 0) {
                [weakSelf getDetailListDatas];
            }
            [weakSelf.tableview reloadData];
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
    if (self.imgUrl.length <= 0 && self.PKModel.C_HEADIMGURL_SHOW.length <= 0) {
        [JRToast showWithText:@"请选择队徽"];
        return;
    }
    
    
    DBSelf(weakSelf);
    //获取组员
    NSMutableArray *groupArray = [NSMutableArray array];
    for (MJKChooseEmployeesModel *model in self.dataArray) {
        for (MJKPKGroupPeopleModel *subModel in model.userList) {
            if (subModel.isSelected == YES) {
                [groupArray addObject:subModel.USER_ID];
            }
        }
        
    }
    NSString *groupStr = [groupArray componentsJoinedByString:@","];
    
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
    contentDict[@"C_YEARMONTH"] = self.dateStr;
    contentDict[@"C_TYPE_DD_ID"] = @"A48100_C_TYPE_0000";
    contentDict[@"X_OWNERROLEIDS"] = groupStr;
    contentDict[@"C_HEADIMGURL"] = self.imgUrl;
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
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
            
            [weakSelf.tableview reloadData];
            
            NSArray *arr = [weakSelf.PKModel.X_OWNERROLEIDS componentsSeparatedByString:@","];
            for (MJKChooseEmployeesModel *model in self.dataArray) {
                for (MJKPKGroupPeopleModel *subModel in model.userList) {
                    for (NSString *userID in arr) {
                        if ([subModel.USER_ID isEqualToString:userID]) {
                            subModel.selected = YES;
                        }
                    }
                }
                
            }
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
    [self TouchAddImage];
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
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight)];
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


@end
