//
//  WorkCalendarViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "WorkCalendarViewController.h"
//#import "DAYCalendarView.h"
#import "WorkCalendarTableViewCell.h"
#import "ScaleView.h"
#import "YXCalendarView.h"

#import "WorkCalendarModel.h"

#import "CreatRemindViewController.h"
#import "WorkCalendartListViewController.h"
#import "CustomerFollowAddEditViewController.h"

#import "MJKSingleDetailViewController.h"
#import "MJKOrderFllowViewController.h"
#import "AssistFollowViewController.h"
#import "CustomerDetailInfoModel.h"

#import "ServiceTaskPerformViewController.h"
#import "ServiceTaskTrueDetailViewController.h"
#import "CGCAppiontDetailVC.h"

#import "FansFollowAddEditViewController.h"

#define  CELL0   @"WorkCalendarTableViewCell"
@interface WorkCalendarViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*tableView;
//@property(nonatomic,strong)DAYCalendarView *calendarView;
@property(nonatomic,strong)YXCalendarView*calendar;
@property (nonatomic, strong) CustomerDetailInfoModel *detailInfoModel;

@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)NSString*currentTimeStr;  //
@property(nonatomic,strong)NSMutableArray*mainDatasArray;  //所有的数据
@property (nonatomic, strong) WorkCalendarModel*clendarModel;
@end

@implementation WorkCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"工作日历";
    [self creatCalendarView];
    [self creatBottomButton];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setupRefresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark  --UI
-(void)creatCalendarView{
//    self.calendarView=[[DAYCalendarView alloc]initWithFrame:CGRectMake(0, NavigationHeight, KScreenWidth, 250)];
//    self.calendarView.backgroundColor=[UIColor whiteColor];
////    self.calendarView.singleRowMode=YES;
//    [self.view addSubview:self.calendarView];
//    self.calendarView.selectedDate = [NSDate date];
//    [self.calendarView addTarget:self action:@selector(changeSelectedCalendar:) forControlEvents:UIControlEventValueChanged];
//    [self.calendarView updateCurrentVisibleRow];

    
    _calendar = [[YXCalendarView alloc] initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, [YXCalendarView getMonthTotalHeight:[NSDate date] type:CalendarType_Week]) Date:[NSDate date] Type:CalendarType_Week];
    __weak typeof(_calendar) weakCalendar = _calendar;
    _calendar.refreshH = ^(CGFloat viewH) {
        [UIView animateWithDuration:0.3 animations:^{
            weakCalendar.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, viewH);
        }];
        
    };
    DBSelf(weakSelf);
    _calendar.sendSelectDate = ^(NSDate *selDate) {
        NSString*dateStr=[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:selDate];
        //选择后返回的时间，初始当前时间需要自己在init中设置
        
        weakSelf.currentTimeStr=dateStr;
        
        [weakSelf.tableView.mj_header beginRefreshing];
        
        
    };
    [self.view addSubview:_calendar];
    
    _calendar.buttonMonthBlock = ^(NSString *dateStr) {
        //选择后返回的时间，初始当前时间需要自己在init中设置
        weakSelf.currentTimeStr=dateStr;
        [weakSelf.tableView.mj_header beginRefreshing];
    };
    
    
    //初始刷新
    weakSelf.currentTimeStr=[[YXDateHelpObject manager] getStrFromDateFormat:@"yyyy-MM-dd" Date:[NSDate date]];
    [weakSelf.tableView.mj_header beginRefreshing];
    
}



-(void)creatBottomButton{
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithTitle:@"列表" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    rightItem.tintColor=[UIColor blackColor];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    
    self.view.backgroundColor=self.tableView.backgroundColor;
    UIButton*bottomButton=[[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame) + 10, KScreenWidth-40, 40)];
    [bottomButton addTarget:self action:@selector(addCalendar)];
    [bottomButton setTitleNormal:@"添加"];
    [bottomButton setTitleColor:[UIColor blackColor]];
    [bottomButton setBackgroundColor:KNaviColor];
    bottomButton.layer.cornerRadius=5;
    bottomButton.layer.masksToBounds=YES;
    [self.view addSubview:bottomButton];
    
}

-(void)setupRefresh{
    self.pagen=10;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (self.currentTimeStr&&![self.currentTimeStr isEqualToString:@""]) {
            self.pages=1;
            [self httpPostGetTodayInfo];
        }else{
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
      
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
         if (self.currentTimeStr&&![self.currentTimeStr isEqualToString:@""]) {
             self.pages++;
             [self httpPostGetTodayInfo];
         }else{
             [self.tableView.mj_header endRefreshing];
             [self.tableView.mj_footer endRefreshing];
         }
        
    }];
    
    [self.tableView reloadData];
}


#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.mainDatasArray.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkCalendarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    WorkCalendarModel*model=self.mainDatasArray[indexPath.row];
    cell.mainModel=model;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      WorkCalendarModel*model=self.mainDatasArray[indexPath.row];
	self.clendarModel = model;
	if ([model.TYPE_NAME isEqualToString:@"预约"]) {
		CGCAppiontDetailVC *vc = [[CGCAppiontDetailVC alloc]init];
		vc.C_ID = model.C_ID;
        vc.rootVC = self;
		vc.isDiss = [model.C_PROCESS isEqualToString:@"未处理"] ? @"未到店" : @"已到店";
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([model.C_TYPE_DD_ID isEqualToString:@"A41600_C_TYPE_0001"]) {
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpEdit;
        vc.objectID=model.C_ID;
        vc.canEdit=NO;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.TYPE_NAME isEqualToString:@"备忘"]){
        
        CreatRemindViewController*vc=[[CreatRemindViewController alloc]init];
        vc.type=RemindTypeShow;
        vc.C_A41600_C_ID=model.C_ID;
        vc.C_PROCESS=model.C_PROCESS;
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }

    
    if ([model.TYPE_NAME isEqualToString:@"签到"]) {
//         [ScaleView ScaleSignWithModel:model];
        MJKSingleDetailViewController *vc = [[MJKSingleDetailViewController alloc]init];
        vc.C_ID = model.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
	
	if ([model.TYPE_NAME isEqualToString:@"订单跟进"]) {
		MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
		vc.detailModel = [[CGCOrderDetailModel alloc]init];
		vc.detailModel.C_A41500_C_ID = model.C_A41500_C_ID;
		vc.objectID = model.C_ID;
		vc.canEdit = NO;
		vc.isDetail = @"详情";
		[self.navigationController pushViewController:vc animated:YES];
	}
	
	if ([model.TYPE_NAME isEqualToString:@"协助跟进"]) {
		[self httpPostGetCustomerDetailInfoC_A41500:model.C_A41500_C_ID andBlock:^(id data) {
			CustomerDetailInfoModel *customerDodel = [CustomerDetailInfoModel yy_modelWithDictionary:data];
			AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
			vc.Type=AssistFollowUpEdit;
			vc.infoModel=customerDodel;
			vc.vcSuper=self;
			vc.canEdit=NO;
			vc.objectID=model.C_ID;
			[self.navigationController pushViewController:vc animated:YES];
		}];
		
	}
    if ([model.TYPE_NAME isEqualToString:@"粉丝跟进"]) {
        FansFollowAddEditViewController*vc=[[FansFollowAddEditViewController alloc]init];
        vc.Type=FansFollowUpEdit;
        vc.objectID=model.C_ID;
        vc.canEdit=NO;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
	if ([model.C_TYPE_DD_ID isEqualToString:@"A41600_C_TYPE_0008"]) {
		if ([model.C_RWSTATUS_DD_NAME isEqualToString:@"未执行"]) {
			ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
			vc.title = @"任务执行";
			vc.C_ID = model.C_A01200_C_ID;
			[self.navigationController pushViewController:vc animated:YES];
			
		} else {
			ServiceTaskTrueDetailViewController *vc = [[ServiceTaskTrueDetailViewController alloc]init];
			vc.title = @"任务详情";
			vc.C_ID = model.C_A01200_C_ID;
			[self.navigationController pushViewController:vc animated:YES];
		}
	}
    
    
}


//客户详情
-(void)httpPostGetCustomerDetailInfoC_A41500:(NSString *)c_id andBlock:(void(^)(id data))completeBlack{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:@{@"C_ID":c_id} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			if (completeBlack) {
				completeBlack(data[@"data"]);
			}
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
		
		
	}];
	
	
	
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}


#pragma mark  --click
//-(void)changeSelectedCalendar:(DAYCalendarView*)calendarView{
//    NSDate *selectedDate = self.calendarView.selectedDate;
//    NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSString*dateStr=[formatter stringFromDate:selectedDate];
//    MyLog(@"%@",dateStr);
//    self.currentTimeStr=dateStr;
//    [self.tableView.mj_header beginRefreshing];
//    
//    
//}


-(void)clickRightItem{
    //列表
    WorkCalendartListViewController*vc=[[WorkCalendartListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)addCalendar{
    //添加 日历
    CreatRemindViewController*vc=[[CreatRemindViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  --datas
//2017-10-12
-(void)httpPostGetTodayInfo{
    if (!self.currentTimeStr) {
        return;
    }
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416/calendar", HTTP_IP] parameters:@{@"SEARCH_TIME":self.currentTimeStr,@"pageSize":@(self.pagen),@"pageNum":@(self.pages)} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (self.pages==1) {
                [self.mainDatasArray removeAllObjects];
            }
            
            for (NSDictionary*dict in data[@"data"]) {
                WorkCalendarModel*model=[WorkCalendarModel yy_modelWithDictionary:dict];
                [self.mainDatasArray addObject:model];
            }
            
            [self.tableView reloadData];
            
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
    }];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  --set
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendar.frame), KScreenWidth, KScreenHeight-NavigationHeight-60-self.calendar.frame.size.height - SafeAreaBottomHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
    }
    return _tableView;
}

-(NSMutableArray *)mainDatasArray{
    if (!_mainDatasArray) {
        _mainDatasArray=[NSMutableArray array];
    }
    return _mainDatasArray;
}


@end
