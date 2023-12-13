//
//  MJKCheckingViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/25.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKCheckingViewController.h"
#import "MJKDeviationViewController.h"
#import "MJKChooseAddressInMapViewController.h"

#import "LYSDatePickerController.h"

#import "MJKCheckingCell.h"
#import "MJKAddCheckAddressCell.h"
#import "MJKDetailAddressTableViewCell.h"
#import "DateViewWithHourMinute.h"

#import "MJKCheckDetailModel.h"
#import "MJKCheckDetailAddressModel.h"

@interface MJKCheckingViewController ()<UITableViewDataSource, UITableViewDelegate,LYSDatePickerSelectDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 选择的indexPath*/
@property (nonatomic, strong) NSIndexPath *indexPath;
/** 上班时间*/
@property (nonatomic, strong) NSString * inputTime;
/** 下班时间*/
@property (nonatomic, strong) NSString *outputTime;
/** 编辑*/
@property (nonatomic, assign) BOOL isEdit;
/** 米*/
@property (nonatomic, strong) NSString *meterStr;
/** a64900Forms arr*/
@property (nonatomic, strong) NSMutableArray *a64900FormsArr;
/** MJKCheckDetailModel 考勤详情*/
@property (nonatomic, strong) MJKCheckDetailModel *detailModel;
/** delete model*/
@property (nonatomic, strong) MJKCheckDetailAddressModel *deleteModel;
@end

@implementation MJKCheckingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	
    [self initUI];
	[self httpCheckDetail];
}

- (void)initUI {
	self.title = @"考勤规则设置";
//	[self configNaviRightButton];
//	self.isEdit = NO;
	self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.tableView];
}
#pragma mark - 配置右上角item
- (void)configNaviRightButton {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
	[button setTitleNormal:@"编辑"];
	button.titleLabel.font = [UIFont systemFontOfSize:14.f];
	[button setTitleColor:[UIColor blackColor]];
	[button addTarget:self action:@selector(editButtonAction:)];
	
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
	self.navigationItem.rightBarButtonItem = item;
}

#pragma mark 编辑
- (void)editButtonAction:(UIButton *)sender {
	if ([sender.titleLabel.text isEqualToString:@"编辑"]) {
		[sender setTitleNormal:@"保存"];
//		self.isEdit = YES;
	} else {
		if (self.inputTime.length <= 0) {
			[JRToast showWithText:@"请选择上班时间"];
			return;
		}
		if (self.outputTime.length <= 0) {
			[JRToast showWithText:@"请选择下班时间"];
			return;
		}
		if (self.meterStr.length <= 0) {
			[JRToast showWithText:@"请选择考勤范围"];
			return;
		}
		if (self.a64900FormsArr.count <= 0) {
			[JRToast showWithText:@"请选择考勤地址"];
			return;
		}
		
		
		[self httpSaveCheckAddressSuccess:^{
//			[sender setTitleNormal:@"编辑"];
//			self.isEdit = NO;
		}];
	}
	[self.tableView reloadData];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 2;
	} else {
		return 2 + self.detailModel.a64900Forms.count;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.section == 0) {
		MJKCheckingCell *cell = [MJKCheckingCell cellWithTableView:tableView];
		cell.titleLabel.text = @[@"上班时间",@"下班时间"][indexPath.row];
		if (indexPath.row == 0) {
			cell.contentTextField.text = self.inputTime.length > 0 ? self.inputTime : self.detailModel.TOWORK_TIME;
		} else {
			cell.contentTextField.text = self.outputTime.length > 0 ? self.outputTime : self.detailModel.OFFWORK_TIME;
		}
		return cell;
	} else {
		if (indexPath.row ==0 ) {
			MJKCheckingCell *cell = [MJKCheckingCell cellWithTableView:tableView];
			cell.titleLabel.text = @"允许偏差";
			if (self.meterStr) {
				cell.contentTextField.text = self.meterStr;
			} else {
				cell.contentTextField.text = self.detailModel.B_SIGNRANGE;
			}
			return cell;
		} else if (indexPath.row == 1) {
			MJKAddCheckAddressCell *cell = [MJKAddCheckAddressCell cellWithTableView:tableView];
			cell.nameLabel.text = @"添加考勤地点";
			return cell;
		} else {
			MJKCheckDetailAddressModel *addressModel = self.detailModel.a64900Forms[indexPath.row - 2];
//			NSDictionary *dic = self.a64900FormsArr[indexPath.row - 2];
			MJKDetailAddressTableViewCell *cell = [MJKDetailAddressTableViewCell cellWithTableView:tableView];
			cell.indexPath = indexPath;
//			cell.dic = dic;
			cell.addressModel = addressModel;
			cell.deleteAddressBlock = ^{
				[weakSelf alertView:addressModel];
				
//				if (self.isEdit == YES) {
				
				
//					[weakSelf.a64900FormsArr removeObjectAtIndex:indexPath.row - 2];
//					[weakSelf.tableView reloadData];
//				}
			};
			return cell;
		}
	}
}

- (void)alertView:(MJKCheckDetailAddressModel *)addressModel {
	DBSelf(weakSelf);
	UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除考勤地点" preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		weakSelf.deleteModel = addressModel;
		[weakSelf httpSaveCheckAddressSuccess:^{
			[weakSelf httpCheckDetail];
		}];
	}];
	
	UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		
	}];
	
	[alertC addAction:noAction];
	[alertC addAction:yesAction];
	
	[self presentViewController:alertC animated:YES completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
	bgView.backgroundColor = kBackgroundColor;
	UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth, bgView.frame.size.height)];
	if (section == 0) {
		label.text = @"时间信息";
	} else {
		label.text = @"考勤信息";
	}
	label.textColor = [UIColor darkGrayColor];
	label.font = [UIFont systemFontOfSize:14.f];
	[bgView addSubview:label];
	return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
	return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 1 && indexPath.row > 1) {
		
		MJKCheckDetailAddressModel *addressModel = self.detailModel.a64900Forms[indexPath.row - 2];
//		NSDictionary *dic = self.a64900FormsArr[indexPath.row - 2];
		CGSize size = [addressModel.C_NAME boundingRectWithSize:CGSizeMake(KScreenWidth - 35 - 38, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
		if (size.height + 37 + 10 > 44) {
			return size.height + 37 + 10;
		}
	}
	return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.section == 1 && indexPath.row > 1) {
//		NSDictionary *dic = self.a64900FormsArr[indexPath.row - 2];
		
		MJKCheckDetailAddressModel *addressModel = self.detailModel.a64900Forms[indexPath.row - 2];
		MJKChooseAddressInMapViewController *vc = [[MJKChooseAddressInMapViewController alloc]init];
//		vc.haveAddressDic = dic;
		vc.addressModel = addressModel;
		vc.backAddressDicBlock = ^(NSDictionary *dic) {
			[weakSelf.a64900FormsArr addObject:dic];
			//				[weakSelf.tableView reloadData];
			[weakSelf httpSaveCheckAddressSuccess:^{
				[weakSelf httpCheckDetail];
			}];
			
		};
		[self.navigationController pushViewController:vc animated:YES];
	}

//	if (self.isEdit == NO) {
//		return;
//	}
	
	self.indexPath = indexPath;
	if (indexPath.section == 0) {
		[self dateView];
	}
	if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			MJKDeviationViewController *vc = [[MJKDeviationViewController alloc]init];
			vc.backMeterBlock = ^(NSString *meter) {
				weakSelf.meterStr = meter;
				[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
				[weakSelf httpSaveCheckAddressSuccess:nil];
			};
			[self.navigationController pushViewController:vc animated:YES];
		} else if (indexPath.row == 1) {
			MJKChooseAddressInMapViewController *vc = [[MJKChooseAddressInMapViewController alloc]init];
			vc.backAddressDicBlock = ^(NSDictionary *dic) {
				[weakSelf.a64900FormsArr addObject:dic];
//				[weakSelf.tableView reloadData];
				[weakSelf httpSaveCheckAddressSuccess:^{
					[weakSelf httpCheckDetail];
				}];
				
			};
			[self.navigationController pushViewController:vc animated:YES];
		}
	}
	
}

- (void)dateView {
	DBSelf(weakSelf);
//	DateViewWithHourMinute *dateView = [[DateViewWithHourMinute alloc]initWithFrame:CGRectMake(0, KScreenHeight - 150, KScreenWidth, 150)];
//	dateView.delegate = self;
//	[self.view addSubview:dateView];
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm"];
	NSString *currentDate = [dateFormat stringFromDate:[NSDate date]];
	NSString *selectStr;
	if (self.indexPath.section == 0) {
		if (self.indexPath.row == 0) {
			selectStr =[NSString stringWithFormat:@"%@ %@",[currentDate substringToIndex:10],self.detailModel.TOWORK_TIME];
		} else {
			selectStr =[NSString stringWithFormat:@"%@ %@",[currentDate substringToIndex:10],self.detailModel.OFFWORK_TIME];
		}
	}
	
	LYSDatePickerController *datePicker = [[LYSDatePickerController alloc] init];
	datePicker.headerView.backgroundColor = [UIColor whiteColor];;
	datePicker.indicatorHeight = 0;
	datePicker.selectDate = [dateFormat dateFromString:selectStr];
	datePicker.delegate = self;
	datePicker.headerView.centerItem.textColor = [UIColor whiteColor];
	datePicker.headerView.leftItem.textColor = [UIColor whiteColor];
	datePicker.headerView.rightItem.textColor = [UIColor whiteColor];
	datePicker.pickHeaderHeight = 40;
	datePicker.pickType = LYSDatePickerTypeTime;
	datePicker.minuteLoop = YES;
	datePicker.headerView.titleDateFormat = @"HH:mm";
	datePicker.headerView.showTimeLabel = YES;
	datePicker.headerView.leftItem.textColor = [UIColor blackColor];
	datePicker.headerView.rightItem.textColor = [UIColor blackColor];
	datePicker.weakDayType = LYSDatePickerWeakDayTypeUSDefault;
	datePicker.showWeakDay = YES;
	[datePicker setDidSelectDatePicker:^(NSDate *date) {
		NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
		[dateFormat setDateFormat:@"HH:mm"];
		NSString *currentDate = [dateFormat stringFromDate:date];
		[weakSelf selectTimeShowBack:currentDate];
	}];
	[datePicker showDatePickerWithController:self];
	
}



- (void)selectTimeShowBack:(NSString *)timeStr {
	if (self.indexPath.section == 0) {
		if (self.indexPath.row == 0) {
			self.inputTime = timeStr;
		} else {
			self.outputTime = timeStr;
		}
	}
	[self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
	[self httpSaveCheckAddressSuccess:nil];
}

//MARK:-考勤地点详情
- (void)httpCheckDetail {
	DBSelf(weakSelf);
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A64900WebService-detail"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKCheckDetailModel mj_objectWithKeyValues:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//MARK:-保存考勤地点
- (void)httpSaveCheckAddressSuccess:(void(^)(void))completeBlock {
	DBSelf(weakSelf);
	NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A64900WebService-update"];
	NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
	if (self.inputTime.length > 0) {
		contentDict[@"TOWORK_TIME"] = self.inputTime;
	} else {
		contentDict[@"TOWORK_TIME"] = self.detailModel.TOWORK_TIME.length > 0 ? self.detailModel.TOWORK_TIME : @"";
	}
	if (self.outputTime.length > 0) {
		contentDict[@"OFFWORK_TIME"] = self.outputTime;
	} else {
		contentDict[@"OFFWORK_TIME"] = self.detailModel.OFFWORK_TIME.length > 0 ? self.detailModel.OFFWORK_TIME : @"";
	}
	if (self.meterStr.length > 0) {
		contentDict[@"B_SIGNRANGE"] = self.meterStr;
	} else {
		contentDict[@"B_SIGNRANGE"] = self.detailModel.B_SIGNRANGE.length > 0 ? self.detailModel.B_SIGNRANGE : @"";
	}
	if (self.deleteModel != nil) {
//		contentDict[@"I_DELETEFLAG"] = @"1";
		NSMutableArray *arr = [NSMutableArray array];
		
		for (MJKCheckDetailAddressModel *addressModel in self.detailModel.a64900Forms) {//一共的
			NSMutableDictionary *dic = [NSMutableDictionary dictionary];
			dic[@"C_ID"] = addressModel.C_ID;
			dic[@"C_NAME"] = addressModel.C_NAME;
			dic[@"B_SIGNLATITUDE"] = addressModel.B_SIGNLATITUDE;
			dic[@"B_SIGNLONGITUDE"] = addressModel.B_SIGNLONGITUDE;
			if ([addressModel.C_ID isEqualToString:self.deleteModel.C_ID]) {
				dic[@"I_DELETEFLAG"] = @"1";
			}
			[arr addObject:dic];
		}
		
		contentDict[@"a64900Forms"] = arr;
	} else {
		if (self.a64900FormsArr.count > 0) {
			contentDict[@"a64900Forms"] = self.a64900FormsArr;
		} else {
			NSMutableArray *arr = [NSMutableArray array];
			for (MJKCheckDetailAddressModel *addressModel in self.detailModel.a64900Forms) {
				NSMutableDictionary *dic = [NSMutableDictionary dictionary];
				dic[@"C_ID"] = addressModel.C_ID;
				dic[@"C_NAME"] = addressModel.C_NAME;
				dic[@"B_SIGNLATITUDE"] = addressModel.B_SIGNLATITUDE;
				dic[@"B_SIGNLONGITUDE"] = addressModel.B_SIGNLONGITUDE;
				[arr addObject:dic];
			}
			contentDict[@"a64900Forms"] = arr;
		}
	}
	
	
	
	[mtDict setObject:contentDict forKey:@"content"];
	NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			[JRToast showWithText:data[@"message"]];
			weakSelf.deleteModel = nil;
			if (completeBlock) {
				completeBlock();
			}
//			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (NSMutableArray *)a64900FormsArr {
	if (!_a64900FormsArr) {
		_a64900FormsArr = [NSMutableArray array];
	}
	return _a64900FormsArr;
}

@end
