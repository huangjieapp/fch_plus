//
//  MJKCustomaSortViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/20.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import "MJKCustomaSortViewController.h"

#import "MJKCustomReturnSubModel.h"

#import "MJKWorkReportSetCell.h"

@interface MJKCustomaSortViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** titleView*/
@property (nonatomic, strong) UIView *titleView;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) MJKCustomReturnSubModel *perModel;
@end

@implementation MJKCustomaSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self initUI];
}

- (void)initUI {
    self.title = @"潜客列表排序设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    [self getList];
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
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    MJKWorkReportSetCell *cell = [MJKWorkReportSetCell cellWithTableView:tableView];
    cell.nameLabel.text = model.C_NAME;
    cell.labelLeftLayout.constant = 40;
    cell.selectImageView.hidden = NO;
    cell.openSwitchButton.hidden = YES;
    cell.selectButton.hidden = NO;
    cell.selectImageView.image = [UIImage imageNamed:[model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? @"icon_switch_check" : @"icon_switch_uncheck"];
    cell.selectButtonBlock = ^{
        if ([weakSelf.perModel.C_ID isEqualToString:model.C_ID]) {
            return ;
        }
        for (MJKCustomReturnSubModel *perModel in self.dataArray) {
           
            if ([perModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] && perModel != model) {
                perModel.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//                [weakSelf httpChangeStatusWithModel:perModel];
            }
        }
        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
        } else {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
        }
        NSMutableArray *arr = [NSMutableArray array];
        for (MJKCustomReturnSubModel *subModel in weakSelf.dataArray) {
            NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
            contentDic[@"C_ID"] = subModel.C_ID;
            contentDic[@"C_STATUS_DD_ID"] = subModel.C_STATUS_DD_ID;
            [arr addObject:contentDic];
        }
        
        weakSelf.perModel = model;
        /*
         A47500_C_KHPX_0000    客户活跃时间
         A47500_C_KHPX_0001    客户下次跟进时间
         A47500_C_KHPX_0002    客户等级
         A47500_C_KHPX_0003    客户首字母
         */
        [weakSelf updateDatasWithArray:arr andCompleteBlock:^{
            [NewUserSession instance].configData.C_KHPX = model.C_VOUCHERID;
            [weakSelf getList];
        }];
//        [weakSelf httpChangeStatusWithModel:model];
    };
//    if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
//        cell.openSwitchButton.on = YES;
//    } else {
//        cell.openSwitchButton.on = NO;
//    }
//    cell.openSwitchBlock = ^(BOOL isOn) {
//        for (MJKCustomReturnSubModel *perModel in self.dataArray) {
//            if ([perModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] && perModel != model) {
//                perModel.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//                [weakSelf httpChangeStatusWithModel:perModel];
//            }
//        }
//        if (isOn == YES) {
//            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
//        } else {
//            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//        }
//
//        [weakSelf httpChangeStatusWithModel:model];
//    };
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

#pragma mark - http
-(void)getList {
    
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic[@"TYPE"] = @"16";
    
    
    HttpManager*manager=[[HttpManager alloc]init];
    
    DBSelf(weakSelf);
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
            for (MJKCustomReturnSubModel *perModel in self.dataArray) {
                if ([perModel.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                    weakSelf.perModel = perModel;
                }
            }
        }else{
            
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)updateDatasWithArray:(NSArray *)array andCompleteBlock:(void(^)(void))completeBlock {
    //    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : array} compliation:^(id data, NSError *error) {
   
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

-(void)httpChangeStatusWithModel:(MJKCustomReturnSubModel *)model {
    DBSelf(weakSelf);
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = model.C_ID;
    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            [weakSelf getList];
            [JRToast showWithText:data[@"message"]];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

#pragma mark - set
- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 44)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 40, 44)];
        label.font = [UIFont systemFontOfSize:14.f];
        label.textColor = [UIColor blackColor];
        label.text = @"客户列表排序方式(单选):";
        [_titleView addSubview:label];
    }
        return _titleView;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - self.titleView.frame.size.height) style:UITableViewStyleGrouped];
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
