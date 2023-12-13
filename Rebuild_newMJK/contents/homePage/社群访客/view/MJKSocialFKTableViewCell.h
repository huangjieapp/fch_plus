//
//  MJKSocialFKTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2019/8/13.
//  Copyright © 2019 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKSocialFKModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialFKTableViewCell : UITableViewCell
/** MJKSocialFKModel*/
@property (nonatomic, strong) MJKSocialFKModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
