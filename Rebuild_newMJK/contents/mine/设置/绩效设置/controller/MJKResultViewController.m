//
//  MJKResultViewController.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKResultViewController.h"

#import "MJKCustomReturnSubModel.h"

#import "MJKSettingHeadView.h"
#import "MJKCustomReturnTableViewCell.h"


@interface MJKResultViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) MJKSettingHeadView *headerView;
@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *customArray;

@end

@implementation MJKResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableview];
    [self getListDatas];
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
    MJKCustomReturnSubModel *model = self.dataArray[indexPath.row];
    
    MJKCustomReturnTableViewCell *cell = [MJKCustomReturnTableViewCell cellWithTableView:tableView];
    cell.openSwitchButton.hidden = NO;
    cell.openSwitchButton.on = [model.C_STATUS_DD_ID isEqualToString:@"A47500_C_STATUS_0000"] ? YES : NO;
    cell.selectButton.hidden = YES;
    cell.titleLabel.text = model.C_NAME;
    cell.numberTextField.hidden = YES;
    cell.openSwitchBlock = ^(BOOL isOn) {
        if (isOn == YES) {
            [weakSelf alertvView:model andIndexPath:indexPath];
        } else {
            model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
//            [weakSelf httpChangeStatusWithModel:model andSuccessBlock:^{
//            NSMutableArray *arr = [weakSelf.customArray mutableCopy];
            for (NSMutableDictionary *dic in weakSelf.customArray) {
                if ([dic[@"C_ID"] isEqualToString:model.C_ID]) {
                    dic[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
                }
            }
            [weakSelf updateDatasCompleteBlock:^{
                [weakSelf getListDatas];
            }];
//            }];
        }
    };
    return cell;
}

- (void)alertvView:(MJKCustomReturnSubModel *)model andIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入分数" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入";
        textField.text = model.I_NUMBER;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        
    }];
    
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray * arr = alertC.textFields;
        UITextField * field = arr[0];
        
        model.C_STATUS_DD_ID = @"A47500_C_STATUS_0000";
//        [weakSelf.customArray addObject:@{@"I_NUMBER" : field.text, @"C_ID" : model.C_ID,@"C_STATUS_DD_ID" : model.C_STATUS_DD_ID}];
        for (NSMutableDictionary *dic in weakSelf.customArray) {
            if ([dic[@"C_ID"] isEqualToString:model.C_ID]) {
                dic[@"I_NUMBER"] = field.text;
                dic[@"C_STATUS_DD_ID"] = model.C_STATUS_DD_ID;
            }
        }
        [weakSelf updateDatasCompleteBlock:^{
//            [weakSelf httpChangeStatusWithModel:model andSuccessBlock:^{
                [weakSelf getListDatas];
//            }];
        }];
       
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        model.C_STATUS_DD_ID = @"A47500_C_STATUS_0001";
        [weakSelf.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [alertC addAction:determineAction];
    [alertC addAction:cancelAction];
    
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - http request
-(void)getListDatas{
    DBSelf(weakSelf);
    NSMutableDictionary*contentDict=[NSMutableDictionary dictionary];
    contentDict[@"TYPE"] = @"36";
    
    HttpManager*manager=[[HttpManager alloc]init];
    [manager getNewDataFromNetworkNOHUDWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/list", HTTP_IP] parameters:contentDict compliation:^(id data, NSError *error) {
        if ([data[@"code"] integerValue]==200) {
            if (weakSelf.dataArray.count > 0) {
                [weakSelf.dataArray removeAllObjects];
            }
            if (weakSelf.customArray.count > 0) {
                [weakSelf.customArray removeAllObjects];
            }
            NSArray *arr = data[@"data"][@"content"];
            for (NSDictionary *dic in arr) {
                MJKCustomReturnSubModel *model = [MJKCustomReturnSubModel yy_modelWithDictionary:dic];
                [weakSelf.dataArray addObject:model];
                [weakSelf.customArray addObject:[@{@"I_NUMBER" : model.I_NUMBER, @"C_ID" : model.C_ID,@"C_STATUS_DD_ID" : model.C_STATUS_DD_ID} mutableCopy]];
            }
            [weakSelf.tableview reloadData];
            
        }else{
            [JRToast showWithText:data[@"msg"]];
        }
    }];
    
    
}

-(void)updateDatasCompleteBlock:(void(^)(void))completeBlock {
//    DBSelf(weakSelf);
    HttpManager*manager=[[HttpManager alloc]init];
    [manager postNewDataFromNetworkNoHudWithUrl:[NSString stringWithFormat:@"%@/api/system/a475/editMore", HTTP_IP] parameters:@{@"array" : self.customArray} compliation:^(id data, NSError *error) {
    
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

-(void)httpChangeStatusWithModel:(MJKCustomReturnSubModel *)model andSuccessBlock:(void(^)(void))completeBlock {
//    DBSelf(weakSelf);
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
//            [weakSelf getList];
            if (completeBlock) {
                completeBlock();
            }
            [JRToast showWithText:data[@"message"]];
        }else{
            [JRToast showWithText:data[@"message"]];
        }
        
    }];
    
}

- (MJKSettingHeadView *)headerView {
    if (!_headerView) {
        _headerView = [[MJKSettingHeadView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, 30)];
        _headerView.headTitleArray = @[@"业务", @"得分"];
    }
    return _headerView;
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), KScreenWidth, KScreenHeight - NavStatusHeight - WD_TabBarHeight - self.headerView.frame.size.height)];
        _tableview.dataSource = self;
        _tableview.delegate = self;
        _tableview.tableFooterView = [[UIView alloc]init];
    }
    return _tableview;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)customArray {
    if (!_customArray) {
        _customArray = [NSMutableArray array];
    }
    return _customArray;
}


@end
