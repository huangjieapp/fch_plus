//
//  MJKAttendanceCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/11.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKAttendanceModel.h"

@interface MJKAttendanceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
/** model*/
@property (nonatomic, strong) MJKAttendanceModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
