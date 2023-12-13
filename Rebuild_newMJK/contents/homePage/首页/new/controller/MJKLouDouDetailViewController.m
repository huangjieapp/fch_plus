//
//  MJKLouDouDetailViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/1/15.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "MJKLouDouDetailViewController.h"
#import "MJKLouDouDetailModel.h"

#import "MJKLouDouDetailTableViewCell.h"

@interface MJKLouDouDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UIView *backView;
/** <#注释#> */
@property (nonatomic, strong) UIButton *backButton;
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSString *tableType;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#> */
@property (nonatomic, strong) NSString *C_GRPCODE;
@property (nonatomic, strong) NSString *C_ORGCODE;
@end

@implementation MJKLouDouDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableType = @"0";
    @weakify(self);
    _backView = [UIView new];
    [self.view addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVIHEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    _backButton = [UIButton new];
    [_backView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
        make.width.mas_equalTo(90);
    }];
    [_backButton setTitle:@"返回上一层" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor colorWithHex:@"#777777"] forState:UIControlStateNormal];
    _backButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    _backButton.layer.borderColor = kBackgroundColor.CGColor;
    _backButton.layer.borderWidth = 1.f;
    _backButton.layer.cornerRadius = 5.f;
    _backView.hidden = YES;
    [[_backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([self.tableType isEqualToString:@"2"]) {
            self.tableType = @"1";
        } else if ([self.tableType isEqualToString:@"1"]) {
            self.tableType = @"0";
            [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(0);
            }];
            self.backView.hidden = YES;
        }
        
        [self getDataList];
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView.mas_bottom);
        make.left.right.equalTo(self.view);
        make.bottom.mas_equalTo(-SafeAreaBottomHeight);
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [scrollView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.height.equalTo(scrollView);
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[MJKLouDouDetailTableViewCell class] forCellReuseIdentifier:@"MJKLouDouDetailTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
//    scrollView.contentSize = CGSizeMake(90 * 7, 0);
    scrollView.bounces = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    
    [self getDataList];
    
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    MJKLouDouDetailModel *model = self.dataArray[indexPath.row];
    MJKLouDouDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MJKLouDouDetailTableViewCell"];
    cell.tableType = self.tableType;
    cell.model = model;
    [[[cell.toButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if ([self.tableType isEqualToString:@"0"]) {
            [self.backView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(40);
            }];
            self.backView.hidden = NO;
            self.tableType = @"1";
            self.C_GRPCODE = model.code;
        } else if ([self.tableType isEqualToString:@"1"]) {
            self.tableType = @"2";
            self.C_ORGCODE = model.code;
            
        }
        [self getDataList];
    }];
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    
//    NSArray *arr = @[@"事业部",@"全域流量",@"意向客户",@"到店",@"订单",@"全款",@"交付"];
    NSArray *arr = @[@"事业部",@"总量"];
    if ([self.tableType isEqualToString:@"2"]) {
        arr = @[@"门店",@"总量"];
    } else if ([self.tableType isEqualToString:@"1"]) {
        arr = @[@"区域",@"总量"];
    } else if ([self.tableType isEqualToString:@"0"]) {
        arr = @[@"事业部",@"总量"];
    }
    for (int i = 0; i < arr.count; i++) {
        UILabel *label = [UILabel new];
        [bgView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo((KScreenWidth / 2) * i);
            make.top.mas_equalTo(0);
            make.height.mas_equalTo(40);
            make.width.mas_equalTo(KScreenWidth / 2);
        }];
        label.text = arr[i];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textAlignment = NSTextAlignmentCenter;
        
        UIView *sepView = [UIView new];
        [bgView addSubview:sepView];
        [sepView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(label.mas_right).offset(-1);
            make.height.equalTo(label);
            make.top.equalTo(label);
            make.width.mas_equalTo(1);
        }];
        sepView.backgroundColor = kBackgroundColor;
    }
    
    UIView *topSep = [UIView new];
    [bgView addSubview:topSep];
    [topSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.width.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(0);
    }];
    topSep.backgroundColor = kBackgroundColor;
    
    
    UIView *bottomSep = [UIView new];
    [bgView addSubview:bottomSep];
    [bottomSep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-1);
        make.width.equalTo(bgView);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(0);
    }];
    bottomSep.backgroundColor = kBackgroundColor;
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getDataList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    if (self.CREATE_TIME_TYPE.length > 0) {
        contentDic[@"CREATE_TIME_TYPE"] = self.CREATE_TIME_TYPE;
    }
    if (self.CREATE_START_TIME.length > 0) {
        contentDic[@"CREATE_START_TIME"] = self.CREATE_START_TIME;
    }
    if (self.CREATE_END_TIME.length > 0) {
        contentDic[@"CREATE_END_TIME"] = self.CREATE_END_TIME;
    }
    if (self.bangDanType.length > 0) {
        contentDic[@"bangDanType"] = self.bangDanType;
    }
    if (self.tableType.length > 0) {
        contentDic[@"tableType"] = self.tableType;
    }
    if ([self.tableType isEqualToString:@"1"]) {
        if (self.C_GRPCODE.length > 0) {
            contentDic[@"C_GRPCODE"] = self.C_GRPCODE;
        }
    }
    if ([self.tableType isEqualToString:@"2"]) {
        if (self.C_ORGCODE.length > 0) {
            contentDic[@"C_ORGCODE"] = self.C_ORGCODE;
        }
    }
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/portal/funnelXq", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKLouDouDetailModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

@end
