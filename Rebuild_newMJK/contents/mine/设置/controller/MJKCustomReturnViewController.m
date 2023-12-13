//
//  MJKCustomReturnViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKCustomReturnViewController.h"
#import "MJKCustomReturnEditViewController.h"
#import "MJKSettingHeadView.h"

#import "MJKAddFlowTableViewCell.h"
#import "MJKCustomReturnTableViewCell.h"
#import "MJKCustomReturnModel.h"
#import "MJKCustomReturnSubModel.h"
#import "MJOwnerResultsModel.h"

@interface MJKCustomReturnViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *customReturnArray;//客户回访类型(A类...)
@property (nonatomic, strong) MJKSettingHeadView *headView;
@property (nonatomic, strong) MJKCustomReturnModel *customModel;
@property (nonatomic, strong) UILabel *yearMonthLabel;
/** <#备注#>*/
@property (nonatomic, strong) NSArray *seaArrayList;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *statusListArr;

@end

@implementation MJKCustomReturnViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([self.title isEqualToString:@"客户跟进等级设置"]) {
		[self HTTPGetCustomDatas];
	} else if ([self.title isEqualToString:@"个人业绩目标设置"]) {
		[self HTTPGetPerformanceDatas];
	} else if ( [self.title isEqualToString:@"订单关怀周期设置"]) {
		[self HTTPGetOrderDatas];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initUI];
}

- (void)initUI {
	self.headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
	[self.view addSubview:self.headView];
	if ([self.title isEqualToString:@"客户跟进等级设置"] || [self.title isEqualToString:@"个人业绩目标设置"] || [self.title isEqualToString:@"订单关怀周期设置"]) {
		UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
		[button setTitle:@"编辑" forState:UIControlStateNormal];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		[button addTarget:self action:@selector(clickEidtButton:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
//        if ([self.title isEqualToString:@"客户跟进等级设置"]) {
//            if ([[NewUserSession instance].appcode containsObject:@"A41100_0001"]) {
//                self.navigationItem.rightBarButtonItem = barButton;
//            }
//        } else {
//             self.navigationItem.rightBarButtonItem = barButton;
//        }
		
		
		if ([self.title isEqualToString:@"订单关怀周期设置"]) {
			self.headView.headTitleArray = @[@"订单状态", @"间隔时间"];
		} else {
			self.headView.headTitleArray = [self.title isEqualToString:@"客户跟进等级设置"] ? @[@"客户等级", @"间隔时间"] : @[];
		}
		
	} else if ([self.title isEqualToString:@"员工名单分配设置"]) {
		self.headView.headTitleArray = @[@"员工", @"操作"];
		[self HTTPGetFlowDatas];
		
	}
	
	
	[self.view addSubview:self.tableView];
	if ([self.title isEqualToString:@"个人业绩目标设置"]) {
		[self initPanGR];
		[self getSeaSetList];
	}
}

- (void)initPanGR {
	UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
	leftSwipeGR.delegate = self;
	leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
	[self.view addGestureRecognizer:leftSwipeGR];
	UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
	rightSwipeGR.delegate = self;
	rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
	[self.view addGestureRecognizer:rightSwipeGR];
	
	UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(80, NavStatusHeight, KScreenWidth - 160, 30)];
//	bgView.backgroundColor = [UIColor grayColor];
	[self.view addSubview:bgView];
	
	
	UILabel *yearMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake((bgView.frame.size.width-100) / 2, 0, 100, 30)];
//	yearMonthLabel.backgroundColor = [UIColor redColor];
	self.yearMonthLabel = yearMonthLabel;
	yearMonthLabel.tag = 2018;
	[bgView addSubview:yearMonthLabel];
	yearMonthLabel.text = [self nowYearMonth];
	yearMonthLabel.font = [UIFont systemFontOfSize:14.f];
	yearMonthLabel.textAlignment = NSTextAlignmentCenter;
	yearMonthLabel.textColor = DBColor(142, 142, 142);
	
	UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(yearMonthLabel.frame) - 20, 0, 20, 30)];
	UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yearMonthLabel.frame), 0, 20, 30)];
	[leftButton setTitle:@"<" forState:UIControlStateNormal];
	[leftButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
	[rightButton setTitle:@">" forState:UIControlStateNormal];
	[rightButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
	[bgView addSubview:leftButton];
	[bgView addSubview:rightButton];
	[leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	[rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	
}

- (void)buttonClick:(UIButton *)sender {
	NSString *yearMonth = self.yearMonthLabel.text;
	NSString *year = [yearMonth substringToIndex:4];
	NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
	if ([sender.titleLabel.text isEqualToString:@"<"]) {
		month = [NSString stringWithFormat:@"%02d",month.intValue-1];
		if (month.intValue < 1) {
			month = @"12";
			year = [NSString stringWithFormat:@"%d",year.intValue-1];
		}
	} else {
		month = [NSString stringWithFormat:@"%02ld",month.intValue+1];
		if (month.intValue > 12) {
			month = @"01";
			year = [NSString stringWithFormat:@"%d",year.intValue+1];
		}
	}
	self.yearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
	[self HTTPGetPerformanceDatas];
	
	NSString *nowYearMonth = [self nowYearMonth];
	NSString *nowYear = [nowYearMonth substringToIndex:4];
	NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
	if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
		self.navigationItem.rightBarButtonItem.customView.hidden = YES;
	} else {
		self.navigationItem.rightBarButtonItem.customView.hidden = NO;
	}
}

- (void)changeData:(UISwipeGestureRecognizer *)swipe {
	NSString *yearMonth = self.yearMonthLabel.text;
	NSString *year = [yearMonth substringToIndex:4];
	NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
	if (swipe.direction ==  UISwipeGestureRecognizerDirectionLeft) {
		month = [NSString stringWithFormat:@"%02ld",month.intValue+1];
		if (month.intValue > 12) {
			month = @"01";
			year = [NSString stringWithFormat:@"%d",year.intValue+1];
		}
		
		NSLog(@"右 %@   %@", year,month );
	} else if (swipe.direction ==  UISwipeGestureRecognizerDirectionRight) {
		month = [NSString stringWithFormat:@"%02d",month.intValue-1];
		if (month.intValue < 1) {
			month = @"12";
			year = [NSString stringWithFormat:@"%d",year.intValue-1];
		}
		NSLog(@"左 %@   %@", year,month);
	}
	self.yearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
	[self HTTPGetPerformanceDatas];
	
	NSString *nowYearMonth = [self nowYearMonth];
	NSString *nowYear = [nowYearMonth substringToIndex:4];
	NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
	if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
		self.navigationItem.rightBarButtonItem.customView.hidden = YES;
	} else {
		self.navigationItem.rightBarButtonItem.customView.hidden = NO;
	}
	
	
}

- (NSString *)nowYearMonth {
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateFormatter.dateFormat = @"yyyy年MM月";
	return [dateFormatter stringFromDate:date];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
	// 点击的view的类名
//	NSLog(@"%@", NSStringFromClass([touch.view class]));
	// 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
//	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//		return NO;
//	}
	NSLog(@"%@",NSStringFromClass([touch.view class]));
	return  YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([self.title isEqualToString:@"客户跟进等级设置"]) {
		return self.customModel.content.count;
	} else if ([self.title isEqualToString:@"员工名单分配设置"]) {
		return self.customModel.content.count;
	} else if([self.title isEqualToString:@"订单关怀周期设置"]) {
		return self.customModel.content.count;
	}
	else {
		return 8;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
	if ([self.title isEqualToString:@"客户跟进等级设置"]) {
		MJKCustomReturnSubModel *model = self.customModel.content[indexPath.row];
		MJKAddFlowTableViewCell *cell = [MJKAddFlowTableViewCell cellWithTableView:tableView];
		[cell updateCustomCell:model.C_NAME andDays:model.I_NUMBER andDetail:YES];
		return cell;
	} else if ([self.title isEqualToString:@"员工名单分配设置"]) {
		MJKCustomReturnSubModel *model = self.customModel.content[indexPath.row];
		MJKCustomReturnTableViewCell *cell = [MJKCustomReturnTableViewCell cellWithTableView:tableView];
		cell.model = model;
		[cell updataCell:model.C_NAME];
		DBSelf(weakSelf);
		[cell setBackSelectBlock:^(NSString *c_id, NSString *selectBool){
			[weakSelf HTTPUpdateFlowDatas:c_id andSelect:selectBool];
		}];
		return cell;
	} else if ([self.title isEqualToString:@"订单关怀周期设置"]) {
		MJKCustomReturnSubModel *model = self.customModel.content[indexPath.row];
		MJKAddFlowTableViewCell *cell = [MJKAddFlowTableViewCell cellWithTableView:tableView];
		[cell updateCustomCell:model.C_NAME andDays:model.I_NUMBER andDetail:YES];
		return cell;
	}
	else {
        
        MJOwnerResultsModel *model = self.statusListArr[indexPath.row];
		MJKCustomReturnTableViewCell *cell = [MJKCustomReturnTableViewCell cellWithTableView:tableView];
        [cell updataNumberCell:self.customModel andTitleArray:@[@"回款金额的目标量", @"预估金额的目标量",@"订单新增的目标量",@"订单完工的目标量", @"客户新增的目标量",@"客户跟进的目标量",@"名单流量的目标量",@"预约到店的目标量"] andDetail:YES andRow:indexPath.row andStatusArray:self.statusListArr];
//        cell.openSwitchButton.enabled = [self isEdit];
        cell.openSwitchButton.tag = indexPath.row;
        cell.numLabel.hidden = model.COUNT.doubleValue <= 0.0 ? YES : NO;
		cell.openSwitchBlock = ^(BOOL isOn) {
            
			if (isOn == YES) {
                model.STATUS = @"1";
                if ([self isEdit] == YES && model.COUNT.doubleValue <= 0.0) {
                    [weakSelf alertvView:indexPath.row];
                } else {
                    [weakSelf updateDatasWithArray:model andCompleteBlock:^{
                        [weakSelf HTTPGetPerformanceDatas];
                    }];
                }
			} else {
                model.STATUS = @"0";
                [weakSelf updateDatasWithArray:model andCompleteBlock:^{
                    [weakSelf HTTPGetPerformanceDatas];
                }];
			}
		};
		return cell;
	}
	
	
}

- (void)alertvView:(NSInteger)tag {
    DBSelf(weakSelf);
    MJOwnerResultsModel *model = self.statusListArr[tag];
    MJKCustomReturnTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当月只能填写一次,请谨慎输入数量" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入目标量";
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (model.COUNT.doubleValue > 0.0) {
            textField.text = model.COUNT;
        }
        
    }];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * arr = alertC.textFields;
        UITextField * field = arr[0];
        model.COUNT = field.text;
        [weakSelf updateDatasWithArray:model andCompleteBlock:^{
            [weakSelf HTTPGetPerformanceDatas];
        }];
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        model.STATUS = @"0";
        cell.openSwitchButton.on = NO;
    }];
    
    [alertC addAction:determineAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (BOOL)isEdit {
    NSString *yearMonth = self.yearMonthLabel.text;
    NSString *year = [yearMonth substringToIndex:4];
    NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
    
    NSString *nowYearMonth = [self nowYearMonth];
    NSString *nowYear = [nowYearMonth substringToIndex:4];
    NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
    if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
        return NO;
    } else {
        return YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

#pragma mark - 点击事件
- (void)clickEidtButton:(UIButton *)sender {
	MJKCustomReturnEditViewController *addVC = [[MJKCustomReturnEditViewController alloc]init];
	addVC.model = self.customModel;
	addVC.title = self.title;
	[self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - HTTP request
- (void)HTTPGetCustomDatas {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.customModel = [MJKCustomReturnModel yy_modelWithDictionary:data[@"data"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPGetFlowDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getUserListToReceive];
	[dict setObject:@{} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			self.customModel = [MJKCustomReturnModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPGetPerformanceDatas {
	NSDate *date = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
	dateFormatter.dateFormat = @"yyyy-MM";
	NSString *dateStr = [dateFormatter stringFromDate:date];
	NSString *year = [self.yearMonthLabel.text substringToIndex:4];
	NSString *month = [self.yearMonthLabel.text substringWithRange:NSMakeRange(5, 2)];
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getCountAmount];
	[dict setObject:@{@"C_YEAR" : year, @"C_MONTH" : month} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.customModel = [MJKCustomReturnModel yy_modelWithDictionary:data];
            weakSelf.statusListArr = [MJOwnerResultsModel mj_objectArrayWithKeyValuesArray:data[@"list"]];
			[weakSelf.tableView reloadData];
//            if ([dateStr substringToIndex:4].intValue == year.intValue && [dateStr substringWithRange:NSMakeRange(5, 2)].intValue == month.intValue) {
//                if (weakSelf.customModel.B_SJHKMB.floatValue > 0 || weakSelf.customModel.B_YGJEMB.floatValue > 0  || weakSelf.customModel.I_A41300_CLUENUMBER.floatValue > 0  || weakSelf.customModel.I_A41500_NUMBER.floatValue > 0  || weakSelf.customModel.I_A41600_NUMBER.floatValue > 0 || weakSelf.customModel.I_A41600_YUYUENUMBER.floatValue > 0  || weakSelf.customModel.I_A42000INSERT_NUMBER.floatValue > 0  || weakSelf.customModel.I_A42000_NUMBER.floatValue > 0) {
//                    weakSelf.navigationItem.rightBarButtonItem.customView.hidden = YES;
//                } else {
//                    weakSelf.navigationItem.rightBarButtonItem.customView.hidden = NO;
//                }
//            }
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

-(void)updateDatasWithArray:(MJOwnerResultsModel *)model andCompleteBlock:(void(^)(void))completeBlock {
    //    DBSelf(weakSelf);
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A43500WebService-update"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = model.ID;
    contentDic[@"NAME"] = model.NAME;
    contentDic[@"STATUS"] = model.STATUS;
    contentDic[@"COUNT"] = model.COUNT;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
}

- (void)HTTPGetOrderDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:@{@"TYPE" : @"0"} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.customModel = [MJKCustomReturnModel yy_modelWithDictionary:data[@"data"]];
//
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)HTTPUpdateFlowDatas:(NSString *)c_id andSelect:(NSString *)str {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updateToReceive];
	[dict setObject:@{@"I_RECEIVE" : str, @"C_ID" : c_id} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf HTTPGetFlowDatas];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

-(void)getSeaSetList {
	
	NSMutableDictionary *dic=[NSMutableDictionary new];
	dic[@"TYPE"] = @"1";
	
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	DBSelf(weakSelf);
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
		if ([data[@"code"] integerValue]==200) {
			weakSelf.seaArrayList = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
			[weakSelf.tableView reloadData];
		}else{
			
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.headView.frame.size.height, KScreenWidth, KScreenHeight - 64-30 ) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}


@end
