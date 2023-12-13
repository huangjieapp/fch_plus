//
//  MJKOrganizationalTableViewCell.h
//  Rebuild_newMJK
//
//  Created by 黄杰 on 2018/12/18.
//  Copyright © 2018 脉居客. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MJKOrganizationalModel;

NS_ASSUME_NONNULL_BEGIN

@interface MJKOrganizationalTableViewCell : UITableViewCell
/** <#备注#>*/
@property (nonatomic, copy) void(^buttonBlock)(void);
/** <#备注#>*/
@property (nonatomic, copy) void(^selectButtonBlock)(void);

/** MJKOrganizationalModel*/
@property (nonatomic, strong) MJKOrganizationalModel *model;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end

NS_ASSUME_NONNULL_END
