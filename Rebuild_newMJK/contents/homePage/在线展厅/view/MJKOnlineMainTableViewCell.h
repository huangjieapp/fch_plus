//
//  MJKOnlineMainTableViewCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2017/9/19.
//  Copyright © 2017年 月见黑. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKOnlineMainHallSubModel.h"

@interface MJKOnlineMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eyesLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (nonatomic, strong) MJKOnlineMainHallSubModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
