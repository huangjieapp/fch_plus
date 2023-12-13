//
//  MJKAddReimbursementViewController.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/22.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKAddReimbursementViewController.h"
#import "CGCOrderListVC.h"

#import "AddCustomerInputTableViewCell.h"
#import "AddCustomerChooseTableViewCell.h"
#import "MJKClueMemoInDetailTableViewCell.h"

#import "MJKPhotoView.h"

@interface MJKAddReimbursementViewController ()<UITableViewDataSource, UITableViewDelegate>
/** list data array*/
@property (nonatomic, strong) NSMutableArray *listDataArray;
/** type select*/
@property (nonatomic, strong) NSString *typeStr;
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
/** selectTypeView*/
@property (nonatomic, strong) UIView *selectTypeView;
/** MJKPhotoView*/
@property (nonatomic, strong) MJKPhotoView *tableFootPhoto;

/** submit button*/
@property (nonatomic, strong) UIButton *submitButton;
@end

@implementation MJKAddReimbursementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    self.title = @"新增报销";
    
    [self configSelectTypeView];
}

- (void)configSelectTypeView {
    UIView *typeView = [[UIView alloc]initWithFrame:self.view.frame];
    typeView.backgroundColor = kBackgroundColor;
    [self.view addSubview:typeView];
    self.selectTypeView = typeView;
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake((KScreenWidth - 200) / 2, 200 + (i * 70), 200, 50)];
        [button setTitleNormal:@[@"订单相关费用", @"门店日常费用"][i]];
        [button setTitleColor:[UIColor blackColor]];
        [button setBackgroundColor:KNaviColor];
        button.layer.cornerRadius = 5.f;
        [button addTarget:self action:@selector(selectTypeAction:)];
        [self.view addSubview:button];
    }
}

#pragma mark - 选择费用类型
- (void)selectTypeAction:(UIButton *)sender {
    self.listDataArray = nil;
    if ([sender.titleLabel.text isEqualToString:@"订单相关费用"]) {
        self.typeStr = @"order";
        self.title = @"新增订单报销";
    } else {
        self.typeStr = @"other";
        self.title = @"新增其他报销";
    }
    self.selectTypeView.hidden = YES;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.submitButton];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listDataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr = self.listDataArray[section][@"content"];
    return arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    NSArray *arr = self.listDataArray[indexPath.section][@"content"];
    NSMutableDictionary *dic = arr[indexPath.row];
    if ([dic[@"title"] isEqualToString:@"备注"]) {
        MJKClueMemoInDetailTableViewCell *memoCell = [MJKClueMemoInDetailTableViewCell cellWithTableView:tableView];
        memoCell.titleLabel.text = @"备注";
        memoCell.memoTextView.editable = YES;
        memoCell.titleBgView.backgroundColor = kBackgroundColor;
        if([dic[@"content"] length] > 0){
            memoCell.memoTextView.text=dic[@"content"];
        }
        [memoCell setBackTextViewBlock:^(NSString *str){
           dic[@"content"] = str;
        }];
        return memoCell;
    } else if ([dic[@"title"] isEqualToString:@"报销金额"] || [dic[@"title"] isEqualToString:@"报销说明"]) {
        AddCustomerInputTableViewCell *cell = [AddCustomerInputTableViewCell cellWithTableView:tableView];
        cell.inputTextField.keyboardType=[dic[@"title"] isEqualToString:@"报销金额"] ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
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
        cell.taglabel.hidden = YES;
        cell.nameTitleLabel.text = dic[@"title"];
        cell.isTitle = YES;
        if ([dic[@"content"] length] > 0) {
            cell.textStr = dic[@"content"];
        }
        if ([dic[@"title"] isEqualToString:@"付款时间"]) {
            cell.Type = ChooseTableViewTypeAllTime;
        } else if ([dic[@"title"] isEqualToString:@"选择订单"]) {
            cell.Type = chooseTypeNil;
        }
        cell.chooseBlock = ^(NSString *str, NSString *postValue) {
            MyLog(@"str-- %@      post---%@",str,postValue);
            if ([dic[@"title"] isEqualToString:@"选择订单"]) {
                CGCOrderListVC *vc = [[CGCOrderListVC alloc]init];
                vc.isTab = @"无";
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }
        };
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arr = self.listDataArray[indexPath.section][@"content"];
    NSMutableDictionary *dic = arr[indexPath.row];
    if ([dic[@"title"] isEqualToString:@"分类"]) {
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == self.listDataArray.count - 1) {
        return 120 ;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0 || section == self.listDataArray.count - 1) {
        return .1f;
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == self.listDataArray.count - 1 - 1) {
        return 50;
    } else if (section == self.listDataArray.count - 1) {
        return 165;
    }
    return .1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = self.listDataArray[section];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    bgView.backgroundColor = kBackgroundColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, KScreenWidth - 60, 30)];
    label.text = dic[@"title"];
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor blackColor];
    [bgView addSubview:label];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 50, 5, 20, 20)];
    [deleteButton setImage:@"标签设置删除按钮图标"];
    deleteButton.tag = section;
    [deleteButton addTarget:self action:@selector(deleteSection:)];
    if (section != 1) {
        [bgView addSubview:deleteButton];
    }
    
    if (section == 0 || section == self.listDataArray.count - 1) {
        return nil;
    }
    return bgView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 50)];
    bgView.backgroundColor = kBackgroundColor;
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, KScreenWidth - 20, 40)];
    [button setBackgroundColor:KNaviColor];
    [button setTitleNormal:@"新增报销明细"];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [button setTitleColor:[UIColor blackColor]];
    button.layer.cornerRadius = 5.f;
    [button addTarget:self action:@selector(addDetail:)];
    [bgView addSubview:button];
    if (section == self.listDataArray.count - 1 - 1) {
        return bgView;
    } else if (section == self.listDataArray.count - 1) {
        return self.tableFootPhoto;
    }
    return nil;
}

#pragma mark - 点击新增明细
- (void)addDetail:(UIButton *)sender {
    NSMutableArray *section1Array = [NSMutableArray array];
    if ([self.typeStr isEqualToString:@"order"]) {
        [section1Array addObject:[@{@"id" : @"C_ID", @"title" : @"选择订单"} mutableCopy]];
    }
    [section1Array addObject:[@{@"id" : @"remark", @"title" : @"付款时间"} mutableCopy]];
    [section1Array addObject:[@{@"id" : @"amount", @"title" : @"报销金额"} mutableCopy]];
    [section1Array addObject:[@{@"id" : @"remark", @"title" : @"报销说明"} mutableCopy]];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"title"] = [NSString stringWithFormat:@"报销明细%ld",self.listDataArray.count - 1];
    dic[@"content"] = section1Array;
    [self.listDataArray insertObject:dic atIndex:self.listDataArray.count - 1];
    [self.tableView reloadData];
}

- (void)deleteSection:(UIButton *)sender {
    // 先把要删除的数据提前一个排序这样删除了这个排序后，后面的排序可以顺序排序，不会乱
    for (NSInteger i = sender.tag; i < self.listDataArray.count - 1; i++) {
        NSMutableDictionary *dic = self.listDataArray[i];
        dic[@"title"] = [NSString stringWithFormat:@"报销明细%ld",i - 1];
    }
    [self.listDataArray removeObjectAtIndex:sender.tag];
    [self.tableView reloadData];
}

- (void)submitButtonAction:(UIButton *)sender {
    
}

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavStatusHeight, KScreenWidth, KScreenHeight - NavStatusHeight - SafeAreaBottomHeight - WD_TabBarHeight - 44) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

- (NSMutableArray *)listDataArray {
    if (!_listDataArray) {
        _listDataArray = [NSMutableArray array];
        NSMutableArray *section0Array = [NSMutableArray array];
        [section0Array addObject:[@{@"id" : @"classificationId", @"title" : @"类别"} mutableCopy]];
        [_listDataArray addObject:@{@"title" : @"category", @"content" : section0Array}];
    
        NSMutableArray *section1Array = [NSMutableArray array];
        if ([self.typeStr isEqualToString:@"order"]) {
            [section1Array addObject:[@{@"id" : @"C_ID", @"title" : @"选择订单"} mutableCopy]];
        }
            [section1Array addObject:[@{@"id" : @"time", @"title" : @"付款时间"} mutableCopy]];
            [section1Array addObject:[@{@"id" : @"amount", @"title" : @"报销金额"} mutableCopy]];
            [section1Array addObject:[@{@"id" : @"remark", @"title" : @"报销说明"} mutableCopy]];
        [_listDataArray addObject:@{@"title" : @"报销明细1", @"content" : section1Array}];
        
        
        NSMutableArray *section2Array = [NSMutableArray array];
        [section2Array addObject:[@{@"id" : @"remark", @"title" : @"备注"} mutableCopy]];
        [_listDataArray addObject:@{@"title" : @"备注", @"content" : section2Array}];
    }
    return _listDataArray;
}

- (MJKPhotoView *)tableFootPhoto {
    DBSelf(weakSelf);
    if (!_tableFootPhoto) {
        _tableFootPhoto = [[MJKPhotoView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 165)];
        _tableFootPhoto.isEdit = YES;
        _tableFootPhoto.isCamera = NO;
        _tableFootPhoto.rootVC = self;
        _tableFootPhoto.backUrlArray = ^(NSArray *arr, NSArray *saveArr) {
//            weakSelf.imageUrlArray = arr;
        };
    }
    return _tableFootPhoto;
};

- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [[UIButton alloc]initWithFrame:CGRectMake(0, KScreenHeight - SafeAreaBottomHeight - 44, KScreenWidth, 44)];
        [_submitButton setTitleNormal:@"提交"];
        [_submitButton setTitleColor:[UIColor blackColor]];
        [_submitButton setBackgroundColor:KNaviColor];
        [_submitButton addTarget:self action:@selector(submitButtonAction:)];
    }
    return _submitButton;
}


@end
