//
//  MJKTelephoneRobotInfoViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/20.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKTelephoneRobotInfoViewController.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"

#import "MJKMarketViewController.h"
#import "MJKWordsArtTemplateViewController.h"
#import "MJKTelephoneRobotViewController.h"
#import "MJKCallShowDetailViewController.h"

@interface MJKTelephoneRobotInfoViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** submit button*/
@property (nonatomic, strong) UIButton *submitButton;

/** list data*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
/** 话术主题id*/
@property (nonatomic, strong)  NSString*nlpThemeId;
@end

@implementation MJKTelephoneRobotInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"呼叫任务信息";
    self.view.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSMutableDictionary *dic = self.listDataArray[indexPath.row];
    if ([dic[@"title"] isEqualToString:@"任务名称"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.keyboardType=UIKeyboardTypeDefault;
        cell.nameTitleLabel.text=dic[@"title"];   //标题
        if ([dic[@"content"] length] > 0) {
            cell.textStr = dic[@"content"];
        }
        cell.changeTextBlock = ^(NSString *textStr) {
            dic[@"content"] = textStr;
            dic[@"C_ID"] = textStr;
        };
        return cell;
    } else {
        AddCustomerChooseTableViewCell*cell=[AddCustomerChooseTableViewCell cellWithTableView:tableView];
        cell.taglabel.hidden = [dic[@"title"] isEqualToString:@"呼叫话术模板"] ? NO : YES;
        cell.nameTitleLabel.text = dic[@"title"];
        if ([dic[@"content"] length] > 0) {
            cell.textStr = dic[@"content"];
        }
        if ([dic[@"title"] isEqualToString:@"呼叫开始时间"]) {
            cell.Type = ChooseTableViewTypeAllTime;
        } else {
            cell.Type = chooseTypeNil;
        }
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            if ([dic[@"title"] isEqualToString:@"呼叫开始时间"])  {
                dic[@"content"] = str;
                dic[@"C_ID"] = postValue;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            } else if ([dic[@"title"] isEqualToString:@"呼叫话术模板"]) {
                MJKWordsArtTemplateViewController *vc = [[MJKWordsArtTemplateViewController alloc]init];
                vc.selectBackBlock = ^(NSString * _Nonnull codeStr, NSString * _Nonnull nameStr, NSString * _Nonnull nlpThemeId) {
                    dic[@"content"] = nameStr;
                    dic[@"C_ID"] = codeStr;
                    weakSelf.nlpThemeId = nlpThemeId;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            } else {
                MJKMarketViewController *vc = [[MJKMarketViewController alloc]init];
                vc.vcName = @"订单";
                vc.backSelectParameterBlock = ^(NSString *codeStr, NSString *nameStr) {
                    dic[@"content"] = nameStr;
                    dic[@"C_ID"] = codeStr;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                };
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return cell;
    }
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


#pragma mark - 提交按钮
- (void)submitButtonAction:(UIButton *)sender {
//    DBSelf(weakSelf);
    NSMutableDictionary *dic = self.listDataArray[2];
    if ([dic[@"C_ID"] length] <= 0) {
        [JRToast showWithText:@"请选择话术模块"];
        return;
    }
    
    MJKCallShowDetailViewController *vc = [[MJKCallShowDetailViewController alloc]init];
    vc.C_ID = self.getA70100C_id;
    vc.searchDataArray = self.listDataArray;
    vc.nlpThemeId = self.nlpThemeId;
    [self.navigationController pushViewController:vc animated:YES];
    
//    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:nil message:@"提交之后不可修改，请再次确认！" preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        [weakSelf HTTPSubmitData];
//    }];
//    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//    [alertC addAction:noAction];
//    [alertC addAction:yesAction];
//    [self presentViewController:alertC animated:yesAction completion:nil];
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 50) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), KScreenWidth, 54)];
        [_submitButton setTitleNormal:@"确定"];
        [_submitButton setTitleColor:[UIColor blackColor]];
        [_submitButton setBackgroundColor:KNaviColor];
        [_submitButton addTarget:self action:@selector(submitButtonAction:)];
    }
    return _submitButton;
}
    
- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
        if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0002"]) {//客户
            [_listDataArray addObject:[@{@"title" : @"任务名称", @"content" : @"客户列表的呼叫任务",@"C_ID" : @"客户列表的呼叫任务", @"id" : @"C_NAME"} mutableCopy]];
        } else if ([self.C_SOURCE_DD_ID isEqualToString:@"A70100_C_SOURCE_0000"]) {//名单
            [_listDataArray addObject:[@{@"title" : @"任务名称", @"content" : @"名单列表的呼叫任务",@"C_ID" : @"名单列表的呼叫任务", @"id" : @"C_NAME"} mutableCopy]];
        } else {//粉丝
            [_listDataArray addObject:[@{@"title" : @"任务名称", @"content" : @"粉丝列表的呼叫任务",@"C_ID" : @"粉丝列表的呼叫任务", @"id" : @"C_NAME"} mutableCopy]];
        }
        [_listDataArray addObject:[@{@"title" : @"呼叫开始时间", @"content" : [DBTools getTimeFomatFromCurrentTimeStamp], @"C_ID" : [DBTools getTimeFomatFromCurrentTimeStamp], @"id" : @"D_START_TIME"} mutableCopy]];
        [_listDataArray addObject:[@{@"title" : @"呼叫话术模板",@"id" : @"nlpEventId"} mutableCopy]];
        [_listDataArray addObject:[@{@"title" : @"发起人", @"content" : [NewUserSession instance].user.nickName, @"C_ID" : [NewUserSession instance].user.u051Id, @"id" : @"USER_ID"} mutableCopy]];
        
    }
    return _listDataArray;
}

@end
