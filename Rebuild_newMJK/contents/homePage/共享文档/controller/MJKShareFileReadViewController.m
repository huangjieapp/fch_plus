//
//  MJKCommentsViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKShareFileReadViewController.h"

#import "MJKCommentsListModel.h"

#import "MJKCommentsCell.h"

@interface MJKShareFileReadViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
/** 列表数组*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKShareFileReadViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"阅读人列表";
    [self initUI];
}

- (void)initUI {
    [self.view addSubview:self.tableView];
    [self httpGetCommentsList];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKCommentsListModel *model = self.dataArray[indexPath.row];
    MJKCommentsCell *cell = [MJKCommentsCell cellWithTableView:tableView];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

#pragma mark - get comments list
- (void)httpGetCommentsList {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A46500WebService-getReadList"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"C_OBJECTID"] = self.C_OBJECTID;
    [dict setObject:dic forKey:@"content"];
    DBSelf(weakSelf);
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:@"1"];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCommentsListModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];

}


#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - SafeAreaBottomHeight)];
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
