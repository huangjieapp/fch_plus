//
//  MJKIntegralReportCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/24.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKSourceShowModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKIntegralReportCell : UITableViewCell
/** MJKSourceShowModel*/
@property (nonatomic, strong) MJKSourceShowModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** <#备注#>*/
@property (nonatomic, copy) void(^detailButtonBlock)(NSString *str);
@end

NS_ASSUME_NONNULL_END
