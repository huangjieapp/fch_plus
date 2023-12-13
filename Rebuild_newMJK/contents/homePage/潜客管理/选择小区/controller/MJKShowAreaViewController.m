//
//  MJKShowAreaViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKShowAreaViewController.h"

#import "MJKShowAreaModel.h"

@interface MJKShowAreaViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, assign) NSInteger pages;//条
@property (nonatomic, assign) NSInteger pagen;//页
@property (nonatomic, strong) NSString *SEARCH_NAMEORADDRESS;
@property (nonatomic, strong) MJKShowAreaModel *areaModel;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MJKShowAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择小区";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableview];
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableview.mj_header beginRefreshing];
}

-(void)setupRefresh{
    DBSelf(weakSelf);
    self.pages=20;
    self.tableview.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.pages=20;
        [weakSelf getListDatas];
        
    }];
    
    self.tableview.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.pages += 20;
        [weakSelf getListDatas];
        
    }];
    
    //    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    MJKShowAreaModel *areaModel = self.dataArray[indexPath.row];
    cell.textLabel.text = areaModel.C_NAMEANDADDRESS;
	cell.textLabel.font = [UIFont systemFontOfSize:14.f];
	cell.textLabel.numberOfLines = 0;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKShowAreaModel *model = self.dataArray[indexPath.row];
    if (self.selectAddressBlock) {
        self.selectAddressBlock(model);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	MJKShowAreaModel *areaModel = self.dataArray[indexPath.row];
	CGSize size = [areaModel.C_NAMEANDADDRESS boundingRectWithSize:CGSizeMake(KScreenWidth - 20, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size;
	if (size.height + 22 > 44) {
		return size.height + 22;
	} else {
		return 44;
	}
}

#pragma mark - http request
-(void)getListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary*mainDict=[DBObjectTools getAddressDicWithAction:@"A48200WebService-getList"];
    
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"currPage"] = @"1";
    contentDict[@"pageSize"] = [NSString stringWithFormat:@"%ld",self.pages];
    if (self.SEARCH_NAMEORADDRESS.length > 0) {
        contentDict[@"SEARCH_NAMEORADDRESS"] = self.SEARCH_NAMEORADDRESS;
    }
    
    [mainDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            NSArray *arr = data[@"content"];
            for (NSDictionary *dic in arr) {
                weakSelf.areaModel = [MJKShowAreaModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:weakSelf.areaModel];
            }
            
            [weakSelf.tableview reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableview.mj_header endRefreshing];
        [weakSelf.tableview.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - searchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.SEARCH_NAMEORADDRESS = searchText;
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - setter/getter
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 50)];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), KScreenWidth, KScreenHeight - NavStatusHeight - self.searchBar.frame.size.height - WD_TabBarHeight) style:UITableViewStylePlain];
        _tableview.dataSource = self;
        _tableview.delegate = self;
    }
    return _tableview;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
