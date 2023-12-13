//
//  MJKCustomReturnViewController.m
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/12.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import "MJKPersonalPerformanceTargetViewController.h"
#import "MJKSettingHeadView.h"

#import "MJKAddFlowTableViewCell.h"
#import "MJKCustomReturnTableViewCell.h"
#import "MJKPersonalPerformanceTargetModel.h"

#import "MJKCustomReturnSubModel.h"
#import "MJKWorkReportSetCell.h"

@interface MJKPersonalPerformanceTargetViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *customReturnArray;//客户回访类型(A类...)
@property (nonatomic, strong) MJKSettingHeadView *headView;
@property (nonatomic, strong) MJKCustomReturnModel *customModel;
@property (nonatomic, strong) UILabel *yearMonthLabel;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation MJKPersonalPerformanceTargetViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self HTTPGetPerformanceDatas];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人业绩目标设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)initUI {
    self.headView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tableView];
//    [self initPanGR];
}

- (void)initPanGR {
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
    leftSwipeGR.delegate = self;
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipeGR];
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeData:)];
    rightSwipeGR.delegate = self;
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipeGR];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(80, NavStatusHeight, KScreenWidth - 160, 30)];
    //    bgView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:bgView];
    
    
    UILabel *yearMonthLabel = [[UILabel alloc]initWithFrame:CGRectMake((bgView.frame.size.width-100) / 2, 0, 100, 30)];
    //    yearMonthLabel.backgroundColor = [UIColor redColor];
    self.yearMonthLabel = yearMonthLabel;
    yearMonthLabel.tag = 2018;
    [bgView addSubview:yearMonthLabel];
    yearMonthLabel.text = [self nowYearMonth];
    yearMonthLabel.font = [UIFont systemFontOfSize:14.f];
    yearMonthLabel.textAlignment = NSTextAlignmentCenter;
    yearMonthLabel.textColor = DBColor(142, 142, 142);
    
    UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(yearMonthLabel.frame) - 20, 0, 20, 30)];
    UIButton *rightButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(yearMonthLabel.frame), 0, 20, 30)];
    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
    [rightButton setTitle:@">" forState:UIControlStateNormal];
    [rightButton setTitleColor:DBColor(142, 142, 142) forState:UIControlStateNormal];
    [bgView addSubview:leftButton];
    [bgView addSubview:rightButton];
    [leftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonClick:(UIButton *)sender {
    NSString *yearMonth = self.yearMonthLabel.text;
    NSString *year = [yearMonth substringToIndex:4];
    NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
    if ([sender.titleLabel.text isEqualToString:@"<"]) {
        month = [NSString stringWithFormat:@"%02d",month.intValue-1];
        if (month.intValue < 1) {
            month = @"12";
            year = [NSString stringWithFormat:@"%d",year.intValue-1];
        }
    } else {
        month = [NSString stringWithFormat:@"%02d",month.intValue+1];
        if (month.intValue > 12) {
            month = @"01";
            year = [NSString stringWithFormat:@"%d",year.intValue+1];
        }
    }
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
    [self HTTPGetPerformanceDatas];
    
    NSString *nowYearMonth = [self nowYearMonth];
    NSString *nowYear = [nowYearMonth substringToIndex:4];
    NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
    if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
}

- (void)changeData:(UISwipeGestureRecognizer *)swipe {
    NSString *yearMonth = self.yearMonthLabel.text;
    NSString *year = [yearMonth substringToIndex:4];
    NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
    if (swipe.direction ==  UISwipeGestureRecognizerDirectionLeft) {
        month = [NSString stringWithFormat:@"%02d",month.intValue+1];
        if (month.intValue > 12) {
            month = @"01";
            year = [NSString stringWithFormat:@"%d",year.intValue+1];
        }
        
        NSLog(@"右 %@   %@", year,month );
    } else if (swipe.direction ==  UISwipeGestureRecognizerDirectionRight) {
        month = [NSString stringWithFormat:@"%02d",month.intValue-1];
        if (month.intValue < 1) {
            month = @"12";
            year = [NSString stringWithFormat:@"%d",year.intValue-1];
        }
        NSLog(@"左 %@   %@", year,month);
    }
    self.yearMonthLabel.text = [NSString stringWithFormat:@"%@年%@月",year,month];
    [self HTTPGetPerformanceDatas];
    
    NSString *nowYearMonth = [self nowYearMonth];
    NSString *nowYear = [nowYearMonth substringToIndex:4];
    NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
    if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    } else {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
    }
    
    
}

- (NSString *)nowYearMonth {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy年MM月";
    return [dateFormatter stringFromDate:date];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // 点击的view的类名
    //    NSLog(@"%@", NSStringFromClass([touch.view class]));
    // 点击了tableViewCell，view的类名为UITableViewCellContentView，则不接收Touch点击事件
    //    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
    //        return NO;
    //    }
    NSLog(@"%@",NSStringFromClass([touch.view class]));
    return  YES;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
        
//    MJKPersonalPerformanceTargetModel *model = self.dataArray[indexPath.row];
//    MJKCustomReturnTableViewCell *cell = [MJKCustomReturnTableViewCell cellWithTableView:tableView];
//    [cell updataNumberCell:model];
//
//    //        cell.openSwitchButton.enabled = [self isEdit];
//    cell.openSwitchButton.tag = indexPath.row;
//    cell.numLabel.hidden = model.I_TARGETNUMBER.doubleValue <= 0.0 ? YES : NO;
//    cell.numLabel.text = model.I_TARGETNUMBER;
//    cell.openSwitchBlock = ^(BOOL isOn) {
//
//        if (isOn == YES) {
//            model.C_SATUS_DD_ID = @"A70900_C_STATUS_0000";
//            if ([self isEdit] == YES && model.I_TARGETNUMBER.doubleValue <= 0.0) {
//                [weakSelf alertvView:indexPath.row];
//            } else {
//                [weakSelf updateDatasWithArray:model andCompleteBlock:^{
//                    [weakSelf HTTPGetPerformanceDatas];
//                }];
//            }
//        } else {
//            model.C_SATUS_DD_ID = @"A70900_C_STATUS_0001";
//            [weakSelf updateDatasWithArray:model andCompleteBlock:^{
//                [weakSelf HTTPGetPerformanceDatas];
//            }];
//        }
//    };
//    return cell;
    
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    MJKWorkReportSetCell *cell = [MJKWorkReportSetCell cellWithTableView:tableView];
    cell.remindModel = model;
    
//    if ([model.C_NAME isEqualToString:@"今日备注"] || [model.C_NAME isEqualToString:@"计划备注"]) {
//        cell.nameLabel.text = [NSString stringWithFormat:@"%@ %@字", model.C_NAME, model.I_NUMBER];
//    }
    cell.openSwitchBlock = ^(BOOL isOn) {
        if (isOn == YES) {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
        } else {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
        }
        [weakSelf httpSetRecheck:model];
    };
    return cell;
    
}

- (void)alertvView:(NSInteger)tag {
    DBSelf(weakSelf);
    MJKPersonalPerformanceTargetModel *model = self.dataArray[tag];
    MJKCustomReturnTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"当月只能填写一次,请谨慎输入数量" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入目标量";
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if (model.I_TARGETNUMBER.doubleValue > 0.0) {
            textField.text = model.I_TARGETNUMBER;
        }
        
    }];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * arr = alertC.textFields;
        UITextField * field = arr[0];
        model.I_TARGETNUMBER = field.text;
        [weakSelf updateDatasWithArray:model andCompleteBlock:^{
            [weakSelf HTTPGetPerformanceDatas];
        }];
        
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        model.C_SATUS_DD_ID = @"A70900_C_STATUS_0001";
        cell.openSwitchButton.on = NO;
    }];
    
    [alertC addAction:determineAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (BOOL)isEdit {
    NSString *yearMonth = self.yearMonthLabel.text;
    NSString *year = [yearMonth substringToIndex:4];
    NSString *month = [yearMonth substringWithRange:NSMakeRange(5, 2)];
    
    NSString *nowYearMonth = [self nowYearMonth];
    NSString *nowYear = [nowYearMonth substringToIndex:4];
    NSString *nowMonth = [nowYearMonth substringWithRange:NSMakeRange(5, 2)];
    if (nowMonth.intValue > month.intValue && nowYear.intValue >= year.intValue) {
        return NO;
    } else {
        return YES;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - HTTP request


- (void)HTTPGetPerformanceDatas {
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:@{@"TYPE" : @"49"} compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        DBSelf(weakSelf);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            [weakSelf.tableView reloadData];
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
}

-(void)httpSetRecheck:(MJKCustomReturnSubModel *)model {
    DBSelf(weakSelf);
    NSMutableDictionary*mtDict=[DBObjectTools getAddressDicWithAction:@"A47500WebService-updateStatus"];
    NSMutableDictionary*contentDict = [NSMutableDictionary dictionary];
    contentDict[@"C_ID"] = model.C_ID;
    contentDict[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
    /*
     NSMutableArray *arr = [NSMutableArray array];
     for (MJKCustomReturnSubModel *subModel in weakSelf.dataArray) {
     NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
     contentDic[@"C_ID"] = subModel.C_ID;
     contentDic[@"C_STATUS_DD_ID"] = subModel.C_STATUS_DD_ID;
     [arr addObject:contentDic];
     }
     */
    [mtDict setObject:contentDict forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:mtDict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            
            [self HTTPGetPerformanceDatas];
            
            
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

-(void)updateDatasWithArray:(MJKPersonalPerformanceTargetModel *)model andCompleteBlock:(void(^)(void))completeBlock {
    //    DBSelf(weakSelf);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    dateFormatter.dateFormat = @"yyyy年MM月";
    NSDate *date = [dateFormatter dateFromString:self.yearMonthLabel.text];
    dateFormatter.dateFormat = @"yyyy-MM";
    NSString *dateStr = [dateFormatter stringFromDate:date];
    
    NSMutableDictionary*dict=[DBObjectTools getAddressDicWithAction:@"A70900WebService-update"];
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    contentDic[@"C_ID"] = model.C_ID.length > 0 ? model.C_ID : [DBObjectTools getA70900C_id];
    contentDic[@"C_YEARMONTH"] = model.C_YEARMONTH.length > 0 ? model.C_YEARMONTH : dateStr;
    contentDic[@"C_TYPE_DD_ID"] = model.C_TYPE_DD_ID;
    contentDic[@"C_SATUS_DD_ID"] = model.C_SATUS_DD_ID;
    contentDic[@"I_TARGETNUMBER"] = model.I_TARGETNUMBER;
    [dict setObject:contentDic forKey:@"content"];
    NSString*encodeUrlStr=[DBObjectTools getPostStringAddressWithMainDict:dict withtype:nil];
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postDataFromNetworkNoHudWithUrl:encodeUrlStr parameters:nil compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"message"]];
        }
    }];
    
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight , KScreenWidth, KScreenHeight - 64 ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


@end
