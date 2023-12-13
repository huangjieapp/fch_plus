//
//  MJKPushSetViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/16.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKExternalMessagePushViewController.h"
#import "MJKPushOpenSetViewController.h"//推送开启后跳转的页面
#import "MJKPushOpenFollowSetViewController.h"//跟进推送设置

#import "MJKCustomReturnSubModel.h"

#import "MJKPushSetListCell.h"

@interface MJKExternalMessagePushViewController ()<UITableViewDataSource, UITableViewDelegate> {
    NSString *typeNumber;
}
/** button array*/
@property (nonatomic, strong) NSArray *buttonArray;
/** button code array*/
@property (nonatomic, strong) NSArray *buttonCodeArray;
/** type bg view*/
@property (nonatomic, strong) UIView *typeBGView;
/** sep view*/
@property (nonatomic, strong) UIView *sepView;
/** data array*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** is edit*/
@property (nonatomic, assign) BOOL isEdit;
@end

@implementation MJKExternalMessagePushViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self HTTPSafeSetDatasWith:typeNumber];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"外部消息推送设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self configTypeButton];
    typeNumber = @"19";
    [self.view addSubview:self.tableView];
    self.isEdit = NO;
    //    [self addLeftRightItem];
}

-(void)addLeftRightItem{
    UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [leftButton setImage:[UIImage imageNamed:@"btn-返回"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(clickLeftItem:)];
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    UIBarButtonItem*item=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=item;
    
    UIButton *editButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    editButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [editButton setTitleNormal:@"编辑"];
    [editButton setTitleColor:[UIColor blackColor]];
    [editButton addTarget:self action:@selector(editButtonAction:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:editButton];
    
    
}
#pragma mark 左侧返回按钮
- (void)clickLeftItem:(UIButton *)sender {
    if (self.isEdit == YES) {
        self.isEdit = NO;
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        [self.tableView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark 右侧编辑按钮
- (void)editButtonAction:(UIButton *)sender {
    self.isEdit = YES;
    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    [self.tableView reloadData];
}
#pragma mark - 配置类型view
- (void)configTypeButton {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 40)];
    self.typeBGView = bgView;
    bgView.backgroundColor = kBackgroundColor;
    [self.view addSubview:bgView];
    CGFloat width = KScreenWidth / self.buttonArray.count;
    for (int i = 0; i < self.buttonArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i * width, 0, width, bgView.frame.size.height)];
        [bgView addSubview:button];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [button setTitleColor:[UIColor darkGrayColor]];
        [button setTitleNormal:self.buttonArray[i]];
        [button addTarget:self action:@selector(selectTypeButtonAction:)];
        button.tag = [self.buttonCodeArray[i] integerValue] + 100;
        if (i == 0) {
            UIView *sepView = [[UIView alloc]initWithFrame:CGRectMake(0, bgView.frame.size.height - 3, width, 1)];
            self.sepView = sepView;
            sepView.backgroundColor = KNaviColor;
            [bgView addSubview:sepView];
        }
    }
}
#pragma mark - 选择类型
- (void)selectTypeButtonAction:(UIButton *)sender {
    CGRect sepRect = self.sepView.frame;
    sepRect.origin.x = sender.frame.origin.x;
    self.sepView.frame = sepRect;
    typeNumber = [NSString stringWithFormat:@"%ld",sender.tag - 100];
    [self HTTPSafeSetDatasWith:typeNumber ];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    MJKPushSetListCell *cell = [MJKPushSetListCell cellWithTableView:tableView];
    cell.isEdit = self.isEdit;
    cell.model = model;
    
    cell.openSwitchBlock = ^(BOOL isOn) {
        model.C_STATUS_DD_ID = isOn == YES ? @"A47500_C_STATUS_0000" : @"A47500_C_STATUS_0001";
        [weakSelf httpOpenOrClosePush:model andCompleteBlock:^{
            NSMutableArray *arr = [NewUserSession instance].configData.khtsList;
            if (isOn == YES) {
                if (![arr containsObject:model.C_VOUCHERID]) {
                    [arr addObject:model.C_VOUCHERID];
                }
            } else {
                if ([arr containsObject:model.C_VOUCHERID]) {
                    [arr removeObject:model.C_VOUCHERID];
                }
            }
            [NewUserSession instance].configData.khtsList = arr;
        }];
    };
    //    cell.editButtonBlock = ^{
    //        if ([model.C_VOUCHERID isEqualToString:@"A47500_C_YYTS_0005"] || [model.C_VOUCHERID isEqualToString:@"A47500_C_DDTS_0006"] || [model.C_VOUCHERID isEqualToString:@"A47500_C_RWTS_0003"] || [model.C_VOUCHERID isEqualToString:@"A47500_C_RBTS_0000"] ||[typeNumber isEqualToString:@"13"]) {
    //            MJKPushOpenFollowSetViewController *vc = [[MJKPushOpenFollowSetViewController alloc]init];
    //            vc.typeNumber = model.C_VOUCHERID;
    //            vc.detailModel = model;
    //            [weakSelf.navigationController pushViewController:vc animated:YES];
    //        } else {
    //            MJKPushOpenSetViewController *vc = [[MJKPushOpenSetViewController alloc]init];
    //            vc.detailModel = model;
    //            [weakSelf.navigationController pushViewController:vc animated:YES];
    //        }
    //    };
    return cell;
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
#pragma mark - http 配置项列表
- (void)HTTPSafeSetDatasWith:(NSString *)type {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = type;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

- (void)httpOpenOrClosePush:(MJKCustomReturnSubModel *)model andCompleteBlock:(void(^)(void))completeBlock {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_ID"] = model.C_ID;
    dic[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    [dict setObject:dic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            //            [JRToast showWithText:data[@"message"]];
            [weakSelf.tableView reloadData];
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

- (NSArray *)buttonArray {
    if (!_buttonArray) {
        _buttonArray = [NSArray arrayWithObjects:@"流量",@"预约",@"任务",@"订单", nil];
    }
    return _buttonArray;
}
- (NSArray *)buttonCodeArray {
    if (!_buttonCodeArray) {
        _buttonCodeArray = [NSArray arrayWithObjects:@"19",@"20",@"22",@"21", nil];
    }
    return _buttonCodeArray;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeBGView.frame), KScreenWidth, KScreenHeight - SafeAreaBottomHeight - WD_TabBarHeight - NavStatusHeight - self.typeBGView.frame.size.height) style:UITableViewStyleGrouped];
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
