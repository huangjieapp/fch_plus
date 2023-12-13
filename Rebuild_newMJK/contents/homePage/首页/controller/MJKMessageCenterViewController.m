//
//  MJKMessageCenterViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/12.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKMessageCenterViewController.h"

#import "MJKMessageCell.h"

#import "MJKMessageCenterModel.h"


#import "MJKClueDetailViewController.h"//名单流量处理
#import "CustomerDetailViewController.h"//客户详情
#import "CGCAppiontDetailVC.h"//预约处理
#import "addDealViewController.h"//收款退款
#import "OrderDetailViewController.h"//订单详情
#import "ServiceTaskPerformViewController.h"//任务执行
#import "MJKFlowDetailViewController.h"//门店流量处理
#import "MJKFlowMeterDetailViewController.h"//流量仪分配
#import "WXApi.h"//w满意度
#import "MJKAttendanceViewController.h"//考勤
#import "MJKWorkReportViewController.h"//工作汇报列表
#import "MJKWorkWorldViewController.h"//工作圈
#import "MJKCommentsViewController.h"//评论列表
#import "PotentailCustomerListViewController.h"//今日代办客户跟进列表
#import "CGCOrderListVC.h"//今日代办订单跟进列表
#import "CGCAppointmentListVC.h"//今日代办预约到店
#import "ServiceTaskViewController.h"//今日代办任务执行

#import "MJKMessageDetailModel.h"
#import "MJKClueListMainSecondModel.h"//流量
#import "PotentailCustomerListDetailModel.h"//客户详细
#import "MJKOrderMoneyListModel.h"//收款退款
#import "MJKFlowMeterSubSecondModel.h"//流量仪分配
#import "ServiceTaskTrueDetailViewController.h"//任务详情
#import "MJKSingleDetailViewController.h"
#import "MJKTelephoneRobotProcessViewController.h"//ai外呼
#import "MJKOldCustomerSalesViewController.h"
#import "MJKHighQualityViewController.h"
#import "MJKRegistrationViewController.h"
#import "MJKQualityAssuranceViewController.h"
#import "MJKMortgageViewController.h"
#import "MJKInsuranceViewController.h"
#import "MJKApprolViewController.h"

@interface MJKMessageCenterViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** data array*/
@property (nonatomic, strong) NSArray *dataArray;
/** 已读按钮*/
@property (nonatomic, assign) BOOL isRead;
/** read choose view*/
@property (nonatomic, strong) UIView *readChooseView;
/** is all choose*/
@property (nonatomic, assign) BOOL isAllChoose;
/** clean badge*/
@property (nonatomic, assign) BOOL cleanBadge;
/** <#注释#> */
@property (nonatomic, assign) NSInteger pageSize;
@end

@implementation MJKMessageCenterViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.view.backgroundColor = kBackgroundColor;
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	self.title = @"消息中心";
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.readChooseView];
	
	[self configRightItem];
    
    [self configRefresh];
}

- (void)configRefresh {
    @weakify(self);
    self.pageSize = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self httpGetMessageList];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self httpGetMessageList];
    }];
}

- (void)configRightItem {
	self.isRead = NO;
	self.isAllChoose = NO;
	self.cleanBadge = NO;
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
	[button setTitleNormal:@"已读"];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button setTitleColor:[UIColor blackColor]];
	[button addTarget:self action:@selector(isReadButtonAction:)];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark - isReadButtonAction 已读按钮事件
- (void)isReadButtonAction:(UIButton *)sender {
	if (self.isRead == NO) {
		[sender setTitleNormal:@"取消"];
		self.isRead = YES;
		self.readChooseView.hidden = NO;
		CGRect rect = self.tableView.frame;
		rect.size.height = rect.size.height - 40;
		self.tableView.frame = rect;
	} else {
		self.isRead = NO;
		[sender setTitleNormal:@"已读"];
		
		for (MJKMessageCenterModel *model in self.dataArray) {
			model.selected = NO;
		}
		
		self.isAllChoose = NO;
		self.readChooseView.hidden = YES;
		CGRect rect = self.tableView.frame;
		rect.size.height = rect.size.height + 40;
		self.tableView.frame = rect;
	}
	[self.tableView reloadData];
}

#pragma mark 全选/已读
- (void)allReadAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"全选"]) {
//		if (self.isAllChoose == NO) {
			self.isAllChoose = YES;
//		} else {
//			self.isAllChoose = NO;
//		}
	} else {
		NSMutableArray *arr = [NSMutableArray array];
		for (MJKMessageCenterModel *model in self.dataArray) {
			if (model.isSelected == YES) {
				self.cleanBadge = YES;
//				[arr addObject:model.C_TYPE_DD_ID];
                [arr addObject:model.C_ID];
			}
			model.selected = NO;
		}
		
		[self httpMessageIsRead:arr];
		
		self.isRead = NO;
		self.isAllChoose = NO;
		self.readChooseView.hidden = YES;
		
		UIButton *button = self.navigationItem.rightBarButtonItem.customView;
		[button setTitleNormal:@"已读"];
		
		CGRect rect = self.tableView.frame;
		rect.size.height = rect.size.height + 40;
		self.tableView.frame = rect;
	}
	[self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKMessageCenterModel *model = self.dataArray[indexPath.row];
	MJKMessageCell *cell = [MJKMessageCell cellWithTableView:tableView];
	cell.model = model;
	cell.isRead = self.isRead;
	cell.isAllChoose = self.isAllChoose;
	cell.cleanBadge = self.cleanBadge;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isRead == YES) {
        return;
    }
    MJKMessageDetailModel *model = self.dataArray[indexPath.row];
    [self httpMessageIsRead:@[model.C_ID]];
    
   if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0000"]) {//名单流量处理
        MJKClueDetailViewController *vc = [[MJKClueDetailViewController alloc]init];
        MJKClueListMainSecondModel *clueModel = [[MJKClueListMainSecondModel alloc]init];
        clueModel.C_ID = model.C_OBJECTID;
        vc.clueListMainSecondModel = clueModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0001"]) {//流量处理
        MJKFlowDetailViewController *vc = [[MJKFlowDetailViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0003"]) {//流量仪分配
        MJKFlowMeterDetailViewController *vc = [[MJKFlowMeterDetailViewController alloc]init];
        vc.VCName = @"处理";
        MJKFlowMeterSubSecondModel *flowModel = [[MJKFlowMeterSubSecondModel alloc]init];
        flowModel.C_ID = model.C_OBJECTID;
        flowModel.C_ARRIVAL_DD_ID = @"A46000_C_STATUS_0002";
        vc.model = flowModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0004"]) {//客户消息
        CustomerDetailViewController *vc = [[CustomerDetailViewController alloc]init];
        PotentailCustomerListDetailModel *customerModel = [[PotentailCustomerListDetailModel alloc]init];
        customerModel.C_A41500_C_ID = model.C_OBJECTID;
        vc.mainModel = customerModel;
//        vc.touchButtonIndex = 0;
        [self.navigationController pushViewController:vc animated:YES];
    }  else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0005"] || [model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0006"]) {//预约详情/预约处理
        CGCAppiontDetailVC *vc = [[CGCAppiontDetailVC alloc]init];
        vc.C_ID = model.C_OBJECTID;
        vc.rootVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0007"]) {//订单详情
        OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
        vc.orderId = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0008"]) {//满意度评价
        WXLaunchMiniProgramReq *launchMiniProgramReq = [WXLaunchMiniProgramReq object];
        launchMiniProgramReq.userName = [NewUserSession instance].C_GID;  //拉起的小程序的username
        launchMiniProgramReq.path = [NSString stringWithFormat:@"/pages/evaluateList/evaluateList?objectid=%@",model.C_OBJECTID] ;    //拉起小程序页面的可带参路径，不填默认拉起小程序首页
        launchMiniProgramReq.miniProgramType = WXMiniProgramTypeRelease; //拉起小程序的类型
        [WXApi sendReq:launchMiniProgramReq completion:nil];
    }
    else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0009"]) {//收款退款
        addDealViewController *vc = [[addDealViewController alloc]init];
        vc.vcName = @"收款/退款详情";
        MJKOrderMoneyListModel *moneyModel = [[MJKOrderMoneyListModel alloc]init];
        moneyModel.C_A04200_C_ID = model.C_OBJECTID;
        vc.model = moneyModel;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0010"]) {//任务执行
        ServiceTaskPerformViewController *vc = [[ServiceTaskPerformViewController alloc]init];
        vc.title =  @"任务执行";
        vc.C_ID = model.C_OBJECTID;
        vc.vcName = @"消息中心";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0011"]) {//任务详情
        ServiceTaskTrueDetailViewController *vc = [[ServiceTaskTrueDetailViewController alloc]init];
        vc.title = @"任务详情";
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0012"]) {//考勤
        MJKAttendanceViewController *vc = [[MJKAttendanceViewController alloc]initWithNibName:@"MJKAttendanceViewController" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0013"]) {//工作汇报列表
        MJKWorkWorldViewController *vc = [[MJKWorkWorldViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
//        MJKWorkReportViewController *vc = [[MJKWorkReportViewController alloc]init];
//        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0014"] || [model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0015"]) {//评论列表
        MJKCommentsViewController *vc = [[MJKCommentsViewController alloc]init];
        vc.C_OBJECTID = model.C_OBJECTID;
        vc.typeStr = [model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0014"] ? @"评论" : @"点赞";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0016"]) {//今日代办客户跟进
        PotentailCustomerListViewController*vc=[[PotentailCustomerListViewController alloc]init];
        vc.timerType=customerListTimeTypeToday;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0017"]) {
        CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
        cvc.LASTFOLLOW_TIME_TYPE=@"1";
        cvc.statusStr = @"今日";
        [self.navigationController pushViewController:cvc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0018"]) {
        CGCAppointmentListVC *cvc=[[CGCAppointmentListVC alloc] init];
        cvc.BOOK_TIME_TYPE=@"1";
        cvc.IS_ARRIVE_SHOP=@"1";
        [self.navigationController pushViewController:cvc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0019"]) {
        CGCOrderListVC *cvc=[[CGCOrderListVC alloc] init];
        cvc.startTime=@"1";
        cvc.statusID=@"0";
        [self.navigationController pushViewController:cvc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0020"]) {
        ServiceTaskViewController*vc=[[ServiceTaskViewController alloc]init];
        vc.status = @"3";
        vc.ORDER_TIME = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0021"]) {//工作圈
        MJKSingleDetailViewController *vc = [[MJKSingleDetailViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0023"]) {//ai外呼
        MJKTelephoneRobotProcessViewController *vc = [[MJKTelephoneRobotProcessViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0031"]) {//审批
        MJKApprolViewController *myView=[[MJKApprolViewController alloc]init];
        myView.index = @"1";
        [self.navigationController pushViewController:myView animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0030"]) {//审批申请
        MJKApprolViewController *myView=[[MJKApprolViewController alloc]init];
        myView.index = @"0";
        [self.navigationController pushViewController:myView animated:YES];
    } else  if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0037"]) {//售后信息
        MJKOldCustomerSalesViewController *vc = [[MJKOldCustomerSalesViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0032"]) {//保险信息
        MJKInsuranceViewController *vc = [[MJKInsuranceViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0033"]) {//按揭信息
        MJKMortgageViewController *vc = [[MJKMortgageViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0034"]) {//质保信息
        MJKQualityAssuranceViewController *vc = [[MJKQualityAssuranceViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0035"]) {//上牌信息
        MJKRegistrationViewController *vc = [[MJKRegistrationViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([model.C_TITLE isEqualToString:@"A47500_C_TSPAGE_0036"]) {//精品信息
        MJKHighQualityViewController *vc = [[MJKHighQualityViewController alloc]init];
        vc.C_ID = model.C_OBJECTID;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

#pragma mark - http request list
- (void)httpGetMessageList {
	DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @"1";
    dict[@"pageSize"] = @(self.pageSize);
    dict[@"C_TITLE"] = self.C_TYPE_DD_ID;
    dict[@"C_STATE_DD_ID"] = self.C_STATE_DD_ID;
    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_A617List parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKMessageCenterModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
	
}

- (void)httpMessageIsRead:(NSArray *)typeList {
	DBSelf(weakSelf);
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"C_IDs"] = typeList;
   
    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
    [manager postNewDataFromNetworkNoHudWithUrl:HTTP_A617Read parameters:dict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
//            [JRToast showWithText:data[@"msg"]];
            [weakSelf httpGetMessageList];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
//	NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"A61700WebService-updateStatusByType"];
//	NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//	dic[@"typeList"] = typeList;
//	[mainDic setObject:dic forKey:@"content"];
//
//	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
//
//	HttpManager*manager=[[HttpManager alloc]init];
//	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//		MyLog(@"%@",data);
//		if ([data[@"code"] integerValue]==200) {
//			[JRToast showWithText:data[@"message"]];
//			[weakSelf httpGetMessageList];
//		}else{
//			[JRToast showWithText:data[@"message"]];
//		}
//
//
//	}];
	
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (UIView *)readChooseView {
	if (!_readChooseView) {
		_readChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 40, KScreenWidth, 40)];
		_readChooseView.backgroundColor = KNaviColor;
		_readChooseView.hidden = YES;
		for (int i = 0; i < 2; i++) {
			UIButton *button;
			if (i == 0) {
				button = [[UIButton alloc]initWithFrame:CGRectMake(20, 0, 60, 40)];
			} else {
				button = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 20 - 60, 0, 60, 40)];
				button.titleLabel.textAlignment = NSTextAlignmentRight;
			}
			
			[button setTitleNormal:@[@"全选", @"已读"][i]];
			[button setTitleColor:[UIColor blackColor]];
			button.titleLabel.font = [UIFont systemFontOfSize:14.f];
			[button addTarget:self action:@selector(allReadAction:)];
			[_readChooseView addSubview:button];
		}
		
	}
	return _readChooseView;
}

@end
