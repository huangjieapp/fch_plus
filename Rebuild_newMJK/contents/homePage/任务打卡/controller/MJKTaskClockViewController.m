//
//  MJKTaskClockViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/2/21.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKTaskClockViewController.h"
#import "MJKTaskClockDetailViewController.h"

#import "MJKAddTaskClockViewController.h"

#import "MJKTaskClockMainModel.h"
#import "MJKTaskClockModel.h"

#import "MJKTaskClockTableViewCell.h"

#import "CFDropDownMenuView.h"

#import "CGCCustomDateView.h"

#import "CGCNavSearchTextView.h"

@interface MJKTaskClockViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pages;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) CFDropDownMenuView *menuView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *TableSelectedChooseDatas;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *TableChooseDatas;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveSelTimeDict;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveSelTableDict;
/** <#注释#>*/
@property (nonatomic, strong) UILabel *allNumberLabel;
/** <#注释#>*/
@property (nonatomic, strong) CGCNavSearchTextView *CurrentTitleView;


@end

@implementation MJKTaskClockViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"任务打卡";
    [self.view addSubview:self.tableView];
    [self initNavi];
    [self configUI];
    [self configRefresh];
    [self addChooseView];
}

- (void)initNavi {
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入姓名" withRecord:^{//点击录音

        
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        [weakSelf.saveSelTableDict setObject:str forKey:@"USER_ID"];
        [weakSelf.tableView.mj_header beginRefreshing];
        
    }];
    self.CurrentTitleView.recordBtn.hidden = YES;
    
    self.navigationItem.titleView = self.CurrentTitleView;
    
}

- (void)configUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"+" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30.f];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addTaskClock) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

-(void)addChooseView{
    DBSelf(weakSelf);
    NSMutableArray*TypeArr=[NSMutableArray arrayWithObjects:@"全部", nil];
    NSMutableArray*TypeSelectedArr=[NSMutableArray arrayWithObjects:@"", nil];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A46400_C_TYPE"] ) {
        [TypeArr addObject:model.C_NAME];
        [TypeSelectedArr addObject:model.C_VOUCHERID];
    }
    
    NSMutableArray*statusArr=[NSMutableArray arrayWithObjects:@"全部", nil];
    NSMutableArray*statusSelectedArr=[NSMutableArray arrayWithObjects:@"", nil];
    for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A46400_C_STATUS"] ) {
        [statusArr addObject:model.C_NAME];
        [statusSelectedArr addObject:model.C_VOUCHERID];
    }
    
    
    
    
    //期望开始时间
    NSArray * expectBegintitleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * expectBeginidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
    
    
    //总的 筛选tableView 的数据
    NSMutableArray *totailTableDatas=[NSMutableArray arrayWithObjects:statusArr,TypeArr,expectBegintitleArr, nil];
    NSMutableArray *totailTAbleSelected=[NSMutableArray arrayWithObjects:statusSelectedArr,TypeSelectedArr ,expectBeginidArr, nil];
    
    
    self.TableChooseDatas=totailTableDatas;
    
    self.TableSelectedChooseDatas=totailTAbleSelected;
    
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    menuView.dataSourceArr=self.TableChooseDatas;
    self.menuView=menuView;
    menuView.defaulTitleArray= @[@"状态",@"类型",@"创建时间"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=weakSelf.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]){
            //状态
            selectKey=@"C_STATUS_DD_ID";
        }else if ([selectedSection isEqualToString:@"1"]){
            //类型
            selectKey=@"C_TYPE_DD_ID";
        }else if ([selectedSection isEqualToString:@"2"]){
            //任务日期
            selectKey=@"CREATE_TIME_TYPE";//@"START_TIME_TYPE";
            [self.saveSelTimeDict removeObjectForKey:@"START_TIME"];
            [self.saveSelTimeDict removeObjectForKey:@"END_TIME"];
            
            
        }
        
        
        if (selectKey) {
            
            [weakSelf.saveSelTableDict setObject:selectValue forKey:selectKey];
            if ([selectValue isEqualToString:@"999"])  {
            }else{
                [weakSelf.tableView.mj_header beginRefreshing];
            }
        }
        
        
        //如果点击的是   自定义
        if ([selectValue isEqualToString:@"999"]) {
            CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                
            } withEnd:^{
                
                
            } withSure:^(NSString *start, NSString *end) {
                MyLog(@"11--%@   22--%@",start,end);
                
                [self.saveSelTimeDict setObject:start forKey:@"START_TIME"];
                [self.saveSelTimeDict setObject:end forKey:@"END_TIME"];
                [self.saveSelTableDict removeObjectForKey:@"CREATE_TIME_TYPE"];
                
                [self.tableView.mj_header beginRefreshing];
                
            }];
            
            
            dateView.clickCancelBlock = ^{
                //选中第一个
                [self.saveSelTimeDict removeObjectForKey:@"START_TIME"];
                [self.saveSelTimeDict removeObjectForKey:@"END_TIME"];
                [self.saveSelTableDict setObject:@"" forKey:@"CREATE_TIME_TYPE"];
                
                [self.tableView.mj_header beginRefreshing];
            };
            
            
            
            [[UIApplication sharedApplication].keyWindow addSubview:dateView];
            
            
            
            
            
        }
        
        
        
    };
    [self.view addSubview:menuView];
    //要写在 chooseView  加载完之后
    [self addTotailView];
    
    
    
    
    
    
}


-(void)addTotailView{
    UIImageView*BGImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-60, NavStatusHeight+40-1, 60, 20)];
    BGImageV.image=[UIImage imageNamed:@"all_bg"];
    BGImageV.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:BGImageV];

    UILabel*allNumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, BGImageV.width, BGImageV.height)];
    allNumberLabel.font=[UIFont systemFontOfSize:11];
    allNumberLabel.textColor=KColorGrayTitle;
    allNumberLabel.text=@"总计:0";
    allNumberLabel.textAlignment=NSTextAlignmentCenter;
    self.allNumberLabel=allNumberLabel;
    [BGImageV addSubview:allNumberLabel];


}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pages = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages = 20;
        [weakSelf getTaskClockData];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages += 20;
        [weakSelf getTaskClockData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addTaskClock {
    if (![[NewUserSession instance].appcode containsObject:@"crm:a464:add"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
    MJKAddTaskClockViewController *vc = [[MJKAddTaskClockViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getTaskClockData {
    DBSelf(weakSelf);
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"currPage"] = @"1";
    contentDict[@"pageSize"] = @(self.pages);
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
    [self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a464/list",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKTaskClockMainModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            NSNumber*number=data[@"data"][@"countNumber"];
            weakSelf.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",number];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MJKTaskClockMainModel *mainModel = self.dataArray[section];
    return mainModel.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTaskClockMainModel *mainModel = self.dataArray[indexPath.section];
    MJKTaskClockModel *model = mainModel.content[indexPath.row];
    MJKTaskClockTableViewCell *cell = [MJKTaskClockTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKTaskClockMainModel *mainModel = self.dataArray[indexPath.section];
    MJKTaskClockModel *model = mainModel.content[indexPath.row];
    MJKTaskClockDetailViewController *vc = [[MJKTaskClockDetailViewController alloc]init];
    vc.C_ID = model.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MJKTaskClockMainModel *mainModel = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
    label.text = mainModel.total;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    [bgView addSubview:label];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 40, KScreenWidth, KScreenHeight - 40 - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
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

-(NSMutableDictionary*)saveSelTimeDict{
    if (!_saveSelTimeDict) {
        _saveSelTimeDict=[NSMutableDictionary dictionary];
    }
    return _saveSelTimeDict;
}
@end
