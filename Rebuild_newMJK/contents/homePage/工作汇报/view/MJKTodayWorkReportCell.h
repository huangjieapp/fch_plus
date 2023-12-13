//
//  MJKTodayWorkReportCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/7/4.
//  Copyright © 2018年 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKWorkReportDetailModel;

@interface MJKTodayWorkReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLayout;
/** 今日*/
@property (weak, nonatomic) IBOutlet UILabel *todayWorkLabel;
@property (nonatomic, strong) MJKWorkReportDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
