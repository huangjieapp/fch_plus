//
//  MJKGroupShopsViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKGroupShowShopsViewController.h"

#import "DBTabBarViewController.h"
#import "DBNavigationController.h"

#import "MJKLocCodeModel.h"

@interface MJKGroupShowShopsViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *locCodeArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_LOCCODE;
@end

@implementation MJKGroupShowShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"集团下属门店";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = KNaviColor;
    [self.view addSubview:self.tableView];
    [self getLocCodeData];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locCodeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKLocCodeModel *model = self.locCodeArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14.f];
    cell.textLabel.text = model.C_A40300_C_NAME;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKLocCodeModel *model = self.locCodeArray[indexPath.row];
    [NewUserSession instance].C_ABBREVATION = model.C_A40300_C_NAME;
    [NewUserSession instance].user.C_LOCCODE = model.C_A40300_C_ID;
    self.C_LOCCODE = model.C_VOUCHERID;
    [KUSERDEFAULT removeObjectForKey:@"tabSelect"];
    
    [KUSERDEFAULT removeObjectForKey:@"customerTabName"];
    
    [KUSERDEFAULT removeObjectForKey:@"clueTabName"];
    [self httpChooseShop];
}

//MARK:-选择门店
- (void)httpChooseShop {
    //    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"UserWebService-synchronizeUserCommon"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_GRPCODE"] = [NewUserSession instance].user.C_GRPCODE;
    if (self.C_ORGCODE.length > 0) {
        contentDic[@"C_ORGCODE"] = self.C_ORGCODE;
    }
    if (self.C_LOCCODE.length > 0) {
        contentDic[@"C_LOCCODE"] = self.C_LOCCODE;
    }
    contentDic[@"user_id"] = [NewUserSession instance].user.u051Id;
    mainDic[@"content"] = contentDic;
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [NewUserSession instance].jobStr = @"员工";
            DBTabBarViewController*tab=[[DBTabBarViewController alloc]initWithNibName:@"DBTabBarViewController" bundle:nil];
            [UIApplication sharedApplication].keyWindow.rootViewController=tab;
        } else{
            
        }
        
        
    }];
    
}

//MARK:-选择门店


- (void)getLocCodeData{
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"UserWebService-getlocListByOrgId"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.C_A40200_C_ID.length > 0) {
        contentDic[@"C_A40200_C_ID"] = self.C_A40200_C_ID;
    }
    mainDic[@"content"] = contentDic;
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];

    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.locCodeArray = [MJKLocCodeModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        } else{
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
