//
//  MJKFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChooseUpFileViewController.h"
#import "MJKFileDetailViewController.h"

#import "MJKFolderTableViewCell.h"
#import "MJKFileTableViewCell.h"

#import "CustomerLvevelNextFollowModel.h"
#import "MJKFolderModel.h"
#import "MJKTypeFolderModel.h"

#import "MJKTabView.h"

@interface MJKChooseUpFileViewController ()<UITableViewDataSource, UITableViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>{
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
@property (nonatomic, strong) NSMutableArray *typeFolderArray;
/** C_A70600_C_ID*/
@property (nonatomic, strong) NSString *C_A70600_C_ID;
@property (nonatomic, strong) NSString *C_A70600_C_NAME;

@property (nonatomic, strong) NSString *C_A70600_C_ID_PARENT;
@property (nonatomic, strong) NSString *C_A70600_C_NAME_PARENT;
@property (nonatomic, strong) UILabel *ljLabel;
/** <#注释#>*/
@property (nonatomic, strong) UIDocumentInteractionController *document;

/** bottom view*/
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation MJKChooseUpFileViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"共享文档";
    self.vcName = @"公司文档";
    [self.view addSubview:self.tableView];
    [self configRefresh];
    
    [self configNavi];
    subID = 0;
    self.C_A70600_C_ID = @"-2";
    
    [self.view addSubview:self.bottomView];
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
    DBSelf(weakSelf);
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:@"btn-返回"];
    [backButton setTitleColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(backVCAction)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:28.f];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    MJKTabView *tabView = [[MJKTabView alloc]initWithFrame:CGRectMake(0, 7, 3 * 70, 30) andNameItems:@[@"公司文档",@"个人文档"]  withDefaultIndex:0 andIsSaveItem:YES andClickButtonBlock:^(NSString * _Nonnull str) {
        CGRect tbFrame = weakSelf.tableView.frame;
        if ([str isEqualToString:@"公司文档"]) {
            weakSelf.bottomView.hidden = YES;
            if (![weakSelf.vcName isEqualToString:str]) {
                tbFrame.size.height = tbFrame.size.height + 85;
            }
        } else {
            weakSelf.user_id = [NewUserSession instance].user.u051Id;
        }
        weakSelf.tableView.frame = tbFrame;
        weakSelf.vcName = str;
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
    self.navigationItem.titleView = tabView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.vcName isEqualToString:@"个人文档"]) {
        return 1;
    }
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
        MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
        cell.folderNameTF.enabled = NO;
        cell.folderNameTF.text = model.C_NAME;
        if ([self.vcName isEqualToString:@"公司文档"]) {
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_WJGSPIC]];
        } else {
            cell.headImageView.image = [UIImage imageNamed:@"文件图标"];
        }
        //设置进入需要权限可以删除操作
        
        cell.editButton.hidden = cell.deleteButton.hidden = YES;
        cell.selectImageView.hidden = NO;
        
        return cell;
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
            self.title = @"共享文档";
        } else {
            self.C_A70600_C_ID = model.C_A70600_C_ID;
            self.C_A70600_C_NAME = model.C_A70600_C_NAME;
            self.title = model.C_A70600_C_NAME;
            
        }
        if ([self.vcName isEqualToString:@"个人文档"]) {
            if (self.bottomView.hidden == YES ) {
                self.bottomView.hidden = NO;
                CGRect tbFrame =self.tableView.frame;
                tbFrame.size.height = tbFrame.size.height - 85;
                self.tableView.frame = tbFrame;
            }
        }
        
        
        
        [self.tableView.mj_header beginRefreshing];
    } else {
        MJKTypeFolderModel *model = self.typeFolderArray[indexPath.row];
        if ([[self.fileExtension  uppercaseString] isEqualToString:model.C_WJGSNAME] || [[self.fileExtension  lowercaseString] isEqualToString:model.C_WJGSNAME]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"fileName" object:nil userInfo:@{@"folderName" : subID == 0 ? [NSString stringWithFormat:@"../%@",model.C_NAME] : [NSString stringWithFormat:@"../%@/%@", model.C_A70600_C_NAME,model.C_NAME], @"fileID" : model.C_ID , @"type" : @"公司"}];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [JRToast showWithText:@"文件类型不匹配"];
        }
        
    }
}

//- (void)HTTPInsertHistoryDatas:(NSString *)C_OBJECTID {
//    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A43200WebService-insert"];
//    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
//    contentDic[@"C_ID"] = [DBObjectTools getA43200C_id];
//    contentDic[@"C_OBJECTID"] = C_OBJECTID;
//    [dict setObject:contentDic forKey:@"content"];
//    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        DBSelf(weakSelf);
//        if ([data[@"code"] integerValue]==200) {
//
//        }else{
//            [JRToast showWithText:data[@"message"]];
//        }
//        [weakSelf.tableView.mj_header endRefreshing];
//    }];
//}
//
////下载文件
//- (void)download:(NSString *)urlStr andCompleteBlock:(void(^)(NSString *path))successBlock{
//
//    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
//    NSString *url = urlStr;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//
//    NSURLSessionDownloadTask *loadTask = [manger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        //下载进度监听
//        NSLog(@"Progress:----%.2f%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
//    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
//        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
//        if (successBlock) {
//            successBlock(fullPath);
//        }
//
//        NSLog(@"fullPath:%@",fullPath);
//        NSLog(@"targetPath:%@",targetPath);
//        return [NSURL fileURLWithPath:fullPath];
//    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
//        NSLog(@"filePath:%@",filePath);
//    }];
//    [loadTask resume];
//}
//
//
//
//#pragma mark 代理方法 UIDocumentInteractionControllerDelegate
////为快速预览指定控制器
//- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller
//{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    return self;
//}
//
////为快速预览指定View
//- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller
//{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    return self.view;
//}
//
////为快速预览指定显示范围
//- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller
//{
//    NSLog(@"%@",NSStringFromSelector(_cmd));
//    //    return self.view.frame;
//    return CGRectMake(0, 0, self.view.frame.size.width, 300);
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//- (void)historyButtonAction:(UIButton *)sender {
//    MJKTypeFolderModel *model = self.typeFolderArray[sender.tag - 100];
//    MJKFileDetailViewController *vc = [[MJKFileDetailViewController alloc]init];
//    vc.model = model;
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - button click
- (void)backVCAction {
    if (subID == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.title = subID == 1 ? @"共享文档" : self.C_A70600_C_NAME_PARENT;
        self.C_A70600_C_ID = subID == 1 ? @"-2" : self.C_A70600_C_ID_PARENT;
        if (subID == 1) {
            self.bottomView.hidden = YES;
            CGRect tbFrame =self.tableView.frame;
            tbFrame.size.height = tbFrame.size.height + 85;
            self.tableView.frame = tbFrame;
        }
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
            weakSelf.ljLabel.text = data[@"wjlj"];
            weakSelf.folderArray = [MJKFolderModel mj_objectArrayWithKeyValuesArray:data[@"wjj_list"]];
            NSArray *arr = [MJKTypeFolderModel mj_objectArrayWithKeyValuesArray:data[@"wj_list"]];
            weakSelf.typeFolderArray = [NSMutableArray array];
            for (MJKTypeFolderModel *model in arr) {
                if ([model.ISXG isEqualToString:@"1"]) {
                    [weakSelf.typeFolderArray addObject:model];
                }
            }
//            weakSelf.typeFolderArray = [MJKTypeFolderModel mj_objectArrayWithKeyValuesArray:data[@"wj_list"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)selectFolderAction {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fileName" object:nil userInfo:@{@"folderName" : self.C_A70600_C_NAME, @"fileID" : self.C_A70600_C_ID, @"type" : @"个人"}];
    [self.navigationController popToRootViewControllerAnimated:YES];
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

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 85, KScreenWidth, 85)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 20)];
        label.backgroundColor = kBackgroundColor;
        label.font = [UIFont systemFontOfSize:14.f];
        self.ljLabel = label;
        [_bottomView addSubview:label];
        
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 35, KScreenWidth - 20, 45)];
        button.backgroundColor = KNaviColor;
        [button setTitleNormal:@"选定"];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(selectFolderAction)];
        [_bottomView addSubview:button];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}


@end
