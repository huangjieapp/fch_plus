//
//  MJKAuditRecordsViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/3/27.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAuditRecordsViewController.h"
#import "MJKAuditRecordsModel.h"
#import "MJKAuditRecordsTableViewCell.h"

@interface MJKAuditRecordsViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MJKAuditRecordsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"审批记录";
    [self.view addSubview:self.tableView];
    [self httpListData];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKAuditRecordsModel *model = self.dataArray[indexPath.row];
    MJKAuditRecordsTableViewCell *cell = [MJKAuditRecordsTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    bgView.backgroundColor = [UIColor colorWithHex:@"#62F4CD"];
    CGFloat x = 0;
    NSArray *arr = @[@"0.25", @"0.2",@"0.35",@"0.2"];
    NSArray *nameArr = @[@"审批人", @"状态",@"审批时间",@"意见"];
    for (int i = 0; i < arr.count; i++) {
        CGFloat width = KScreenWidth * [arr[i] floatValue];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(x, 0, width, 50)];
        label.text = nameArr[i];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:label];
        x = x + width;
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label.frame), 0, 1, 50)];
        view.backgroundColor = kBackgroundColor;
        [bgView addSubview:view];
    }
    
    
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - list
- (void)httpListData {
    DBSelf(weakSelf);
    NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:@"ApplicationWebService-getJingDu"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.C_ID.length > 0) {
        
        [dict setObject:self.C_ID forKey:@"C_ID"];
    } else {
        [JRToast showWithText:@"暂无审批ID"];
        return;
    }
    [mainDic setObject:dict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKAuditRecordsModel mj_keyValuesArrayWithObjectArray:data[@"returnList"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
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
