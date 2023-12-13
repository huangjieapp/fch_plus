//
//  MJKPushOpenFollowSetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKJXPushOpenSetViewController.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKPushDefaultListModel.h"
#import "MJKClueListSubModel.h"

#import "MJKPushOpenSetSection0Cell.h"
#import "MJKPushOpenFollowSetCell.h"
#import "MJKPushOpenSetSection1Cell.h"

@interface MJKJXPushOpenSetViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** push user model array*/
@property (nonatomic, strong) NSArray *pushUserArray;
/** <#注释#> */
@property (nonatomic, strong) NSString *nickName;
@end

@implementation MJKJXPushOpenSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推送设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    //自定义推送人
    [self getSalesListDatas];
    [self configNaviItem];
}

- (void)configNaviItem {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitleNormal:@"确定"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    [button addTarget:self action:@selector(commitButtonAction:)];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.nickName = searchBar.text;
    [self getSalesListDatas];
}

#pragma mark - 确定按钮事件
- (void)commitButtonAction:(UIButton *)sender {
    DBSelf(weakSelf);
        NSMutableArray *selectCustomerArr = [NSMutableArray array];
        for (MJKClueListSubModel *model in self.pushUserArray) {
            if (model.isSelected == YES) {
                [selectCustomerArr addObject:model.u051Id];
            }
        }
    
    if (self.detailModel.C_FIRSTPUSH.length <= 0) {
        [JRToast showWithText:@"请选择推送时间"];
        return;
    }
    if (selectCustomerArr.count <= 0) {
        [JRToast showWithText:@"请选择推送人"];
        return;
    }
//    NSMutableArray *defaulArr = [NSMutableArray array];
//    for (MJKPushDefaultListModel *model in self.detailModel.defaultList) {
//        NSDictionary *dic = model.mj_keyValues;
//        [defaulArr addObject:dic];
//    }
    [self httpOpenOrCloseMessagePush:self.detailModel andDefault:selectCustomerArr andCompleteBlock:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (self.detailModel.defaultList.count > 0) {
        return 2;
//    } else {
//        return 2;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
//        return 1;
//    } else
        if (section == 0) {
//        if ([self.typeNumber isEqualToString:@"A47500_C_RBTS_0000"]) {
            return 1;
//        } else {
//            return 3;
//        }
    } else {
        return self.pushUserArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
//    if (indexPath.section == 0) {
//        MJKPushOpenSetSection0Cell *cell = [MJKPushOpenSetSection0Cell cellWithTableView:tableView];
//        cell.titleNameLabel.text = @"公众号推送";
//        cell.model = self.detailModel;
//        cell.openSwitchBlock = ^(BOOL isOn) {
//            weakSelf.detailModel.I_TYPE = isOn == YES ? 1 : 0;
//            [weakSelf httpOpenOrCloseMessagePush:weakSelf.detailModel andDefault:nil andCompleteBlock:nil];
//        };
//        return cell;
//    } else
        if (indexPath.section == 0) {
        MJKPushOpenFollowSetCell *cell = [MJKPushOpenFollowSetCell cellWithTableView:tableView];
        [cell updateCellWithModel:self.detailModel andRow:indexPath.row andTypeNumber:@"A47500_C_RBTS_0000"];
        return cell;
    } else  {
        MJKClueListSubModel *model = self.pushUserArray[indexPath.row];
        MJKPushOpenSetSection1Cell *cell = [MJKPushOpenSetSection1Cell cellWithTableView:tableView];
        cell.jxModel = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30.f;
    } else {
        return 80;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), KScreenWidth, 50)];
    searchBar.placeholder = @"搜索姓名";
    searchBar.delegate = self;
//    if (section == 0) {
//        label.text = @"消息推送方式";
//    } else
        if (section == 0) {
        label.text = @"推送时间";
    } else {
        label.text = @"默认推送人";
        [bgView addSubview:searchBar];
    }
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)httpOpenOrCloseMessagePush:(MJKCustomReturnSubModel *)model  andDefault:(NSArray *)defaultArr andCompleteBlock:(void(^)(void))completeBlock {
//    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = model.C_ID;
    dic[@"I_TYPE"] = @(model.I_TYPE);
    if (defaultArr.count > 0) {
        dic[@"customList"] = defaultArr;
    } else {
        dic[@"customList"] = @[];
    }
    dic[@"C_FIRSTPUSH"] = model.C_FIRSTPUSH;
    
    
//    [dict setObject:dic forKey:@"content"];
//    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkWithUrl:[HTTP_IP stringByAppendingString:@"/api/system/a475/edit"] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            //            [JRToast showWithText:data[@"message"]];
            [weakSelf.tableView reloadData];
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
#pragma mark 推送人
-(void)getSalesListDatas {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (self.nickName.length > 0) {
        dic[@"nickName"] = self.nickName;
    }
    dic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[HTTP_IP stringByAppendingString:@"/api/system/user/list"] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.pushUserArray = [MJKClueListSubModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            for (NSString *saleStr in weakSelf.detailModel.customList) {
                for (MJKClueListSubModel *model in weakSelf.pushUserArray) {
                    if ([saleStr isEqualToString:model.u051Id]) {
                        model.selected = YES;
                    }
                }
            }
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
