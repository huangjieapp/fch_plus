//
//  MJKCustomReturnEditViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKCustomReturnEditViewController.h"

#import "MJKAddFlowTableViewCell.h"
#import "MJKSettingHeadView.h"
#import "MJKCustomReturnTableViewCell.h"
#import "MJKAddOrderFlowTableViewCell.h"

#import "MJKCustomReturnSubModel.h"

#import "CGCAlertDateView.h"


@interface MJKCustomReturnEditViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKSettingHeadView *headView;
@property (nonatomic, strong) NSMutableArray *customArray;

@end

@implementation MJKCustomReturnEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	[self initUI];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)initUI {
	self.headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
	[self.view addSubview:self.headView];
	if ([self.title isEqualToString:@"订单关怀周期设置"]) {
		self.headView.headTitleArray = @[@"订单状态", @"间隔天数"];
    } else if ([self.title isEqualToString:@"粉丝互动周期设置"]) {
        self.headView.headTitleArray = @[@"粉丝等级", @"间隔天数"];
    }
    else {
		self.headView.headTitleArray = [self.title isEqualToString:@"潜客跟进周期设置"] ? @[@"客户等级", @"间隔天数"] : @[@"业务", @"目标量"];
	}
	
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
	[button setTitle:@"完成" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[button addTarget:self action:@selector(clickCompleteButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
	self.navigationItem.rightBarButtonItem = barButton;
	
	[self.view addSubview:self.tableView];
	
	if ([self.title isEqualToString:@"潜客跟进周期设置"] || [self.title isEqualToString:@"订单关怀周期设置"] || [self.title isEqualToString:@"粉丝互动周期设置"]) {
		if ([self.title isEqualToString:@"潜客跟进周期设置"]) {
			[self HTTPGetCustomDatas];
		} else if ([self.title isEqualToString:@"订单关怀周期设置"]) {
			[self HTTPGetOrderDatas];
        } else {
            [self HTTPGetMembersDatas];
        }
		self.navigationItem.rightBarButtonItem.customView.hidden = YES;
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"btn-返回" highImage:@"btn-返回" isLeft:YES target:self andAction:@selector(backVC)];
	}
}

#pragma mark 返回
- (void)backVC {
	if ([self.title isEqualToString:@"潜客跟进周期设置"]) {
		[self HTTPUpdateLevelDatas];
	} else if ([self.title isEqualToString:@"订单关怀周期设置"] || [self.title isEqualToString:@"粉丝互动周期设置"]) {
		[self HTTPUpdateOrderDatas];
    } else {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
	
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.title isEqualToString:@"潜客跟进周期设置"] || [self.title isEqualToString:@"订单关怀周期设置"] || [self.title isEqualToString:@"粉丝互动周期设置"] ? self.model.content.count : 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
    if ([self.title isEqualToString:@"订单关怀周期设置"]) {
        MJKCustomReturnSubModel *subModel = self.model.content[indexPath.row];
        MJKAddOrderFlowTableViewCell *cell = [MJKAddOrderFlowTableViewCell cellWithTableView:tableView];
        [cell updateCustomCell:subModel.C_NAME andDays:subModel.I_NUMBER andDetail:NO];
        
        [cell setBackTextBlock:^(NSString *str){
            [weakSelf.customArray addObject:@{@"I_NUMBER" : str, @"C_ID" : subModel.C_ID}];
        }];
        return cell;
    } else if ([self.title isEqualToString:@"潜客跟进周期设置"] || [self.title isEqualToString:@"粉丝互动周期设置"]) {
		MJKCustomReturnSubModel *subModel = self.model.content[indexPath.row];
		MJKAddFlowTableViewCell *cell = [MJKAddFlowTableViewCell cellWithTableView:tableView];
		[cell updateCustomCell:subModel.C_NAME andDays:subModel.I_NUMBER andDetail:NO];
		
		[cell setBackTextBlock:^(NSString *str){
			[weakSelf.customArray addObject:@{@"I_NUMBER" : str, @"C_ID" : subModel.C_ID}];
		}];
		return cell;
	} else {
		MJKCustomReturnTableViewCell *cell = [MJKCustomReturnTableViewCell cellWithTableView:tableView];
//        cell.numberTextField.tag = indexPath.row + 10;
        cell.textFieldEdit = ^(UITextField *textField) {
            if (textField.tag - 400  < 4) {
                self.tableView.frame=CGRectMake(0, -80,self.tableView.frame.size.width,self.tableView.frame.size.height);
            }
            
        };
        cell.textFieldEndEdit = ^(UITextField *textField) {
            if (textField.tag-400 < 4) {
                self.tableView.frame=CGRectMake(0, NavStatusHeight + self.headView.frame.size.height,self.tableView.frame.size.width,self.tableView.frame.size.height);
            }
            
        };
		[cell updataNumberCell:self.model andTitleArray:@[@"名单新增",@"客户新增",@"邀约到店",@"客户跟进",@"订单新增",@"预估金额",@"回款金额",@"订单完工"] andDetail:NO andRow:indexPath.row andStatusArray:nil];
		//@[4@"订单新增"0,7@"订单交付"1,5@"预估金额"2,6@"回款金额"3,2@"客户新增"4,3@"客户跟进"5,0@"线索新增"6,1@"邀约到店"7]
		[cell setBackTextBlock:^(NSString *str, NSInteger row){
			switch (row) {
				case 0:
                    weakSelf.model.I_A41300_CLUENUMBER = str;
					break;
				case 1:
					weakSelf.model.I_A41500_NUMBER = str;
					break;
				case 2:
					weakSelf.model.I_A41600_YUYUENUMBER = str;
					break;
				case 3:
                    weakSelf.model.I_A41600_NUMBER = str;
					break;
				case 4:
                    weakSelf.model.I_A42000INSERT_NUMBER = str;
					break;
				case 5:
                    weakSelf.model.B_YGJEMB = str;
					break;
				case 6:
                    weakSelf.model.B_SJHKMB = str;
					break;
				case 7:
                    weakSelf.model.I_A42000_NUMBER = str;
					break;
				default:
					break;
			}
		}];
		return cell;
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

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [self.view endEditing:YES];
//}

//-(void)KeyboardShow:(NSNotification*)notif{
//    NSDictionary*userInfo=notif.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//
//    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
//    CGFloat keyStartY=[userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
//
//    //-260
//    CGFloat delaty=keyEndY-keyStartY;
//
//
//    [UIView animateWithDuration:duration animations:^{
//        self.tableView.frame=CGRectMake(0, self.tableView.frame.origin.y+delaty,self.tableView.frame.size.width,self.tableView.frame.size.height);
//
//
//    }];
//
//
//}
//
//-(void)keyBoardHidden:(NSNotification*)notif{
//    NSDictionary*userInfo=notif.userInfo;
//    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
//
//    CGFloat keyEndY = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
//    CGFloat keyStartY=[userInfo[@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue].origin.y;
//
//    //260
//    CGFloat delaty=keyEndY-keyStartY;
//
//
//    [UIView animateWithDuration:duration animations:^{
//        self.tableView.frame=CGRectMake(0, NavStatusHeight + self.headView.frame.size.height,self.tableView.frame.size.width,self.tableView.frame.size.height);
//
//
//    }];
//
//
//
//}


#pragma mark - 点击事件
- (void)clickCompleteButton:(UIButton *)sender {
	if ([self.title isEqualToString:@"潜客跟进周期设置"]) {
		[self HTTPUpdateLevelDatas];
	} else if ([self.title isEqualToString:@"订单关怀周期设置"]) {
		[self HTTPUpdateOrderDatas];
	} else {
		
		[self HTTPUpdateAmountDatas];
	}
}

#pragma mark - HTTP request
- (void)HTTPUpdateOrderDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : self.customArray} compliation:^(id data, NSError *error) {
	
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)HTTPUpdateLevelDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updateLevel];
	[dict setObject:@{@"array" : self.customArray} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPUpdateAmountDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updateCountAmount];
	[dict setObject:@{@"C_ID" : self.model.C_ID, @"I_A41500_NUMBER" : self.model.I_A41500_NUMBER, @"I_A41600_NUMBER" : self.model.I_A41600_NUMBER, @"I_A42000_NUMBER" : self.model.I_A42000_NUMBER, @"I_A41600_YUYUENUMBER" : self.model.I_A41600_YUYUENUMBER, @"I_A41300_CLUENUMBER" : self.model.I_A41300_CLUENUMBER, @"B_YGJEMB" : self.model.B_YGJEMB, @"B_SJHKMB" : self.model.B_SJHKMB, @"I_A42000INSERT_NUMBER" : self.model.I_A42000INSERT_NUMBER} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPGetCustomDatas {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a411/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.model = [MJKCustomReturnModel yy_modelWithDictionary:data[@"data"]];
			[weakSelf.tableView reloadData];
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
			weakSelf.model = [MJKCustomReturnModel yy_modelWithDictionary:data[@"data"]];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)HTTPGetMembersDatas {
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:@{@"TYPE" : @"14"} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.model = [MJKCustomReturnModel yy_modelWithDictionary:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.headView.frame.size.height, KScreenWidth, KScreenHeight - 50) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

- (NSMutableArray *)customArray {
	if (!_customArray) {
		_customArray = [NSMutableArray array];
	}
	return _customArray;
}

@end
