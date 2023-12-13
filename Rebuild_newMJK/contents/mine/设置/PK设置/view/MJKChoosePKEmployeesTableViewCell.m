//
//  MJKChooseEmployeesTableViewCell.m
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/5/5.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import "MJKChoosePKEmployeesTableViewCell.h"
#import "MJKChooseEmployeesModel.h"
#import "MJKChooseEmployeesSubModel.h"
#import "MJKClueListSubModel.h"
#import "MJKGroupPeopleTableViewCell.h"
#import "MJKPKGroupPeopleModel.h"
#import "MJKPKModel.h"

#import "MJKClueMarketTableViewCell.h"

@interface MJKChoosePKEmployeesTableViewCell ()<UITableViewDataSource, UITableViewDelegate>
/** tableView*/
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MJKChoosePKEmployeesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(MJKChooseEmployeesModel *)model {
    _model = model;
    self.titleLabel.text = model.isSelected == YES ? [NSString stringWithFormat:@"∨%@",model.storeName] : [NSString stringWithFormat:@"＞%@",model.storeName];
    if (model.isSelected == YES) {
        [self.contentView addSubview:self.tableView];
    } else {
        [self.tableView removeFromSuperview];
    }
}

//- (void)setPKModel:(MJKPKModel *)PKModel {
//    _PKModel = PKModel;
//    [self.tableView reloadData];
//}

#pragma mark - UITableViewDataSource, UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DBSelf(weakSelf);
    MJKPKGroupPeopleModel *subModel = self.model.userList[indexPath.row];
    MJKGroupPeopleTableViewCell *cell = [MJKGroupPeopleTableViewCell cellWithTableView:tableView];
//    if (self.C_ID.length > 0) {
//        cell.isDetail = YES;
//        cell.PKModel = self.PKModel;
//    }
    cell.model = subModel;
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

#pragma mark - set
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, KScreenWidth, self.model.userList.count * 44) style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.tableFooterView = [[UIView alloc]init];
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

+ (CGFloat)cellForHeight:(MJKChooseEmployeesModel *)model {
    if (model.isSelected == YES) {
        return 44 + model.userList.count * 44;
    } else {
        return 44;
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKChoosePKEmployeesTableViewCell";
    MJKChoosePKEmployeesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
