//
//  MJKMarketSettingDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKPhoneSetViewController.h"
#import "MJKMarketSettingEditViewController.h"

#import "MJKMarketSettingTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"
#import "MJKFlowDetailTableViewCell.h"
#import "MJKAddFlowSubTableViewCell.h"
#import "MJKMarketPickerView.h"

#import "MJKPhoneSetListModel.h"
#import "MJKFlowMainSaleModel.h"
#import "MJKFlowSalesModel.h"
#import "MJKFunnelChooseModel.h"
#import "MJKClueListViewModel.h"

@interface MJKPhoneSetViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *topTableView;
@property (nonatomic, strong) UITableView *bottomTableView;
@property (nonatomic, strong) MJKPhoneSetListModel *detailModel;
@property (nonatomic, strong) MJKClueListViewModel *saleListModel;
@property (nonatomic, assign) BOOL isEdit;//是否编辑
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *sureButton;
@property (nonatomic, strong) UIButton *delButton;
@property (nonatomic, strong) NSMutableArray*salesArray;
@property (nonatomic, strong) MJKMarketPickerView *pickerView;
@end

@implementation MJKPhoneSetViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([self.titleStr isEqualToString:@"电话分配设置"]) {
		[self HTTPGetSalesListDatas];
	} else {
		[self HTTPGetMarkDatas];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self initUI];
	
}

- (void)initUI {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
	self.editButton = button;
	[button setTitle:@"修改" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[button addTarget:self action:@selector(clickEidtButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
	self.navigationItem.rightBarButtonItem = barButton;
	
	if ([self.titleStr isEqualToString:@"电话分配设置"]) {
		button.hidden = YES;
		self.detailModel = [[MJKPhoneSetListModel alloc]init];
		CGRect frame = self.bottomTableView.frame;
		frame.size.height = self.bottomTableView.frame.size.height - 50;
		self.bottomTableView.frame = frame;
		CGRect topFrame = self.topTableView.frame;
		topFrame.origin.y = self.topTableView.frame.origin.y + 64;
		self.topTableView.frame = topFrame;
		self.sureButton.frame = CGRectMake(15, KScreenHeight - 45, KScreenWidth - 30, 40);
		[self.view addSubview:self.sureButton];
	}
	
	[self.view addSubview:self.topTableView];
	[self.view addSubview:self.bottomTableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (tableView == self.topTableView) {
		return 3;
	} else {
		if (self.isEdit == YES || [self.titleStr isEqualToString:@"电话分配设置"]) {
			
			return self.saleListModel.data.count;
		} else {
			return self.detailModel.content.count;
		}
	}
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (tableView == self.topTableView) {
		MJKFlowDetailTableViewCell *cell = [MJKFlowDetailTableViewCell cellWithTableView:tableView];
		if (indexPath.row == 2) {
			[cell updatePhoneCell:@"选择对应员工" andContent:@""];
		} else {
			if ([self.titleStr isEqualToString:@"电话分配设置"]) {
				[cell addPhoneCell:@[@"投放来源",@"话机号码"] andRow:indexPath.row];
				if (self.detailModel.C_A41200_C_NAME.length > 0) {
					cell.contentLabel.text = self.detailModel.C_A41200_C_NAME;
				}
				[cell setBackTextBlock:^(NSString *str){
					weakSelf.detailModel.C_INTERNAL = str;
				}];
				
			} else {
				if (self.detailModel != nil) {
					[cell updatePhoneCell:@[@"投放来源",@"话机号码"][indexPath.row] andContent:@[self.detailModel.C_A41200_C_NAME, self.detailModel.C_INTERNAL][indexPath.row]];
					if (self.isEdit == YES) {
						if (indexPath.row) {
							cell.phoneNumber.hidden = NO;
							cell.phoneNumber.text = self.detailModel.C_INTERNAL;
							cell.contentLabel.hidden = YES;
							[cell setBackTextBlock:^(NSString *str){
								weakSelf.detailModel.C_INTERNAL = str;
							}];
						}
					}
				}
			}
		}
		
		return cell;
        
	} else {
		
		MJKAddFlowSubTableViewCell *cell = [MJKAddFlowSubTableViewCell cellWithTableView:tableView];
		
		if ([self.titleStr isEqualToString:@"电话分配设置"]) {
			MJKFlowSalesModel *saleSubModel = self.saleListModel.data[indexPath.row];
			
			[cell updateEditPhoneCell:saleSubModel];
		} else {
			if (self.isEdit) {
				MJKFlowSalesModel *saleSubModel = self.saleListModel.data[indexPath.row];
				
				[cell updateEditPhoneCell:saleSubModel];
				//			[cell setBackFlowShopBlock:^(NSString *str){
				//				[weakSelf.salesArray removeAllObjects];
				//
				//
				//			}];
			} else {
                //总共4个model  怎么会取到9
				MJKPhoneSetListSubModel *subModel = self.detailModel.content[indexPath.row];
				[cell updatePhoneCell:subModel.C_U03100_C_NAME];
			}
		}
		
		return cell;
	}
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.isEdit == YES || ([self.titleStr isEqualToString:@"电话分配设置"] && tableView == self.topTableView)) {
		if (indexPath.row == 0) {
			[self getMarketActionDatas];
			
		}
	}
}

#pragma mark - 点击事件
- (void)clickEidtButton:(UIButton *)sender {
	self.isEdit = YES;
	self.sureButton.hidden = self.delButton.hidden = NO;;
	self.editButton.hidden = YES;
	CGRect frame = self.bottomTableView.frame;
	frame.size.height = self.bottomTableView.frame.size.height - 100;
	self.bottomTableView.frame = frame;
	[self.view addSubview:self.sureButton];
	[self.view addSubview:self.delButton];
	[self HTTPGetSalesListDatas];
	[self.topTableView reloadData];
}

- (void)saveButtonAction:(UIButton *)sender {
	for (MJKClueListSubModel *saleSubModel in self.saleListModel.data) {
		if (saleSubModel.isSelected == YES) {
			[self.salesArray addObject:saleSubModel.nickName];
		}
	}
	
	self.editButton.hidden = NO;
	self.sureButton.hidden = self.delButton.hidden = YES;
	[self HTTPUpdatePhoneSetDatas];
	self.bottomTableView.frame = CGRectMake(0, self.topTableView.frame.size.height, KScreenWidth, KScreenHeight - self.topTableView.frame.size.height);
	[self.topTableView reloadData];
    
    
//    self.isEdit = NO;
}

- (void)delButtonAction:(UIButton *)sender {
	[self HTTPDelectPhoneSetDatas];
}

#pragma mark - HTTP request
- (void)HTTPGetMarkDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getPhoneDetail];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	[tempDic setObject: self.phoneModel.totalId  forKey:@"C_ID"];
	[dict setObject:tempDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.detailModel = [MJKPhoneSetListModel yy_modelWithDictionary:data];
			[weakSelf.topTableView reloadData];
			[weakSelf.bottomTableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

//销售顾问
- (void)HTTPGetSalesListDatas {
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/user/list",HTTP_IP] parameters:@{@"C_LOCCODE" : [NewUserSession instance].user.C_LOCCODE} compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			if ([weakSelf.titleStr isEqualToString:@"电话分配设置"]) {
				weakSelf.saleListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
				[weakSelf.bottomTableView reloadData];
			} else {
				weakSelf.saleListModel = [MJKClueListViewModel yy_modelWithDictionary:data];
				for (MJKPhoneSetListSubModel *subModel in self.detailModel.content) {
					for (MJKClueListSubModel *saleSubModel in weakSelf.saleListModel.data) {
						if ([subModel.C_U03100_C_NAME isEqualToString:saleSubModel.nickName]) {
							saleSubModel.selected = YES;
						}
					}
				}
				[weakSelf.bottomTableView reloadData];
			}
			
		}else{
			[JRToast showWithText:data[@"msg"]];
		}
	}];
}

- (void)HTTPUpdatePhoneSetDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getPhoneUpddate];
	NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
	NSString *str = [self.salesArray componentsJoinedByString:@","];
	if (![self.titleStr isEqualToString:@"电话分配设置"]) {
		[tempDic setObject:self.phoneModel.totalId forKey:@"C_ID"];
	}
	if (self.detailModel.C_A41200_C_ID.length > 0) {
		[tempDic setObject:self.detailModel.C_A41200_C_ID forKey:@"C_A41200_C_ID"];
	}
	if (self.detailModel.C_INTERNAL.length > 0) {
		[tempDic setObject:self.detailModel.C_INTERNAL forKey:@"C_INTERNAL"];
	}
	if (str.length > 0) {
		[tempDic setObject:str forKey:@"C_U03100_C_ID"];
	}
	
	[dict setObject:tempDic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			if ([weakSelf.titleStr isEqualToString:@"电话分配设置"]) {
				[weakSelf.navigationController popViewControllerAnimated:YES];
			} else {
				[weakSelf.bottomTableView reloadData];
			}
			
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPDelectPhoneSetDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getPhoneDelete];
	[dict setObject:@{@"C_ID" : self.phoneModel.totalId} forKey:@"content"];
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

//得到市场活动的数据
-(void)getMarketActionDatas{
	NSMutableArray*saveMarketArray=[NSMutableArray array];
	HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/masterdata/a412/list", HTTP_IP] parameters:@{@"C_TYPE_DD_ID":@"A41200_C_TYPE_0000"} compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			NSArray*array=data[@"data"][@"list"];
			for (NSDictionary*dict in array) {
				MJKDataDicModel*model=[[MJKDataDicModel alloc]init];
				model.C_NAME=dict[@"C_NAME"];
				model.C_VOUCHERID=dict[@"C_ID"];
				
				[saveMarketArray addObject:model];
			}
			weakSelf.pickerView = nil;
			weakSelf.pickerView.style = PickerViewDataStyle;
			weakSelf.pickerView.modelArray = saveMarketArray;
			[weakSelf.pickerView popPickerView];
			[weakSelf.pickerView setSelectTextBlock:^(NSString *name, NSString *code){
				weakSelf.detailModel.C_A41200_C_NAME = name;
				weakSelf.detailModel.C_A41200_C_ID = code;
				[weakSelf.topTableView reloadData];
			}];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)topTableView {
	if (!_topTableView) {
		_topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 196) style:UITableViewStyleGrouped];
		_topTableView.delegate = self;
		_topTableView.dataSource = self;
		_topTableView.bounces = NO;
	}
	return _topTableView;
}

- (UITableView *)bottomTableView {
	if (!_bottomTableView) {
		_bottomTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.topTableView.frame.size.height, KScreenWidth, KScreenHeight - self.topTableView.frame.size.height) style:UITableViewStyleGrouped];
		_bottomTableView.delegate = self;
		_bottomTableView.dataSource = self;
	}
	return _bottomTableView;
}

- (UIButton *)sureButton {
	if (!_sureButton) {
		_sureButton = [[UIButton alloc]initWithFrame:CGRectMake(15, KScreenHeight - 95, KScreenWidth - 30, 40)];
		_sureButton.layer.cornerRadius = 5.0f;
		[_sureButton setTitle:@"确定" forState:UIControlStateNormal];
		_sureButton.backgroundColor = DBColor(220, 222, 34);
		[_sureButton addTarget:self action:@selector(saveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _sureButton;
}

- (UIButton *)delButton {
	if (!_delButton) {
		_delButton = [[UIButton alloc]initWithFrame:CGRectMake(15, KScreenHeight - 45, KScreenWidth - 30, 40)];
		_delButton.layer.cornerRadius = 5.0f;
		[_delButton setTitle:@"删除本机" forState:UIControlStateNormal];
		_delButton.backgroundColor = DBColor(252, 62, 68);
		[_delButton addTarget:self action:@selector(delButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _delButton;
}

- (MJKMarketPickerView *)pickerView {
	if (!_pickerView) {
		_pickerView = [[MJKMarketPickerView alloc]initWithFrame:self.view.frame];
		[self.view addSubview:_pickerView];
	}
	return _pickerView;
}

- (NSMutableArray *)salesArray {
	if (!_salesArray) {
		_salesArray = [NSMutableArray array];
	}
	return _salesArray;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[DBTools findFirstResponderBeneathView:self.view] resignFirstResponder];
}

@end
