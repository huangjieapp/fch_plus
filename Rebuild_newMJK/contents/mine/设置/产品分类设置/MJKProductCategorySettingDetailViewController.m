//
//  MJKMarketSettingDetailViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/13.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKProductCategorySettingDetailViewController.h"
#import "MJKProductCategorySettingEditViewController.h"
#import "AddCustomerInputTableViewCell.h"
#import "MJKProductShowModel.h"

@interface MJKProductCategorySettingDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MJKProductCategorySettingDetailViewController

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
//    [self HTTPGetMarkDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"产品分类详情";
	[self initUI];
	[self.view addSubview:self.tableView];
	if (@available(iOS 11.0,*)) {
		self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
	}else{
		
		
		self.automaticallyAdjustsScrollViewInsets=NO;
	}
}

- (void)initUI {
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
	[button setTitle:@"修改" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[button addTarget:self action:@selector(clickEidtButton:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];;
	self.navigationItem.rightBarButtonItem = barButton;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
    cell.nameTitleLabel.text = @"产品分类名称";
    if (self.productModel.C_NAME.length > 0) {
        cell.inputTextField.text = self.productModel.C_NAME;
    };
    cell.inputTextField.enabled = NO;
    cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
    return cell;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	return nil;
}

#pragma mark - 点击事件
- (void)clickEidtButton:(UIButton *)sender {
	MJKProductCategorySettingEditViewController *editVC = [[MJKProductCategorySettingEditViewController alloc]init];
	editVC.productModel = self.productModel;
	[self.navigationController pushViewController:editVC animated:YES];
}

//#pragma mark - HTTP request
//- (void)HTTPGetMarkDatas {
//    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getMarketBeanById];
//    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
//    [tempDic setObject:self.model.C_ID forKey:@"C_ID"];
//    [dict setObject:tempDic forKey:@"content"];
//    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        DBSelf(weakSelf);
//        if ([data[@"code"] integerValue]==200) {
//            weakSelf.productModel = [MJKProductShowModel mj_objectWithKeyValues:data[@"content"]];
//            [weakSelf.tableView reloadData];
//        }else{
//            [JRToast showWithText:data[@"message"]];
//        }
//    }];
//}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
	}
	return _tableView;
}

@end
