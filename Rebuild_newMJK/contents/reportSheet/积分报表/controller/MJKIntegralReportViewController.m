//
//  MJKIntegralReportViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/24.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKIntegralReportViewController.h"

#import "MJKSourceShowModel.h"

#import "CGCSellModel.h"

#import "MJKIntegralReportCell.h"
#import "DBPickerView.h"

#import "MJKIntegralDetailViewController.h"

@interface MJKIntegralReportViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *screenButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MJKIntegralReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.topLayout.constant = NavStatusHeight;
	self.title = @"积分报表";
    self.timeLabel.text = [DBTools getYearMonthDayTime];
	[self getSourceDatas:[DBTools getYearMonthDayTime]];
	
}
#pragma mark - 筛选按钮
- (IBAction)screenButtonAction:(UIButton *)sender {
	DBSelf(weakSelf);
	DBPickerView *pickView = [[DBPickerView alloc]initWithFrame:self.view.frame andCurrentType:PickViewTypeBirthday andmtArrayDatas:nil andSelectStr:nil andTitleStr:nil andBlock:^(NSString *title, NSString *indexStr) {
		weakSelf.timeLabel.text = title;
		[weakSelf getSourceDatas:title];
	}];
	[[UIApplication sharedApplication].keyWindow addSubview:pickView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKSourceShowModel *model = self.dataArray[indexPath.row];
	MJKIntegralReportCell *cell = [MJKIntegralReportCell cellWithTableView:tableView];
	cell.model = model;
	cell.detailButtonBlock = ^(NSString * _Nonnull str) {
		MJKIntegralDetailViewController *vc = [[MJKIntegralDetailViewController alloc]init];
		CGCSellModel *sellModel = [[CGCSellModel alloc]init];
		
		if ([str isEqualToString:@"month"]) {
			sellModel.CREATE_TIME_TYPE = @"3";
		} else {
			sellModel.CREATE_TIME_TYPE = @"1";
		}
		vc.userID = model.USER_ID;
		vc.sellModel = sellModel;
		[weakSelf.navigationController pushViewController:vc animated:YES];
	};
	return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
	bgView.backgroundColor = [UIColor whiteColor];
	
	for (int i = 0; i < 3; i++) {
		UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(i * ((KScreenWidth - 2) / 3), 0, (KScreenWidth - 2) / 3, 20)];
		label.text = @[@"员工",@"本月积分",@"今日积分"][i];
		label.textColor = [UIColor lightGrayColor];
		label.font = [UIFont systemFontOfSize:14.f];
		[bgView addSubview:label];
		label.textAlignment = NSTextAlignmentCenter;
		
		if (i == 0 || i == 1) {
			UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width, 0, 1, 20)];
			sepView.backgroundColor = kBackgroundColor;
			[bgView addSubview:sepView];
		}
	}
	UIView *bottomSepView = [[UIView alloc]initWithFrame:CGRectMake(0, 19, KScreenWidth, 1)];
	bottomSepView.backgroundColor = kBackgroundColor;
	[bgView addSubview:bottomSepView];
	
	return bgView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

#pragma mark - data request
-(void)getSourceDatas:(NSString *)timeStr {
	DBSelf(weakSelf);
	NSMutableDictionary*mtdict=[DBObjectTools getAddressDicWithAction:@"A48100WebService-getAllIntegral"];
	
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	dict[@"DATE"] = timeStr;
	[mtdict setObject:dict forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtdict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.dataArray = [MJKSourceShowModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
			[weakSelf.tableView reloadData];
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}


@end
