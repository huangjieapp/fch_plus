//
//  MJKProductChooseViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/25.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseNewCarModelsViewController.h"

#import "MJKSaleCarSourceTableViewCell.h"

#import "MJKProductShowModel.h"

#import "CGCNavSearchTextView.h"
#import "VoiceView.h"

#import "CustomerLvevelNextFollowModel.h"

@interface MJKChooseNewCarModelsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic)  UITableView *tableView;//右边显示产品tableview


@property(nonatomic,strong)CGCNavSearchTextView*CurrentTitleView;  //不做属性 警告。。
/** VoiceView*/
@property (nonatomic, strong) VoiceView *vv;

/** type array*/
@property (nonatomic, strong) NSMutableArray *typeArray;

/** pagen*/
@property (nonatomic, assign) NSInteger pagen;

@property (nonatomic, strong) NSString *tempModelType;
/** paramDic*/
@property (nonatomic, strong) NSDictionary *paramDic;
/** mainShow*/
@property (nonatomic, strong) NSArray *mainShowArray;

/** <#注释#>*/
@property (nonatomic, strong) NSArray *categoryArray;

/** bottomview*/
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MJKChooseNewCarModelsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    self.title = @"产品";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.tableView];
    [self configRefresh];
    
}


- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf HTTPGetProductList];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf HTTPGetProductList];
    }];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.mainShowArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MJKProductShowModel *model = self.mainShowArray[indexPath.row];
    MJKSaleCarSourceTableViewCell *cell = [MJKSaleCarSourceTableViewCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
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



#pragma mark - http get data
- (void)HTTPGetProductList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_TYPE_DD_ID"] = self.C_TYPE_DD_ID;
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD496PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.mainShowArray = [MJKProductShowModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            
            [weakSelf.tableView reloadData];
            
        } else {
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)commitButtonAction:(UIButton *)sender {
    //    if (self.productArray.count > 0) {
    
    for (MJKProductShowModel *model in self.mainShowArray) {
        if (model.isSelected == YES) {
            [self.productArray addObject:model];
        }
    }
    if (self.productArray.count <= 0) {
        [JRToast showWithText:@"请选择车型"];
        return;
    }
    if (self.chooseProductBlock) {
        self.chooseProductBlock(self.productArray);
    }
//    [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"productArray" object:nil userInfo:@{@"productArray" : self.productArray}];
//    }];
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToViewController:self.rootVC animated:YES];
    //    } else {
    //        [JRToast showWithText:@"请选择产品"];
    //    }
}

- (NSMutableArray *)productArray {
    if (!_productArray) {
        _productArray = [NSMutableArray array];
        
    }
    return _productArray;
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

-(UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        button.layer.cornerRadius = 5.f;
        button.backgroundColor = KNaviColor;
        [button addTarget:self action:@selector(commitButtonAction:)];
        [button setTitleNormal:@"确定"];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

@end



