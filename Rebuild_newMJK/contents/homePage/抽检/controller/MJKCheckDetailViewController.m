//
//  MJKTaskClockDetailViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2021/2/22.
//  Copyright © 2021 脉居客. All rights reserved.
//

#import "MJKCheckDetailViewController.h"

#import "AddCustomerChooseTableViewCell.h"
#import "CGCNewAppointTextCell.h"

#import "MJKPhotoView.h"

#import "MJKTaskClockModel.h"

@interface MJKCheckDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
/** <#注释#>*/
@property (nonatomic, strong) UITableView *tableView;
/** <#注释#>*/
@property (nonatomic, strong) MJKTaskClockModel *model;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *cellArray;
/** <#注释#>*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;
@end

@implementation MJKCheckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"抽检详情";
    [self.view addSubview:self.tableView];
    [self getCheckDetail];
}

- (void)getCheckDetail {
   DBSelf(weakSelf);
   NSMutableDictionary*mainDic=[DBObjectTools getAddressDicWithAction:@"A72800WebService-getBeanById"];
   NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    if (self.C_ID.length > 0) {
        contentDict[@"C_ID"] = self.C_ID;
    }
   [mainDic setObject:contentDict forKey:@"content"];
   NSString*encodeStr=[DBObjectTools getPostStringAddressWithMainDict:mainDic withtype:nil];
   HttpManager*manager=[[HttpManager alloc]init];
   [manager postDataFromNetworkNoHudWithUrl:encodeStr parameters:nil compliation:^(id data, NSError *error) {
       MyLog(@"%@",data);
       if ([data[@"code"] integerValue]==200) {
           weakSelf.model = [MJKTaskClockModel mj_objectWithKeyValues:data];
           weakSelf.tableFootPhoto.imageURLArray = @[weakSelf.model.C_VOUCHERID];
           [weakSelf.tableView reloadData];
       }else{
           [JRToast showWithText:data[@"message"]];
       }
       
   }];
   
   
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
    AddCustomerChooseTableViewCell *cell = [AddCustomerChooseTableViewCell cellWithTableView:tableView];
    cell.chooseTextField.enabled = NO;
    cell.arrowImage.hidden = YES;
    cell.nameTitleLabel.text = cellStr;
    if ([cellStr isEqualToString:@"类型"]) {
        cell.textStr = self.model.C_TYPE_DD_NAME;
    } else if ([cellStr isEqualToString:@"不合格原因"]) {
        cell.textStr = self.model.C_BHGYY_DD_NAME;
    } else if ([cellStr isEqualToString:@"备注"]) {//备注
        CGCNewAppointTextCell*cell=[CGCNewAppointTextCell cellWithTableView:tableView];
        cell.topTitleLabel.text=@"备注";
        if (self.model.X_REMARK.length > 0) {
            cell.textView.text = self.model.X_REMARK;
        }
        cell.textView.editable = NO;
        return  cell;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellStr = self.cellArray[indexPath.row];
    if ([cellStr isEqualToString:@"备注"]) {
        return 120;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (self.model.urlList.count > 0) {
        return 150;
    }
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (self.model.urlList.count > 0) {
        return self.tableFootPhoto;
    }
    return nil;
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

- (NSArray *)cellArray {
    if (!_cellArray) {
        _cellArray = @[@"类型",@"不合格原因",@"备注"];
    }
    return _cellArray;
}

- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 160)];
        _tableFootPhoto.isEdit = NO;
        _tableFootPhoto.isCamera = NO;
        _tableFootPhoto.rootVC = self;
    }
    return _tableFootPhoto;
};


@end
