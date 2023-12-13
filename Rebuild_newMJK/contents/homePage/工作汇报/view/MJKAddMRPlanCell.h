//
//  MJKAddMRPlanCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/23.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKWorkReportDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKAddMRPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *completeLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelLayout;
/** 今日*/
@property (weak, nonatomic) IBOutlet UILabel *todayWorkLabel;
@property (nonatomic, strong) MJKWorkReportDetailModel *model;
@property (weak, nonatomic) IBOutlet UIButton *minButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextField *countTF;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
