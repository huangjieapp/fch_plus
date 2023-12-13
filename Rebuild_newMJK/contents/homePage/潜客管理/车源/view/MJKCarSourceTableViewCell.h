//
//  MJKCarSourceTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/16.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCarSourceSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCarSourceTableViewCell : UITableViewCell
/** MJKCarSourceSubModel*/
@property (nonatomic, strong) MJKCarSourceSubModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
