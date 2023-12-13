//
//  MJKTelephoneRobotDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotDetailViewController.h"

#import "MJKTelephoneRobotDetailCell.h"
#import "MJKTelephoneRoboCalltResultCell.h"
#import "MJKTelephoneRoboFirstCalltResultCell.h"
#import "MJKTelephoneRoboRepeatCalltResultCell.h"

#import "MJKTelephoneRobotResultViewController.h"

@interface MJKTelephoneRobotDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** list data array*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
/** C_A70100_C_ID*/
@property (nonatomic, strong) NSString *C_A70100_C_ID;
/** show all button*/
@property (nonatomic, strong) UIButton *showAllButton;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *callLengthArrray;
@property (nonatomic, strong) NSMutableArray *callFirstArrray;
@property (nonatomic, strong) NSMutableArray *callRepeatArrray;
@end

@implementation MJKTelephoneRobotDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"任务报告";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.showAllButton];
    [self HTTPListData];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.listDataArray[section][@"content"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.listDataArray[indexPath.section][@"content"];
    NSDictionary *dic = arr[indexPath.row];
    if ([dic[@"title"] isEqualToString:@"通话时长分布"]) {
        MJKTelephoneRoboCalltResultCell *cell = [MJKTelephoneRoboCalltResultCell cellWithTableView:tableView];
        cell.titleLabel.text = dic[@"title"];
        for (int i = 0; i < cell.contentLabelArray.count; i++) {
            UILabel *label = cell.contentLabelArray[i];
            label.text = [NSString stringWithFormat:@"%@",self.callLengthArrray[i] ] ;
        }
        return cell;
    } else if ([dic[@"title"] isEqualToString:@"首次拨打分析"]) {
        MJKTelephoneRoboFirstCalltResultCell *cell = [MJKTelephoneRoboFirstCalltResultCell cellWithTableView:tableView];
        cell.titleLabel.text = dic[@"title"];
        for (int i = 0; i < cell.contentLabelArray.count; i++) {
            UILabel *label = cell.contentLabelArray[i];
            label.text = [NSString stringWithFormat:@"%@",self.callFirstArrray[i] ];
        }
        return cell;
    } else if ([dic[@"title"] isEqualToString:@"重拨分析"]) {
        MJKTelephoneRoboRepeatCalltResultCell *cell = [MJKTelephoneRoboRepeatCalltResultCell cellWithTableView:tableView];
        cell.titleLabel.text = dic[@"title"];
//        for (int i = 0; i < cell.contentLabelArray.count; i++) {
//            UILabel *label = cell.contentLabelArray[i];
//            label.text = self.callLengthArrray[i];
//        }
        return cell;
    } else {
        
        MJKTelephoneRobotDetailCell *cell = [MJKTelephoneRobotDetailCell cellWithTableView:tableView];
        if (indexPath.section != 0 && indexPath.section != 1) {
            cell.arrowRightImageView.hidden = NO;
        } else {
            cell.arrowRightImageView.hidden = YES;
            cell.contentLabelLayout.constant = -10;
        }
        cell.titleLabel.text=dic[@"title"];
        NSString *contentStr;
        if ([dic[@"content"] isKindOfClass:[NSNumber class]]) {
           contentStr = [NSString stringWithFormat:@"%@",dic[@"content"]];
        } else {
            contentStr = dic[@"content"];
        }
        if ([contentStr length] > 0) {
            cell.contentLabel.text = contentStr;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ((indexPath.section == 0 && indexPath.row == 1) || indexPath.section == 2 ) {
        MJKTelephoneRobotResultViewController *vc = [[MJKTelephoneRobotResultViewController alloc]init];
        vc.C_A70100_C_ID = self.C_A70100_C_ID;
        if (indexPath.section == 2) {
            NSDictionary *resultDic = self.listDataArray[2];
            NSMutableDictionary *subDic = resultDic[@"content"][indexPath.row];
            vc.intentionDesc = subDic[@"title"];
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.listDataArray[indexPath.section][@"content"];
    NSDictionary *dic = arr[indexPath.row];
    if ([dic[@"title"] isEqualToString:@"通话时长分布"] || [dic[@"title"] isEqualToString:@"重拨分析"]) {
        return 132;
    } else if ([dic[@"title"] isEqualToString:@"首次拨打分析"]) {
        return 220;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = self.listDataArray[section][@"title"];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 30)];
    label.text = title;
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 点击
- (void)showAllAction:(UIButton *)sender {
    MJKTelephoneRobotResultViewController *vc = [[MJKTelephoneRobotResultViewController alloc]init];
    vc.C_A70100_C_ID = self.C_A70100_C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http

- (void)HTTPListData {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70100WebService-getBeanById"];
    NSMutableDictionary *contentDic=[NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.C_A70100_C_ID = data[@"C_ID"];
            NSDictionary *basicDic = self.listDataArray[0];
            for (NSMutableDictionary *subDic in basicDic[@"content"]) {
                if ([subDic[@"title"] isEqualToString:@"呼叫任务数量"]) {
                    subDic[@"content"] = data[@"I_NUMBER"];
                } else if ([subDic[@"title"] isEqualToString:@"呼叫任务来源"]) {
                    subDic[@"content"] = data[@"C_SOURCE_DD_NAME"];
                } else if ([subDic[@"title"] isEqualToString:@"最早呼叫时间"]) {
                    subDic[@"content"] = data[@"zzhjsj"];
                } else if ([subDic[@"title"] isEqualToString:@"最晚呼叫时间"]) {
                    subDic[@"content"] = data[@"zwhjsj"];
                } else if ([subDic[@"title"] isEqualToString:@"总外呼耗时"]) {
                    subDic[@"content"] = data[@"zzwhhs"];
                } else if ([subDic[@"title"] isEqualToString:@"呼叫任务名称"]) {
                    subDic[@"content"] = data[@"C_NAME"];
                } else if ([subDic[@"title"] isEqualToString:@"平均通话时间"]) {
                    subDic[@"content"] = data[@"pjthsj"];
                } else if ([subDic[@"title"] isEqualToString:@"通话时长分布"]) {
                    weakSelf.callLengthArrray = [NSMutableArray array];
                    [weakSelf.callLengthArrray addObject:data[@"fb_1"]];
                    [weakSelf.callLengthArrray addObject:data[@"fb_2"]];
                    [weakSelf.callLengthArrray addObject:data[@"fb_3"]];
                    [weakSelf.callLengthArrray addObject:data[@"fb_4"]];
                }
            }
            
            
            NSDictionary *whDic = self.listDataArray[1];
            for (NSMutableDictionary *subDic in whDic[@"content"]) {
                if ([subDic[@"title"] isEqualToString:@"首次拨打分析"]) {
                    weakSelf.callFirstArrray = [NSMutableArray array];
                    [weakSelf.callFirstArrray addObject:data[@"ybdCount"]];
                    [weakSelf.callFirstArrray addObject:data[@"wbdCount"]];
                    [weakSelf.callFirstArrray addObject:data[@"yjtCount"]];
                    [weakSelf.callFirstArrray addObject:data[@"wjtCount"]];
                    [weakSelf.callFirstArrray addObject:data[@"yjtCountBl"]];
                    [weakSelf.callFirstArrray addObject:data[@"wjtCountBl"]];
                }  else if ([subDic[@"title"] isEqualToString:@"重拨分析"]) {
                    weakSelf.callRepeatArrray = [NSMutableArray array];
                }
            }
            
            
            NSDictionary *intentionDic = self.listDataArray[2];
            [intentionDic[@"content"] removeAllObjects];
            NSArray *yxList = data[@"yxList"];
            for (int i = 0; i < [yxList count]; i++) {
                NSMutableDictionary *subDic = [NSMutableDictionary dictionary];
                NSDictionary *yxDic = data[@"yxList"][i];
                subDic[@"title"] = yxDic[@"name"];
                subDic[@"content"] = yxDic[@"count"];
                [intentionDic[@"content"] addObject:subDic];
            }
            
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 44) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIButton *)showAllButton {
    if (!_showAllButton) {
        _showAllButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 44, KScreenWidth, 44)];
        [_showAllButton setTitleNormal:@"查看任务详情"];
        _showAllButton.backgroundColor = KNaviColor;
        [_showAllButton setTitleColor:[UIColor blackColor]];
        [_showAllButton addTarget:self action:@selector(showAllAction:)];
    }
    return _showAllButton;
}

- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
        
        NSMutableArray *basicArr = [NSMutableArray array];
        NSArray *basicTitleArray = [NSArray arrayWithObjects:@"呼叫任务名称",@"呼叫任务来源",@"呼叫任务数量",@"最早呼叫时间",@"最晚呼叫时间",@"总外呼耗时",@"平均通话时间",@"通话时长分布", nil];
        for (NSString *str in basicTitleArray) {
            NSMutableDictionary *basicDic = [NSMutableDictionary dictionary];
            basicDic[@"title"] = str;
            [basicArr addObject:basicDic];
        }
        
        NSMutableArray *whArr = [NSMutableArray array];
        NSArray *whTitleArray = [NSArray arrayWithObjects:@"首次拨打分析",@"重拨分析", nil];
        for (NSString *str in whTitleArray) {
            NSMutableDictionary *whDic = [NSMutableDictionary dictionary];
            whDic[@"title"] = str;
            [whArr addObject:whDic];
        }
        
        
        
        NSMutableArray *intentionArr = [NSMutableArray array];
        NSArray *intentionTitleArray = [NSArray arrayWithObjects:@"不需要",@"在忙",@"没准备装修",@"已装修",@"已加过微信",@"挂断",@"发短信",@"愿意加",@"可能愿意加", nil];
        for (NSString *str in intentionTitleArray) {
            NSMutableDictionary *intentionDic = [NSMutableDictionary dictionary];
            intentionDic[@"title"] = str;
            [intentionArr addObject:intentionDic];
        }
        
        [_listDataArray addObject:@{@"title" : @"基本信息", @"content" : basicArr}];
        [_listDataArray addObject:@{@"title" : @"通话结果分析", @"content" : whArr}];
        
        [_listDataArray addObject:@{@"title" : @"意图", @"content" : intentionArr}];
        
    }
    return _listDataArray;
}

@end
