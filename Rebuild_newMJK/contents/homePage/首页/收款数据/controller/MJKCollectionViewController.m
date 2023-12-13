//
//  MJKCollectionViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCollectionViewController.h"
#import "MJKNewAddDealViewController.h"

#import "MJKTitleTabView.h"
#import "MJKPayTableViewCell.h"
#import "MJKPayDetailInfoTableViewCell.h"
#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"

#import "MJKClueListViewModel.h"
#import "MJKClueListSubModel.h"
#import "MJKPayModel.h"
#import "MJKOrderMoneyListModel.h"

@interface MJKCollectionViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSString *chooseTabStr;
/** mbArray*/
@property (nonatomic, strong) NSArray *mbArray;
/** 每页/条*/
@property (nonatomic, assign) NSInteger pagen;
/** CFDropDownMenuView*/
@property (nonatomic, strong) CFDropDownMenuView *menuView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveSelTableDict;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveSelTimeDict;
/** <#注释#>*/
@property (nonatomic, strong) MJKTitleTabView *secondTabView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *totalArray;
/** <#注释#>*/
@property (nonatomic, strong) UIView *dateView;
/** dateLabel*/
@property (nonatomic, strong) UILabel *dateLabel;
/** <#注释#>*/
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *serachDateStr;
/** <#注释#>*/
@property (nonatomic, strong) NSString *SKCOUNT_ALL;
@property (nonatomic, strong) NSString *WCBL_ALL;
/** <#注释#>*/
@property (nonatomic, strong) MJKTitleTabView *tabView;

/** <#注释#>*/
@property (nonatomic, strong) UIImageView *bgImageView;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *totalLabel;
@end

@implementation MJKCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"收款";
    self.view.backgroundColor = [UIColor whiteColor];
    self.chooseTabStr = self.tabStr;
    if ([self.chooseTabStr isEqualToString:@"收款明细"]) {
        [self.saveSelTableDict setObject:@"1" forKey:@"COLLECTION_TIME_TYPE"];//默认今天
    }
    [self initUI];
    [self getSalesListDatas];
    [self configRefresh];
    
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        if ([weakSelf.chooseTabStr isEqualToString:@"目标进度"]) {
            [weakSelf httpGetMBData];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"金额龙虎榜"]) {
            weakSelf.typeStr = @"0";
            [weakSelf httpGetSKData];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"完成率龙虎榜"]) {
            weakSelf.typeStr = @"1";
            [weakSelf httpGetSKData];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"收款明细"]) {
            
            [weakSelf httpGetDetailInfo];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        if ([weakSelf.chooseTabStr isEqualToString:@"目标进度"]) {
            [weakSelf httpGetMBData];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"金额龙虎榜"]) {
            weakSelf.typeStr = @"0";
            [weakSelf httpGetSKData];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"完成率龙虎榜"]) {
            weakSelf.typeStr = @"1";
            [weakSelf httpGetSKData];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"收款明细"]) {
            [weakSelf httpGetDetailInfo];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUI {
    DBSelf(weakSelf);
    MJKTitleTabView *tabView = [[MJKTitleTabView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 50) withTitleArray:@[@"目标进度",@"金额龙虎榜",@"完成率龙虎榜",@"收款明细"] andIsCanChooseTab:YES isSepView:NO];
    self.tabView = tabView;
    tabView.selectButtonTitle = self.tabStr;
    tabView.chooseTabBlock = ^(NSString * _Nonnull buttonTitle) {
        weakSelf.serachDateStr = @"";
        
        [weakSelf.menuView hide];
        
        weakSelf.dateView.hidden = NO;
        CGRect menuFreme = weakSelf.menuView.frame;
        menuFreme.origin.y = CGRectGetMaxY(weakSelf.dateView.frame);
        weakSelf.menuView.frame = menuFreme;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        df.dateFormat = @"yyyy年MM月";
        NSString *dateStr = [df stringFromDate:date];
        weakSelf.dateLabel.text = dateStr;
        
        df.dateFormat = @"yyyy-MM";
        weakSelf.serachDateStr = [df stringFromDate:date];
        weakSelf.menuView.selectedButtonIndex = 0;
        if ([buttonTitle isEqualToString:@"目标进度"]) {
            weakSelf.chooseTabStr = @"目标进度";
        } else if ([buttonTitle isEqualToString:@"金额龙虎榜"]) {
            weakSelf.chooseTabStr = @"金额龙虎榜";
        } else if ([buttonTitle isEqualToString:@"完成率龙虎榜"]) {
            weakSelf.chooseTabStr = @"完成率龙虎榜";
        } else if ([buttonTitle isEqualToString:@"收款明细"]) {
            [weakSelf.saveSelTimeDict removeAllObjects];
            [weakSelf.saveSelTableDict setObject:@"1" forKey:@"COLLECTION_TIME_TYPE"];//默认今天
            weakSelf.chooseTabStr = @"收款明细";
            CGRect menuFreme = weakSelf.menuView.frame;
            menuFreme.origin.y = CGRectGetMaxY(weakSelf.dateView.frame) - 50;
            weakSelf.menuView.frame = menuFreme;
            weakSelf.dateView.hidden = YES;
        }
        [weakSelf.tableView.mj_header beginRefreshing];
        
        
        CGRect tableFrame = weakSelf.tableView.frame;
        tableFrame.origin.y = CGRectGetMaxY(weakSelf.menuView.frame);
        tableFrame.size.height = KScreenHeight - tableFrame.origin.y - SafeAreaBottomHeight;
        weakSelf.tableView.frame = tableFrame;
        
        if ([weakSelf.chooseTabStr isEqualToString:@"收款明细"]) {
            weakSelf.menuView.typeName = @"image";
            weakSelf.menuView.dataSourceArr = weakSelf.totalArray;
            weakSelf.menuView.defaulTitleArray= @[@"今天",@"金额",@"类型",@"收款人"];
        } else {
            weakSelf.menuView.typeName = @"noImage";
            if ([weakSelf.chooseTabStr isEqualToString:@"目标进度"]) {
                weakSelf.menuView.dataSourceArr = [@[@[],@[],@[]] mutableCopy];
                weakSelf.menuView.defaulTitleArray = @[@"日期", @"金额", @"占比",@""];
            } else if ([weakSelf.chooseTabStr isEqualToString:@"金额龙虎榜"]) {
                weakSelf.menuView.dataSourceArr = [@[@[],@[],@[],@[]] mutableCopy];
                weakSelf.menuView.defaulTitleArray = @[@"员工",@"销量目标",@"实际收款",@"完成率"];
            } else if ([weakSelf.chooseTabStr isEqualToString:@"完成率龙虎榜"]) {
                weakSelf.menuView.dataSourceArr = [@[@[],@[],@[],@[]] mutableCopy];
                weakSelf.menuView.defaulTitleArray = @[@"员工",@"销量目标",@"实际收款",@"完成率"];
            }
        }
        
    };
    [self.view addSubview:tabView];
    
    
    
    
    
    [self.view addSubview:self.tableView];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 115, CGRectGetMaxY(tabView.frame)+40, 100, 20)];
    self.bgImageView = bgImageView;
    bgImageView.image = [UIImage imageNamed:@"all_bg"];
    [weakSelf.view addSubview:bgImageView];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgImageView.frame.size.width, bgImageView.frame.size.height)];
    self.totalLabel = totalLabel;
    totalLabel.textColor = [UIColor darkGrayColor];
    totalLabel.font = [UIFont systemFontOfSize:12.f];
    totalLabel.text = @"金额:0.0万 数量:0";
    [bgImageView addSubview:totalLabel];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.mbArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MJKPayModel *model = self.mbArray[indexPath.row];
    if ([self.chooseTabStr isEqualToString:@"目标进度"]) {
        MJKPayTableViewCell *cell = [MJKPayTableViewCell cellWithTableView:tableView];
        cell.chooseTabStr = self.chooseTabStr;
        cell.payModel = model;
        return cell;
    } else {
        MJKPayDetailInfoTableViewCell *cell = [MJKPayDetailInfoTableViewCell cellWithTableView:tableView];
        cell.chooseTabStr = self.chooseTabStr;
        cell.payModel = model;
        if ([self.chooseTabStr isEqualToString:@"金额龙虎榜"] || [self.chooseTabStr isEqualToString:@"完成率龙虎榜"]) {
            cell.rankImageView.hidden = NO;
            if (indexPath.row == 0) {
                cell.rankImageView.image = [UIImage imageNamed:@"第一名"];
            } else if (indexPath.row == 1) {
                cell.rankImageView.image = [UIImage imageNamed:@"第二名"];
            } else if (indexPath.row == 2) {
                cell.rankImageView.image = [UIImage imageNamed:@"第三名"];
            } else {
                cell.rankImageView.hidden = YES;
            }
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([self.chooseTabStr isEqualToString:@"目标进度"]) {
        return 44;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ([self.chooseTabStr isEqualToString:@"目标进度"]) {
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        bgView.backgroundColor = [UIColor whiteColor];
        
        UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 1)];
        sepView.backgroundColor = kBackgroundColor;
        [bgView addSubview:sepView];
        
        for (int i = 0; i < 3; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * (KScreenWidth / 3), 0, KScreenWidth / 3, 44)];
            label.textColor = [UIColor darkGrayColor];
            label.font = [UIFont systemFontOfSize:14.f];
            label.textAlignment = NSTextAlignmentCenter;
            if (i == 0) {
                label.text = @"总计";
            } else if (i == 1) {
                label.text = self.SKCOUNT_ALL;
            } else {
                label.text = self.WCBL_ALL;
            }
            [bgView addSubview:label];
        }
        return bgView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.chooseTabStr isEqualToString:@"收款明细"]) {
         MJKPayModel *model = self.mbArray[indexPath.row];
        MJKNewAddDealViewController *vc = [[MJKNewAddDealViewController alloc]init];
        vc.vcName = @"收款目标明细";
        MJKOrderMoneyListModel *payModel = [[MJKOrderMoneyListModel alloc]init];
        payModel.C_A04200_C_ID = model.C_ID;
        vc.model = payModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (![[NewUserSession instance].appcode containsObject:@"APP017_0005"]) {
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
        [self.saveSelTableDict removeAllObjects];
        MJKPayModel *model = self.mbArray[indexPath.row];
        if ([self.chooseTabStr isEqualToString:@"目标进度"]) {
            [self.saveSelTimeDict setObject:model.dateTime forKey:@"COLLECTION_START_TIME"];
            [self.saveSelTimeDict setObject:model.dateTime forKey:@"COLLECTION_END_TIME"];
        } else {
            NSDateFormatter *df = [[NSDateFormatter alloc]init];
            df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
            df.dateFormat = @"yyyy年MM月";
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[df dateFromString:self.dateLabel.text]];
            NSUInteger numberOfDaysInMonth = range.length;
            
            
            [self.saveSelTimeDict setObject:[NSString stringWithFormat:@"%@-01",self.serachDateStr] forKey:@"COLLECTION_START_TIME"];
            [self.saveSelTimeDict setObject:[NSString stringWithFormat:@"%@-%lu",self.serachDateStr,(unsigned long)numberOfDaysInMonth] forKey:@"COLLECTION_END_TIME"];
            
            [self.saveSelTableDict setObject:model.userid forKey:@"USER_ID"];
        }
        
        self.tabView.selectButtonTitle = @"收款明细";
        self.chooseTabStr = @"收款明细";
        
        self.menuView.typeName = @"image";
        self.menuView.dataSourceArr = self.totalArray;
        self.menuView.defaulTitleArray= @[@"时间",@"金额",@"类型",model.username.length > 0 ? model.username : @"收款人"];
        
        CGRect menuFreme = self.menuView.frame;
        menuFreme.origin.y = CGRectGetMaxY(self.dateView.frame) - 50;
        self.menuView.frame = menuFreme;
        self.dateView.hidden = YES;
        
        CGRect tableFrame = self.tableView.frame;
        tableFrame.origin.y = CGRectGetMaxY(self.menuView.frame);
        tableFrame.size.height = KScreenHeight - tableFrame.origin.y - SafeAreaBottomHeight;
        self.tableView.frame = tableFrame;
        
        [tableView.mj_header beginRefreshing];
    }
}

- (NSString *)preOrNextMonthAndDate:(NSString *)str andPreNextStr:(NSString *)preNextStr {
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.dateFormat = @"yyyy年MM月";
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    if ([preNextStr isEqualToString:@"上个月"]) {
        [comps setMonth:-1];
    } else {
        [comps setMonth:1];
    }
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:[df dateFromString:str] options:0];
    return [df stringFromDate:mDate];
}

- (void)preOrNextAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"<"]) {
        self.dateLabel.text = [self preOrNextMonthAndDate:self.dateLabel.text andPreNextStr:@"上个月"];
    } else {
        self.dateLabel.text = [self preOrNextMonthAndDate:self.dateLabel.text andPreNextStr:@"下个月"];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.dateFormat = @"yyyy年MM月";
    NSDate *selectDate = [df dateFromString:self.dateLabel.text];
    df.dateFormat = @"yyyy-MM";
    
    self.serachDateStr = [df stringFromDate:selectDate];
    [self.tableView.mj_header beginRefreshing];
}

-(void)addChooseView:(MJKClueListViewModel *)model{
    DBSelf(weakSelf);
    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 50, KScreenWidth, 50)];
    self.dateView = dateView;
    dateView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    df.dateFormat = @"yyyy年MM月";
    NSString *dateStr = [df stringFromDate:date];
    label.text = dateStr;
    CGSize size = [dateStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
    label.frame = CGRectMake((dateView.frame.size.width - (size.width + 20)) / 2, 0, size.width + 10, 50);
    self.dateLabel = label;
    [dateView addSubview:label];
    [self.view addSubview:dateView];
    
    UIButton *preButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(label.frame) - 40, 10, 20, 30)];
    [preButton setTitleNormal:@"<"];
    [preButton setTitleColor:[UIColor darkGrayColor]];
    [preButton addTarget:self action:@selector(preOrNextAction:)];
    [dateView addSubview:preButton];
    
    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 20, 10, 20, 30)];
    [nextButton setTitleNormal:@">"];
    [nextButton setTitleColor:[UIColor darkGrayColor]];
    [dateView addSubview:nextButton];
    [nextButton addTarget:self action:@selector(preOrNextAction:)];
    
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 50 + 50, KScreenWidth, 40)];
//    if ([self.chooseTabStr isEqualToString:@"收款明细"]) {
//        menuView.hidden = NO;
//    } else {
//        menuView.hidden = YES;
//    }
    self.menuView = menuView;
    menuView.VCName = @"首页收款";
    NSArray *timeNameArr = @[@"全部",@"今天",@"昨天",@"本周",@"上周",@"本月",@"上月",@"自定义"];
    NSArray *timeCodeArr = @[@"",@"1",@"4",@"2",@"5",@"3",@"6",@"999"];
    
    
    NSArray *acountNameArr = @[@"默认",@"高到低",@"低到高"];
    NSArray *acountCodeArr = @[@"",@"1",@"0"];
    
    NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A04200_C_TYPE"];
    NSMutableArray*typeNameArr=[NSMutableArray array];
    NSMutableArray*typeCodeArr=[NSMutableArray array];
    [typeNameArr addObject:@"全部"];
    [typeCodeArr addObject:@""];
    for (MJKDataDicModel*model1 in dataArray) {
        [typeNameArr addObject:model1.C_NAME];
        [typeCodeArr addObject:model1.C_VOUCHERID];
    }
    
    NSMutableArray*userNameArr=[NSMutableArray array];
    NSMutableArray*userCodeArr=[NSMutableArray array];
    [userNameArr addObject:@"全部"];
    [userCodeArr addObject:@""];
    for (int i = 0; i < model.data.count; i++) {
        MJKClueListSubModel *subModel = model.data[i];
        [userNameArr addObject:subModel.nickName];
        [userCodeArr addObject:subModel.u051Id];
    }
    
    NSMutableArray *TableChooseDatas = [NSMutableArray arrayWithObjects:timeNameArr, acountNameArr, typeNameArr, userNameArr, nil];
    self.totalArray = [NSMutableArray arrayWithArray:TableChooseDatas];
    NSMutableArray *TableSelectedChooseDatas = [NSMutableArray arrayWithObjects:timeCodeArr, acountCodeArr, typeCodeArr, userCodeArr, nil];
    
    menuView.dataSourceArr=TableChooseDatas;
    
    
    menuView.defaulTitleArray= @[@"今天",@"金额",@"类型",@"收款人"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
            if ([selectedSection isEqualToString:@"0"]) {
                //时间
                if ([title isEqualToString:@"自定义"]) {
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                        
                    } withSure:^(NSString *start, NSString *end) {
                        MyLog(@"11--%@   22--%@",start,end);
                        [self.saveSelTableDict removeObjectForKey:@"COLLECTION_TIME_TYPE"];
                        [self.saveSelTimeDict setObject:start forKey:@"COLLECTION_START_TIME"];
                        [self.saveSelTimeDict setObject:end forKey:@"COLLECTION_END_TIME"];
                        
                        [self.tableView.mj_header beginRefreshing];
                        
                    }];
                    
                    
                    dateView.clickCancelBlock = ^{
                        [self.saveSelTimeDict removeObjectForKey:@"COLLECTION_START_TIME"];
                        [self.saveSelTimeDict removeObjectForKey:@"COLLECTION_END_TIME"];
                        
                    };
                    
                    
                    
                    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
                    return ;
                }
                selectKey=@"COLLECTION_TIME_TYPE";
                [self.saveSelTimeDict removeObjectForKey:@"COLLECTION_START_TIME"];
                [self.saveSelTimeDict removeObjectForKey:@"COLLECTION_END_TIME"];
                
            }else if ([selectedSection isEqualToString:@"1"]){
                //金额
                selectKey = @"PX_TYPE";
            }else if ([selectedSection isEqualToString:@"2"]){
                //状态
                selectKey=@"C_TYPE_DD_ID";
            }else if ([selectedSection isEqualToString:@"3"]){
                //负责人
                selectKey=@"USER_ID";
            }
        
            
        if (selectKey.length > 0) {
            [self.saveSelTableDict setObject:selectValue forKey:selectKey];
            [weakSelf.tableView.mj_header beginRefreshing];
        }
    
        
        
    };
    [self.tableView reloadData];
    [self.view addSubview:menuView];
    
    
    
    if ([self.chooseTabStr isEqualToString:@"收款明细"]) {
        menuView.typeName = @"image";
        menuView.defaulTitleArray= @[@"今天",@"金额",@"类型",@"收款人"];
        dateView.hidden = YES;
        CGRect menuFreme = menuView.frame;
        menuFreme.origin.y = CGRectGetMaxY(dateView.frame) - 50;
        self.menuView.frame = menuFreme;
    } else {
        dateView.hidden = NO;
        menuView.typeName = @"noImage";
       
        if ([self.chooseTabStr isEqualToString:@"目标进度"]) {
            self.menuView.dataSourceArr = [@[@[],@[],@[]] mutableCopy];
            menuView.defaulTitleArray = @[@"日期", @"金额", @"占比"];
        } else if ([self.chooseTabStr isEqualToString:@"金额龙虎榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[],@[],@[]] mutableCopy];
            menuView.defaulTitleArray = @[@"员工",@"销量目标",@"实际收款",@"完成率"];
        } else if ([self.chooseTabStr isEqualToString:@"完成率龙虎榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[],@[],@[]] mutableCopy];
            menuView.defaulTitleArray = @[@"员工",@"销量目标",@"实际收款",@"完成率"];
        }
    }
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = CGRectGetMaxY(self.menuView.frame);
    tableFrame.size.height = KScreenHeight - tableFrame.origin.y - SafeAreaBottomHeight;
    self.tableView.frame = tableFrame;
    
}

#pragma mark - data
-(void)getSalesListDatas {
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            MJKClueListViewModel*saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            [weakSelf addChooseView:saleDatasModel];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

- (void)httpGetMBData {
    if (![[NewUserSession instance].appcode containsObject:@"APP017_0002"]) {
        self.SKCOUNT_ALL = @"0";
        self.WCBL_ALL = @"0";
        self.mbArray = nil;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [JRToast showWithText:@"账号无权限"];
        return ;
    }
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A04200WebService-getCountListByDay"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"searchTime"] = self.serachDateStr;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.SKCOUNT_ALL = data[@"SKCOUNT_ALL"];
            weakSelf.WCBL_ALL = data[@"WCBL_ALL"];
            weakSelf.mbArray = [MJKPayModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)httpGetSKData {
    if ([self.chooseTabStr isEqualToString:@"金额龙虎榜"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP017_0003"]) {
            self.mbArray = nil;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
    }
    if ([self.chooseTabStr isEqualToString:@"完成率龙虎榜"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP017_0004"]) {
            self.mbArray = nil;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self.tableView reloadData];
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
    }
    
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A04200WebService-getPKCountByStore"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.typeStr.length > 0) {
        contentDic[@"type"] = self.typeStr;
    }
    if (self.serachDateStr.length > 0) {
        contentDic[@"searchTime"] = self.serachDateStr;
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mbArray = [MJKPayModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)httpGetDetailInfo {
    if (![[NewUserSession instance].appcode containsObject:@"APP017_0005"]) {
        self.mbArray = nil;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        [JRToast showWithText:@"账号无权限"];
        return ;
    }
    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A04200WebService-getList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = @(self.pagen);
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        contentDic[key] = obj;
    }];
    [self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        contentDic[key] = obj;
    }];
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mbArray = [MJKPayModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
            
            NSString *totalStr = [NSString stringWithFormat:@"金额:%@ 数量:%@",data[@"sum"], data[@"countNumber"]];
            CGFloat totalWidth = [totalStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size.width;
            CGRect imageFrame = weakSelf.bgImageView.frame;
            imageFrame.origin.x = KScreenWidth - totalWidth - 3;
            imageFrame.size.width = totalWidth;
            weakSelf.bgImageView.frame = imageFrame;
            
            
            CGRect totalFrame = weakSelf.totalLabel.frame;
            totalFrame.size.width = totalWidth;
            weakSelf.totalLabel.frame = totalFrame;
            weakSelf.totalLabel.text = totalStr;
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}


#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 50 + 40, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - 50 - WD_TabBarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}


-(NSMutableDictionary *)saveSelTableDict{
    if (!_saveSelTableDict) {
        _saveSelTableDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTableDict;
}
//saveSelTimeDict
-(NSMutableDictionary *)saveSelTimeDict{
    if (!_saveSelTimeDict) {
        _saveSelTimeDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTimeDict;
}
@end
