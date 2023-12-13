//
//  MJKAddTelephoneRobotViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/19.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAddTelephoneRobotViewController.h"

#import "MJKAddressTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKShowSendView.h"
#import "CGCCustomDateView.h"

#import "MJKMarketViewController.h"
#import "MJKTelephoneRobotInfoViewController.h"

@interface MJKAddTelephoneRobotViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
/** search button*/
@property (nonatomic, strong) UIButton *searchButton;

/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *customTimeDic;

@end

@implementation MJKAddTelephoneRobotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"新增呼叫任务";
    self.view.backgroundColor = kBackgroundColor;
    
    [self configUI];
}

- (void)configUI {
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchButton];
}

-(void)showTimeAlertVC:(NSMutableDictionary *)dic{
    //自定义的选择时间界面。
    DBSelf(weakSelf);
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        dic[@"content"] = @"自定义";
        dic[@"C_ID"] = @"";
        [weakSelf.tableView reloadData];
        if ([weakSelf.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {
            if ([dic[@"title"] isEqualToString:@"创建时间"]) {
                weakSelf.customTimeDic[@"CREATE_START_TIME"] = start;
                weakSelf.customTimeDic[@"CREATE_END_TIME"] = end;
            }
        } else if ([weakSelf.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {
            if ([dic[@"title"] isEqualToString:@"创建时间"]) {
                weakSelf.customTimeDic[@"START_TIME"] = start;
                weakSelf.customTimeDic[@"END_TIME"] = end;
            } else if ([dic[@"title"] isEqualToString:@"活跃时间"]) {
                weakSelf.customTimeDic[@"LASTUPDATE_START_TIME"] = start;
                weakSelf.customTimeDic[@"LASTUPDATE_END_TIME"] = end;
            } else if ([dic[@"title"] isEqualToString:@"下次跟进时间"]) {
                weakSelf.customTimeDic[@"FLOW_START_TIME"] = start;
                weakSelf.customTimeDic[@"FLOW_END_TIME"] = end;
            }
        } else {
            if ([dic[@"title"] isEqualToString:@"创建时间"]) {
                weakSelf.customTimeDic[@"CREATE_START_TIME"] = start;
                weakSelf.customTimeDic[@"CREATE_END_TIME"] = end;
            } else if ([dic[@"title"] isEqualToString:@"活跃时间"]) {
                weakSelf.customTimeDic[@"LASTUPDATE_START_TIME"] = start;
                weakSelf.customTimeDic[@"LASTUPDATE_END_TIME"] = end;
            } else if ([dic[@"title"] isEqualToString:@"下次跟进时间"]) {
                weakSelf.customTimeDic[@"LASTFOLLOW_START_TIME"] = start;
                weakSelf.customTimeDic[@"LASTFOLLOW_END_TIME"] = end;
            }
        }
       
            
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = self.listDataArray[indexPath.row];
    if ([dic[@"title"] isEqualToString:@"客户地址"] || [dic[@"title"] isEqualToString:@"导入标识"]) {
        //客户地址
        MJKAddressTableViewCell *cell = [MJKAddressTableViewCell cellWithTableView:tableView];
        cell.chooseAreaLayout.constant = -55;
        cell.chooseAreaButton.hidden = YES;
        cell.titleLabel.text=dic[@"title"];
        if ([dic[@"content"] length] > 0) {
            cell.textView.alpha = 1.f;
        }
        cell.textView.text = dic[@"content"];
        
        cell.changeTextBlock = ^(NSString *textStr) {
            dic[@"content"] = textStr;
            dic[@"C_ID"] = textStr;
            
            [tableView beginUpdates];
            [tableView endUpdates];
        };
        return cell;
    } else {
        AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.taglabel.hidden=YES;
        cell.isTitle = YES;
        cell.nameTitleLabel.text=dic[@"title"];
        if ([dic[@"content"] length] > 0) {
            cell.textStr=dic[@"content"];
        }else{
            cell.textStr=nil;
        }
        if ([dic[@"title"] isEqualToString:@"员工"]) {
            cell.Type = chooseTypeNil;
        } else if ([dic[@"title"] isEqualToString:@"等级"]) {
            if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0001"]) {//客户
                cell.Type = ChooseTableViewTypeFansLevel;
            } else {
                cell.Type=ChooseTableViewTypeLevel;
            }
        } else if ([dic[@"title"] isEqualToString:@"客户状态"] || [dic[@"title"] isEqualToString:@"名单状态"]) {
            if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {//客户
                cell.Type = CHooseTableViewTypeCustomerStatus;
            } else if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {//名单
                cell.Type=CHooseTableViewTypeListStatus;
            } else {
                cell.Type=CHooseTableViewTypeFansStatus;
            }
        } else if ([dic[@"title"] isEqualToString:@"到店情况"]) {
            cell.Type = CHooseTableViewTypeArriveShop;
        } else if ([dic[@"title"] isEqualToString:@"创建时间"]) {
            cell.Type=CHooseTableViewTypeRobotTime;
        } else if ([dic[@"title"] isEqualToString:@"活跃时间"]) {
            if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {
                cell.Type=CHooseTableViewTypeRobotActiveTime;
            } else {
                cell.Type=CHooseTableViewTypeRobotTime;
            }
        } else if ([dic[@"title"] isEqualToString:@"下次跟进时间"]) {
            cell.Type=CHooseTableViewTypeRobotTime;
        } else if ([dic[@"title"] isEqualToString:@"客户标签"]) {
            cell.Type = ChooseTableViewTypeCustomerLabel;
        } else if ([dic[@"title"] isEqualToString:@"星标客户"]) {
            cell.Type = ChooseTableViewTypeCustomerStar;
        } else if ([dic[@"title"] isEqualToString:@"客户阶段"]) {
            cell.Type=ChooseTableViewTypeStage;
        } else if ([dic[@"title"] isEqualToString:@"来源渠道"]) {
            cell.Type=ChooseTableViewTypeCustomerSource;
        } else if ([dic[@"title"] isEqualToString:@"渠道细分"]) {
            cell.Type=ChooseTableViewTypeAction;
        } else if ([dic[@"title"] isEqualToString:@"最近到店方式"]) {
            cell.Type = CHooseTableViewTypeArriveShopWay;
        } else if ([dic[@"title"] isEqualToString:@"性别"]) {
            cell.Type=ChooseTableViewTypeGender;
        }  else if ([dic[@"title"] isEqualToString:@"业务"]) {
            cell.Type=chooseTypeNil;
        }  else if ([dic[@"title"] isEqualToString:@"创建人"]) {
            cell.Type=chooseTypeNil;
        } else if ([dic[@"title"] isEqualToString:@"类型"]) {
            cell.Type = CHooseTableViewTypeType;
        } else if ([dic[@"title"] isEqualToString:@"搜索数量"]) {
            cell.Type = CHooseTableViewTypeMumber;
        }
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            if ([dic[@"title"] isEqualToString:@"员工"] || [dic[@"title"] isEqualToString:@"业务"] || [dic[@"title"] isEqualToString:@"创建人"]) {
                MJKMarketViewController *vc = [[MJKMarketViewController alloc]init];
                vc.vcName = @"订单";
                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                    dic[@"content"] = nameStr;
                    dic[@"C_ID"] = codeStr;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                if ([postValue isEqualToString:@"999"]) {
                    [weakSelf showTimeAlertVC:dic];
                    return ;
                }
                if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {
                    if ([dic[@"title"] isEqualToString:@"创建时间"]) {
                        [self.customTimeDic removeObjectForKey:@"CREATE_START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"CREATE_END_TIME"];
                    }
                } else if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {
                    if ([dic[@"title"] isEqualToString:@"创建时间"]) {
                        [self.customTimeDic removeObjectForKey:@"START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"END_TIME"];
                    } else if ([dic[@"title"] isEqualToString:@"活跃时间"]) {
                        [self.customTimeDic removeObjectForKey:@"LASTUPDATE_START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"LASTUPDATE_END_TIME"];
                    } else if ([dic[@"title"] isEqualToString:@"下次跟进时间"]) {
                        [self.customTimeDic removeObjectForKey:@"FLOW_START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"FLOW_END_TIME"];
                    }
                } else {
                    if ([dic[@"title"] isEqualToString:@"创建时间"]) {
                        [self.customTimeDic removeObjectForKey:@"CREATE_START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"CREATE_END_TIME"];
                    } else if ([dic[@"title"] isEqualToString:@"活跃时间"]) {
                        [self.customTimeDic removeObjectForKey:@"LASTUPDATE_START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"LASTUPDATE_END_TIME"];
                    } else if ([dic[@"title"] isEqualToString:@"下次跟进时间"]) {
                        [self.customTimeDic removeObjectForKey:@"LASTFOLLOW_START_TIME"];
                        [self.customTimeDic removeObjectForKey:@"LASTFOLLOW_END_TIME"];
                    }
                }
                
                dic[@"content"] = str;
                dic[@"C_ID"] = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        };
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth, 30)];
    label.text = @"筛选搜索条件";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)HTTPSearchData {
    NSString *actionStr;
    if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {
        actionStr = @"CluedisplayWebService-getCount";
    } else if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {
        actionStr = @"CustomerWebService-getCount";
    } else {
        actionStr = @"A47700WebService-getCount";
    }
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
    NSMutableDictionary *contentDic=[NSMutableDictionary new];
    contentDic[@"C_ID"] = [DBObjectTools getA70100C_id];
    for (NSMutableDictionary *dic in self.listDataArray) {
        if ([dic[@"C_ID"] length] > 0) {
            [contentDic setObject:dic[@"C_ID"] forKey:dic[@"id"]];
        }
    }
    
    [self.customTimeDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [contentDic setObject:obj forKey:key];
    }];
    
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            MJKShowSendView *showView = [[MJKShowSendView alloc]initWithFrame:weakSelf.view.frame andButtonTitleArray:@[@"取消",@"确定"] andTitle:@"" andMessage:data[@"content"]];
            showView.buttonActionBlock = ^(NSString * _Nonnull str) {
                if ([str isEqualToString:@"确定"]) {
                    MJKTelephoneRobotInfoViewController *vc = [[MJKTelephoneRobotInfoViewController alloc]init];
                    vc.getA70100C_id = contentDic[@"C_ID"];
                    vc.C_SOURCE_DD_ID = weakSelf.C_SOURCE_DD_ID;
                    [weakSelf.navigationController pushViewController:vc animated:YES];
                }
            };
            
            [weakSelf.view addSubview:showView];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

#pragma mark - 搜索按钮
- (void)searchButtonAction:(UIButton *)sender {
    NSLog(@"%@",self.listDataArray);
//    if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {//客户
//        NSMutableDictionary *dic = self.listDataArray[0];
//        if ([dic[@"C_ID"] length] <= 0) {
//            [JRToast showWithText:@"请选择员工"];
//            return;
//        }
//    }
    
    [self HTTPSearchData];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), KScreenWidth, 54)];
        [_searchButton setTitleNormal:@"搜索"];
        [_searchButton setBackgroundColor:KNaviColor];
        [_searchButton setTitleColor:[UIColor blackColor]];
        [_searchButton addTarget:self action:@selector(searchButtonAction:)];
    }
    return _searchButton;
}

- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
        if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {//客户
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"员工", @"content" : @"", @"id" : @"USER_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"等级", @"content" : @"", @"id" : @"C_LEVEL_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"客户状态", @"content" : @"", @"id" : @"C_STATUS_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"到店情况", @"content" : @"", @"id" : @"DD_TYPE"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"客户地址", @"content" : @"", @"id" : @"C_ADDRESS"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"创建时间", @"content" : @"", @"id" : @"CREATE_TIME"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"活跃时间", @"content" : @"", @"id" : @"LASTUPDATE_TIME"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"下次跟进时间", @"content" : @"", @"id" : @"FOLLOW_TIME"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"客户标签", @"content" : @"", @"id" : @"X_LABEL"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"星标客户", @"content" : @"", @"id" : @"C_STAR_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"客户阶段", @"content" : @"", @"id" : @"C_STAGE_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"来源渠道", @"content" : @"", @"id" : @"C_CLUESOURCE_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"渠道细分", @"content" : @"", @"id" : @"C_A41200_C_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"搜索数量", @"content" : @"50", @"id" : @"returnCountType",@"C_ID" : @"0"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"最近到店方式", @"content" : @"", @"id" : @"C_FLOWMODE"}]];
        } else if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {//名单
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"员工", @"content" : @"", @"id" : @"USER_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"名单状态", @"content" : @"", @"id" : @"C_STATUS_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"客户地址", @"content" : @"", @"id" : @"C_ADDRESS"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"导入标识", @"content" : @"", @"id" : @"C_ENGLISHNAME"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"创建时间", @"content" : @"", @"id" : @"CREATE_TIME_TYPE"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"来源渠道", @"content" : @"", @"id" : @"C_CLUESOURCE_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"渠道细分", @"content" : @"", @"id" : @"C_A41200_C_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"搜索数量", @"content" : @"50", @"id" : @"returnCountType",@"C_ID" : @"0"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"业务", @"content" : @"", @"id" : @"C_CLUEPROVIDER_ROLEID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"创建人", @"content" : @"", @"id" : @"C_CREATOR_ROLEID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"性别", @"content" : @"", @"id" : @"C_SEX_DD_ID"}]];
        } else {//粉丝
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"员工", @"content" : @"", @"id" : @"USER_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"等级", @"content" : @"", @"id" : @"C_LEVEL_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"类型", @"content" : @"", @"id" : @"C_TYPE_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"客户状态", @"content" : @"", @"id" : @"C_STATUS_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"活跃时间", @"content" : @"", @"id" : @"LASTUPDATE_TIME_TYPE"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"星标客户", @"content" : @"", @"id" : @"C_STAR_DD_ID"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"创建时间", @"content" : @"", @"id" : @"CREATE_TIME_TYPE"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"搜索数量", @"content" : @"50", @"id" : @"returnCountType",@"C_ID" : @"0"}]];
            [_listDataArray addObject:[NSMutableDictionary dictionaryWithDictionary:@{@"title" : @"下次跟进时间", @"content" : @"", @"id" : @"LASTFOLLOW_TIME_TYPE"}]];
        }
    }
    return _listDataArray;
}

- (NSMutableDictionary *)customTimeDic {
    if (!_customTimeDic) {
        _customTimeDic = [NSMutableDictionary dictionary];
    }
    return _customTimeDic;
}
        
@end
