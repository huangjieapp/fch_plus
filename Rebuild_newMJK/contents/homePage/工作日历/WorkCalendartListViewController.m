//
//  WorkCalendartListViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "WorkCalendartListViewController.h"
#import "CFDropDownMenuView.h"
#import "WorkCalendarTableViewCell.h"
#import "CGCCustomDateView.h"
#import "ScaleView.h"

#import "CalendarListModel.h"
#import "WorkCalendarModel.h"
#import "MJKClueListViewModel.h"
#import "MJKClueListSubModel.h"

#import "MJKSingleDetailViewController.h"


#import "CustomerFollowAddEditViewController.h"
#import "CreatRemindViewController.h"
#import "MJKOrderFllowViewController.h"
#import "AssistFollowViewController.h"

#import "ServiceTaskPerformViewController.h"
#import "ServiceTaskTrueDetailViewController.h"
#import "FansFollowAddEditViewController.h"

#import "CGCAppiontDetailVC.h"


#define CELL0   @"WorkCalendarTableViewCell"
@interface WorkCalendartListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CFDropDownMenuView*menuView;
@property(nonatomic,strong)UILabel*allNumberLabel;   //总计label


@property(nonatomic,assign)NSInteger pagen;
@property(nonatomic,assign)NSInteger pages;
@property(nonatomic,strong)NSMutableArray*mainDatasArray;
@property(nonatomic,strong)NSMutableArray*chooseDatasArray;   //筛选的数据
@property(nonatomic,strong)NSMutableArray*chooseSelectedDatasArray;   //筛选选中的数据
@property(nonatomic,strong)NSMutableDictionary*chooseParamsDict;   //筛选的 所有参数字典
@end

@implementation WorkCalendartListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        if (@available(iOS 11.0, *)) {
            self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
	if (self.C_TYPE_DD_ID.length > 0) {
		self.title = @"跟进列表";
	} else {
		self.title=@"工作日历列表";
	}
	
    [self getchooseViewDatas];
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
    [self setUpRefresh];
    
    
    if (self.calendarType==workCalendartListTypeShakeit) {
        [self.menuView.dropDownMenuTableView.delegate tableView:self.menuView.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
       [self.chooseParamsDict setObject:@"A41600_C_TYPE_0005" forKey:@"C_TYPE_DD_ID"];
        
    }

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    
}


#pragma mark  --UI
-(void)setUpRefresh{
    self.pagen=10;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=1;
        [self httpPostGetListDatas];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages++;
        [self httpPostGetListDatas];
        
    }];
    
    
}


-(void)addChooseView{

    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    self.menuView=menuView;
    menuView.VCName = @"工作日历";
    menuView.dataSourceArr=self.chooseDatasArray;
    menuView.defaulTitleArray=@[@"类型",@"员工",@"本月"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=self.chooseSelectedDatasArray[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
        
        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]) {
            //类型
            selectKey=@"C_TYPE_DD_ID";
            [self.chooseParamsDict setObject:selectValue forKey:selectKey];
            
            
        }else if ([selectedSection isEqualToString:@"1"]){
            //销售
            selectKey=@"USER_ID";
            [self.chooseParamsDict setObject:selectValue forKey:selectKey];
            
        }else if ([selectedSection isEqualToString:@"2"]){
            //创建时间
            selectKey=@"CREATE_TIME_TYPE";
            
            if ([selectValue isEqualToString:@"999"]) {
                //跳警告框
                [self presentAlertVC];
                
            }else{
                //时间选择的
                [self.chooseParamsDict setObject:selectValue forKey:selectKey];
                [self.chooseParamsDict removeObjectForKey:@"START_TIME"];
                [self.chooseParamsDict removeObjectForKey:@"END_TIME"];
                
                
                
            }
            
            
            
        }
        
        
        //如果是 选择了 自定义 时间 那么不刷新
        if ([selectedSection isEqualToString:@"2"]&&[selectValue isEqualToString:@"999"]) {
            
        }else{
             [self.tableView.mj_header beginRefreshing];
        }
        
       
        
        
    };
    [self.view addSubview:menuView];
    
    
    //要写在 chooseView  加载完之后
    [self addTotailView];
    
    
    
    
//    self.menuView.dropDownMenuTableView.delegate select
    
   
    
}


-(void)presentAlertVC{
    //创建时间
     NSString*selectKey=@"CREATE_TIME_TYPE";
    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
        
    } withEnd:^{
        
    } withSure:^(NSString *start, NSString *end) {
        MyLog(@"11--%@   22--%@",start,end);
        
        [self.chooseParamsDict setObject:start forKey:@"START_TIME"];
        [self.chooseParamsDict setObject:end forKey:@"END_TIME"];
        [self.chooseParamsDict removeObjectForKey:selectKey];
      
         [self.tableView.mj_header beginRefreshing];
        
    }];
    
    dateView.clickCancelBlock = ^{
        [self.menuView.dropDownMenuTableView.delegate tableView:self.menuView.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

        
    };
    
    
    [[UIApplication sharedApplication].keyWindow addSubview:dateView];

    
}


-(void)addTotailView{
    UIImageView*BGImageV=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-100, NavStatusHeight + 40, 100, 20)];
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


#pragma mark  --tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.mainDatasArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    CalendarListModel*mainModel=self.mainDatasArray[section];
    return mainModel.array.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WorkCalendarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    CalendarListModel*mainModel=self.mainDatasArray[indexPath.section];
    WorkCalendarModel*model=mainModel.array[indexPath.row];
    cell.mainModel=model;
    
    return cell;

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CalendarListModel*mainModel=self.mainDatasArray[indexPath.section];
    WorkCalendarModel*model=mainModel.array[indexPath.row];
	if ([model.TYPE_NAME isEqualToString:@"预约"]) {
		CGCAppiontDetailVC *vc = [[CGCAppiontDetailVC alloc]init];
		vc.C_ID = model.C_ID;
        vc.rootVC = self;
		vc.isDiss = [model.C_PROCESS isEqualToString:@"未处理"] ? @"未到店" : @"已到店";
		[self.navigationController pushViewController:vc animated:YES];
	} else if ([model.TYPE_NAME isEqualToString:@"客户跟进"]) {
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
        
        
    }else if ([model.TYPE_NAME isEqualToString:@"签到"]){
//         [ScaleView ScaleSignWithModel:model];
        MJKSingleDetailViewController *vc = [[MJKSingleDetailViewController alloc]init];
        vc.C_ID = model.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
       
        
		
	} else if ([model.TYPE_NAME isEqualToString:@"订单跟进"]) {
		MJKOrderFllowViewController *vc = [[MJKOrderFllowViewController alloc]init];
		vc.detailModel = [[CGCOrderDetailModel alloc]init];
		vc.detailModel.C_A41500_C_ID = model.C_A41500_C_ID;
		vc.objectID = model.C_ID;
		vc.canEdit = NO;
		vc.isDetail = @"详情";
		[self.navigationController pushViewController:vc animated:YES];
	} else
	
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
		if ([model.C_RWTYPE_DD_NAME isEqualToString:@"未执行"]) {
			ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
			vc.title = @"任务执行";
			vc.C_ID = model.C_A01200_C_ID;
			[self.navigationController pushViewController:vc animated:YES];
			//			ServiceTaskDetailOrEditViewController*vc=[[ServiceTaskDetailOrEditViewController alloc]init];
			//			vc.C_ID=detailModel.C_ID;
			//			[self.navigationController pushViewController:vc animated:YES];
			
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



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    BGView.backgroundColor=KColorGrayBGView;
    
    CalendarListModel*mainModel=self.mainDatasArray[section];
    NSString*Strr=mainModel.total;
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth/2, 15)];
    titleLabel.textColor=KColorGrayTitle;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=Strr;
    [BGView addSubview:titleLabel];
    
    return BGView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}



#pragma mark  --click




#pragma mark  --datas
-(void)getchooseViewDatas{
    [self getSalesListDatasCompliation:^(MJKClueListViewModel *saleDatasModel) {
        MyLog(@"%@",saleDatasModel);
        
        //类型
        NSMutableArray*typeArray=[NSMutableArray arrayWithObjects:@"全部",@"备忘",@"签到",@"任务",@"预约",@"客户跟进",@"协助跟进",@"订单跟进",@"粉丝跟进", nil];
        NSMutableArray*typeSelectArr=[NSMutableArray arrayWithObjects:@"",@"A41600_C_TYPE_0004",@"A41600_C_TYPE_0005",@"A41600_C_TYPE_0008",@"A41600_C_TYPE_0000",@"A41600_C_TYPE_0001",@"A41600_C_TYPE_0007",@"A41600_C_TYPE_0006",@"A41600_C_TYPE_0009", nil];
        
        //销售
        NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
        NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
            for (MJKClueListSubModel *clueListSubModel in saleDatasModel.data) {
                [saleArr addObject:clueListSubModel.nickName];
                [saleSelectedArr addObject:clueListSubModel.u051Id];
            }

        
        //创建时间
        
        NSArray * array14=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
        NSArray * arraySel14=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
        NSMutableArray*TimeArr=[NSMutableArray arrayWithArray:array14];
        NSMutableArray*timeSelectedArr=[NSMutableArray arrayWithArray:arraySel14];
        
        
        self.chooseDatasArray=[NSMutableArray arrayWithObjects:typeArray,saleArr,TimeArr, nil];
        self.chooseSelectedDatasArray=[NSMutableArray arrayWithObjects:typeSelectArr,saleSelectedArr,timeSelectedArr, nil];
        
        
        [self addChooseView];
        
        
    }];

    
    
   
    
    
    
}


//得到销售列表
-(void)getSalesListDatasCompliation:(void(^)(MJKClueListViewModel*saleDatasModel))salesDatasBlock{
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            MJKClueListViewModel*saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data[@"data"]];
            salesDatasBlock(saleDatasModel);
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}


//获取数据
-(void)httpPostGetListDatas{
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionaryWithDictionary:@{@"pageNum":@(self.pages),@"pageSize":@(self.pagen)}];

    contentDict[@"CREATE_TIME_TYPE"] = @"3";
    [self.chooseParamsDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"CREATE_TIME_TYPE"]) {
            [contentDict setObject:obj forKey:key];
        }
        if (obj&&![obj isEqualToString:@""]) {
            [contentDict setObject:obj forKey:key];
        }
        
    }];
    NSString *str = [contentDict objectForKey:@"C_TYPE_DD_ID"];
    if (str.length > 0) {
        
    } else {
        contentDict[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    }
        
    
    if (self.CREATE_TIME_TYPE.length > 0) {
        contentDict[@"CREATE_TIME_TYPE"] = self.CREATE_TIME_TYPE;
    }
    
    if (self.saleCode.length > 0) {
        contentDict[@"USER_ID"] = self.saleCode;
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416/calendarToList", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            if (self.pages==1) {
                [self.mainDatasArray removeAllObjects];
            }

            
            //个数
            NSString*countNumber=data[@"data"][@"countNumber"];
            self.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",countNumber];
            
            for (NSDictionary*dict in data[@"data"][@"content"]) {
                CalendarListModel*model=[CalendarListModel yy_modelWithDictionary:dict];
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
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight) style:UITableViewStyleGrouped];
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

-(NSMutableDictionary *)chooseParamsDict{
    if (!_chooseParamsDict) {
        _chooseParamsDict=[NSMutableDictionary dictionary];
    }
    return _chooseParamsDict;
}


@end
