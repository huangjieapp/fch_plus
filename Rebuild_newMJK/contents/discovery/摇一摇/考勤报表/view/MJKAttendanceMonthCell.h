//
//  MJKAttendanceMonthCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKMonthStatementsModel.h"

@interface MJKAttendanceMonthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *normalLabel;
/** MJKMonthStatementsModel*/
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addressRightLayout;
@property (nonatomic, strong) MJKMonthStatementsModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *countLabelArray;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabelArray;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
