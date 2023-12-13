//
//  MJKAllOrderViewController.m
//  Rebuild_newMJK
//
//  Created by huangjie on 2023/5/15.
//  Copyright © 2023 脉居客. All rights reserved.
//

#import "MJKAllOrderViewController.h"
#import "CGCOrderDetailModel.h"

#import "CustomerListTableViewCell.h"

@interface MJKAllOrderViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic,strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKAllOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关联订单";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [UITableView new];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.right.equalTo(@0);
        make.bottom.equalTo(@(-AdaptSafeBottomHeight));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[CustomerListTableViewCell class] forCellReuseIdentifier:@"CustomerListTableViewCell"];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    
    [self getAllOrder];
    
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    CGCOrderDetailModel *model = self.dataArray[indexPath.row];
    CustomerListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomerListTableViewCell"];
    cell.titleLabel.text = model.C_A41500_C_NAME;
    cell.headLabel.text = model.C_A41500_C_NAME.length > 0 ? [model.C_A41500_C_NAME substringToIndex:1] : @"";
    cell.phoneLabel.text = model.C_PHONE;
    cell.statusLabel.text = model.C_STATUS_DD_NAME;
    cell.saleLabel.text = model.C_OWNER_ROLENAME;
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ %@",model.D_ORDER_TIME, model.C_VIN];
    cell.chooseButton.hidden = NO;
    [cell.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@64);
    }];
    [[[cell.chooseButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(__kindof UIButton * _Nullable x) {
        x.selected = !x.isSelected;
        if (weakSelf.chooseOrderBlock) {
            weakSelf.chooseOrderBlock(model);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)getAllOrder {
    DBSelf(weakSelf);
    if (self.C_A41500_C_ID.length <=0){
        [JRToast showWithText:@"暂无该客户订单"];
        return;
    }
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A41500_C_ID"] = self.C_A41500_C_ID;
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkWithUrl:[NSString stringWithFormat:@"%@/api/crm/a420/getListByA415Id", HTTP_IP] parameters:contentDic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            weakSelf.dataArray = [CGCOrderDetailModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [weakSelf.tableView reloadData];
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
}

@end
