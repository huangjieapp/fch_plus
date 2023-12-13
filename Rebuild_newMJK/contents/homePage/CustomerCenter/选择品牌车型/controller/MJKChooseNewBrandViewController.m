//
//  MJKChooseBrandViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseNewBrandViewController.h"
#import "MJKChooseNewCarModelsViewController.h"

#import "MJKChooseBrandTableViewCell.h"

#import "MJKChooseNewBrandModel.h"
#import "MJKChooseNewBrandSubModel.h"

#import "MJKProductShowModel.h"

@interface MJKChooseNewBrandViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MJKChooseNewBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self httpBrandList];
    
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKChooseNewBrandSubModel *model = self.dataArray[indexPath.row];
    MJKChooseBrandTableViewCell *cell = [MJKChooseBrandTableViewCell cellWithTableView:tableView];
    [cell.brandImageView sd_setImageWithURL:[NSURL URLWithString:model.C_PICTURE_SHOW]];
    cell.brandNameLabel.text = model.C_NAME;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if ([self.rootName isEqualToString:@"品牌"]) {
        MJKChooseNewBrandSubModel *model = self.dataArray[indexPath.row];
        MJKProductShowModel *pModel = [[MJKProductShowModel alloc]init];
        pModel.C_TYPE_DD_ID = model.C_ID;
        pModel.C_TYPE_DD_NAME = model.C_NAME;
        NSMutableArray *productArray = [NSMutableArray array];
        [productArray addObject:pModel];
        if (self.chooseProductBlock) {
            self.chooseProductBlock(productArray);
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        MJKChooseNewBrandSubModel *model = self.dataArray[indexPath.row];
        MJKChooseNewCarModelsViewController *vc = [[MJKChooseNewCarModelsViewController alloc]init];
        vc.C_TYPE_DD_ID = model.C_ID;
        vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
            NSMutableArray *productArray1 = [NSMutableArray array];
            [productArray1 addObjectsFromArray:productArray];
            MJKProductShowModel *pModel = productArray1[0];
            pModel.C_TYPE_DD_ID = model.C_ID;
            pModel.C_TYPE_DD_NAME = model.C_NAME;
            if (weakSelf.chooseProductBlock) {
                weakSelf.chooseProductBlock(productArray1);
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
    //    vc.rootVC = self.rootVC;
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)httpBrandList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD706PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKChooseNewBrandSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
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
