//
//  MJKNormalEmployeesViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/12.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKDailyTimeViewController.h"
#import "MJKNewSelectHourView.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKClueListSubModel.h"

#import "MJKRecheckTableViewCell.h"

@interface MJKDailyTimeViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
/** <#注释#>*/
@property (nonatomic, strong) NSString *timeStr;
@end

@implementation MJKDailyTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"日报发布时间设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self HTTPDailyTimeDatas];
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
    MJKRecheckTableViewCell *cell = [MJKRecheckTableViewCell cellWithTableView:tableView];
    cell.titleLabel.text = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0001"] ? model.C_NAME : [NSString stringWithFormat:@"工作圈日报发布时间为%@-%@，在结束时间的前%@小时推送提醒",model.C_FIRSTPUSH,model.C_SECONDPUSH,model.I_NUMBER];
    cell.titleLabel.numberOfLines = 0;
    [cell.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(cell.switchButton.mas_left);
    }];
    if (self.timeStr.length > 0) {
        cell.nameLabel.hidden = YES;
        cell.nameLabel.text = self.timeStr;
    } else if (model.C_FIRSTPUSH.length > 0 && model.C_SECONDPUSH.length > 0) {
        cell.nameLabel.hidden = YES;
        cell.nameLabel.text = [model.C_FIRSTPUSH stringByAppendingString:[NSString stringWithFormat:@"-%@",model.C_SECONDPUSH]];
    }
    __block MJKRecheckTableViewCell *blockCell = cell;
    cell.switchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0001"] ? NO : YES;
    cell.switchButtonActionBlock = ^{
        if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//            model.C_FIRSTPUSH = @"";
//            model.C_SECONDPUSH = @"";
            weakSelf.timeStr = @"";
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf httpSetRecheck:model];
        } else {
            MJKNewSelectHourView * dateView=[[MJKNewSelectHourView alloc] initWithFrame:self.view.bounds withStart:^{
                
            } withEnd:^{
                
                
            } withHour:^{
                
            } withSure:^(NSString *start, NSString *end, NSString *hour) {
                MyLog(@"11--%@   22--%@",start,end);
                model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
                model.I_NUMBER = hour;
                model.C_FIRSTPUSH = start;
                model.C_SECONDPUSH = end;
                weakSelf.timeStr = [model.C_FIRSTPUSH stringByAppendingString:[NSString stringWithFormat:@"-%@",model.C_SECONDPUSH]];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf httpSetRecheck:model];
            }];
            dateView.clickCancelBlock = ^{
                blockCell.switchButton.on = NO;
            };
            dateView.startStr = model.C_FIRSTPUSH;
            dateView.endStr = model.C_SECONDPUSH;
            dateView.hourStr = model.I_NUMBER;
            
            dateView.rootVC = self;
            [weakSelf.view addSubview:dateView];
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

- (void)HTTPDailyTimeDatas {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = @"31";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)httpSetRecheck:(MJKCustomReturnSubModel *)model {
    //    DBSelf(weakSelf);
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = model.C_ID;
    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    
    contentDict[@"C_FIRSTPUSH"] = model.C_FIRSTPUSH;
    contentDict[@"C_SECONDPUSH"] = model.C_SECONDPUSH;
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if ([model.C_NAME isEqualToString:@"日报发布时间设置"]) {
                
            }
            [JRToast showWithText:@"操作成功"];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}


#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight) style:UITableViewStyleGrouped];
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
