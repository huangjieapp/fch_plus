//
//  MJKFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKShareFolderDetailViewController.h"
#import "MJKFilelViewController.h"

#import "MJKFolderTableViewCell.h"

#import "MJKFolderModel.h"

@interface MJKShareFolderDetailViewController ()<UITableViewDataSource, UITableViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** 每页/条*/
@property (nonatomic, assign) NSInteger pagen;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** edit model*/
@property (nonatomic, strong) CustomerLvevelNextFollowModel *editModel;
@property (nonatomic, strong) NSIndexPath *editIndexParh;

/** 文件名更改*/
@property (nonatomic, strong) NSString *folderName;

/** <#注释#>*/
@property (nonatomic, strong) UIDocumentPickerViewController *documentPickerVC;
/** <#注释#>*/
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionC;

/** <#注释#>*/
@property (nonatomic, strong) UIView *noFolderView;
@end

@implementation MJKShareFolderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"共享文档";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.noFolderView];
    [self configRefresh];
    
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.pagen = 20;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pagen = 20;
        [weakSelf HTTPGetFolderDatas];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pagen += 20;
        [weakSelf HTTPGetFolderDatas];
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
    MJKFolderModel *model = self.dataArray[indexPath.row];
    MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
    cell.folderModel = model;
    cell.folderNameTF.enabled = NO;
    cell.editButton.hidden = cell.deleteButton.hidden = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 30)];
    label.text = @"文档目录";
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:14.f];
    [bgView addSubview:label];
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MJKFolderModel *model = self.dataArray[indexPath.row];
    MJKFilelViewController *vc = [[MJKFilelViewController alloc]init];
    vc.titleStr = model.C_NAME;
    vc.C_A70600_C_ID = model.C_A70600_C_ID;
    vc.C_A70600_C_NAME = model.C_A70600_C_NAME;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - http data
- (void)HTTPGetFolderDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70800WebService-getList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"TYPE"] = @"0";
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKFolderModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            if (weakSelf.dataArray.count > 0) {
                weakSelf.noFolderView.hidden = YES;
                weakSelf.tableView.hidden = NO;
                [weakSelf.tableView reloadData];
            } else {
                weakSelf.noFolderView.hidden = NO;
                weakSelf.tableView.hidden = YES;
            }
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


- (UIView *)noFolderView {
    if (!_noFolderView) {
        _noFolderView = [[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight - WD_TabBarHeight)];
        _noFolderView.backgroundColor = [UIColor whiteColor];
        _noFolderView.hidden = YES;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, (KScreenHeight - 30) / 2, KScreenWidth, 30)];
        label.text = @"暂无文件查看";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:14.f];
        [_noFolderView addSubview:label];
    }
    return _noFolderView;
}

@end
