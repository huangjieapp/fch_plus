//
//  MJKTaskWorkListCell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/9/30.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKTaskWorkListModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKTaskWorkListCell : UITableViewCell
/** MJKTaskWorkListModel*/
@property (nonatomic, strong) MJKTaskWorkListModel *listModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
