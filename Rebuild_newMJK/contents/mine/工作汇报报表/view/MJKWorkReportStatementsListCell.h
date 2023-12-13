//
//  MJKWorkReportStatementsListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/8/7.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKWorkReportStatementsListModel.h"

@interface MJKWorkReportStatementsListCell : UITableViewCell
/** MJKWorkReportStatementsListModel*/
@property (nonatomic, strong) MJKWorkReportStatementsListModel *model;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
