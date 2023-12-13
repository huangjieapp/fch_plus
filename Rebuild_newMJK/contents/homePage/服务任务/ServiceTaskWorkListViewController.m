//
//  ServiceTaskWorkListViewController.m
//  Rebuild_newMJK
//
//  Created by 黄佳峰 on 2017/10/26.
//  Copyright © 2017年 脉居客. All rights reserved.
//

#import "ServiceTaskWorkListViewController.h"
#import "CGCNavSearchTextView.h"
#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"
#import "ServiceTaskTableViewCell.h"
#import "CGCMoreCollection.h"
#import "CGCTemplateVC.h"
#import "DBAssignBottomChooseView.h"


#import "MJKClueListViewModel.h"
#import "ServiceTaskModel.h"

#import "MJKVoiceCViewController.h"
#import "ServiceTaskAddViewController.h"
#import "ServiceTaskDetailOrEditViewController.h"
#import "ServiceTaskTrueDetailViewController.h"//详情
#import "ServiceTaskPerformViewController.h"//执行
#import "CommonCallViewController.h"
#import "ServiceOrderCreatViewController.h"   //创建服务工单
#import "MJKMarketViewController.h"
#import "CGCAlertDateView.h"
#import "MJKUploadMemoView.h"
//定位
#import <AMapFoundationKit/AMapFoundationKit.h>

#import <AMapLocationKit/AMapLocationKit.h>
#import "VoiceView.h"

#import "MJKTaskWorkListController.h"

#import "MJKChooseEmployeesViewController.h"



#define CELL0   @"ServiceTaskTableViewCell"
@interface ServiceTaskWorkListViewController ()<UITableViewDelegate,UITableViewDataSource,AMapLocationManagerDelegate>
@property(nonatomic,strong)DBAssignBottomChooseView*bottomChooseView;
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
@property(nonatomic,strong)CFDropDownMenuView*menuView;   //菜单选择栏
@property(nonatomic,strong)UILabel*allNumberLabel;   //总计label


@property(nonatomic,strong)NSMutableArray*mainDatasArray;   //所有的数据

@property(nonatomic,strong)NSString*searchStr;   //搜索的文字
@property(nonatomic,strong)NSMutableDictionary*saveSelTableDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelTimeDict;
@property(nonatomic,assign)NSInteger currPage;
@property(nonatomic,assign)NSInteger pageSize;




@property(nonatomic,strong)NSMutableArray*TableChooseDatas;    //筛选的数据
@property(nonatomic,strong)NSMutableArray*TableSelectedChooseDatas;   //筛选选中的数据


//百度地图获取经纬度
@property(nonatomic,strong)NSString*B_SIGN_LON;
@property(nonatomic,strong)NSString*B_SIGN_LAT;  //维度

@property(nonatomic,strong)NSString*D_ORDER_TIME;  //延期时间

//完成时间

@property(nonatomic,assign)BOOL isNewAssign;    //是否是重新指派
@property(nonatomic,strong)NSMutableArray*saveAllSelectedAssignModelArray; //所有选中的分配的model
/*
 self.FINISH_START_TIME=start;
 self.FINISH_END_TIME=end;
 self.FINISH_TIME_TYPE=@"";
 */
@property (nonatomic, strong) NSString *FINISH_START_TIME;
@property (nonatomic, strong) NSString *FINISH_END_TIME;
@property (nonatomic, strong) NSString *FINISH_TIME_TYPE;
@property (nonatomic, strong) CGCAlertDateView *alertDateView;

@property(nonatomic, strong) NSString *performStr;
@property(nonatomic, strong) NSString *imageStr;

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString  *locationAddress;
/** 漏斗筛选*/
@property (nonatomic, strong) NSMutableDictionary *funnelDic;

@end

@implementation ServiceTaskWorkListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initLocation];
     [self createNav];
    [self getChooseDatas];
     [self.view addSubview:self.tableView];
    [self setupRefresh];
     [self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
	
}


-(void)viewWillAppear:(BOOL)animated{
     [super viewWillAppear:animated];
         [self.tableView.mj_header beginRefreshing];
    
    
}

#pragma mark  --UI
- (void)initLocation {
	self.locationManager = [[AMapLocationManager alloc] init];
	self.locationManager.delegate = self;
	self.locationManager.distanceFilter = 200;
	[self.locationManager setLocatingWithReGeocode:YES];
	[self.locationManager startUpdatingLocation];
}

#pragma mark - 定位
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
	NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
	if (reGeocode)
	{
		NSLog(@"reGeocode:%@", reGeocode);
		self.locationAddress = reGeocode.formattedAddress;
	}
}

- (void)createNav{
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
    self.view.backgroundColor=CGCTABBGColor;
    DBSelf(weakSelf);
    self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入客户姓名/地址" withRecord:^{//点击录音
//        MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//        [voiceVC setBackStrBlock:^(NSString *str){
//            if (str.length>0) {
//                _CurrentTitleView.textField.text = str;
//                self.searchStr=str;
//                [self.tableView.mj_header beginRefreshing];
//            }
//        }];
//        [weakSelf presentViewController:voiceVC animated:YES completion:nil];
		VoiceView *vv = [[VoiceView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:vv];
		[vv start];
		vv.recordBlock = ^(NSString *str) {
			_CurrentTitleView.textField.text = str;
			self.searchStr=str;
			[self.tableView.mj_header beginRefreshing];

		};
		
    } withText:^{//开始编辑
        MyLog(@"编辑");
        
        
    }withEndText:^(NSString *str) {//结束编辑
        NSLog(@"%@____",str);
        if (str.length>0) {
            self.searchStr=str;
            [self.tableView.mj_header beginRefreshing];
        }else{
            self.searchStr=@"";
            [self.tableView.mj_header beginRefreshing];
        }
        
    }];
    self.navigationItem.titleView=self.CurrentTitleView;
    
    
    
    
//    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem itemWithImage:@"icon_service_task_add" highImage:@"" isLeft:NO target:self andAction:@selector(addNewServiceTask)], [UIBarButtonItem itemWithImage:@"任务排班图标" highImage:@"" isLeft:NO target:self andAction:@selector(serviceTaskList)]];
	
	
    
}



-(void)addChooseViewWithAaleModel:(MJKClueListViewModel *)saleDatasModel{
    DBSelf(weakSelf);
    CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
    menuView.dataSourceArr=self.TableChooseDatas;
    self.menuView=menuView;
    menuView.defaulTitleArray=@[@"类型",@"状态",@"负责人",@"优先级"];
    menuView.startY=CGRectGetMaxY(menuView.frame);
    menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
        MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
        NSMutableArray*subArray=weakSelf.TableSelectedChooseDatas[[selectedSection integerValue]];
        NSString*selectValue=subArray[[selectedRow integerValue]];
		
        NSString*selectKey;
        if ([selectedSection isEqualToString:@"0"]) {
            //类型
            selectKey=@"C_TYPE_DD_ID";
            
        }else if ([selectedSection isEqualToString:@"1"]){
            //状态
            selectKey=@"STATUS_TYPE";
        }else if ([selectedSection isEqualToString:@"2"]){
            //服务人员
            selectKey=@"USER_ID";
        }else if ([selectedSection isEqualToString:@"3"]){
            //任务日期
            selectKey=@"C_TASKSTATUS_DD_ID";
//            [self.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
//            [self.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
			

        }
        
        
//        if (selectKey) {
            [weakSelf.saveSelTableDict setObject:selectValue forKey:selectKey];
//            if ([selectValue isEqualToString:@"999"])  {
//
//            }else{
		
            [weakSelf.tableView.mj_header beginRefreshing];
//		}
//        }
	
        
        //如果点击的是   自定义
//        if ([selectValue isEqualToString:@"999"]) {
//            CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
//
//            } withEnd:^{
//
//
//            } withSure:^(NSString *start, NSString *end) {
//                MyLog(@"11--%@   22--%@",start,end);
//
//                [self.saveSelTimeDict setObject:start forKey:@"CREATE_START_TIME"];
//                [self.saveSelTimeDict setObject:end forKey:@"CREATE_END_TIME"];
//                [self.saveSelTableDict removeObjectForKey:@"CREATE_TIME_TYPE"];
//
//                 [self.tableView.mj_header beginRefreshing];
//
//            }];
//
//
//            dateView.clickCancelBlock = ^{
//               //选中第一个
//                 [self.menuView.dropDownMenuTableView.delegate tableView:self.menuView.dropDownMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
//
//                [self.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
//                [self.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
//                [self.saveSelTableDict setObject:@"" forKey:@"CREATE_TIME_TYPE"];
//
//                 [self.tableView.mj_header beginRefreshing];
//            };
//
//
//
//            [[UIApplication sharedApplication].keyWindow addSubview:dateView];
//
//
//
//
//
//        }
	
        
        
    };
    [self.view addSubview:menuView];
    
    
    
    
    
    
	//这个是筛选的view
	FunnelShowView*funnelView=[FunnelShowView funnelShowView];
	
	//创建时间
    NSArray * createtitleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * createidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
	NSMutableArray * createArr=[NSMutableArray array];
	for (int i=0;i<createtitleArr.count;i++) {
		
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=createtitleArr[i];
		model.c_id=createidArr[i];
		[createArr addObject:model];
		
	}
	//希望完成时间
    NSArray * hopeFinishtitleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * hopeFinishidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
	NSMutableArray * hopeFinishArr=[NSMutableArray array];
	for (int i=0;i<hopeFinishtitleArr.count;i++) {
		
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=hopeFinishtitleArr[i];
		model.c_id=hopeFinishidArr[i];
		[hopeFinishArr addObject:model];
		
	}
	//期望开始时间
    NSArray * expectBegintitleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * expectBeginidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
	NSMutableArray * expectBeginArr=[NSMutableArray array];
	for (int i=0;i<expectBegintitleArr.count;i++) {
		
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=expectBegintitleArr[i];
		model.c_id=expectBeginidArr[i];
		[expectBeginArr addObject:model];
		
	}
	//预计完成时间
    NSArray * expectFinishtitleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * expectFinishidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
	NSMutableArray * expectFinishArr=[NSMutableArray array];
	for (int i=0;i<expectFinishtitleArr.count;i++) {
		
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=expectFinishtitleArr[i];
		model.c_id=expectFinishidArr[i];
		[expectFinishArr addObject:model];
		
	}
	//完成时间
    NSArray * finishtitleArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * finishidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
	NSMutableArray * finishArr=[NSMutableArray array];
	for (int i=0;i<finishtitleArr.count;i++) {
		
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=finishtitleArr[i];
		model.c_id=finishidArr[i];
		[finishArr addObject:model];
		
	}
	
	
	//创建人
	NSMutableArray*saleArr=[NSMutableArray array];
	MJKFunnelChooseModel*allSaleModel=[[MJKFunnelChooseModel alloc]init];
	allSaleModel.name=@"全部";
	allSaleModel.c_id=@"";
	[saleArr addObject:allSaleModel];
	for (MJKClueListSubModel *clueListSubModel in saleDatasModel.data) {
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=clueListSubModel.nickName;
		model.c_id=clueListSubModel.u051Id;
		[saleArr addObject:model];
	}
	
	//是否超时
	NSArray *isFinish = [NSArray arrayWithObjects:@"全部",@"未超时",@"已超时", nil];
	NSArray *isFinishCode = [NSArray arrayWithObjects:@"",@"0",@"1", nil];
	NSMutableArray *isFinishArr = [NSMutableArray array];
	for (int i=0;i<isFinish.count;i++) {
		MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
		model.name=isFinish[i];
		model.c_id=isFinishCode[i];
		[isFinishArr addObject:model];
	}
	
	NSDictionary*dic=@{@"title":@"创建人",@"content":saleArr};
	NSDictionary*dic1=@{@"title":@"创建时间",@"content":createArr};
	NSDictionary*dic2=@{@"title":@"期望完成时间",@"content":hopeFinishArr};
	NSDictionary*dic3=@{@"title":@"预计开始时间",@"content":expectBeginArr};
	NSDictionary*dic4=@{@"title":@"预计完成时间",@"content":expectFinishArr};
	NSDictionary*dic5=@{@"title":@"完成时间",@"content":finishArr};
	NSDictionary*dic6=@{@"title":@"是否超时",@"content":isFinishArr};
	funnelView.allDatas =  (NSMutableArray *)@[dic,dic1,dic2,dic3,dic4,dic5,dic6];
	
	//回调
	funnelView.sureBlock = ^(NSMutableArray *array) {
		NSString *selectCode;
		for (NSDictionary *dic in array) {
			NSInteger index = [dic[@"index"] integerValue];
			MJKFunnelChooseModel * model=dic[@"model"];
			if (index == 0) {
				selectCode = @"CREATEUSERID";
			} else if (index == 1) {
				selectCode = @"CREATE_TIME_TYPE";
			} else if (index == 2) {
				selectCode = @"ORDER_TIME_TYPE";
			} else if (index == 3) {
				selectCode = @"START_TIME_TYPE";
			} else if (index == 4) {
				selectCode = @"END_TIME_TYPE";
			} else if (index == 5) {
				selectCode = @"FINISH_TIME_TYPE";
			} else if (index == 6) {
				selectCode = @"·";
			}
			if ([model.c_id isEqualToString:@"999"]) {
				
			} else {
				[weakSelf.saveSelTableDict setObject:model.c_id forKey:selectCode];
			}
			
		}
//		NSString * name = [[array firstObject][@"model"] name];
//		NSString * c_id = [[array firstObject][@"model"] c_id];
//		if ([name isEqualToString:@"自定义"]) {
//
//		}else{
//			self.currPage=1;
//			self.FINISH_START_TIME=@"";
//			self.FINISH_END_TIME=@"";
//			self.FINISH_TIME_TYPE=c_id;
//		}
		[weakSelf HttpPostgetListDatas];
		
	};
	[[UIApplication sharedApplication].keyWindow addSubview:funnelView];
 
    
    
    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        //tablieView
        [menuView hide];
		//显示漏斗内容
		[funnelView show];
    };
	
	
	
	funnelView.viewCustomTimeBlock = ^(NSInteger selectedSession){
		MyLog(@"自定义时间");
		CGCCustomDateView * dateView;
		if (selectedSession == 1) {
			dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				self.currPage=1;
				[self.saveSelTimeDict setObject:start forKey:@"CREATE_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"CREATE_END_TIME"];
				[self.saveSelTableDict removeObjectForKey:@"CREATE_TIME_TYPE"];
				
				
			}];
			
			dateView.clickCancelBlock = ^{
				self.currPage=1;
				[self.saveSelTimeDict removeObjectForKey:@"CREATE_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"CREATE_END_TIME"];
				[self.saveSelTableDict setObject:@"" forKey:@"CREATE_TIME_TYPE"];
			};
		} else if (selectedSession == 2) {
			dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				self.currPage=1;
				[self.saveSelTimeDict setObject:start forKey:@"ORDER_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"ORDER_END_TIME"];
				[self.saveSelTableDict removeObjectForKey:@"ORDER_TIME_TYPE"];
				//            [self HTTPGetOrderList];
				
			}];
			
			dateView.clickCancelBlock = ^{
				self.currPage=1;
				[self.saveSelTimeDict removeObjectForKey:@"ORDER_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"ORDER_END_TIME"];
				[self.saveSelTableDict setObject:@"" forKey:@"ORDER_TIME_TYPE"];
			};
		} else if (selectedSession == 3) {
			dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				self.currPage = 1;
				[self.saveSelTimeDict setObject:start forKey:@"START_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"START_END_TIME"];
				[self.saveSelTableDict removeObjectForKey:@"START_TIME_TYPE"];
				//            [self HTTPGetOrderList];
				
			}];
			
			dateView.clickCancelBlock = ^{
				self.currPage=1;
				[self.saveSelTimeDict removeObjectForKey:@"START_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"START_END_TIME"];
				[self.saveSelTableDict setObject:@"" forKey:@"START_TIME_TYPE"];
			};
		} else if (selectedSession == 4) {
			dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				self.currPage=1;
				[self.saveSelTimeDict setObject:start forKey:@"END_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"END_END_TIME"];
				[self.saveSelTableDict removeObjectForKey:@"END_TIME_TYPE"];
				//            [self HTTPGetOrderList];
				
			}];
			
			dateView.clickCancelBlock = ^{
				self.currPage=1;
				[self.saveSelTimeDict removeObjectForKey:@"END_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"END_END_TIME"];
				[self.saveSelTableDict setObject:@"" forKey:@"END_TIME_TYPE"];
			};
		} else if (selectedSession == 5) {
			dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				self.currPage=1;
				[self.saveSelTimeDict setObject:start forKey:@"FINISH_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"FINISH_END_TIME"];
				[self.saveSelTableDict removeObjectForKey:@"FINISH_TIME_TYPE"];
				//            [self HTTPGetOrderList];
				
			}];
			dateView.clickCancelBlock = ^{
				self.currPage=1;
				[self.saveSelTimeDict removeObjectForKey:@"FINISH_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"FINISH_END_TIME"];
				[self.saveSelTableDict setObject:@"" forKey:@"FINISH_TIME_TYPE"];
			};
		}
		
		
		[[UIApplication sharedApplication].keyWindow addSubview:dateView];
		
	};
    
    
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


-(void)setupRefresh{
    DBSelf(weakSelf);
    self.pageSize=20;
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currPage=1;
        [weakSelf HttpPostgetListDatas];
        
    }];
    
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.currPage++;
        [weakSelf HttpPostgetListDatas];
        
    }];
    

    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.mainDatasArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ServiceTaskModel*model=self.mainDatasArray[section];
    return model.content.count;
    
   
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceTaskTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
    ServiceTaskModel*model=self.mainDatasArray[indexPath.section];
    ServiceTaskSubModel*detailModel=model.content[indexPath.row];
    cell.tabType = @"1";
    cell.pubMainDatasModel=detailModel;
     cell.isNewAssign=self.isNewAssign;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceTaskModel*model=self.mainDatasArray[indexPath.section];
    ServiceTaskSubModel*detailModel=model.content[indexPath.row];
	
    if (self.isNewAssign) {
        //重新分配
        detailModel.isSelected=!detailModel.isSelected;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }else{
		if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"] || [detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
			ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
			vc.title = @"任务执行";
			vc.C_ID = detailModel.C_ID;
			[self.navigationController pushViewController:vc animated:YES];

		} else {
			ServiceTaskTrueDetailViewController *vc = [[ServiceTaskTrueDetailViewController alloc]init];
			vc.title = @"任务详情";
			vc.C_ID = detailModel.C_ID;
			[self.navigationController pushViewController:vc animated:YES];
		}
		

    }
    
    
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    ServiceTaskModel*model=self.mainDatasArray[section];

    
    UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
    BGView.backgroundColor=KColorGrayBGView;
    
//    PotentailCustomerListModel*model=self.allListDatas[section];
    NSString*Strr=model.total;
    
    UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth/2, 15)];
    titleLabel.textColor=KColorGrayTitle;
    titleLabel.font=[UIFont systemFontOfSize:14];
    titleLabel.text=Strr;
    [BGView addSubview:titleLabel];
    
    return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
	ServiceTaskModel*model=self.mainDatasArray[indexPath.section];
	ServiceTaskSubModel*detailModel=model.content[indexPath.row];
	if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0005"] || [detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {
		return NO;
	}
    return YES;
}
- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    ServiceTaskModel*model=self.mainDatasArray[indexPath.section];
    ServiceTaskSubModel*detailModel=model.content[indexPath.row];
    DBSelf(weakSelf);
//    //0
//    UITableViewRowAction*phoneAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"拨打电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        MyLog(@"1");
//
//        NSInteger index=indexPath.section*100+indexPath.row;
//        [self selectTelephone:index];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }];
//    phoneAction.backgroundColor=DBColor(255,195,0);
//
//
//
    //1
    UITableViewRowAction*ShortMailAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"短信" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"2");
        [self showShortMail:detailModel];


    }];
    ShortMailAction.backgroundColor=DBColor(153,153,153);
//
//
//
//    //确认
//    UITableViewRowAction*SureAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"确认" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        MyLog(@"2");
////       1: 确认 2: 退回 3: 签到 4：完成 5：延期 6：重新指派7：取消
//        [self HttpPostChangeServiceTaskStatus:@"1" andTaskID:detailModel.C_ID andSuccess:^(id data) {
//            [JRToast showWithText:data[@"message"]];
//            [self.tableView.mj_header beginRefreshing];
//
//        }];
//
//
//
//    }];
//    SureAction.backgroundColor=DBColor(153,153,153);
//
//
//    //签到
//    UITableViewRowAction*SignInAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"签到" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        MyLog(@"2");
//        [self getBaiduMapInfoComplete:^{
//            [self HttpPostChangeServiceTaskStatus:@"3" andTaskID:detailModel.C_ID andSuccess:^(id data) {
//                [JRToast showWithText:data[@"message"]];
//                [self.tableView.mj_header beginRefreshing];
//
//            }];
//
//
//        }];
//
//
//    }];
//    SignInAction.backgroundColor=DBColor(153,153,153);
//
//
//
//
//
//
    //3
    UITableViewRowAction*moreAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多操作" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        MyLog(@"3");
        [self MoreChooseWithModel:detailModel];


    }];
    moreAction.backgroundColor=DBColor(50,151,234);
	
	UITableViewRowAction*editAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		if (![[NewUserSession instance].appcode containsObject:@"APP007_0003"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		ServiceTaskAddViewController *taskVC = [[ServiceTaskAddViewController alloc] init];
		taskVC.title = @"任务编辑";
		taskVC.C_ID =detailModel.C_ID;
		[weakSelf.navigationController pushViewController:taskVC animated:YES];
		
		
	}];
	editAction.backgroundColor=DBColor(255,195,0);
	
	UITableViewRowAction*delayAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"延期" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		if (![[NewUserSession instance].appcode containsObject:@"APP007_0004"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		[weakSelf methodForTitle:@"延期" andServiceTaskSubModel:detailModel];
		
		
	}];
	delayAction.backgroundColor=DBColor(153,153,153);
	
	UITableViewRowAction*gdAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"工单" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf methodForTitle:@"工单" andServiceTaskSubModel:detailModel];
		
		
	}];
	gdAction.backgroundColor=DBColor(255,195,0);
	
	UITableViewRowAction*finishAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"完成" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		[weakSelf methodForTitle:@"完成" andServiceTaskSubModel:detailModel];
		
		
	}];
	finishAction.backgroundColor=DBColor(153,153,153);
	
	if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"]) {
		return @[moreAction,finishAction,editAction];
	}//未确认
	
	if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0004"]) {//完成
		return @[moreAction,ShortMailAction/*,gdAction*/];
	}
	
//	if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0001"]) {//已确认
//		return @[];
//	}
    //A01200_C_STATUS_0005 取消
	
    
//    if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"完成"]) {
//        /*
//         *拨打电话  短信 更多操作  （工单 短信 微信 公众号）
//         */
//
//        return @[moreAction,ShortMailAction,phoneAction];
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"未确认"]){
//        /*
//         *拨打电话  确认 更多操作    （重新指派  延期  取消  短信  微信  公众号）
//         */
//        return @[moreAction,SureAction,phoneAction];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"确认"]){
//        /*
//         *拨打电话  签到 更多操作    （工单 完成  重新指派  延期  取消  短信  微信  公众号）
//         */
//        return @[moreAction,SignInAction,phoneAction];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"退回"]){
//        /*
//         *拨打电话  短信 更多操作    （微信  公众号）
//         */
//        return @[moreAction,ShortMailAction,phoneAction];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"执行中"]){
//        /*
//         *拨打电话  签到  更多操作    （（工单 完成  重新指派  延期  取消  短信  微信  公众号）
//         */
//        return @[moreAction,SignInAction,phoneAction];
//
//    }

    
    
    return nil;
    
    
    
    
    
    
}



#pragma mark  --click
-(void)addNewServiceTask{
	if (![[NewUserSession instance].appcode containsObject:@"APP007_0002"]) {
		[JRToast showWithText:@"账号无权限"];
		return;
	}
    ServiceTaskAddViewController*vc=[[ServiceTaskAddViewController alloc]init];
	vc.title = @"新增任务";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)serviceTaskList {
	MJKTaskWorkListController *vc = [[MJKTaskWorkListController alloc]initWithNibName:@"MJKTaskWorkListController" bundle:nil];
	[self.navigationController pushViewController:vc animated:YES];
}


#pragma mark  --创建工单
-(void)creatWorkOrderWithModel:(ServiceTaskSubModel*)subModel{
    ServiceOrderCreatViewController*vc=[[ServiceOrderCreatViewController alloc]init];
    vc.serviceTaskDatas=subModel;
    [self.navigationController pushViewController:vc animated:YES];
    
}


//短信
-(void)showShortMail:(ServiceTaskSubModel*)detailModel{
    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
    vc.templateType=CGCTemplateMessage;
    vc.titStr=detailModel.C_A41500_C_NAME;
    vc.customPhoneArr=[@[detailModel.C_CONTACTPHONE] mutableCopy];
    vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
    vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
    vc.cusDetailModel.C_NAME=detailModel.C_A41500_C_NAME;
	vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
	vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
	vc.cusDetailModel.C_STAGE_DD_NAME = detailModel.C_STAGE_DD_NAME;
	vc.cusDetailModel.C_STAGE_DD_ID = detailModel.C_STAGE_DD_ID;
	vc.cusDetailModel.D_LASTFOLLOW_TIME = detailModel.D_LASTFOLLOW_TIME;
    [self.navigationController pushViewController:vc animated:YES];
//	[self presentViewController:vc animated:YES completion:nil];

    
    
}

//wechat
-(void)showWechat:(ServiceTaskSubModel*)detailModel{
    CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
    vc.templateType=CGCTemplateWeiXin;
    vc.titStr=detailModel.C_A41500_C_NAME;
    vc.customIDArr=[@[detailModel.C_A41500_C_ID] mutableCopy];
    vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
    vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
    vc.cusDetailModel.C_NAME=detailModel.C_A41500_C_NAME;
	vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
	vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
	vc.cusDetailModel.C_STAGE_DD_NAME = detailModel.C_STAGE_DD_NAME;
	vc.cusDetailModel.C_STAGE_DD_ID = detailModel.C_STAGE_DD_ID;
	vc.cusDetailModel.D_LASTFOLLOW_TIME = detailModel.D_LASTFOLLOW_TIME;
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}

//公众号
-(void)showPublicNumber:(ServiceTaskSubModel*)detailModel{
    [JRToast showWithText:@"敬请期待"];
}

//重新指派
-(void)REAssignment:(ServiceTaskSubModel*)detailModel{
    DBSelf(weakSelf);
    _isNewAssign=YES;
    //当前的选择的  设置为选中  再刷新
    detailModel.isSelected=YES;
    [weakSelf.tableView reloadData];
    
    //底部放个view
    self.bottomChooseView=[DBAssignBottomChooseView AssignBottomChooseViewAndcancel:^{
        //所有数据  选中状态都设为no   刷新
        for (ServiceTaskModel*model in weakSelf.mainDatasArray) {
            for (ServiceTaskSubModel*detailModel in model.content) {
                detailModel.isSelected=NO;
            }
            
        }
        weakSelf.isNewAssign=NO;
        [weakSelf.tableView reloadData];
        [weakSelf.bottomChooseView removeFromSuperview];
        
    } allChoose:^{
        //所有数据 选中状态 都设为yes   刷新
        for (ServiceTaskModel*model in weakSelf.mainDatasArray) {
            for (ServiceTaskSubModel*detailModel in model.content) {
                detailModel.isSelected=YES;
            }
            
        }
        
        [weakSelf.tableView reloadData];
        
        
        
    } sure:^{
        //获取到所有的选中   然后 跳转
        NSMutableArray*saveAllChooseArray=[NSMutableArray array];
        self.saveAllSelectedAssignModelArray=saveAllChooseArray;
        for (ServiceTaskModel*model in weakSelf.mainDatasArray) {
            for (ServiceTaskSubModel*detailModel in model.content) {
                if (detailModel.isSelected) {
                    [saveAllChooseArray addObject:detailModel];
                }
                
            }
            
        }
        
        MyLog(@"saveAllChooseArray===%@",saveAllChooseArray);
        if (saveAllChooseArray.count<1) {
            [JRToast showWithText:@"至少选择一条重新分配"];
            return;
        }
        
        
        NSMutableArray*strArray=[NSMutableArray array];
        for (ServiceTaskSubModel*detailModel in saveAllChooseArray) {
            [strArray addObject:detailModel.C_ID];
        }
        NSString*customerIDS=[strArray componentsJoinedByString:@","];
        
        //跳转  到下一个界面  选择好  销售之后  回调  来用  saveAllChooseArray 的东西和销售吊接口  完成之后 在移除这个view
        MJKChooseEmployeesViewController *vc = [[MJKChooseEmployeesViewController alloc]init];
        if ([[NewUserSession instance].appcode containsObject:@"APP007_0010"]) {
            vc.isAllEmployees = @"是";
        }
        vc.noticeStr = @"无提示";
        vc.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
            [weakSelf.bottomChooseView removeFromSuperview];
            weakSelf.bottomChooseView=nil;
            weakSelf.isNewAssign=NO;
            
            [HttpWebObject AssignServiceTaskToSaleWithSalerID:model.user_id andServiceIDS:customerIDS success:^(id data) {
                MyLog(@"%@",data);
                if ([data[@"code"] integerValue]==200) {
                    
                    
                }else{
                    [JRToast showWithText:data[@"message"]];
                }

                
                //这里需要调用接口    重新分配的接口
                [self.tableView.mj_header beginRefreshing];

            }];
            
            
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
        
    }];
    self.bottomChooseView.frame=CGRectMake(0, KScreenHeight-40, KScreenWidth, 40);
    [self.view addSubview:self.bottomChooseView];
    
    
}


//更多的操作
-(void)MoreChooseWithModel:(ServiceTaskSubModel*)detailModel{
	DBSelf(weakSelf);
	//工单、完成、取消、重新指派、短信、微信
	if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0003"]){
		NSArray*titleArray=@[/*@"工单",@"完成"*/@"延期",@"取消",@"短信",@"微信",@"重新指派"];
		NSArray*imageArray=@[/*@"icon-工单",@"icon-完成"*/@"icon-延期",@"icon-取消",@"icon-短信",@"icon-微信",@"icon-重新指派"];
		CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
			MyLog(@"index==%lu,title==%@",index,title);
			
			[weakSelf methodForTitle:title andServiceTaskSubModel:detailModel];
			
			
		}];
		[[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
		
		
	}
	
	if ([detailModel.C_STATUS_DD_ID isEqualToString:@"A01200_C_STATUS_0004"]) {
		//（工单 短信 微信 公众号）
		NSArray*titleArray=@[@"微信"];
		NSArray*imageArray=@[@"icon-微信"];
		CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
			MyLog(@"index==%lu,title==%@",index,title);
			[weakSelf methodForTitle:title andServiceTaskSubModel:detailModel];
			
			
		}];
		[[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
		
		
	}
	
	
//    if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"完成"]) {
//    //（工单 短信 微信 公众号）
//         NSArray*titleArray=@[@"工单",@"短信",@"微信",@"公众号"];
//         NSArray*imageArray=@[@"icon-工单",@"icon-短信",@"icon-微信",@"icon-公众号"];
//        CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
//            MyLog(@"index==%lu,title==%@",index,title);
//			[self methodForTitle:title andServiceTaskSubModel:detailModel];
//
//
//        }];
//         [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"未确认"]){
//        //（重新指派  延期  取消  短信  微信  公众号）
//        NSArray*titleArray=@[@"重新指派",@"延期",@"取消",@"短信",@"微信",@"公众号"];
//        NSArray*imageArray=@[@"icon-重新指派",@"icon-延期",@"icon-取消",@"icon-短信",@"icon-微信",@"icon-公众号"];
//        CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
//            MyLog(@"index==%lu,title==%@",index,title);
//
//            [self methodForTitle:title andServiceTaskSubModel:detailModel];
//
//        }];
//        [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"确认"]){
//        //（工单 完成  重新指派  延期  取消  短信  微信  公众号）
//        NSArray*titleArray=@[@"工单",@"完成",@"重新指派",@"延期",@"取消",@"短信",@"微信",@"公众号"];
//        NSArray*imageArray=@[@"icon-工单",@"icon-完成",@"icon-重新指派",@"icon-延期",@"icon-取消",@"icon-短信",@"icon-微信",@"icon-公众号"];
//        CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
//            MyLog(@"index==%lu,title==%@",index,title);
//
//            [self methodForTitle:title andServiceTaskSubModel:detailModel];
//
//
//        }];
//        [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"退回"]){
//        //（微信  公众号）
//        NSArray*titleArray=@[@"微信",@"公众号"];
//        NSArray*imageArray=@[@"icon-微信",@"icon-公众号"];
//        CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
//            MyLog(@"index==%lu,title==%@",index,title);
//            [self methodForTitle:title andServiceTaskSubModel:detailModel];
//
//
//        }];
//        [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
//
//
//    }else if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"执行中"]){
//        //（（工单 完成  重新指派  延期  取消  短信  微信  公众号）
//        NSArray*titleArray=@[@"工单",@"完成",@"重新指派",@"延期",@"取消",@"短信",@"微信",@"公众号"];
//        NSArray*imageArray=@[@"icon-工单",@"icon-完成",@"icon-重新指派",@"icon-延期",@"icon-取消",@"icon-短信",@"icon-微信",@"icon-公众号"];
//        CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
//            MyLog(@"index==%lu,title==%@",index,title);
//            [self methodForTitle:title andServiceTaskSubModel:detailModel];
//
//
//        }];
//        [[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
//
//    }
//
//
	
}


-(void)methodForTitle:(NSString*)title andServiceTaskSubModel:(ServiceTaskSubModel*)detailModel{
	DBSelf(weakSelf);
    if ([title isEqualToString:@"工单"]) {
		if (![[NewUserSession instance].appcode containsObject:@"APP007_0005"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
        [self creatWorkOrderWithModel:detailModel];
        
    }else if ([title isEqualToString:@"完成"]){
		if (![[NewUserSession instance].appcode containsObject:@"APP007_0006"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
        if ([CLLocationManager locationServicesEnabled] && [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
            
        } else {
            [JRToast showWithText:@"请开启定位服务\n设置->隐私->定位服务"];
            return;
        }
        
		MJKUploadMemoView *memoView = [[MJKUploadMemoView alloc]initWithFrame:weakSelf.view.frame andTitle:@"执行内容描述" andSendMassage:YES andRootVC:self];
//		memoView.rootVC = self;
		__weak id weakMemoView = memoView;
		memoView.commitButtonBloack = ^(NSArray *imageArr, NSString *remarkText) {
			weakSelf.imageStr = [imageArr componentsJoinedByString:@","];
			weakSelf.performStr = remarkText;
			[weakSelf HttpPostChangeServiceTaskStatus:@"4" andTaskID:detailModel.C_ID andImageArray:imageArr andSuccess:^(id data) {
				[weakSelf.locationManager stopUpdatingLocation];//停止定位
				
				[JRToast showWithText:data[@"message"]];
				[weakMemoView removeFromSuperview];
				[weakSelf.tableView.mj_header beginRefreshing];
			}];
		};
		[self.view addSubview:memoView];
//        [self HttpPostChangeServiceTaskStatus:@"4" andTaskID:detailModel.C_ID andSuccess:^(id data) {
//            [JRToast showWithText:data[@"message"]];
//            [weakSelf.tableView.mj_header beginRefreshing];
//
//        }];
		
        
    }else if ([title isEqualToString:@"重新指派"]){
		if (![[NewUserSession instance].appcode containsObject:@"APP007_0008"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
        [self REAssignment:detailModel];
        
        
        
        
    }else if ([title isEqualToString:@"延期"]){
		self.alertDateView=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
			
		} withSureClick:^(NSString *title, NSString *dateStr) {
			if (dateStr.length>0) {
				
				weakSelf.D_ORDER_TIME=dateStr;
				[weakSelf HttpPostChangeServiceTaskStatus:@"5" andTaskID:detailModel.C_ID andImageArray:nil andSuccess:^(id data) {
					[JRToast showWithText:data[@"message"]];
					[weakSelf.tableView.mj_header beginRefreshing];
					
				}];
				
			}
			
			
		} withHight:150.0 withText:@"延期信息" withDatas:nil];
//		self.alertDateView.cancelActionBlock = ^{
//
//		};
		
		[self.view addSubview:self.alertDateView];
        //选择一个时间
//        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
//
//        } withEnd:^{
//
//        } withSure:^(NSString *start, NSString *end) {
//            MyLog(@"%@,%@",start,end);
//            self.D_ORDER_TIME=start;
//            [self HttpPostChangeServiceTaskStatus:@"5" andTaskID:detailModel.C_ID andSuccess:^(id data) {
//                [JRToast showWithText:data[@"message"]];
//                [self.tableView.mj_header beginRefreshing];
//
//            }];
//
//        }];
//        dateView.canFirstOneSave=YES;
//
//        dateView.startTimeTitleLabel.text=@"延期时间";
//        dateView.endTimeTitleLabel.hidden=YES;
//        dateView.endTimeBtn.hidden=YES;
//
//        [[UIApplication sharedApplication].keyWindow addSubview:dateView];
		
        
        
        
    }else if ([title isEqualToString:@"取消"]){
		if (![[NewUserSession instance].appcode containsObject:@"APP007_0007"]) {
			[JRToast showWithText:@"账号无权限"];
			return;
		}
		UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"是否确认取消" message:nil preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[weakSelf HttpPostChangeServiceTaskStatus:@"7" andTaskID:detailModel.C_ID andImageArray:nil andSuccess:^(id data) {
				[JRToast showWithText:data[@"message"]];
				[weakSelf.tableView.mj_header beginRefreshing];
				
			}];
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
			
		}];
		[alertC addAction:cancelAction];
		[alertC addAction:trueAction];
		[weakSelf presentViewController:alertC animated:YES completion:nil];
		
        
        
    }else if ([title isEqualToString:@"短信"]){
        [self showShortMail:detailModel];
        
    }else if ([title isEqualToString:@"微信"]){
        [self showWechat:detailModel];
        
    }else if ([title isEqualToString:@"公众号"]){
        [self showPublicNumber:detailModel];
        
    }

    
}

#pragma mark  --datas
-(void)getChooseDatas{
    [self getSalesListDatasCompliation:^(MJKClueListViewModel *saleDatasModel) {
        //类型
		NSMutableArray*dataArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TYPE"];
		NSMutableArray*mtArray=[NSMutableArray array];
		NSMutableArray*postArray=[NSMutableArray array];
		for (MJKDataDicModel*model in dataArray) {
			[mtArray addObject:model.C_NAME];
			[postArray addObject:model.C_VOUCHERID];
		}
		[mtArray insertObject:@"全部" atIndex:0];
		[postArray insertObject:@"" atIndex:0];
		NSMutableArray*TypeArr=[NSMutableArray arrayWithArray:mtArray];
		NSMutableArray*TypeSelectedArr=[NSMutableArray arrayWithArray:postArray];
//        NSMutableArray*TypeArr=[NSMutableArray arrayWithObjects:@"全部",@"上门测量",@"上门安装",@"上门维护",@"其他", nil];
//        NSMutableArray*TypeSelectedArr=[NSMutableArray arrayWithObjects:@"",@"0",@"1",@"2",@"3", nil];
		
        //状态
        NSMutableArray*statusArr=[NSMutableArray arrayWithObjects:@"全部",@"未确认",@"已确认",@"完成",@"取消", nil];
        NSMutableArray*statusSelectedArr=[NSMutableArray arrayWithObjects:@"",@"3",@"1",@"4",@"5", nil];
        
        //负责人
        NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
        NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
        for (MJKClueListSubModel *clueListSubModel in saleDatasModel.data) {
            [saleArr addObject:clueListSubModel.nickName];
            [saleSelectedArr addObject:clueListSubModel.u051Id];
        }

        //优先级
		NSMutableArray*priorityAllArr=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A01200_C_TASKSTATUS"];
		NSMutableArray*priorityArr=[NSMutableArray array];
		NSMutableArray*priorityCodeArr=[NSMutableArray array];
		[priorityArr addObject:@"全部"];
		[priorityCodeArr addObject:@""];
		for (MJKDataDicModel*model in priorityAllArr) {
			[priorityArr addObject:model.C_NAME];
			[priorityCodeArr addObject:model.C_VOUCHERID];
		}

        
        //总的 筛选tableView 的数据
        NSMutableArray*totailTableDatas=[NSMutableArray arrayWithObjects:TypeArr,statusArr,saleArr,priorityArr, nil];
        self.TableChooseDatas=totailTableDatas;
        NSMutableArray*totailTAbleSelected=[NSMutableArray arrayWithObjects:TypeSelectedArr,statusSelectedArr,saleSelectedArr,priorityCodeArr, nil];
        self.TableSelectedChooseDatas=totailTAbleSelected;
        
        
         [self addChooseViewWithAaleModel:saleDatasModel];
        
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



-(void)HttpPostgetListDatas{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_SeviceListDatas];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionaryWithDictionary:@{@"pageSize":@(_pageSize),@"currPage":@(_currPage)}];
	
	if (self.userid.length > 0) {
		[contentDict setObject:self.userid forKey:@"USER_ID"];
	}
	if (self.STATUS_TYPE.length > 0) {
		[contentDict setObject:self.STATUS_TYPE forKey:@"STATUS_TYPE"];
	}
    [self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
    [self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [contentDict setObject:obj forKey:key];
        
    }];
//	[self.funnelDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//		[contentDict setObject:obj forKey:key];
//	}];
	
//    contentDict[@"TYPE"] = @"0";
	if (self.ORDER_TIME.length > 0) {
		contentDict[@"ORDER_TIME_TYPE"] = self.ORDER_TIME;
	}
	if (self.status.length > 0) {
		contentDict[@"STATUS_TYPE"] = self.status;
	}
	
	if (self.FINISH_TIME_TYPE.length > 0) {
		contentDict[@"FINISH_TIME_TYPE"] = self.FINISH_TIME_TYPE;
	}
	
	if (self.FINISH_START_TIME.length > 0 && self.FINISH_END_TIME.length > 0) {
		contentDict[@"FINISH_START_TIME"] = self.FINISH_START_TIME;
		contentDict[@"FINISH_END_TIME"] = self.FINISH_END_TIME;
	}
	if (self.ORDER_TIME_END.length > 0) {
		contentDict[@"ORDER_END_TIME"] = self.ORDER_TIME_END;
	}
	
	if (self.searchStr.length > 0) {
		contentDict[@"SEARCH_NAMEORADDRESS"] = self.searchStr;
	}
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSString*countNumber=[NSString stringWithFormat:@"%@",data[@"countNumber"]];
            self.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",countNumber] ;
            
            NSArray*dataArray=data[@"content"];
            
            if (self.currPage==1) {
                [self.mainDatasArray removeAllObjects];
            }
            
            
            for (NSDictionary*dict in dataArray) {
                ServiceTaskModel*model=[ServiceTaskModel yy_modelWithDictionary:dict];
                [self.mainDatasArray addObject:model];
            }
            
            [self.tableView reloadData];
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
        
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
    
    
    
    
}



//改变某一条的状态
// 1: 确认 2: 退回 3: 签到 4：完成 5：延期 6：重新指派7：取消
-(void)HttpPostChangeServiceTaskStatus:(NSString*)statusCode andTaskID:(NSString*)taskID andImageArray:(NSArray *)imageArray andSuccess:(void(^)(id data))successBlock{
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:HTTP_operationServiceTask];
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    [contentDict setObject:statusCode forKey:@"STATUS_TYPE"];
    [contentDict setObject:taskID forKey:@"C_ID"];
    
    if ([statusCode isEqualToString:@"1"]) {
        
    }else if ([statusCode isEqualToString:@"3"]){
        [contentDict setObject:self.B_SIGN_LON forKey:@"B_SIGN_LON"];
        [contentDict setObject:self.B_SIGN_LAT forKey:@"B_SIGN_LAT"];
        
    }else if ([statusCode isEqualToString:@"4"]){
//		if (self.imageStr.length > 0) {
//			[contentDict setObject:self.imageStr forKey:@"X_PICURL"];
//		}
		if (imageArray.count > 0) {
			contentDict[@"urlList"] = imageArray;
		}
		if (self.performStr.length > 0) {
			[contentDict setObject:self.performStr forKey:@"X_TASKCONTENT"];
		}
		if (self.locationAddress.length > 0) {
			[contentDict setObject:self.locationAddress forKey:@"C_FINISHADDRESS"];
		}
    }else if ([statusCode isEqualToString:@"5"]){
        [contentDict setObject:self.D_ORDER_TIME forKey:@"D_ORDER_TIME"];
        
    }else if ([statusCode isEqualToString:@"7"]){
        
    }
    
    
    
    
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            successBlock(data);
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
        
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



#pragma mark -- set
-(NSMutableArray *)mainDatasArray{
    if (!_mainDatasArray) {
        _mainDatasArray=[NSMutableArray array];
    }
    return _mainDatasArray;
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight=0;
        _tableView.estimatedSectionHeaderHeight=0;
        _tableView.estimatedSectionFooterHeight=0;
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



#pragma mark  --funcation
//电话
- (void)telephoneCall:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    
       
    
    ServiceTaskModel*model=self.mainDatasArray[section];
    ServiceTaskSubModel*detailModel=model.content[row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:detailModel.C_CONTACTPHONE]]];
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    long section=index/100;
    int row=index%100;
    
    
    ServiceTaskModel*model=self.mainDatasArray[section];
    ServiceTaskSubModel*detailModel=model.content[row];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=detailModel.C_A41500_C_NAME;
    myView.callStr=detailModel.C_CONTACTPHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    long section=index/100;
    int row=index%100;
   
    
    ServiceTaskModel*model=self.mainDatasArray[section];
    ServiceTaskSubModel*detailModel=model.content[row];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=detailModel.C_A41500_C_NAME;
    myView.callStr=detailModel.C_CONTACTPHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}


#warning  baiduMap
-(void)getBaiduMapInfoComplete:(void(^)())successBlock{
    //
    
    
//    self.B_SIGN_LON=@"0.0";
//    self.B_SIGN_LAT=@"23.26";
    
//    [self configLocationManager];
//   
//    [self initCompleteBlockWithSuccess:^(MAPointAnnotation *annotation) {
//        self.B_SIGN_LON=[NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
//        self.B_SIGN_LAT=[NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
//        
//        successBlock();
//        
//    }];
//    
//     [self reGeocodeAction];
    
    [self LocateCurrentLocatedWithSuccess:^(MAPointAnnotation *annotation) {
        self.B_SIGN_LON=[NSString stringWithFormat:@"%f",annotation.coordinate.longitude];
        self.B_SIGN_LAT=[NSString stringWithFormat:@"%f",annotation.coordinate.latitude];
        
        successBlock();

        
    }];
    
    
    
}

- (NSMutableDictionary *)funnelDic {
	if (!_funnelDic) {
		_funnelDic = [NSMutableDictionary dictionary];
	}
	return _funnelDic;
}





@end
