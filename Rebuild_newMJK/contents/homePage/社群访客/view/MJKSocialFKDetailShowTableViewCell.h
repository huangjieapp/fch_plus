//
//  MJKSocialFKDetailShowTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2020/1/21.
//  Copyright © 2020 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKSocialFKModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKSocialFKDetailShowTableViewCell : UITableViewCell
/** <#注释#>*/
@property (nonatomic, strong) MJKSocialFKModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
