//
//  MJKIntegralDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/27.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKIntegralDetailViewController.h"

#import "MJKPKSheetModel.h"
#import "MJKJFDetailModel.h"
#import "CGCSellModel.h"
#import "MJKClueListSubModel.h"

#import "CFDropDownMenuView.h"
#import "MJKJFDetailCell.h"
#import "CGCCustomDateView.h"

@interface MJKIntegralDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
/** data array*/
@property (nonatomic, strong) NSArray *jfDataArray;
@property (nonatomic,strong) NSMutableArray *sellArray;
/** CFDropDownMenuView*menuView*/
@property (nonatomic, strong) CFDropDownMenuView *menuView;

@end

@implementation MJKIntegralDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"积分明细列表";
    self.view.backgroundColor = [UIColor whiteColor];
	if (self.sellModel == nil) {
		self.sellModel = [[CGCSellModel alloc]init];
	}
	[self httpRequest];
	[self initUI];
}

- (void)initUI {
}

- (void)httpRequest {
	DBSelf(weakSelf);
	[self HTTPGetSellList:^{
		[weakSelf chooseView];
		[self.view addSubview:self.tableView];
		[weakSelf getJFDatas];
	}];
}

- (void)chooseView{
	
	CFDropDownMenuView*menuView=[[CFDropDownMenuView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 40)];
	menuView.VCName = @"订单管理";
	NSMutableArray * arr=[NSMutableArray arrayWithArray:@[@"全部",@"我的"]];
	if (self.sellArray.count>1) {
		for (CGCSellModel* model in self.sellArray) {
			NSString * str= model.nickName.length>0?model.nickName:@" ";
			[arr addObject:str];
			
		}
	}
	/*
     timeStr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"近7天",@"今年",@"去年",@"最近30天",@"自定义"];
     timeKeyStr=@[@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"9",@"10",@"30",@"999"];
     */
    NSArray * timeStrArr=@[@"全部",@"今天",@"本周",@"本月",@"昨天",@"上周",@"上月",@"今年",@"去年",@"最近7天",@"最近30天",@"自定义"];
    NSArray * sidArr=@[@"", @"1", @"2", @"3", @"4", @"5", @"6", @"9", @"10", @"7",@"30",@"100"];
	menuView.dataSourceArr=[@[ arr,
							   timeStrArr,
							   ] mutableCopy];
//    NSString *timeTitle = @"时间";
//    for (int i = 0; i < sidArr.count; i++) {
//        if ([self.CREATE_TIME_TYPE isEqualToString:sidArr[i]]) {
//            timeTitle = timeStrArr[i];
//        }
//    }
	menuView.defaulTitleArray=@[@"员工",@"本月"];
    menuView.VCName = @"积分明细";
	
	menuView.startY=CGRectGetMaxY(menuView.frame);
	self.menuView=menuView;
	[self.view addSubview:self.menuView];
	
	
	
	
	
#pragma   各种筛选的点击事件
	DBSelf(weakSelf);
	self.menuView.chooseConditionBlock = ^(NSString *selectedSection, NSString *selectedRow, NSString *title) {
		NSLog(@"%@---%@--%@",selectedSection,selectedRow,title);
		
		
		switch ([selectedSection intValue]) {
			case 0://销售
				if ([title isEqualToString:@"全部"]) {
//					weakSelf.sellModel.USER_ID=@"";
					weakSelf.userID = @"";
				}
				if ([title isEqualToString:@"我的"]) {
//					weakSelf.sellModel.USER_ID=[NewUserSession instance].user.u051Id;
					weakSelf.userID = [NewUserSession instance].user.u051Id;
				}
				if (weakSelf.sellArray.count>1) {
					for (CGCSellModel* model in weakSelf.sellArray) {
						NSString * str= model.nickName.length>0?model.nickName:@" ";
						if ([str isEqualToString:title]) {
//							weakSelf.sellModel.USER_ID=model.C_ID;
							weakSelf.userID = model.u051Id;
						}
						
					}
				}
				[weakSelf getJFDatas];
				break;
			case 1://创建时间
				if ([title isEqualToString:@"全部"]) {
					weakSelf.sellModel.START_TIME=@"";
					weakSelf.sellModel.END_TIME=@"";
					weakSelf.sellModel.CREATE_TIME_TYPE=@"";
				}
				if ([title isEqualToString:@"自定义"]) {
					
					CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:weakSelf.view.bounds withStart:^{
						
					} withEnd:^{
						
					} withSure:^(NSString *start, NSString *end) {
						weakSelf.sellModel.START_TIME=start;
						weakSelf.sellModel.END_TIME=end;
						weakSelf.sellModel.CREATE_TIME_TYPE=@"";
						[weakSelf getJFDatas];
						
					}];
					[weakSelf.view addSubview:dateView];
					break;
				}
				
				weakSelf.sellModel.START_TIME=@"";
				weakSelf.sellModel.END_TIME=@"";
				weakSelf.sellModel.CREATE_TIME_TYPE=sidArr[[selectedRow intValue]];
				[weakSelf getJFDatas];
				break;
			default:
				break;
		}
		
		
	};
	
	
	
	
}

//MARK:-UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.jfDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKJFDetailModel *model = self.jfDataArray[indexPath.row];
	MJKJFDetailCell *cell = [MJKJFDetailCell cellWithTableView:tableView];
	cell.jfDetailModel = model;
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKJFDetailModel *model = self.jfDataArray[indexPath.row];
    return model.personalDetails.count / 4 * 60;
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 125;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

//MARK:-jf data
-(void)getJFDatas{
	DBSelf(weakSelf);
	NSMutableDictionary*mtdict=[DBObjectTools getAddressDicWithAction:@"A48000WebService-getAllList"];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"CREATE_TIME_TYPE"] = self.sellModel.CREATE_TIME_TYPE.length > 0 ? self.sellModel.CREATE_TIME_TYPE : @"3";
	
	if (self.sellModel.START_TIME.length > 0) {
		dict[@"CREATE_START_TIME"] = self.sellModel.START_TIME;
		dict[@"CREATE_END_TIME"] = self.sellModel.END_TIME;
	}
	
	dict[@"USER_ID"] = self.userID;
	dict[@"C_A48100_C_ID"] = self.pkModel.C_ID;
	
	[mtdict setObject:dict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtdict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.jfDataArray = [MJKJFDetailModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//MARK: --- 获取客户列表 -- request
- (void)HTTPGetSellList:(void(^)(void))successBlock {
	
	
	HttpManager*manager=[[HttpManager alloc]init];
	
    
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			NSDictionary*dict=[data copy];
			for (NSDictionary * div in dict[@"data"]) {
				
//				MJKClueListSubModel*subModel = [MJKClueListSubModel yy_modelWithDictionary:div];
				CGCSellModel * model=[CGCSellModel yy_modelWithDictionary:div];
//				CGCSellModel * model=[[CGCSellModel alloc]init];
//				model.C_ID = subModel.user_id;
//				model.C_NAME = subModel.user_name;
//				model.C_HEADPIC = subModel.C_HEADPIC;
				[self.sellArray addObject:model];
				
			}
			if (successBlock) {
				successBlock();
			}
		}else{
			
			[JRToast showWithText:data[@"message"]];
		}
		
		[self chooseView];
	}];
	
	
	
}

//MARK:-SET
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.menuView.frame), KScreenWidth, KScreenHeight - self.menuView.frame.size.height - self.menuView.frame.origin.y) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (NSMutableArray *)sellArray{
	
	if (_sellArray==nil) {
		_sellArray=[NSMutableArray array];
	}
	return _sellArray;
	
}


@end
