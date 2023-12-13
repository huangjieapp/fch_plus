//
//  MJKSocialPresonShareViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/3/3.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import "MJKSocialPresonShareViewController.h"

#import "MJKSocialPresonShareTableViewCell.h"

#import "MJKSocialPresonShareModel.h"
#import "MJKSocialMarketHeaderModel.h"

#import "CGCCustomDateView.h"


@interface MJKSocialPresonShareViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, assign) NSInteger pagen;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/

@property (nonatomic, strong) UILabel *headerLabel;
/** <#注释#>*/
@property (nonatomic, strong) UIView *perSepView;
/** <#注释#>*/
@property (nonatomic, strong) UIButton *perButton;
@end

@implementation MJKSocialPresonShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self configHeaderView];
    [self configRefresh];
}

- (void)configHeaderView {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 55)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 5; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(50 + (i * ((KScreenWidth - 100) / 5)), 5, (KScreenWidth - 100) / 5, 45)];
        [button setTitleNormal:@[@"今天",@"7天",@"30天",@"90天",@"自定义"][i]];
        [button setTitleColor:[UIColor blackColor]];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        button.tag = 100 + i;
        if (self.startTime.length > 0) {
            if (button.tag == 104) {
                [button setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
                self.perButton = button;

                UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y, button.frame.size.width, 2)];
                self.perSepView = sepView;
                sepView.backgroundColor = [UIColor colorWithHex:@"#3E5687"];
                [headerView addSubview:sepView];
            }
        } else {
        if ((i + 1) == self.searchTime.integerValue) {
            [button setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
            self.perButton = button;

            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(button.frame.origin.x, button.frame.size.height + button.frame.origin.y, button.frame.size.width, 2)];
            self.perSepView = sepView;
            sepView.backgroundColor = [UIColor colorWithHex:@"#3E5687"];
            [headerView addSubview:sepView];
        }
        }
        [button addTarget:self action:@selector(chooseTimeAction:)];
        [headerView addSubview:button];
        
        
    }
    
    [self.view addSubview:headerView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(headerView.frame), KScreenWidth - 10, 30)];
    self.headerLabel = label;
    label.text = @"0次分享0次转发,共0人浏览0次";
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor darkGrayColor];
    [self.view addSubview:label];
}

- (void)chooseTimeAction:(UIButton *)sender {
    DBSelf(weakSelf);
    if ([sender.titleLabel.text isEqualToString:@"自定义"]) {
        CGCCustomDateView * dateView=[[CGCCustomDateView alloc] initWithFrame:self.view.bounds withStart:^{
            
        } withEnd:^{
            
            
        } withSure:^(NSString *start, NSString *end) {
            MyLog(@"11--%@   22--%@",start,end);
            weakSelf.startTime = start;
            weakSelf.endTime = end;
            weakSelf.searchTime = @"";
            
            [weakSelf.tableView.mj_header beginRefreshing];
            
        }];


        dateView.clickCancelBlock = ^{
        
            
        };



        [[UIApplication sharedApplication].keyWindow addSubview:dateView];
    } else {

    self.searchTime = [NSString stringWithFormat:@"%ld",sender.tag - 100 + 1] ;
        self.startTime = @"";
        self.endTime = @"";
        [self.tableView.mj_header beginRefreshing];
    }
    self.perSepView.centerX = sender.centerX;
    [sender setTitleColor:[UIColor colorWithHex:@"#3E5687"]];
    
    [self.perButton setTitleColor:[UIColor blackColor]];
    
    self.perButton = sender;
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf httpGetDataValue];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf httpGetDataValue];
        
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - http
- (void)httpGetDataValue {
    DBSelf(weakSelf);
    NSMutableDictionary *mainDic = [DBObjectTools getAddressDicWithAction:@"WxWebService-getShareList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"userToken"] = _accountId;
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = @(self.pagen);
    contentDic[@"searchTime"] = self.searchTime;
    contentDic[@"type"] = @"3";
//    "userToken":"1000001071918225","searchTime":4,"currPage":1,"pageSize":10,"type":3
    [mainDic setObject:contentDic forKey:@"content"];
    
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:@"1"];
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:mainDic compliation:^(id data, NSError *error) {
        NSLog(@"%@",data);
        if ([data[@"code"] integerValue] == 200) {
            MJKSocialMarketHeaderModel *socialMarketHeaderModel = [MJKSocialMarketHeaderModel mj_objectWithKeyValues:data];
            weakSelf.headerLabel.text = [NSString stringWithFormat:@"%@次分享%@次转发,共%@人浏览%@次",socialMarketHeaderModel.allShareNumber,socialMarketHeaderModel.allForwardNumber,socialMarketHeaderModel.allReadNumber,socialMarketHeaderModel.allReadCount];
            weakSelf.dataArray = [MJKSocialPresonShareModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"message"]];
        }

        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKSocialPresonShareModel *model = self.dataArray[indexPath.row];
    MJKSocialPresonShareTableViewCell *cell = [MJKSocialPresonShareTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKSocialPresonShareModel *model = self.dataArray[indexPath.row];
    if (model.images.count > 0) {
        return [MJKSocialPresonShareTableViewCell cellForHeight:model];
    } else {
    return 190;
    }
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

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight + 85, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 85) style:UITableViewStyleGrouped];
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
