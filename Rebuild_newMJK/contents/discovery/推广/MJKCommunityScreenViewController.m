//
//  MJKCommunityScreenViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/24.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCommunityScreenViewController.h"

#import "MJKCommunityScreenCell.h"

#import "MJKShowAreaModel.h"

@interface MJKCommunityScreenViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
/** searchBar*/
@property (nonatomic, strong) UISearchBar *searchBar;
/** allChoose*/
@property (nonatomic, strong) UIView *allChooseView;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** SEARCH_NAMEORADDRESS*/
@property (nonatomic, strong) NSString *SEARCH_NAMEORADDRESS;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pages;
/** <#注释#>*/
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation MJKCommunityScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"选择小区";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 44)];
    [button setTitleNormal:@"确定"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [button addTarget:self action:@selector(sureButtonAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.allChooseView];
    [self.view addSubview:self.tableView];
    
    [self configRefresh];
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pages = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pages = 20;
        [weakSelf getListDatas];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pages += 20;
        [weakSelf getListDatas];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark sureButtonAction
- (void)sureButtonAction {
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
    NSString *str = @"";
    NSString *nameStr = @"小区搜索";
    for (MJKShowAreaModel *model in self.dataArray) {
        if (model.isSelected == YES) {
            [arr addObject:model.C_ID];
            [nameArr addObject:model.C_NAMEANDADDRESS];
        }
    }
    if (arr.count > 0) {
        str = [arr componentsJoinedByString:@","];
        nameStr = [nameArr componentsJoinedByString:@","];
    }
    if (self.sureBackBlock) {
        self.sureBackBlock(str,nameStr);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKShowAreaModel *model = self.dataArray[indexPath.row];
    MJKCommunityScreenCell *cell = [MJKCommunityScreenCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectImageView.image = [UIImage imageNamed:@"未打钩"];
    MJKShowAreaModel *model = self.dataArray[indexPath.row];
    if (self.isAddExpand == YES) {
        if (self.sureBackBlock) {
            self.sureBackBlock(model.C_ID, model.C_NAMEANDADDRESS);
        }
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    model.selected = !model.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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



#pragma mark - 搜索框 UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    self.SEARCH_NAMEORADDRESS = searchBar.text;
    [self.tableView.mj_header beginRefreshing];
}

- (void)chooseAllAction {
    for (MJKShowAreaModel *model in self.dataArray) {
        model.selected = NO;
    }
    self.selectImageView.image = [UIImage imageNamed:@"打钩"];
    [self.tableView reloadData];
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
            weakSelf.dataArray = [MJKShowAreaModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    
}

#pragma mark - set
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 44)];
        _searchBar.placeholder = @"搜索小区";
//        UITextField * searchField = [_searchBar valueForKey:@"_searchField"];
//        [searchField setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIView *)allChooseView {
    if (!_allChooseView) {
        _allChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), KScreenWidth, 44)];
        _allChooseView.backgroundColor = kBackgroundColor;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,(44 - 22) / 2, 22, 22)];
        imageView.image = [UIImage imageNamed:@"未打钩"];
        [_allChooseView addSubview:imageView];
        self.selectImageView = imageView;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), 0, KScreenWidth - imageView.frame.size.width - 10, 44)];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        label.text = @"全部";
        label.textAlignment = NSTextAlignmentCenter;
        [_allChooseView addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
        [button addTarget:self action:@selector(chooseAllAction)];
        [_allChooseView addSubview:button];
    }
    return _allChooseView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.allChooseView.frame), KScreenWidth, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - self.searchBar.frame.size.height )];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

@end
