//
//  MJKFunctionalmManagementViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/4.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFunctionalmManagementViewController.h"
#import "MJKCustomReturnSubModel.h"
#import "MJKPushDefaultListModel.h"

#import "MJKWorkReportSetCell.h"

@interface MJKFunctionalmManagementViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *defaultArray;
@end

@implementation MJKFunctionalmManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"应用功能管理设置";
    [self.view addSubview:self.tableView];
    [self HTTPRecheckSetDatas];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MJKCustomReturnSubModel *defaultModel = self.dataArray[section];
    return defaultModel.defaultList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKCustomReturnSubModel *defaultModel = self.dataArray[indexPath.section];
    MJKPushDefaultListModel *model =  defaultModel.defaultList[indexPath.row];
    MJKWorkReportSetCell *cell = [MJKWorkReportSetCell cellWithTableView:tableView];
    cell.defaultModel = model;
    if ([model.ISBUY isEqualToString:@"false"]) {
        cell.openSwitchButton.enabled = NO;
    }
    cell.openSwitchBlock = ^(BOOL isOn) {
        if (isOn == YES) {
            model.ISCHECK = @"true";
           
        } else {
            model.ISCHECK = @"false";
           
        }
        
        [weakSelf httpSetRecheck:defaultModel];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    MJKCustomReturnSubModel *defaultModel = self.dataArray[section];
    if (defaultModel.defaultList.count > 0) {
        return 20;
    }
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJKCustomReturnSubModel *defaultModel = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 20)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    if (defaultModel.defaultList.count > 0) {
        label.text = defaultModel.C_NAME;
    }
    
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCustomReturnSubModel *defaultModel = self.dataArray[indexPath.section];
    MJKPushDefaultListModel *model =  defaultModel.defaultList[indexPath.row];
    if ([model.ISBUY isEqualToString:@"false"]) {
        [JRToast showWithText:@"暂无权限开启"];
        return ;
    }
}

//MARK:-http
- (void)HTTPRecheckSetDatas {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = @"18";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)httpSetRecheck:(MJKCustomReturnSubModel *)model {
    //    DBSelf(weakSelf);
    self.defaultArray = [NSMutableArray array];
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = model.C_ID;
    
    for (MJKPushDefaultListModel *defaultModel in model.defaultList) {
        NSDictionary *dic = [defaultModel mj_keyValues];
        [self.defaultArray addObject:dic];
    }
    contentDict[@"defaultList"] = self.defaultArray;
//    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    /*
     NSMutableArray *arr = [NSMutableArray array];
     for (MJKCustomReturnSubModel *subModel in weakSelf.dataArray) {
     NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
     contentDic[@"C_ID"] = subModel.C_ID;
     contentDic[@"C_STATUS_DD_ID"] = subModel.C_STATUS_DD_ID;
     [arr addObject:contentDic];
     }
     */
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [JRToast showWithText:@"操作成功"];
            NSMutableArray *myAppArr = [[KUSERDEFAULT objectForKey:SaveSelectedModule] mutableCopy];
            NSArray *myAppArrName = [KUSERDEFAULT objectForKey:SaveSelectedModuleName];
            
            for (MJKPushDefaultListModel *defaultModel in model.defaultList) {
                if ([defaultModel.ISCHECK isEqualToString:@"false"]) {
                    if ([myAppArrName containsObject:defaultModel.NAME]) {
                        [myAppArr removeObject:defaultModel.NAME];
                    }
                    [KUSERDEFAULT setObject:myAppArr forKey:SaveSelectedModule];
                    if ([[NewUserSession instance].configData.app_default containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_default removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_base containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_base removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_report containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_report removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_mjk containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mjk removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_mzg containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mzg removeObject:defaultModel.CODE];
                    }
                    if ([[NewUserSession instance].configData.app_jp containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_jp removeObject:defaultModel.CODE];
                        [NewUserSession instance].isApp_jp = YES;
                    }
                } else {
                    if ([myAppArrName containsObject:defaultModel.NAME] && ![myAppArr containsObject:defaultModel.NAME]) {
                        NSInteger index = [myAppArrName indexOfObject:defaultModel.NAME];
                        [myAppArr insertObject:defaultModel.NAME atIndex:index];
                    }
                    [KUSERDEFAULT setObject:myAppArr forKey:SaveSelectedModule];
                    if (![[NewUserSession instance].configData.app_default containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_default addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_base containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_base addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_report containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_report addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_mjk containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mjk addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_mzg containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_mzg addObject:defaultModel.CODE];
                    }
                    if (![[NewUserSession instance].configData.app_jp containsObject:defaultModel.CODE]) {
                        [[NewUserSession instance].configData.app_jp addObject:defaultModel.CODE];
                        
                        [NewUserSession instance].isApp_jp = YES;
                    }
                }
                
            }
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
