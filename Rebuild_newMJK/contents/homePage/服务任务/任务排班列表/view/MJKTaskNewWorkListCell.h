//
//  MJKTaskNewWorkListCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/1/14.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKTaskWorkListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskNewWorkListCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
/** MJKTaskWorkListModel*/
@property (nonatomic, strong) MJKTaskWorkListModel *model;
@end

NS_ASSUME_NONNULL_END
