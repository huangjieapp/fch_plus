//
//  ShopsViewController.m
//  match5.0
//
//  Created by huangjie on 7/5/23.
//

#import "MJKNewGroupShopsViewController.h"
#import "DBTabBarViewController.h"

#import "ProvincesAndCityTableViewCell.h"

#import "ShopModel.h"

@interface MJKNewGroupShopsViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#> */
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#> */
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKNewGroupShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    self.title = @"集团下属门店";
    self.view.backgroundColor = [UIColor whiteColor];
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(NAVIHEIGHT));
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(@(-AdaptSafeBottomHeight));
    }];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.tableFooterView = [UIView new];
    if (@available(iOS 15.0,*)) {
        _tableView.sectionHeaderTopPadding = YES;
    }
    [_tableView registerClass:[ProvincesAndCityTableViewCell class] forCellReuseIdentifier:@"ProvincesAndCityTableViewCell"];
    
    [self getShops];
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopModel *model = self.dataArray[indexPath.row];
    ProvincesAndCityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProvincesAndCityTableViewCell"];
    cell.titleLabel.text = model.C_NAME;
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
    ShopModel *model = self.dataArray[indexPath.row];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否选择%@", model.C_NAME] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [cancelAction setValue:[UIColor darkGrayColor] forKey:@"_titleTextColor"];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [NewUserSession instance].user.C_LOCCODE = model.C_LOCCODE;
        [NewUserSession instance].user.C_LOCNAME = model.C_NAME;
        [NewUserSession instance].jobStr = @"员工";
        DBTabBarViewController*tab=[[DBTabBarViewController alloc]initWithNibName:@"DBTabBarViewController" bundle:nil];
        [UIApplication sharedApplication].keyWindow.rootViewController=tab;
    }];
    [trueAction setValue:KNaviColor forKey:@"_titleTextColor"];
    
    [ac addAction:cancelAction];
    [ac addAction:trueAction];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)getShops {
    @weakify(self);
    HttpManager *manager = [[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/crm/a403/list", HTTP_IP] parameters:@{} compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue] == 200) {
            @strongify(self);
            MyLog(@"");
            
            self.dataArray = [ShopModel mj_objectArrayWithKeyValuesArray:data[@"data"]];
            [self.tableView reloadData];
            
        } else {
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

@end
