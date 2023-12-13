//
//  MJKFolderDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFileDetailViewController.h"
#import "MJKShareFileReadViewController.h"

#import "MJKFileTableViewCell.h"

#import "MJKTypeFolderModel.h"
#import "MJKFileDetailModel.h"

@interface MJKFileDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UIDocumentInteractionControllerDelegate>
/** UITableView*/
@property (nonatomic, strong) UITableView *tableView;
/** searchBar*/
@property (nonatomic, strong) UISearchBar *searchBar;
/** search name*/
@property (nonatomic, strong) NSString *searchName;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic,strong)UIDocumentInteractionController *document;

@end

@implementation MJKFileDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = self.model.C_NAME;
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.searchBar];
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
    MJKFileDetailModel *fileModel = self.dataArray[indexPath.row];
    MJKFileTableViewCell *cell = [MJKFileTableViewCell cellWithTableView:tableView];
    cell.fileNameLabel.text = fileModel.C_NAME;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.C_WJGSPIC]];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@在%@上传的最新版本",fileModel.C_OWNER_ROLENAME, fileModel.D_CREATE_TIME];
    cell.historyButton.hidden = cell.downloadButton.hidden = NO;
    [cell.downloadButton setImage:@"阅读记录"];
    cell.downloadButton.tag = 100 + indexPath.row;
    [cell.downloadButton addTarget:self action:@selector(downloadButtonAction:)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
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
    MJKFileDetailModel *fileModel = self.dataArray[indexPath.row];
    [self download:fileModel.C_URL andCompleteBlock:^(NSString *path) {
        [weakSelf HTTPInsertHistoryDatas:fileModel.C_ID];
        dispatch_async(dispatch_get_main_queue(), ^{
            _document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
            _document.delegate = self;
            [_document presentPreviewAnimated:YES];
        });
        
    }];
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

#pragma mark - click button
- (void)downloadButtonAction:(UIButton *)sender {
    MJKFileDetailModel *fileModel = self.dataArray[sender.tag - 100];
    MJKShareFileReadViewController *vc = [[MJKShareFileReadViewController alloc]init];
    vc.C_OBJECTID = fileModel.C_ID;
    [self.navigationController pushViewController:vc animated:YES];
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

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.searchName = searchText;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - http data
- (void)HTTPGetFolderDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A47400WebService-getList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_OBJECTID"] = self.model.C_ID;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKFileDetailModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
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

#pragma mark - set
- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, 44)];
        _searchBar.placeholder = @"搜索文件";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

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
