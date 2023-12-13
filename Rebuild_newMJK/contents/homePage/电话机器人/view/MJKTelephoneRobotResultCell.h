//
//  MJKTelephoneRobotResultCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/2/21.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJKTelephoneRobotModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTelephoneRobotResultCell : UITableViewCell
/** MJKTelephoneRobotModel*/
@property (nonatomic, strong) MJKTelephoneRobotModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
