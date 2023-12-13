//
//  MJKGroupPeopleTableViewCell.m
//  Rebuild_newMJK
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import "MJKGroupPeopleTableViewCell.h"

@implementation MJKGroupPeopleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)buttonSelectClick:(UIButton *)sender {
    if (self.model != nil) {
        self.model.selected = !self.model.isSelected;
        if (self.model.isSelected == YES) {
            [self.selectButton setImage:[UIImage imageNamed:@"kuangselected"] forState:UIControlStateNormal];
        } else {
            [self.selectButton setImage:[UIImage imageNamed:@"kuang_off"] forState:UIControlStateNormal];
            NSArray *arr = [self.PKModel.X_OWNERROLEIDS componentsSeparatedByString:@","];
            for (NSString *userID in arr) {
                if ([userID isEqualToString:self.model.USER_ID]) {
                    self.model.checkFlag = @"false";
                }
            }
        }
    }
    if (self.workModel != nil) {
        self.workModel.selected = !self.workModel.isSelected;
        if (self.workModel.isSelected == YES) {
            [self.selectButton setImage:[UIImage imageNamed:@"kuangselected"] forState:UIControlStateNormal];
        } else {
            [self.selectButton setImage:[UIImage imageNamed:@"kuang_off"] forState:UIControlStateNormal];
        }
    }
}

- (void)setWorkModel:(MJKPKGroupPeopleModel *)workModel {
    _workModel = workModel;
    self.nameLabel.text = workModel.nickName;
    self.groupName.text = workModel.deptName;
    if (self.isDetail == YES) {
        NSArray *arr = [self.PKModel.X_OWNERROLEIDS componentsSeparatedByString:@","];
        for (NSString *userID in arr) {
            if ([userID isEqualToString:workModel.u051Id]) {
                workModel.selected = YES;
                [self.selectButton setImage:[UIImage imageNamed:@"kuangselected"] forState:UIControlStateNormal];
            }
        }
    }
    
    if (workModel.isSelected == YES) {
        [self.selectButton setImage:[UIImage imageNamed:@"kuangselected"] forState:UIControlStateNormal];
    } else {
        [self.selectButton setImage:[UIImage imageNamed:@"kuang_off"] forState:UIControlStateNormal];
    }
}

- (void)setModel:(MJKPKGroupPeopleModel *)model {
    _model = model;
    self.nameLabel.text = model.C_NAME;
    self.groupName.text = model.gourpName;
//    if (self.isDetail == YES) {
//        NSArray *arr = [self.PKModel.X_OWNERROLEIDS componentsSeparatedByString:@","];
//        for (NSString *userID in arr) {
//            if ([userID isEqualToString:model.USER_ID]) {
//                if ([model.checkFlag isEqualToString:@"true"]) {
//                    model.selected = YES;
//                    [self.selectButton setImage:[UIImage imageNamed:@"kuangselected"] forState:UIControlStateNormal];
//                } else {
//                    model.selected = NO;
//                    [self.selectButton setImage:[UIImage imageNamed:@"kuang_off"] forState:UIControlStateNormal];
//                }
//            }
//        }
//    }
    
    if (model.isSelected == YES) {
        [self.selectButton setImage:[UIImage imageNamed:@"kuangselected"] forState:UIControlStateNormal];
    } else {
        [self.selectButton setImage:[UIImage imageNamed:@"kuang_off"] forState:UIControlStateNormal];
    }
}

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"MJKGroupPeopleTableViewCell";
    MJKGroupPeopleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return cell;
    
}

@end
