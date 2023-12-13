//
//  MJKCarSourceNewDetailViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2022/10/19.
//  Copyright © 2022 脉居客. All rights reserved.
//

#import "MJKCarSourceNewDetailViewController.h"
#import "MJKCarSourceNewAddOrEditViewController.h"
#import "MJKCarSourceHomeWLViewController.h"
#import "CGCOrderListVC.h"
#import "MJKCarSourceStatusView.h"
#import "MJKOldCustomerSalesViewController.h"
#import "MJKCarSourceHomeWLViewController.h"
#import "MJKHighQualityViewController.h"
#import "MJKRegistrationViewController.h"

#import "MJKCarSourceHomeModel.h"
#import "VideoAndImageModel.h"

#import "MJKCarSourcePathTableViewCell.h"

@interface MJKCarSourceNewDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *headLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *titleLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *carLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *subLabel;
/** <#注释#> */
@property (nonatomic, strong) UILabel *contentLabel;

/** <#注释#> */
@property (nonatomic, assign) NSInteger tab;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *buttonArray;

/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) MJKCarSourceHomeSubModel *model;
/** <#注释#> */
@property (nonatomic, assign) NSInteger pageSize;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;

/** <#注释#> */
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#> */
@property (nonatomic, strong) MJKCarSourceStatusView *carStatusView;
@end

@implementation MJKCarSourceNewDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        if (self.tab == 0) {
            [self getCarSourceLockData];
        }  else if (self.tab == 1) {
            [self getCarSourceWLData];
        } else  {
            [self getCarSourceGJData];
        }
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车源详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    @weakify(self);
    _headLabel = [UILabel new];
    [self.view addSubview:_headLabel];
    [_headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT + 10);
        make.left.mas_equalTo(10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    _headLabel.backgroundColor = kBackgroundColor;
    _headLabel.textColor = [UIColor colorWithHex:@"#777777"];
    _headLabel.font = [UIFont systemFontOfSize:18.f];
    _headLabel.textAlignment = NSTextAlignmentCenter;
    
    _headImageView = [UIImageView new];
    [self.view addSubview:_headImageView];
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.headLabel);
    }];
    
    _titleLabel = [UILabel new];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headLabel.mas_right).offset(10);
        make.top.equalTo(self.headLabel);
    }];
    _titleLabel.textColor = [UIColor colorWithHex:@"#000000"];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16.f];
    
    _carLabel = [UILabel new];
    [self.view addSubview:_carLabel];
    [_carLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        make.left.equalTo(self.titleLabel);
    }];
    
    _carLabel.textColor = [UIColor colorWithHex:@"#777777"];
    _carLabel.font = [UIFont systemFontOfSize:14.f];
    
    _subLabel = [UILabel new];
    [self.view addSubview:_subLabel];
    [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.carLabel.mas_bottom).offset(7);
        make.left.equalTo(self.carLabel);
    }];
    _subLabel.textColor = [UIColor colorWithHex:@"#777777"];
    _subLabel.font = [UIFont systemFontOfSize:14.f];
    
    UIImageView *rightImageView = [UIImageView new];
    [self.view addSubview:rightImageView];
    [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.equalTo(self.carLabel);
        make.size.mas_equalTo(CGSizeMake(10, 20));
    }];
    rightImageView.image = [UIImage imageNamed:@"arrow_right2"];
    
    UIButton *rightButton = [UIButton new];
    [self.view addSubview:rightButton];
    [rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(rightImageView);
    }];
    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        MJKCarSourceNewAddOrEditViewController *vc = [MJKCarSourceNewAddOrEditViewController new];
        vc.C_ID = self.model.C_ID;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    
    UIView *sepView = [UIView new];
    [self.view addSubview:sepView];
    [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subLabel.mas_bottom).offset(7);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    sepView.backgroundColor = kBackgroundColor;
    
    _contentLabel = [UILabel new];
    [self.view addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sepView.mas_bottom).offset(7);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textColor = [UIColor colorWithHex:@"#777777"];
    _contentLabel.font = [UIFont systemFontOfSize:14.f];
    
    self.tab = 0;
    UIView *topView = [UIView new];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLabel.mas_bottom).offset(7);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    topView.backgroundColor = [UIColor colorWithHex:@"#fff"];
    NSArray *titleArray = @[@"锁定",@"物流",@"轨迹"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton new];
        [topView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(topView);
            make.left.mas_equalTo(i * (KScreenWidth / titleArray.count));
            make.width.mas_equalTo(KScreenWidth / titleArray.count);
        }];
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor colorWithHex:@"#aaaaaa"]];
        button.titleLabel.font = [UIFont systemFontOfSize:12.f];
        if (i != titleArray.count - 1) {
            UIView *sepView = [UIView new];
            [topView addSubview:sepView];
            
            [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(topView);
                make.right.equalTo(button.mas_right);
                make.width.mas_equalTo(1);
                
            }];
            sepView.backgroundColor = [UIColor colorWithHex:@"#efeff4"];
        }
        if (i == self.tab) {
            [button setBackgroundColor:KNaviColor];
        }
        button.tag = 100 + i;
        [self.buttonArray addObject:button];
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIButton * _Nullable x) {
            @strongify(self);
            UIButton *button = self.buttonArray[self.tab];
            [button setBackgroundColor:[UIColor colorWithHex:@"#aaaaaa"]];
            self.tab = x.tag - 100;
            [x setBackgroundColor:KNaviColor];
            [self.tableView.mj_header beginRefreshing];
        }];
    }
    
    NSArray *oArray = @[@"物流",@"锁定",@"售后",@"精品",@"上牌"];
    NSArray *iArray = @[@"变更状态",@"锁定",@"icon_source_sales",@"精品",@"上牌"];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight - ((((oArray.count - 1) / 4) * 90) + 90));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MJKCarSourcePathTableViewCell class] forCellReuseIdentifier:@"MJKCarSourcePathTableViewCell"];
    _tableView.estimatedRowHeight = 300;
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
   
    _bottomView = [UIView new];
    [self.view addSubview:_bottomView];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-AdaptSafeBottomHeight);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo((((oArray.count - 1) / 4) * 90) + 90);
    }];
    _bottomView.backgroundColor = kBackgroundColor;
    
    
    for (int i = 0; i < oArray.count; i++) {
        UIView *subView = [UIButton new];
        [_bottomView addSubview:subView];
        [subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((i % 4) * (KScreenWidth / 4));
            make.size.mas_equalTo(CGSizeMake(KScreenWidth / 4, 90));
            make.top.mas_equalTo((i / 4) * 90);
        }];
        
        UIImageView *imageView = [UIImageView new];
        [subView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(40, 40));
            make.top.mas_equalTo(10);
            make.centerX.equalTo(subView);
        }];
        imageView.image = [UIImage imageNamed:iArray[i]];
        
        UILabel *label = [UILabel new];
        [_bottomView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_bottom).offset(10);
            make.centerX.equalTo(imageView);
        }];
        label.textColor = [UIColor colorWithHex:@"#777777"];
        label.font = [UIFont systemFontOfSize:12.f];
        label.text = oArray[i];
        
        UIButton *button = [UIButton new];
        [_bottomView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(subView);
        }];
        button.tag = 100 + i;
        @weakify(self);
        [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self);
            if (x.tag == 100) {
                MJKCarSourceHomeWLViewController *vc = [MJKCarSourceHomeWLViewController new];
                vc.C_A82300_C_ID = self.model.C_ID;
                vc.C_A80000_DD_ID = self.model.C_A80000SZD_C_ID;
                vc.C_A80000_DD_NAME = self.model.C_A80000SZD_C_NAME;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (x.tag == 101) {
                CGCOrderListVC *vc = [CGCOrderListVC new];
                vc.isTab = @"无";
                vc.carChoose = @"是";
                __block NSString *C_A42000_C_ID = @"";
                __block NSString *C_CYSTATUS_DD_ID = @"";
                vc.chooseOrderBlock = ^(NSString *orderId) {
                    MJKCarSourceStatusView *view = [[MJKCarSourceStatusView alloc]initWithFrame:self.view.bounds];;
                    self.carStatusView = view;
                    view.chooseBlock = ^(NSString * _Nonnull str, NSString * _Nonnull postValue) {
                        C_A42000_C_ID = orderId;
                        C_CYSTATUS_DD_ID = postValue;
                    };
                    
                    [[view.trueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                        [self saveCarSourceSdData:C_A42000_C_ID andC_A82300_C_ID:self.model.C_ID andC_CYSTATUS_DD_ID:C_CYSTATUS_DD_ID];
                    }];
                    [[UIApplication sharedApplication].windows[0] addSubview:view];
                    
                };
                [self.navigationController pushViewController:vc animated:YES];
            } else if (x.tag == 102) {
                MJKOldCustomerSalesViewController *vc = [MJKOldCustomerSalesViewController new];
                vc.C_TYPE_DD_ID = @"A81500_C_TYPE_0000";
                vc.C_A47700_C_ID = self.model.C_ID;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (x.tag == 103) {
                MJKHighQualityViewController *vc = [MJKHighQualityViewController new];
                vc.C_A42000_C_ID = self.model.C_ID;
                [self.navigationController pushViewController:vc animated:YES];
            } else if (x.tag == 104) {
                MJKRegistrationViewController *vc = [MJKRegistrationViewController new];
                vc.type = @"车源";
                vc.C_A42000_C_ID = self.model.C_ID;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    
    
    [self getCarSourceData];
    
    
}

- (void)saveCarSourceSdData:(NSString *)orderId andC_A82300_C_ID:(NSString *)C_A82300_C_ID andC_CYSTATUS_DD_ID:(NSString *)C_CYSTATUS_DD_ID {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A42000_C_ID"] = orderId;
    contentDic[@"C_A82300_C_ID"] = C_A82300_C_ID;
    contentDic[@"C_CYSTATUS_DD_ID"] = C_CYSTATUS_DD_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/cysd", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            [self.carStatusView removeFromSuperview];
            [self getCarSourceData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)configRefresh {
    @weakify(self);
    self.pageSize = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.pageSize = 20;
        if (self.tab == 0) {
            [self getCarSourceLockData];
        }  else if (self.tab == 1) {
            [self getCarSourceWLData];
        } else  {
            [self getCarSourceGJData];
        }
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.pageSize += 20;
        if (self.tab == 0) {
            [self getCarSourceLockData];
        } else if (self.tab == 1) {
            [self getCarSourceWLData];
        } else  {
            [self getCarSourceGJData];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MJKCarSourcePathTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKCarSourcePathTableViewCell"];
    if (self.tab == 0) {
        MJKCarSourceLockModel *model = self.dataArray[indexPath.row];
        cell.statusLabel.text = model.D_CREATE_TIME;
        cell.typeLabel.text = @"";
        cell.contentLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@",model.C_CYSTATUS_DD_NAME,model.C_STATUS_DD_NAME,model.C_CREATOR_ROLENAME];
    } else if (self.tab == 1) {
        MJKCarSourceWLModel *model = self.dataArray[indexPath.row];
        
        cell.statusLabel.text = model.D_CREATE_TIME;
        cell.typeLabel.text = model.C_TYPE_DD_NAME;
        cell.contentLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@\n%@", model.C_A80000DCF_C_NAME, model.C_A80000DRF_C_NAME, model.C_STATUS_DD_NAME, model.C_CREATOR_ROLENAME];
    } else {
        MJKCarSourceGJModel *model = self.dataArray[indexPath.row];
        cell.statusLabel.text = model.D_CREATE_TIME;  
        cell.typeLabel.text = model.dateType;
        cell.contentLabel.text = model.X_REMARK;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.tab == 1) {
        MJKCarSourceWLModel *model = self.dataArray[indexPath.row];
        MJKCarSourceHomeWLViewController *vc = [MJKCarSourceHomeWLViewController new];
        vc.C_ID = model.C_ID;
        vc.C_TYPE_DD_ID = model.C_TYPE_DD_ID;
        [self.navigationController pushViewController:vc animated:YES];
    } else if (self.tab == 2) {
        MJKCarSourceGJModel *model = self.dataArray[indexPath.row];
        if ([model.dateType isEqualToString:@"精品"]) {
            MJKHighQualityViewController *vc = [MJKHighQualityViewController new];
            vc.C_ID = model.C_ID;
            [self.navigationController pushViewController:vc animated:YES];
        } else if ([model.dateType isEqualToString:@"上牌"]) {
            MJKRegistrationViewController *vc = [MJKRegistrationViewController new];
            vc.C_ID = model.C_ID;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([model.dateType isEqualToString:@"售后"]) {
            MJKOldCustomerSalesViewController *vc = [MJKOldCustomerSalesViewController new];
            vc.C_ID = model.C_ID;
            vc.C_TYPE_DD_ID = @"A81500_C_TYPE_0000";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [UIImageView new];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(95);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    imageView.image = [UIImage imageNamed:@"topimg"];
    
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [UIImageView new];
    [bgView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(95);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    imageView.image = [UIImage imageNamed:@"bottomimg"];
    
    return bgView;
}

- (void)getCarSourceData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = self.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/info", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            MJKCarSourceHomeSubModel *model = [MJKCarSourceHomeSubModel mj_objectWithKeyValues:data[@"data"]];
            self.model = model;
            if (model.fileListFp.count > 0) {
                self.headLabel.hidden = YES;
                self.headImageView.hidden = NO;
                VideoAndImageModel *vm = model.fileListFp[0];
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:vm.url]];
            } else {
                
                    self.headLabel.hidden = NO;
                    self.headImageView.hidden = YES;
                if (model.C_CAR_TYPE.length > 0) {
                    self.headLabel.text = [model.C_CAR_TYPE substringToIndex:1];
                } else {
                    self.headLabel.text = @"";
                }
            }
            self.titleLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",model.C_CAR_TYPE,model.C_A70600_C_NAME, model.C_A49600_C_NAME, model.C_A80000CJ_C_NAME];
            self.carLabel.text = [NSString stringWithFormat:@"%@座 %@/%@ %@ %@", model.I_SEAT, model.C_W_COLOR, model.C_N_COLOR, model.C_ENVIRONMENTAL_PROTECTION, model.C_VOUCHERID];
            self.subLabel.text = [NSString stringWithFormat:@"%@ %@ %@", model.C_A80000SZD_C_NAME, model.D_ARRIVAL_TIME, model.C_STATUS_DD_NAME];
            self.contentLabel.text = [NSString stringWithFormat:@"告知单:%@ 备注%@", model.C_INFORM_THE_SINGLE, model.X_REMARK];
            
            [self configRefresh];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)getCarSourceLockData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pageSize);
    contentDic[@"C_A82300_C_ID"] = self.model.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a828/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            self.dataArray = [MJKCarSourceLockModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [self.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getCarSourceWLData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pageSize);
    contentDic[@"C_A82300_C_ID"] = self.model.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a829/list", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            self.dataArray = [MJKCarSourceWLModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [self.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (void)getCarSourceGJData {
    @weakify(self);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"pageNum"] = @"1";
    contentDic[@"pageSize"] = @(self.pageSize);
    contentDic[@"C_A82300_C_ID"] = self.model.C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a823/guijiList", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        @strongify(self);
        if ([data[@"code"] intValue] == 200) {
            MyLog(@"%@", data);
            self.dataArray = [MJKCarSourceGJModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [self.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

- (NSMutableArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}


@end
