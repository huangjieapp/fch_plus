//
//  MJKCollectionViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCollectionListViewController.h"
#import "MJKNewAddDealViewController.h"

#import "MJKTitleTabView.h"
#import "MJKPayTableViewCell.h"
#import "MJKNewPayDetailInfoTableViewCell.h"
#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"

#import "MJKClueListViewModel.h"
#import "MJKClueListSubModel.h"
#import "MJKPayModel.h"
#import "MJKOrderMoneyListModel.h"

@interface MJKCollectionListViewController ()<UITableViewDataSource, UITableViewDelegate>
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
@property (nonatomic, strong) CFDropDownMenuView *chooseMenuView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveSelTableDict;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveSelTimeDict;
/** <#注释#>*/
@property (nonatomic, strong) MJKTitleTabView *secondTabView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *totalArray;
@property (nonatomic, strong) NSMutableArray *dataSourceArr;
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

@implementation MJKCollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"榜单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.chooseTabStr = self.tabStr;
    
    //默认本月
    [self.saveSelTableDict setObject:@"3" forKey:@"CREATE_TIME_TYPE"];
    if ([self.chooseTabStr isEqualToString:@"资源榜"]) {
        [self.saveSelTableDict setObject:@"1" forKey:@"bangDanType"];
    }
    [self initUI];
    [self configRefresh];
    
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        if ([weakSelf.chooseTabStr isEqualToString:@"资源榜"]) {
            [weakSelf httpGetCreatDetailInfo];
        } else {
            [weakSelf httpGetDetailInfo];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        if ([weakSelf.chooseTabStr isEqualToString:@"资源榜"]) {
            [weakSelf httpGetCreatDetailInfo];
        } else {
            [weakSelf httpGetDetailInfo];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUI {
    DBSelf(weakSelf);
    [self getSalesListDatas];
    NSMutableArray *titleArr = [NSMutableArray array];//@[@"销量榜",@"预约榜",@"跟进榜",@"资源榜",@"逾期榜"];
        if ([[NewUserSession instance].appcode containsObject:@"home:bangdan:xlb"]) {
            [titleArr addObject:@"销量榜"];
        }
        if ([[NewUserSession instance].appcode containsObject:@"home:bangdan:yyb"]) {
            [titleArr addObject:@"预约榜"];
        }
        if ([[NewUserSession instance].appcode containsObject:@"home:bangdan:gjb"]) {
            [titleArr addObject:@"跟进榜"];
        }
        if ([[NewUserSession instance].appcode containsObject:@"home:bangdan:zyb"]) {
            [titleArr addObject:@"资源榜"];
        }
        if ([[NewUserSession instance].appcode containsObject:@"home:bangdan:yqb"]) {
            [titleArr addObject:@"逾期榜"];
        }
    
    MJKTitleTabView *tabView = [[MJKTitleTabView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 50) withTitleArray:titleArr andIsCanChooseTab:YES isSepView:NO];
    self.tabView = tabView;
    tabView.selectButtonTitle = self.tabStr;
    tabView.chooseTabBlock = ^(NSString * _Nonnull buttonTitle) {
        if ([weakSelf.chooseTabStr isEqualToString:buttonTitle]) {
            return;
        }
        NSArray *timeNameArr = @[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近30天"];
        NSArray *timeCodeArr = @[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"9", @"10",@"30"];
        
        
        NSArray *typeNameArr = @[@"线索新增数",@"潜客新增数",@"线索跟进新增数"];
        NSArray *typeCodeArr = @[@"1", @"2", @"3"];
        
        NSMutableArray *TableChooseDatas = [NSMutableArray arrayWithObjects:timeNameArr, nil];
        NSMutableArray *TableSelectedChooseDatas = [NSMutableArray arrayWithObjects:timeCodeArr, nil];
        
        if ([buttonTitle isEqualToString:@"资源榜"]) {
            [TableChooseDatas addObject:typeNameArr];
            [TableSelectedChooseDatas addObject:typeCodeArr];
        }
        weakSelf.chooseMenuView.dataSourceArr=TableChooseDatas;
        weakSelf.dataSourceArr = TableSelectedChooseDatas;
        if ([buttonTitle isEqualToString:@"资源榜"]) {
            
            weakSelf.chooseMenuView.defaulTitleArray = @[@"本月", @"线索新增数"];
            [weakSelf.saveSelTableDict setObject:@"1" forKey:@"bangDanType"];
        } else {
            weakSelf.chooseMenuView.defaulTitleArray = @[@"本月"];
        }
        [weakSelf.saveSelTableDict setObject:@"3" forKey:@"CREATE_TIME_TYPE"];
        weakSelf.serachDateStr = @"";
        
        
        
        weakSelf.menuView.selectedButtonIndex = 0;
        weakSelf.chooseMenuView.selectedButtonIndex = 0;
        weakSelf.chooseMenuView.setNil = @"nil";
        
        [weakSelf.menuView hide];
        [weakSelf.chooseMenuView hide];
        
        weakSelf.dateView.hidden = NO;
        CGRect menuFreme = weakSelf.menuView.frame;
        menuFreme.origin.y = CGRectGetMaxY(weakSelf.chooseMenuView.frame);
        weakSelf.menuView.frame = menuFreme;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        df.dateFormat = @"yyyy年MM月";
        NSString *dateStr = [df stringFromDate:date];
        weakSelf.dateLabel.text = dateStr;
        
        
        df.dateFormat = @"yyyy-MM";
        weakSelf.serachDateStr = [df stringFromDate:date];
        if ([buttonTitle isEqualToString:@"销量榜"]) {
            weakSelf.chooseTabStr = @"销量榜";
        } else if ([buttonTitle isEqualToString:@"预约榜"]) {
            weakSelf.chooseTabStr = @"预约榜";
        } else if ([buttonTitle isEqualToString:@"跟进榜"]) {
            weakSelf.chooseTabStr = @"跟进榜";
        } else if ([buttonTitle isEqualToString:@"资源榜"]) {
            weakSelf.chooseTabStr = @"资源榜";
        } else if ([buttonTitle isEqualToString:@"逾期榜"]) {
            weakSelf.chooseTabStr = @"逾期榜";
        }
        [weakSelf.tableView.mj_header beginRefreshing];
        
        
        weakSelf.menuView.typeName = @"noImage";
        if ([weakSelf.chooseTabStr isEqualToString:@"销量榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
            weakSelf.menuView.defaulTitleArray= @[@"员工",@"订单数"];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"预约榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
            weakSelf.menuView.defaulTitleArray = @[@"员工", @"预约数"];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"跟进榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
            weakSelf.menuView.defaulTitleArray = @[@"员工",@"跟进数"];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"资源榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
            weakSelf.menuView.defaulTitleArray = @[@"员工",@"数量"];
        } else if ([weakSelf.chooseTabStr isEqualToString:@"逾期榜"]) {
            self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
            weakSelf.menuView.defaulTitleArray = @[@"员工",@"客户数"];
        }
        
        
    };
    [self.view addSubview:tabView];
    
    
    
    
    
    [self.view addSubview:self.tableView];
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 115, CGRectGetMaxY(tabView.frame)+40, 100, 20)];
    self.bgImageView = bgImageView;
    bgImageView.image = [UIImage imageNamed:@"all_bg"];
//    [weakSelf.view addSubview:bgImageView];
    
    UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, bgImageView.frame.size.width, bgImageView.frame.size.height)];
    self.totalLabel = totalLabel;
    totalLabel.textColor = [UIColor darkGrayColor];
    totalLabel.font = [UIFont systemFontOfSize:12.f];
    totalLabel.text = @"金额:0.0万 数量:0";
//    [bgImageView addSubview:totalLabel];
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
    MJKNewPayDetailInfoTableViewCell *cell = [MJKNewPayDetailInfoTableViewCell cellWithTableView:tableView];
    cell.chooseTabStr = self.chooseTabStr;
    cell.payModel = model;
    cell.rankImageView.hidden = NO;
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithHex:@"#efeff4"];
    }
    if (indexPath.row == 0) {
        cell.rankImageView.image = [UIImage imageNamed:@"第一名"];
    } else if (indexPath.row == 1) {
        cell.rankImageView.image = [UIImage imageNamed:@"第二名"];
    } else if (indexPath.row == 2) {
        cell.rankImageView.image = [UIImage imageNamed:@"第三名"];
    } else {
        cell.rankImageView.hidden = YES;
    }
    return cell;
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

- (void)configYM{
    DBSelf(weakSelf);
//    UIView *dateView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 50, KScreenWidth, 50)];
//    self.dateView = dateView;
//    dateView.backgroundColor = kBackgroundColor;
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.textColor = [UIColor darkGrayColor];
//    label.font = [UIFont systemFontOfSize:14.f];
//    NSDate *date = [NSDate date];
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    df.dateFormat = @"yyyy年MM月";
//    NSString *dateStr = [df stringFromDate:date];
//    label.text = dateStr;
//    CGSize size = [dateStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 50) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
//    label.frame = CGRectMake((dateView.frame.size.width - (size.width + 20)) / 2, 0, size.width + 10, 50);
//    self.dateLabel = label;
//    [dateView addSubview:label];
//    [self.view addSubview:dateView];
//
//    UIButton *preButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(label.frame) - 40, 10, 20, 30)];
//    [preButton setTitleNormal:@"<"];
//    [preButton setTitleColor:[UIColor darkGrayColor]];
//    [preButton addTarget:self action:@selector(preOrNextAction:)];
//    [dateView addSubview:preButton];
//
//    UIButton *nextButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame) + 20, 10, 20, 30)];
//    [nextButton setTitleNormal:@">"];
//    [nextButton setTitleColor:[UIColor darkGrayColor]];
//    [dateView addSubview:nextButton];
//    [nextButton addTarget:self action:@selector(preOrNextAction:)];
//
//    df.dateFormat = @"yyyy-MM";
//    self.serachDateStr = [df stringFromDate:date];
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 50, KScreenWidth, 50)];
//    if ([self.chooseTabStr isEqualToString:@"收款明细"]) {
//        menuView.hidden = NO;
//    } else {
//        menuView.hidden = YES;
//    }
    self.chooseMenuView = menuView;
    menuView.VCName = @"榜单筛选";
    NSArray *timeNameArr = @[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近30天"];
    NSArray *timeCodeArr = @[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"9", @"10",@"30"];
    
    
    NSArray *typeNameArr = @[@"线索新增数",@"潜客新增数",@"线索跟进新增数"];
    NSArray *typeCodeArr = @[@"1", @"2", @"3"];
    
    NSMutableArray *TableChooseDatas = [NSMutableArray arrayWithObjects:timeNameArr, nil];
    NSMutableArray *TableSelectedChooseDatas = [NSMutableArray arrayWithObjects:timeCodeArr, nil];
    
    if ([weakSelf.chooseTabStr isEqualToString:@"资源榜"]) {
        [TableChooseDatas addObject:typeNameArr];
        [TableSelectedChooseDatas addObject:typeCodeArr];
    }
    menuView.dataSourceArr=TableChooseDatas;
    self.dataSourceArr = TableSelectedChooseDatas;
    if ([weakSelf.chooseTabStr isEqualToString:@"资源榜"]) {
        menuView.defaulTitleArray = @[@"本月", @"线索新增数"];
    } else {
        menuView.defaulTitleArray= @[@"本月"];
    }
//    self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
    
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=weakSelf.dataSourceArr[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
            if ([selectedSection isEqualToString:@"0"]) {
                //时间
                selectKey=@"CREATE_TIME_TYPE";
            } else if ([selectedSection isEqualToString:@"1"]) {
                selectKey=@"bangDanType";
            }
            [weakSelf.saveSelTableDict setObject:selectValue forKey:selectKey];
            [weakSelf.tableView.mj_header beginRefreshing];
        
    
        
        
    };
//    [dateView addSubview:menuView];
//    [[UIApplication sharedApplication].keyWindow addSubview:dateView];
    [self.view addSubview:menuView];
    
}

-(void)addChooseView:(MJKClueListViewModel *)model{
    DBSelf(weakSelf);
    
    
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
    
//    menuView.dataSourceArr=TableChooseDatas;
    self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
    
    
    menuView.defaulTitleArray= @[@"员工",@"订单数"];
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
    
    
    
    
    self.dateView.hidden = NO;
    menuView.typeName = @"noImage";
   
    if ([self.chooseTabStr isEqualToString:@"销量榜"]) {
        self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
        menuView.defaulTitleArray = @[@"员工",@"订单数"];
    } else if ([self.chooseTabStr isEqualToString:@"预约榜"]) {
        self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
        menuView.defaulTitleArray = @[@"员工", @"预约数"];
    } else if ([self.chooseTabStr isEqualToString:@"跟进榜"]) {
        self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
        menuView.defaulTitleArray = @[@"员工",@"跟进数"];
    } else if ([self.chooseTabStr isEqualToString:@"资源榜"]) {
        self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
        menuView.defaulTitleArray = @[@"员工",@"数量"];
    } else if ([self.chooseTabStr isEqualToString:@"逾期榜"]) {
        self.menuView.dataSourceArr = [@[@[],@[]] mutableCopy];
        menuView.defaulTitleArray = @[@"员工",@"客户数"];
    }
    
    
    CGRect tableFrame = self.tableView.frame;
    tableFrame.origin.y = CGRectGetMaxY(self.menuView.frame);
    tableFrame.size.height = KScreenHeight - tableFrame.origin.y - SafeAreaBottomHeight;
    self.tableView.frame = tableFrame;
    
    
    [self configYM];
    
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

- (void)httpGetDetailInfo {
//    if (![[NewUserSession instance].appcode containsObject:@"APP017_0005"]) {
//        self.mbArray = nil;
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        [self.tableView reloadData];
//        [JRToast showWithText:@"账号无权限"];
//        return ;
//    }
    self.view.userInteractionEnabled = NO;
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            contentDic[key] = obj;
        }
    }];
    if ([self.chooseTabStr isEqualToString:@"销量榜"]) {
        contentDic[@"bangDanType"] = @"3";
    } else if ([self.chooseTabStr isEqualToString:@"预约榜"]) {
        contentDic[@"bangDanType"] = @"0";
    } else if ([self.chooseTabStr isEqualToString:@"跟进榜"]) {
        contentDic[@"bangDanType"] = @"1";
    } else if ([self.chooseTabStr isEqualToString:@"逾期榜"]) {
        contentDic[@"bangDanType"] = @"2";
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/portal/banDanList", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mbArray = [MJKPayModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
//
//            NSString *totalStr = [NSString stringWithFormat:@"金额:%@ 数量:%@",data[@"sum"], data[@"countNumber"]];
//            CGFloat totalWidth = [totalStr boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size.width;
//            CGRect imageFrame = weakSelf.bgImageView.frame;
//            imageFrame.origin.x = KScreenWidth - totalWidth - 3;
//            imageFrame.size.width = totalWidth;
//            weakSelf.bgImageView.frame = imageFrame;
//
//
//            CGRect totalFrame = weakSelf.totalLabel.frame;
//            totalFrame.size.width = totalWidth;
//            weakSelf.totalLabel.frame = totalFrame;
//            weakSelf.totalLabel.text = totalStr;
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.view.userInteractionEnabled = YES;
    }];
}

- (void)httpGetCreatDetailInfo {
    self.view.userInteractionEnabled = NO;
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            contentDic[key] = obj;
        }
    }];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/portal/banDanCreatList", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mbArray = [MJKPayModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.view.userInteractionEnabled = YES;
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
