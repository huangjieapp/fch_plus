//
//  MJKStatementsMonthCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/8.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKMonthStatementsModel.h"
#import "MJKMonthStatementsContentModel.h"

@interface MJKStatementsMonthCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDeliveryLabel;
@property (weak, nonatomic) IBOutlet UILabel *vacationLabel;
- (void)updateCellWithModel:(MJKMonthStatementsModel *)model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
