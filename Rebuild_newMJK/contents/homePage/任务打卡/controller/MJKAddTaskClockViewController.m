//
//  MJKAddTaskClockViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/2/21.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKAddTaskClockViewController.h"

#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"

#import "MJKTaskClockModel.h"

@interface MJKAddTaskClockViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *cellArray;

/** <#注释#>*/
@property (nonatomic, strong) CustomerPhotoView *tableFootPhoto;
/** <#注释#>*/
@property (nonatomic, strong) MJKTaskClockModel *model;
@property (nonatomic, strong) NSArray *imageArr;
/** <#注释#>*/
@property (nonatomic, strong) UIView *bottomView;
/** <#注释#> */
@property (nonatomic, strong) NSMutableArray *imageUrlArray;
@end

@implementation MJKAddTaskClockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"新增打卡";
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    self.model = [[MJKTaskClockModel alloc]init];
    self.model.C_ID = [DBObjectTools getA46400C_id];
    
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"类型"]) {
        AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.nameTitleLabel.text = @"打卡类型";
        cell.taglabel.hidden = NO;
        cell.Type = ChooseTableViewTypeTaskClockType;
        if (self.model.C_TYPE_DD_ID.length > 0) {
            cell.textStr = self.model.C_TYPE_DD_NAME;
        }
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            weakSelf.model.C_TYPE_DD_ID = postValue;
            weakSelf.model.C_TYPE_DD_NAME = str;
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        };
        return cell;
    } else if ([cellStr isEqualToString:@"备注"]) {
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=@"备注";
        cell.mustLabel.hidden = NO;
        if (self.model.X_REMARK.length > 0) {
            cell.textView.text = self.model.X_REMARK;
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            weakSelf.model.X_REMARK = textStr;
        };
        return  cell;
    }
    return [UITableViewCell new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"备注"]) {
        return 120;
    }
    return 44;;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 160;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 180)];
    _tableFootPhoto = [CustomerPhotoView new];
    [bgView addSubview:_tableFootPhoto];
    [_tableFootPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(bgView);
        make.height.equalTo(@180);
    }];
    _tableFootPhoto.tableView = tableView;
    _tableFootPhoto.imageUrlArray = self.imageUrlArray;
    @weakify(self);
    [[self.tableFootPhoto.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        HXPhotoManager *manager = [HXPhotoManager new];
        manager.configuration.singleJumpEdit = NO;
        manager.configuration.singleSelected = YES;
        [self openPhotoLibraryWith:manager success:^(VideoAndImageModel * _Nonnull model) {
            @strongify(self);
            [self.imageUrlArray addObject:model];
            [self.tableView reloadData];
            
            
        }];
    }];
    return bgView;
}

- (void)addTaskClock {
    if (self.model.C_TYPE_DD_ID.length <= 0) {
        [JRToast showWithText:@"请选择打卡类型"];
        return;;
    }
    if (self.model.X_REMARK.length <= 0) {
        [JRToast showWithText:@"请输入备注"];
        return;;
    }
    
    DBSelf(weakSelf);
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    NSMutableDictionary *dic = [self.model mj_keyValues];
    [dic enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            contentDict[key] = obj;
        }
    }];
    
    if (self.imageUrlArray.count > 0) {
        NSMutableArray *arr = [NSMutableArray array];
        for (VideoAndImageModel *model in self.imageUrlArray) {
            [arr addObject:@{@"saveUrl": model.saveUrl}];
        }
        contentDict[@"fileList"] = arr;
    } else {
        contentDict[@"fileList"] = @[];
    }
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/crm/a464/add",HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            [MJKHttpApproval DefeatGetHttpValuesWithC_VOUCHERID:@"" andX_REMARK:@"" andC_REMARK_TYPE_DD_ID:@"" andC_OBJECT_ID:self.model.C_ID andTYPE:@"A42500_C_TYPE_0007" andSuccessBlock:^{
                [KUSERDEFAULT setObject:@"yes" forKey:@"isRefresh"];
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
    }];
    
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 55) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"类型",@"备注"];
    }
    return _cellArray;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 55 - SafeAreaBottomHeight, KScreenWidth, 55)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 45)];
        [button setTitle:@"提交" forState:UIControlStateNormal];
        [button setBackgroundColor:KNaviColor];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(addTaskClock) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:button];
    }
    return _bottomView;
}

- (NSMutableArray *)imageUrlArray {
    if (!_imageUrlArray) {
        _imageUrlArray = [NSMutableArray array];
    }
    return _imageUrlArray;
}

@end
