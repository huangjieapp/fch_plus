//
//  MJKYesterdayWorkReportCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJKWorkReportListModel.h"

@interface MJKYesterdayWorkReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *noReportView;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayWorkLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayout;
/** <#备注#>*/
@property (nonatomic, strong) MJKWorkReportListModel *model;
/** nsindexPath*/
@property (nonatomic, strong) NSIndexPath *indexPath;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
