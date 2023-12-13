//
//  AssistViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/1/5.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "AssistViewController.h"
#import "CGCNavSearchTextView.h"
#import "MJKVoiceCViewController.h"
#import "CustomerDetailViewController.h"
#import "CustomerDetailInfoModel.h"
#import "CustomerFollowAddEditViewController.h"
#import "CGCAppointmentModel.h"
#import "CGCNewAddAppointmentVC.h"
#import "DBAssignBottomChooseView.h"
#import "CGCTemplateVC.h"
#import "MJKMarketViewController.h"
#import "ShowHelpViewController.h"

#import "CFDropDownMenuView.h"
#import "CGCCustomDateView.h"
#import "PotentailCustomerListCell.h"
#import "CGCAlertDateView.h"
#import "CGCMoreCollection.h"

#import "MJKClueListViewModel.h"
#import "MJKFunnelChooseModel.h"

#import "PotentailCustomerListModel.h"
#import "AssistFollowViewController.h"

#import "CommonCallViewController.h"
#import "VoiceView.h"
#import "MJKNoteModel.h"

#define CELL0   @"PotentailCustomerListCell"

@interface AssistViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic,strong)UITableView*tableView;
@property(nonatomic,strong)UILabel*allNumberLabel;   //总计label
@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
@property(nonatomic,strong)DBAssignBottomChooseView*bottomChooseView; //底部的选择view

@property(nonatomic,strong)NSMutableArray*TableChooseDatas;    //筛选的数据
@property(nonatomic,strong)NSMutableArray*TableSelectedChooseDatas;   //筛选选中的数据
@property(nonatomic,strong)NSMutableArray*FunnelDatas;     //漏斗的所有数据
@property(nonatomic,strong)NSMutableArray<PotentailCustomerListModel*>*allListDatas;  //保存所有的潜客列表

@property (nonatomic, assign) NSInteger pagen;
@property (nonatomic, assign) NSInteger pages;
//下面4个 筛选条件    有就 加进去  没有就算了
@property(nonatomic,strong)NSString*searchStr;
@property(nonatomic,strong)NSMutableDictionary*saveSelTableDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelFunnelDict;
@property(nonatomic,strong)NSMutableDictionary*saveSelTimeDict;
@property(nonatomic,strong)NSMutableArray*saveAllSelectedAssignModelArray; //所有选中的分配的model
@property(nonatomic,strong) PotentailCustomerListDetailModel*detailModel;
/** 协助人*/
@property (nonatomic, strong) MJKClueListViewModel *saleDatasModel;
@end

@implementation AssistViewController

- (void)setTabSearchStr:(NSString *)tabSearchStr {
	_tabSearchStr = tabSearchStr;
	self.searchStr = tabSearchStr;
	[self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView.mj_header beginRefreshing];
}

- (void)initUI {
	//TYPE  一定要传  后台问题   默认给他0
	[self.saveSelTableDict setObject:@"0" forKey:@"TYPE"];
	[self createNav];
	[self createChooseView];
	[self setupRefresh];
	[self.view addSubview:self.tableView];
	[self.tableView registerNib:[UINib nibWithNibName:CELL0 bundle:nil] forCellReuseIdentifier:CELL0];
}

#pragma mark -- createUI
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

- (void)createNav{
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		if (@available(iOS 11.0, *)) {
			self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}else {
			self.automaticallyAdjustsScrollViewInsets = NO;
		}
	}
	self.view.backgroundColor=CGCTABBGColor;
	DBSelf(weakSelf);
	self.CurrentTitleView=[[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名/地址" withRecord:^{//点击录音
//		MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//		[voiceVC setBackStrBlock:^(NSString *str){
//			if (str.length>0) {
//				_CurrentTitleView.textField.text = str;
//				self.searchStr=str;
//				[self.tableView.mj_header beginRefreshing];
//			}
//		}];
//		[weakSelf presentViewController:voiceVC animated:YES completion:nil];
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
	
	
	
	
//	self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"icon_customer_add" highImage:@"" target:self andAction:@selector(addNewPotentailCustomer)];
	
	
}

-(void)createChooseView{
	DBSelf(weakSelf);
	[self getSalesListDatasCompliation:^(MJKClueListViewModel *saleDatasModel) {
		MyLog(@"%@",saleDatasModel);
		[weakSelf getActionOfMarketComplication:^(NSArray<MJKFunnelChooseModel*> *actionMarketArray) {
//			[weakSelf getNoteDataCompliation:^(NSArray *noteArray) {
				
			
			MyLog(@"%@",actionMarketArray);
			[weakSelf getSalesListDatas:^(id data) {
				//协助人
				weakSelf.saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
			//销售
			NSMutableArray*saleArr=[NSMutableArray arrayWithObjects:@"全部",@"我的", nil];
			NSMutableArray*saleSelectedArr=[NSMutableArray arrayWithObjects:@"",[NewUserSession instance].user.u051Id, nil];
			for (MJKClueListSubModel *clueListSubModel in saleDatasModel.data) {
				[saleArr addObject:clueListSubModel.nickName];
				[saleSelectedArr addObject:clueListSubModel.u051Id];
			}
			
			//等级
			NSMutableArray*levelArr=[NSMutableArray arrayWithObjects:@"全部", nil];
			NSMutableArray*levelSelectedArr=[NSMutableArray arrayWithObjects:@"", nil];
			for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_LEVEL"] ) {
				[levelArr addObject:model.C_NAME];
				[levelSelectedArr addObject:model.C_VOUCHERID];
			}
			
			//状态
			NSMutableArray*statusArr=[NSMutableArray arrayWithObjects:@"全部",@"有意向", nil];
			NSMutableArray*statusSelectedArr=[NSMutableArray arrayWithObjects:@"",@"0", nil];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STATUS"]) {
				[statusArr addObject:model.C_NAME];
				[statusSelectedArr addObject:model.C_VOUCHERID];
				
			}
			
			//排序
			NSMutableArray*sortArr=[NSMutableArray arrayWithObjects:@"活跃时间",@"跟进时间",@"创建时间",@"客户等级",@"首字母", nil];
			NSMutableArray*sortSelectedArr=[NSMutableArray arrayWithObjects:@"0",@"1",@"5",@"2",@"4", nil];
			
			//总的 筛选tableView 的数据
			NSMutableArray*totailTableDatas=[NSMutableArray arrayWithObjects:saleArr,levelArr,statusArr,sortArr, nil];
			self.TableChooseDatas=totailTableDatas;
			NSMutableArray*totailTAbleSelected=[NSMutableArray arrayWithObjects:saleSelectedArr,levelSelectedArr,statusSelectedArr,sortSelectedArr, nil];
			self.TableSelectedChooseDatas=totailTAbleSelected;
			
			
#pragma 漏斗筛选
				NSString*Str00=@"协助时间";
				NSMutableArray*mtArr00=[NSMutableArray array];
                
                NSArray * array00=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel00=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
				for (int i=0; i<array00.count; i++) {
					MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
					funnelModel.name=array00[i];
					funnelModel.c_id=arraySel00[i];
					[mtArr00 addObject:funnelModel];
					
				}
				NSDictionary*dic00=@{@"title":Str00,@"content":mtArr00};
				
			NSString*starStr=@"星标客户";
			NSMutableArray*starArr=[NSMutableArray arrayWithObjects:@"全部", nil];
			NSMutableArray*starSelectedArr=[NSMutableArray arrayWithObjects:@"", nil];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STAR"]) {
				[starArr addObject:model.C_NAME];
				[starSelectedArr addObject:model.C_VOUCHERID];
			}
			NSMutableArray * StarContentArr=[NSMutableArray array];
			for (int i=0; i<starArr.count; i++) {
				MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
				model.name=starArr[i];
				model.c_id=starSelectedArr[i];
				[StarContentArr addObject:model];
			}
			NSDictionary*starDic=@{@"title":starStr,@"content":StarContentArr};
			
                NSString*mcStr=@"是否免测";
                NSMutableArray*mcArr=[NSMutableArray array];
                NSArray*mcArray=@[@"全部",@"是",@"否"];
                for (int i=0; i<mcArray.count; i++) {
                    MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
                    funnelModel.name=mcArray[i];
                    funnelModel.c_id=mcArray[i];
                    [mcArr addObject:funnelModel];
                    
                }
                NSDictionary*mcdic=@{@"title":mcStr,@"content":mcArr};
			
			
			NSString*potentailLevelStr=@"客户阶段";
			NSMutableArray*potentailLevelArr=[NSMutableArray array];
			MJKFunnelChooseModel*sModel=[[MJKFunnelChooseModel alloc]init];
			sModel.name=@"全部";
			sModel.c_id=@"";
			[potentailLevelArr addObject:sModel];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_STAGE"]) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.C_NAME;
				funnelModel.c_id=model.C_VOUCHERID;
				[potentailLevelArr addObject:funnelModel];
			}
			NSDictionary*potentailDic=@{@"title":potentailLevelStr,@"content":potentailLevelArr};
			
			
			
			
			NSString*customerSourceStr=@"来源渠道";
			NSMutableArray*customerSourceArr=[NSMutableArray array];
			MJKFunnelChooseModel*customerSourceModel=[[MJKFunnelChooseModel alloc]init];
			customerSourceModel.name=@"全部";
			customerSourceModel.c_id=@"";
			[customerSourceArr addObject:customerSourceModel];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"]) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.C_NAME;
				funnelModel.c_id=model.C_VOUCHERID;
				[customerSourceArr addObject:funnelModel];
			}
			NSDictionary*customerSourceDic=@{@"title":customerSourceStr,@"content":customerSourceArr};
			
			
			
			
			//市场活动
			NSString*str9=@"渠道细分";
			NSDictionary*dic9=@{@"title":str9,@"content":actionMarketArray};
			
			
			
			
			
			
			
			
			//年收入
			NSString*Str10=@"预算";
			NSMutableArray*mtArr10=[NSMutableArray array];
			MJKFunnelChooseModel*Model10=[[MJKFunnelChooseModel alloc]init];
			Model10.name=@"全部";
			Model10.c_id=@"";
			[mtArr10 addObject:Model10];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SALARY"]) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.C_NAME;
				funnelModel.c_id=model.C_VOUCHERID;
				[mtArr10 addObject:funnelModel];
			}
			NSDictionary*dic10=@{@"title":Str10,@"content":mtArr10};
			
			
			
			NSString*Str11=@"物业类型";
			NSMutableArray*mtArr11=[NSMutableArray array];
			MJKFunnelChooseModel*Model11=[[MJKFunnelChooseModel alloc]init];
			Model11.name=@"全部";
			Model11.c_id=@"";
			[mtArr11 addObject:Model11];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_EDUCATION"]) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.C_NAME;
				funnelModel.c_id=model.C_VOUCHERID;
				[mtArr11 addObject:funnelModel];
			}
			NSDictionary*dic11=@{@"title":Str11,@"content":mtArr11};
			
			
			
			NSString*Str12=@"居住人口";
			NSMutableArray*mtArr12=[NSMutableArray array];
			MJKFunnelChooseModel*Model12=[[MJKFunnelChooseModel alloc]init];
			Model12.name=@"全部";
			Model12.c_id=@"";
			[mtArr12 addObject:Model12];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_MARITALSTATUS"]) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.C_NAME;
				funnelModel.c_id=model.C_VOUCHERID;
				[mtArr12 addObject:funnelModel];
			}
			NSDictionary*dic12=@{@"title":Str12,@"content":mtArr12};
			
			
			
			NSString*Str13=@"爱好";
			NSMutableArray*mtArr13=[NSMutableArray array];
			MJKFunnelChooseModel*Model13=[[MJKFunnelChooseModel alloc]init];
			Model13.name=@"全部";
			Model13.c_id=@"";
			[mtArr13 addObject:Model13];
			for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_HOBBY"]) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=model.C_NAME;
				funnelModel.c_id=model.C_VOUCHERID;
				[mtArr13 addObject:funnelModel];
			}
			NSDictionary*dic13=@{@"title":Str13,@"content":mtArr13};
			
			
			
			NSString*Str14=@"创建时间";
			NSMutableArray*mtArr14=[NSMutableArray array];
                NSArray * array14=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel14=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
			for (int i=0; i<array14.count; i++) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=array14[i];
				funnelModel.c_id=arraySel14[i];
				[mtArr14 addObject:funnelModel];
				
			}
			NSDictionary*dic14=@{@"title":Str14,@"content":mtArr14};
			
			
			NSString*Str15=@"下次跟进时间";
			NSMutableArray*mtArr15=[NSMutableArray array];
                NSArray * array15=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel15=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
			for (int i=0; i<array15.count; i++) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=array15[i];
				funnelModel.c_id=arraySel15[i];
				[mtArr15 addObject:funnelModel];
				
			}
			NSDictionary*dic15=@{@"title":Str15,@"content":mtArr15};
			
			
			NSString*Str16=@"活跃时间";
			NSMutableArray*mtArr16=[NSMutableArray array];
                NSArray * array16=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
                NSArray * arraySel16=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"999"];
			for (int i=0; i<array16.count; i++) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=array16[i];
				funnelModel.c_id=arraySel16[i];
				[mtArr16 addObject:funnelModel];
				
			}
			NSDictionary*dic16=@{@"title":Str16,@"content":mtArr16};
			
				
				NSString*Str17=@"协助发起人";
				NSMutableArray*mtArr17=[NSMutableArray array];
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=@"全部";
				funnelModel.c_id=@"";
				[mtArr17 addObject:funnelModel];
				//			NSArray*array17=@[@"全部",@"今天",@"最近7天",@"最近30天",@"本周",@"本月",@"自定义"];
				//			NSArray*arraySel16=@[@"",@"1",@"7",@"30",@"2",@"3",@"999"];
				for (MJKClueListSubModel *model in self.saleDatasModel.data) {
					MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
					funnelModel.name=model.nickName;
					funnelModel.c_id=model.u051Id;
					[mtArr17 addObject:funnelModel];
				}
				
				NSDictionary*dic17=@{@"title":Str17,@"content":mtArr17};
			
				NSString*Str18=@"客户标签";
				NSMutableArray*mtArr18=[NSMutableArray array];
				MJKFunnelChooseModel*funnelModel18=[[MJKFunnelChooseModel alloc]init];
				funnelModel18.name=@"全部";
				funnelModel18.c_id=@"";
				[mtArr18 addObject:funnelModel18];
//				for (MJKNoteModel *model in noteArray) {
//					MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
//					funnelModel.name=model.C_NAME;
//					funnelModel.c_id=model.C_ID;
//					[mtArr18 addObject:funnelModel];
//				}
				NSDictionary*dic18=@{@"title":Str18,@"content":mtArr18};
			
//            NSMutableArray*funnelTotailArr=[NSMutableArray arrayWithObjects:dic00, starDic,potentailDic,customerSourceDic,dic9,dic10,dic11,dic12,dic13,dic14,dic15,dic16,dic17,dic18, nil];
                NSMutableArray*funnelTotailArr=[NSMutableArray arrayWithObjects:dic17, dic00, dic14, dic16, starDic,mcdic,potentailDic,customerSourceDic,dic9,dic10,dic11,dic12,dic13, dic18, nil];
			self.FunnelDatas=funnelTotailArr;
                
			//
			[self addChooseView];
			
			
			
			
			
			}];
//		}];
		}];
	}];
	
}

-(void)addChooseView{
	DBSelf(weakSelf);
	CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
	menuView.dataSourceArr=self.TableChooseDatas;
    menuView.VCName = @"协助客户";
	menuView.defaulTitleArray=@[@"员工",@"等级",@"有意向",@"排序"];
	menuView.startY=CGRectGetMaxY(menuView.frame);
	menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
		MyLog(@"%@  %@   %@",selectedSection,selectedRow,title);
		NSMutableArray*subArray=weakSelf.TableSelectedChooseDatas[[selectedSection integerValue]];
		NSString*selectValue=subArray[[selectedRow integerValue]];
		
		NSString*selectKey;
		if ([selectedSection isEqualToString:@"0"]) {
			//销售
			selectKey=@"C_ASSISTANT";
			
		}else if ([selectedSection isEqualToString:@"1"]){
			//等级
			selectKey=@"C_LEVEL_DD_ID";
		}else if ([selectedSection isEqualToString:@"2"]){
			//状态
			selectKey=@"C_STATUS_DD_ID";
		}else if ([selectedSection isEqualToString:@"3"]){
			//排序
			selectKey=@"TYPE";
		}
		
		
		if (selectKey) {
//			if ([selectKey isEqualToString:@"C_STATUS_DD_ID"]) {
//				self.FOLLOW_TIME_TYPE = @"";
//			}
			[weakSelf.saveSelTableDict setObject:selectValue forKey:selectKey];
			[weakSelf.tableView.mj_header beginRefreshing];
		}
		
		
	};
	[self.view addSubview:menuView];
	
	
	
	
	
	
	
	//这个是筛选的view
	FunnelShowView*funnelView=[FunnelShowView funnelShowView];
	__weak typeof(funnelView)weakFunnelView=funnelView;
	//赋值
	funnelView.allDatas=self.FunnelDatas;
	
	//c_id 是999 的时候  是选择时间
	funnelView.viewCustomTimeBlock = ^(NSInteger selectedSection) {
		MyLog(@"自定义时间   %lu",selectedSection);
		//      这里加时间   8    9   10   来跳窗口 并保存   测试
		if (selectedSection==1) {
			CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
				
			} withSure:^(NSString *start, NSString *end) {
				MyLog(@"11--%@   22--%@",start,end);
				
				[self.saveSelTimeDict setObject:start forKey:@"XZCREATE_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"XZCREATE_END_TIME"];
				
				
				
			}];
			
			
			dateView.clickCancelBlock = ^{
				NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
				[weakFunnelView unselectedDetailRow:indexPath];
				
				[self.saveSelTimeDict removeObjectForKey:@"XZCREATE_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"XZCREATE_END_TIME"];
				[self.saveSelFunnelDict setObject:@"" forKey:@"XZCREATE_TIME_TYPE"];
				
			};
			
			
			
			[[UIApplication sharedApplication].keyWindow addSubview:dateView];
			
			
			
			
			
		}
		
		if (selectedSection==2) {
			CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
				
			} withSure:^(NSString *start, NSString *end) {
				MyLog(@"11--%@   22--%@",start,end);
				
				[self.saveSelTimeDict setObject:start forKey:@"START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"END_TIME"];
				
				
				
			}];
			
			
			dateView.clickCancelBlock = ^{
				NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:8];
				[weakFunnelView unselectedDetailRow:indexPath];
				
				[self.saveSelTimeDict removeObjectForKey:@"START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"END_TIME"];
				[self.saveSelFunnelDict setObject:@"" forKey:@"CREATE_TIME"];
				
			};
			
			
			
			[[UIApplication sharedApplication].keyWindow addSubview:dateView];
			
			
			
			
			
		}/*else if (selectedSection==3){
			CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				
				
				[self.saveSelTimeDict setObject:start forKey:@"FOLLOW_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"FOLLOW_END_TIME"];
				
				
				
			}];
			
			dateView.clickCancelBlock = ^{
				NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:9];
				[weakFunnelView unselectedDetailRow:indexPath];
				
				[self.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
				[self.saveSelFunnelDict setObject:@"" forKey:@"FOLLOW_TIME"];
				
			};
			
			
			
			
			[[UIApplication sharedApplication].keyWindow addSubview:dateView];
			
			
			
		}*/else if (selectedSection==3){
			CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				
				[self.saveSelTimeDict setObject:start forKey:@"LASTUPDATE_START_TIME"];
				[self.saveSelTimeDict setObject:end forKey:@"LASTUPDATE_END_TIME"];
				
				
				
			}];
			
			
			dateView.clickCancelBlock = ^{
				NSIndexPath*indexPath=[NSIndexPath indexPathForRow:6 inSection:10];
				[weakFunnelView unselectedDetailRow:indexPath];
				
				[self.saveSelTimeDict removeObjectForKey:@"LASTUPDATE_START_TIME"];
				[self.saveSelTimeDict removeObjectForKey:@"LASTUPDATE_END_TIME"];
				[self.saveSelFunnelDict setObject:@"" forKey:@"LASTUPDATE_TIME"];
				
			};
			
			
			
			
			[[UIApplication sharedApplication].keyWindow addSubview:dateView];
			
			
		}
		
		
		
		
	};
	
	
	//    回调
	funnelView.sureBlock = ^(NSMutableArray *array) {
        //协助发起人 协助时间 创建时间 活跃时间 下次跟进时间（这个隐藏掉） 星标客户 客户阶段 来源渠道 渠道细分 预算 物业类型  居住人口 爱好 客户标签
        //协助时间 星标客户 客户阶段 来源渠道 渠道细分 预算 物业类型  居住人口 爱好 创建时间 下次跟进时间（这个隐藏掉）活跃时间 协助发起人 客户标签
		MyLog(@"%@",array);
        DBSelf(weakSelf);
		
		[self.saveSelFunnelDict removeAllObjects];
		for (NSDictionary*dict in array) {
			NSString*indexStr=dict[@"index"];
			MJKFunnelChooseModel*model=dict[@"model"];
            if ([indexStr isEqualToString:@"0"]) {
                //协助人
                [self.saveSelFunnelDict setObject:model.c_id forKey:@"USER_ID"];
            } else
			if ([indexStr isEqualToString:@"1"]){
				//协助时间
				if ([model.c_id isEqualToString:@"999"]) {
					//不传这个字段
					
					
				}else{
					//移除timerDict 里面对应的东西
					[weakSelf.saveSelTimeDict removeObjectForKey:@"XZCREATE_START_TIME"];
					[weakSelf.saveSelTimeDict removeObjectForKey:@"XZCREATE_END_TIME"];
//
					[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"XZCREATE_TIME_TYPE"];
				}
				
				
            } else if ([indexStr isEqualToString:@"2"]) {
                //创建时间
                if ([model.c_id isEqualToString:@"999"]) {
                    //不传这个字段
                    
                    
                }else{
                    //移除timerDict 里面对应的东西
                    [weakSelf.saveSelTimeDict removeObjectForKey:@"START_TIME"];
                    [weakSelf.saveSelTimeDict removeObjectForKey:@"END_TIME"];
                    
                    [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"CREATE_TIME"];
                }
            } else if ([indexStr isEqualToString:@"3"]) {
                //活跃时间
                if ([model.c_id isEqualToString:@"999"]) {
                    //不传这个字段
                    
                }else{
                    //移除timerDict 里面对应的东西
                    [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTUPDATE_START_TIME"];
                    [weakSelf.saveSelTimeDict removeObjectForKey:@"LASTUPDATE_END_TIME"];
                    
                    
                    [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"LASTUPDATE_TIME"];
                    
                }
            }
            
            else
			if ([indexStr isEqualToString:@"4"]) {
				//星标客户
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_STAR_DD_ID"];
				
            } else if ([indexStr isEqualToString:@"5"]) {
                //免测
                [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_ISMC"];
            }
            else if ([indexStr isEqualToString:@"6"]){
				//潜客阶段
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_STAGE_DD_ID"];
				
			}else if ([indexStr isEqualToString:@"7"]){
				//客户来源
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_CLUESOURCE_DD_ID"];
				
			}else if ([indexStr isEqualToString:@"8"]){
				//市场活动
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_A41200_C_ID"];
				
			}else if ([indexStr isEqualToString:@"9"]){
				//年收入
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_SALARY_DD_ID"];
			}else if ([indexStr isEqualToString:@"10"]){
				//文化程度
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_EDUCATION_DD_ID"];
			}else if ([indexStr isEqualToString:@"11"]){
				//婚姻状况
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_MARITALSTATUS_DD_ID"];
				
			}else if ([indexStr isEqualToString:@"12"]){
				//爱好
				[weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"C_HOBBY_DD_ID"];
				
			}else if ([indexStr isEqualToString:@"13"]){
                //客户标签
                [self.saveSelFunnelDict setObject:model.c_id forKey:@"X_LABEL"];
				
				
			}
//                //下次跟进时间
//                if ([model.c_id isEqualToString:@"999"]) {
//                    //不传这个字段
//
//                }else{
//                    //移除timerDict 里面对应的东西
//                    [weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
//                    [weakSelf.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
//
//
//                    [weakSelf.saveSelFunnelDict setObject:model.c_id forKey:@"FOLLOW_TIME"];
//                }
		}
		
		
		
		[weakSelf.tableView.mj_header beginRefreshing];
		
		
		
	};
	
	funnelView.resetBlock = ^{
//		[self.saveSelTimeDict removeObjectForKey:@"FOLLOW_START_TIME"];
//		[self.saveSelTimeDict removeObjectForKey:@"FOLLOW_END_TIME"];
//		//		[self.saveSelFunnelDict removeObjectForKey:@"FOLLOW_TIME"];
//
//		[self.saveSelTimeDict removeObjectForKey:@"LASTUPDATE_START_TIME"];
//		[self.saveSelTimeDict removeObjectForKey:@"LASTUPDATE_END_TIME"];
//		//		[self.saveSelFunnelDict removeObjectForKey:@"LASTUPDATE_TIME"];
//
//		[self.saveSelTimeDict removeObjectForKey:@"START_TIME"];
//		[self.saveSelTimeDict removeObjectForKey:@"END_TIME"];
		[self.saveSelTimeDict removeAllObjects];
		
		//		[self.saveSelFunnelDict removeObjectForKey:@"CREATE_TIME"];
		[self.saveSelFunnelDict removeAllObjects];
        [weakSelf.tableView.mj_header beginRefreshing];
	};
	[[UIApplication sharedApplication].keyWindow addSubview:funnelView];
	
	
	//这个是漏斗按钮
	CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
	[self.view addSubview:funnelButton];
	funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
		//tablieView
		[menuView hide];
		//显示 左边的view
		[funnelView show];
	};
	
	
	//要写在 chooseView  加载完之后
	[self addTotailView];
	
	
	
	
	
}

-(void)setupRefresh{
	DBSelf(weakSelf);
	self.pagen=20;
	self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
		self.pages=1;
		[weakSelf getListDatas];
		
	}];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		self.pages++;
		[weakSelf getListDatas];
		
	}];
	
	    [self.tableView.mj_header beginRefreshing];
	
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return self.allListDatas.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	PotentailCustomerListModel*model=self.allListDatas[section];
	return model.content.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	PotentailCustomerListCell*cell=[tableView dequeueReusableCellWithIdentifier:CELL0];
	PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
	PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
	cell.detailModel=detailModel;
//	cell.isNewAssign=self.isNewAssign;
	
	if (indexPath.row==model.content.count-1) {
		cell.bottomVIewLeftValue.constant=0;
		
	}else{
		cell.bottomVIewLeftValue.constant=15;
	}
	
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
	PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
	
//	if (self.isNewAssign) {
//		//重新分配
//		detailModel.isSelected=!detailModel.isSelected;
//		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//	}else{
//		if (self.timerType==customerListTimeTypeRecordToFollow) {
//			CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
//			infoModel.C_ID=detailModel.C_A41500_C_ID;
//			infoModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
//			infoModel.C_NAME=detailModel.C_NAME;
//			infoModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
//			infoModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
//
//
//			//去跟进界面
//			CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
//			vc.vcSuper=self.followVC;
//			vc.Type=CustomerFollowUpAdd;
//			vc.infoModel=infoModel;
//			vc.recordID=self.recordID;
//			[self.navigationController pushViewController:vc animated:YES];
//
//		}else{
	
			//单独的点击  进入 详情页面
    if (![[NewUserSession instance].appcode containsObject:@"APP016_0015"]) {
        [JRToast showWithText:@"账号无权限"];
        return;
    }
			CustomerDetailViewController*vc=[[CustomerDetailViewController alloc]init];
			[[NSUserDefaults standardUserDefaults] setObject:@"协助" forKey:@"VCName"];
			vc.mainModel=detailModel;
            vc.isAssist = YES;
			vc.assistStr = @"协助";
			[self.navigationController pushViewController:vc animated:YES];
			
//		}
//	}
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//	if (self.timerType==customerListTimeTypeRecordToFollow) {
//		return NO;
//	}
	return YES;
}

- (nullable NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
	DBSelf(weakSelf);
	PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
	PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
    self.detailModel = detailModel;
	
	UITableViewRowAction*phoneAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		MyLog(@"1");
        if (![[NewUserSession instance].appcode containsObject:@"APP016_0001"]) {
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
		NSInteger index=indexPath.section*100+indexPath.row;
		[self selectTelephone:index];
		[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}];
	phoneAction.backgroundColor=DBColor(255,195,0);
	
	
	
//	UITableViewRowAction*failAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"协助" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//		MyLog(@"2");
//		ShowHelpViewController *vc = [[ShowHelpViewController alloc]init];
////		vc.orderID = weakSelf.orderId;
//		vc.vcName = @"客户";
//		vc.C_A41500_C_ID = detailModel.C_A41500_C_ID;
//		vc.C_DESIGNER_ROLEID = detailModel.C_DESIGNER_ROLEID;
//		vc.C_ID = detailModel.C_ID;
//		[weakSelf.navigationController pushViewController:vc animated:YES];
//	}];
//	failAction.backgroundColor=DBColor(153,153,153);
	
	UITableViewRowAction*messageAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"短信" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		MyLog(@"2");
        if (![[NewUserSession instance].appcode containsObject:@"APP016_0002"]) {
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
		CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
		vc.templateType=CGCTemplateMessage;
		vc.titStr=detailModel.C_NAME;
		vc.customPhoneArr =[@[detailModel.C_PHONE] mutableCopy];
		
		vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
		vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
		vc.cusDetailModel.C_NAME=detailModel.C_NAME;
		vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
		vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
		
		[weakSelf.navigationController pushViewController:vc animated:YES];
	}];
	messageAction.backgroundColor=DBColor(153,153,153);
	
	
//	UITableViewRowAction*moreAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"更多操作" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//		MyLog(@"3");
//		[self MoreChooseWithIndexPath:indexPath];
//
//
//	}];
//	moreAction.backgroundColor=DBColor(50,151,234);
	
	UITableViewRowAction*wechatAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"微信" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		MyLog(@"3");
        if (![[NewUserSession instance].appcode containsObject:@"APP016_0003"]) {
            [JRToast showWithText:@"账号无权限"];
            return ;
        }
		CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
		vc.templateType=CGCTemplateWeiXin;
		vc.titStr=detailModel.C_NAME;
		vc.customIDArr=[@[detailModel.C_A41500_C_ID] mutableCopy];
		
		vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
		vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
		vc.cusDetailModel.C_NAME=detailModel.C_NAME;
		vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
		vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
		
		[weakSelf.navigationController pushViewController:vc animated:YES];
		
		
	}];
	wechatAction.backgroundColor=DBColor(50,151,234);
	
	
	
	UITableViewRowAction*activateAction=[UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"激活" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		
		UIAlertController *alert=[DBObjectTools getAlertVCwithTitle:@"提示" withMessage:@"是否申请客户激活?" clickCanel:^{
			
		} sureClick:^{
			
            [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0001" andSuccessBlock:^{
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
			
		} canelActionTitle:@"取消" sureActionTitle:@"确定"];
		[self presentViewController:alert animated:YES completion:^{
			
		}];
		
		
		
		
	}];
	activateAction.backgroundColor=[UIColor grayColor];
	
	
	
	
	
	
//	if ([detailModel.C_STATUS_DD_NAME isEqualToString:@"战败"]) {
//		return @[activateAction];
//
//	}else{
		//正常 订单 逾期    都3个
		return @[wechatAction,messageAction,phoneAction];
		
		
//	}
	
	
	
	
	return nil;
}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UIView*BGView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 25)];
	BGView.backgroundColor=KColorGrayBGView;
	
	PotentailCustomerListModel*model=self.allListDatas[section];
	NSString*Strr=model.total;
	
	UILabel*titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth/2, 15)];
	titleLabel.textColor=KColorGrayTitle;
	titleLabel.font=[UIFont systemFontOfSize:14];
	titleLabel.text=Strr;
	[BGView addSubview:titleLabel];
	
	return BGView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 84;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0.01;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 25;
}

-(void)showChooseFailDatasWith:(NSIndexPath*)indexPath{
    DBSelf(weakSelf);
	PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
	PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
	
	
	
	NSMutableArray*failChooseArray=[NSMutableArray array];
    NSMutableArray*failChooseCodeArray=[NSMutableArray array];
	for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_REMARK_TYPE"] ) {
		[failChooseArray addObject:model.C_NAME];
        [failChooseCodeArray addObject:model.C_VOUCHERID];
		
	}
	
	
	CGCAlertDateView *alertDate=[[CGCAlertDateView alloc] initWithFrame:self.view.bounds  withSelClick:^{
		
	} withSureClick:^(NSString *title, NSString *dateStr) {
		MyLog(@"11--%@   22---%@",title,dateStr);
		if (dateStr.length<1||title.length<1) {
			
			[JRToast showWithText:@"战败类型和战败理由必填才能提交"];
			
			
		}else{
			NSString*remarkReason=[NSString stringWithFormat:@"%@,%@",title,dateStr];
            NSInteger index = [failChooseArray indexOfObject:title];
            [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[index] andC_OBJECT_ID:detailModel.C_ID andTYPE:@"A42500_C_TYPE_0000" andSuccessBlock:^{
                [self.tableView.mj_header beginRefreshing];
            }];
		}
		
	} withHight:195.0 withText:@"请填写战败信息" withDatas:failChooseArray];
	
	alertDate.remarkText.placeholder=@"请输入战败理由";
	alertDate.textfield.placeholder=@"请选择战败类型";
	
	
	[self.view addSubview:alertDate];
	
	
	
}

- (void)HTTPDeleteHelper:(NSString *)C_ID {
	DBSelf(weakSelf);
//	self.listArr = [NSMutableArray array];
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-delete"];
	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
	dic[@"C_ID"] = C_ID;
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf getListDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

-(void)MoreChooseWithIndexPath:(NSIndexPath*)indexPath{
	DBSelf(weakSelf);
	
	PotentailCustomerListModel*model=self.allListDatas[indexPath.section];
	PotentailCustomerListDetailModel*detailModel=model.content[indexPath.row];
	
	NSArray*titleArray=@[@"新增预约",@"短信",@"微信",@"新增跟进"];
	NSArray*imageArray;
	if ([detailModel.C_STAR_DD_ID isEqualToString:@"A41500_C_STAR_0000"]) {
		imageArray=@[@"moree_新增预约",@"icon-短信",@"icon-微信",@"新增跟进"];
	}else{
		imageArray=@[@"moree_新增预约",@"icon-短信",@"icon-微信",@"more_新增跟进"];
	}
	
	
	CGCMoreCollection*moreOperation=[[CGCMoreCollection alloc]initWithFrame:self.view.bounds withPicArr:imageArray withTitleArr:titleArray withTitle:@"更多操作" withSelectIndex:^(NSInteger index, NSString *title) {
		MyLog(@"index==%lu,title==%@",index,title);
		
		if ([title isEqualToString:@"新增跟进"]) {
			CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
			infoModel.C_ID=detailModel.C_A41500_C_ID;
			infoModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
			infoModel.C_NAME=detailModel.C_NAME;
			infoModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
			infoModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
			
			
			AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
			vc.Type=AssistFollowUpAdd;
			vc.infoModel=infoModel;
			vc.vcSuper=weakSelf;
			vc.followText=nil;
			[weakSelf.navigationController pushViewController:vc animated:YES];
		}
		
		
		if ([title isEqualToString:@"新增预约"]) {
			
			CGCAppointmentModel*postModel=[[CGCAppointmentModel alloc]init];
			postModel.C_A41500_C_NAME=detailModel.C_NAME;
			postModel.C_A41500_C_ID=detailModel.C_A41500_C_ID;
			postModel.C_PHONE=detailModel.C_PHONE;
			postModel.C_SEX_DD_ID=detailModel.C_SEX_DD_ID;
			postModel.C_SEX_DD_NAME=detailModel.C_SEX_DD_NAME;
			
			
			CGCNewAddAppointmentVC *vc=[[CGCNewAddAppointmentVC alloc] init];
			vc.amodel=postModel;
            vc.rootVC = self;
			[self.navigationController pushViewController:vc animated:YES];
			
			
		}
		
		
		if ([title isEqualToString:@"短信"]) {
			
			//            [self messageClick:detailModel];
			
			CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
			vc.templateType=CGCTemplateMessage;
			vc.titStr=detailModel.C_NAME;
			vc.customPhoneArr =[@[detailModel.C_PHONE] mutableCopy];
			
			vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
			vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
			vc.cusDetailModel.C_NAME=detailModel.C_NAME;
			vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
			vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
			
			[self.navigationController pushViewController:vc animated:YES];
			
			
			
		}
		
		
		
		
		
		
		if ([title isEqualToString:@"微信"]) {
			//            [self shareWeiXin:detailModel];
			
			CGCTemplateVC*vc=[[CGCTemplateVC alloc]init];
			vc.templateType=CGCTemplateWeiXin;
			vc.titStr=detailModel.C_NAME;
			vc.customIDArr=[@[detailModel.C_A41500_C_ID] mutableCopy];
			
			vc.cusDetailModel.C_ID=detailModel.C_A41500_C_ID;
			vc.cusDetailModel.C_HEADIMGURL=detailModel.C_HEADIMGURL;
			vc.cusDetailModel.C_NAME=detailModel.C_NAME;
			vc.cusDetailModel.C_LEVEL_DD_NAME=detailModel.C_LEVEL_DD_NAME;
			vc.cusDetailModel.C_LEVEL_DD_ID=detailModel.C_LEVEL_DD_ID;
			
			[self.navigationController pushViewController:vc animated:YES];
			
			
		}
		
		if ([title isEqualToString:@"协助"]) {
			NSLog(@"协助");
			ShowHelpViewController *vc = [[ShowHelpViewController alloc]init];
			vc.C_A41500_C_ID = detailModel.C_A41500_C_ID;
			[self.navigationController pushViewController:vc animated:YES];
		}
		
		
		
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:moreOperation];
	
}



-(void)getListDatas{
	NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A47200WebService-getCustomerListByAssistant"];
	
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[contentDict setObject:@(self.pages) forKey:@"currPage"];
	[contentDict setObject:@(self.pagen) forKey:@"pageSize"];
	
    contentDict[@"C_STATUS_DD_ID"] = @"0";
//    if (self.FOLLOW_TIME_TYPE.length > 0) {
//        contentDict[@"FOLLOW_TIME_TYPE"] = self.FOLLOW_TIME_TYPE;
//	} else {
//		contentDict[@"FOLLOW_TIME_TYPE"] = @"9";
//	}
	if (self.searchStr&&![self.searchStr isEqualToString:@""]) {
		[contentDict setObject:self.searchStr forKey:@"SEARCH_NAMEORCONTACT"];
	}
	
	//    MyLog(@"1     xxxxxx--%@",self.saveSelTableDict);
	//    MyLog(@"2--%@",self.saveSelFunnelDict);
	//    MyLog(@"3--%@",self.saveSelTimeDict);
	
    if (self.saleCode.length > 0) {
        contentDict[@"C_ASSISTANT"] = self.saleCode;
    }
	[self.saveSelTableDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//		if ([key isEqualToString:@"C_STATUS_DD_ID"]) {
//			[contentDict removeObjectForKey:@"FOLLOW_TIME_TYPE"];
//		}
		[contentDict setObject:obj forKey:key];
		
	}];
    
	
	[self.saveSelFunnelDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		[contentDict setObject:obj forKey:key];
	}];
	
	[self.saveSelTimeDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
		[contentDict setObject:obj forKey:key];
	}];
	
    if (self.CREATE_TIME_TYPE.length > 0) {
        contentDict[@"CREATE_TIME_TYPE"] =self.CREATE_TIME_TYPE;
    }
    if (self.CREATE_TIME.length > 0) {
        contentDict[@"CREATE_TIME"] = self.CREATE_TIME;
    }
    if (self.XZCREATE_TIME_TYPE.length > 0) {
        contentDict[@"XZCREATE_TIME_TYPE"] = self.XZCREATE_TIME_TYPE;
    }
    if (self.TYPE.length > 0) {
        contentDict[@"TYPE"] =self.TYPE;
    }
//	if (self.timerType==customerListTimeTypeToday) {
//		[contentDict setObject:@"1" forKey:@"FOLLOW_TIME_TYPE"];
//	}else if (self.timerType==customerListTimeTypeThreeDay){
//		[contentDict setObject:@"2" forKey:@"FOLLOW_TIME_TYPE"];
//	}else if (self.timerType==customerListTimeTypeOverDay){
//		[contentDict setObject:@"3" forKey:@"FOLLOW_TIME_TYPE"];
//	}
	
	
	
//	[contentDict setObject:@"1" forKey:@"CREATE_TIME_TYPE"];
	[mainDict setObject:contentDict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			if (self.pages==1) {
				[self.allListDatas removeAllObjects];
			}
			
			
			for (NSDictionary*dict in data[@"content"]) {
				PotentailCustomerListModel*model=[PotentailCustomerListModel yy_modelWithDictionary:dict];
				[self.allListDatas addObject:model];
			}
			
			NSNumber*number=data[@"countNumber"];
			self.allNumberLabel.text=[NSString stringWithFormat:@"总计:%@",number];
			
			[self.tableView reloadData];
			[self.tableView.mj_header endRefreshing];
			[self.tableView.mj_footer endRefreshing];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//得到标签
- (void)getNoteDataCompliation:(void(^)(NSArray *noteArray))noteDatasBlock {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46700WebService-getAllList"];
	
	[dict setObject:@{} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			NSArray * noteArray = [MJKNoteModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			if (noteDatasBlock) {
				noteDatasBlock(noteArray);
			}
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//得到销售列表
-(void)getSalesListDatasCompliation:(void(^)(MJKClueListViewModel*saleDatasModel))salesDatasBlock{
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
	
//        DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			MJKClueListViewModel*saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data[@"data"]];
			salesDatasBlock(saleDatasModel);
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
	
}

#pragma mark  -- 得到协助人列表
-(void)getSalesListDatas:(void(^)(id data))complete{
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			if (complete) {
				complete(data);
			}
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
	
	
}

#pragma mark - 重写打电话
//重写
//电话
- (void)telephoneCall:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }
    
    
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"tel://" stringByAppendingString:detailModel.C_PHONE]]];
}


//座机
- (void)landLineCall:(NSInteger)index{
    
    long section=index/100;
    int row=index%100;
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"用座机拨打";
    myView.nameStr=detailModel.C_NAME;
    myView.callStr=detailModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

//回呼
- (void)callBack:(NSInteger)index{
    long section=index/100;
    int row=index%100;
    if (self.allListDatas.count<section||[[self.allListDatas[section] content] count]<row) {
        [JRToast showWithText:@"section row 错误"];
        return;
    }
    PotentailCustomerListModel*model=self.allListDatas[section];
    PotentailCustomerListDetailModel*detailModel=model.content[row];
    
    CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
    myView.typeStr=@"回呼到手机";
    myView.nameStr=detailModel.C_NAME;
    myView.callStr=detailModel.C_PHONE;
    [self.navigationController pushViewController:myView animated:YES];
    
}

- (void)closePhone {
    [self alertViewFollow];
    
}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
        infoModel.C_ID=weakSelf.detailModel.C_A41500_C_ID;
        infoModel.C_HEADIMGURL=weakSelf.detailModel.C_HEADIMGURL;
        infoModel.C_NAME=weakSelf.detailModel.C_NAME;
        infoModel.C_LEVEL_DD_NAME=weakSelf.detailModel.C_LEVEL_DD_NAME;
        infoModel.C_LEVEL_DD_ID=weakSelf.detailModel.C_LEVEL_DD_ID;
        infoModel.C_STAGE_DD_ID = weakSelf.detailModel.C_STAGE_DD_ID;
        infoModel.C_STAGE_DD_NAME = weakSelf.detailModel.C_STAGE_DD_NAME;
        
        
        AssistFollowViewController*vc=[[AssistFollowViewController alloc]init];
        vc.Type=AssistFollowUpAdd;
        vc.infoModel=infoModel;
        vc.vcSuper=weakSelf;
        vc.followText=nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}

//得到市场活动
-(void)getActionOfMarketComplication:(void(^)(NSArray<MJKFunnelChooseModel*>*actionMarketArray))actionMarketBlock{
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSMutableArray*actionArray=[NSMutableArray array];
			MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
			funnelModel.name=@"全部";
			funnelModel.c_id=@"";
			[actionArray addObject:funnelModel];
			
			NSArray*contentArr=data[@"data"][@"list"];
			for (NSDictionary*dict in contentArr) {
				MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
				funnelModel.name=dict[@"C_NAME"];
				funnelModel.c_id=dict[@"C_ID"];
				[actionArray addObject:funnelModel];
			}
			
			
			actionMarketBlock(actionArray);
		}else{
			[JRToast showWithText:data[@"message"]];
		}
		
		
	}];
	
	
	
}

#pragma mark  -- set
-(UITableView *)tableView{
	if (!_tableView) {
		CGRect rect = CGRectZero;
		if (self.isTab) {
			rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight - WD_TabBarHeight);
		} else {
			rect = CGRectMake(0, NavStatusHeight + 40, KScreenWidth, KScreenHeight-NavStatusHeight - 40 - WD_TabBarHeight);
		}
		_tableView=[[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
		_tableView.delegate=self;
		_tableView.dataSource=self;
		_tableView.estimatedRowHeight=0;
		_tableView.estimatedSectionHeaderHeight=0;
		_tableView.estimatedSectionFooterHeight=0;
		_tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}

-(NSMutableArray<PotentailCustomerListModel *> *)allListDatas{
	if (!_allListDatas) {
		_allListDatas=[NSMutableArray array];
	}
	return _allListDatas;
}

-(NSMutableDictionary *)saveSelTableDict{
	if (!_saveSelTableDict) {
		_saveSelTableDict=[NSMutableDictionary dictionary];
	}
	return _saveSelTableDict;
}

-(NSMutableDictionary *)saveSelFunnelDict{
	if (!_saveSelFunnelDict) {
		_saveSelFunnelDict=[NSMutableDictionary dictionary];
	}
	return _saveSelFunnelDict;
	
}

-(NSMutableDictionary*)saveSelTimeDict{
	if (!_saveSelTimeDict) {
		_saveSelTimeDict=[NSMutableDictionary dictionary];
	}
	return _saveSelTimeDict;
}

@end
