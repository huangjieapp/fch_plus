//
//  MJKChooseBrandViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/12/31.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseBrandViewController.h"
#import "MJKChooseCarModelsViewController.h"

#import "MJKChooseBrandTableViewCell.h"

#import "MJKChooseBrandModel.h"
#import "MJKChooseBrandSubModel.h"

@interface MJKChooseBrandViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *indexArr;
/** <#注释#>*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MJKChooseBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择品牌";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self httpBrandList];
    
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArray[section];
    NSArray *arr = dic[@"content"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = dic[@"content"];
    MJKChooseBrandSubModel *subModel =arr[indexPath.row];
    MJKChooseBrandTableViewCell *cell = [MJKChooseBrandTableViewCell cellWithTableView:tableView];
    [cell.brandImageView sd_setImageWithURL:[NSURL URLWithString:subModel.C_PICTURE_SHOW]];
    cell.brandNameLabel.text = subModel.C_NAME;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.dataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 20)];
    label.textColor = [UIColor darkGrayColor];
    label.font = [UIFont systemFontOfSize:14.f];
    label.text = dic[@"PY"];
    [bgView addSubview:label];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

//添加索引栏标题数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray * arr=[NSMutableArray array];
    for (NSDictionary *dic in self.dataArray) {
        [arr addObject:dic[@"PY"]];
    }
    
    return arr;

}


//点击索引栏标题时执行
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    
    NSInteger count=0;
    
    for (NSDictionary *dic in self.dataArray) {
        
        if ([[dic[@"PY"] uppercaseString] hasPrefix:title]) {
            return count;
        }
        
        count++;
    }
    
    
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = dic[@"content"];
    MJKChooseBrandSubModel *subModel =arr[indexPath.row];
    MJKChooseCarModelsViewController *vc = [[MJKChooseCarModelsViewController alloc]init];
    vc.C_TYPE_DD_ID = subModel.C_ID;
    vc.C_TYPE_DD_NAME = subModel.C_NAME;
    vc.chooseProductBlock = ^(NSArray * _Nonnull productArray) {
        if (weakSelf.chooseProductBlock) {
            weakSelf.chooseProductBlock(productArray);
        }
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
//    vc.rootVC = self.rootVC;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)httpBrandList {
    DBSelf(weakSelf);
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:HTTP_SYSTEMD706PPLIST parameters:contentDic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            MyLog(@"");
            NSArray *arr = [MJKChooseBrandSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"list"]];
            NSArray *sortArray = [arr  sortedArrayUsingComparator:^NSComparisonResult(MJKChooseBrandSubModel  *model ,MJKChooseBrandSubModel *model1)

               {

           //          NSLog(@"%@~%@",obj1,obj2); //A~B，C~D

                     return [model.C_PY compare:model1.C_PY options:NSLiteralSearch]; //升序

                 }];
            weakSelf.indexArr = [NSMutableArray array];
            for (MJKChooseBrandSubModel *model in sortArray) {
                if (![weakSelf.indexArr containsObject:model.C_PY]) {
                    [weakSelf.indexArr addObject:model.C_PY];
                }
            }
            for (NSString *str in weakSelf.indexArr) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"PY"] = str;
                NSMutableArray *sArr = [NSMutableArray array];
                for (MJKChooseBrandSubModel *model in sortArray) {
                    if ([model.C_PY isEqualToString:str]) {
                        [sArr addObject:model];
                    }
                }
                dic[@"content"] = sArr;
                [weakSelf.dataArray addObject:dic];
            }
            
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}


@end
