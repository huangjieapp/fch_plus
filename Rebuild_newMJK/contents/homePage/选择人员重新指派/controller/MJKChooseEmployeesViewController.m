//
//  MJKMarketViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/5.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKChooseEmployeesViewController.h"
#import "MJKClueListViewModel.h"
#import "MJKClueMarketTableViewCell.h"
#import "MJKChooseEmployeesTableViewCell.h"
#import "MJKTabView.h"
#import "MJKChooseEmployeesModel.h"
#import "MJKChooseEmployeesSubModel.h"
#import "ServiceTaskViewController.h"

#import "MJKPKGroupPeopleModel.h"



#define marketCell @"marketCell"

@interface MJKChooseEmployeesViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) MJKClueListViewModel *clueListModel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *tabStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *searchStr;
/** 公司员工*/
@property (nonatomic, strong)  NSArray *storeArray;
@end

@implementation MJKChooseEmployeesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableview.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"选择人员";
    self.tabStr = @"本店";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initSearchBar];
    [self.view addSubview:self.tableview];
    [self.tableview registerNib:[UINib nibWithNibName:@"MJKClueMarketTableViewCell" bundle:nil] forCellReuseIdentifier:marketCell];
    
    [self createNavi];
    [self configRefresh];
    
}

- (void)createNavi {
    DBSelf(weakSelf);
    MJKTabView *tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 2 * 70, 30) andNameItems:@[@"本店", @"公司"]  withDefaultIndex:0  andIsSaveItem:NO andClickButtonBlock:^(NSString * _Nonnull str) {
        if ([str isEqualToString:@"本店"]) {
            weakSelf.tabStr = str;
            [weakSelf.tableview.mj_header beginRefreshing];
        } else if ([str isEqualToString:@"公司"]) {
            weakSelf.tabStr = str;
            [weakSelf.tableview.mj_header beginRefreshing];
        }
    }];
    
    if ([self.isAllEmployees isEqualToString:@"是"]) {
        self.navigationItem.titleView = tabView;
    } else {
        self.title = @"选择人员";
    }
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tabStr isEqualToString:@"本店"] ? [weakSelf getAllSalesListWithName] : [weakSelf getAllShopEmployesesWithName];
    }];
    [self.tableview.mj_header beginRefreshing];
}

- (void)initSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 5, KScreenWidth, 30)];
    searchBar.delegate = self;
    searchBar.placeholder = @"搜索姓名";
    UIImage* searchBarBg = [self GetImageWithColor:[UIColor clearColor] andHeight:30.0f];
    //设置背景图片
    [searchBar setBackgroundImage:searchBarBg];
    //设置背景色
    [searchBar setBackgroundColor:[UIColor clearColor]];
    //设置文本框背景
    [searchBar setSearchFieldBackgroundImage:searchBarBg forState:UIControlStateNormal];
    
    UITextField *searchField = [searchBar valueForKey:@"searchField"];
    
    if (searchField) {
        
        [searchField setBackgroundColor:[UIColor whiteColor]];
        
        searchField.layer.cornerRadius = 14.0f;
        
        searchField.layer.borderColor = [UIColor grayColor].CGColor;
        
        searchField.layer.borderWidth = 1;
        
        searchField.layer.masksToBounds = YES;
        
    }
    [self.view addSubview:searchBar];
}
//自定义searchBar背景
- (UIImage*) GetImageWithColor:(UIColor*)color andHeight:(CGFloat)height
{
    CGRect r= CGRectMake(0.0f, 0.0f, 1.0f, height);
    UIGraphicsBeginImageContext(r.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, r);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (void)alertViewWithModel:(MJKClueListSubModel *)model {
    DBSelf(weakSelf);
    NSString *str = @"是否重新指派";
    if (self.alertName.length > 0) {
        if ([self.alertName isEqualToString:@"到货"]) {
            str = [NSString stringWithFormat:@"是否更改为收货人为%@",model.user_name];
        } else {
            str = [NSString stringWithFormat:@"是否更改为验收人为%@",model.user_name];
        }
    }
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:str preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (weakSelf.chooseEmployeesBlock) {
            weakSelf.chooseEmployeesBlock(model);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    
    [ac addAction:noAction];
    [ac addAction:yesAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchStr = searchText;
    [self.tableview.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tabStr isEqualToString:@"本店"]) {
        return self.clueListModel.content.count;
    } else {
        return self.storeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if ([self.tabStr isEqualToString:@"本店"]) {
        MJKClueMarketTableViewCell *cell = [MJKClueMarketTableViewCell cellWithTableView:tableView];
        cell.subModel = self.clueListModel.content[indexPath.row];
        MJKClueListSubModel *subModel = self.clueListModel.content[indexPath.row];
        cell.countLabel.hidden = NO;
        cell.countLabel.text = subModel.COUNT;
        cell.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
            if ([weakSelf.rootVC isKindOfClass:[ServiceTaskViewController class]] || [weakSelf.noticeStr isEqualToString:@"无提示"]) {
                if (weakSelf.chooseEmployeesBlock) {
                    weakSelf.chooseEmployeesBlock(model);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf alertViewWithModel:model];
            }
        };
        return cell;
    } else {
        MJKChooseEmployeesModel *model = self.storeArray[indexPath.row];
        MJKChooseEmployeesTableViewCell *cell = [MJKChooseEmployeesTableViewCell cellWithTableView:tableView];
        if ([self.tabStr isEqualToString:@"公司"]) {
            if (self.searchStr.length > 0) {
                model.selected = YES;
            }
        }
        cell.model = model;
        cell.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
            if ([weakSelf.rootVC isKindOfClass:[ServiceTaskViewController class]] || [weakSelf.noticeStr isEqualToString:@"无提示"]) {
                if (weakSelf.chooseEmployeesBlock) {
                    weakSelf.chooseEmployeesBlock(model);
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } else {
                [weakSelf alertViewWithModel:model];
            }
        };
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.tabStr isEqualToString:@"本店"]) {
        return 44;
    } else {
        MJKChooseEmployeesModel *model = self.storeArray[indexPath.row];
        return [MJKChooseEmployeesTableViewCell cellForHeight:model];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tabStr isEqualToString:@"本店"]) {
        MJKClueListSubModel *model=self.clueListModel.content[indexPath.row];
    } else {
        MJKChooseEmployeesModel *model = self.storeArray[indexPath.row];
        model.selected = !model.isSelected;
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}


- (void)submitButtonAction:(UIButton *)sender {
    
}



//销售顾问
- (void)getAllSalesListWithName {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.allUser.length > 0) {
        contentDic[@"allUser"] = @"1";
    } else {
        contentDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    }
    if (self.searchStr.length > 0) {
        contentDic[@"nickName"] = self.searchStr;
    }
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserList parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {

            weakSelf.clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            for (MJKClueListSubModel *subModel in weakSelf.clueListModel.data) {
                subModel.user_id = subModel.u031Id;
                subModel.user_name = subModel.nickName;
                subModel.C_HEADPIC = subModel.avatar;
            }
            weakSelf.clueListModel.content = weakSelf.clueListModel.data;
            [weakSelf.tableview reloadData];

        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableview.mj_header endRefreshing];
    }];
            
}

- (void)getAllShopEmployesesWithName {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.searchStr.length > 0) {
        contentDic[@"C_NAME"] = self.searchStr;
    }
    contentDic[@"isAll"] = @"1";
    HttpManager *manage = [[HttpManager alloc]init];
    [manage getNewDataFromNetworkWithUrl:HTTP_SYSTEMUserStoreList parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.storeArray = [MJKChooseEmployeesModel  mj_objectArrayWithKeyValuesArray:data[@"data"]];
            for (MJKChooseEmployeesModel *model in weakSelf.storeArray) {
                for (MJKChooseEmployeesSubModel *subModel in model.userList) {
                    subModel.USER_ID = subModel.u031Id;
                    subModel.C_NAME = subModel.nickName;
                    subModel.C_HEADPIC = subModel.avatar;
                }
                
            }
            [weakSelf.tableview reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableview.mj_header endRefreshing];
    }];
    
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - 40 - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
        _tableview.estimatedSectionFooterHeight = 0;
    }
    return _tableview;
}


@end
