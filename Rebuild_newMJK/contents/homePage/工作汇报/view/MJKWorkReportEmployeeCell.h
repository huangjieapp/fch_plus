//
//  MJKWorkReportEmployeeCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/3.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJKWorkReportListModel.h"

@interface MJKWorkReportEmployeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel;
/** <#备注#>*/
@property (nonatomic, strong) MJKWorkReportListModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
