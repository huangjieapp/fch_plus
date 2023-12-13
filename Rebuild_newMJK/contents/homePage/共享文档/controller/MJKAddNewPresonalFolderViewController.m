//
//  MJKAddNewPresonalFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/10/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAddNewPresonalFolderViewController.h"

#import "MJKChoosePKEmployeesTableViewCell.h"

#import "MJKChooseEmployeesModel.h"
#import "MJKPKGroupPeopleModel.h"
#import "MJKFolderModel.h"

@interface MJKAddNewPresonalFolderViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong)  UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *folderName;
@end

@implementation MJKAddNewPresonalFolderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新建文件夹";
    [self initUI];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
}

- (void)initUI {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 60)];
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 50)];
    textField.placeholder = @"请输入文件夹名称";
    textField.backgroundColor = kBackgroundColor;
    [textField addTarget:self action:@selector(enterFolderName:) forControlEvents:UIControlEventEditingChanged];
    [headView addSubview:textField];
    [self.view addSubview:headView];
    if (self.A706_model != nil) {
        textField.text = self.folderName = self.A706_model.C_A70600_C_NAME;
    }
    [self getGroupPeopleListDatas];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKChooseEmployeesModel *model = self.dataArray[indexPath.row];
    MJKChoosePKEmployeesTableViewCell *cell = [MJKChoosePKEmployeesTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKChooseEmployeesModel *model = self.dataArray[indexPath.row];
    return [MJKChoosePKEmployeesTableViewCell cellForHeight:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
    label.text = @"请选择可共享员工";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14];
    [bgView addSubview:label];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKChooseEmployeesModel *model = self.dataArray[indexPath.row];
    model.selected = !model.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)enterFolderName:(UITextField *)tf {
    self.folderName = tf.text;
}

#pragma mark - http request
-(void)getGroupPeopleListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"isAll"] = @"1";
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserStoreList parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKChooseEmployeesModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            if (self.A706_model != nil) {
                NSArray *arr = [weakSelf.A706_model.X_CKQX componentsSeparatedByString:@","];
                for (MJKChooseEmployeesModel *model in weakSelf.dataArray) {
                    for (MJKPKGroupPeopleModel *subModel in model.userList) {
                        for (NSString *str in arr) {
                            if ([subModel.USER_ID isEqualToString:str]) {
                                subModel.selected = YES;
                                model.selected = YES;
                            }
                        }
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)HTTPInsertFolderDatasWithUser_id:(NSString *)userStr {
    NSString *action = @"A70600WebService-insert";
    if (self.A706_model.C_A70600_C_ID.length > 0) {
        action = @"A70600WebService-update";
    }
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:action];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    tempDic[@"C_ID"] = self.A706_model.C_A70600_C_ID.length > 0 ? self.A706_model.C_A70600_C_ID : [DBObjectTools getA70600C_id];
    if (self.folderName.length > 0) {
        tempDic[@"C_NAME"] = self.folderName;
    }
    tempDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0003";
    if (userStr.length > 0) {
        tempDic[@"X_CKQX"] = userStr;
    }
    if (self.C_A70600_C_ID.length > 0) {
        tempDic[@"C_FATHERID"] = self.C_A70600_C_ID;
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

- (void)commitButtonAction {
    if (self.folderName.length <= 0) {
        [JRToast showWithText:@"请输入文件夹名称"];
        return;
    }
    //获取组员
    NSMutableArray *groupArray = [NSMutableArray array];
    for (MJKChooseEmployeesModel *model in self.dataArray) {
        for (MJKPKGroupPeopleModel *subModel in model.userList) {
            if (subModel.isSelected == YES) {
                [groupArray addObject:subModel.USER_ID];
            }
        }
        
    }
    NSString *groupStr = @"";
    if (groupArray.count > 0) {
        groupStr = [groupArray componentsJoinedByString:@","];
    }
    [self HTTPInsertFolderDatasWithUser_id:groupStr];
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 60, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 60) style:UITableViewStyleGrouped];
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
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        [button setTitleNormal:@"提交"];
        button.backgroundColor = KNaviColor;
        [button addTarget:self action:@selector(commitButtonAction)];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

@end
