//
//  MJKFolderDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFolderDetailViewController.h"
#import "MJKAddShareFolderViewController.h"
#import "MJKFileDetailViewController.h"

#import "MJKFolderTableViewCell.h"

#import "MJKFolderModel.h"

@interface MJKFolderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
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

@end

@implementation MJKFolderDetailViewController

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
    if (self.isUpload == YES) {
        [self.view addSubview:self.bottomView];
    } else {
        [self configNavi];
    }
}

- (void)configRefresh {
    DBSelf(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf HTTPGetFolderDatas];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)configNavi {
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [button setTitle:@"+"];
    [button setTitleColor:[UIColor blackColor]];
    button.titleLabel.font = [UIFont systemFontOfSize:28.f];
    [button addTarget:self action:@selector(addFolderAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}
    
#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
    
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKFolderModel *model = self.dataArray[indexPath.row];
    MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
    cell.folderNameTF.enabled = NO;
    cell.folderNameTF.text = model.C_NAME;
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_WJGSPIC]];
    //设置进入需要权限可以删除操作
   
    cell.editButton.hidden = cell.deleteButton.hidden = NO;
  
    //上传进入需要选择状态
    if (self.isUpload == YES) {
        cell.selectImageView.hidden = NO;
        cell.selectImageView.image = [UIImage imageNamed:model.isSelected == YES ? @"icon_1_highlight" : @"icon_1_normal"];
        cell.editButton.hidden = cell.deleteButton.hidden = YES;
    }
    cell.buttonActionBlock = ^(NSString * _Nonnull str) {
        if ([model.ISXG isEqualToString:@"1"]) {
            if ([str isEqualToString:@"编辑"]) {
                MJKAddShareFolderViewController *vc = [[MJKAddShareFolderViewController alloc]init];
                vc.type = ShareFolderEdit;
                vc.model = model;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf HTTPDelFolderDatas:model.C_ID];
                }];
                
                UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
                
                [ac addAction:noAction];
                [ac addAction:yesAction];
                [weakSelf presentViewController:ac animated:yesAction completion:nil];
            }
        }
    };
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
    MJKFolderModel *model = self.dataArray[indexPath.row];
    if (self.isUpload == YES) {
        NSString * sampleFile= [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"FileType.plist"];
        NSDictionary*  dic_sections = [NSDictionary dictionaryWithContentsOfFile:sampleFile];
        NSString *imageStr = @"疑问文件";
        NSArray *keyArray = dic_sections.allKeys;
        for (int i = 0; i < keyArray.count; i++) {
            NSString *key = keyArray[i];
            if (([self.fileExtension isEqualToString:key.lowercaseString] || [self.fileExtension isEqualToString:key.uppercaseString])) {
                imageStr = dic_sections[key];
            }
        }
        if (![model.C_WJGSNAME isEqualToString:imageStr]) {
            [JRToast showWithText:@"文件格式不匹配"];
            return;
        }
        if (self.preModel != nil && ![self.preModel.C_ID isEqualToString:model.C_ID]) {
            self.preModel.selected = NO;
        }
        model.selected = YES;
        self.preModel = model;
        [tableView reloadData];
    }
}

- (void)addFolderAction {
    MJKAddShareFolderViewController *vc = [[MJKAddShareFolderViewController alloc]init];
    
    MJKFolderModel *model = [[MJKFolderModel alloc]init];
    model.C_A70600_C_ID = self.C_A70600_C_ID;
    model.C_A70600_C_NAME = self.C_A70600_C_NAME;
    vc.model = model;
    vc.type = ShareFolderAdd;
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
    if (self.isUpload != YES) {
        contentDic[@"IS_CONTROL"] = @"0";
    }
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if (self.isUpload == YES) {
                NSArray *arr = [MJKFolderModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
                NSMutableArray *xgqxArr = [NSMutableArray array];
                for (MJKFolderModel *model in arr) {
                    if ([model.ISXG isEqualToString:@"1"]) {
                        [xgqxArr addObject:model];
                    }
                }
                weakSelf.dataArray = [xgqxArr copy];
            } else {
                weakSelf.dataArray = [MJKFolderModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
            }
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
        CGFloat height = 0;
        if (self.isUpload == YES) {
            height = 55;
        }
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchBar.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.searchBar.frame.size.height - height) style:UITableViewStyleGrouped];
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
