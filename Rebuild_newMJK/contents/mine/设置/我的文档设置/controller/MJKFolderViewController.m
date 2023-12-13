//
//  MJKFolderViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/7/23.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKFolderViewController.h"
#import "MJKAddShareFolderViewController.h"

#import "MJKFolderTableViewCell.h"

#import "CustomerLvevelNextFollowModel.h"
#import "MJKFolderModel.h"
#import "MJKTypeFolderModel.h"

@interface MJKFolderViewController ()<UITableViewDataSource, UITableViewDelegate,UIDocumentPickerDelegate,UIDocumentInteractionControllerDelegate>{
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
/** <#注释#>*/
@property (nonatomic, strong) NSString *C_A70600_C_ID_PARENT;
@property (nonatomic, strong) NSString *C_A70600_C_NAME_PARENT;

@end

@implementation MJKFolderViewController

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
    self.title = @"共享文档设置";
    [self.view addSubview:self.tableView];
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
    UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [addButton setTitleNormal:@"+"];
    [addButton setTitleColor:[UIColor blackColor]];
    [addButton addTarget:self action:@selector(addFolderAction)];
    addButton.titleLabel.font = [UIFont systemFontOfSize:28.f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:addButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:@"btn-返回"];
    [backButton setTitleColor:[UIColor blackColor]];
    [backButton addTarget:self action:@selector(backVCAction)];
    backButton.titleLabel.font = [UIFont systemFontOfSize:28.f];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
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
    DBSelf(weakSelf);
    if (indexPath.section == 0) {
        MJKFolderModel *model = self.folderArray[indexPath.row];
        MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
        cell.model = model;
        cell.folderNameTF.enabled = NO;
        cell.folderNameTF.borderStyle = UITextBorderStyleNone;
        
        
        cell.buttonActionBlock = ^(NSString * _Nonnull str) {
            if ([str isEqualToString:@"编辑"]) {
                
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    textField.text = model.C_A70600_C_NAME;
                }];
                
                UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSArray * arr = alertC.textFields;
                    UITextField * field = arr[0];
                    weakSelf.folderName = field.text;
                    [weakSelf HTTPUpdateMarketData:model.C_A70600_C_ID];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                
                [alertC addAction:determineAction];
                [alertC addAction:cancelAction];
                
                [self presentViewController:alertC animated:YES completion:nil];
            } else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否删除此文件夹以及其包含的所有文件" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSelf HTTPDeleteDatas:model.C_A70600_C_ID];
                }];
                
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
                
                [alertC addAction:determineAction];
                [alertC addAction:cancelAction];
                
                [weakSelf presentViewController:alertC animated:YES completion:nil];
            }
        };
        
        cell.changeValueBlock = ^(NSString * _Nonnull str) {
            weakSelf.folderName = str;
        };
        return cell;
    } else {
        MJKTypeFolderModel *model = self.typeFolderArray[indexPath.row];
        MJKFolderTableViewCell *cell = [MJKFolderTableViewCell cellWithTableView:tableView];
        cell.folderNameTF.enabled = NO;
        cell.folderNameTF.text = model.C_NAME;
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.C_WJGSPIC]];
        //设置进入需要权限可以删除操作
        
        cell.editButton.hidden = cell.deleteButton.hidden = NO;
        
        cell.buttonActionBlock = ^(NSString * _Nonnull str) {
//            if ([model.ISXG isEqualToString:@"1"]) {
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
//            }
        };
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
    if (indexPath.section == 0) {
        subID++;
        MJKFolderModel *model = self.folderArray[indexPath.row];
        if (subID == 0) {
            self.C_A70600_C_ID = @"-2";
            self.title = @"共享文档";
        } else {
            self.C_A70600_C_ID = model.C_A70600_C_ID;
            self.title = model.C_A70600_C_NAME;
        }
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - button click
- (void)backVCAction {
    if (subID == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        self.title = subID == 1 ? @"共享文档" : self.C_A70600_C_NAME_PARENT;
        self.C_A70600_C_ID = subID == 1 ? @"-2" : self.C_A70600_C_ID_PARENT;
        [self.tableView.mj_header beginRefreshing];
    }
    subID--;
}

- (void)addFolderAction {
    DBSelf(weakSelf);
//    CustomerLvevelNextFollowModel *model = self.dataArray[indexPath.row];
    UIAlertController *sheetC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *folderAcrion = [UIAlertAction actionWithTitle:@"文件夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入文件夹名称";
        }];
        
        UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSArray * arr = alertC.textFields;
            UITextField * field = arr[0];
            [weakSelf HTTPInsertFolderDatasWithName:field.text];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alertC addAction:determineAction];
        [alertC addAction:cancelAction];
        
        [weakSelf presentViewController:alertC animated:YES completion:nil];
    }];
    
    UIAlertAction *typeFolderAction = [UIAlertAction actionWithTitle:@"文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        MJKAddShareFolderViewController *vc = [[MJKAddShareFolderViewController alloc]init];
        MJKTypeFolderModel *model = [[MJKTypeFolderModel alloc]init];
        if (subID== 0) {
            model.C_A70600_C_ID = @"-2";
        } else {
            model.C_A70600_C_ID = weakSelf.C_A70600_C_ID;
        }
        vc.model = model;
        vc.type = ShareFolderAdd;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheetC addAction:folderAcrion];
    [sheetC addAction:typeFolderAction];
    [sheetC addAction:cancelAction];
    [self presentViewController:sheetC animated:YES completion:nil];
    
    
}

#pragma mark - http data
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
//- (void)HTTPGetFolderDatas {
//    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-getList"];
//    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
//    contentDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0001";
//    contentDic[@"ISPAGE"] = @"1";
//    contentDic[@"currPage"] = @"1";
//    contentDic[@"pageSize"] = [NSString stringWithFormat:@"%ld", (long)self.pagen];
//    [dict setObject:contentDic forKey:@"content"];
//    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
//    HttpManager*manager=[[HttpManager alloc]init];
//    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
//        MyLog(@"%@",data);
//        DBSelf(weakSelf);
//        if ([data[@"code"] integerValue]==200) {
//            weakSelf.dataArray = [CustomerLvevelNextFollowModel mj_objectArrayWithKeyValuesArray:data[@"content"]];
//            [weakSelf.tableView reloadData];
//        }else{
//            [JRToast showWithText:data[@"message"]];
//        }
//        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf.tableView.mj_footer endRefreshing];
//    }];
//}

- (void)HTTPGetFolderDatas {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70800WebService-getAllList"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    
    contentDic[@"C_A70600_C_ID"] = self.C_A70600_C_ID;
    
    contentDic[@"IS_CONTROL"] = @"0";
    contentDic[@"currPage"] = @"1";
    contentDic[@"pageSize"] = [NSString stringWithFormat:@"%ld", (long)self.pagen];
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

- (void)HTTPInsertFolderDatasWithName:(NSString *)name {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-insert"];
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    tempDic[@"C_ID"] = [DBObjectTools getA70600C_id];
    tempDic[@"C_NAME"] = name;
    tempDic[@"C_TYPE_DD_ID"] = @"A70600_C_TYPE_0001";
    tempDic[@"C_FATHERID"] = self.C_A70600_C_ID;
    [dict setObject:tempDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf.tableView.mj_header beginRefreshing];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
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

- (void)HTTPUpdateMarketData:(NSString *)C_ID {
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70600WebService-update"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = C_ID;
    contentDic[@"C_NAME"] = self.folderName;
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
