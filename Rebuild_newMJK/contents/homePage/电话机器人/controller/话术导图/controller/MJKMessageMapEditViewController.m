//
//  MJKMessageMapEditViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/4/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKMessageMapEditViewController.h"
#import "MJKAddCustomerTheLabelView.h"

#import "MJKMessageMapEditTextCell.h"
#import "MJKMessageEditRecordCell.h"
#import "MJKMessageMapLabelCell.h"

@interface MJKMessageMapEditViewController ()<UITableViewDataSource, UITableViewDelegate>
/** tableview*/
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MJKMessageMapEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {

        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑话术";
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MJKMessageMapEditTextCell *cell = [MJKMessageMapEditTextCell cellWithTableView:tableView];
        return cell;
    } else if (indexPath.row == 1) {
        MJKMessageEditRecordCell *cell = [MJKMessageEditRecordCell cellWithTableView:tableView];
        return cell;
    } else {
        MJKMessageMapLabelCell *cell = [MJKMessageMapLabelCell cellWithTableView:tableView];
        cell.addButtonActionBlock = ^{
            MJKAddCustomerTheLabelView *tlV = [[NSBundle mainBundle]loadNibNamed:@"MJKAddCustomerTheLabelView" owner:nil options:nil].firstObject;
            tlV.titleLabel.text = @"关键词";
            tlV.inputLabelMessageBlock = ^(NSString * _Nonnull str) {
                
            };
            [[UIApplication sharedApplication].keyWindow addSubview:tlV];
        };
        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 150;
    } else if (indexPath.row == 1) {
        return 90;
    } else {
        return 77;
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
