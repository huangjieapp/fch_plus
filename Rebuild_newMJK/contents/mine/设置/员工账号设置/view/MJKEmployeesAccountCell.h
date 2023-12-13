//
//  MJKEmployeesAccountCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKEmployeesAccountModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKEmployeesAccountCell : UITableViewCell
/** MJKEmployeesAccountModel*/
@property (nonatomic, strong) MJKEmployeesAccountModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
