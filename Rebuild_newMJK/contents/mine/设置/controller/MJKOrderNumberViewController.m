//
//  MJKOrderNumberViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/10/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKOrderNumberViewController.h"

#import "MJKOrderNumberTableViewCell.h"

#import "MJKOrderNumberModel.h"

@interface MJKOrderNumberViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) MJKOrderNumberModel *model;
@property (nonatomic, assign) BOOL isChange;//是否修改
@end

@implementation MJKOrderNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"订单编号设置";
	[self.view addSubview:self.tableView];
	[self HTTPGetOrderNumberDatas];
	
	UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	gestureRecognizer.numberOfTapsRequired = 1;
	gestureRecognizer.cancelsTouchesInView = NO;
	[self.tableView addGestureRecognizer:gestureRecognizer];

	
	UIButton *rightTopButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
	[rightTopButton setTitle:@"修改" forState:UIControlStateNormal];
	rightTopButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[rightTopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[rightTopButton addTarget:self action:@selector(rightTopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:rightTopButton];
	self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKOrderNumberTableViewCell *cell = [MJKOrderNumberTableViewCell cellWithTableView:tableView];
	if (self.model != nil) {
		[cell updataCellTitle:@[@"编号前缀", @"后缀长度"] andContent:@[self.model.C_ABBREVIATION, self.model.I_STORENUMBER] andRow:indexPath.row];
		if (self.isChange == YES) {
			cell.contentTextField.enabled = YES;
			DBSelf(weakSelf);
			cell.backTextBlock = ^(NSString *text) {
				if (indexPath.row == 0) {
					weakSelf.model.C_ABBREVIATION = text;
				} else {
					weakSelf.model.I_STORENUMBER = text;
				}
			};
		} else {
			cell.contentTextField.enabled = NO;
		}
		
	}
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

#pragma mark - 点击事件
- (void)rightTopButtonAction:(UIButton *)sender {
	sender.selected = !sender.isSelected;
	[sender setTitle:sender.isSelected == YES ? @"完成" : @"修改" forState:UIControlStateNormal];
	if (sender.isSelected == YES) {
		self.isChange = YES;
	} else {
		[self HTTPUpdataOrderNumberDatas];
		self.isChange = NO;
		
	}
	[self.tableView reloadData];
}

- (void) hideKeyboard {
	[self.view endEditing:YES];
}

#pragma mark - HTTPRequest
- (void)HTTPGetOrderNumberDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_getPrefixDetail];
	[dict setObject:@{} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.model = [MJKOrderNumberModel yy_modelWithDictionary:data];
			[weakSelf.tableView reloadData];
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

- (void)HTTPUpdataOrderNumberDatas {
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:HTTP_updatePrefix];
	[dict setObject:@{@"C_ABBREVIATION" : self.model.C_ABBREVIATION, @"I_STORENUMBER" : self.model.I_STORENUMBER} forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
	HttpManager*manager=[[HttpManager alloc]init];
	[manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		MyLog(@"%@",data);
		DBSelf(weakSelf);
		if ([data[@"code"] integerValue]==200) {
		}else{
			[JRToast showWithText:data[@"message"]];
		}
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.bounces = NO;
	}
	return _tableView;
}
@end
