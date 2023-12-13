//
//  MJKCustomerMandatoryViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/2.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKCustomerMandatoryViewController.h"

#import "MJKCustomReturnSubModel.h"

#import "MJKWorkReportSetCell.h"

@interface MJKCustomerMandatoryViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** dataArray*/
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation MJKCustomerMandatoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"潜客必填项设置";
    [self.view addSubview:self.tableView];
    [self HTTPRecheckSetDatas];
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
    cell.remindModel = model;
//    if ([model.C_NAME isEqualToString:@"跟进内容"]) {
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

//MARK:-http
- (void)HTTPRecheckSetDatas {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"TYPE"] = @"17";
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:dic compliation:^(id data, NSError *error) {
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            weakSelf.dataArray = [MJKCustomReturnSubModel mj_objectArrayWithKeyValuesArray:data[@"data"][@"content"]];
            
            
            [weakSelf.tableView reloadData];
            [[NewUserSession instance].configData.btListMapKh removeAllObjects];
            for (MJKCustomReturnSubModel *model in weakSelf.dataArray) {
                if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                    [[NewUserSession instance].configData.btListMapKh addObject:@{@"CODE" : model.C_VOUCHERID, @"NUMBER" : model.I_NUMBER}];
                }
                
            }
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
            /*
             意向产品    A47500_C_BTX_0001
             客户地址    A47500_C_BTX_0002
             客户微信    A47500_C_BTX_0004
             客户阶段    A47500_C_BTX_0006
             客户性别    A47500_C_BTX_0007
             来源渠道    A47500_C_BTX_0008
             渠道细分    A47500_C_BTX_0009
             */
            if ([model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"]) {
                if ([model.C_NAME hasPrefix:@"跟进内容"]) {
                    [weakSelf alertStyleWithTextField:model];
                }
            }
           
            [weakSelf HTTPRecheckSetDatas];
            
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

-(void)httpSetSeaDaysWithArray:(NSArray *)array andBlock:(void(^)(void))completeBlock {
    //    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : array} compliation:^(id data, NSError *error) {
    
        MyLog(@"%@",data);
        if ([data[@"code"] integerValue]==200) {
            //            [JRToast showWithText:data[@"message"]];
            if (completeBlock) {
                completeBlock();
            }
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
        
    }];
    
}

//开启输入
- (void)alertStyleWithTextField:(id)model {
    DBSelf(weakSelf);
    MJKCustomReturnSubModel *returnModel = (MJKCustomReturnSubModel *)model;
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入字数";
        
        textField.keyboardType = UIKeyboardTypeNumberPad;
        returnModel.I_NUMBER.length > 0 ? textField.text = returnModel.I_NUMBER : nil;
        
    }];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * arr = alertC.textFields;
        UITextField * field = arr[0];
        returnModel.I_NUMBER = field.text;
        [weakSelf httpSetSeaDaysWithArray:@[@{@"C_ID" : returnModel.C_ID, @"I_NUMBER" : returnModel.I_NUMBER,@"C_STATUS_DD_ID" : returnModel.C_STATUS_DD_ID}] andBlock:^{
            [weakSelf HTTPRecheckSetDatas];
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:determineAction];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight ) style:UITableViewStyleGrouped];
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
