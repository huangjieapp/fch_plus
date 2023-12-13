//
//  MJKShopArriveViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/28.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKShopArriveViewController.h"
#import "SubscribeAddOrEditViewController.h"

#import "MJKShopArriveTableViewCell.h"

#import "MJKShopArriveModel.h"
#import "MJKShopArriveSubModel.h"
#import "MJKShopArriveContentModel.h"

@interface MJKShopArriveViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger pagen;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) MJKShopArriveModel *arraiveModel;
@property (nonatomic, strong) MJKShopArriveContentModel *contentModel;
@property (nonatomic, strong) NSString *SEARCH_NAMEORCONTACT;
@end

@implementation MJKShopArriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"预约到店列表";
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUI {
    self.topLayout.constant = NavStatusHeight;
	UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 20)];
	button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
	[button setTitle:@"确定" forState:UIControlStateNormal];
	[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[button addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:button];
    if (![self.isLook isEqualToString:@"yes"]) {
        self.navigationItem.rightBarButtonItem = barButton;
    }
	
	
	[self.view addSubview:self.tableView];
	[self setUpRefresh];
	
}

-(void)setUpRefresh{
	self.pages = 1;
	self.pagen = 20;
	DBSelf(weakSelf);
    
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        self.pagen = 20;
        [self HTTPShopArriveListDatas];
    }];
	
	self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
		weakSelf.pagen += 20;
		[weakSelf HTTPShopArriveListDatas];

	}];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.arraiveModel.content.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	MJKShopArriveSubModel *subModel = self.arraiveModel.content[section];
	return subModel.content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	DBSelf(weakSelf);
	MJKShopArriveSubModel *subModel = self.arraiveModel.content[indexPath.section];
	MJKShopArriveContentModel *contentModel = subModel.content[indexPath.row];
	MJKShopArriveTableViewCell *cell = [MJKShopArriveTableViewCell cellWithTableView:tableView];
    if ([self.isLook isEqualToString:@"yes"]) {
        cell.seleteButton.hidden = YES;
    }
	cell.customLabel.text = contentModel.C_A41500_C_NAME;
	cell.shopTimeLabel.text = contentModel.D_BOOK_TIME;
	cell.saleLabel.text = contentModel.USER_NAME;
	cell.model = contentModel;
	cell.backModel = ^(MJKShopArriveContentModel *model) {
        if (weakSelf.type == ShopArriveTypeChoose) {
            
            SubscribeAddOrEditViewController *vc = [SubscribeAddOrEditViewController new];
            vc.C_ID = model.C_ID;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        } else {
            weakSelf.contentModel = model;
        }
	};
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	UIView *headerView = [[UIView alloc]initWithFrame:self.tableView.tableHeaderView.frame];
	headerView.backgroundColor = DBColor(247,247,247);
	UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
	timeLabel.textColor = DBColor(153,153,153);
	MJKShopArriveSubModel *model = self.arraiveModel.content[section];
	timeLabel.text = model.total;
	timeLabel.font = [UIFont systemFontOfSize:14.0f];
	CGSize size = [timeLabel.text sizeWithFont:timeLabel.font constrainedToSize:CGSizeMake(1000.0f, 20000.0f) lineBreakMode:NSLineBreakByWordWrapping];
	timeLabel.frame = CGRectMake(16, 3, size.width, size.height);
	[headerView addSubview:timeLabel];
	return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.SEARCH_NAMEORCONTACT = searchText;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 点击事件
- (void)clickBack:(UIButton *)sender {
    if (self.contentModel.C_ID.length <= 0) {
        [JRToast showWithText:@"请选择客户"];
        return;
    }
    if (self.backCustomerInfoBlock) {
        self.backCustomerInfoBlock(self.contentModel);
        return;
    }
	if (self.backC_ID) {
		self.backC_ID(self.contentModel.C_ID);
	}
//    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HTTP request
- (void)HTTPShopArriveListDatas {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	[dict setObject:[NSString stringWithFormat:@"%ld",self.pages] forKey:@"pageNum"];
	[dict setObject:[NSString stringWithFormat:@"%ld",self.pagen] forKey:@"pageSize"];
//    [dict setObject:@"" forKey:@"C_A40600_C_ID"];
	[dict setObject:@"1" forKey:@"IS_ARRIVE_SHOP"];
    if (self.SEARCH_NAMEORCONTACT.length > 0) {
        dict[@"SEARCH_NAMEORCONTACT"] = self.SEARCH_NAMEORCONTACT;
    }
    dict[@"C_LOCCODE"] = [NewUserSession instance].user.C_LOCCODE;
	HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a416Yy/list", HTTP_IP] parameters:dict compliation:^(id data, NSError *error) {
		DBSelf(weakSelf);
		MyLog(@"%@",data);
		if ([data[@"code"] integerValue]==200) {
			weakSelf.arraiveModel = [MJKShopArriveModel yy_modelWithDictionary:data[@"data"]];
			[weakSelf.tableView reloadData];
		} else {
			[JRToast showWithText:data[@"message"]];
		}
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
	}];
}

#pragma mark - set
- (UITableView *)tableView {
	if (!_tableView) {
		_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight + self.searchBar.frame.size.height + 30, KScreenWidth, KScreenHeight - (NavStatusHeight + self.searchBar.frame.size.height + 30)) style:UITableViewStyleGrouped];
		_tableView.delegate = self;
		_tableView.dataSource = self;
		_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _tableView;
}
@end
