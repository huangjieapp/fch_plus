//
//  MJKFolderDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFilelViewController.h"
#import "MJKAddShareFolderViewController.h"
#import "MJKFileDetailViewController.h"

#import "MJKFileTableViewCell.h"

#import "MJKFolderModel.h"

@interface MJKFilelViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UIDocumentInteractionControllerDelegate>
/** UITableView*/
@property (nonatomic, strong) UITableView *tableView;
/** searchBar*/
@property (nonatomic, strong) UISearchBar *searchBar;
/** search name*/
@property (nonatomic, strong) NSString *searchName;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** pre model*/
@property (nonatomic, strong) MJKFolderModel *preModel;

/** bottom view*/
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic,strong)UIDocumentInteractionController *document;

@end

@implementation MJKFilelViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[KUSERDEFAULT objectForKey:@"isRefresh"] isEqualToString:@"yes"]) {
        [self.tableView.mj_header beginRefreshing];
        [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = self.titleStr;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
    [self configRefresh];
    
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
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
    MJKFileTableViewCell *cell = [MJKFileTableViewCell cellWithTableView:tableView];
    cell.fileNameLabel.text = model.C_NAME;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_WJGSPIC]];
    cell.timeLabel.text = model.TSY;
    cell.downloadButton.hidden = NO;
    cell.downloadButton.tag = 100 + indexPath.row;
    [cell.downloadButton addTarget:self action:@selector(historyButtonAction:)];
    return cell;
}

//下载文件
- (void)download:(NSString *)urlStr andCompleteBlock:(void(^)(NSString *path))successBlock{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSString *url = urlStr;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSURLSessionDownloadTask *loadTask = [manger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度监听
        NSLog(@"Progress:----%.2f%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        if (successBlock) {
            successBlock(fullPath);
        }
        
        NSLog(@"fullPath:%@",fullPath);
        NSLog(@"targetPath:%@",targetPath);
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"filePath:%@",filePath);
    }];
    [loadTask resume];
}



#pragma mark 代理方法 UIDocumentInteractionControllerDelegate
//为快速预览指定控制器
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    return self;
}

//为快速预览指定View
- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    return self.view;
}

//为快速预览指定显示范围
- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    //    return self.view.frame;
    return CGRectMake(0, 0, self.view.frame.size.width, 300);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    MJKFolderModel *model = self.dataArray[indexPath.row];
    
    [self download:model.NEWESTURL andCompleteBlock:^(NSString *path) {
        [weakSelf HTTPInsertHistoryDatas:model.NEWESTID];
        dispatch_async(dispatch_get_main_queue(), ^{
            _document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
            _document.delegate = self;
            [_document presentPreviewAnimated:YES];
        });
        
    }];
    
    
}

- (void)historyButtonAction:(UIButton *)sender {
    MJKFolderModel *model = self.dataArray[sender.tag - 100];
    MJKFileDetailViewController *vc = [[MJKFileDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchName = searchText;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - http data
- (void)HTTPGetFolderDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70800WebService-getList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_A70600_C_ID"] = self.C_A70600_C_ID;
    contentDic[@"TYPE"] = @"1";
    if (self.searchName.length > 0) {
        contentDic[@"C_NAME"] = self.searchName;
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKFolderModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)HTTPDelFolderDatas:(NSString *)C_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70800WebService-delete"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = C_ID;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf HTTPGetFolderDatas];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

- (void)HTTPInsertHistoryDatas:(NSString *)C_OBJECTID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A43200WebService-insert"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = [DBObjectTools getA43200C_id];
    contentDic[@"C_OBJECTID"] = C_OBJECTID;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}


#pragma mark click button
- (void)submitButtonAction {
    NSString *fileId;
    for (MJKFolderModel *model in self.dataArray) {
        if (model.isSelected == YES) {
            fileId = model.C_ID;
        }
    }
    if (fileId.length <= 0) {
        [JRToast showWithText:@"请选择文件夹"];
        return;
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fileName" object:nil userInfo:@{@"folderName" : self.C_A70600_C_NAME , @"fileID" : fileId}];
            [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - set
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 44)];
        _searchBar.placeholder = @"搜索文件";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenHeight - SafeAreaBottomHeight - 55, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        [button setBackgroundColor:KNaviColor];
        [button setTitleColor:[UIColor blackColor]];
        [button setTitle:@"选定"];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(submitButtonAction)];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.searchBar.frame.size.height) style:UITableViewStyleGrouped];
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
