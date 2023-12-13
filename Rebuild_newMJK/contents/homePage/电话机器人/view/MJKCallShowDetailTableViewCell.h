//
//  MJKCallShowDetailTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/3/28.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKCallShowDetailModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKCallShowDetailTableViewCell : UITableViewCell
/** MJKCallShowDetailModel*/
@property (nonatomic, strong) MJKCallShowDetailModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
