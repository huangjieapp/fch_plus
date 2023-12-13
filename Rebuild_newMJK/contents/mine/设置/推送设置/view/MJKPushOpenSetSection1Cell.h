//
//  MJKPushOpenSetSection1Cell.h
//  Rebuild_newMJK
//
//  Created by Hjie on 2018/10/17.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKPushDefaultListModel;
@class MJKClueListSubModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKPushOpenSetSection1Cell : UITableViewCell
/** MJKPushDefaultListModel*/
@property (nonatomic, strong) MJKPushDefaultListModel *model;
@property (nonatomic, strong) MJKClueListSubModel *jxModel;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
