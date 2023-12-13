//
//  MJKAddPublicMessageViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/11/14.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKAddPublicMessageViewController.h"

#import "CGCTalkModel.h"

#import "AddCustomerInputTableViewCell.h"
#import "CGCNewAppointTextCell.h"

@interface MJKAddPublicMessageViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** commitButton*/
@property (nonatomic, strong) UIButton *commitButton;
@end

@implementation MJKAddPublicMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if (@available(iOS 11.0, *)) {
		self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	}else {
		self.automaticallyAdjustsScrollViewInsets = NO;
	}
	[self initUI];
}

- (void)initUI {
	if (self.type == PublicMessageAdd) {
		self.title = @"新增公共消息模板";
		self.model = [[CGCTalkModel alloc]init];
	} else {
		self.title = @"编辑公共消息模板";
	}
	[self.view addSubview:self.tableView];
	[self.view addSubview:self.commitButton];
}

#pragma  mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	if (indexPath.row == 0) {
		AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
		cell.nameTitleLabel.text = @"标题";
		cell.inputTextField.text = self.model.C_NAME;
		cell.inputTextField.hidden = NO;
		cell.inputTextView.hidden = YES;
        cell.inputTextView.textColor = cell.inputTextField.textColor = [UIColor darkGrayColor];
		cell.changeTextBlock = ^(NSString *textStr) {
			weakSelf.model.C_NAME = textStr;
		};
		return cell;
	} else {
		CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
		cell.topTitleLabel.text=@"内容";
		cell.beforeText = self.model.X_PICCONTENT;
		
		cell.changeTextBlock = ^(NSString *textStr) {
			weakSelf.model.X_PICCONTENT = textStr;
		};
		return cell;
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.row == 1) {
		return 150;
	}
	return 44;
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

#pragma mark - 点击事件
- (void)commitButtonAction {
	if (self.model.C_NAME.length <= 0) {
		[JRToast showWithText:@"请输入标题"];
		return;
	}
	if (self.model.X_PICCONTENT.length <= 0) {
		[JRToast showWithText:@"请输入内容"];
		return;
	}
	[self HTTPAddMineMessageRequest];
}

-(void)HTTPAddMineMessageRequest
{
	NSString *actionStr;
	if (self.type == PublicMessageAdd) {
		actionStr = HTTP_CGC_saveBeanId;
	} else {
		actionStr = HTTP_CGC_templateMessageUpdate;
	}
	NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:actionStr];
	
	NSMutableDictionary *dic=[NSMutableDictionary dictionary];
	
	if (self.model.C_ID.length > 0) {
		[dic setObject:self.model.C_ID forKey:@"C_ID"];
	}
	if (self.model.C_NAME.length > 0) {
		[dic setObject:self.model.C_NAME forKey:@"C_NAME"];
	}
	if (self.model.X_PICCONTENT.length > 0) {
		[dic setObject:self.model.X_PICCONTENT forKey:@"X_PICCONTENT"];
	}
	
	[dic setObject:@"A68300_C_PUBLIC_0000" forKey:@"C_PUBLIC_DD_ID"];
	[dic setObject:@"A68300_C_MESSAGETYPE_0002" forKey:@"C_MESSAGETYPE_DD_ID"];
	[dict setObject:dic forKey:@"content"];
	NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
	
	HttpManager*manager=[[HttpManager alloc]init];
	
	
	[manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
		
		if ([data[@"code"] integerValue]==200) {
			
			[self.navigationController popViewControllerAnimated:YES];
			
		}else{
			
			[JRToast showWithText:data[@"message"]];
			
		}
	}];
	
	
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
		_tableView.dataSource = self;
		_tableView.delegate = self;
		_tableView.estimatedRowHeight = 0;
		_tableView.estimatedSectionFooterHeight = 0;
		_tableView.estimatedSectionHeaderHeight = 0;
		_tableView.tableFooterView = [[UIView alloc]init];
	}
	return _tableView;
}

- (UIButton *)commitButton {
	if (!_commitButton) {
		_commitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), KScreenWidth, 55)];
		_commitButton.backgroundColor = KNaviColor;
		[_commitButton setTitleNormal:@"提交"];
		[_commitButton setTitleColor:[UIColor blackColor]];
		[_commitButton addTarget:self action:@selector(commitButtonAction)];
	}
	return _commitButton;
}

@end
