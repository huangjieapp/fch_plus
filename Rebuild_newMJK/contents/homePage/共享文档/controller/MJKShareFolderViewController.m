//
//  MJKFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKShareFolderViewController.h"
#import "MJKFileDetailViewController.h"
#import "MJKAddNewPresonalFolderViewController.h"

#import "MJKFolderTableViewCell.h"
#import "MJKFileTableViewCell.h"

#import "CustomerLvevelNextFollowModel.h"
#import "MJKFolderModel.h"
#import "MJKTypeFolderModel.h"

@interface MJKShareFolderViewController ()<UITableViewDataSource, UITableViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>{
    NSInteger subID;
}

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

/** 文件夹*/
@property (nonatomic, strong) NSArray *folderArray;
/** w类型文件夹*/
@property (nonatomic, strong) NSArray *typeFolderArray;
/** C_A70600_C_ID*/
@property (nonatomic, strong) NSString *C_A70600_C_ID;

@property (nonatomic, strong) NSString *C_A70600_C_ID_PARENT;
@property (nonatomic, strong) NSString *C_A70600_C_NAME_PARENT;
/** <#注释#>*/
@property (nonatomic, strong) UIDocumentInteractionController *document;

@end

@implementation MJKShareFolderViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.vcName isEqualToString:@"个人文档"]) {
        if ([KUSERDEFAULT objectForKey:@"isRefresh"]) {
            [self.tableView.mj_header beginRefreshing];
            [KUSERDEFAULT removeObjectForKey:@"isRefresh"];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.user_name;
    [self.view addSubview:self.tableView];
    if ([self.vcName isEqualToString:@"个人文档"]) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        [button setTitleNormal:@"+"];
        [button setTitleColor:[UIColor blackColor]];
        [button addTarget:self action:@selector(addButtonAction:)];
        button.titleLabel.font = [UIFont systemFontOfSize:28.f];
        if ([self.user_id isEqualToString:[NewUserSession instance].user.u051Id]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        }
    }
    [self configRefresh];
    
    [self configNavi];
    subID = 0;
    self.C_A70600_C_ID = @"-2";
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

- (void)configNavi {
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:@"btn-返回"];
    [backButton setTitleColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(backVCAction)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:28.f];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
}

- (void)addButtonAction:(UIButton *)sender {
    MJKAddNewPresonalFolderViewController *vc = [[MJKAddNewPresonalFolderViewController alloc]init];
    vc.C_A70600_C_ID = self.C_A70600_C_ID;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.folderArray.count;
    } else {
        return self.typeFolderArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MJKFolderModel *model = self.folderArray[indexPath.row];
        MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.folderNameTF.enabled = NO;
        cell.folderNameTF.borderStyle = UITextBorderStyleNone;
        cell.editButton.hidden = cell.deleteButton.hidden = YES;
        return cell;
    } else {
        MJKTypeFolderModel *model = self.typeFolderArray[indexPath.row];
        MJKFileTableViewCell *cell = [MJKFileTableViewCell cellWithTableView:tableView];
        cell.fileNameLabel.text = model.C_NAME;
        if ([self.vcName isEqualToString:@"公司文档"]) {
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_WJGSPIC]];
        } else {
            cell.headImageView.image = [UIImage imageNamed:@"文件图标"];
        }
        cell.timeLabel.text = model.TSY;
        cell.downloadButton.hidden = NO;
        cell.downloadButton.tag = 100 + indexPath.row;
        [cell.downloadButton addTarget:self action:@selector(historyButtonAction:)];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.vcName isEqualToString:@"个人文档"]) {
        if ([self.user_id isEqualToString:[NewUserSession instance].user.u051Id]) {
        return YES;
        }
    }
    return NO;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.section == 0) {
            MJKFolderModel *model = self.folderArray[indexPath.row];
            [weakSelf HTTPDeleteDatas:model.C_A70600_C_ID];
        } else if (indexPath.section == 1) {
            MJKTypeFolderModel *model = self.typeFolderArray[indexPath.row];
            [weakSelf HTTPDelFileDatas:model.C_ID];
        }
    }];
    action.backgroundColor = KNaviColor;
    
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (indexPath.section == 0) {
            MJKFolderModel *model = self.folderArray[indexPath.row];
            MJKAddNewPresonalFolderViewController *vc = [[MJKAddNewPresonalFolderViewController alloc]init];
            vc.A706_model = model;
            vc.C_A70600_C_ID = self.C_A70600_C_ID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
    editAction.backgroundColor = DBColor(50,151,234);
    if (indexPath.section == 0) {
        
        return @[action,editAction];
    } else {
        return @[action];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 10)];
    bgView.backgroundColor = kBackgroundColor;
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    if (indexPath.section == 0) {
        subID++;
        MJKFolderModel *model = self.folderArray[indexPath.row];
        if (subID == 0) {
            self.C_A70600_C_ID = @"-2";
            self.title = self.user_name;
        } else {
            self.C_A70600_C_ID = model.C_A70600_C_ID;
            self.title = model.C_A70600_C_NAME;
        }
        [self.tableView.mj_header beginRefreshing];
    } else {
        MJKTypeFolderModel *model = self.typeFolderArray[indexPath.row];
        if (model.NEWESTURL.length <= 0) {
            [JRToast showWithText:@"暂无文件"];
            return;
        }
        [self download:model.NEWESTURL andCompleteBlock:^(NSString *path) {
            [weakSelf HTTPInsertHistoryDatas:model.NEWESTID];
            dispatch_async(dispatch_get_main_queue(), ^{
                _document = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:path]];
                _document.delegate = self;
                [_document presentPreviewAnimated:YES];
            });
            
        }];
    }
}

- (void)HTTPDeleteDatas:(NSString *)C_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-delete"];
    [dict setObject:@{@"C_ID" : C_ID} forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.tableView.mj_header beginRefreshing];
            [JRToast showWithText:@"删除成功"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
}
//删除文件
- (void)HTTPDelFileDatas:(NSString *)C_ID {
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
            [weakSelf.tableView.mj_header beginRefreshing];
            [JRToast showWithText:@"删除成功"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
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

- (void)historyButtonAction:(UIButton *)sender {
    MJKTypeFolderModel *model = self.typeFolderArray[sender.tag - 100];
    MJKFileDetailViewController *vc = [[MJKFileDetailViewController alloc]init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - button click
- (void)backVCAction {
    if (subID == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.title = subID == 1 ? self.user_name : self.C_A70600_C_NAME_PARENT;
        self.C_A70600_C_ID = subID == 1 ? @"-2" : self.C_A70600_C_ID_PARENT;
        [self.tableView.mj_header beginRefreshing];
    }
    subID--;
}

#pragma mark - http data
- (void)HTTPGetFolderDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70800WebService-getAllList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
    contentDic[@"C_A70600_C_ID"] = self.C_A70600_C_ID;
    
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = [NSString stringWithFormat:@"%ld", (long)self.pagen];
    if ([self.vcName isEqualToString:@"个人文档"]) {
        contentDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0003";
        contentDic[@"USER_ID"] = self.user_id;
    } else {
        contentDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0001";
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.C_A70600_C_ID_PARENT = data[@"C_A70600_C_ID_PARENT"];
            weakSelf.C_A70600_C_NAME_PARENT = data[@"C_A70600_C_NAME_PARENT"];
            weakSelf.folderArray = [MJKFolderModel mj_objectArrayWithKeyValuesArray:data[@"wjj_list"]];
            weakSelf.typeFolderArray = [MJKTypeFolderModel mj_objectArrayWithKeyValuesArray:data[@"wj_list"]];
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
