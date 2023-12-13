//
//  MJKClueListViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/8/29.
//  Copyright © 2017年 黄蜂大魔王. All rights reserved.
//

#import "MJKClueListViewController.h"
#import "MJKClueAddViewController.h"
#import "MJKMarketViewController.h"
#import "CommonCallViewController.h"
#import "MJKVoiceCViewController.h"
#import "CGCTemplateVC.h"
//跳转查看详情
#import "CustomerDetailViewController.h"
//跟进潜客
#import "CustomerFollowAddEditViewController.h"

#import "CGCNavSearchTextView.h"//textfield筛选框
#import "CFDropDownMenuView.h"   //筛选试图
#import "MJKClueListTableViewCell.h"
#import "FunnelShowView.h"
#import "MJKClueListMainModel.h"
#import "MJKClueListMainFirstSubModel.h"
#import "MJKClueListMainSecondModel.h"
#import "MJKClueListViewModel.h"  //销售模型类
#import "MJKClueListSubModel.h"
#import "MJKFunnelChooseModel.h"//沙漏model
#import "MJKAssignedView.h"
#import "CGCCustomDateView.h"
#import "CGCAlertDateView.h"
#import "MJKClueDetailModel.h"
#import "CustomerDetailInfoModel.h"
#import "MJKClueDetailModel.h"

#import "NSString+Extern.h"

#import "VoiceView.h"

//controller
#import "MJKClueDetailViewController.h"
#import "AddOrEditlCustomerViewController.h"
#import "MJKClueNewProcessViewController.h"
#import "MJKChooseEmployeesViewController.h"


#define listCell @"listCell"

@interface MJKClueListViewController ()<CFDropDownMenuViewDelegate, UITableViewDataSource, UITableViewDelegate,MJKClueDetailViewControllerDelegate>

@property (nonatomic, strong) MJKClueListViewModel *clueListModel;
/** <#注释#>*/
@property (nonatomic, strong) MJKClueListViewModel *saleDatasModel;
@property (nonatomic, strong) MJKClueListViewModel *allSaleDatasModel;
@property (nonatomic, strong) MJKClueListMainModel *clueListMainModel;
@property (nonatomic, strong) MJKClueDetailModel *detailModel;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) CGCNavSearchTextView *titleView;

@property (nonatomic, assign) NSString *sendDownCode;//筛选的下发时间code
@property (nonatomic, strong) NSMutableArray *shopTimeArr;//到店时间
@property (nonatomic, strong) NSMutableArray *shopTimeCodeArr;//到店时间code
@property (nonatomic, strong) NSString *sexCode;
@property (nonatomic, strong) NSString *shopTimeCode;
@property (nonatomic, strong) NSString *marketCode;
@property (nonatomic, strong) NSString *yewuCode;
@property (nonatomic, strong) NSString *jieshaorenCode;
@property (nonatomic, strong) NSString *createSaleCode;
@property (nonatomic, strong) NSString *fromCode;//筛选的来源code
@property (nonatomic, strong) NSString *startTime;//筛选的来源code
@property (nonatomic, strong) NSString *endTime;//筛选的来源code
@property (nonatomic, strong) NSString *sourcePeople;
@property (nonatomic, strong) NSString *nextContactTime;

@property(nonatomic,strong)NSMutableArray*saveFunnelAllDatas;  //漏斗筛选的所有数据

@property (nonatomic, assign) int pages;
@property (nonatomic, assign) int pagen;

@property (nonatomic, strong) NSMutableArray *stateCodeArr;//状态code
@property (nonatomic, strong) NSMutableArray *fromCodeArr;//来源code
@property (nonatomic, strong) NSArray *sendDwonTimeCodeArr;
@property (nonatomic, strong) NSMutableArray *saleCodeArr;

@property (nonatomic, strong) NSString *backView;
@property (nonatomic, strong) NSString *phoneNumber;


@property (nonatomic, strong) MJKAssignedView *assignView;
@property (nonatomic, strong) MJKClueListMainSecondModel *model;
@property (nonatomic, strong) NSString *C_ID;
@property (nonatomic, assign) BOOL isAgain;
@property (nonatomic, assign) BOOL isAllSelect;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) UIButton *countButton;//总数
@property (nonatomic, strong) UIView *selectView;

@property (nonatomic, strong) NSMutableArray *fromArray;
@property (nonatomic, strong) NSMutableArray *allArray;

@property (nonatomic, strong) MJKClueDetailModel *clueDetailModel;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableDictionary *saveTimeDataDic;
@property (nonatomic, strong) NSMutableDictionary *saveSubmitDataDic;

@property(nonatomic,copy)void(^localBlock)();

@end

@implementation MJKClueListViewController
//tab页点新增
- (void)setIsAdd:(BOOL)isAdd {
	_isAdd = isAdd;
	if (isAdd == YES) {
		[self clickAddNew:nil];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
	[self.view addSubview:self.tableview];
	[self initUI];
	[self.tableview registerNib:[UINib nibWithNibName:@"MJKClueListTableViewCell" bundle:nil] forCellReuseIdentifier:listCell];
    
    if (@available(iOS 11.0, *)) {
        self.tableview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
	self.isAgain = NO;
	self.assignView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    self.allArray = nil;
	if ([self.backView isEqualToString:@"addView"]) {
		self.pagen= 20;
		self.pages = 1;
	}
	
    
	if (self.isAgain != YES) {
		[self.allArray removeAllObjects];
		[self getClueListDatas];
		self.assignView.hidden = YES;
        if (![self.haveAddButton isEqualToString:@"无"]) {
            self.tabBarController.tabBar.hidden = NO;
        } else {
            self.tabBarController.tabBar.hidden = YES;
        }
	} else {
		self.assignView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
	}
	
    if (self.isTab != YES) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

#pragma mark - initUI

- (void)initUI {
	self.view.backgroundColor = [UIColor whiteColor];
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
	[button setBackgroundImage:[UIImage imageNamed:@"网络.png"] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(clickAddNew:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
    if (![self.haveAddButton isEqualToString:@"无"]) {
        self.navigationItem.rightBarButtonItem = barButton;
    } else {
        self.tabBarController.tabBar.hidden = YES;
    }
	DBSelf(weakSelf);
	self.titleView = [[CGCNavSearchTextView alloc] initWithFrame:self.view.bounds withPlaceHolder:@"请输入手机/客户姓名/地址" withRecord:^{//点击录音
//		MJKVoiceCViewController *voiceVC = [[MJKVoiceCViewController alloc]initWithNibName:@"MJKVoiceCViewController" bundle:nil];
//		[voiceVC setBackStrBlock:^(NSString *str){
//            [weakSelf.allArray removeAllObjects];
//			weakSelf.phoneNumber = str;
//			weakSelf.titleView.textField.text = str;
//			[weakSelf getClueListDatas];
//		}];
//		[weakSelf presentViewController:voiceVC animated:YES completion:nil];
		VoiceView *vv = [[VoiceView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:vv];
		[vv start];
		vv.recordBlock = ^(NSString *str) {
			[weakSelf.allArray removeAllObjects];
			weakSelf.phoneNumber = str;
			weakSelf.titleView.textField.text = str;
			[weakSelf getClueListDatas];
		};
 } withText:^{//开始编辑
     [weakSelf.allArray removeAllObjects];
 }withEndText:^(NSString *str) {//结束编辑
//	 NSLog(@"%@____",str);
//	 weakSelf.phoneNumber = str;
     [weakSelf.allArray removeAllObjects];
     [weakSelf getClueListDatas];
 }];
	self.titleView.changeBlock = ^(NSString *str) {
        [weakSelf.allArray removeAllObjects];
		weakSelf.phoneNumber = str;
//        [weakSelf getClueListDatas];
	};
	
	self.navigationItem.titleView=self.titleView;
    self.pages = 1;
	self.pagen = 20;
	//初始化筛选条件
    if (_stateCode.length <=0) {
        _stateCode = @"";
    }
    _sendDownCode = _fromCode = _sexCode = _shopTimeCode = _marketCode = _phoneNumber = @"";
    [self httpgetSalesListDatas:^{
        [weakSelf httpgetSalesListDatas];
    }];
//    [self httpgetSalesListDatas];
	
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[self.titleView endEditing:YES];
}

- (void)addChooseView {
	[self.view addSubview:self.countButton];
	CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth-40, 40)];
	
	NSMutableArray *saleArr = [NSMutableArray array];
	[saleArr addObject:@"全部"];
	[saleArr addObject:@"我的"];
	self.saleCodeArr = [NSMutableArray array];
	[self.saleCodeArr addObject:@""];
	NSString * user_id=[NewUserSession instance].user.u051Id;
	[self.saleCodeArr addObject:user_id];
    
	NSArray *arr = self.clueListModel.data;
	for (MJKClueListSubModel *clueListSubModel in arr) {
		[saleArr addObject:clueListSubModel.nickName];
		[self.saleCodeArr addObject:clueListSubModel.u051Id];
	}
    
    NSMutableArray *fromNameArray = [NSMutableArray array];
    [fromNameArray addObject:@"全部"];
    [self.fromCodeArr addObject:@""];
    for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_CLUESOURCE"]) {
//        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
        [fromNameArray addObject:model.C_NAME];
        [self.fromCodeArr addObject:model.C_VOUCHERID];
    }
	
	NSMutableArray *stateNameArray = [NSMutableArray array];
	[stateNameArray addObject:@"全部"];
	[self.stateCodeArr addObject:@""];
	for (MJKDataDicModel*model in [[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41300_C_STATUS"]) {
		//        MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
		[stateNameArray addObject:model.C_NAME];
		[self.stateCodeArr addObject:model.C_VOUCHERID];
	}
    //,@"再激活"
    //@"",@"A41300_C_STATUS_0004",@"A41300_C_STATUS_0003",@"A41300_C_STATUS_0002",@"A41300_C_STATUS_0001",@"A41300_C_STATUS_0000"
    //@[@"全部",@"新分配",@"有意向",@"再激活",@"再下发",@"无意向",@"联系中"]
    //@[@"",@"A41300_C_STATUS_0003",@"A41300_C_STATUS_0001",@"再激活",@"A41300_C_STATUS_0004",@"A41300_C_STATUS_0000",@"A41300_C_STATUS_0002"]
	menuView.dataSourceArr=[@[saleArr,
							  stateNameArray,
							  self.shopTimeArr,
							  fromNameArray] mutableCopy];
	menuView.defaulTitleArray=@[@"员工",@"状态",@"创建时间",@"来源渠道"];
	menuView.startY=CGRectGetMaxY(menuView.frame);
	
	DBSelf(weakSelf);
	menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
		[weakSelf.allArray removeAllObjects];
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		[weakSelf selectScreenDatas:selectedSection.integerValue andRow:selectedRow.integerValue andTitle:title];
	};
	[self.view addSubview:menuView];
	
    
    

    
    
    
    //这个是筛选的view
    FunnelShowView*funnelView=[FunnelShowView funnelShowView];
    funnelView.rootVC = self;
    
    NSDictionary *dic222 = @{@"title" : @"搜索", @"content" : @[]};
    [self.saveFunnelAllDatas addObject:dic222];
    NSDictionary *dic21 = @{@"title" : @"介绍人", @"content" : @[]};
    [weakSelf.saveFunnelAllDatas addObject:dic21];
    
    NSString*Str20=@"业务";
    NSMutableArray*mtArr20=[NSMutableArray array];
    MJKFunnelChooseModel*funnelModel20=[[MJKFunnelChooseModel alloc]init];
    funnelModel20.name=@"全部";
    funnelModel20.c_id=@"";
    [mtArr20 addObject:funnelModel20];
        for (MJKClueListSubModel *model in weakSelf.allSaleDatasModel.data) {
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=model.nickName;
            funnelModel.c_id=model.u051Id;
            [mtArr20 addObject:funnelModel];
        }
    
    
    NSDictionary*dic20=@{@"title":Str20,@"content":mtArr20};
    [weakSelf.saveFunnelAllDatas addObject:dic20];
    
    //延迟 传入参数
    
        
        NSString*Str22=@"创建人";
        NSMutableArray*mtArr22=[NSMutableArray array];
        MJKFunnelChooseModel*funnelModel22=[[MJKFunnelChooseModel alloc]init];
        funnelModel22.name=@"全部";
        funnelModel22.c_id=@"";
        [mtArr22 addObject:funnelModel22];
        for (MJKClueListSubModel *model in weakSelf.saleDatasModel.data) {
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=model.nickName;
            funnelModel.c_id=model.u051Id;
            [mtArr22 addObject:funnelModel];
        }
        
        NSDictionary*dic22=@{@"title":Str22,@"content":mtArr22};
        [weakSelf.saveFunnelAllDatas addObject:dic22];
    
    
    
    //得到筛选的所有数据
    [self getFunnelValue];
    
    self.localBlock = ^{
        NSString*sourcePeopleStr=@"前负责人";
        NSMutableArray*sourcePeopleArr=[NSMutableArray array];
        MJKFunnelChooseModel*sourcePeopleModel=[[MJKFunnelChooseModel alloc]init];
        sourcePeopleModel.name=@"全部";
        sourcePeopleModel.c_id=@"";
        [sourcePeopleArr addObject:sourcePeopleModel];
        for (MJKClueListSubModel *model in weakSelf.saleDatasModel.data) {
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=model.nickName;
            funnelModel.c_id=model.u051Id;
            [sourcePeopleArr addObject:funnelModel];
        }
        
        NSDictionary*sourcePeopleDic=@{@"title":sourcePeopleStr,@"content":sourcePeopleArr};
        [weakSelf.saveFunnelAllDatas addObject:sourcePeopleDic];
        
        
        NSArray * timeStrArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近30天",@"自定义"];
        NSArray * sidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6",@"7", @"9", @"10",@"30",@"100"];
        NSString*nextTimeStr=@"下发时间";
        NSMutableArray*nextTimeArr=[NSMutableArray array];
        for (int i = 0; i < timeStrArr.count; i++) {
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=timeStrArr[i];
            funnelModel.c_id=sidArr[i];
            [nextTimeArr addObject:funnelModel];
        }
        
        NSDictionary*nextTimeDic=@{@"title":nextTimeStr,@"content":nextTimeArr};
        [weakSelf.saveFunnelAllDatas addObject:nextTimeDic];
        
        NSString*timeStr=@"下次联系时间";
        NSMutableArray*timeArr=[NSMutableArray array];
        for (int i = 0; i < timeStrArr.count; i++) {
            MJKFunnelChooseModel*funnelModel=[[MJKFunnelChooseModel alloc]init];
            funnelModel.name=timeStrArr[i];
            funnelModel.c_id=sidArr[i];
            [timeArr addObject:funnelModel];
        }
        
        NSDictionary*timeDic=@{@"title":timeStr,@"content":timeArr};
        [weakSelf.saveFunnelAllDatas addObject:timeDic];
        
        
        funnelView.allDatas=weakSelf.saveFunnelAllDatas;
        
    };
	
	funnelView.resetBlock = ^{
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		weakSelf.sendDownCode = @"";
        weakSelf.jieshaorenCode = @"";
        weakSelf.yewuCode = @"";
        weakSelf.createSaleCode = @"";
        weakSelf.phoneNumber = @"";
        weakSelf.sourcePeople = @"";
        weakSelf.nextTime = @"";
        weakSelf.nextContactTime = @"";
        weakSelf.CREATE_TIME_TYPE = @"";
        [weakSelf.saveTimeDataDic removeAllObjects];
		[weakSelf getClueListDatas];
		
//        [funnelView hidden];
        
        [weakSelf.tableview.mj_header beginRefreshing];
	};
	
    //c_id 是999 的时候  是选择时间
    funnelView.viewCustomTimeBlock = ^(NSInteger selectSection){
        MyLog(@"自定义时间");
        [weakSelf showTimeAlertVC];
    };
    
    funnelView.jieshaorenAndLastTimeBlock = ^(NSString *jieshaoren, NSString *arriveTimes) {
        if (jieshaoren.length > 0) {
            weakSelf.jieshaorenCode = jieshaoren;
        }
        if (arriveTimes.length > 0) {
            weakSelf.phoneNumber = arriveTimes;
        }
    };
    
//    回调
    funnelView.sureBlock = ^(NSMutableArray *array) {
		DBSelf(weakSelf);
		[weakSelf.allArray removeAllObjects];
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		
		NSMutableArray <NSString *>*backArray = [NSMutableArray array];
		if (array.count <= 0) {
			weakSelf.sexCode = weakSelf.sendDownCode = weakSelf.marketCode = @"";
		}
		for (int i = 0; i < array.count; i++) {
			[backArray addObject:array[i][@"index"]];
		}
		
		for (int j = 0; j < backArray.count; j++) {
			MJKFunnelChooseModel *model = array[j][@"model"];
            if ([backArray[j] isEqualToString:@"0"] ) {
//                weakSelf.sexCode = model.c_id;
            } else if ([backArray[j] isEqualToString:@"1"]) {
//                if ([model.name isEqualToString:@"自定义"]) {
//
//                } else {
//                    weakSelf.startTime = weakSelf.endTime = @"";
//                    weakSelf.sendDownCode = model.c_id;
//                }
            } else if ([backArray[j] isEqualToString:@"2"]) {
                weakSelf.yewuCode = model.c_id;
            } else if ([backArray[j] isEqualToString:@"3"]) {
                    weakSelf.createSaleCode = model.c_id;
            } else if ([backArray[j] isEqualToString:@"4"]) {
                weakSelf.sexCode = model.c_id;
            } else if ([backArray[j] isEqualToString:@"5"]) {
                weakSelf.marketCode = model.c_id;
            } else if ([backArray[j] isEqualToString:@"6"]) {
                weakSelf.sourcePeople = model.c_id;
            } else if ([backArray[j] isEqualToString:@"7"]) {
                if ([model.name isEqualToString:@"自定义"]) {
                    DBSelf(weakSelf);
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        [weakSelf.allArray removeAllObjects];
                        weakSelf.pagen = 20;
                        weakSelf.pages = 1;
                        weakSelf.nextTime = @"";
                        [weakSelf.saveTimeDataDic setObject:start forKey:@"LEAD_START_TIME"];
                        [weakSelf.saveTimeDataDic setObject:end forKey:@"LEAD_END_TIME"];
                        [weakSelf getClueListDatas];
                    }];
                    [[UIApplication sharedApplication].keyWindow  addSubview:dateView];
                    
                } else {
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"LEAD_START_TIME"];
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"LEAD_END_TIME"];
                    weakSelf.nextTime = model.c_id;
                }
            } else if ([backArray[j] isEqualToString:@"8"]) {
                if ([model.name isEqualToString:@"自定义"]) {
                    DBSelf(weakSelf);
                    CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
                        
                    } withEnd:^{
                        
                    } withSure:^(NSString *start, NSString *end) {
                        [weakSelf.allArray removeAllObjects];
                        weakSelf.pagen = 20;
                        weakSelf.pages = 1;
                        weakSelf.nextContactTime = @"";
                        [weakSelf.saveTimeDataDic setObject:start forKey:@"NEXTCONTACT_START_TIME"];
                        [weakSelf.saveTimeDataDic setObject:end forKey:@"NEXTCONTACT_END_TIME"];
                        [weakSelf getClueListDatas];
                    }];
                    [[UIApplication sharedApplication].keyWindow  addSubview:dateView];
                    
                } else {
                    
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"NEXTCONTACT_START_TIME"];
                    [weakSelf.saveTimeDataDic removeObjectForKey:@"NEXTCONTACT_END_TIME"];
                    weakSelf.nextContactTime = model.c_id;
                }
            }
            
		}
        //吊接口  加上上面的筛选
//		[weakSelf getClueListDatas];
		[weakSelf.tableview.mj_header beginRefreshing];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:funnelView];

    //这个是漏斗按钮
    CFRightButton*funnelButton=[[CFRightButton alloc]initWithFrame:CGRectMake( KScreenWidth-40,NavStatusHeight, 40, 40)];
    [self.view addSubview:funnelButton];
    funnelButton.clickFunnelBlock = ^(BOOL isSelected) {
        [menuView hide];
        //显示 左边的view
        [funnelView show];
    };
	
	//分割线
//	UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, KScreenWidth - self.countButton.frame.size.width, 1)];
//	sepView.backgroundColor = DBColor(213, 213, 218);
//	[self.view addSubview:sepView];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.clueListMainModel.content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MJKClueListMainFirstSubModel *clueListMainFirstSubModel = self.clueListMainModel.content[section];
	return clueListMainFirstSubModel.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKClueListTableViewCell *cell = [MJKClueListTableViewCell cellWithTableView:tableView];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
	cell.selectArray = self.selectArray;
//	MJKClueListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:listCell];
	cell.isAgain = self.isAgain;
	MJKClueListMainFirstSubModel *clueListMainFirstSubModel = self.clueListMainModel.content[indexPath.section];
	MJKClueListMainSecondModel *clueListMainSecondModel = clueListMainFirstSubModel.content[indexPath.row];
	[cell updateCellWithDatas:clueListMainSecondModel];
	if (indexPath.row == clueListMainFirstSubModel.content.count - 1) {
		cell.sepLabelLayoutConstraint.constant = 0;
	}
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *view = [[UIView alloc]initWithFrame:self.tableview.tableHeaderView.frame];
	view.backgroundColor = DBColor(247,247,247);
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	timeLabel.textColor = DBColor(153,153,153);
	MJKClueListMainFirstSubModel *clueListMainFirstSubModel = self.clueListMainModel.content[section];
	timeLabel.text = clueListMainFirstSubModel.total;
	timeLabel.font = [UIFont systemFontOfSize:14.0f];
	CGSize size = [timeLabel.text sizeWithFont:timeLabel.font constrainedToSize:CGSizeMake(1000.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	timeLabel.frame = CGRectMake(16, 3, size.width, size.height);
	[view addSubview:timeLabel];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 95;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 21;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	if (self.isAgain == YES) {
		return;
	}
    
    if (![[NewUserSession instance].appcode containsObject:@"APP001_0013"]) {
        [JRToast showWithText:@"账号无权限"];
        return ;
    }
	MJKClueListMainFirstSubModel *clueListMainFirstModel = self.clueListMainModel.content[indexPath.section];
	MJKClueListMainSecondModel *model = clueListMainFirstModel.content[indexPath.row];
	DBSelf(weakSelf);
	if ([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0001"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0008"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0007"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0004"]) {
        if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
		CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc]init];
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
		PotentailCustomerListDetailModel *detailModel = [[PotentailCustomerListDetailModel alloc]init];
		detailModel.C_A41500_C_ID = model.C_A41500_C_ID;
		detailVC.mainModel = detailModel;
		[self.navigationController pushViewController:detailVC animated:YES];
    }  else {
        MJKClueNewProcessViewController *vc = [[MJKClueNewProcessViewController alloc]init];
        vc.rootVC = self;
        vc.c_id = model.C_ID;
        if ([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0000"]) {//无意向
            vc.haveOpreationButton = @"无";
        }
        [self.navigationController pushViewController:vc animated:YES];
//        MJKClueDetailViewController *clueDetailVC = [[MJKClueDetailViewController alloc]init];
//        clueDetailVC.delegate=self;
//        MJKClueListMainFirstSubModel *clueListMainFirstSubModel = self.clueListMainModel.content[indexPath.section];
//        clueDetailVC.clueListMainSecondModel = clueListMainFirstSubModel.content[indexPath.row];
//        clueDetailVC.total = clueListMainFirstSubModel.total;
//        clueDetailVC.VC = self;
//        [clueDetailVC setBackViewBlock:^(NSString *str){
//            weakSelf.backView = str;
//        }];
//        [self.navigationController pushViewController:clueDetailVC animated:YES];
	}
	
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKClueListMainFirstSubModel *clueListMainFirstModel = self.clueListMainModel.content[indexPath.section];
	MJKClueListMainSecondModel *model = clueListMainFirstModel.content[indexPath.row];
	if ([model.C_STATUS_DD_NAME isEqualToString:@"无意向"]) {
		return NO;
	}
	return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKClueListMainFirstSubModel *clueListMainFirstModel = self.clueListMainModel.content[indexPath.section];
	MJKClueListMainSecondModel *model = clueListMainFirstModel.content[indexPath.row];
	self.model = model;
	DBSelf(weakSelf);
	UITableViewRowAction *followAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"跟进客户" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            if (![[NewUserSession instance].appcode containsObject:@"APP004_0005"]) {
                [JRToast showWithText:@"账号无权限"];
                return ;
            }
			[self getCustomerDetailDatas:model.C_A41500_C_ID];
	}];
	followAction.backgroundColor = DBColor(50,151,234);
	
	
	UITableViewRowAction *assAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重新指派" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		if ([[NewUserSession instance].appcode containsObject:@"crm:a413:cxzp"]) {
			weakSelf.tabBarController.tabBar.hidden = YES;
			model.selected = YES;
			weakSelf.assignView.hidden = NO;
			UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, weakSelf.view.frame.size.width, 44)];
			weakSelf.selectView = view;
			[weakSelf.view addSubview:view];
			weakSelf.isAgain = YES;
			CGRect frame = weakSelf.tableview.frame;
			frame.size.height = weakSelf.tableview.frame.size.height + 20;
			weakSelf.tableview.frame = frame;
			[weakSelf.view addSubview:weakSelf.assignView];
			[weakSelf.tableview reloadData];
			
			[weakSelf.assignView setCloseAssignedBlock:^{
				
				weakSelf.tabBarController.tabBar.hidden = NO;
				weakSelf.isAgain = NO;
				[weakSelf.selectArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					obj.selected = NO;
				}];
				[view removeFromSuperview];
				CGRect frame = weakSelf.tableview.frame;
				frame.size.height = weakSelf.tableview.frame.size.height - 20;
				weakSelf.tableview.frame = frame;
				[weakSelf.tableview reloadData];
			}];
			
			[weakSelf.assignView setAllSelectBlock:^{
				__block BOOL result = YES;//1
				[weakSelf.selectArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
					result *= obj.isSelected;
				}];
				for (MJKClueListMainSecondModel *modelSelect in weakSelf.selectArray) {
					if (!result) {
						weakSelf.isAllSelect = YES;
						modelSelect.selected = YES;//已全选
						[weakSelf.assignView.allButton setTitle:@"取消全选" forState:UIControlStateNormal];
					} else {
						weakSelf.isAllSelect = NO;
						modelSelect.selected = NO;//未全选
						[weakSelf.assignView.allButton setTitle:@"全选" forState:UIControlStateNormal];
					}
					[weakSelf.tableview reloadData];
				}
			}];
			[weakSelf.assignView setTrueBlock:^{

				NSMutableArray *chooseArray = [NSMutableArray array];
				[weakSelf.selectArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
					if (obj.isSelected == YES) {
						[chooseArray addObject:obj];
					}
				}];
				MJKChooseEmployeesViewController *marketVC = [[MJKChooseEmployeesViewController alloc]init];
                if ([[NewUserSession instance].appcode containsObject:@"crm:a413:cxzpkmd"]) {
                    marketVC.isAllEmployees = @"是";
                }
				//如果没有下级就只有自己
				if (weakSelf.clueListModel.data.count <= 0) {
					MJKClueListSubModel *subModel = [MJKClueListSubModel new];
					subModel.user_id = [NewUserSession instance].user.u051Id;
					subModel.user_name = [NewUserSession instance].user.nickName;
					subModel.C_HEADPIC = [NewUserSession instance].user.avatar;
					[weakSelf.clueListModel.data addObject:subModel];
				}
                marketVC.chooseEmployeesBlock = ^(MJKClueListSubModel * _Nonnull model) {
                    NSMutableArray *arr = [NSMutableArray array];
                    for (MJKClueListMainSecondModel *model in chooseArray) {
                        [arr addObject:model.C_ID];
                    }
                    
                    NSString *chooseStr = [arr componentsJoinedByString:@","];
                    [weakSelf updateAssignClues:chooseStr andSale:model.u031Id];
                    
                    weakSelf.tabBarController.tabBar.hidden = NO;
                    weakSelf.isAgain = NO;
                    [weakSelf.selectArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        obj.selected = NO;
                    }];
                    [view removeFromSuperview];
                    CGRect frame = weakSelf.tableview.frame;
                    frame.size.height = weakSelf.tableview.frame.size.height + 30;
                    weakSelf.tableview.frame = frame;
                    
                };
                
//                marketVC.backSuccessBlock = ^{
//
//                    weakSelf.tabBarController.tabBar.hidden = NO;
//                    weakSelf.isAgain = NO;
//                    [weakSelf.selectArray enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                        obj.selected = NO;
//                    }];
//                    [view removeFromSuperview];
//                    CGRect frame = weakSelf.tableview.frame;
//                    frame.size.height = weakSelf.tableview.frame.size.height + 30;
//                    weakSelf.tableview.frame = frame;
//                };
				//			marketVC.clueListModel = weakSelf.clueListModel;
				if (chooseArray.count > 0) {
//                    marketVC.chooseArray = chooseArray;
					[weakSelf.navigationController pushViewController:marketVC animated:YES];
				} else {
					[JRToast showWithText:@"请选择线索"];
				}
			}];
		} else {
			[JRToast showWithText:@"账号无权限"];
		}
		
	}];
	assAction.backgroundColor = DBColor(50,151,234);
	
	UITableViewRowAction *seeAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"查看客户" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
			//查看潜=
        if (![[NewUserSession instance].appcode containsObject:@"APP004_0025"]) {
            [JRToast showWithText:@"账号无权限"];
            return;
        }
			CustomerDetailViewController *detailVC = [[CustomerDetailViewController alloc]init];
			[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"VCName"];
			PotentailCustomerListDetailModel *detailModel = [[PotentailCustomerListDetailModel alloc]init];
			detailModel.C_A41500_C_ID = model.C_A41500_C_ID;
			detailVC.mainModel = detailModel;
			[weakSelf.navigationController pushViewController:detailVC animated:YES];
		
			
		
	}];
	
	UITableViewRowAction *defeatAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"战败" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
			if (![[NewUserSession instance].appcode containsObject:@"APP001_0007"]) {
				[JRToast showWithText:@"账号无权限"];
				return ;
			}
			//战败
			NSMutableArray*failChooseArray=[NSMutableArray array];
        NSMutableArray*failChooseCodeArray=[NSMutableArray array];
			for (MJKDataDicModel *model in[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A42500_C_REMARK_TYPE"] ) {
				[failChooseArray addObject:model.C_NAME];
                [failChooseCodeArray addObject:model.C_VOUCHERID];
			}
			DBSelf(weakSelf);
			CGCAlertDateView *alertDateView = [[CGCAlertDateView alloc]initWithFrame:CGRectMake(15, self.view.frame.size.height / 2 - 100, KScreenWidth - 30, 200) withSelClick:^{
				
			} withSureClick:^(NSString *title, NSString *dateStr) {
                NSInteger index = [failChooseArray indexOfObject:title];
                [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:dateStr andC_REMARK_TYPE_DD_ID:failChooseCodeArray[index] andC_OBJECT_ID:weakSelf.model.C_A41500_C_ID andTYPE:@"A42500_C_TYPE_0000" andSuccessBlock:^{
                    
                        [KVNProgress show];
                        [weakSelf getClueListDatas];
                }];
			} withHight:195.0 withText:@"请填写关闭原因" withDatas:failChooseArray];
			alertDateView.textfield.placeholder = @"请选择原因类型";
			alertDateView.remarkText.placeholder = @"请填写关闭备注";
			alertDateView.remarkText.hidden = NO;
			[self.view addSubview:alertDateView];
		
		
	}];
										   
	
	
	seeAction1.backgroundColor = defeatAction1.backgroundColor = DBColor(153,153,153);
	
										   
	
	
	
	UITableViewRowAction *action2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"电话" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
		if (![[NewUserSession instance].appcode containsObject:@"APP001_0009"]) {
			[JRToast showWithText:@"账号无权限"];
			return ;
		}
		if (model.C_PHONE.length == 11) {
//			[self selectTelephone:indexPath.row];
			[[UIApplication sharedApplication]openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",self.model.C_PHONE ]]];
		} else {
			[JRToast showWithText:@"电话号不合法"];
		}
		
	}];
	action2.backgroundColor = DBColor(255,195,0);
	if ([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0003"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0006"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0002"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0005"]) {
		return @[assAction, action2];
	} else if ([model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0001"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0008"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0007"] || [model.C_STATUS_DD_ID isEqualToString:@"A41300_C_STATUS_0004"]) {
		return @[followAction, seeAction1, action2];
	} else {
		return nil;
	}
}

- (void)createAlertView {
	UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写线索关闭理由" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
	alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
	[alertView show];
}



-(void)setUpRefresh{
	self.pages = 1;
	DBSelf(weakSelf);
	self.tableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.allArray removeAllObjects];
		weakSelf.pages = 1;
		weakSelf.pagen = 20;
		[weakSelf getClueListDatas];
	}];
	
	self.tableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf getClueListDatas];
	}];
	[weakSelf.tableview.mj_header beginRefreshing];
}

#pragma mark - 点击事件
- (void)clickAddNew:(UIButton *)sender {
    if (self.isAgain == YES) {
        return;
    }
	MJKClueAddViewController *addVC = [[MJKClueAddViewController alloc]init];
	DBSelf(weakSelf);
	[addVC setBackViewBlock:^(NSString *str){
		weakSelf.backView = str;
	}];
	if (![[NewUserSession instance].appcode containsObject:@"crm:a413:add"]) {
		[JRToast showWithText:@"账号无权限"];
		return ;
	}
	[self.navigationController pushViewController:addVC animated:YES];
}


- (void)selectScreenDatas:(NSInteger)section andRow:(NSInteger)row andTitle:(NSString *)title{
	if (section == 0) {
		self.saleCode = self.saleCodeArr[row];
	}
	if (section == 1) {
		self.stateCode = self.stateCodeArr[row];
	}
	if (section == 2) {
		if ([title isEqualToString:@"自定义"]) {
			DBSelf(weakSelf);
			CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
				
			} withEnd:^{
				
			} withSure:^(NSString *start, NSString *end) {
				[weakSelf.allArray removeAllObjects];
				weakSelf.pagen = 20;
				weakSelf.pages = 1;
                [weakSelf.saveTimeDataDic setObject:start forKey:@"CREATE_START_TIME"];
                [weakSelf.saveTimeDataDic setObject:end forKey:@"CREATE_END_TIME"];
				weakSelf.CREATE_TIME_TYPE =@"";
				[weakSelf getClueListDatas];
			}];
			[[UIApplication sharedApplication].keyWindow  addSubview:dateView];
		} else {
            [self.saveTimeDataDic removeObjectForKey:@"CREATE_START_TIME"];
            [self.saveTimeDataDic removeObjectForKey:@"CREATE_END_TIME"];
			self.sendDownCode = self.shopTimeCodeArr[row];
            self.CREATE_TIME_TYPE = self.shopTimeCodeArr[row];
		}
		
	}
	if (section == 3) {
		self.fromCode = self.fromCodeArr[row];
	}
//    [self getClueListDatas];
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - 重写方法
//电话
- (void)telephoneCall:(NSInteger)index{
    if (self.model.C_PHONE.length > 0) {
	[[UIApplication sharedApplication]openURL:[NSURL URLWithString: [NSString stringWithFormat:@"tel://%@",self.model.C_PHONE ]]];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
	
}

- (void)whbcallBack:(NSInteger)index {
    if (self.model.C_PHONE.length > 0) {
    [DBObjectTools whbCallWithC_OBJECT_ID:self.model.C_ID andC_CALL_PHONE:self.model.C_PHONE andC_NAME:self.model.C_NAME andC_OBJECTTYPE_DD_ID:@"A83100_C_OBJECTTYPE_0000" andCompleteBlock:nil];
    } else {
       [JRToast showWithText:@"无电话号码"];
   }
}

- (void)closePhone {
    if ([self.model.C_STATUS_DD_NAME isEqualToString:@"有意向"] || [self.model.C_STATUS_DD_NAME isEqualToString:@"已关联"]) {
        [self alertViewFollow];
    }
    
}

- (void)alertViewFollow {
    DBSelf(weakSelf);
    UIAlertController *alertV = [UIAlertController alertControllerWithTitle:@"是否新增跟进" message:nil  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       
        CustomerDetailInfoModel*infoModel=[[CustomerDetailInfoModel alloc]init];
        infoModel.C_ID=weakSelf.model.C_A41500_C_ID;
//        infoModel.C_HEADIMGURL=weakSelf.model.C_HEADIMGURL;
        infoModel.C_NAME=weakSelf.model.C_NAME;
        infoModel.C_LEVEL_DD_NAME=weakSelf.model.C_LEVEL_DD_NAME;
        infoModel.C_LEVEL_DD_ID=weakSelf.model.C_LEVEL_DD_ID;
        infoModel.C_STAGE_DD_ID = weakSelf.model.C_STAGE_DD_ID;
        infoModel.C_STAGE_DD_NAME = weakSelf.model.C_STAGE_DD_NAME;
        
        
        CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
        vc.Type=CustomerFollowUpAdd;
        vc.infoModel=infoModel;
        vc.vcSuper=weakSelf;
        vc.followText=nil;
        [weakSelf.navigationController pushViewController:vc animated:YES];
        
    }];
    [alertV addAction:cancelAction];
    [alertV addAction:trueAction];
    
    [self presentViewController:alertV animated:YES completion:nil];
}

//座机
- (void)landLineCall:(NSInteger)index{
	
	CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
	myView.typeStr=@"用座机拨打";
	myView.nameStr=@"请接听座机来电，随后将其自动呼叫对方";
	myView.callStr=self.model.C_PHONE;
	[self.navigationController pushViewController:myView animated:YES];
	
}
//回呼
- (void)callBack:(NSInteger)index{
	CommonCallViewController *myView=[[CommonCallViewController alloc]initWithNibName:@"CommonCallViewController" bundle:nil];
	myView.typeStr=@"回呼到手机";
	myView.nameStr=@"请接听手机来电，随后将其自动呼叫对方";
	myView.callStr=self.model.C_PHONE;
	[self.navigationController pushViewController:myView animated:YES];
	
}


#pragma mark  --delegate
-(void)DelegateForCompleteAddCustomerShowAlertVCToFollow:(CustomerDetailInfoModel *)newModel{
    
    [self ToFollowWithModel:newModel];

}


#pragma mark - 数据请求



- (void)httpgetSalesListDatas:(void(^)(void))completeBlock {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            
            weakSelf.allSaleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            if (completeBlock) {
                completeBlock();
            }
            //            [weakSelf getClueListDatas];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}
////销售顾问
- (void)httpgetSalesListDatas {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
    
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.clueListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            
            weakSelf.saleDatasModel = [MJKClueListViewModel yy_modelWithDictionary:data];
            [weakSelf addChooseView];
            [weakSelf setUpRefresh];
//            [weakSelf getClueListDatas];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}
//留资线索列表
- (void)getClueListDatas {
//    NSString *leadStr = @"";
    NSString *nowTime =  [DBTools getTimeFomatFromCurrentTimeStampWithYMD];
    NSString *oneDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
    NSString *threeDayTime =  [DBTools getTimeFomatFromTimeStampOnlyYMDAddDay:2 andNowTime:oneDayTime];
    NSString *beforeOneDayTime =  [DBTools getBeforeTimeFomatFromTimeStampOnlyYMDAddDay:1 andNowTime:nowTime];
	NSMutableDictionary *parameterDic = [NSMutableDictionary dictionary];
	if (self.timerType==clueListTimeTypeToday) {
        [parameterDic setObject:self.LEAD_START_TIME forKey:@"LEAD_START_TIME"];
        [parameterDic setObject:self.LEAD_END_TIME forKey:@"LEAD_END_TIME"];
	}else if (self.timerType==clueListTimeTypeOverDay){
        [parameterDic setObject:self.LEAD_START_TIME forKey:@"LEAD_START_TIME"];
        [parameterDic setObject:self.LEAD_END_TIME forKey:@"LEAD_END_TIME"];
	}
	[parameterDic setObject:[NSString stringWithFormat:@"%d",self.pages] forKey:@"pageNum"];
	[parameterDic setObject:[NSString stringWithFormat:@"%d",self.pagen] forKey:@"pageSize"];
    if (self.saleCode.length > 0) {
        [parameterDic setObject:_saleCode forKey:@"C_OWNER_ROLEID"];
    }
	
	if (self.stateCode.length > 0) {
		[parameterDic setObject:_stateCode forKey:@"C_STATUS_DD_ID"];
	}
    if (self.nextTime.length > 0) {
        [parameterDic setObject:self.nextTime forKey:@"LEAD_TIME_TYPE"];
    }
    if (self.nextContactTime.length > 0) {
        [parameterDic setObject:self.nextContactTime forKey:@"NEXTCONTACT_TIME_TYPE"];
    }
//    [parameterDic setObject:leadStr.length > 0 ? leadStr : self.sendDownCode forKey:@"LEAD_TIME_TYPE"];
    if (_marketCode.length > 0) {
        [parameterDic setObject:_marketCode forKey:@"C_A41200_C_ID"];
    }
    if (self.sexCode.length > 0) {
        [parameterDic setObject:self.sexCode forKey:@"C_SEX_DD_ID"];
    }
    if (self.CREATE_TIME_TYPE.length>0) {
        parameterDic[@"CREATE_TIME_TYPE"] = self.CREATE_TIME_TYPE;
    }
//    if (self.startTime.length > 0 || self.endTime.length > 0) {
//        [parameterDic setObject:self.startTime.length > 0 ? self.startTime : @"" forKey:@"START_TIME"];
//        [parameterDic setObject:self.endTime.length > 0 ? self.endTime : @"" forKey:@"END_TIME"];
//    } else {
//        [parameterDic setObject:self.shopTimeCode forKey:@"SHOP_TIME_TYPE"];
//    }
    if (_fromCode.length > 0) {
        [parameterDic setObject:_fromCode forKey:@"C_CLUESOURCE_DD_ID"];
    }
    if (_phoneNumber.length > 0) {
        [parameterDic setObject:_phoneNumber forKey:@"SEARCH_NAMEORCONTACT"];
    }
    if (self.IS_A47700.length > 0) {
        [parameterDic setObject:self.IS_A47700 forKey:@"IS_A47700"];
    }
    if (self.jieshaorenCode.length > 0) {
        //C_A47700_C_ID
        [parameterDic setObject:self.jieshaorenCode forKey:@"C_A47700_C_ID"];
    }
    if (self.yewuCode.length > 0) {
        [parameterDic setObject:self.yewuCode forKey:@"C_CLUEPROVIDER_ROLEID"];
    }
    if (self.createSaleCode.length > 0) {
        [parameterDic setObject:self.createSaleCode forKey:@"C_CREATOR_ROLEID"];
    }
    
    
    if (self.sourcePeople.length > 0) {
        [parameterDic setObject:self.sourcePeople forKey:@"C_SOURCEOWNERID"];
    }
//    if (self.nextTime.length > 0) {
//        <#statements#>
//    }
    if (self.TABTYPE.length > 0) {
        parameterDic[@"TABTYPE"] = self.TABTYPE;
    }
    if (self.I_SFSY.length > 0) {
        parameterDic[@"I_SFSY"] = self.I_SFSY;
    }
    
    [self.saveTimeDataDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        parameterDic[key] = obj;
    }];
    parameterDic[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/list", HTTP_IP] parameters:parameterDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
			
            weakSelf.clueListMainModel = [MJKClueListMainModel yy_modelWithDictionary:data[@"data"]];
            
            
            if (self.isAgain == YES) {
                if (weakSelf.allArray.count > 0) {
                    for (int i = 0; i < weakSelf.allArray.count; i++) {
                        MJKClueListMainFirstSubModel *model = weakSelf.clueListMainModel.content[i];
                        MJKClueListMainFirstSubModel *model1 = weakSelf.allArray[i];
                        for (int j = 0; j < model1.content.count; j++) {
                            MJKClueListMainSecondModel *subModel = model.content[j];
                            MJKClueListMainSecondModel *subModel1 = model1.content[j];
                            if ([subModel.C_ID isEqualToString:subModel1.C_ID]) {
                                subModel.selected = subModel1.isSelected;
                            }
                        }
                    }
                }
			}
                [weakSelf.allArray removeAllObjects];
//            }
           
			weakSelf.selectArray = [NSMutableArray array];
			[weakSelf.clueListMainModel.content enumerateObjectsUsingBlock:^(MJKClueListMainFirstSubModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if (weakSelf.isAgain == YES) {
                    [weakSelf.allArray addObject:obj];
//                }
				[obj.content enumerateObjectsUsingBlock:^(MJKClueListMainSecondModel * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
					if (weakSelf.isAllSelect == YES) {
						obj.selected = YES;
					}
					[weakSelf.selectArray addObject:obj];
				}];
			}];
			[weakSelf.countButton setTitle:[NSString stringWithFormat:@"总计:%@",weakSelf.clueListMainModel.countNumber] forState:UIControlStateNormal];
            [weakSelf.tableview reloadData];
			
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
        [KVNProgress dismiss];
    }];
}

//详情
- (void)getClueDetailData:(NSString *)C_ID complete:(void(^)(void))successBlock {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/info", HTTP_IP] parameters:@{@"C_ID" :C_ID} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.clueDetailModel = [MJKClueDetailModel yy_modelWithDictionary:data[@"data"]];
            if (successBlock) {
                successBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}
//潜客详情
- (void)getCustomerDetailDatas:(NSString *)C_ID {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a415/info", HTTP_IP] parameters:@{@"C_ID" :C_ID} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			CustomerFollowAddEditViewController *followVC = [[CustomerFollowAddEditViewController alloc]init];
			CustomerDetailInfoModel *followModel = [[CustomerDetailInfoModel alloc]init];
			followModel.C_NAME = weakSelf.model.C_NAME;
			followModel.C_LEVEL_DD_NAME = data[@"data"][@"C_LEVEL_DD_NAME"];
			followModel.C_LEVEL_DD_ID = data[@"data"][@"C_LEVEL_DD_ID"];
			followModel.C_ID = weakSelf.model.C_A41500_C_ID;
			followModel.C_HEADIMGURL = @"";
			followVC.infoModel = followModel;
			[weakSelf.navigationController pushViewController:followVC animated:YES];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}



//得到市场活动的数据
-(void)getMarketActionDatas{
    NSMutableArray*saveMarketArray=[NSMutableArray array];
	MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
	model.name=@"全部";
	model.c_id=@"";
	[saveMarketArray addObject:model];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            NSArray*array=data[@"data"][@"list"];
            for (NSDictionary*dict in array) {
                MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
                model.name=dict[@"C_NAME"];
                model.c_id=dict[@"C_ID"];
                
                [saveMarketArray addObject:model];
            }
            MyLog(@"%@",saveMarketArray);
            NSDictionary*dic=@{@"title":@"渠道细分",@"content":saveMarketArray};
            [weakSelf.saveFunnelAllDatas addObject:dic];
            //这里赋值完成后  让漏斗加载视图
            if (weakSelf.localBlock) {
                weakSelf.localBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

//MARK:重新指派
- (void)updateAssignClues:(NSString *)chooseStr andSale:(NSString *)userId {
    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a413/assign", HTTP_IP] parameters:@{@"C_ID" : chooseStr, @"USER_ID" : userId} compliation:^(id data, NSError *error) {
//        DBSelf(weakSelf);
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf getClueListDatas];
            [JRToast showWithText:data[@"msg"]];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}


#pragma mark - set
- (UITableView *)tableview {
	if (!_tableview) {
		CGRect rect = CGRectZero;
		if (self.isTab == YES) {
			rect = CGRectMake(0, NavStatusHeight+40, KScreenWidth, KScreenHeight - NavStatusHeight - 40 - WD_TabBarHeight - WD_TabBarHeight);
		} else {
			rect = CGRectMake(0, NavStatusHeight+40, KScreenWidth, KScreenHeight - NavStatusHeight - 40 - WD_TabBarHeight);
		}
		_tableview = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
		_tableview.dataSource = self;
		_tableview.delegate = self;
		_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableview.estimatedRowHeight = 0;
        _tableview.estimatedSectionHeaderHeight = 0;
//        _tableview.estimatedSectionFooterHeight = 0;
	}
	return _tableview;
}


-(NSMutableArray *)saveFunnelAllDatas{
    if (!_saveFunnelAllDatas) {
        _saveFunnelAllDatas=[NSMutableArray array];
    }
    return _saveFunnelAllDatas;
}

//- (NSArray *)stateCodeArr {
//	if (!_stateCodeArr) {
//		_stateCodeArr = [NSArray arrayWithObjects:@"",@"A41300_C_STATUS_0003",@"A41300_C_STATUS_0001",@"A41300_C_STATUS_0005",@"A41300_C_STATUS_0004",@"A41300_C_STATUS_0000",@"A41300_C_STATUS_0002", nil];
//	}
//	return _stateCodeArr;
//}

- (NSMutableArray *)stateCodeArr {
	if (!_stateCodeArr) {
		_stateCodeArr = [NSMutableArray array];
	}
	return _stateCodeArr;
}

- (NSMutableArray *)fromCodeArr {
	if (!_fromCodeArr) {
//        _fromCodeArr = [NSArray arrayWithObjects:@"",@"C_CLUESOURCE_DD_0005",@"C_CLUESOURCE_DD_0004",@"C_CLUESOURCE_DD_0006", nil];
        _fromCodeArr = [NSMutableArray array];
	}
	return _fromCodeArr;
}

//- (NSArray *)sendDwonTimeCodeArr {
//	if (!_sendDwonTimeCodeArr) {
//		_sendDwonTimeCodeArr = [NSMutableArray arrayWithObjects:@"",@"1",@"7",@"30",@"2",@"3", nil];
//	}
//	return  _sendDwonTimeCodeArr;
//}
- (NSMutableArray *)shopTimeArr {
	if (!_shopTimeArr) {
        
		_shopTimeArr = [NSMutableArray arrayWithObjects:@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近30天",@"自定义", nil];
	}
	return _shopTimeArr;
}

- (NSMutableArray *)shopTimeCodeArr {
	if (!_shopTimeCodeArr) {
		_shopTimeCodeArr = [NSMutableArray arrayWithObjects:@"", @"1", @"2", @"3", @"4", @"5", @"6",@"7", @"9", @"10",@"30",@"999", nil];
	}
	return _shopTimeCodeArr;
}


- (MJKAssignedView *)assignView {
	if (!_assignView) {
		_assignView = [[MJKAssignedView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 30, self.view.frame.size.width, 30)];
		_assignView.allButton.hidden = YES;
		_assignView.userInteractionEnabled = YES;
	}
	return _assignView;
}

- (UIButton *)countButton {
	if (!_countButton) {
		_countButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 60, NavStatusHeight + 40, 60, 20)];
		[_countButton setBackgroundImage:[UIImage imageNamed:@"all_bg.png"] forState:UIControlStateNormal];
		_countButton.titleLabel.font = [UIFont systemFontOfSize:10.0f];
		[_countButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
	}
	return _countButton;
}

#pragma mark  --funcation
-(void)ToFollowWithModel:(CustomerDetailInfoModel *)newModel{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIAlertController*alertVC=[UIAlertController alertControllerWithTitle:@"提示" message:@"是否新增跟进" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction*cancel=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction*sure=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [DBObjectTools httpPostGetCustomerDetailInfoWithC_ID:newModel.C_A41500_C_ID andCompleteBlock:^(CustomerDetailInfoModel *customerDetailModel) {
                CustomerFollowAddEditViewController*vc=[[CustomerFollowAddEditViewController alloc]init];
                vc.Type=CustomerFollowUpAdd;
                customerDetailModel.C_A41500_C_ID=customerDetailModel.C_ID;
                vc.infoModel=customerDetailModel;
                vc.vcSuper=self;
                vc.followText=nil;
                [self.navigationController pushViewController:vc animated:YES];
            }];
            
        }];
        [alertVC addAction:cancel];
        [alertVC addAction:sure];
        [self presentViewController:alertVC animated:YES completion:nil];
    });
}


-(void)getFunnelValue{
    //性别
    [self getSexDatas];

    //客户登记时间
//    [self getRegisterTime];
    
    //市场活动
   [self getMarketActionDatas];
    
    
}

-(void)getSexDatas{
    NSMutableArray*saveSexArray=[NSMutableArray array];
    MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
    model.name=@"全部";
    model.c_id=@"";
    [saveSexArray addObject:model];
	
	NSMutableArray*sexArray=[[FMDBManager sharedFMDBManager]queryDatasWithC_TYPECODE:@"A41500_C_SEX"];
    for (MJKDataDicModel*Dicmodel in sexArray) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=Dicmodel.C_NAME;
        model.c_id=Dicmodel.C_VOUCHERID;
        [saveSexArray addObject:model];
    }
    NSDictionary*dic=@{@"title":@"性别",@"content":saveSexArray};
    [self.saveFunnelAllDatas addObject:dic];
}

-(void)getRegisterTime{
    NSMutableArray*saveRegisterTimeArray=[NSMutableArray array];
    
    NSArray * name=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"最近7天",@"今年",@"去年",@"最近30天",@"自定义"];
    NSArray * C_ID=@[@"", @"1", @"2", @"3", @"4", @"5", @"6",@"7", @"9", @"10",@"30",@"999"];
    
    for (int i=0; i<name.count; i++) {
        MJKFunnelChooseModel*model=[[MJKFunnelChooseModel alloc]init];
        model.name=name[i];
        model.c_id=C_ID[i];
        [saveRegisterTimeArray addObject:model];
    }
    NSDictionary*dic=@{@"title":@"客户登记时间",@"content":saveRegisterTimeArray};
    [self.saveFunnelAllDatas addObject:dic];

}



-(void)showTimeAlertVC{
   //自定义的选择时间界面。
	DBSelf(weakSelf);
	CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
		
	} withEnd:^{
		
	} withSure:^(NSString *start, NSString *end) {
		weakSelf.pagen = 20;
		weakSelf.pages = 1;
		weakSelf.startTime=start;
		weakSelf.endTime=end;
		weakSelf.shopTimeCode =@"";
//		[weakSelf getClueListDatas];
	}];
	[[UIApplication sharedApplication].keyWindow  addSubview:dateView];
}

//- (NSMutableArray *)fromArray {
//    if (!_fromCodeArr) {
//        <#statements#>
//    }
//}
- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
}

- (NSMutableDictionary *)saveTimeDataDic {
    if (!_saveTimeDataDic) {
        _saveTimeDataDic = [NSMutableDictionary dictionary];
    }
    return _saveTimeDataDic;
}

- (NSMutableDictionary *)saveSubmitDataDic {
    if (!_saveSubmitDataDic) {
        _saveSubmitDataDic = [NSMutableDictionary dictionary];
    }
    return _saveSubmitDataDic;
}

@end
